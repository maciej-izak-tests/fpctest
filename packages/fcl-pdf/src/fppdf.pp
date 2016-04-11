{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 2014 by Michael Van Canneyt

    This unit generates PDF files, without dependencies on GUI libraries.
    (Based on original ideas from the fpGUI pdf generator by Jean-Marc Levecque
     <jmarc.levecque@jmlesite.web4me.fr>)

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit fppdf;

{$mode objfpc}{$H+}

{ enable compiler define for extra console debug output }
{.$define gdebug}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  contnrs,
  fpImage,
  zstream,
  fpparsettf;

Const
  clBlack = $000000;
  clBlue  = $0000FF;
  clGreen = $00FF00;
  clRed   = $FF0000;

type
  TPDFPaperType = (ptCustom, ptA4, ptA5, ptLetter, ptLegal, ptExecutive, ptComm10, ptMonarch, ptDL, ptC5, ptB5);
  TPDFPaperOrientation = (ppoPortrait,ppoLandscape);
  TPDFPenStyle = (ppsSolid,ppsDash,ppsDot,ppsDashDot,ppsDashDotDot);
  TPDFPageLayout = (lSingle, lTwo, lContinuous);
  TPDFUnitOfMeasure = (uomInches, uomMillimeters, uomCentimeters, uomPixels);

  TPDFOption = (poOutLine, poCompressText, poCompressFonts);
  TPDFOptions = set of TPDFOption;

  EPDF = Class(Exception);
  TPDFDocument = Class;
  TARGBColor = Cardinal;
  TPDFFloat = Single;


  TPDFDimensions = record
    T,L,R,B: TPDFFloat;
  end;


  TPDFPaper = record
    H, W: integer;
    Printable: TPDFDimensions;
  end;


  TPDFCoord = record
    X,Y: TPDFFloat;
  end;


  TPDFCoordArray = array of TPDFCoord;

  { We use a special 3x3 matrix for transformations of coordinates. As the
    only allowed transformations are translations and scalations, we need a
    matrix with the following content ([x,y] is a variable):
        [0,0]   0   [2,0]
          0   [1,1] [2,1]
          0     0     1
    [0,0]: X scalation
    [2,0]: X translation
    [1,1]: Y scalation
    [2,1]: Y translation
  }
  TPDFMatrix = object
    _00, _20, _11, _21: TPDFFloat;
    function Transform(APoint: TPDFCoord): TPDFCoord; overload;
    function Transform(X, Y: TPDFFloat): TPDFCoord; overload;
    function ReverseTransform(APoint: TPDFCoord): TPDFCoord;
    procedure SetXScalation(const AValue: TPDFFloat);
    procedure SetYScalation(const AValue: TPDFFloat);
    procedure SetXTranslation(const AValue: TPDFFloat);
    procedure SetYTranslation(const AValue: TPDFFloat);
  end;


  TPDFObject = class(TObject)
  Protected
    Class Function FloatStr(F: TPDFFloat) : String;
    procedure Write(const AStream: TStream); virtual;
    Class procedure WriteString(const AValue: string; AStream: TStream);
  public
    Constructor Create(Const ADocument : TPDFDocument); virtual; overload;
  end;


  TPDFDocumentObject = Class(TPDFObject)
  Private
    FDocument : TPDFDocument;
  Public
    Constructor Create(Const ADocument : TPDFDocument); override; overload;
    Procedure SetWidth(AWidth : TPDFFloat; AStream : TStream);
    Property Document : TPDFDocument Read FDocument ;
  end;


  TPDFBoolean = class(TPDFObject)
  private
    FValue: Boolean;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AValue: Boolean);overload;
  end;


  TPDFMoveTo = class(TPDFObject)
  private
    FPos : TPDFCoord;
  protected
    procedure Write(const AStream: TStream); override;
  public
    class function Command(APos: TPDFCoord): String;
    class function Command(AX,AY: TPDFFloat): String;
    constructor Create(Const ADocument : TPDFDocument; const AX,AY : TPDFFloat);overload;
    constructor Create(Const ADocument : TPDFDocument; const APos : TPDFCoord);overload;
  end;


  TPDFInteger = class(TPDFObject)
  private
    FInt: integer;
  protected
    procedure Inc;
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AValue: integer);overload;
    property Value: integer read FInt write FInt;
  end;


  TPDFReference = class(TPDFObject)
  private
    FValue: integer;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; Const AValue: integer);overload;
    property Value: integer read FValue write FValue;
  end;


  TPDFName = class(TPDFObject)
  private
    FName : string;
    function  ConvertCharsToHex: string;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AValue: string); overload;
    property Name : String read FName;
  end;


  TPDFAbstractString = class(TPDFDocumentObject)
  protected
    FFontIndex: integer;
    // These symbols must be preceded by a backslash:  "(", ")", "\"
    function InsertEscape(const AValue: string): string;
  public
    property FontIndex: integer read FFontIndex;
  end;


  TPDFString = class(TPDFAbstractString)
  private
    FValue: string;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AValue: string); overload;
  end;


  TPDFUTF8String = class(TPDFAbstractString)
  private
    FValue: UTF8String;
    { Remap each character to the equivalant dictionary character code }
    function RemapedText: AnsiString;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AValue: UTF8String; const AFontIndex: integer); overload;
  end;


  TPDFArray = class(TPDFDocumentObject)
  private
    FArray: TFPObjectList;
  protected
    procedure Write(const AStream: TStream); override;
    procedure AddItem(const AValue: TPDFObject);
    // Add integers in S as TPDFInteger elements to the array
    Procedure AddIntArray(S : String);
  public
    constructor Create(Const ADocument : TPDFDocument); override;
    destructor Destroy; override;
  end;


  TPDFStream = class(TPDFObject)
  private
    FItems: TFPObjectList;
  protected
    procedure Write(const AStream: TStream); override;
    procedure AddItem(const AValue: TPDFObject);
  public
    constructor Create(Const ADocument : TPDFDocument; OwnsObjects : Boolean = True); overload;
    destructor Destroy; override;
  end;


  TPDFEmbeddedFont = class(TPDFObject)
  private
    FTxtFont: integer;
    FTxtSize: string;
  protected
    procedure Write(const AStream: TStream); override;
    Class function WriteEmbeddedFont(const ADocument: TPDFDocument; const Src: TMemoryStream; const AStream: TStream): int64;
  public
    constructor Create(Const ADocument : TPDFDocument;const AFont: integer; const ASize: string); overload;
  end;


  TPDFText = class(TPDFObject)
  private
    FX: TPDFFloat;
    FY: TPDFFloat;
    FString: TPDFString;
    FFontIndex: integer;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AX, AY: TPDFFloat; const AText: AnsiString; const AFontIndex: integer); overload;
    destructor Destroy; override;
    Property X : TPDFFloat Read FX Write FX;
    Property Y : TPDFFloat Read FY Write FY;
    Property Text : TPDFString Read FString;
    property FontIndex: integer read FFontIndex;
  end;


  TPDFUTF8Text = class(TPDFObject)
  private
    FX: TPDFFloat;
    FY: TPDFFloat;
    FString: TPDFUTF8String;
    FFontIndex: integer;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AX, AY: TPDFFloat; const AText: UTF8String; const AFontIndex: integer); overload;
    destructor Destroy; override;
    Property X : TPDFFloat Read FX Write FX;
    Property Y : TPDFFloat Read FY Write FY;
    Property Text : TPDFUTF8String Read FString;
    property FontIndex: integer read FFontIndex;
  end;


  TPDFLineSegment = class(TPDFDocumentObject)
  private
    FWidth: TPDFFloat;
    P1, p2: TPDFCoord;
  protected
    procedure Write(const AStream: TStream); override;
  public
    Class Function Command(APos : TPDFCoord) : String;
    Class Function Command(APos1,APos2 : TPDFCoord) : String;
    constructor Create(Const ADocument : TPDFDocument; const AWidth, X1,Y1, X2,Y2: TPDFFloat);overload;
  end;


  TPDFRectangle = class(TPDFDocumentObject)
  private
    FWidth: TPDFFloat;
    FTopLeft: TPDFCoord;
    FDimensions: TPDFCoord;
    FFill: Boolean;
    FStroke: Boolean;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(const ADocument: TPDFDocument; const APosX, APosY, AWidth, AHeight, ALineWidth: TPDFFloat; const AFill, AStroke: Boolean);overload;
  end;


  TPDFCurveC = class(TPDFDocumentObject)
  private
    FP1,FP2,FP3: TPDFCoord;
    FWidth: TPDFFloat;
    FStroke: Boolean;
  protected
    Class Function Command(Const X1,Y1,X2,Y2,X3,Y3 : TPDFFloat) : String; overload;
    Class Function Command(Const AP1,AP2,AP3: TPDFCoord) : String; overload;
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const X1,Y1,X2,Y2,X3,Y3,AWidth : TPDFFloat;AStroke: Boolean = True);overload;
    constructor Create(Const ADocument : TPDFDocument; const AP1,AP2,AP3 : TPDFCoord; AWidth: TPDFFloat; AStroke: Boolean = True);overload;
  end;


  TPDFCurveV = class(TPDFDocumentObject)
  private
    FP2,FP3: TPDFCoord;
    FWidth: TPDFFloat;
    FStroke : Boolean;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const X2,Y2,X3,Y3,AWidth : TPDFFloat;AStroke: Boolean = True);overload;
    constructor Create(Const ADocument : TPDFDocument; const AP2,AP3 : TPDFCoord; AWidth: TPDFFloat;AStroke: Boolean = True);overload;
  end;


  TPDFCurveY = class(TPDFDocumentObject)
  private
    FP1,FP3: TPDFCoord;
    FWidth: TPDFFloat;
    FStroke : Boolean;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const X1,Y1,X3,Y3,AWidth : TPDFFloat;AStroke: Boolean = True);overload;
    constructor Create(Const ADocument : TPDFDocument; const AP1,AP3 : TPDFCoord; AWidth: TPDFFloat;AStroke: Boolean = True);overload;
  end;


  TPDFEllipse = class(TPDFDocumentObject)
  private
    FCenter,
    FDimensions: TPDFCoord;
    FFill : Boolean;
    FStroke : Boolean;
    FLineWidth : TPDFFloat;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const APosX, APosY, AWidth, AHeight, ALineWidth: TPDFFloat; const AFill : Boolean = True; AStroke: Boolean = True);overload;
  end;


  TPDFSurface = class(TPDFObject)
  private
    FPoints: TPDFCoordArray;
    FFill : Boolean;
    FClose : Boolean;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const APoints: TPDFCoordArray; AClose : Boolean; AFill : Boolean = True); overload;
  end;


  TPDFImage = class(TPDFDocumentObject)
  private
    FNumber: integer;
    FPos: TPDFCoord;
    FWidth: integer;
    FHeight: integer;
  protected
    procedure Write(const AStream: TStream); override;
  public
    constructor Create(Const ADocument : TPDFDocument; const ALeft, ABottom: TPDFFloat; AWidth, AHeight, ANumber: integer); overload;
  end;


  TPDFLineStyle = class(TPDFObject)
  private
    FStyle: TPDFPenStyle;
    FPhase: integer;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(Const ADocument : TPDFDocument; AStyle: TPDFPenStyle; APhase: integer); overload;
  end;


  TPDFColor = class(TPDFDocumentObject)
  private
    FRed: string;
    FGreen: string;
    FBlue: string;
    FStroke: Boolean;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AStroke: Boolean; AColor: TARGBColor); overload;
  end;


  TPDFDictionaryItem = class(TPDFObject)
  private
    FKey: TPDFName;
    FObj: TPDFObject;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(Const ADocument : TPDFDocument; const AKey: string; const AValue: TPDFObject);
    destructor Destroy; override;
    Property Value : TPDFObject Read FObj;
  end;


  TPDFDictionary = class(TPDFDocumentObject)
  private
    FElements: TFPObjectList; // list of TPDFDictionaryItem
    function GetE(AIndex : Integer): TPDFDictionaryItem;
    function GetEC: Integer;
    function GetV(AIndex : Integer): TPDFObject;
  protected
    procedure AddElement(const AKey: string; const AValue: TPDFObject);
    procedure AddName(const AKey,AName : String);
    procedure AddInteger(const AKey : String; AInteger : Integer);
    procedure AddReference(const AKey : String; AReference : Integer);
    procedure AddString(const AKey, AString : String);
    function IndexOfKey(const AValue: string): integer;
    procedure Write(const AStream: TStream); override;
    procedure WriteDictionary(const AObject: integer; const AStream: TStream);
  public
    constructor Create(Const ADocument : TPDFDocument); override;
    destructor Destroy; override;
    Function LastElement : TPDFDictionaryItem;
    Function LastValue : TPDFObject;
    Function FindElement(Const AKey : String) : TPDFDictionaryItem;
    Function FindValue(Const AKey : String) : TPDFObject;
    Function ElementByName(Const AKey : String) : TPDFDictionaryItem;
    Function ValueByName(Const AKey : String) : TPDFObject;
    Property Elements[AIndex : Integer] : TPDFDictionaryItem Read GetE;
    Property Values[AIndex : Integer] : TPDFObject Read GetV;
    Property ElementCount : Integer Read GetEC;
  end;


  TPDFXRef = class(TPDFObject)
  private
    FOffset: integer;
    FDict: TPDFDictionary;
    FStream: TPDFStream;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(Const ADocument : TPDFDocument); override;
    destructor Destroy; override;
    property Offset: integer read FOffset write FOffset;
    Property Dict : TPDFDictionary Read FDict;
  end;


  TPDFInfos = Class(TPersistent)
  private
    FApplicationName: String;
    FAuthor: String;
    FCreationDate: TDateTime;
    FProducer: String;
    FTitle: String;
  public
    constructor Create; virtual;
    Property Author : String Read FAuthor Write FAuthor;
    Property Title : String Read FTitle Write FTitle;
    Property ApplicationName : String Read FApplicationName Write FApplicationName;
    Property Producer : String Read FProducer Write FProducer;
    Property CreationDate : TDateTime Read FCreationDate Write FCreationDate;
  end;


  { When the WriteXXX() and DrawXXX() methods specify coordinates, they do it as
    per the PDF specification, from the bottom-left. }
  TPDFPage = Class(TPDFDocumentObject)
  private
    FObjects : TObjectList;
    FOrientation: TPDFPaperOrientation;
    FPaper: TPDFPaper;
    FPaperType: TPDFPaperType;
    FFontIndex: integer;
    FUnitOfMeasure: TPDFUnitOfMeasure;
    FMatrix: TPDFMatrix;
    procedure CalcPaperSize;
    function GetO(AIndex : Integer): TPDFObject;
    function GetObjectCount: Integer;
    procedure SetOrientation(AValue: TPDFPaperOrientation);
    procedure SetPaperType(AValue: TPDFPaperType);
    procedure AddTextToLookupLists(AText: UTF8String);
    procedure SetUnitOfMeasure(AValue: TPDFUnitOfMeasure);
    procedure AdjustMatrix;
  protected
    procedure DoUnitConversion(var APoint: TPDFCoord); virtual;
    procedure CreateStdFontText(X, Y: TPDFFloat; AText: AnsiString; AFontIndex: integer); virtual;
    procedure CreateTTFFontText(X, Y: TPDFFloat; AText: UTF8String; AFontIndex: integer); virtual;
  Public
    Constructor Create(Const ADocument : TPDFDocument); override;
    Destructor Destroy; override;
    Procedure AddObject(AObject : TPDFObject);
    // Commands. These will create objects in the objects list of the page.
    Procedure SetFont(AFontIndex : Integer; AFontSize : Integer);
    // used for stroking and nonstroking colors - purpose determined by the AStroke parameter
    Procedure SetColor(AColor : TARGBColor; AStroke : Boolean = True);
    Procedure SetPenStyle(AStyle : TPDFPenStyle);
    { output coordinate is the font baseline. }
    Procedure WriteText(X, Y: TPDFFloat; AText : UTF8String); overload;
    Procedure WriteText(APos: TPDFCoord; AText : UTF8String); overload;
    procedure DrawLine(X1, Y1, X2, Y2, ALineWidth : TPDFFloat); overload;
    procedure DrawLine(APos1: TPDFCoord; APos2: TPDFCoord; ALineWidth: TPDFFloat); overload;
    Procedure DrawLineStyle(X1, Y1, X2, Y2: TPDFFloat; AStyle: Integer); overload;
    Procedure DrawLineStyle(APos1: TPDFCoord; APos2: TPDFCoord; AStyle: Integer); overload;
    { X, Y coordinates are the bottom-left coordinate of the rectangle. The W and H parameters are in the UnitOfMeasure units. }
    Procedure DrawRect(const X, Y, W, H, ALineWidth: TPDFFloat; const AFill, AStroke : Boolean); overload;
    Procedure DrawRect(const APos: TPDFCoord; const W, H, ALineWidth: TPDFFloat; const AFill, AStroke : Boolean); overload;
    { X, Y coordinates are the bottom-left coordinate of the image. AWidth and AHeight are in image pixels. }
    Procedure DrawImage(const X, Y: TPDFFloat; const AWidth, AHeight, ANumber: integer); overload;
    Procedure DrawImage(const APos: TPDFCoord; const AWidth, AHeight, ANumber: integer); overload;
    { X, Y coordinates are the bottom-left coordinate of the boundry rectangle.
      The W and H parameters are in the UnitOfMeasure units. A negative AWidth will
      cause the ellpise to draw to the left of the origin point. }
    Procedure DrawEllipse(const APosX, APosY, AWidth, AHeight, ALineWidth: TPDFFloat; const AFill: Boolean = True; AStroke: Boolean = True); overload;
    Procedure DrawEllipse(const APos: TPDFCoord; const AWidth, AHeight, ALineWidth: TPDFFloat; const AFill: Boolean = True; AStroke: Boolean = True); overload;
    { This returns the paper height, converted to whatever UnitOfMeasure is set too }
    function GetPaperHeight: TPDFFloat;
    Function HasImages : Boolean;
    // Quick settings for Paper.
    Property PaperType : TPDFPaperType Read FPaperType Write SetPaperType default ptA4;
    Property Orientation : TPDFPaperOrientation Read FOrientation Write SetOrientation;
    // Set this if you want custom paper size.
    Property Paper : TPDFPaper Read FPaper Write FPaper;
    // Unit of Measure - how the PDF Page should convert the coordinates and dimensions
    property UnitOfMeasure: TPDFUnitOfMeasure read FUnitOfMeasure write SetUnitOfMeasure default uomMillimeters;
    Property ObjectCount: Integer Read GetObjectCount;
    Property Objects[AIndex : Integer] : TPDFObject Read GetO; default;
    // returns the last used FontIndex used in SetFont()
    property FontIndex: integer read FFontIndex;
    { A 3x3 matrix used to translate the PDF Cartesian coordinate system to an Image coordinate system. }
    property Matrix: TPDFMatrix read FMatrix write FMatrix;
  end;


  TPDFSection = Class(TCollectionItem)
  private
    FTitle: String;
    FPages : TFPList; // not owned
    function GetP(AIndex : Integer): TPDFPage;
    function GetP: Integer;
  Public
    Destructor Destroy; override;
    Procedure AddPage(APage : TPDFPage);
    Property Title : String Read FTitle Write FTitle;
    Property Pages[AIndex : Integer] : TPDFPage Read GetP;
    Property PageCount : Integer Read GetP;
  end;


  TPDFSectionList = Class(TCollection)
  private
    function GetS(AIndex : Integer): TPDFSection;
  Public
    Function AddSection : TPDFSection;
    Property Section[AIndex : Integer] : TPDFSection Read GetS; Default;
  end;


  // forward declarations
  TTextMapping = class;


  TTextMappingList = class(TObject)
  private
    FList: TFPObjectList;
    function    GetCount: Integer;
  protected
    function    GetItem(AIndex: Integer): TTextMapping; reintroduce;
    procedure   SetItem(AIndex: Integer; AValue: TTextMapping); reintroduce;
  public
    constructor Create;
    destructor  Destroy; override;
    function    Add(AObject: TTextMapping): Integer; overload;
    function    Add(const ACharID, AGlyphID: uint16): Integer; overload;
    property    Count: Integer read GetCount;
    property    Items[Index: Integer]: TTextMapping read GetItem write SetItem; default;
  end;


  TTextMapping = class(TObject)
  private
    FCharID: uint16;
    FGlyphID: uint16;
  public
    class function NewTextMap(const ACharID, AGlyphID: uint16): TTextMapping;
    property    CharID: uint16 read FCharID write FCharID;
    property    GlyphID: uint16 read FGlyphID write FGlyphID;
  end;


  TPDFFont = CLass(TCollectionItem)
  private
    FColor: TARGBColor;
    FIsStdFont: boolean;
    FName: String;
    FFontFilename: String;
    FTrueTypeFile: TTFFileInfo;
    { stores mapping of Char IDs to font Glyph IDs }
    FTextMappingList: TTextMappingList;
    procedure   PrepareTextMapping;
    procedure   SetFontFilename(AValue: string);
  public
    destructor  Destroy; override;
    { Returns a string where each character is replaced with a glyph index value instead. }
    function    GetGlyphIndices(const AText: UnicodeString): AnsiString;
    procedure   AddTextToMappingList(const AText: UnicodeString);
    Property    FontFile: string read FFontFilename write SetFontFilename;
    Property    Name: String Read FName Write FName;
    Property    Color: TARGBColor Read FColor Write FColor;
    property    TextMapping: TTextMappingList read FTextMappingList;
    property    IsStdFont: boolean read FIsStdFont write FIsStdFont;
  end;


  TPDFTrueTypeCharWidths = class(TPDFDocumentObject)
  private
    FEmbeddedFontNum: integer;
    FFontIndex: integer;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(const ADocument: TPDFDocument; const AEmbeddedFontNum: integer); overload;
    property EmbeddedFontNum: integer read FEmbeddedFontNum;
    property FontIndex: integer read FFontIndex write FFontIndex;
  end;


  TPDFFontDefs = Class(TCollection)
  private
    function GetF(AIndex : Integer): TPDFFont;
  Public
    Function AddFontDef : TPDFFont;
    Property FontDefs[AIndex : Integer] : TPDFFont Read GetF; Default;
  end;


  TPDFPages = Class(TPDFDocumentObject)
  private
    FList : TFPObjectList;
    function GetP(AIndex : Integer): TPDFPage;
  public
    Destructor Destroy; override;
    Function AddPage : TPDFPage;
    procedure Add(APage: TPDFPage);
    Property Pages[AIndex : Integer] : TPDFPage Read GetP; Default;
  end;


  TPDFImageItem = Class(TCollectionItem)
  private
    FImage: TFPCustomImage;
    FOwnsImage: Boolean;
    FStreamed: TBytes;
    FWidth,FHeight : Integer;
    function GetHeight: Integer;
    function GetStreamed: TBytes;
    function GetWidth: Integer;
    procedure SetImage(AValue: TFPCustomImage);
    procedure SetStreamed(AValue: TBytes);
  Public
    Destructor Destroy; override;
    Procedure CreateStreamedData;
    Function WriteImageStream(AStream: TStream): int64; virtual;
    function Equals(AImage: TFPCustomImage): boolean; reintroduce;
    Property Image : TFPCustomImage Read FImage Write SetImage;
    Property StreamedData : TBytes Read GetStreamed Write SetStreamed;
    Property OwnsImage : Boolean Read FOwnsImage Write FOwnsImage;
    Property Width : Integer Read GetWidth;
    Property Height : Integer Read GetHeight;
  end;


  TPDFImages = CLass(TCollection)
  private
    function GetI(AIndex : Integer): TPDFImageItem;
  Public
    Function AddImageItem : TPDFImageItem;
    Function AddFromFile(Const AFileName : String; KeepImage : Boolean = False): Integer;
    Property Images[AIndex : Integer] : TPDFImageItem Read GetI; default;
  end;


  TPDFToUnicode = class(TPDFDocumentObject)
  private
    FEmbeddedFontNum: integer;
  protected
    procedure Write(const AStream: TStream);override;
  public
    constructor Create(const ADocument: TPDFDocument; const AEmbeddedFontNum: integer); overload;
    property EmbeddedFontNum: integer read FEmbeddedFontNum;
  end;


  TPDFLineStyleDef = Class(TCollectionItem)
  private
    FColor: TARGBColor;
    FLineWidth: TPDFFloat;
    FPenStyle: TPDFPenStyle;
  Published
    Property LineWidth : TPDFFloat Read FLineWidth Write FLineWidth;
    Property Color : TARGBColor Read FColor Write FColor Default clBlack;
    Property PenStyle : TPDFPenStyle Read FPenStyle Write FPenStyle Default ppsSolid;
  end;


  TPDFLineStyleDefs = Class(TCollection)
  private
    function GetI(AIndex : Integer): TPDFLineStyleDef;
  Public
    Function AddLineStyleDef : TPDFLineStyleDef;
    Property Defs[AIndex : Integer] : TPDFLineStyleDef Read GetI; Default;
  end;


  TPDFDocument = class(TComponent)
  private
    FCatalogue: integer;
    FCurrentColor: string;
    FCurrentWidth: string;
    FDefaultOrientation: TPDFPaperOrientation;
    FDefaultPaperType: TPDFPaperTYpe;
    FFontDirectory: string;
    FFontFiles: TStrings;
    FFonts: TPDFFontDefs;
    FImages: TPDFImages;
    FInfos: TPDFInfos;
    FLineStyleDefs: TPDFLineStyleDefs;
    FObjectCount: Integer;
    FOptions: TPDFOptions;
    FPages: TPDFPages;
    FPreferences: Boolean;
    FPageLayout: TPDFPageLayout;
    FSections: TPDFSectionList;
    FTrailer: TPDFDictionary;
    FZoomValue: string;
    FGlobalXRefs: TFPObjectList; // list of TPDFXRef
    function GetX(AIndex : Integer): TPDFXRef;
    function GetXC: Integer;
    procedure SetFontFiles(AValue: TStrings);
    procedure SetFonts(AValue: TPDFFontDefs);
    procedure SetInfos(AValue: TPDFInfos);
    procedure SetLineStyles(AValue: TPDFLineStyleDefs);
  protected
    // Returns next prevoutline
    function CreateSectionOutLine(Const SectionIndex,OutLineRoot,ParentOutLine,NextSect,PrevSect : Integer): Integer; virtual;
    Function CreateSectionsOutLine : Integer; virtual;
    Function CreateSectionPageOutLine(Const S: TPDFSection; Const PageOutLine, PageIndex, NewPage,  ParentOutline, NextOutline, PrevOutLine : Integer) : Integer;virtual;
    procedure AddFontNameToPages(const AName: String; ANum : Integer);
    procedure WriteXRefTable(const AStream: TStream);
    procedure WriteObject(const AObject: integer; const AStream: TStream);
    procedure CreateRefTable;virtual;
    procedure CreateTrailer;virtual;
    procedure CreateFontEntries; virtual;
    procedure CreateImageEntries; virtual;
    function CreateContentsEntry: integer;virtual;
    function CreateCatalogEntry: integer;virtual;
    procedure CreateInfoEntry;virtual;
    procedure CreatePreferencesEntry;virtual;
    function CreatePagesEntry(Parent: integer): integer;virtual;
    function CreatePageEntry(Parent, PageNum: integer): integer;virtual;
    function CreateOutlines: integer;virtual;
    function CreateOutlineEntry(Parent, SectNo, PageNo: integer; ATitle: string): integer;virtual;
    function LoadFont(AFont: TPDFFont): boolean;
    procedure CreateStdFont(EmbeddedFontName: string; EmbeddedFontNum: integer);virtual;
    procedure CreateTTFFont(const EmbeddedFontNum: integer);virtual;
    procedure CreateTTFDescendantFont(const EmbeddedFontNum: integer);virtual;
    procedure CreateTTFCIDSystemInfo;virtual;
    procedure CreateTp1Font(const EmbeddedFontNum: integer);virtual;
    procedure CreateFontDescriptor(const EmbeddedFontNum: integer);virtual;
    procedure CreateToUnicode(const EmbeddedFontNum: integer);virtual;
    procedure CreateFontFileEntry(const EmbeddedFontNum: integer);virtual;
    procedure CreateImageEntry(ImgWidth, ImgHeight, NumImg: integer);virtual;
    procedure CreatePageStream(APage : TPDFPage; PageNum: integer);
    Function CreateString(Const AValue : String) : TPDFString;
    Function CreateUTF8String(Const AValue : UTF8String; const AFontIndex: integer) : TPDFUTF8String;
    Function CreateGlobalXRef: TPDFXRef;
    Function AddGlobalXRef(AXRef : TPDFXRef) : Integer;
    function IndexOfGlobalXRef(const AValue: string): integer;
    Function FindGlobalXRef(Const AName : String) : TPDFXRef;
    Function GlobalXRefByName(Const AName : String) : TPDFXRef;
    Property GlobalXRefs[AIndex : Integer] : TPDFXRef Read GetX;
    Property GlobalXRefCount : Integer Read GetXC;
    Property CurrentColor: string Read FCurrentColor Write FCurrentColor;
    Property CurrentWidth: string Read FCurrentWidth Write FCurrentWidth;
  public
    constructor Create(AOwner : TComponent); override;
    procedure StartDocument;
    destructor Destroy; override;
    procedure SaveToStream(const AStream: TStream);
    // Create objects, owned by this document.
    Function CreateEmbeddedFont(AFontIndex, AFontSize : Integer) : TPDFEmbeddedFont;
    Function CreateText(X,Y : TPDFFloat; AText : AnsiString; const AFontIndex: integer) : TPDFText; overload;
    Function CreateText(X,Y : TPDFFloat; AText : UTF8String; const AFontIndex: integer) : TPDFUTF8Text; overload;
    Function CreateRectangle(const X,Y,W,H, ALineWidth: TPDFFloat; const AFill, AStroke: Boolean) : TPDFRectangle;
    Function CreateColor(AColor : TARGBColor; AStroke : Boolean) : TPDFColor;
    Function CreateBoolean(AValue : Boolean) : TPDFBoolean;
    Function CreateInteger(AValue : Integer) : TPDFInteger;
    Function CreateReference(AValue : Integer) : TPDFReference;
    Function CreateLineStyle(APenStyle: TPDFPenStyle) : TPDFLineStyle;
    Function CreateName(AValue : String) : TPDFName;
    Function CreateStream(OwnsObjects : Boolean = True) : TPDFStream;
    Function CreateDictionary : TPDFDictionary;
    Function CreateXRef : TPDFXRef;
    Function CreateArray : TPDFArray;
    Function CreateImage(const ALeft, ABottom: TPDFFloat; AWidth, AHeight, ANumber: integer) : TPDFImage;
    Function AddFont(AName : String; AColor : TARGBColor = clBlack) : Integer; overload;
    Function AddFont(AFontFile: String; AName : String; AColor : TARGBColor = clBlack) : Integer; overload;
    Function AddLineStyleDef(ALineWidth : TPDFFloat; AColor : TARGBColor = clBlack; APenStyle : TPDFPenStyle = ppsSolid) : Integer;
    Property Options : TPDFOptions Read FOptions Write FOPtions;
    property PageLayout: TPDFPageLayout read FPageLayout write FPageLayout default lSingle;
    Property Infos : TPDFInfos Read FInfos Write SetInfos;
    Property Fonts : TPDFFontDefs Read FFonts Write SetFonts;
    Property LineStyles : TPDFLineStyleDefs Read FLineStyleDefs Write SetLineStyles;
    Property Pages : TPDFPages Read FPages;
    Property Images : TPDFImages Read FImages;
    Property Catalogue: integer Read FCatalogue;
    Property Trailer: TPDFDictionary Read FTrailer;
    Property FontFiles : TStrings Read FFontFiles Write SetFontFiles;
    Property FontDirectory: string Read FFontDirectory Write FFontDirectory;
    Property Sections : TPDFSectionList Read FSections;
    Property DefaultPaperType : TPDFPaperTYpe Read FDefaultPaperType Write FDefaultPaperType;
    Property DefaultOrientation : TPDFPaperOrientation Read FDefaultOrientation Write FDefaultOrientation;
    Property ObjectCount : Integer Read FObjectCount;
  end;


const
  CRLF = #13#10;
  PDF_VERSION = '%PDF-1.3';
  PDF_BINARY_BLOB = '%'#$C3#$A4#$C3#$BC#$C3#$B6#$C3#$9F;
  PDF_FILE_END = '%%EOF';
  PDF_MAX_GEN_NUM = 65535;
  PDF_UNICODE_HEADER = 'FEFF001B%s001B';
  PDF_LANG_STRING = 'en';

  { Info from http://www.papersizes.org/a-sizes-all-units.htm }
  PDFPaperSizes : Array[TPDFPaperType,0..1] of Integer = (
    // Height,Width (units in pixels (or Points))
      (0,0),          // ptCustom
      (842,595),      // ptA4
      (595,420),      // ptA5
      (792,612),      // ptLetter
      (1008,612),     // ptLegal
      (756,522),      // ptExecutive
      (684,297),      // ptComm10
      (540,279),      // ptMonarch
      (624,312),      // ptDL
      (649,459),      // ptC5
      (709,499)       // ptB5
    );

  PDFPaperPrintables : Array[TPDFPaperType,0..3] of Integer = (
     // Top,Left,Right,Bottom (units in pixels)
      (0,0,0,0),          // ptCustom
      (10,11,586,822),    // ptA4
      (10,11,407,588),    // ptA5
      (13,13,599,780),    // ptLetter
      (13,13,599,996),    // ptLegal
      (14,13,508,744),    // ptExecutive
      (13,13,284,672),    // ptComm10
      (13,13,266,528),    // ptMonarch
      (14,13,297,611),    // ptDL
      (13,13,446,637),    // ptC5
      (14,13,485,696)     // ptB5
    );

  PageLayoutNames : Array[TPDFPageLayout] of String
                  = ('SinglePage','TwoColumnLeft','OneColumn');


// Helper procedures - made them global for unit testing purposes
procedure CompressStream(AFrom: TStream; ATo: TStream; ACompressLevel: TCompressionLevel = clDefault; ASkipHeader: boolean = False);
procedure CompressString(const AFrom: string; var ATo: string);
procedure DecompressStream(AFrom: TStream; ATo: TStream);

function mmToPDF(mm: single): TPDFFloat;
function cmToPDF(cm: single): TPDFFloat;
function InchesToPDF(Inches: single): TPDFFloat;

implementation


Resourcestring
  rsErrReportFontFileMissing = 'Font File "%s" does not exist.';
  SErrDictElementNotFound = 'Error: Dictionary element "%s" not found.';
  SerrInvalidSectionPage = 'Error: Invalid section page index.';
  SErrNoGlobalDict = 'Error: no global XRef named "%s".';
  SErrInvalidPageIndex = 'Invalid page index: %d';
  SErrNoFontIndex = 'No FontIndex was set - please use SetFont() first.';

type
  // to get access to protected methods
  TTTFFriendClass = class(TTFFileInfo)
  end;

Const
  // TODO: we should improve this to take into account the line width
  cPenStyleBitmasks: array[TPDFPenStyle] of string = (
    '',               // ppsSolid
    '5 3',            // ppsDash (dash space ...)
    '1 3',            // ppsDot (dot space ...)
    '5 3 1 3',        // ppsDashDot (dash space dot space ...)
    '5 3 1 3 1 3'     // ppsDashDotDot (dash space dot space dot space ...)
    );

const
  cInchToMM = 25.4;
  cInchToCM = 2.54;
  cDefaultDPI = 72;

  // mm = (pixels * 25.4) / dpi
  // pixels = (mm * dpi) / 25.4
  // cm = ((pixels * 25.4) / dpi) / 10


function DateToPdfDate(const ADate: TDateTime): string;
begin
  Result:=FormatDateTime('"D:"yyyymmddhhnnss', ADate);
end;

function FormatPDFInt(const Value: integer; PadLen: integer): string;
begin
  Result:=IntToStr(Value);
  Dec(PadLen,Length(Result));
  if PadLen>0 then
    Result:=StringOfChar('0',Padlen)+Result;
end;

procedure CompressStream(AFrom: TStream; ATo: TStream; ACompressLevel: TCompressionLevel = clDefault; ASkipHeader: boolean = False);
var
  c: TCompressionStream;
begin
  if AFrom.Size = 0 then
  begin
    ATo.Size := 0;
    Exit; //==>
  end;

  c := TCompressionStream.Create(ACompressLevel, ATo, ASkipHeader);
  try
    AFrom.Position := 0;
    c.CopyFrom(AFrom, AFrom.Size);
    c.Flush;
  finally
    c.Free;
  end;
end;

procedure CompressString(const AFrom: string; var ATo: string);
var
  lStreamFrom : TStringStream;
  lStreamTo  : TStringStream;
begin
  { TODO : Possible improvement would be to perform this compression directly on
           the string as a buffer, and not go through the stream stage. }
  lStreamFrom := TStringStream.Create(AFrom);
  try
    lStreamTo  := TStringStream.Create('');
    try
      lStreamFrom.Position := 0;
      lStreamTo.Size := 0;
      CompressStream(lStreamFrom, lStreamTo);
      ATo  := lStreamTo.DataString;
    finally
      lStreamTo.Free;
    end;
  finally
    lStreamFrom.Free;
  end;
end;

procedure DecompressStream(AFrom: TStream; ATo: TStream);

{$IFDEF VER2_6}
{$DEFINE NOHEADERWORKADOUND}
{$ENDIF}
{$IFDEF VER3_0}
{$DEFINE NOHEADERWORKADOUND}
{$ENDIF}

Const
  BufSize = 1024; // 1K

Type
  TBuffer = Array[0..BufSize-1] of byte;

var
  d: TDecompressionStream;
  {$IFDEF NOHEADERWORKADOUND}
  I: integer;
  {$ENDIF}
  Count : Integer;
  Buffer : TBuffer;

begin
  if AFrom.Size = 0 then
  begin
    ATo.Size := 0;
    Exit; //==>
  end;
  FillMem(@Buffer, SizeOf(TBuffer), 0);

  AFrom.Position := 0;
  AFrom.Seek(0,soFromEnd);
{$IFDEF NOHEADERWORKADOUND}
  // Work around a paszlib bug, FPC bugtracker 26827
  I:=0;
  AFrom.Write(I,SizeOf(I));
  AFrom.Position:=0;
{$ENDIF}
  D:=TDecompressionStream.Create(AFrom, False);
  try
    repeat
       Count:=D.Read(Buffer,BufSize);
       ATo.WriteBuffer(Buffer,Count);
     until (Count<BufSize);
  finally
    d.Free;
  end;
end;

function mmToPDF(mm: single): TPDFFloat;
begin
  Result := mm * (cDefaultDPI / cInchToMM);
end;

function PDFtoMM(APixels: TPDFFloat): single;
begin
  Result := (APixels * cInchToMM) / cDefaultDPI;
end;

function cmToPDF(cm: single): TPDFFloat;
begin
  Result := cm *(cDefaultDPI / cInchToCM);
end;

function PDFtoCM(APixels: TPDFFloat): single;
begin
  Result := (APixels * cInchToCM) / cDefaultDPI;
end;

function InchesToPDF(Inches: single): TPDFFloat;
begin
  Result := Inches * cDefaultDPI;
end;

function PDFtoInches(APixels: TPDFFloat): single;
begin
  Result := APixels / cDefaultDPI;
end;

{ TPDFInfos }

constructor TPDFInfos.Create;
begin
  inherited Create;
  FProducer := 'fpGUI Toolkit 0.8';
end;

{ TPDFMatrix }

function TPDFMatrix.Transform(APoint: TPDFCoord): TPDFCoord;
begin
  Result.x := _00 * APoint.x + _20;
  Result.y := _11 * APoint.y + _21;
end;

function TPDFMatrix.Transform(X, Y: TPDFFloat): TPDFCoord;
begin
  Result.x := _00 * X + _20;
  Result.y := _11 * Y + _21;
end;

function TPDFMatrix.ReverseTransform(APoint: TPDFCoord): TPDFCoord;
begin
  Result.x := (APoint.x - _20) / _00;
  Result.y := (APoint.y - _21) / _11;
end;

procedure TPDFMatrix.SetXScalation(const AValue: TPDFFloat);
begin
  _00 := AValue;
end;

procedure TPDFMatrix.SetYScalation(const AValue: TPDFFloat);
begin
  _11 := AValue;
end;

procedure TPDFMatrix.SetXTranslation(const AValue: TPDFFloat);
begin
  _20 := AValue;
end;

procedure TPDFMatrix.SetYTranslation(const AValue: TPDFFloat);
begin
  _21 := AValue;
end;

{ TTextMappingList }

function TTextMappingList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTextMappingList.GetItem(AIndex: Integer): TTextMapping;
begin
  Result := TTextMapping(FList.Items[AIndex]);
end;

procedure TTextMappingList.SetItem(AIndex: Integer; AValue: TTextMapping);
begin
  FList.Items[AIndex] := AValue;
end;

constructor TTextMappingList.Create;
begin
  FList := TFPObjectList.Create;
end;

destructor TTextMappingList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TTextMappingList.Add(AObject: TTextMapping): Integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FList.Count-1 do
  begin
    if TTextMapping(FList.Items[i]).CharID = AObject.CharID then
      Exit; // mapping already exists
  end;
  Result := FList.Add(AObject);
end;

function TTextMappingList.Add(const ACharID, AGlyphID: uint16): Integer;
var
  o: TTextMapping;
begin
  o := TTextMapping.Create;
  o.CharID := ACharID;
  o.GlyphID := AGlyphID;
  Result := Add(o);
  if Result = -1 then
    o.Free;
end;

{ TTextMapping }

class function TTextMapping.NewTextMap(const ACharID, AGlyphID: uint16): TTextMapping;
begin
  Result := TTextMapping.Create;
  Result.CharID := ACharID;
  Result.GlyphID := AGlyphID;
end;

{ TPDFFont }

procedure TPDFFont.PrepareTextMapping;
begin
  if FFontFilename <> '' then
  begin
    // only create objects when needed
    FTextMappingList := TTextMappingList.Create;
    FTrueTypeFile := TTFFileInfo.Create;
    FTrueTypeFile.LoadFromFile(FFontFilename);
    FTrueTypeFile.PrepareFontDefinition('cp1252', True);
  end;
end;

procedure TPDFFont.SetFontFilename(AValue: string);
begin
  if FFontFilename = AValue then
    Exit;
  FFontFilename := AValue;
  PrepareTextMapping;
end;

destructor TPDFFont.Destroy;
begin
  FTextMappingList.Free;
  FTrueTypeFile.Free;
  inherited Destroy;
end;

function TPDFFont.GetGlyphIndices(const AText: UnicodeString): AnsiString;
var
  i: integer;
  c: word;
begin
  Result := '';
  if Length(AText) = 0 then
    Exit;
  for i := 1 to Length(AText) do
  begin
    c := Word(AText[i]);
    Result := Result + IntToHex(FTrueTypeFile.GetGlyphIndex(c), 4);
  end;
end;

procedure TPDFFont.AddTextToMappingList(const AText: UnicodeString);
var
  i: integer;
  c: uint16; // Unicode codepoint
begin
  if AText = '' then
    Exit;
  for i := 1 to Length(AText) do
  begin
    c := uint16(AText[i]);
    FTextMappingList.Add(c, FTrueTypeFile.GetGlyphIndex(c));
  end;
end;

{ TPDFTrueTypeCharWidths }

procedure TPDFTrueTypeCharWidths.Write(const AStream: TStream);
var
  i: integer;
  s: string;
  lst: TTextMappingList;
  lFont: TTFFileInfo;
begin
  s := '';
  lst := Document.Fonts[EmbeddedFontNum].TextMapping;
  lFont := Document.Fonts[EmbeddedFontNum].FTrueTypeFile;
  for i := 0 to lst.Count-1 do
    s :=  s + Format(' %d [%d]', [ lst[i].GlyphID, TTTFFriendClass(lFont).ToNatural(lFont.Widths[lst[i].GlyphID].AdvanceWidth)]);
  WriteString(s, AStream);
end;

constructor TPDFTrueTypeCharWidths.Create(const ADocument: TPDFDocument; const AEmbeddedFontNum: integer);
begin
  inherited Create(ADocument);
  FEmbeddedFontNum := AEmbeddedFontNum;
end;

{ TPDFMoveTo }

class function TPDFMoveTo.Command(APos: TPDFCoord): String;

begin
  Result:=Command(APos.X,APos.Y);
end;

class function TPDFMoveTo.Command(AX, AY: TPDFFloat): String;
begin
  Result:=FloatStr(AX)+' '+FloatStr(AY)+' m'+CRLF;
end;

procedure TPDFMoveTo.Write(const AStream: TStream);
begin
  WriteString(Command(FPos),AStream);
end;

constructor TPDFMoveTo.Create(const ADocument: TPDFDocument; const AX,
  AY: TPDFFloat);
begin
  Inherited Create(ADocument);
  FPos.X:=AX;
  FPos.Y:=AY;
end;

constructor TPDFMoveTo.Create(const ADocument: TPDFDocument;
  const APos: TPDFCoord);
begin
  Inherited Create(ADocument);
  FPos:=APos;
end;

{ TPDFEllipse }

procedure TPDFEllipse.Write(const AStream: TStream);
Var
  X,Y,W2,H2,WS,HS : TPDFFloat;
begin
  if FStroke then
    SetWidth(FLineWidth, AStream);

  X:=FCenter.X;
  Y:=FCenter.Y;
  W2:=FDimensions.X/2;
  H2:=FDimensions.Y/2;
  WS:=W2*11/20;
  HS:=H2*11/20;
  // Starting point
  WriteString(TPDFMoveTo.Command(X,Y+H2),AStream);
  WriteString(TPDFCurveC.Command(X, Y+H2-HS, X+W2-WS, Y, X+W2, Y),AStream);
  WriteString(TPDFCurveC.Command(X+W2+WS, Y, X+W2*2, Y+H2-HS, X+W2*2, Y+H2),AStream);
  WriteString(TPDFCurveC.Command(X+W2*2, Y+H2+HS, X+W2+WS, Y+H2*2, X+W2, Y+H2*2),AStream);
  WriteString(TPDFCurveC.Command(X+W2-WS, Y+H2*2, X, Y+H2+HS, X, Y+H2),AStream);

  if FStroke and FFill then
    WriteString('b'+CRLF, AStream)
  else if FFill then
    WriteString('f'+CRLF, AStream)
  else if FStroke then
    WriteString('S'+CRLF, AStream);
  (*
  // should we default to this if no stroking or filling is required?
  else
    WriteString('n'+CRLF, AStream); // see PDF 1.3 Specification document on page 152
  *)
end;

constructor TPDFEllipse.Create(const ADocument: TPDFDocument; const APosX, APosY, AWidth, AHeight,
  ALineWidth: TPDFFloat; const AFill: Boolean; AStroke: Boolean);
begin
  Inherited Create(ADocument);
  FLineWidth:=ALineWidth;
  FCenter.X:=APosX;
  FCenter.Y:=APosY;
  FDimensions.X:=AWidth;
  FDimensions.Y:=AHeight;
  FFill:=AFill;
  FStroke:=AStroke;
end;

{ TPDFCurveY }

procedure TPDFCurveY.Write(const AStream: TStream);

begin
  if FStroke then
    SetWidth(FWidth,AStream);
  WriteString(FloatStr(FP1.X)+' '+FloatStr(FP1.Y)+' '+
              FloatStr(FP3.X)+' '+FloatStr(FP3.Y)+' y'+CRLF,AStream);
  if FStroke then
    WriteString('S'+CRLF, AStream);
end;

constructor TPDFCurveY.Create(const ADocument: TPDFDocument; const X1, Y1, X3,
  Y3, AWidth: TPDFFloat; AStroke: Boolean);
begin
  Inherited Create(ADocument);
  FP1.X:=X1;
  FP1.Y:=Y1;
  FP3.X:=X3;
  FP3.Y:=Y3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;

constructor TPDFCurveY.Create(const ADocument: TPDFDocument; const AP1,
  AP3: TPDFCoord; AWidth: TPDFFloat; AStroke: Boolean);
begin
  Inherited Create(ADocument);
  FP1:=AP1;
  FP3:=AP3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;


{ TPDFCurveV }

procedure TPDFCurveV.Write(const AStream: TStream);

begin
  if FStroke then
    SetWidth(FWidth,AStream);
  WriteString(FloatStr(FP2.X)+' '+FloatStr(FP2.Y)+' '+
              FloatStr(FP3.X)+' '+FloatStr(FP3.Y)+' v'+CRLF,AStream);
  if FStroke then
    WriteString('S'+CRLF, AStream);
end;

constructor TPDFCurveV.Create(const ADocument: TPDFDocument; const X2, Y2, X3,
  Y3, AWidth: TPDFFloat;AStroke: Boolean = True);
begin
  Inherited Create(ADocument);
  FP2.X:=X2;
  FP2.Y:=Y2;
  FP3.X:=X3;
  FP3.Y:=Y3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;

constructor TPDFCurveV.Create(const ADocument: TPDFDocument; const AP2,
  AP3: TPDFCoord; AWidth: TPDFFloat;AStroke: Boolean = True);
begin
  Inherited Create(ADocument);
  FP2:=AP2;
  FP3:=AP3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;

{ TPDFCurveC }

class function TPDFCurveC.Command(const X1, Y1, X2, Y2, X3, Y3: TPDFFloat
  ): String;
begin
  Result:=FloatStr(X1)+' '+FloatStr(Y1)+' '+
          FloatStr(X2)+' '+FloatStr(Y2)+' '+
          FloatStr(X3)+' '+FloatStr(Y3)+' c'+CRLF
end;

class function TPDFCurveC.Command(const AP1, AP2, AP3: TPDFCoord): String;
begin
  Result:=Command(AP1.X,AP1.Y,AP2.X,AP2.Y,AP3.X,AP3.Y);
end;

procedure TPDFCurveC.Write(const AStream: TStream);
begin
  if FStroke then
    SetWidth(FWidth,AStream);
  WriteString(Command(FP1,FP2,FP3),AStream);
  if FStroke then
    WriteString('S'+CRLF, AStream);
end;

constructor TPDFCurveC.Create(const ADocument: TPDFDocument; const X1, Y1, X2, Y2, X3, Y3,AWidth: TPDFFloat;AStroke: Boolean = True);
begin
  Inherited Create(ADocument);
  FP1.X:=X1;
  FP1.Y:=Y1;
  FP2.X:=X2;
  FP2.Y:=Y2;
  FP3.X:=X3;
  FP3.Y:=Y3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;

constructor TPDFCurveC.Create(const ADocument: TPDFDocument; const AP1, AP2, AP3: TPDFCoord; AWidth: TPDFFloat;AStroke: Boolean = True);
begin
  Inherited Create(ADocument);
  FP1:=AP1;
  FP2:=AP2;
  FP3:=AP3;
  FWidth:=AWidth;
  FStroke:=AStroke;
end;

{ TPDFLineStyleDefs }

function TPDFLineStyleDefs.GetI(AIndex : Integer): TPDFLineStyleDef;
begin
  Result:=TPDFLineStyleDef(Items[AIndex]);
end;

function TPDFLineStyleDefs.AddLineStyleDef: TPDFLineStyleDef;
begin
  Result:=Add as TPDFLineStyleDef;
end;

{ TPDFPages }

function TPDFPages.GetP(AIndex : Integer): TPDFPage;
begin
  if Assigned(Flist) then
    Result:=TPDFPage(FList[Aindex])
  else
    Raise EListError.CreateFmt(SErrInvalidPageIndex,[AIndex]);
end;

destructor TPDFPages.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TPDFPages.AddPage: TPDFPage;
begin
  if (FList=Nil) then
    FList:=TFPObjectList.Create;
  Result:=TPDFPage.Create(Document);
  FList.Add(Result);
end;

procedure TPDFPages.Add(APage: TPDFPage);
begin
  if (FList = nil) then
    FList := TFPObjectList.Create;
  FList.Add(APage);
end;

{ TPDFPage }

function TPDFPage.GetO(AIndex : Integer): TPDFObject;
begin
  Result:=TPDFObject(FObjects[AIndex]);
end;

function TPDFPage.GetObjectCount: Integer;
begin
  if FObjects=Nil then
    Result:=0
  else
    Result:=FObjects.Count;
end;

procedure TPDFPage.SetOrientation(AValue: TPDFPaperOrientation);
begin
  if FOrientation=AValue then Exit;
  FOrientation:=AValue;
  CalcPaperSize;
end;

procedure TPDFPage.CalcPaperSize;
var
  PP: TPDFPaper;
  O1, O2: Integer;
begin
  if PaperType = ptCustom then
    Exit;
  O1 := 0;
  O2 := 1;
  if Orientation = ppoLandScape then
  begin
    O1 := 1;
    O2 := 0;
  end;
  PP.H:=PDFPaperSizes[PaperType][O1];
  PP.W:=PDFPaperSizes[PaperType][O2];
  PP.Printable.T:=PDFPaperPrintables[PaperType][O1];
  PP.Printable.L:=PDFPaperPrintables[PaperType][O2];
  PP.Printable.R:=PDFPaperPrintables[PaperType][2+O1];
  PP.Printable.B:=PDFPaperPrintables[PaperType][2+O2];
  Paper:=PP;
end;

procedure TPDFPage.SetPaperType(AValue: TPDFPaperType);
begin
  if FPaperType=AValue then Exit;
  FPaperType:=AValue;
  CalcPaperSize;
end;

procedure TPDFPage.AddTextToLookupLists(AText: UTF8String);
var
  str: UnicodeString;
begin
  if AText = '' then
    Exit;
  str := UTF8Decode(AText);
  Document.Fonts[FFontIndex].AddTextToMappingList(str);
end;

procedure TPDFPage.DoUnitConversion(var APoint: TPDFCoord);
begin
  case FUnitOfMeasure of
    uomMillimeters:
      begin
        APoint.X := mmToPDF(APoint.X);
        APoint.Y := mmToPDF(APoint.Y);
      end;
    uomCentimeters:
      begin
        APoint.X := cmToPDF(APoint.X);
        APoint.Y := cmToPDF(APoint.Y);
      end;
    uomInches:
      begin
        APoint.X := InchesToPDF(APoint.X);
        APoint.Y := InchesToPDF(APoint.Y);
      end;
  end;
end;

procedure TPDFPage.CreateStdFontText(X: TPDFFloat; Y: TPDFFloat; AText: AnsiString; AFontIndex: integer);
var
  T: TPDFText;
begin
  T := Document.CreateText(X, Y, AText, AFontIndex);
  AddObject(T);
end;

procedure TPDFPage.CreateTTFFontText(X: TPDFFloat; Y: TPDFFloat; AText: UTF8String; AFontIndex: integer);
var
  T: TPDFUTF8Text;
begin
  AddTextToLookupLists(AText);
  T := Document.CreateText(X, Y, AText, FFontIndex);
  AddObject(T);
end;

procedure TPDFPage.SetUnitOfMeasure(AValue: TPDFUnitOfMeasure);
begin
  if FUnitOfMeasure = AValue then
    Exit;
  FUnitOfMeasure := AValue;
  AdjustMatrix;
end;

procedure TPDFPage.AdjustMatrix;
begin
  FMatrix._21 := GetPaperHeight;
end;

constructor TPDFPage.Create(const ADocument: TPDFDocument);
begin
  inherited Create(ADocument);
  FFontIndex := -1;
  FPaperType := ptA4;
  FUnitOfMeasure := uomMillimeters;
  CalcPaperSize;
  If Assigned(ADocument) then
  begin
    PaperType := ADocument.DefaultPaperType;
    Orientation := ADocument.DefaultOrientation;
  end;

  FMatrix._00 := 1;
  FMatrix._20 := 0;
  FMatrix._11 := -1;  // flip coordinates
  AdjustMatrix;       // sets FMatrix._21 value
end;

destructor TPDFPage.Destroy;
begin
  FreeAndNil(FObjects);
  inherited Destroy;
end;

procedure TPDFPage.AddObject(AObject: TPDFObject);
begin
  if FObjects=Nil then
    FObjects:=TObjectList.Create;
  FObjects.Add(AObject);
end;

procedure TPDFPage.SetFont(AFontIndex: Integer; AFontSize: Integer);

Var
  F : TPDFEmbeddedFont;

begin
  F:=Document.CreateEmbeddedFont(AFontIndex,AFontSize);
  AddObject(F);
  FFontIndex := AFontIndex;
end;

procedure TPDFPage.SetColor(AColor: TARGBColor; AStroke : Boolean = True);

Var
  C : TPDFColor;

begin
  C:=Document.CreateColor(AColor,AStroke);
  AddObject(C);
end;

procedure TPDFPage.SetPenStyle(AStyle: TPDFPenStyle);

Var
  L : TPDFLineStyle;

begin
  L:=Document.CreateLineStyle(AStyle);
  AddObject(L);
end;

procedure TPDFPage.WriteText(X, Y: TPDFFloat; AText: UTF8String);
var
  p: TPDFCoord;
begin
  if FFontIndex = -1 then
    raise EPDF.Create(SErrNoFontIndex);
  p := Matrix.Transform(X, Y);
  DoUnitConversion(p);
  if Document.Fonts[FFontIndex].IsStdFont then
    CreateStdFontText(p.X, p.Y, AText, FFontIndex)
  else
    CreateTTFFontText(p.X, p.Y, AText, FFontIndex);
end;

procedure TPDFPage.WriteText(APos: TPDFCoord; AText: UTF8String);
begin
  WriteText(APos.X, APos.Y, AText);
end;

procedure TPDFPage.DrawLine(X1, Y1, X2, Y2, ALineWidth: TPDFFloat);
var
  L : TPDFLineSegment;
  p1, p2: TPDFCoord;
begin
  p1 := Matrix.Transform(X1, Y1);
  p2 := Matrix.Transform(X2, Y2);
  DoUnitConversion(p1);
  DoUnitConversion(p2);
  L := TPDFLineSegment.Create(Document, ALineWidth, p1.X, p1.Y, p2.X, p2.Y);
  AddObject(L);
end;

procedure TPDFPage.DrawLine(APos1: TPDFCoord; APos2: TPDFCoord; ALineWidth: TPDFFloat);
begin
  DrawLine(APos1.X, APos1.Y, APos2.X, APos2.Y, ALineWidth);
end;

procedure TPDFPage.DrawLineStyle(X1, Y1, X2, Y2: TPDFFloat; AStyle: Integer);
var
  S: TPDFLineStyleDef;
begin
  S := Document.LineStyles[AStyle];
  SetColor(S.Color, True);
  SetPenStyle(S.PenStyle);
  DrawLine(X1, Y1, X2, Y2, S.LineWidth);
end;

procedure TPDFPage.DrawLineStyle(APos1: TPDFCoord; APos2: TPDFCoord; AStyle: Integer);
begin
  DrawLineStyle(APos1.X, APos1.Y, APos2.X, APos2.Y, AStyle);
end;

procedure TPDFPage.DrawRect(const X, Y, W, H, ALineWidth: TPDFFloat; const AFill, AStroke: Boolean);
var
  R: TPDFRectangle;
  p1, p2: TPDFCoord;
begin
  p1 := Matrix.Transform(X, Y);
  DoUnitConversion(p1);
  p2.X := W;
  p2.Y := H;
  DoUnitConversion(p2);
  R := Document.CreateRectangle(p1.X, p1.Y, p2.X, p2.Y, ALineWidth, AFill, AStroke);
  AddObject(R);
end;

procedure TPDFPage.DrawRect(const APos: TPDFCoord; const W, H, ALineWidth: TPDFFloat; const AFill, AStroke: Boolean);
begin
  DrawRect(APos.X, APos.Y, W, H, ALineWidth, AFill, AStroke);
end;

procedure TPDFPage.DrawImage(const X, Y: TPDFFloat; const AWidth, AHeight, ANumber: integer);
var
  p1: TPDFCoord;
begin
  p1 := Matrix.Transform(X, Y);
  DoUnitConversion(p1);
  AddObject(Document.CreateImage(p1.X, p1.Y, AWidth, AHeight, ANumber));
end;

procedure TPDFPage.DrawImage(const APos: TPDFCoord; const AWidth, AHeight, ANumber: integer);
begin
  DrawImage(APos.X, APos.Y, AWidth, AHeight, ANumber);
end;

procedure TPDFPage.DrawEllipse(const APosX, APosY, AWidth, AHeight,
    ALineWidth: TPDFFloat; const AFill: Boolean; AStroke: Boolean);
var
  p1, p2: TPDFCoord;
begin
  p1 := Matrix.Transform(APosX, APosY);
  DoUnitConversion(p1);
  p2.X := AWidth;
  p2.Y := AHeight;
  DoUnitConversion(p2);
  AddObject(TPDFEllipse.Create(Document, p1.X, p1.Y, p2.X, p2.Y, ALineWidth, AFill, AStroke));
end;

procedure TPDFPage.DrawEllipse(const APos: TPDFCoord; const AWidth, AHeight, ALineWidth: TPDFFloat;
    const AFill: Boolean; AStroke: Boolean);
begin
  DrawEllipse(APos.X, APos.Y, AWidth, AHeight, ALineWidth, AFill, AStroke);
end;

function TPDFPage.GetPaperHeight: TPDFFloat;
begin
  case FUnitOfMeasure of
    uomMillimeters:
      begin
        Result := PDFtoMM(Paper.H);
      end;
    uomCentimeters:
      begin
        Result := PDFtoCM(Paper.H);
      end;
    uomInches:
      begin
        Result := PDFtoInches(Paper.H);
      end;
    uomPixels:
      begin
        Result := Paper.H;
      end;
  end;
end;

function TPDFPage.HasImages: Boolean;

Var
  I,M : Integer;
begin
  Result:=False;
  M:=ObjectCount;
  I:=0;
  While (Not Result) and (I<M) do
    begin
    Result:=FObjects[i] is TPDFImage;
    Inc(I);
    end;
end;

{ TPDFFontDefs }

function TPDFFontDefs.GetF(AIndex : Integer): TPDFFont;
begin
  Result:=Items[AIndex] as TPDFFont;
end;

function TPDFFontDefs.AddFontDef: TPDFFont;
begin
  Result:=Add as TPDFFont;
end;

{ TPDFSection }

function TPDFSection.GetP(AIndex : Integer): TPDFPage;
begin
  If Assigned(FPages) then
    Result:=TPDFPage(FPages[Aindex])
  else
    Raise EPDF.CreateFmt(SerrInvalidSectionPage,[AIndex]);
end;

function TPDFSection.GetP: INteger;
begin
  if Assigned(FPages) then
    Result:=FPages.Count
  else
    Result:=0;
end;

destructor TPDFSection.Destroy;
begin
  FreeAndNil(FPages);
  inherited Destroy;
end;

procedure TPDFSection.AddPage(APage: TPDFPage);
begin
  if Not Assigned(FPages) then
    FPages:=TFPList.Create;
  FPages.Add(APage);
end;

{ TPDFSectionList }

function TPDFSectionList.GetS(AIndex : Integer): TPDFSection;
begin
  Result:=Items[AIndex] as TPDFSection
end;

function TPDFSectionList.AddSection: TPDFSection;
begin
  Result:=Add as TPDFSection;
end;

{ TPDFDocumentObject }

constructor TPDFDocumentObject.Create(const ADocument: TPDFDocument);
begin
  inherited Create(ADocument);
  FDocument:=ADocument;
end;

procedure TPDFDocumentObject.SetWidth(AWidth: TPDFFloat; AStream : TStream);

Var
  S : String;
begin
  S:=FloatStr(AWidth)+' w'; // stroke width
  if (S<>Document.CurrentWidth) then
    begin
    WriteString('1 J'+CRLF, AStream); // line cap set to rounded edge
    WriteString(S+CRLF, AStream);
    Document.CurrentWidth:=S;
    end;
end;

class procedure TPDFObject.WriteString(const AValue: string; AStream: TStream);

Var
  L : Integer;

begin
  L:=Length(AValue);
  if L>0 then
    AStream.Write(AValue[1],L);
end;

// Font=Name-Size:x:y
function ExtractBaseFontName(const AValue: string): string;
var
  FontName, S1, S2: string;
  P : Integer;

begin
  P:=RPos('-', AValue);
  if (P>0) then
    FontName:=Copy(AValue,1,P-1)
  else
    FontName:='';
  P:=Pos(':',AValue); // First attribute
  if (P>0) then
    begin
    S1:=Copy(AValue,P+1,Length(AValue)-P);
    S1:=Upcase(S1[1])+Copy(S1,2,Pred(Length(S1)));
    P:=Pos(':',S1);
    if (P>0) then
      begin
      S2:=Copy(S1,P+1,Length(S1)-P);
      if Length(S2)>0 then
        S2[1]:=Upcase(S2[1]);
      S1:=Copy(S1,1,P-1);
      if Length(S1)>0 then
        S1[1]:=Upcase(S1[1]);
      S1:=S1+S2;
      end;
    S1:='-'+S1;
    end;
  Result:=FontName+S1;
end;

{ TPDFImageItem }

procedure TPDFImageItem.SetImage(AValue: TFPCustomImage);
begin
  if FImage=AValue then Exit;
  FImage:=AValue;
  SetLength(FStreamed,0);
end;

function TPDFImageItem.GetStreamed: TBytes;
begin
  if Length(FStreamed)=0 then
    CreateStreamedData;
  Result:=FStreamed;
end;

function TPDFImageItem.GetHeight: Integer;
begin
  If Assigned(FImage) then
    Result:=FImage.Height
  else
    Result:=FHeight;
end;

function TPDFImageItem.GetWidth: Integer;
begin
  If Assigned(FImage) then
    Result:=FImage.Width
  else
    Result:=FWidth;
end;

procedure TPDFImageItem.SetStreamed(AValue: TBytes);
begin
  If AValue=FStreamed then exit;
  SetLength(FStreamed,0);
  FStreamed:=AValue;
end;

destructor TPDFImageItem.Destroy;
begin
  if FOwnsImage then
    FreeAndNil(FImage);
  inherited Destroy;
end;

procedure TPDFImageItem.CreateStreamedData;

Var
  I,X,Y : Integer;
  C : TFPColor;
begin
  FWidth:=Image.Width;
  FHeight:=Image.Height;
  SetLength(FStreamed,FWidth*FHeight*3);
  I:=0;
  for Y:=0 to FHeight-1 do
    for X:=0 to FWidth-1 do
      begin
      C:=Image.Colors[x,y];
      FStreamed[I]:=C.Red shr 8;
      FStreamed[I+1]:=C.Green shr 8;
      FStreamed[I+2]:=C.blue shr 8;
      Inc(I,3);
      end;
end;

function TPDFImageItem.WriteImageStream(AStream: TStream): int64;

var
  Img : TBytes;

begin
  TPDFObject.WriteString(CRLF+'stream'+CRLF,AStream);
  Img:=StreamedData;
  Result:=Length(Img);
  AStream.WriteBuffer(Img[0],Result);
  TPDFObject.WriteString(CRLF, AStream);
  TPDFObject.WriteString('endstream', AStream);
end;

function TPDFImageItem.Equals(AImage: TFPCustomImage): boolean;
var
  x, y: Integer;
begin
  Result := True;
  for x := 0 to Image.Width-1 do
    for y := 0 to Image.Height-1 do
      if Image.Pixels[x, y] <> AImage.Pixels[x, y] then
      begin
        Result := False;
        Exit;
      end;
end;



{ TPDFImages }

function TPDFImages.GetI(AIndex : Integer): TPDFImageItem;
begin
  Result:=Items[AIndex] as TPDFImageItem;
end;

function TPDFImages.AddImageItem: TPDFImageItem;
begin
  Result:=Add as TPDFImageItem;
end;

function TPDFImages.AddFromFile(const AFileName: String; KeepImage: Boolean): Integer;

Var
  I : TFPMemoryImage;
  IP : TPDFImageItem;

begin
  I:=TFPMemoryImage.Create(0,0);
  I.LoadFromFile(AFileName);
  IP:=AddImageItem;
  IP.Image:=I;
  if Not KeepImage then
    begin
    IP.CreateStreamedData;
    IP.FImage:=Nil; // not through property, that would clear the image
    i.Free;
    end;
  Result:=Count-1;
end;

{ TPDFObject }

constructor TPDFObject.Create(const ADocument: TPDFDocument);
begin
  If Assigned(ADocument) then
    Inc(ADocument.FObjectCount);
end;

{ We opted to use the Str() function instead of FormatFloat(), because it is
  considerably faster. This also works around the problem of locale specific
  DecimalSeparator causing float formatting problems in the generated PDF. }
class function TPDFObject.FloatStr(F: TPDFFloat): String;
begin
  if ((Round(F*100) mod 100)=0) then
    Str(F:4:0,Result)
  else
    Str(F:4:2,Result);
end;

procedure TPDFObject.Write(const AStream: TStream);
begin
  Assert(AStream<>Nil);
end;

procedure TPDFBoolean.Write(const AStream: TStream);
begin
  if FValue then
    WriteString('true', AStream)
  else
    WriteString('false', AStream);
end;

constructor TPDFBoolean.Create(Const ADocument : TPDFDocument; const AValue: Boolean);
begin
  inherited Create(ADocument);
  FValue:=AValue;
end;

procedure TPDFInteger.Write(const AStream: TStream);
begin
  WriteString(IntToStr(FInt), AStream);
end;

procedure TPDFInteger.Inc;
begin
  system.Inc(FInt);
end;

constructor TPDFInteger.Create(Const ADocument : TPDFDocument; const AValue: integer);
begin
  inherited Create(ADocument);
  FInt:=AValue;
end;


procedure TPDFReference.Write(const AStream: TStream);
begin
  WriteString(IntToStr(FValue)+' 0 R', AStream);
end;

constructor TPDFReference.Create(Const ADocument : TPDFDocument; const AValue: integer);
begin
  inherited Create(ADocument);
  FValue:=AValue;
end;

procedure TPDFName.Write(const AStream: TStream);
begin
  if FName <> '' then
    if Pos('Length1', FName) > 0 then
      WriteString('/Length1', AStream)
    else
      WriteString('/'+FName {ConvertCharsToHex}, AStream);
end;

constructor TPDFName.Create(const ADocument: TPDFDocument; const AValue: string);
begin
  inherited Create(ADocument);
  FName:=AValue;
end;

function TPDFName.ConvertCharsToHex: string;
var
  s: string;
  i: integer;
  d: integer;
begin
  s := '';
  for i := 1 to Length(Name) do
  begin
    d := Ord(Name[i]);
    if (d < 33) or (d > 126) then
      s := s + '#' + IntToHex(d, 2)
    else
      s := s + Name[i];
  end;
  Result := s;
end;

{ TPDFAbstractString }

function TPDFAbstractString.InsertEscape(const AValue: string): string;
var
  S: string;
begin
  Result:='';
  S:=AValue;
  if Pos('\', S) > 0 then
    S:=AnsiReplaceStr(S, '\', '\\');
  if Pos('(', S) > 0 then
    S:=AnsiReplaceStr(S, '(', '\(');
  if Pos(')', S) > 0 then
    S:=AnsiReplaceStr(S, ')', '\)');
  Result:=S;
end;

{ TPDFString }

procedure TPDFString.Write(const AStream: TStream);
var
  s: AnsiString;
begin
  s := Utf8ToAnsi(FValue);
  if poCompressText in Document.Options then
  begin
    // TODO: Implement text compression
    WriteString('('+s+')', AStream);
  end
  else
    WriteString('('+s+')', AStream);
end;

constructor TPDFString.Create(Const ADocument : TPDFDocument; const AValue: string);
begin
  inherited Create(ADocument);
  FValue := AValue;
  if (Pos('(', FValue) > 0) or (Pos(')', FValue) > 0) or (Pos('\', FValue) > 0) then
    FValue := InsertEscape(FValue);
end;

{ TPDFUTF8String }

function TPDFUTF8String.RemapedText: AnsiString;
var
  s: UnicodeString;
begin
  s := UTF8Decode(FValue);
  Result := Document.Fonts[FontIndex].GetGlyphIndices(s);
end;

procedure TPDFUTF8String.Write(const AStream: TStream);
begin
  if poCompressText in Document.Options then
  begin
    // TODO: Implement text compression
    WriteString('<'+RemapedText+'>', AStream)
  end
  else
    WriteString('<'+RemapedText+'>', AStream);
end;

constructor TPDFUTF8String.Create(const ADocument: TPDFDocument; const AValue: UTF8String; const AFontIndex: integer);
begin
  inherited Create(ADocument);
  FValue := AValue;
  FFontIndex := AFontIndex;
  if (Pos('(', FValue) > 0) or (Pos(')', FValue) > 0) or (Pos('\', FValue) > 0) then
    FValue := InsertEscape(FValue);
end;

{ TPDFArray }

procedure TPDFArray.Write(const AStream: TStream);
var
  i: integer;
begin
  WriteString('[', AStream);
  for i:=0 to Pred(FArray.Count) do
    begin
    if i > 0 then
      WriteString(' ', AStream);
    TPDFObject(FArray[i]).Write(AStream);
    end;
  WriteString(']', AStream);
end;

procedure TPDFArray.AddItem(const AValue: TPDFObject);
begin
  FArray.Add(AValue);
end;

procedure TPDFArray.AddIntArray(S: String);

Var
  P : Integer;

begin
  P:=Pos(' ',S);
  while (P>0) do
  begin
    AddItem(Document.CreateInteger(StrToInt(Copy(S,1,Pred(P)))));
    Delete(S,1,P);
    P:=Pos(' ',S);
  end;
  if S <> '' then
    AddItem(Document.CreateInteger(StrToInt(S)));
end;

constructor TPDFArray.Create(const ADocument: TPDFDocument);
begin
  inherited Create(ADocument);
  FArray:=TFPObjectList.Create;
end;

destructor TPDFArray.Destroy;

begin
  // TPDFInteger, TPDFReference, TPDFName
  FreeAndNil(FArray);
  inherited;
end;

procedure TPDFStream.Write(const AStream: TStream);
var
  i: integer;
begin
  for i:=0 to FItems.Count-1 do
    TPDFObject(FItems[i]).Write(AStream);
end;

procedure TPDFStream.AddItem(const AValue: TPDFObject);
begin
  FItems.Add(AValue);
end;

constructor TPDFStream.Create(Const ADocument : TPDFDocument; OwnsObjects : Boolean = True);
begin
  inherited Create(ADocument);
  FItems:=TFPObjectList.Create(OwnsObjects);
end;

destructor TPDFStream.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TPDFEmbeddedFont.Write(const AStream: TStream);
begin
  WriteString('/F'+IntToStr(FTxtFont)+' '+FTxtSize+' Tf'+CRLF, AStream);
end;

Class function TPDFEmbeddedFont.WriteEmbeddedFont(const ADocument: TPDFDocument; const Src: TMemoryStream; const AStream: TStream): int64;
var
  PS: int64;
  CompressedStream: TMemoryStream;
begin
  WriteString(CRLF+'stream'+CRLF, AStream);
  PS:=AStream.Position;
  if poCompressFonts in ADocument.Options then
  begin
    CompressedStream := TMemoryStream.Create;
    CompressStream(Src, CompressedStream);
    CompressedStream.Position := 0;
    CompressedStream.SaveToStream(AStream);
    CompressedStream.Free;
  end
  else
  begin
    Src.Position := 0;
    Src.SaveToStream(AStream);
  end;
  Result:=AStream.Position-PS;
  WriteString(CRLF, AStream);
  WriteString('endstream', AStream);
end;

constructor TPDFEmbeddedFont.Create(Const ADocument : TPDFDocument;const AFont: integer; const ASize: string);
begin
  inherited Create(ADocument);
  FTxtFont:=AFont;
  FTxtSize:=ASize;
end;


procedure TPDFText.Write(const AStream: TStream);
begin
  WriteString('BT'+CRLF, AStream);
  WriteString(FloatStr(FX)+' '+FloatStr(FY)+' TD'+CRLF, AStream);
  FString.Write(AStream);
  WriteString(' Tj'+CRLF, AStream);
  WriteString('ET'+CRLF, AStream);
end;

constructor TPDFText.Create(Const ADocument : TPDFDocument; const AX, AY: TPDFFloat; const AText: AnsiString;
    const AFontIndex: integer);
begin
  inherited Create(ADocument);
  FX:=AX;
  FY:=AY;
  FFontIndex := AFontIndex;
  FString:=ADocument.CreateString(AText);
end;

destructor TPDFText.Destroy;
begin
  FreeAndNil(FString);
  inherited;
end;

{ TPDFUTF8Text }

procedure TPDFUTF8Text.Write(const AStream: TStream);
begin
  WriteString('BT'+CRLF, AStream);
  WriteString(FloatStr(FX)+' '+FloatStr(FY)+' TD'+CRLF, AStream);
  FString.Write(AStream);
  WriteString(' Tj'+CRLF, AStream);
  WriteString('ET'+CRLF, AStream);
end;

constructor TPDFUTF8Text.Create(const ADocument: TPDFDocument; const AX, AY: TPDFFloat; const AText: UTF8String;
    const AFontIndex: integer);
begin
  inherited Create(ADocument);
  FX := AX;
  FY := AY;
  FFontIndex := AFontIndex;
  FString := ADocument.CreateUTF8String(AText, AFontIndex);
end;

destructor TPDFUTF8Text.Destroy;
begin
  FreeAndNil(FString);
  inherited Destroy;
end;

{ TPDFLineSegment  }

procedure TPDFLineSegment.Write(const AStream: TStream);

begin
  SetWidth(FWidth,AStream);
  WriteString(TPDFMoveTo.Command(P1), AStream);
  WriteString(Command(P2),AStream);
  WriteString('S'+CRLF, AStream);
end;

class function TPDFLineSegment.Command(APos: TPDFCoord): String;
begin
  Result:=FloatStr(APos.X)+' '+FloatStr(APos.Y)+' l'+CRLF
end;

class function TPDFLineSegment.Command(APos1, APos2: TPDFCoord): String;
begin
  Result:=TPDFMoveTo.Command(APos1)+Command(APos2);
end;

constructor TPDFLineSegment.Create(const ADocument: TPDFDocument; const AWidth,
  X1, Y1, X2, Y2: TPDFFloat);
begin
  inherited Create(ADocument);
  FWidth:=AWidth;
  P1.X:=X1;
  P1.Y:=Y1;
  P2.X:=X2;
  P2.Y:=Y2;
end;

procedure TPDFRectangle.Write(const AStream: TStream);
begin
  if FStroke then
    SetWidth(FWidth, AStream);
  WriteString(FloatStr(FTopLeft.X)+' '+FloatStr(FTopLeft.Y)+' '+FloatStr(FDimensions.X)+' '+FloatStr(FDimensions.Y)+' re'+CRLF, AStream);
  if FStroke and FFill then
    WriteString('b'+CRLF, AStream)
  else if FFill then
    WriteString('f'+CRLF, AStream)
  else if FStroke then
    WriteString('S'+CRLF, AStream);
  (*
  // should we default to this if no stroking or filling is required?
  else
    WriteString('n'+CRLF, AStream); // see PDF 1.3 Specification document on page 152
  *)
end;

constructor TPDFRectangle.Create(const ADocument: TPDFDocument; const APosX, APosY, AWidth, AHeight,
    ALineWidth: TPDFFloat; const AFill, AStroke: Boolean);
begin
  inherited Create(ADocument);
  FTopLeft.X := APosX;
  FTopLeft.Y := APosY;
  FDimensions.X := AWidth;
  FDimensions.Y := AHeight;
  FWidth := ALineWidth;
  FFill := AFill;
  FStroke := AStroke;
end;

procedure TPDFSurface.Write(const AStream: TStream);
var
  i: integer;
begin
  WriteString(TPDFMoveTo.Command(FPoints[0].X,FPoints[0].Y),AStream);
  for i:=1 to Pred(Length(FPoints)) do
    WriteString(FloatStr( FPoints[i].X)+' '+FloatStr( FPoints[i].Y)+' l'+CRLF, AStream);
  if FClose then
    WriteString('h'+CRLF, AStream);
  if FFill then
    WriteString('f'+CRLF, AStream);
end;

constructor TPDFSurface.Create(Const ADocument : TPDFDocument; const APoints: TPDFCoordArray; AClose : Boolean; AFill : Boolean = True);
begin
  inherited Create(ADocument);
  FPoints:=APoints;
  FClose:=AClose;
  FFill:=AFill;
end;

procedure TPDFImage.Write(const AStream: TStream);
begin
  WriteString('q'+CRLF, AStream);   // save graphics state
  WriteString(IntToStr(FWidth)+' 0 0 '+IntToStr(FHeight)+' '+FloatStr( FPos.X)+' '+FloatStr( FPos.Y)+' cm'+CRLF, AStream);
  WriteString('/I'+IntToStr(FNumber)+' Do'+CRLF, AStream);
  WriteString('Q'+CRLF, AStream);   // restore graphics state
end;

constructor TPDFImage.Create(Const ADocument : TPDFDocument; const ALeft, ABottom: TPDFFloat; AWidth, AHeight, ANumber: integer);
begin
  inherited Create(ADocument);
  FNumber:=ANumber;
  FPos.X:=ALeft;
  FPos.Y:=ABottom;
  FWidth:=AWidth;
  FHeight:=AHeight;
end;

procedure TPDFLineStyle.Write(const AStream: TStream);
begin
  WriteString(Format('[%s] %d d'+CRLF,[cPenStyleBitmasks[FStyle],FPhase]), AStream);
end;

constructor TPDFLineStyle.Create(Const ADocument : TPDFDocument; AStyle: TPDFPenStyle; APhase: integer);
begin
  inherited Create(ADocument);
  FStyle:=AStyle;
  FPhase:=APhase;
end;

procedure TPDFColor.Write(const AStream: TStream);

Var
  S : String;
begin
  S:=FRed+' '+FGreen+' '+FBlue;
  if FStroke then
    S:=S+' RG'
  else
    S:=S+' rg';
  if (S<>Document.CurrentColor) then
    begin
    WriteString(S+CRLF, AStream);
    Document.CurrentColor:=S;
    end;
end;

Function ARGBGetRed(AColor : TARGBColor) : Byte;

begin
  Result:=((AColor shr 16) and $FF)
end;

Function ARGBGetGreen(AColor : TARGBColor) : Byte;

begin
  Result:=((AColor shr 8) and $FF)
end;

Function ARGBGetBlue(AColor : TARGBColor) : Byte;

begin
  Result:=AColor and $FF;
end;

Function ARGBGetAlpha(AColor : TARGBColor) : Byte;

begin
  Result:=((AColor shr 24) and $FF)
end;

constructor TPDFColor.Create(Const ADocument : TPDFDocument; const AStroke: Boolean; AColor: TARGBColor);
begin
  inherited Create(ADocument);
  FRed:=FloatStr( ARGBGetRed(AColor)/256);
  FGreen:=FloatStr( ARGBGetGreen(AColor)/256);
  FBlue:=FloatStr( ARGBGetBlue(AColor)/256);
  FStroke:=AStroke;
end;

procedure TPDFDictionaryItem.Write(const AStream: TStream);
begin
  FKey.Write(AStream);
  TPDFObject.WriteString(' ', AStream);
  FObj.Write(AStream);
  TPDFObject.WriteString(CRLF, AStream);
end;

constructor TPDFDictionaryItem.Create(Const ADocument : TPDFDocument;const AKey: string; const AValue: TPDFObject);
begin
  inherited Create(ADocument);
  FKey:=ADocument.CreateName(AKey);
  FObj:=AValue;
end;

destructor TPDFDictionaryItem.Destroy;
begin
  FreeAndNil(FKey);
  // TPDFBoolean,TPDFDictionary,TPDFInteger,TPDFName,TPDFReference,TPDFString,TPDFArray
  FreeAndNil(FObj);
  inherited;
end;

function TPDFDictionary.GetE(AIndex : Integer): TPDFDictionaryItem;
begin
  Result:=TPDFDictionaryItem(FElements[AIndex]);
end;

function TPDFDictionary.GetEC: Integer;
begin
  Result:=FElements.Count;
end;

function TPDFDictionary.GetV(AIndex : Integer): TPDFObject;
begin
  Result:=Elements[AIndex].Value;
end;

procedure TPDFDictionary.AddElement(const AKey: string; const AValue: TPDFObject);
var
  DicElement: TPDFDictionaryItem;
begin
  DicElement:=TPDFDictionaryItem.Create(Document,AKey, AValue);
  FElements.Add(DicElement);
end;

procedure TPDFDictionary.AddName(const AKey, AName: String);
begin
  AddElement(AKey,Document.CreateName(AName));
end;

procedure TPDFDictionary.AddInteger(const AKey: String; AInteger: Integer);
begin
  AddElement(AKey,Document.CreateInteger(AInteger));
end;

procedure TPDFDictionary.AddReference(const AKey: String; AReference: Integer);
begin
  AddElement(AKey,Document.CreateReference(AReference));
end;

procedure TPDFDictionary.AddString(const AKey, AString: String);
begin
  AddElement(AKey,Document.CreateString(AString));
end;

function TPDFDictionary.IndexOfKey(const AValue: string): integer;
var
  i: integer;
begin
  Result:=-1;
  I:=0;
  While (Result=-1) and (I<ElementCount) do
    begin
    if GetE(I).FKey.Name=AValue then
      Result:=I;
    Inc(I);
    end;
end;

procedure TPDFDictionary.Write(const AStream: TStream);
begin
  WriteDictionary(-1,AStream);
end;

procedure TPDFDictionary.WriteDictionary(const AObject: integer; const AStream: TStream);
var
  ISize,i, NumImg, NumFnt, BufSize: integer;
  Value: string;
  M, Buf : TMemoryStream;
  E : TPDFDictionaryItem;
  D : TPDFDictionary;
begin
  if GetE(0).FKey.Name='' then
    GetE(0).Write(AStream)  // write a charwidth array of a font
  else
  begin
    WriteString('<<'+CRLF, AStream);
    for i:=0 to ElementCount-1 do
      GetE(I).Write(AStream);
    NumImg:=-1;
    NumFnt:=-1;
    for i:=0 to ElementCount-1 do
      begin
      E:=GetE(i);
      if AObject > -1 then
        begin
          if (E.FKey.Name='Name') then
          begin
            if (TPDFObject(E.Value) is TPDFName) and (TPDFName(E.Value).Name[1]='I') then
            begin
              NumImg:=StrToInt(Copy(TPDFName(E.Value).Name, 2, Length(TPDFName(E.Value).Name) - 1));
              // write image stream length in xobject dictionary
              ISize:=Length(Document.Images[NumImg].StreamedData);
              D:=Document.GlobalXRefs[AObject].Dict;
              D.AddInteger('Length',ISize);
              LastElement.Write(AStream);
              WriteString('>>', AStream);
              // write image stream in xobject dictionary
              Document.Images[NumImg].WriteImageStream(AStream);
            end;
          end;
          if Pos('Length1', E.FKey.Name) > 0 then
          begin
            M:=TMemoryStream.Create;
            try
              Value:=E.FKey.Name;
              NumFnt:=StrToInt(Copy(Value, Succ(Pos(' ', Value)), Length(Value) - Pos(' ', Value)));
              m.LoadFromFile(Document.FontFiles[NumFnt]);
              Buf := TMemoryStream.Create;
              try
                // write fontfile stream (could be compressed or not) to a temporary buffer so we can get the size
                BufSize := TPDFEmbeddedFont.WriteEmbeddedFont(Document, M, Buf);
                Buf.Position := 0;
                // write fontfile stream length in xobject dictionary
                D := Document.GlobalXRefs[AObject].Dict;
                D.AddInteger('Length', BufSize);
                LastElement.Write(AStream);
                WriteString('>>', AStream);
                // write fontfile buffer stream in xobject dictionary
                Buf.SaveToStream(AStream);
              finally
                Buf.Free;
              end;
            finally
              M.Free;
            end;
          end;
        end;
      end; { for i... }
    end; { if FElement.Count... }
    if (NumImg = -1) and (NumFnt = -1) then
      WriteString('>>', AStream);
end; { if/else }


function TPDFDictionary.LastElement: TPDFDictionaryItem;
begin
  if (ElementCount=0) then
    Result:=Nil
  else
    Result:=GetE(ElementCount-1);
end;

function TPDFDictionary.LastValue: TPDFObject;
Var
  DE : TPDFDictionaryItem;
begin
  DE:=LastElement;
  If Assigned(DE) then
    Result:=DE.Value
  else
    Result:=Nil;
end;

function TPDFDictionary.FindElement(const AKey: String): TPDFDictionaryItem;

Var
  I : integer;

begin
  I:=IndexOfKey(AKey);
  if I=-1 then
    Result:=Nil
  else
    Result:=GetE(I);
end;

function TPDFDictionary.FindValue(const AKey: String): TPDFObject;

Var
  DI : TPDFDictionaryItem;

begin
  DI:=FindElement(AKey);
  if Assigned(DI) then
    Result:=DI.Value
  else
    Result:=Nil;
end;

function TPDFDictionary.ElementByName(const AKey: String): TPDFDictionaryItem;
begin
  Result:=FindElement(AKey);
  If (Result=Nil) then
    Raise EPDF.CreateFmt(SErrDictElementNotFound,[AKey]);
end;

function TPDFDictionary.ValueByName(const AKey: String): TPDFObject;
begin
  Result:=ElementByName(AKey).Value;
end;

constructor TPDFDictionary.Create(const ADocument: TPDFDocument);
begin
  inherited Create(ADocument);
  FElements:=TFPObjectList.Create;
end;

destructor TPDFDictionary.Destroy;

begin
  FreeAndNil(FElements);
  inherited;
end;

procedure TPDFXRef.Write(const AStream: TStream);
begin
  TPDFObject.WriteString(FormatPDFInt(FOffset, 10)+' '+FormatPDFInt(0, 5)+' n'+CRLF, AStream);
end;

constructor TPDFXRef.Create(Const ADocument : TPDFDocument);
begin
  inherited Create;
  FOffset:=0;
  FDict:=ADocument.CreateDictionary;
  FStream:=nil;
end;

destructor TPDFXRef.Destroy;
begin
  FreeAndNil(FDict);
  FreeAndNil(FStream);
  inherited;
end;

{ TPDFToUnicode }

procedure TPDFToUnicode.Write(const AStream: TStream);
var
  lst: TTextMappingList;
  i: integer;
begin
  lst := Document.Fonts[EmbeddedFontNum].TextMapping;

  WriteString('/CIDInit /ProcSet findresource begin'+CRLF, AStream);
  WriteString('12 dict begin'+CRLF, AStream);
  WriteString('begincmap'+CRLF, AStream);
  WriteString('/CIDSystemInfo'+CRLF, AStream);
  WriteString('<</Registry (Adobe)'+CRLF, AStream);
  WriteString('/Ordering (Identity)'+CRLF, AStream);
  WriteString('/Supplement 0'+CRLF, AStream);
  WriteString('>> def'+CRLF, AStream);
  WriteString(Format('/CMapName /%s def', [Document.Fonts[EmbeddedFontNum].FTrueTypeFile.PostScriptName])+CRLF, AStream);
  WriteString('/CMapType 2 def'+CRLF, AStream);
  WriteString('1 begincodespacerange'+CRLF, AStream);
  WriteString('<0000> <FFFF>'+CRLF, AStream);
  WriteString('endcodespacerange'+CRLF, AStream);
  WriteString(Format('%d beginbfchar', [lst.Count])+CRLF, AStream);
  for i := 0 to lst.Count-1 do
    WriteString(Format('<%s> <%s>', [IntToHex(lst[i].GlyphID, 4), IntToHex(lst[i].CharID, 4)])+CRLF, AStream);
  WriteString('endbfchar'+CRLF, AStream);
  WriteString('endcmap'+CRLF, AStream);
  WriteString('CMapName currentdict /CMap defineresource pop'+CRLF, AStream);
  WriteString('end'+CRLF, AStream);
  WriteString('end'+CRLF, AStream);
end;

constructor TPDFToUnicode.Create(const ADocument: TPDFDocument; const AEmbeddedFontNum: integer);
begin
  inherited Create(ADocument);
  FEmbeddedFontNum := AEmbeddedFontNum;
end;

{ TPDFDocument }

procedure TPDFDocument.SetInfos(AValue: TPDFInfos);
begin
  if FInfos=AValue then Exit;
  FInfos.Assign(AValue);
end;

procedure TPDFDocument.SetLineStyles(AValue: TPDFLineStyleDefs);
begin
  if FLineStyleDefs=AValue then Exit;
  FLineStyleDefs.Assign(AValue);
end;

procedure TPDFDocument.SetFonts(AValue: TPDFFontDefs);
begin
  if FFonts=AValue then Exit;
  FFonts:=AValue;
end;

procedure TPDFDocument.SetFontFiles(AValue: TStrings);
begin
  if FFontFiles=AValue then Exit;
  FFontFiles.Assign(AValue);
end;

function TPDFDocument.GetX(AIndex : Integer): TPDFXRef;
begin
  Result:=FGlobalXRefs[Aindex] as TPDFXRef;
end;

function TPDFDocument.GetXC: Integer;
begin
  Result:=FGlobalXRefs.Count;
end;

function TPDFDocument.IndexOfGlobalXRef(const AValue: string): integer;
var
  i: integer;
  p : TPDFObject;
begin
  Result:=-1;
  I:=1;
  While (Result=-1) and (I<FGlobalXRefs.Count) do
    begin
    p:=GetX(i).Dict.Elements[0].Value;
    if (p is TPDFName) and (TPDFName(p).Name=AValue) then
      Result:=i;
    Inc(I);
    end;
end;

function TPDFDocument.FindGlobalXRef(const AName: String): TPDFXRef;

Var
  I : Integer;

begin
  I:=IndexOfGlobalXRef(AName);
  if I=-1 then
    Result:=Nil
  else
    Result:=GlobalXRefs[i];
end;

procedure TPDFDocument.WriteXRefTable(const AStream: TStream);
var
  i: integer;
begin
  if FGlobalXRefs.Count > 1 then
    for i:=1 to FGlobalXRefs.Count-1 do
      GetX(i).Write(AStream);
end;

procedure TPDFDocument.WriteObject(const AObject: integer; const AStream: TStream);
var
  M : TMemoryStream;
  X : TPDFXRef;
begin
  TPDFObject.WriteString(IntToStr(AObject)+' 0 obj'+CRLF, AStream);
  X:=GlobalXRefs[AObject];
  if X.FStream = nil then
    X.Dict.WriteDictionary(AObject, AStream)
  else
    begin
    M:=TMemoryStream.Create;
    try
      CurrentColor:='';
      CurrentWidth:='';
      X.FStream.Write(M);
      X.Dict.AddInteger('Length',M.Size);
    finally
      M.Free;
    end;
    X.Dict.Write(AStream);
    // write stream in contents dictionary
    CurrentColor:='';
    CurrentWidth:='';
    TPDFObject.WriteString(CRLF+'stream'+CRLF, AStream);
    X.FStream.Write(AStream);
    TPDFObject.WriteString('endstream', AStream);
    end;
  TPDFObject.WriteString(CRLF+'endobj'+CRLF+CRLF, AStream);
end;

procedure TPDFDocument.CreateRefTable;

begin
  FGlobalXRefs:=TFPObjectList.Create;
  FGlobalXRefs.Add(CreateXRef);
end;


procedure TPDFDocument.CreateTrailer;

begin
  FTrailer:=CreateDictionary;
  Trailer.AddInteger('Size',GlobalXRefCount);
end;

function TPDFDocument.CreateCatalogEntry: integer;
var
  CDict: TPDFDictionary;
begin
  CDict:=CreateGlobalXRef.Dict;
  Trailer.AddReference('Root',GlobalXRefCount-1);
  CDict.AddName('Type','Catalog');
  CDict.AddName('PageLayout', PageLayoutNames[FPageLayout]);
  CDict.AddElement('OpenAction', CreateArray);
  Result:=GlobalXRefCount-1;
end;

procedure TPDFDocument.CreateInfoEntry;

var
  IDict: TPDFDictionary;

begin
  IDict:=CreateGlobalXRef.Dict;
  Trailer.AddReference('Info', GLobalXRefCount-1);
  (Trailer.ValueByName('Size') as TPDFInteger).Value:=GLobalXRefCount;
  IDict.AddString('Title',Infos.Title);
  IDict.AddString('Author',Infos.Author);
  IDict.AddString('Creator',Infos.ApplicationName);
  IDict.AddString('Producer',Infos.Producer);
  IDict.AddString('CreationDate',DateToPdfDate(Infos.CreationDate));
end;

procedure TPDFDocument.CreatePreferencesEntry;

var
  VDict: TPDFDictionary;

begin
  VDict:=CreateGlobalXRef.Dict;
  VDict.AddName('Type', 'ViewerPreferences');
  VDict.AddElement('FitWindow', CreateBoolean(True));
  VDict:=GlobalXRefByName('Catalog').Dict;
  VDict.AddReference('ViewerPreferences',GLobalXRefCount-1);
end;

function TPDFDocument.CreatePagesEntry(Parent: integer): integer;

var
  EDict,ADict: TPDFDictionary;

begin
  EDict:=CreateGlobalXRef.Dict;
  Result:=GLobalXRefCount-1;
  EDict.AddName('Type','Pages');
  EDict.AddElement('Kids',CreateArray);
  EDict.AddInteger('Count',0);
  if Parent=0 then
    GlobalXRefByName('Catalog').Dict.AddReference('Pages',Result)
  else
    begin
    EDict.AddReference('Parent',Parent);
    ADict:=GlobalXRefs[Parent].Dict;
    (ADict.ValueByName('Count') as TPDFInteger).Inc;
    (ADict.ValueByName('Kids') as TPDFArray).AddItem(CreateReference(Result));
    end;
end;

function TPDFDocument.CreatePageEntry(Parent, PageNum: integer): integer;
var

  PDict,ADict: TPDFDictionary;
  Arr : TPDFArray;
  PP : TPDFPage;

begin
  // add xref entry
  PP:=Pages[PageNum];
  PDict:=CreateGlobalXRef.Dict;
  PDict.AddName('Type','Page');
  PDict.AddReference('Parent',Parent);
  ADict:=GlobalXRefs[Parent].Dict;
  (ADict.ValueByName('Count') as TPDFInteger).Inc;
  (ADict.ValueByName('Kids') as TPDFArray).AddItem(CreateReference(GLobalXRefCount-1));
  Arr:=CreateArray;
  Arr.AddItem(CreateInteger(0));
  Arr.AddItem(CreateInteger(0));
  Arr.AddItem(CreateInteger(PP.Paper.W));
  Arr.AddItem(CreateInteger(PP.Paper.H));
  PDict.AddElement('MediaBox',Arr);
  ADict:=CreateDictionary;
  PDict.AddElement('Resources',ADict);
  Arr:=CreateArray; // procset
  ADict.AddElement('ProcSet',Arr);
  Arr.AddItem(CreateName('PDF'));
  Arr.AddItem(CreateName('Text'));
  Arr.AddItem(CreateName('ImageC'));
  if (Fonts.Count>0) then
    ADict.AddElement('Font',CreateDictionary);
  if PP.HasImages then
    ADict.AddElement('XObject', CreateDictionary);
  Result:=GLobalXRefCount-1;
end;

function TPDFDocument.CreateOutlines: integer;
var
  ODict: TPDFDictionary;

begin
  ODict:=CreateGlobalXRef.Dict;
  ODict.AddName('Type','Outlines');
  ODict.AddInteger('Count',0);
  Result:=GLobalXRefCount-1;
end;

function TPDFDocument.CreateOutlineEntry(Parent, SectNo, PageNo: integer; ATitle: string): integer;
var
  ODict: TPDFDictionary;
  S: String;

begin
  ODict:=CreateGlobalXRef.Dict;
  S:=ATitle;
  if (S='') then
    S:='Section '+IntToStr(SectNo);
  if (PageNo>-1) then
    S:=S+' Page '+IntToStr(PageNo);
  ODict.AddString('Title',S);
  ODict.AddReference('Parent',Parent);
  ODict.AddInteger('Count',0);
  ODict.AddElement('Dest', CreateArray);
  Result:=GLobalXRefCount-1;
end;

procedure TPDFDocument.AddFontNameToPages(const AName: String; ANum: Integer);

Var
  i: integer;
  ADict: TPDFDictionary;

begin
  for i:=1 to GLobalXRefCount-1 do
    begin
    ADict:=GlobalXRefs[i].Dict;
    if (ADict.ElementCount>0) then
      if (ADict.Values[0] is TPDFName) and ((ADict.Values[0] as TPDFName).Name= 'Page') then
        begin
        ADict:=ADict.ValueByName('Resources') as TPDFDictionary;
        ADict:=ADict.ValueByName('Font') as TPDFDictionary;
        ADict.AddReference(AName,ANum);
        end;
    end;
end;

procedure TPDFDocument.CreateStdFont(EmbeddedFontName: string; EmbeddedFontNum: integer);
var
  FDict: TPDFDictionary;
  N: TPDFName;
begin
  // add xref entry
  FDict := CreateGlobalXRef.Dict;
  FDict.AddName('Type', 'Font');
  FDict.AddName('Subtype', 'Type1');
  FDict.AddName('Encoding', 'WinAnsiEncoding');
  FDict.AddInteger('FirstChar', 32);
  FDict.AddInteger('LastChar', 255);
  FDict.AddName('BaseFont', EmbeddedFontName);
  N := CreateName('F'+IntToStr(EmbeddedFontNum));
  FDict.AddElement('Name',N);
  AddFontNameToPages(N.Name,GLobalXRefCount-1);
  // add font reference to global page dictionary
  FontFiles.Add('');
end;

function TPDFDocument.LoadFont(AFont: TPDFFont): boolean;
var
  lFName: string;
  s: string;
begin
  Result := False;
  if ExtractFilePath(AFont.FontFile) <> '' then
    // assume AFont.FontFile is the full path to the TTF file
    lFName := AFont.FontFile
  else
    // assume it's just a TTF filename
    lFName := IncludeTrailingPathDelimiter(FontDirectory)+AFont.FontFile;

  if FileExists(lFName) then
  begin
    s := LowerCase(ExtractFileExt(lFName));
    Result := (s = '.ttf') or (s = '.otf');
  end
  else
    Raise EPDF.CreateFmt(rsErrReportFontFileMissing, [lFName]);
end;

procedure TPDFDocument.CreateTTFFont(const EmbeddedFontNum: integer);
var
  FDict: TPDFDictionary;
  N: TPDFName;
  Arr: TPDFArray;
begin
  // add xref entry
  FDict := CreateGlobalXRef.Dict;
  FDict.AddName('Type', 'Font');
  FDict.AddName('Subtype', 'Type0');
  FDict.AddName('BaseFont', Fonts[EmbeddedFontNum].Name);
  FDict.AddName('Encoding', 'Identity-H');
  // add name element to font dictionary
  N:=CreateName('F'+IntToStr(EmbeddedFontNum));
  FDict.AddElement('Name',N);
  AddFontNameToPages(N.Name,GlobalXRefCount-1);
  CreateTTFDescendantFont(EmbeddedFontNum);
  Arr := CreateArray;
  FDict.AddElement('DescendantFonts', Arr);
  Arr.AddItem(TPDFReference.Create(self, GlobalXRefCount-4));
  CreateToUnicode(EmbeddedFontNum);
  FDict.AddReference('ToUnicode', GlobalXRefCount-1);
  FontFiles.Add(Fonts[EmbeddedFontNum].FTrueTypeFile.Filename);
end;

procedure TPDFDocument.CreateTTFDescendantFont(const EmbeddedFontNum: integer);
var
  FDict: TPDFDictionary;
  Arr: TPDFArray;
begin
  // add xref entry
  FDict := CreateGlobalXRef.Dict;
  FDict.AddName('Type', 'Font');
  FDict.AddName('Subtype', 'CIDFontType2');
  FDict.AddName('BaseFont', Fonts[EmbeddedFontNum].Name);

  CreateTTFCIDSystemInfo;
  FDict.AddReference('CIDSystemInfo', GlobalXRefCount-1);

  // add fontdescriptor reference to font dictionary
  CreateFontDescriptor(EmbeddedFontNum);
  FDict.AddReference('FontDescriptor',GlobalXRefCount-2);

  Arr := CreateArray;
  FDict.AddElement('W',Arr);
  Arr.AddItem(TPDFTrueTypeCharWidths.Create(self, EmbeddedFontNum));
end;

procedure TPDFDocument.CreateTTFCIDSystemInfo;
var
  FDict: TPDFDictionary;
begin
  FDict := CreateGlobalXRef.Dict;
  FDict.AddString('Registry', 'Adobe');
  FDict.AddString('Ordering', 'Identity');
  FDict.AddInteger('Supplement', 0);
end;

procedure TPDFDocument.CreateTp1Font(const EmbeddedFontNum: integer);
begin
  Assert(EmbeddedFontNum<>-1);
end;

procedure TPDFDocument.CreateFontDescriptor(const EmbeddedFontNum: integer);
var
  Arr: TPDFArray;
  FDict: TPDFDictionary;
begin
  FDict:=CreateGlobalXRef.Dict;
  FDict.AddName('Type', 'FontDescriptor');
  FDict.AddName('FontName', Fonts[EmbeddedFontNum].Name);
  FDict.AddName('FontFamily', Fonts[EmbeddedFontNum].FTrueTypeFile.FamilyName);
  FDict.AddInteger('Ascent', Fonts[EmbeddedFontNum].FTrueTypeFile.Ascender);
  FDict.AddInteger('Descent', Fonts[EmbeddedFontNum].FTrueTypeFile.Descender);
  FDict.AddInteger('CapHeight', Fonts[EmbeddedFontNum].FTrueTypeFile.CapHeight);
  FDict.AddInteger('Flags', 32);
  Arr:=CreateArray;
  FDict.AddElement('FontBBox',Arr);
  Arr.AddIntArray(Fonts[EmbeddedFontNum].FTrueTypeFile.BBox);
  FDict.AddInteger('ItalicAngle',Fonts[EmbeddedFontNum].FTrueTypeFile.ItalicAngle);
  FDict.AddInteger('StemV', Fonts[EmbeddedFontNum].FTrueTypeFile.StemV);
  FDict.AddInteger('MissingWidth', Fonts[EmbeddedFontNum].FTrueTypeFile.MissingWidth);
  CreateFontFileEntry(EmbeddedFontNum);
  FDict.AddReference('FontFile2',GlobalXRefCount-1);
end;

procedure TPDFDocument.CreateToUnicode(const EmbeddedFontNum: integer);
var
  lXRef: TPDFXRef;
begin
  lXRef := CreateGlobalXRef;
  lXRef.FStream := CreateStream(True);
  lXRef.FStream.AddItem(TPDFToUnicode.Create(self, EmbeddedFontNum));
end;

procedure TPDFDocument.CreateFontFileEntry(const EmbeddedFontNum: integer);
var
  FDict: TPDFDictionary;
begin
  FDict:=CreateGlobalXRef.Dict;
  if poCompressFonts in Options then
    FDict.AddName('Filter','FlateDecode');
  FDict.AddInteger('Length1 '+IntToStr(EmbeddedFontNum), Fonts[EmbeddedFontNum].FTrueTypeFile.OriginalSize);
end;

procedure TPDFDocument.CreateImageEntry(ImgWidth, ImgHeight, NumImg: integer);

var
  N: TPDFName;
  IDict,ADict: TPDFDictionary;
  i: integer;

begin
  IDict:=CreateGlobalXRef.Dict;
  IDict.AddName('Type','XObject');
  IDict.AddName('Subtype','Image');
  IDict.AddInteger('Width',ImgWidth);
  IDict.AddInteger('Height',ImgHeight);
  IDict.AddName('ColorSpace','DeviceRGB');
  IDict.AddInteger('BitsPerComponent',8);
  N:=CreateName('I'+IntToStr(NumImg)); // Needed later
  IDict.AddElement('Name',N);
  for i:=1 to GLobalXRefCount-1 do
    begin
    ADict:=GlobalXRefs[i].Dict;
    if ADict.ElementCount > 0 then
      begin
      if (ADict.Values[0] is TPDFName) and ((ADict.Values[0] as TPDFName).Name='Page') then
        begin
        ADict:=ADict.ValueByName('Resources') as TPDFDictionary;
        ADict:=TPDFDictionary(ADict.FindValue('XObject'));
        if Assigned(ADict) then
          begin
          ADict.AddReference(N.Name,GLobalXRefCount-1);
          end;
        end;
      end;
    end;
end;

function TPDFDocument.CreateContentsEntry: integer;
var
  Contents: TPDFXRef;

begin
  Contents:=CreateGlobalXRef;
  Contents.FStream:=CreateStream(False);
  Result:=GlobalXRefCount-1;
  GlobalXrefs[GlobalXRefCount-2].Dict.AddReference('Contents',Result);
end;

procedure TPDFDocument.CreatePageStream(APage : TPDFPage; PageNum: integer);

var
  i: integer;
  PageStream : TPDFStream;

begin
  PageStream:=GlobalXRefs[PageNum].FStream;
  for i:=0 to APage.ObjectCount-1 do
    begin
    PageStream.AddItem(APage.Objects[i]);
    end;
end;

function TPDFDocument.CreateGlobalXRef: TPDFXRef;
begin
  Result:=Self.CreateXRef;
  AddGlobalXRef(Result);
end;

function TPDFDocument.AddGlobalXRef(AXRef: TPDFXRef): Integer;
begin
  Result:=FGlobalXRefs.Add(AXRef);
end;


function TPDFDocument.GlobalXRefByName(const AName: String): TPDFXRef;
begin
  Result:=FindGlobalXRef(AName);
  if Result=Nil then
    Raise EPDF.CreateFmt(SErrNoGlobalDict,[AName]);
end;

constructor TPDFDocument.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FLineStyleDefs:=TPDFLineStyleDefs.Create(TPDFLineStyleDef);
  FSections:=TPDFSectionList.Create(TPDFSection);
  FFontFiles:=TStringList.Create;
  FFonts:=TPDFFontDefs.Create(TPDFFont);
  FInfos:=TPDFInfos.Create;
  FImages:=TPDFImages.Create(TPDFImageItem);
  FPages:=TPDFPages.Create(Self);
  FPreferences:=True;
  FPageLayout:=lSingle;
  FDefaultPaperType:=ptA4;
  FDefaultOrientation:=ppoPortrait;
  FZoomValue:='100';
  FOptions := [poCompressFonts];
end;

procedure TPDFDocument.StartDocument;

begin
  CreateRefTable;
  CreateTrailer;
  FCatalogue:=CreateCatalogEntry;
  CreateInfoEntry;
  CreatePreferencesEntry;
  if (FontDirectory = '') then
    FontDirectory:=ExtractFilePath(ParamStr(0));
end;

destructor TPDFDocument.Destroy;

begin
  FreeAndNil(FLineStyleDefs);
  FreeAndNil(FInfos);
  FreeAndNil(FFonts);
  FreeAndNil(FImages);
  FreeAndNil(FFontFiles);
  FreeAndNil(FPages);
  FreeAndNil(FSections);
  Trailer.Free;
  FGlobalXRefs.Free;
  inherited;
end;

function TPDFDocument.CreateSectionPageOutLine(const S: TPDFSection;
  const PageOutLine, PageIndex, NewPage, ParentOutline, NextOutline,
  PrevOutLine: Integer): Integer; // Return pages ID

Var
  ADict: TPDFDictionary;
  Arr : TPDFArray;

begin
  ADict:=GlobalXRefs[ParentOutline].Dict;
  (ADict.ValueByName('Count') as TPDFInteger).Inc;
  // add page reference to outline destination
  ADict:=GlobalXRefs[PageOutLine].Dict;
  Arr:=(ADict.ValueByName('Dest') as TPDFArray);
  Arr.AddItem(CreateReference(NewPage));
  Arr.AddItem(CreateName('Fit'));
  Result:=PrevOutline;
  if PageIndex=0 then
    begin
    GlobalXRefs[ParentOutline].Dict.AddReference('First',GLobalXRefCount-1);
    Result:=GLobalXRefCount-1;
    // add page reference to parent outline destination
    ADict:=GlobalXRefs[ParentOutline].Dict;
    Arr:=(ADict.ValueByName('Dest') as TPDFArray);
    Arr.AddItem(CreateReference(NewPage));
    Arr.AddItem(CreateName('Fit'));
    end
  else
    begin
    GlobalXRefs[NextOutline].Dict.AddReference('Next',GLobalXRefCount-1);
    GlobalXRefs[PageOutLine].Dict.AddReference('Prev',PrevOutline);
    if (PageIndex<S.PageCount) then
      Result:=GLobalXRefCount-1;
    end;
  if PageIndex=S.PageCount-1 then
    GlobalXRefs[ParentOutline].Dict.AddReference('Last',GLobalXRefCount-1);
end;

function TPDFDocument.CreateSectionOutLine(const SectionIndex, OutLineRoot,
  ParentOutLine, NextSect, PrevSect: Integer): Integer; // Previous section

Var
  ADict: TPDFDictionary;

begin
  Result:=PrevSect;
  ADict:=GlobalXRefs[OutlineRoot].Dict;
  (ADict.ValueByName('Count') as TPDFInteger).Inc;
  if (SectionIndex=0) then
    begin
    GlobalXRefs[OutlineRoot].Dict.AddReference('First',GLobalXRefCount-1);
    Result:=GLobalXRefCount-1;
    end
  else
    begin
    GlobalXRefs[NextSect].Dict.AddReference('Next',GLobalXRefCount-1);
    GlobalXRefs[ParentOutline].Dict.AddReference('Prev', PrevSect);
    if (SectionIndex<Sections.Count-1) then
      Result:=GLobalXRefCount-1;
    end;
  if SectionIndex=Sections.Count-1 then
    GlobalXRefs[OutlineRoot].Dict.AddReference('Last',GLobalXRefCount-1);
end;

function TPDFDocument.CreateSectionsOutLine: Integer; // Parent page ID

var
  pc,j: integer;
  ParentOutline,TreeRoot,OutlineRoot : Integer;
  K,PageNum: integer;
  PageOutline, NextOutline, NextSect, NewPage, PrevOutline, PrevSect: integer;
  ADict: TPDFDictionary;
  Arr : TPDFArray;
  S : TPDFSection;

begin
  Result:=0;
  TreeRoot:=0;
  if (Sections.Count>1) then
    begin
    If (poOutline in Options) then
      begin
      OutlineRoot:=CreateOutlines;
      // add outline reference to catalog dictionary
      GlobalXRefs[Catalogue].Dict.AddReference('Outlines',GLobalXRefCount-1);
      // add useoutline element to catalog dictionary
      GlobalXRefs[Catalogue].Dict.AddName('PageMode','UseOutlines');
      end;
    TreeRoot:=CreatePagesEntry(Result);
    end
  else
    begin
    Result:=CreatePagesEntry(Result);
    TreeRoot:=Result;
    end;

  NextSect:=0;
  PrevSect:=0;
  PrevOutLine:=0;
  NextOutLine:=0;
  for J:=0 to Sections.Count-1 do
    begin
    S:=Sections[J];
    if (poOutline in options) then
      begin
      ParentOutline:=CreateOutlineEntry(OutlineRoot,j+1,-1,S.Title);
      PrevSect:=CreateSectionOutline(J,OutlineRoot,ParentOutLine,NextSect,PrevSect);
      NextSect:=ParentOutline;
      Result:=CreatePagesEntry(TreeRoot);
      end;
    for k:=0 to S.PageCount-1 do
      begin
      with S do
        NewPage:=CreatePageEntry(Result,K);
      // add zoom factor to catalog dictionary
      if (j=0) and (k=0) then
        begin
        ADict:=GlobalXRefByName('Catalog').Dict;
        Arr:=ADict.ValueByName('OpenAction') as TPDFArray;
        Arr.AddItem(CreateReference(GLobalXRefCount-1));
        Arr.AddItem(CreateName('XYZ null null '+TPDFObject.FloatStr(StrToInt(FZoomValue) / 100)));
        end;
      PageNum:=CreateContentsEntry; // pagenum = object number in the pdf file
      CreatePageStream(S.Pages[k],PageNum);
      if (Sections.Count>1) and (poOutline in Options) then
        begin
        PageOutLine:=CreateOutlineEntry(ParentOutline,j+1,k+1,S.Title);
        CreateSectionPageOutLine(S,PageOutLine,K,NewPage,ParentOutLine,NextOutLine,PrevOutLine);
        NextOutline:=PageOutLine;
        end;
    end;
  end;
  // update count in root parent pages dictionary
  ADict:=GlobalXRefs[TreeRoot].Dict;
  Pc:=0;
  For J:=0 to Sections.Count-1 do
    Inc(Pc,Sections[J].PageCount);
  (ADict.ValueByName('Count') as TPDFInteger).Value:=PC;
end;

procedure TPDFDocument.CreateFontEntries;
var
  i: integer;
  NumFont: integer;
  FontName: string;
begin
  // select the font type
  NumFont:=0;
  for i:=0 to Fonts.Count-1 do
    begin
    FontName := Fonts[i].Name;
    { Acrobat Reader expects us to be case sensitive. Other PDF viewers are case-insensitive. }
    if (FontName='Courier') or (FontName='Courier-Bold') or (FontName='Courier-Oblique') or (FontName='Courier-BoldOblique')
        or (FontName='Helvetica') or (FontName='Helvetica-Bold') or (FontName='Helvetica-Oblique') or (FontName='Helvetica-BoldOblique')
        or (FontName='Times-Roman') or (FontName='Times-Bold') or (FontName='Times-Italic') or (FontName='Times-BoldItalic')
        or (FontName='Symbol')
        or (FontName='Zapf Dingbats') then
    begin
      CreateStdFont(FontName, NumFont);
    end
    else if LoadFont(Fonts[i]) then
      CreateTtfFont(NumFont)
    else
      CreateTp1Font(NumFont);  // not implemented yet
    Inc(NumFont);
    end;
end;

procedure TPDFDocument.CreateImageEntries;

Var
  I : Integer;

begin
  for i:=0 to Images.Count-1 do
    CreateImageEntry(Images[i].Width,Images[i].Height,i);
end;

procedure TPDFDocument.SaveToStream(const AStream: TStream);

var
  i, XRefPos: integer;

begin
  CreateSectionsOutLine;
  CreateFontEntries;
  CreateImageEntries;
  (Trailer.ValueByName('Size') as TPDFInteger).Value:=GlobalXRefCount;
  AStream.Position:=0;
  TPDFObject.WriteString(PDF_VERSION+CRLF, AStream);
  TPDFObject.WriteString(PDF_BINARY_BLOB+CRLF, AStream); // write some binary data as recommended in PDF Spec section 3.4.1 (File Header)
  // write numbered indirect objects
  for i:=1 to GlobalXRefCount-1 do
    begin
    XRefPos:=AStream.Position;
    WriteObject(i, AStream);
    GlobalXRefs[i].Offset:=XRefPos;
    end;
  XRefPos:=AStream.Position;
  // write xref table
  TPDFObject.WriteString('xref'+CRLF+'0 '+IntToStr(GlobalXRefCount)+CRLF, AStream);
  with GlobalXRefs[0] do
    TPDFObject.WriteString(FormatPDFInt(Offset, 10)+' '+FormatPDFInt(PDF_MAX_GEN_NUM, 5)+' f'+CRLF, AStream);
  WriteXRefTable(AStream);
  // write trailer
  TPDFObject.WriteString('trailer'+CRLF, AStream);
  Trailer.Write(AStream);
  // write offset of last xref table
  TPDFObject.WriteString(CRLF+'startxref'+CRLF+IntToStr(XRefPos)+CRLF, AStream);
  TPDFObject.WriteString(PDF_FILE_END, AStream);
end;

function TPDFDocument.CreateEmbeddedFont(AFontIndex, AFontSize : Integer): TPDFEmbeddedFont;
begin
  Result:=TPDFEmbeddedFont.Create(Self,AFontIndex,IntToStr(AFontSize))
end;

function TPDFDocument.CreateText(X, Y: TPDFFloat; AText: AnsiString; const AFontIndex: integer): TPDFText;
begin
  {$ifdef gdebug}
  writeln('TPDFDocument.CreateText( AnsiString ) ', AFontIndex);
  {$endif}
  Result:=TPDFText.Create(Self,X,Y,AText,AFontIndex);
end;

function TPDFDocument.CreateText(X, Y: TPDFFloat; AText: UTF8String; const AFontIndex: integer): TPDFUTF8Text;
begin
  {$ifdef gdebug}
  writeln('TPDFDocument.CreateText( UTF8String ) ', AFontIndex);
  {$endif}
  Result := TPDFUTF8Text.Create(Self,X,Y,AText,AFontIndex);
end;

function TPDFDocument.CreateRectangle(const X,Y,W,H, ALineWidth: TPDFFloat; const AFill, AStroke: Boolean): TPDFRectangle;
begin
  Result:=TPDFRectangle.Create(Self,X,Y,W,H,ALineWidth,AFill, AStroke);
end;

function TPDFDocument.CreateColor(AColor: TARGBColor; AStroke: Boolean): TPDFColor;
begin
  Result:=TPDFColor.Create(Self,AStroke,AColor);
end;

function TPDFDocument.CreateBoolean(AValue: Boolean): TPDFBoolean;
begin
  Result:=TPDFBoolean.Create(Self,AValue);
end;

function TPDFDocument.CreateInteger(AValue: Integer): TPDFInteger;
begin
  Result:=TPDFInteger.Create(Self,AValue);
end;

function TPDFDocument.CreateReference(AValue: Integer): TPDFReference;
begin
  Result:=TPDFReference.Create(Self,AValue);
end;

function TPDFDocument.CreateString(const AValue: String): TPDFString;
begin
  Result:=TPDFString.Create(Self,AValue);
end;

function TPDFDocument.CreateUTF8String(const AValue: UTF8String; const AFontIndex: integer): TPDFUTF8String;
begin
  Result := TPDFUTF8String.Create(self, AValue, AFontIndex);
end;

function TPDFDocument.CreateLineStyle(APenStyle: TPDFPenStyle): TPDFLineStyle;
begin
  Result:=TPDFLineStyle.Create(Self,APenStyle,0)
end;

function TPDFDocument.CreateName(AValue: String): TPDFName;
begin
  Result:=TPDFName.Create(Self,AValue);
end;

function TPDFDocument.CreateStream(OwnsObjects : Boolean = True): TPDFStream;
begin
  Result:=TPDFStream.Create(Self,OwnsObjects);
end;

function TPDFDocument.CreateDictionary: TPDFDictionary;
begin
  Result:=TPDFDictionary.Create(Self);
end;

function TPDFDocument.CreateXRef: TPDFXRef;
begin
  Result:=TPDFXRef.Create(Self);
end;

function TPDFDocument.CreateArray: TPDFArray;
begin
  Result:=TPDFArray.Create(Self);
end;

function TPDFDocument.CreateImage(const ALeft, ABottom: TPDFFloat; AWidth,
  AHeight, ANumber: integer): TPDFImage;
begin
  Result:=TPDFImage.Create(Self,ALeft,ABottom,AWidth,AHeight,ANumber);
end;

function TPDFDocument.AddFont(AName: String; AColor : TARGBColor = clBlack): Integer;
var
  F: TPDFFont;
  i: integer;
begin
  { reuse existing font definition if it exists }
  for i := 0 to Fonts.Count-1 do
  begin
    if Fonts[i].Name = AName then
    begin
      Result := i;
      Exit;
    end;
  end;
  F := Fonts.AddFontDef;
  F.Name := AName;
  F.Color := AColor;
  F.IsStdFont := True;
  Result := Fonts.Count-1;
end;

function TPDFDocument.AddFont(AFontFile: String; AName: String; AColor: TARGBColor): Integer;
var
  F: TPDFFont;
  i: integer;
  lFName: string;
begin
  { reuse existing font definition if it exists }
  for i := 0 to Fonts.Count-1 do
  begin
    if Fonts[i].Name = AName then
    begin
      Result := i;
      Exit;
    end;
  end;
  F := Fonts.AddFontDef;
  if ExtractFilePath(AFontFile) <> '' then
    // assume AFontFile is the full path to the TTF file
    lFName := AFontFile
  else
    // assume it's just the TTF filename
    lFName := IncludeTrailingPathDelimiter(FontDirectory)+AFontFile;
  F.FontFile := lFName;
  F.Name := AName;
  F.Color := AColor;
  F.IsStdFont := False;
  Result := Fonts.Count-1;
end;

function TPDFDocument.AddLineStyleDef(ALineWidth: TPDFFloat; AColor: TARGBColor;
  APenStyle: TPDFPenStyle): Integer;

Var
  F : TPDFLineStyleDef;

begin
  F:=FLineStyleDefs.AddLineStyleDef;
  F.LineWidth:=ALineWidth;
  F.Color:=AColor;
  F.PenStyle:=APenStyle;
  Result:=FLineStyleDefs.Count-1;
end;


end.

