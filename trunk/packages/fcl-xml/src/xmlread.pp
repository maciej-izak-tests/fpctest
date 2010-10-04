{
    This file is part of the Free Component Library

    XML reading routines.
    Copyright (c) 1999-2000 by Sebastian Guenther, sg@freepascal.org
    Modified in 2006 by Sergei Gorelkin, sergei_gorelkin@mail.ru

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

unit XMLRead;

{$ifdef fpc}
{$MODE objfpc}{$H+}
{$endif}

interface

uses
  SysUtils, Classes, DOM;

type
  TErrorSeverity = (esWarning, esError, esFatal);

  EXMLReadError = class(Exception)
  private
    FSeverity: TErrorSeverity;
    FErrorMessage: string;
    FLine: Integer;
    FLinePos: Integer;
  public
    property Severity: TErrorSeverity read FSeverity;
    property ErrorMessage: string read FErrorMessage;
    property Line: Integer read FLine;
    property LinePos: Integer read FLinePos;
  end;

procedure ReadXMLFile(out ADoc: TXMLDocument; const AFilename: String); overload;
procedure ReadXMLFile(out ADoc: TXMLDocument; var f: Text); overload;
procedure ReadXMLFile(out ADoc: TXMLDocument; f: TStream); overload;
procedure ReadXMLFile(out ADoc: TXMLDocument; f: TStream; const ABaseURI: String); overload;

procedure ReadXMLFragment(AParentNode: TDOMNode; const AFilename: String); overload;
procedure ReadXMLFragment(AParentNode: TDOMNode; var f: Text); overload;
procedure ReadXMLFragment(AParentNode: TDOMNode; f: TStream); overload;
procedure ReadXMLFragment(AParentNode: TDOMNode; f: TStream; const ABaseURI: String); overload;

procedure ReadDTDFile(out ADoc: TXMLDocument; const AFilename: String);  overload;
procedure ReadDTDFile(out ADoc: TXMLDocument; var f: Text); overload;
procedure ReadDTDFile(out ADoc: TXMLDocument; f: TStream); overload;
procedure ReadDTDFile(out ADoc: TXMLDocument; f: TStream; const ABaseURI: String); overload;

type
  TDOMParseOptions = class(TObject)
  private
    FValidate: Boolean;
    FPreserveWhitespace: Boolean;
    FExpandEntities: Boolean;
    FIgnoreComments: Boolean;
    FCDSectionsAsText: Boolean;
    FResolveExternals: Boolean;
    FNamespaces: Boolean;
    FDisallowDoctype: Boolean;
    FCanonical: Boolean;
    FMaxChars: Cardinal;
    function GetCanonical: Boolean;
    procedure SetCanonical(aValue: Boolean);
  public
    property Validate: Boolean read FValidate write FValidate;
    property PreserveWhitespace: Boolean read FPreserveWhitespace write FPreserveWhitespace;
    property ExpandEntities: Boolean read FExpandEntities write FExpandEntities;
    property IgnoreComments: Boolean read FIgnoreComments write FIgnoreComments;
    property CDSectionsAsText: Boolean read FCDSectionsAsText write FCDSectionsAsText;
    property ResolveExternals: Boolean read FResolveExternals write FResolveExternals;
    property Namespaces: Boolean read FNamespaces write FNamespaces;
    property DisallowDoctype: Boolean read FDisallowDoctype write FDisallowDoctype;
    property MaxChars: Cardinal read FMaxChars write FMaxChars;
    property CanonicalForm: Boolean read GetCanonical write SetCanonical;
  end;

  // NOTE: DOM 3 LS ACTION_TYPE enumeration starts at 1
  TXMLContextAction = (
    xaAppendAsChildren = 1,
    xaReplaceChildren,
    xaInsertBefore,
    xaInsertAfter,
    xaReplace);

  TXMLErrorEvent = procedure(Error: EXMLReadError) of object;

  TXMLInputSource = class(TObject)
  private
    FStream: TStream;
    FStringData: string;
    FBaseURI: WideString;
    FSystemID: WideString;
    FPublicID: WideString;
//    FEncoding: string;
  public
    constructor Create(AStream: TStream); overload;
    constructor Create(const AStringData: string); overload;
    property Stream: TStream read FStream;
    property StringData: string read FStringData;
    property BaseURI: WideString read FBaseURI write FBaseURI;
    property SystemID: WideString read FSystemID write FSystemID;
    property PublicID: WideString read FPublicID write FPublicID;
//    property Encoding: string read FEncoding write FEncoding;
  end;

  TDOMParser = class(TObject)
  private
    FOptions: TDOMParseOptions;
    FOnError: TXMLErrorEvent;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(Src: TXMLInputSource; out ADoc: TXMLDocument);
    procedure ParseUri(const URI: WideString; out ADoc: TXMLDocument);
    function ParseWithContext(Src: TXMLInputSource; Context: TDOMNode;
      Action: TXMLContextAction): TDOMNode;
    property Options: TDOMParseOptions read FOptions;
    property OnError: TXMLErrorEvent read FOnError write FOnError;
  end;

  TDecoder = record
    Context: Pointer;
    Decode: function(Context: Pointer; InBuf: PChar; var InCnt: Cardinal; OutBuf: PWideChar; var OutCnt: Cardinal): Integer; stdcall;
    Cleanup: procedure(Context: Pointer); stdcall;
  end;

  TGetDecoderProc = function(const AEncoding: string; out Decoder: TDecoder): Boolean; stdcall;

procedure RegisterDecoder(Proc: TGetDecoderProc);

// =======================================================

implementation

uses
  UriParser, xmlutils;

const
  PubidChars: TSetOfChar = [' ', #13, #10, 'a'..'z', 'A'..'Z', '0'..'9',
    '-', '''', '(', ')', '+', ',', '.', '/', ':', '=', '?', ';', '!', '*',
    '#', '@', '$', '_', '%'];

type
  TDOMNotationEx = class(TDOMNotation);
  TDOMDocumentTypeEx = class(TDOMDocumentType);
  TDOMTopNodeEx = class(TDOMNode_TopLevel);
  TDOMElementDef = class;

  TDTDSubsetType = (dsNone, dsInternal, dsExternal);

  // This may be augmented with ByteOffset, UTF8Offset, etc.
  TLocation = record
    Line: Integer;
    LinePos: Integer;
  end;

  TDOMEntityEx = class(TDOMEntity)
  protected
    FExternallyDeclared: Boolean;
    FPrefetched: Boolean;
    FResolved: Boolean;
    FOnStack: Boolean;
    FBetweenDecls: Boolean;
    FIsPE: Boolean;
    FReplacementText: DOMString;
    FStartLocation: TLocation;
    FCharCount: Cardinal;
  end;

  TXMLReader = class;

  TXMLCharSource = class(TObject)
  private
    FBuf: PWideChar;
    FBufEnd: PWideChar;
    FReader: TXMLReader;
    FParent: TXMLCharSource;
    FEntity: TObject;   // weak reference
    FLineNo: Integer;
    LFPos: PWideChar;
    FXML11Rules: Boolean;
    FSystemID: WideString;
    FCharCount: Cardinal;
    FStartNesting: Integer;
    function GetSystemID: WideString;
  protected
    function Reload: Boolean; virtual;
  public
    DTDSubsetType: TDTDSubsetType;
    constructor Create(const AData: WideString);
    procedure NextChar;
    procedure NewLine; virtual;
    function SkipUntil(var ToFill: TWideCharBuf; const Delim: TSetOfChar;
      wsflag: PBoolean = nil): WideChar; virtual;
    procedure Initialize; virtual;
    function SetEncoding(const AEncoding: string): Boolean; virtual;
    function Matches(const arg: WideString): Boolean;
    property SystemID: WideString read GetSystemID write FSystemID;
  end;

  TXMLDecodingSource = class(TXMLCharSource)
  private
    FCharBuf: PChar;
    FCharBufEnd: PChar;
    FBufStart: PWideChar;
    FDecoder: TDecoder;
    FHasBOM: Boolean;
    FFixedUCS2: string;
    FBufSize: Integer;
    procedure DecodingError(const Msg: string);
  protected
    function Reload: Boolean; override;
    procedure FetchData; virtual;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function SetEncoding(const AEncoding: string): Boolean; override;
    procedure NewLine; override;
    function SkipUntil(var ToFill: TWideCharBuf; const Delim: TSetOfChar;
      wsflag: PBoolean = nil): WideChar; override;
    procedure Initialize; override;
  end;

  TXMLStreamInputSource = class(TXMLDecodingSource)
  private
    FAllocated: PChar;
    FStream: TStream;
    FCapacity: Integer;
    FOwnStream: Boolean;
    FEof: Boolean;
  public
    constructor Create(AStream: TStream; AOwnStream: Boolean);
    destructor Destroy; override;
    procedure FetchData; override;
  end;

  TXMLFileInputSource = class(TXMLDecodingSource)
  private
    FFile: ^Text;
    FString: string;
    FTmp: string;
  public
    constructor Create(var AFile: Text);
    procedure FetchData; override;
  end;

  PForwardRef = ^TForwardRef;
  TForwardRef = record
    Value: WideString;
    Loc: TLocation;
  end;

  TCPType = (ctName, ctChoice, ctSeq);
  TCPQuant = (cqOnce, cqZeroOrOnce, cqZeroOrMore, cqOnceOrMore);

  TContentParticle = class(TObject)
  private
    FParent: TContentParticle;
    FChildren: TFPList;
    FIndex: Integer;
    function GetChildCount: Integer;
    function GetChild(Index: Integer): TContentParticle;
  public
    CPType: TCPType;
    CPQuant: TCPQuant;
    Def: TDOMElementDef;
    destructor Destroy; override;
    function Add: TContentParticle;
    function IsRequired: Boolean;
    function FindFirst(aDef: TDOMElementDef): TContentParticle;
    function FindNext(aDef: TDOMElementDef; ChildIdx: Integer): TContentParticle;
    function MoreRequired(ChildIdx: Integer): Boolean;
    property ChildCount: Integer read GetChildCount;
    property Children[Index: Integer]: TContentParticle read GetChild;
  end;

  TElementValidator = object
    FElement: TDOMElement;
    FElementDef: TDOMElementDef;
    FCurCP: TContentParticle;
    FFailed: Boolean;
    function IsElementAllowed(Def: TDOMElementDef): Boolean;
    function Incomplete: Boolean;
  end;

  TXMLReadState = (rsProlog, rsDTD, rsRoot, rsEpilog);

  TElementContentType = (
    ctUndeclared,
    ctAny,
    ctEmpty,
    ctMixed,
    ctChildren
  );

  TCheckNameFlags = set of (cnOptional, cnToken);
  
  TPrefixedAttr = record
    Attr: TDOMAttr;
    PrefixLen: Integer;  // to avoid recalculation
  end;

  TLiteralType = (ltPlain, ltAttr, ltTokAttr, ltPubid, ltEntity);

  TXMLReader = class
  private
    FSource: TXMLCharSource;
    FCtrl: TDOMParser;
    FXML11: Boolean;
    FState: TXMLReadState;
    FHavePERefs: Boolean;
    FInsideDecl: Boolean;
    FValue: TWideCharBuf;
    FEntityValue: TWideCharBuf;
    FName: TWideCharBuf;
    FTokenStart: TLocation;
    FStandalone: Boolean;          // property of Doc ?
    FNamePages: PByteArray;
    FDocType: TDOMDocumentTypeEx;  // a shortcut
    FPEMap: TDOMNamedNodeMap;
    FIDRefs: TFPList;
    FNotationRefs: TFPList;
    FCurrContentType: TElementContentType;
    FSaViolation: Boolean;
    FDTDStartPos: PWideChar;
    FIntSubset: TWideCharBuf;
    FAttrTag: Cardinal;
    FOwnsDoctype: Boolean;
    FDTDProcessed: Boolean;

    FNSHelper: TNSSupport;
    FWorkAtts: array of TPrefixedAttr;
    FNsAttHash: TDblHashArray;
    FStdPrefix_xml: PHashItem;
    FStdPrefix_xmlns: PHashItem;

    FColonPos: Integer;
    FValidate: Boolean;            // parsing options, copy of FCtrl.Options
    FPreserveWhitespace: Boolean;
    FExpandEntities: Boolean;
    FIgnoreComments: Boolean;
    FCDSectionsAsText: Boolean;
    FResolveExternals: Boolean;
    FNamespaces: Boolean;
    FDisallowDoctype: Boolean;
    FCanonical: Boolean;
    FMaxChars: Cardinal;

    procedure SkipQuote(out Delim: WideChar; required: Boolean = True);
    procedure Initialize(ASource: TXMLCharSource);
    procedure EntityToSource(AEntity: TDOMEntityEx; out Src: TXMLCharSource);
    function ContextPush(AEntity: TDOMEntityEx): Boolean;
    function ContextPop(Forced: Boolean = False): Boolean;
    procedure XML11_BuildTables;
    function ParseQuantity: TCPQuant;
    procedure StoreLocation(out Loc: TLocation);
    function ValidateAttrSyntax(AttrDef: TDOMAttrDef; const aValue: WideString): Boolean;
    procedure ValidateAttrValue(Attr: TDOMAttr; const aValue: WideString);
    procedure AddForwardRef(aList: TFPList; Buf: PWideChar; Length: Integer);
    procedure ClearRefs(aList: TFPList);
    procedure ValidateIdRefs;
    procedure StandaloneError(LineOffs: Integer = 0);
    procedure CallErrorHandler(E: EXMLReadError);
    function  FindOrCreateElDef: TDOMElementDef;
    function  SkipUntilSeq(const Delim: TSetOfChar; c1: WideChar; c2: WideChar = #0): Boolean;
    procedure CheckMaxChars;
  protected
    FCursor: TDOMNode_WithChildren;
    FNesting: Integer;
    FValidator: array of TElementValidator;

    procedure DoError(Severity: TErrorSeverity; const descr: string; LineOffs: Integer=0);
    procedure DoErrorPos(Severity: TErrorSeverity; const descr: string;
      const ErrPos: TLocation);
    procedure FatalError(const descr: String; LineOffs: Integer=0); overload;
    procedure FatalError(const descr: string; const args: array of const; LineOffs: Integer=0); overload;
    procedure FatalError(Expected: WideChar); overload;
    function  SkipWhitespace(PercentAloneIsOk: Boolean = False): Boolean;
    function  SkipS(required: Boolean = False): Boolean;
    procedure ExpectWhitespace;
    procedure ExpectString(const s: String);
    procedure ExpectChar(wc: WideChar);
    function  CheckForChar(c: WideChar): Boolean;

    procedure RaiseNameNotFound;
    function  CheckName(aFlags: TCheckNameFlags = []): Boolean;
    procedure CheckNCName;
    function  ExpectName: WideString;                                   // [5]
    function ParseLiteral(var ToFill: TWideCharBuf; aType: TLiteralType;
      Required: Boolean; Normalized: PBoolean = nil): Boolean;
    procedure ExpectAttValue;                                           // [10]
    procedure ParseComment;                                             // [15]
    procedure ParsePI;                                                  // [16]
    procedure ParseXmlOrTextDecl(TextDecl: Boolean);
    procedure ExpectEq;
    procedure ParseDoctypeDecl;                                         // [28]
    procedure ParseMarkupDecl;                                          // [29]
    procedure ParseStartTag;                                            // [39]
    procedure ParseEndTag;                                              // [42]
    procedure DoEndElement(ErrOffset: Integer);
    procedure ParseAttribute(Elem: TDOMElement; ElDef: TDOMElementDef);
    procedure ParseContent;                                             // [43]
    function  ResolvePredefined: Boolean;
    function  EntityCheck(NoExternals: Boolean = False): TDOMEntityEx;
    procedure AppendReference(AEntity: TDOMEntityEx);
    function PrefetchEntity(AEntity: TDOMEntityEx): Boolean;
    procedure StartPE;
    function  ParseRef(var ToFill: TWideCharBuf): Boolean;              // [67]
    function  ParseExternalID(out SysID, PubID: WideString;             // [75]
      SysIdOptional: Boolean): Boolean;

    procedure BadPENesting(S: TErrorSeverity = esError);
    procedure ParseEntityDecl;
    procedure ParseAttlistDecl;
    procedure ExpectChoiceOrSeq(CP: TContentParticle);
    procedure ParseElementDecl;
    procedure ParseNotationDecl;
    function ResolveEntity(const ASystemID, APublicID, ABaseURI: WideString; out Source: TXMLCharSource): Boolean;
    procedure ProcessDefaultAttributes(Element: TDOMElement; Map: TDOMNamedNodeMap);
    procedure ProcessNamespaceAtts(Element: TDOMElement);
    procedure AddBinding(Attr: TDOMAttr; PrefixPtr: PWideChar; PrefixLen: Integer);

    procedure PushVC(aElement: TDOMElement; aElDef: TDOMElementDef);
    procedure PopVC;
    procedure UpdateConstraints;
    procedure ValidateDTD;
    procedure ValidateRoot;
    procedure ValidationError(const Msg: string; const args: array of const; LineOffs: Integer = -1);
    procedure DoAttrText(ch: PWideChar; Count: Integer);
    procedure DTDReloadHook;
    procedure ConvertSource(SrcIn: TXMLInputSource; out SrcOut: TXMLCharSource);
    // Some SAX-alike stuff (at a very early stage)
    procedure DoText(ch: PWideChar; Count: Integer; Whitespace: Boolean=False);
    procedure DoComment(ch: PWideChar; Count: Integer);
    procedure DoCDSect(ch: PWideChar; Count: Integer);
    procedure DoNotationDecl(const aName, aPubID, aSysID: WideString);
  public
    doc: TDOMDocument;
    constructor Create; overload;
    constructor Create(AParser: TDOMParser); overload;
    destructor Destroy; override;
    procedure ProcessXML(ASource: TXMLCharSource);                // [1]
    procedure ProcessFragment(ASource: TXMLCharSource; AOwner: TDOMNode);
    procedure ProcessDTD(ASource: TXMLCharSource);               // ([29])
  end;

  // Attribute/Element declarations

  TDOMElementDef = class(TDOMElement)
  public
    FExternallyDeclared: Boolean;
    ContentType: TElementContentType;
    IDAttr: TDOMAttrDef;
    NotationAttr: TDOMAttrDef;
    RootCP: TContentParticle;
    destructor Destroy; override;
  end;

const
  NullLocation: TLocation = (Line: 0; LinePos: 0);

{ Decoders }

var
  Decoders: array of TGetDecoderProc;

procedure RegisterDecoder(Proc: TGetDecoderProc);
var
  L: Integer;
begin
  L := Length(Decoders);
  SetLength(Decoders, L+1);
  Decoders[L] := Proc;
end;

function FindDecoder(const AEncoding: string; out Decoder: TDecoder): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(Decoders) do
    if Decoders[I](AEncoding, Decoder) then
    begin
      Result := True;
      Exit;
    end;
end;


function Is_8859_1(const AEncoding: string): Boolean;
begin
  Result := SameText(AEncoding, 'ISO-8859-1') or
            SameText(AEncoding, 'ISO_8859-1') or
            SameText(AEncoding, 'latin1') or
            SameText(AEncoding, 'iso-ir-100') or
            SameText(AEncoding, 'l1') or
            SameText(AEncoding, 'IBM819') or
            SameText(AEncoding, 'CP819') or
            SameText(AEncoding, 'csISOLatin1') or
// This one is not in character-sets.txt, but was used in FPC documentation,
// and still being used in fcl-registry package
            SameText(AEncoding, 'ISO8859-1');
end;


{ TDOMParseOptions }

function TDOMParseOptions.GetCanonical: Boolean;
begin
  Result := FCanonical and FExpandEntities and FCDSectionsAsText and
  { (not normalizeCharacters) and } FNamespaces and
  { namespaceDeclarations and } FPreserveWhitespace;
end;

procedure TDOMParseOptions.SetCanonical(aValue: Boolean);
begin
  FCanonical := aValue;
  if aValue then
  begin
    FExpandEntities := True;
    FCDSectionsAsText := True;
    FNamespaces := True;
    FPreserveWhitespace := True;
    { normalizeCharacters := False; }
    { namespaceDeclarations := True; }
    { wellFormed := True; }
  end;
end;

{ TXMLInputSource }

constructor TXMLInputSource.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

constructor TXMLInputSource.Create(const AStringData: string);
begin
  inherited Create;
  FStringData := AStringData;
end;

{ TDOMParser }

constructor TDOMParser.Create;
begin
  FOptions := TDOMParseOptions.Create;
end;

destructor TDOMParser.Destroy;
begin
  FOptions.Free;
  inherited Destroy;
end;

procedure TDOMParser.Parse(Src: TXMLInputSource; out ADoc: TXMLDocument);
var
  InputSrc: TXMLCharSource;
begin
  with TXMLReader.Create(Self) do
  try
    ConvertSource(Src, InputSrc);  // handles 'no-input-specified' case
    ProcessXML(InputSrc)
  finally
    ADoc := TXMLDocument(doc);
    Free;
  end;
end;

procedure TDOMParser.ParseUri(const URI: WideString; out ADoc: TXMLDocument);
var
  Src: TXMLCharSource;
begin
  ADoc := nil;
  with TXMLReader.Create(Self) do
  try
    if ResolveEntity(URI, '', '', Src) then
      ProcessXML(Src)
    else
      DoErrorPos(esFatal, 'The specified URI could not be resolved', NullLocation);
  finally
    ADoc := TXMLDocument(doc);
    Free;
  end;
end;

function TDOMParser.ParseWithContext(Src: TXMLInputSource;
  Context: TDOMNode; Action: TXMLContextAction): TDOMNode;
var
  InputSrc: TXMLCharSource;
  Frag: TDOMDocumentFragment;
  node: TDOMNode;
begin
  if Action in [xaInsertBefore, xaInsertAfter, xaReplace] then
    node := Context.ParentNode
  else
    node := Context;
  // TODO: replacing document isn't yet supported
  if (Action = xaReplaceChildren) and (node.NodeType = DOCUMENT_NODE) then
    raise EDOMNotSupported.Create('DOMParser.ParseWithContext');

  if not (node.NodeType in [ELEMENT_NODE, DOCUMENT_FRAGMENT_NODE]) then
    raise EDOMHierarchyRequest.Create('DOMParser.ParseWithContext');

  with TXMLReader.Create(Self) do
  try
    ConvertSource(Src, InputSrc);    // handles 'no-input-specified' case
    Frag := Context.OwnerDocument.CreateDocumentFragment;
    try
      ProcessFragment(InputSrc, Frag);
      Result := Frag.FirstChild;
      case Action of
        xaAppendAsChildren: Context.AppendChild(Frag);

        xaReplaceChildren: begin
          Context.TextContent := '';     // removes children
          Context.ReplaceChild(Frag, Context.FirstChild);
        end;
        xaInsertBefore: node.InsertBefore(Frag, Context);
        xaInsertAfter:  node.InsertBefore(Frag, Context.NextSibling);
        xaReplace:      node.ReplaceChild(Frag, Context);
      end;
    finally
      Frag.Free;
    end;
  finally
    Free;
  end;
end;

{ TXMLCharSource }

constructor TXMLCharSource.Create(const AData: WideString);
begin
  inherited Create;
  FLineNo := 1;
  FBuf := PWideChar(AData);
  FBufEnd := FBuf + Length(AData);
  LFPos := FBuf-1;
  FCharCount := Length(AData);
end;

procedure TXMLCharSource.Initialize;
begin
end;

function TXMLCharSource.SetEncoding(const AEncoding: string): Boolean;
begin
  Result := True; // always succeed
end;

function TXMLCharSource.GetSystemID: WideString;
begin
  if FSystemID <> '' then
    Result := FSystemID
  else if Assigned(FParent) then
    Result := FParent.SystemID
  else
    Result := '';
end;

function TXMLCharSource.Reload: Boolean;
begin
  Result := False;
end;

procedure TXMLCharSource.NewLine;
begin
  Inc(FLineNo);
  LFPos := FBuf;
end;

function TXMLCharSource.SkipUntil(var ToFill: TWideCharBuf; const Delim: TSetOfChar;
  wsflag: PBoolean): WideChar;
var
  old: PWideChar;
  nonws: Boolean;
begin
  old := FBuf;
  nonws := False;
  repeat
    if FBuf^ = #10 then
      NewLine;
    if (FBuf^ < #255) and (Char(ord(FBuf^)) in Delim) then
      Break;
    if (FBuf^ > #32) or not (Char(ord(FBuf^)) in [#32, #9, #10, #13]) then
      nonws := True;
    Inc(FBuf);
  until False;
  Result := FBuf^;
  BufAppendChunk(ToFill, old, FBuf);
  if Assigned(wsflag) then
    wsflag^ := wsflag^ or nonws;
end;

function TXMLCharSource.Matches(const arg: WideString): Boolean;
begin
  Result := False;
  if (FBufEnd >= FBuf + Length(arg)) or Reload then
    Result := CompareMem(Pointer(arg), FBuf, Length(arg)*sizeof(WideChar));
  if Result then
  begin
    Inc(FBuf, Length(arg));
    if FBuf >= FBufEnd then
      Reload;
  end;
end;

{ TXMLDecodingSource }

procedure TXMLDecodingSource.AfterConstruction;
begin
  inherited AfterConstruction;
  FBufStart := AllocMem(4096);
  FBuf := FBufStart;
  FBufEnd := FBuf;
  LFPos := FBuf-1;
end;

destructor TXMLDecodingSource.Destroy;
begin
  FreeMem(FBufStart);
  if Assigned(FDecoder.Cleanup) then
    FDecoder.Cleanup(FDecoder.Context);
  inherited Destroy;
end;

procedure TXMLDecodingSource.FetchData;
begin
end;

procedure TXMLDecodingSource.DecodingError(const Msg: string);
begin
// count line endings to obtain correct error location
  while FBuf < FBufEnd do
  begin
    if (FBuf^ = #10) or (FBuf^ = #13) or (FXML11Rules and ((FBuf^ = #$85) or (FBuf^ = #$2028))) then
    begin
      if (FBuf^ = #13) and (FBuf < FBufEnd-1) and
      ((FBuf[1] = #10) or (FXML11Rules and (FBuf[1] = #$85))) then
        Inc(FBuf);
      LFPos := FBuf;
      Inc(FLineNo);
    end;
    Inc(FBuf);
  end;
  FReader.FatalError(Msg);
end;

function TXMLDecodingSource.Reload: Boolean;
var
  Remainder: PtrInt;
  r, inLeft: Cardinal;
  rslt: Integer;
begin
  if DTDSubsetType = dsInternal then
    FReader.DTDReloadHook;
  Remainder := FBufEnd - FBuf;
  if Remainder > 0 then
    Move(FBuf^, FBufStart^, Remainder * sizeof(WideChar));
  Dec(LFPos, FBuf-FBufStart);
  FBuf := FBufStart;
  FBufEnd := FBufStart + Remainder;

  repeat
    inLeft := FCharBufEnd - FCharBuf;
    if inLeft < 4 then                      // may contain an incomplete char
    begin
      FetchData;
      inLeft := FCharBufEnd - FCharBuf;
      if inLeft <= 0 then
        Break;
    end;
    r := FBufStart + FBufSize - FBufEnd;
    if r = 0 then
      Break;
    rslt := FDecoder.Decode(FDecoder.Context, FCharBuf, inLeft, FBufEnd, r);
    { Sanity checks: r and inLeft must not increase. }
    if inLeft + FCharBuf <= FCharBufEnd then
      FCharBuf := FCharBufEnd - inLeft
    else
      DecodingError('Decoder error: input byte count out of bounds');
    if r + FBufEnd <= FBufStart + FBufSize then
      FBufEnd := FBufStart + FBufSize - r
    else
      DecodingError('Decoder error: output char count out of bounds');

    if rslt = 0 then
      Break
    else if rslt < 0 then
      DecodingError('Invalid character in input stream')
    else
    begin
      Inc(FCharCount, rslt);
      FReader.CheckMaxChars;
    end;
  until False;

  FBufEnd^ := #0;
  Result := FBuf < FBufEnd;
end;

const
  XmlSign: array [0..4] of WideChar = ('<', '?', 'x', 'm', 'l');

procedure TXMLDecodingSource.Initialize;
begin
  inherited;
  FLineNo := 1;
  FDecoder.Decode := @Decode_UTF8;

  FFixedUCS2 := '';
  if FCharBufEnd-FCharBuf > 1 then
  begin
    if (FCharBuf[0] = #$FE) and (FCharBuf[1] = #$FF) then
    begin
      FFixedUCS2 := 'UTF-16BE';
      FDecoder.Decode := {$IFNDEF ENDIAN_BIG} @Decode_UCS2_Swapped {$ELSE} @Decode_UCS2 {$ENDIF};
    end
    else if (FCharBuf[0] = #$FF) and (FCharBuf[1] = #$FE) then
    begin
      FFixedUCS2 := 'UTF-16LE';
      FDecoder.Decode := {$IFDEF ENDIAN_BIG} @Decode_UCS2_Swapped {$ELSE} @Decode_UCS2 {$ENDIF};
    end;
  end;
  FBufSize := 6;             //  possible BOM and '<?xml'
  Reload;
  if FBuf^ = #$FEFF then
  begin
    FHasBOM := True;
    Inc(FBuf);
  end;
  LFPos := FBuf-1;
  if CompareMem(FBuf, @XmlSign[0], sizeof(XmlSign)) then
  begin
    FBufSize := 3;           // don't decode past XML declaration
    Inc(FBuf, Length(XmlSign));
    FReader.ParseXmlOrTextDecl((FParent <> nil) or (FReader.FState <> rsProlog));
  end;
  FBufSize := 2047;
  if FReader.FXML11 then
    FReader.XML11_BuildTables;
end;

function TXMLDecodingSource.SetEncoding(const AEncoding: string): Boolean;
var
  NewDecoder: TDecoder;
begin
  Result := True;
  if (FFixedUCS2 = '') and SameText(AEncoding, 'UTF-8') then
    Exit;
  if FFixedUCS2 <> '' then
  begin
    Result := SameText(AEncoding, FFixedUCS2) or
       SameText(AEncoding, 'UTF-16') or
       SameText(AEncoding, 'unicode');
    Exit;
  end;
// TODO: must fail when a byte-based stream is labeled as word-based.
// see rmt-e2e-61, it now fails but for a completely different reason.
  FillChar(NewDecoder, sizeof(TDecoder), 0);
  if Is_8859_1(AEncoding) then
    FDecoder.Decode := @Decode_8859_1
  else if FindDecoder(AEncoding, NewDecoder) then
    FDecoder := NewDecoder
  else
    Result := False;
end;

procedure TXMLDecodingSource.NewLine;
begin
  case FBuf^ of
    #10: ;
    #13: begin
      // Reload trashes the buffer, it should be consumed beforehand
      if (FBufEnd >= FBuf+2) or Reload then
      begin
        if (FBuf[1] = #10) or (FXML11Rules and (FBuf[1] = #$85)) then
          Inc(FBuf);
      end;
      FBuf^ := #10;
    end;
    #$85, #$2028: if FXML11Rules then
      FBuf^ := #10
    else
      Exit;
  else
    Exit;
  end;
  Inc(FLineNo);
  LFPos := FBuf;
end;

{ TXMLStreamInputSource }

const
  Slack = 16;

constructor TXMLStreamInputSource.Create(AStream: TStream; AOwnStream: Boolean);
begin
  FStream := AStream;
  FCapacity := 4096;
  GetMem(FAllocated, FCapacity+Slack);
  FCharBuf := FAllocated+(Slack-4);
  FCharBufEnd := FCharBuf;
  FOwnStream := AOwnStream;
  FetchData;
end;

destructor TXMLStreamInputSource.Destroy;
begin
  FreeMem(FAllocated);
  if FOwnStream then
    FStream.Free;
  inherited Destroy;
end;

procedure TXMLStreamInputSource.FetchData;
var
  Remainder, BytesRead: Integer;
  OldBuf: PChar;
begin
  Assert(FCharBufEnd - FCharBuf < Slack-4);
  if FEof then
    Exit;
  OldBuf := FCharBuf;
  Remainder := FCharBufEnd - FCharBuf;
  if Remainder < 0 then
    Remainder := 0;
  FCharBuf := FAllocated+Slack-4-Remainder;
  if Remainder > 0 then
    Move(OldBuf^, FCharBuf^, Remainder);
  BytesRead := FStream.Read(FAllocated[Slack-4], FCapacity);
  if BytesRead < FCapacity then
    FEof := True;
  FCharBufEnd := FAllocated + (Slack-4) + BytesRead;
  { Null-termination has been removed:
    1) Built-in decoders don't need it because they respect the buffer length.
    2) It was causing unaligned access errors on ARM CPUs.
  }
  //PWideChar(FCharBufEnd)^ := #0;
end;

{ TXMLFileInputSource }

constructor TXMLFileInputSource.Create(var AFile: Text);
begin
  FFile := @AFile;
  SystemID := FilenameToURI(TTextRec(AFile).Name);
  FetchData;
end;

procedure TXMLFileInputSource.FetchData;
var
  Remainder: Integer;
begin
  if not Eof(FFile^) then
  begin
    Remainder := FCharBufEnd - FCharBuf;
    if Remainder > 0 then
      SetString(FTmp, FCharBuf, Remainder);
    ReadLn(FFile^, FString);
    FString := FString + #10;    // bad solution...
    if Remainder > 0 then
      Insert(FTmp, FString, 1);
    FCharBuf := PChar(FString);
    FCharBufEnd := FCharBuf + Length(FString);
  end;
end;

{ helper that closes handle upon destruction }
type
  THandleOwnerStream = class(THandleStream)
  public
    destructor Destroy; override;
  end;

destructor THandleOwnerStream.Destroy;
begin
  if Handle >= 0 then FileClose(Handle);
  inherited Destroy;
end;

{ TXMLReader }

procedure TXMLReader.ConvertSource(SrcIn: TXMLInputSource; out SrcOut: TXMLCharSource);
begin
  SrcOut := nil;
  if Assigned(SrcIn) then
  begin
    if Assigned(SrcIn.FStream) then
      SrcOut := TXMLStreamInputSource.Create(SrcIn.FStream, False)
    else if SrcIn.FStringData <> '' then
      SrcOut := TXMLStreamInputSource.Create(TStringStream.Create(SrcIn.FStringData), True)
    else if (SrcIn.SystemID <> '') then
      ResolveEntity(SrcIn.SystemID, SrcIn.PublicID, SrcIn.BaseURI, SrcOut);
  end;
  if (SrcOut = nil) and (FSource = nil) then
    DoErrorPos(esFatal, 'No input source specified', NullLocation);
end;

procedure TXMLReader.StoreLocation(out Loc: TLocation);
begin
  Loc.Line := FSource.FLineNo;
  Loc.LinePos := FSource.FBuf-FSource.LFPos;
end;

function TXMLReader.ResolveEntity(const ASystemID, APublicID, ABaseURI: WideString; out Source: TXMLCharSource): Boolean;
var
  AbsSysID: WideString;
  Filename: string;
  Stream: TStream;
  fd: THandle;
begin
  Source := nil;
  Result := False;
  if not ResolveRelativeURI(ABaseURI, ASystemID, AbsSysID) then
    Exit;
  { TODO: alternative resolvers
    These may be 'internal' resolvers or a handler set by application.
    Internal resolvers should probably produce a TStream
    ( so that internal classes need not be exported ).
    External resolver will produce TXMLInputSource that should be converted.
    External resolver must NOT be called for root entity.
    External resolver can return nil, in which case we do the default }
  if URIToFilename(AbsSysID, Filename) then
  begin
    fd := FileOpen(Filename, fmOpenRead + fmShareDenyWrite);
    if fd <> THandle(-1) then
    begin
      Stream := THandleOwnerStream.Create(fd);
      Source := TXMLStreamInputSource.Create(Stream, True);
      Source.SystemID := AbsSysID;    // <- Revisit: Really need absolute sysID?
    end;
  end;
  Result := Assigned(Source);
end;

procedure TXMLReader.Initialize(ASource: TXMLCharSource);
begin
  ASource.FParent := FSource;
  FSource := ASource;
  FSource.FReader := Self;
  FSource.FStartNesting := FNesting;
  FSource.Initialize;
end;

procedure TXMLReader.FatalError(Expected: WideChar);
begin
// FIX: don't output what is found - anything may be found, including exploits...
  FatalError('Expected "%1s"', [string(Expected)]);
end;

procedure TXMLReader.FatalError(const descr: String; LineOffs: Integer);
begin
  DoError(esFatal, descr, LineOffs);
end;

procedure TXMLReader.FatalError(const descr: string; const args: array of const; LineOffs: Integer);
begin
  DoError(esFatal, Format(descr, args), LineOffs);
end;

procedure TXMLReader.ValidationError(const Msg: string; const Args: array of const; LineOffs: Integer);
begin
  if FValidate then
    DoError(esError, Format(Msg, Args), LineOffs);
end;

procedure TXMLReader.DoError(Severity: TErrorSeverity; const descr: string; LineOffs: Integer);
var
  Loc: TLocation;
begin
  StoreLocation(Loc);
  if LineOffs >= 0 then
  begin
    Dec(Loc.LinePos, LineOffs);
    DoErrorPos(Severity, descr, Loc);
  end
  else
    DoErrorPos(Severity, descr, FTokenStart);
end;

procedure TXMLReader.DoErrorPos(Severity: TErrorSeverity; const descr: string; const ErrPos: TLocation);
var
  E: EXMLReadError;
  sysid: WideString;
begin
  if Assigned(FSource) then
  begin
    sysid := FSource.FSystemID;
    if (sysid = '') and Assigned(FSource.FEntity) then
      sysid := TDOMEntityEx(FSource.FEntity).FURI;
    E := EXMLReadError.CreateFmt('In ''%s'' (line %d pos %d): %s', [sysid, ErrPos.Line, ErrPos.LinePos, descr]);
  end
  else
    E := EXMLReadError.Create(descr);
  E.FSeverity := Severity;
  E.FErrorMessage := descr;
  E.FLine := ErrPos.Line;
  E.FLinePos := ErrPos.LinePos;
  CallErrorHandler(E);
  // No 'finally'! If user handler raises exception, control should not get here
  // and the exception will be freed in CallErrorHandler (below)
  E.Free;
end;

procedure TXMLReader.CheckMaxChars;
var
  src: TXMLCharSource;
  total: Cardinal;
begin
  if FMaxChars = 0 then
    Exit;
  src := FSource;
  total := 0;
  repeat
    Inc(total, src.FCharCount);
    if total > FMaxChars then
      FatalError('Exceeded character count limit');
    src := src.FParent;
  until src = nil;
end;

procedure TXMLReader.CallErrorHandler(E: EXMLReadError);
begin
  try
    if Assigned(FCtrl) and Assigned(FCtrl.FOnError) then
      FCtrl.FOnError(E);
    if E.Severity = esFatal then
      raise E;
  except
    if ExceptObject <> E then
      E.Free;
    raise;
  end;
end;

function TXMLReader.SkipWhitespace(PercentAloneIsOk: Boolean): Boolean;
begin
  Result := False;
  repeat
    Result := SkipS or Result;
    if FSource.FBuf^ = #0 then
    begin
      Result := True;      // report whitespace upon exiting the PE
      if not ContextPop then
        Break;
    end
    else if FSource.FBuf^ = '%' then
    begin
      if (FState <> rsDTD) or ((FSource.DTDSubsetType = dsInternal) and FInsideDecl) then
        Break;
// This is the only case where look-ahead is needed
      if FSource.FBuf > FSource.FBufEnd-2 then
        FSource.Reload;

      if (not PercentAloneIsOk) or (Byte(FSource.FBuf[1]) in NamingBitmap[FNamePages^[$100+hi(Word(FSource.FBuf[1]))]]) or
        (FXML11 and (FSource.FBuf[1] >= #$D800) and (FSource.FBuf[1] <= #$DB7F)) then
      begin
        Inc(FSource.FBuf);    // skip '%'
        CheckName;
        ExpectChar(';');
        StartPE;
        Result := True;        // report whitespace upon entering the PE
      end
      else Break;
    end
    else
      Break;
  until False;
end;

procedure TXMLReader.ExpectWhitespace;
begin
  if not SkipWhitespace then
    FatalError('Expected whitespace');
end;

function TXMLReader.SkipS(Required: Boolean): Boolean;
var
  p: PWideChar;
begin
  Result := False;
  repeat
    p := FSource.FBuf;
    repeat
      if (p^ = #10) or (p^ = #13) or (FXML11 and ((p^ = #$85) or (p^ = #$2028))) then
      begin
        FSource.FBuf := p;
        FSource.NewLine;
        p := FSource.FBuf;
      end
      else if (p^ <> #32) and (p^ <> #9) then
        Break;
      Inc(p);
      Result := True;
    until False;
    FSource.FBuf := p;
  until (p^ <> #0) or (not FSource.Reload);
  if (not Result) and Required then
    FatalError('Expected whitespace');
end;

procedure TXMLReader.ExpectString(const s: String);
var
  I: Integer;
begin
  for I := 1 to Length(s) do
  begin
    if FSource.FBuf^ <> WideChar(ord(s[i])) then
      FatalError('Expected "%s"', [s], i-1);
    FSource.NextChar;
  end;
end;

function TXMLReader.CheckForChar(c: WideChar): Boolean;
begin
  Result := (FSource.FBuf^ = c);
  if Result then
  begin
    Inc(FSource.FBuf);
    if FSource.FBuf >= FSource.FBufEnd then
      FSource.Reload;
  end;  
end;

procedure TXMLReader.SkipQuote(out Delim: WideChar; required: Boolean);
begin
  Delim := #0;
  if (FSource.FBuf^ = '''') or (FSource.FBuf^ = '"') then
  begin
    Delim := FSource.FBuf^;
    FSource.NextChar;  // skip quote
    StoreLocation(FTokenStart);
  end
  else if required then
    FatalError('Expected single or double quote');
end;

const
  PrefixDefault: array[0..4] of WideChar = ('x','m','l','n','s');

constructor TXMLReader.Create;
begin
  inherited Create;
  BufAllocate(FName, 128);
  BufAllocate(FValue, 512);
  FIDRefs := TFPList.Create;
  FNotationRefs := TFPList.Create;

  FNSHelper := TNSSupport.Create;

  FNsAttHash := TDblHashArray.Create;
  SetLength(FWorkAtts, 16);
  FStdPrefix_xml := FNSHelper.GetPrefix(@PrefixDefault, 3);
  FStdPrefix_xmlns := FNSHelper.GetPrefix(@PrefixDefault, 5);
  // Set char rules to XML 1.0
  FNamePages := @NamePages;
  SetLength(FValidator, 16);
end;

constructor TXMLReader.Create(AParser: TDOMParser);
begin
  Create;
  FCtrl := AParser;
  if FCtrl = nil then
    Exit;
  FValidate := FCtrl.Options.Validate;
  FPreserveWhitespace := FCtrl.Options.PreserveWhitespace;
  FExpandEntities := FCtrl.Options.ExpandEntities;
  FCDSectionsAsText := FCtrl.Options.CDSectionsAsText;
  FIgnoreComments := FCtrl.Options.IgnoreComments;
  FResolveExternals := FCtrl.Options.ResolveExternals;
  FNamespaces := FCtrl.Options.Namespaces;
  FDisallowDoctype := FCtrl.Options.DisallowDoctype;
  FCanonical := FCtrl.Options.CanonicalForm;
  FMaxChars := FCtrl.Options.MaxChars;
end;

destructor TXMLReader.Destroy;
begin
  if Assigned(FEntityValue.Buffer) then
    FreeMem(FEntityValue.Buffer);
  FreeMem(FName.Buffer);
  FreeMem(FValue.Buffer);
  if Assigned(FSource) then
    while ContextPop(True) do;     // clean input stack
  FSource.Free;
  FPEMap.Free;
  ClearRefs(FNotationRefs);
  ClearRefs(FIDRefs);
  FNsAttHash.Free;
  FNSHelper.Free;
  if FOwnsDoctype then
    FDocType.Free;

  FNotationRefs.Free;
  FIDRefs.Free;
  inherited Destroy;
end;

procedure TXMLReader.XML11_BuildTables;
begin
  FNamePages := Xml11NamePages;
  FXML11 := True;
  FSource.FXml11Rules := True;
end;

procedure TXMLReader.ProcessXML(ASource: TXMLCharSource);
begin
  doc := TXMLDocument.Create;
  doc.documentURI := ASource.SystemID;  // TODO: to be changed to URI or BaseURI  
  FCursor := doc;
  FState := rsProlog;
  FNesting := 0;
  Initialize(ASource);
  ParseContent;

  if FState < rsRoot then
    FatalError('Root element is missing');

  if FValidate and Assigned(FDocType) then
    ValidateIdRefs;
end;

procedure TXMLReader.ProcessFragment(ASource: TXMLCharSource; AOwner: TDOMNode);
begin
  doc := AOwner.OwnerDocument;
  FCursor := AOwner as TDOMNode_WithChildren;
  FState := rsRoot;
  FXML11 := doc.InheritsFrom(TXMLDocument) and (TXMLDocument(doc).XMLVersion = '1.1');
  Initialize(ASource);
  FDocType := TDOMDocumentTypeEx(doc.DocType);
  ParseContent;
end;

function TXMLReader.CheckName(aFlags: TCheckNameFlags): Boolean;
var
  p: PWideChar;
  NameStartFlag: Boolean;
begin
  p := FSource.FBuf;
  FName.Length := 0;
  FColonPos := -1;
  NameStartFlag := not (cnToken in aFlags);

  repeat
    if NameStartFlag then
    begin
      if (Byte(p^) in NamingBitmap[FNamePages^[hi(Word(p^))]]) or
        ((p^ = ':') and (not FNamespaces)) then
        Inc(p)
      else if FXML11 and ((p^ >= #$D800) and (p^ <= #$DB7F) and
        (p[1] >= #$DC00) and (p[1] <= #$DFFF)) then
        Inc(p, 2)
      else
      begin
  // here we come either when first char of name is bad (it may be a colon),
  // or when a colon is not followed by a valid NameStartChar
        FSource.FBuf := p;
        Result := False;
        Break;
      end;
      NameStartFlag := False;
    end;

    if FXML11 then
    repeat
      if Byte(p^) in NamingBitmap[FNamePages^[$100+hi(Word(p^))]] then
        Inc(p)
      else if ((p^ >= #$D800) and (p^ <= #$DB7F) and
        (p[1] >= #$DC00) and (p[1] <= #$DFFF)) then
        Inc(p,2)
      else
        Break;
    until False
    else
    while Byte(p^) in NamingBitmap[FNamePages^[$100+hi(Word(p^))]] do
      Inc(p);

    if p^ = ':' then
    begin
      if (cnToken in aFlags) or not FNamespaces then  // colon has no specific meaning
      begin
        Inc(p);
        if p^ <> #0 then Continue;
      end
      else if FColonPos = -1 then       // this is the first colon, remember it
      begin
        FColonPos := p-FSource.FBuf+FName.Length;
        NameStartFlag := True;
        Inc(p);
        if p^ <> #0 then Continue;
      end;
    end;

    BufAppendChunk(FName, FSource.FBuf, p);
    Result := (FName.Length > 0);

    FSource.FBuf := p;
    if (p^ <> #0) or not FSource.Reload then
      Break;

    p := FSource.FBuf;
  until False;
  if not (Result or (cnOptional in aFlags)) then
    RaiseNameNotFound;
end;

procedure TXMLReader.CheckNCName;
begin
  if FNamespaces and (FColonPos <> -1) then
    FatalError('Names of entities, notations and processing instructions may not contain colons', FName.Length);
end;

procedure TXMLReader.RaiseNameNotFound;
begin
  if FColonPos <> -1 then
    FatalError('Bad QName syntax, local part is missing')
  else
  // Coming at no cost, this allows more user-friendly error messages
  with FSource do
  if (FBuf^ = #32) or (FBuf^ = #10) or (FBuf^ = #9) or (FBuf^ = #13) then
    FatalError('Whitespace is not allowed here')
  else
    FatalError('Name starts with invalid character');
end;

function TXMLReader.ExpectName: WideString;
begin
  CheckName;
  SetString(Result, FName.Buffer, FName.Length);
end;

function TXMLReader.ResolvePredefined: Boolean;
var
  wc: WideChar;
begin
  Result := False;
  with FName do
  begin
    if (Length = 2) and (Buffer[1] = 't') then
    begin
      if Buffer[0] = 'l' then
        wc := '<'
      else if Buffer[0] = 'g' then
        wc := '>'
      else Exit;
    end
    else if Buffer[0] = 'a' then
    begin
      if (Length = 3) and (Buffer[1] = 'm') and (Buffer[2] = 'p') then
        wc := '&'
      else if (Length = 4) and (Buffer[1] = 'p') and (Buffer[2] = 'o') and
       (Buffer[3] = 's') then
        wc := ''''
      else Exit;  
    end
    else if (Length = 4) and (Buffer[0] = 'q') and (Buffer[1] = 'u') and
      (Buffer[2] = 'o') and (Buffer[3] ='t') then
      wc := '"'
    else
      Exit;
  end; // with
  BufAppend(FValue, wc);
  Result := True;
end;

function TXMLReader.ParseRef(var ToFill: TWideCharBuf): Boolean;  // [67]
var
  Code: Integer;
begin
  FSource.NextChar;   // skip '&'
  Result := CheckForChar('#');
  if Result then
  begin
    Code := 0;
    if CheckForChar('x') then
    repeat
      case FSource.FBuf^ of
        '0'..'9': Code := Code * 16 + Ord(FSource.FBuf^) - Ord('0');
        'a'..'f': Code := Code * 16 + Ord(FSource.FBuf^) - (Ord('a') - 10);
        'A'..'F': Code := Code * 16 + Ord(FSource.FBuf^) - (Ord('A') - 10);
      else
        Break;
      end;
      FSource.NextChar;
    until Code > $10FFFF
    else
    repeat
      case FSource.FBuf^ of
        '0'..'9': Code := Code * 10 + Ord(FSource.FBuf^) - Ord('0');
      else
        Break;
      end;
      FSource.NextChar;
    until Code > $10FFFF;

    case Code of
      $01..$08, $0B..$0C, $0E..$1F:
        if FXML11 then
          BufAppend(ToFill, WideChar(Code))
        else
          FatalError('Invalid character reference');
      $09, $0A, $0D, $20..$D7FF, $E000..$FFFD:
        BufAppend(ToFill, WideChar(Code));
      $10000..$10FFFF:
        begin
          BufAppend(ToFill, WideChar($D7C0 + (Code shr 10)));
          BufAppend(ToFill, WideChar($DC00 xor (Code and $3FF)));
        end;
    else
      FatalError('Invalid character reference');
    end;
  end
  else CheckName;
  ExpectChar(';');
end;

const
  AttrDelims: TSetOfChar = [#0, '<', '&', '''', '"', #9, #10, #13];
  GT_Delim: TSetOfChar = [#0, '>'];

procedure TXMLReader.ExpectAttValue;
var
  wc: WideChar;
  Delim: WideChar;
  ent: TDOMEntityEx;
  start: TObject;
begin
  SkipQuote(Delim);
  FValue.Length := 0;
  start := FSource.FEntity;
  repeat
    wc := FSource.SkipUntil(FValue, AttrDelims);
    if wc = '<' then
      FatalError('Character ''<'' is not allowed in attribute value')
    else if wc = '&' then
    begin
      if ParseRef(FValue) or ResolvePredefined then
        Continue;

      ent := EntityCheck(True);
      if (ent = nil) or (not FExpandEntities) then
      begin
        if FValue.Length > 0 then
        begin
          DoAttrText(FValue.Buffer, FValue.Length);
          FValue.Length := 0;
        end;
        AppendReference(ent);
      end
      else
        ContextPush(ent);
    end
    else if wc <> #0 then
    begin
      FSource.NextChar;
      if (wc = Delim) and (FSource.FEntity = start) then
        Break;
      if (wc = #10) or (wc = #9) or (wc = #13) then
        wc := #32;
      BufAppend(FValue, wc);
    end
    else if (FSource.FEntity = start) or not ContextPop then    // #0
      FatalError('Literal has no closing quote', -1);
  until False;
  if FValue.Length > 0 then
    DoAttrText(FValue.Buffer, FValue.Length);
  FValue.Length := 0;
end;

const
  PrefixChar: array[Boolean] of string = ('', '%');

procedure TXMLReader.EntityToSource(AEntity: TDOMEntityEx; out Src: TXMLCharSource);
begin
  if AEntity.FOnStack then
    FatalError('Entity ''%s%s'' recursively references itself', [PrefixChar[AEntity.FIsPE], AEntity.FName]);

  if (AEntity.SystemID <> '') and not AEntity.FPrefetched then
  begin
    if not ResolveEntity(AEntity.SystemID, AEntity.PublicID, AEntity.FURI, Src) then
    begin
      // TODO: a detailed message like SysErrorMessage(GetLastError) would be great here
      ValidationError('Unable to resolve external entity ''%s''', [AEntity.FName]);
      Src := nil;
      Exit;
    end;
  end
  else
  begin
    Src := TXMLCharSource.Create(AEntity.FReplacementText);
    Src.FLineNo := AEntity.FStartLocation.Line;
    Src.LFPos := Src.FBuf - AEntity.FStartLocation.LinePos;
    // needed in case of prefetched external PE
    if AEntity.SystemID <> '' then
      Src.SystemID := AEntity.FURI;
  end;

  AEntity.FOnStack := True;
  Src.FEntity := AEntity;
end;

function TXMLReader.ContextPush(AEntity: TDOMEntityEx): Boolean;
var
  Src: TXMLCharSource;
begin
  EntityToSource(AEntity, Src);
  Result := Assigned(Src);
  if Result then
    Initialize(Src);
end;

function TXMLReader.ContextPop(Forced: Boolean): Boolean;
var
  Src: TXMLCharSource;
  Error: Boolean;
begin
  Result := Assigned(FSource.FParent) and (Forced or (FSource.DTDSubsetType = dsNone));
  if Result then
  begin
    Src := FSource.FParent;
    Error := False;
    if Assigned(FSource.FEntity) then
    begin
      TDOMEntityEx(FSource.FEntity).FOnStack := False;
      TDOMEntityEx(FSource.FEntity).FCharCount := FSource.FCharCount;
// [28a] PE that was started between MarkupDecls may not end inside MarkupDecl
      Error := TDOMEntityEx(FSource.FEntity).FBetweenDecls and FInsideDecl;
    end;
    FSource.Free;
    FSource := Src;
// correct position of this error is after PE reference
    if Error then
      BadPENesting(esFatal);
  end;
end;

function TXMLReader.EntityCheck(NoExternals: Boolean): TDOMEntityEx;
var
  RefName: WideString;
  cnt: Integer;
  InnerReader: TXMLReader;
  Src: TXMLCharSource;
begin
  Result := nil;
  SetString(RefName, FName.Buffer, FName.Length);
  cnt := FName.Length+2;

  if Assigned(FDocType) then
    Result := FDocType.Entities.GetNamedItem(RefName) as TDOMEntityEx;

  if Result = nil then
  begin
    if FStandalone or (FDocType = nil) or not (FHavePERefs or (FDocType.SystemID <> '')) then
      FatalError('Reference to undefined entity ''%s''', [RefName], cnt)
    else
      ValidationError('Undefined entity ''%s'' referenced', [RefName], cnt);
    Exit;
  end;

  if FStandalone and Result.FExternallyDeclared then
    FatalError('Standalone constraint violation', cnt);
  if Result.NotationName <> '' then
    FatalError('Reference to unparsed entity ''%s''', [RefName], cnt);

  if NoExternals and (Result.SystemID <> '') then
    FatalError('External entity reference is not allowed in attribute value', cnt);

  if not Result.FResolved then
  begin
    // To build children of the entity itself, we must parse it "out of context"
    InnerReader := TXMLReader.Create(FCtrl);
    try
      EntityToSource(Result, Src);
      Result.SetReadOnly(False);
      if Assigned(Src) then
        InnerReader.ProcessFragment(Src, Result);
      Result.FResolved := True;
    finally
      InnerReader.Free;
      Result.FOnStack := False;
      Result.SetReadOnly(True);
    end;
  end;
  // at this point we know the charcount of the entity being included
  Inc(FSource.FCharCount, Result.FCharCount - cnt);
  CheckMaxChars;
end;

procedure TXMLReader.StartPE;
var
  PEName: WideString;
  PEnt: TDOMEntityEx;
begin
  SetString(PEName, FName.Buffer, FName.Length);
  PEnt := nil;
  if Assigned(FPEMap) then
    PEnt := FPEMap.GetNamedItem(PEName) as TDOMEntityEx;
  if PEnt = nil then
  begin
    ValidationError('Undefined parameter entity ''%s'' referenced', [PEName], FName.Length+2);
    // cease processing declarations, unless document is standalone.
    FDTDProcessed := FStandalone;
    Exit;
  end;

  { cache an external PE so it's only fetched once }
  if (PEnt.SystemID <> '') and (not PEnt.FPrefetched) and (not PrefetchEntity(PEnt)) then
  begin
    FDTDProcessed := FStandalone;
    Exit;
  end;
  Inc(FSource.FCharCount, PEnt.FCharCount);
  CheckMaxChars;

  PEnt.FBetweenDecls := not FInsideDecl;
  ContextPush(PEnt);
  FHavePERefs := True;
end;

function TXMLReader.PrefetchEntity(AEntity: TDOMEntityEx): Boolean;
begin
  Result := ContextPush(AEntity);
  if Result then
  try
    FValue.Length := 0;
    FSource.SkipUntil(FValue, [#0]);
    SetString(AEntity.FReplacementText, FValue.Buffer, FValue.Length);
    AEntity.FCharCount := FValue.Length;
    AEntity.FStartLocation.Line := 1;
    AEntity.FStartLocation.LinePos := 1;
    AEntity.FURI := FSource.SystemID;    // replace base URI with absolute one
  finally
    ContextPop;
    AEntity.FPrefetched := True;
    FValue.Length := 0;
  end;
end;

procedure Normalize(var Buf: TWideCharBuf; Modified: PBoolean);
var
  Dst, Src: Integer;
begin
  Dst := 0;
  Src := 0;
  // skip leading space if any
  while (Src < Buf.Length) and (Buf.Buffer[Src] = ' ') do
    Inc(Src);

  while Src < Buf.Length do
  begin
    if Buf.Buffer[Src] = ' ' then
    begin
      // Dst cannot be 0 here, because leading space is already skipped
      if Buf.Buffer[Dst-1] <> ' ' then
      begin
        Buf.Buffer[Dst] := ' ';
        Inc(Dst);
      end;
    end
    else
    begin
      Buf.Buffer[Dst] := Buf.Buffer[Src];
      Inc(Dst);
    end;
    Inc(Src);
  end;
  // trailing space (only one possible due to compression)
  if (Dst > 0) and (Buf.Buffer[Dst-1] = ' ') then
    Dec(Dst);

  if Assigned(Modified) then
    Modified^ := Dst <> Buf.Length;
  Buf.Length := Dst;
end;

const
  LiteralDelims: array[TLiteralType] of TSetOfChar = (
    [#0, '''', '"'],                          // ltPlain
    [#0, '<', '&', '''', '"', #9, #10, #13],  // ltAttr
    [#0, '<', '&', '''', '"', #9, #10, #13],  // ltTokAttr
    [#0, '''', '"', #13, #10],                // ltPubid
    [#0, '%', '&', '''', '"']                 // ltEntity
  );

function TXMLReader.ParseLiteral(var ToFill: TWideCharBuf; aType: TLiteralType;
  Required: Boolean; Normalized: PBoolean): Boolean;
var
  start: TObject;
  wc, Delim: WideChar;
  ent: TDOMEntityEx;
begin
  SkipQuote(Delim, Required);
  Result := (Delim <> #0);
  if not Result then
    Exit;
  ToFill.Length := 0;
  start := FSource.FEntity;
  repeat
    wc := FSource.SkipUntil(ToFill, LiteralDelims[aType]);
    if wc = '%' then       { ltEntity only }
    begin
      FSource.NextChar;
      CheckName;
      ExpectChar(';');
      if FSource.DTDSubsetType = dsInternal then
        FatalError('PE reference not allowed here in internal subset', FName.Length+2);
      StartPE;
    end
    else if wc = '&' then  { ltAttr, ltTokAttr, ltEntity }
    begin
      if ParseRef(ToFill) then   // charRefs always expanded
        Continue;
      if aType = ltEntity then   // bypass
      begin
        BufAppend(ToFill, '&');
        BufAppendChunk(ToFill, FName.Buffer, FName.Buffer + FName.Length);
        BufAppend(ToFill, ';');
      end
      else                       // include
      begin
        if ResolvePredefined then
          Continue;
        ent := EntityCheck(True);
        if ent = nil then
          Continue;
        ContextPush(ent);
      end;
    end
    else if wc = '<' then
      FatalError('Character ''<'' is not allowed in attribute value')
    else if wc <> #0 then
    begin
      FSource.NextChar;
      if (wc = #10) or (wc = #13) or (wc = #9) then
        wc := #32
      // terminating delimiter must be in the same context as the starting one
      else if (wc = Delim) and (start = FSource.FEntity) then
        Break;
      BufAppend(ToFill, wc);
    end
    else if (FSource.FEntity = start) or not ContextPop then    // #0
      FatalError('Literal has no closing quote', -1);
  until False;
  if aType in [ltTokAttr, ltPubid] then
    Normalize(ToFill, Normalized);
end;

function TXMLReader.SkipUntilSeq(const Delim: TSetOfChar; c1: WideChar; c2: WideChar = #0): Boolean;
var
  wc: WideChar;
begin
  Result := False;
  StoreLocation(FTokenStart);
  repeat
    wc := FSource.SkipUntil(FValue, Delim);
    if wc <> #0 then
    begin
      FSource.NextChar;
      if (FValue.Length > ord(c2 <> #0)) then
      begin
        if (FValue.Buffer[FValue.Length-1] = c1) and
          ((c2 = #0) or ((c2 <> #0) and (FValue.Buffer[FValue.Length-2] = c2))) then
        begin
          Dec(FValue.Length, ord(c2 <> #0) + 1);
          Result := True;
          Exit;
        end;
      end;
      BufAppend(FValue, wc);
    end;
  until wc = #0;
end;

procedure TXMLReader.ParseComment;    // [15]
var
  SaveLength: Integer;
begin
  ExpectString('--');
  SaveLength := FValue.Length;
  if not SkipUntilSeq([#0, '-'], '-') then
    FatalError('Unterminated comment', -1);
  ExpectChar('>');

  DoComment(@FValue.Buffer[SaveLength], FValue.Length-SaveLength);
  FValue.Length := SaveLength;
end;

procedure TXMLReader.ParsePI;                    // [16]
var
  NameStr, ValueStr: WideString;
  PINode: TDOMProcessingInstruction;
begin
  FSource.NextChar;      // skip '?'
  CheckName;
  CheckNCName;
  with FName do
    if (Length = 3) and
     ((Buffer[0] = 'X') or (Buffer[0] = 'x')) and
     ((Buffer[1] = 'M') or (Buffer[1] = 'm')) and
     ((Buffer[2] = 'L') or (Buffer[2] = 'l')) then
  begin
    if not BufEquals(FName, 'xml') then
      FatalError('''xml'' is a reserved word; it must be lowercase', FName.Length)
    else
      FatalError('XML declaration is not allowed here', FName.Length);
  end;

  if FSource.FBuf^ <> '?' then
    SkipS(True);

  FValue.Length := 0;
  if not SkipUntilSeq(GT_Delim, '?') then
    FatalError('Unterminated processing instruction', -1);

  SetString(NameStr, FName.Buffer, FName.Length);
  SetString(ValueStr, FValue.Buffer, FValue.Length);
  // SAX: ContentHandler.ProcessingInstruction(Name, Value);
  if FCurrContentType = ctEmpty then
    ValidationError('Processing instructions are not allowed within EMPTY elements', []);

  PINode := Doc.CreateProcessingInstruction(NameStr, ValueStr);
  if Assigned(FCursor) then
    FCursor.AppendChild(PINode)
  else  // to comply with certain tests, insert PI from DTD before DTD
    Doc.InsertBefore(PINode, FDocType);
end;

const
  vers: array[Boolean] of TXMLVersion = (xmlVersion10, xmlVersion11);

procedure TXMLReader.ParseXmlOrTextDecl(TextDecl: Boolean);
var
  TmpStr: WideString;
  Ver: TXMLVersion;
  Delim: WideChar;
  buf: array[0..31] of WideChar;
  I: Integer;
  node: TDOMNode;
begin
  SkipS(True);
  if TextDecl then
    node := TDOMNode(FSource.FEntity)
  else
    node := doc;
  // [24] VersionInfo: optional in TextDecl, required in XmlDecl
  if (not TextDecl) or (FSource.FBuf^ = 'v') then
  begin
    ExpectString('version');
    ExpectEq;
    SkipQuote(Delim);
    I := 0;
    while (I < 3) and (FSource.FBuf^ <> Delim) do
    begin
      buf[I] := FSource.FBuf^;
      Inc(I);
      FSource.NextChar;
    end;
    if (I <> 3) or (buf[0] <> '1') or (buf[1] <> '.') or
      ((buf[2] <> '0') and (buf[2] <> '1')) then
      FatalError('Illegal version number', -1);

    ExpectChar(Delim);
    Ver := vers[buf[2] = '1'];

    if TextDecl and (Ver = xmlVersion11) and not FXML11 then
      FatalError('XML 1.0 document cannot invoke XML 1.1 entities', -1);
    if Assigned(node) then  { it is nil for external DTD subset }
      TDOMTopNodeEx(node).FXMLVersion := Ver;

    if TextDecl or (FSource.FBuf^ <> '?') then
      SkipS(True);
  end;

  // [80] EncodingDecl: required in TextDecl, optional in XmlDecl
  if TextDecl or (FSource.FBuf^ = 'e') then
  begin
    ExpectString('encoding');
    ExpectEq;
    SkipQuote(Delim);
    I := 0;
    while (I < 30) and (FSource.FBuf^ <> Delim) and (FSource.FBuf^ < #127) and
      ((Char(ord(FSource.FBuf^)) in ['A'..'Z', 'a'..'z']) or
      ((I > 0) and (Char(ord(FSource.FBuf^)) in ['0'..'9', '.', '-', '_']))) do
    begin
      buf[I] := FSource.FBuf^;
      Inc(I);
      FSource.NextChar;
    end;
    if not CheckForChar(Delim) then
      FatalError('Illegal encoding name', i);

    SetString(TmpStr, buf, i);
    if not FSource.SetEncoding(TmpStr) then  // <-- Wide2Ansi conversion here
      FatalError('Encoding ''%s'' is not supported', [TmpStr], i+1);
    // getting here means that specified encoding is supported
    // TODO: maybe assign the 'preferred' encoding name?
    if Assigned(node) then
      TDOMTopNodeEx(node).FXMLEncoding := TmpStr;

    if FSource.FBuf^ <> '?' then
      SkipS(not TextDecl);
  end;

  // [32] SDDecl: forbidden in TextDecl, optional in XmlDecl
  if (not TextDecl) and (FSource.FBuf^ = 's') then
  begin
    ExpectString('standalone');
    ExpectEq;
    SkipQuote(Delim);
    if FSource.Matches('yes') then
      FStandalone := True
    else if not FSource.Matches('no') then
      FatalError('Only "yes" or "no" are permitted as values of "standalone"', -1);
    ExpectChar(Delim);
    SkipS;
  end;

  ExpectString('?>');
  { Switch to 1.1 rules only after declaration is parsed completely. This is to
    ensure that NEL and LSEP within declaration are rejected (rmt-056, rmt-057) }
  if Ver = xmlVersion11 then
    FXML11 := True;
end;

procedure TXMLReader.DTDReloadHook;
var
  p: PWideChar;
begin
{ FSource converts CR, NEL and LSEP linebreaks to LF, and CR-NEL sequences to CR-LF.
  We must further remove the CR chars and have only LF's left. }
  p := FDTDStartPos;
  while p < FSource.FBuf do
  begin
    while (p < FSource.FBuf) and (p^ <> #13) do
      Inc(p);
    BufAppendChunk(FIntSubset, FDTDStartPos, p);
    if p^ = #13 then
      Inc(p);
    FDTDStartPos := p;
  end;
  FDTDStartPos := TXMLDecodingSource(FSource).FBufStart;
end;

procedure TXMLReader.ParseDoctypeDecl;    // [28]
var
  Src: TXMLCharSource;
begin
  if FState >= rsDTD then
    FatalError('Markup declaration is not allowed here');
  if FDisallowDoctype then
    FatalError('Document type is prohibited by parser settings');

  ExpectString('DOCTYPE');
  SkipS(True);

  FDocType := TDOMDocumentTypeEx(TDOMDocumentType.Create(doc));
  FDTDProcessed := True;    // assume success
  FState := rsDTD;
  try
    FDocType.FName := ExpectName;
    SkipS(True);
    ParseExternalID(FDocType.FSystemID, FDocType.FPublicID, False);
    SkipS;
  finally
    // DONE: append node after its name has been set; always append to avoid leak
    if FCanonical then
      FOwnsDoctype := True
    else
      Doc.AppendChild(FDocType);
    FCursor := nil;
  end;

  if CheckForChar('[') then
  begin
    BufAllocate(FIntSubset, 256);
    FSource.DTDSubsetType := dsInternal;
    try
      FDTDStartPos := FSource.FBuf;
      ParseMarkupDecl;
      DTDReloadHook;     // fetch last chunk
      SetString(FDocType.FInternalSubset, FIntSubset.Buffer, FIntSubset.Length);
    finally
      FreeMem(FIntSubset.Buffer);
      FSource.DTDSubsetType := dsNone;
    end;
    ExpectChar(']');
    SkipS;
  end;
  ExpectChar('>');

  if (FDocType.SystemID <> '') then
  begin
    if ResolveEntity(FDocType.SystemID, FDocType.PublicID, FSource.SystemID, Src) then
    begin
      Initialize(Src);
      try
        Src.DTDSubsetType := dsExternal;
        ParseMarkupDecl;
      finally
        ContextPop(True);
      end;
    end
    else
    begin
      ValidationError('Unable to resolve external DTD subset', []);
      FDTDProcessed := FStandalone;
    end;
  end;
  FCursor := Doc;
  ValidateDTD;
  FDocType.SetReadOnly(True);
end;

procedure TXMLReader.ExpectEq;   // [25]
begin
  if FSource.FBuf^ <> '=' then
    SkipS;
  if FSource.FBuf^ <> '=' then
    FatalError('Expected "="');
  FSource.NextChar;
  SkipS;
end;


{ DTD stuff }

procedure TXMLReader.BadPENesting(S: TErrorSeverity);
begin
  if (S = esFatal) or FValidate then
    DoError(S, 'Parameter entities must be properly nested');
end;

procedure TXMLReader.StandaloneError(LineOffs: Integer);
begin
  ValidationError('Standalone constriant violation', [], LineOffs);
end;

function TXMLReader.ParseQuantity: TCPQuant;
begin
  case FSource.FBuf^ of
    '?': Result := cqZeroOrOnce;
    '*': Result := cqZeroOrMore;
    '+': Result := cqOnceOrMore;
  else
    Result := cqOnce;
    Exit;
  end;
  FSource.NextChar;
end;

function TXMLReader.FindOrCreateElDef: TDOMElementDef;
var
  p: PHashItem;
begin
  CheckName;
  p := doc.Names.FindOrAdd(FName.Buffer, FName.Length);
  Result := TDOMElementDef(p^.Data);
  if Result = nil then
  begin
    Result := TDOMElementDef.Create(doc);
    Result.FNSI.QName := p;
    p^.Data := Result;
  end;
end;

procedure TXMLReader.ExpectChoiceOrSeq(CP: TContentParticle);                  // [49], [50]
var
  Delim: WideChar;
  CurrentEntity: TObject;
  CurrentCP: TContentParticle;
begin
  Delim := #0;
  repeat
    CurrentCP := CP.Add;
    SkipWhitespace;
    if CheckForChar('(') then
    begin
      CurrentEntity := FSource.FEntity;
      ExpectChoiceOrSeq(CurrentCP);
      if CurrentEntity <> FSource.FEntity then
        BadPENesting;
      FSource.NextChar;
    end
    else
      CurrentCP.Def := FindOrCreateElDef;

    CurrentCP.CPQuant := ParseQuantity;
    SkipWhitespace;
    if FSource.FBuf^ = ')' then
      Break;
    if Delim = #0 then
    begin
      if (FSource.FBuf^ = '|') or (FSource.FBuf^ = ',') then
        Delim := FSource.FBuf^
      else
        FatalError('Expected pipe or comma delimiter');
    end
    else
      if FSource.FBuf^ <> Delim then
        FatalError(Delim);
    FSource.NextChar; // skip delimiter
  until False;
  if Delim = '|' then
    CP.CPType := ctChoice
  else
    CP.CPType := ctSeq;    // '(foo)' is a sequence!
end;

procedure TXMLReader.ParseElementDecl;            // [45]
var
  ElDef: TDOMElementDef;
  CurrentEntity: TObject;
  I: Integer;
  CP: TContentParticle;
  Typ: TElementContentType;
  ExtDecl: Boolean;
begin
  CP := nil;
  Typ := ctUndeclared;         // satisfy compiler
  ExpectWhitespace;
  ElDef := FindOrCreateElDef;
  if ElDef.ContentType <> ctUndeclared then
    ValidationError('Duplicate declaration of element ''%s''', [ElDef.TagName], FName.Length);

  ExtDecl := FSource.DTDSubsetType <> dsInternal;

  ExpectWhitespace;
  if FSource.Matches('EMPTY') then
    Typ := ctEmpty
  else if FSource.Matches('ANY') then
    Typ := ctAny
  else if CheckForChar('(') then
  begin
    CP := TContentParticle.Create;
    try
      CurrentEntity := FSource.FEntity;
      SkipWhitespace;
      if FSource.Matches('#PCDATA') then       // Mixed section [51]
      begin
        SkipWhitespace;
        Typ := ctMixed;
        while FSource.FBuf^ <> ')' do
        begin
          ExpectChar('|');
          SkipWhitespace;

          with CP.Add do
          begin
            Def := FindOrCreateElDef;
            for I := CP.ChildCount-2 downto 0 do
              if Def = CP.Children[I].Def then
                ValidationError('Duplicate token in mixed section', [], FName.Length);
          end;
          SkipWhitespace;
        end;
        if CurrentEntity <> FSource.FEntity then
          BadPENesting;
        FSource.NextChar;
        if (not CheckForChar('*')) and (CP.ChildCount > 0) then
          FatalError(WideChar('*'));
      end
      else       // Children section [47]
      begin
        Typ := ctChildren;
        ExpectChoiceOrSeq(CP);
        if CurrentEntity <> FSource.FEntity then
          BadPENesting;
        FSource.NextChar;
        CP.CPQuant := ParseQuantity;
      end;
    except
      CP.Free;
      raise;
    end;
  end
  else
    FatalError('Invalid content specification');
  // SAX: DeclHandler.ElementDecl(name, model);
  if FDTDProcessed and (ElDef.ContentType = ctUndeclared) then
  begin
    ElDef.FExternallyDeclared := ExtDecl;
    ElDef.ContentType := Typ;
    ElDef.RootCP := CP;
  end
  else
    CP.Free;
end;


procedure TXMLReader.ParseNotationDecl;        // [82]
var
  NameStr, SysID, PubID: WideString;
begin
  ExpectWhitespace;
  NameStr := ExpectName;
  CheckNCName;
  ExpectWhitespace;
  if not ParseExternalID(SysID, PubID, True) then
    FatalError('Expected external or public ID');
  if FDTDProcessed then
    DoNotationDecl(NameStr, PubID, SysID);
end;

const
  AttrDataTypeNames: array[TAttrDataType] of WideString = (
    'CDATA',
    'ID',
    'IDREF',
    'IDREFS',
    'ENTITY',
    'ENTITIES',
    'NMTOKEN',
    'NMTOKENS',
    'NOTATION'
  );

procedure TXMLReader.ParseAttlistDecl;         // [52]
var
  ElDef: TDOMElementDef;
  AttDef: TDOMAttrDef;
  dt: TAttrDataType;
  Found, DiscardIt: Boolean;
  Offsets: array [Boolean] of Integer;
begin
  ExpectWhitespace;
  ElDef := FindOrCreateElDef;
  SkipWhitespace;
  while FSource.FBuf^ <> '>' do
  begin
    CheckName;
    ExpectWhitespace;
    AttDef := doc.CreateAttributeDef(FName.Buffer, FName.Length);
    try
      AttDef.ExternallyDeclared := FSource.DTDSubsetType <> dsInternal;
// In case of duplicate declaration of the same attribute, we must discard it,
// not modifying ElDef, and suppressing certain validation errors.
      DiscardIt := (not FDTDProcessed) or Assigned(ElDef.GetAttributeNode(AttDef.Name));
      if not DiscardIt then
        ElDef.SetAttributeNode(AttDef);

      if CheckForChar('(') then     // [59]
      begin
        AttDef.DataType := dtNmToken;
        repeat
          SkipWhitespace;
          CheckName([cnToken]);
          if not AttDef.AddEnumToken(FName.Buffer, FName.Length) then
            ValidationError('Duplicate token in enumerated attibute declaration', [], FName.Length);
          SkipWhitespace;
        until not CheckForChar('|');
        ExpectChar(')');
        ExpectWhitespace;
      end
      else
      begin
        StoreLocation(FTokenStart);
        // search topside-up so that e.g. NMTOKENS is matched before NMTOKEN
        for dt := dtNotation downto dtCData do
        begin
          Found := FSource.Matches(AttrDataTypeNames[dt]);
          if Found then
            Break;
        end;
        if Found and SkipWhitespace then
        begin
          AttDef.DataType := dt;
          if (dt = dtId) and not DiscardIt then
          begin
            if Assigned(ElDef.IDAttr) then
              ValidationError('Only one attribute of type ID is allowed per element',[])
            else
              ElDef.IDAttr := AttDef;
          end
          else if dt = dtNotation then          // no test cases for these ?!
          begin
            if not DiscardIt then
            begin
              if Assigned(ElDef.NotationAttr) then
                ValidationError('Only one attribute of type NOTATION is allowed per element',[])
              else
                ElDef.NotationAttr := AttDef;
              if ElDef.ContentType = ctEmpty then
                ValidationError('NOTATION attributes are not allowed on EMPTY elements',[]);
            end;
            ExpectChar('(');
            repeat
              SkipWhitespace;
              StoreLocation(FTokenStart);
              CheckName;
              CheckNCName;
              if not AttDef.AddEnumToken(FName.Buffer, FName.Length) then
                ValidationError('Duplicate token in NOTATION attribute declaration',[], FName.Length);

              if not DiscardIt then
                AddForwardRef(FNotationRefs, FName.Buffer, FName.Length);
              SkipWhitespace;
            until not CheckForChar('|');
            ExpectChar(')');
            ExpectWhitespace;
          end;
        end
        else
        begin
          // don't report 'expected whitespace' if token does not match completely
          Offsets[False] := 0;
          Offsets[True] := Length(AttrDataTypeNames[dt]);
          if Found and (FSource.FBuf^ < 'A') then
            ExpectWhitespace
          else
            FatalError('Illegal attribute type for ''%s''', [AttDef.Name], Offsets[Found]);
        end;
      end;
      StoreLocation(FTokenStart);
      if FSource.Matches('#REQUIRED') then
        AttDef.Default := adRequired
      else if FSource.Matches('#IMPLIED') then
        AttDef.Default := adImplied
      else if FSource.Matches('#FIXED') then
      begin
        AttDef.Default := adFixed;
        ExpectWhitespace;
      end
      else
        AttDef.Default := adDefault;

      if AttDef.Default in [adDefault, adFixed] then
      begin
        if AttDef.DataType = dtId then
          ValidationError('An attribute of type ID cannot have a default value',[]);

        FCursor := AttDef;
// See comments to valid-sa-094: PE expansion should be disabled in AttDef.
// ExpectAttValue() does not recognize PEs anyway, so setting FRecognizePEs isn't needed
// Saving/restoring FCursor is also redundant because it is always nil here.
        ExpectAttValue;
        FCursor := nil;
        if not ValidateAttrSyntax(AttDef, AttDef.NodeValue) then
          ValidationError('Default value for attribute ''%s'' has wrong syntax', [AttDef.Name]);
      end;
      // SAX: DeclHandler.AttributeDecl(...)
      if DiscardIt then
        AttDef.Free;
    except
      AttDef.Free;
      raise;
    end;
    SkipWhitespace;
  end;
end;

procedure TXMLReader.ParseEntityDecl;        // [70]
var
  IsPE: Boolean;
  Entity: TDOMEntityEx;
  Map: TDOMNamedNodeMap;
begin
  if not SkipWhitespace(True) then
    FatalError('Expected whitespace');
  IsPE := False;
  Map := FDocType.Entities;
  if CheckForChar('%') then                  // [72]
  begin
    ExpectWhitespace;
    IsPE := True;
    if FPEMap = nil then
      FPEMap := TDOMNamedNodeMap.Create(FDocType, ENTITY_NODE);
    Map := FPEMap;
  end;

  Entity := TDOMEntityEx.Create(Doc);
  Entity.SetReadOnly(True);
  try
    Entity.FExternallyDeclared := FSource.DTDSubsetType <> dsInternal;
    Entity.FIsPE := IsPE;
    Entity.FName := ExpectName;
    CheckNCName;
    ExpectWhitespace;

    // remember where the entity is declared
    Entity.FURI := FSource.SystemID;

    if FEntityValue.Buffer = nil then
      BufAllocate(FEntityValue, 256);

    if ParseLiteral(FEntityValue, ltEntity, False) then
    begin
      SetString(Entity.FReplacementText, FEntityValue.Buffer, FEntityValue.Length);
      Entity.FCharCount := FEntityValue.Length;
      Entity.FStartLocation := FTokenStart;
    end
    else
    begin
      if not ParseExternalID(Entity.FSystemID, Entity.FPublicID, False) then
        FatalError('Expected entity value or external ID');

      if not IsPE then                // [76]
      begin
        if FSource.FBuf^ <> '>' then
          ExpectWhitespace;
        if FSource.Matches('NDATA') then
        begin
          ExpectWhitespace;
          StoreLocation(FTokenStart);
          Entity.FNotationName := ExpectName;
          AddForwardRef(FNotationRefs, FName.Buffer, FName.Length);
          // SAX: DTDHandler.UnparsedEntityDecl(...);
        end;
      end;
    end;
  except
    Entity.Free;
    raise;
  end;

  // Repeated declarations of same entity are legal but must be ignored
  if FDTDProcessed and (Map.GetNamedItem(Entity.FName) = nil) then
    Map.SetNamedItem(Entity)
  else
    Entity.Free;
end;


procedure TXMLReader.ParseMarkupDecl;        // [29]
var
  IncludeLevel: Integer;
  IgnoreLevel: Integer;
  CurrentEntity: TObject;
  IncludeLoc: TLocation;
  IgnoreLoc: TLocation;
  wc: WideChar;
  CondType: (ctUnknown, ctInclude, ctIgnore);
begin
  IncludeLevel := 0;
  IgnoreLevel := 0;
  repeat
    SkipWhitespace;

    if (FSource.FBuf^ = ']') and (IncludeLevel > 0) then
    begin
      ExpectString(']]>');
      Dec(IncludeLevel);
      Continue;
    end;

    if not CheckForChar('<') then
      Break;

    CurrentEntity := FSource.FEntity;

    if FSource.FBuf^ = '?' then
      ParsePI
    else
    begin
      ExpectChar('!');
      if FSource.FBuf^ = '-' then
        ParseComment
      else if CheckForChar('[') then
      begin
        if FSource.DTDSubsetType = dsInternal then
          FatalError('Conditional sections are not allowed in internal subset', 1);

        SkipWhitespace;

        CondType := ctUnknown;  // satisfy compiler
        if FSource.Matches('INCLUDE') then
          CondType := ctInclude
        else if FSource.Matches('IGNORE') then
          CondType := ctIgnore
        else
          FatalError('Expected "INCLUDE" or "IGNORE"');

        SkipWhitespace;
        if CurrentEntity <> FSource.FEntity then
          BadPENesting;
        ExpectChar('[');
        if CondType = ctInclude then
        begin
          if IncludeLevel = 0 then
            StoreLocation(IncludeLoc);
          Inc(IncludeLevel);
        end
        else if CondType = ctIgnore then
        begin
          StoreLocation(IgnoreLoc);
          IgnoreLevel := 1;
          repeat
            FValue.Length := 0;
            wc := FSource.SkipUntil(FValue, [#0, '<', ']']);
            if FSource.Matches('<![') then
              Inc(IgnoreLevel)
            else if FSource.Matches(']]>') then
              Dec(IgnoreLevel)
            else if wc <> #0 then
              FSource.NextChar
            else // PE's aren't recognized in ignore section, cannot ContextPop()
              DoErrorPos(esFatal, 'IGNORE section is not closed', IgnoreLoc);
          until IgnoreLevel=0;
        end;
      end
      else
      begin
        FInsideDecl := True;
        if FSource.Matches('ELEMENT') then
          ParseElementDecl
        else if FSource.Matches('ENTITY') then
          ParseEntityDecl
        else if FSource.Matches('ATTLIST') then
          ParseAttlistDecl
        else if FSource.Matches('NOTATION') then
          ParseNotationDecl
        else
          FatalError('Illegal markup declaration');

        SkipWhitespace;

        if CurrentEntity <> FSource.FEntity then
          BadPENesting;
        ExpectChar('>');
        FInsideDecl := False;
      end;
    end;
  until False;
  if IncludeLevel > 0 then
    DoErrorPos(esFatal, 'INCLUDE section is not closed', IncludeLoc);
  if (FSource.DTDSubsetType = dsInternal) and (FSource.FBuf^ = ']') then
    Exit;
  if FSource.FBuf^ <> #0 then
    FatalError('Illegal character in DTD');
end;

procedure TXMLReader.ProcessDTD(ASource: TXMLCharSource);
begin
  doc := TXMLDocument.Create;
  FDocType := TDOMDocumentTypeEx.Create(doc);
  // TODO: DTD labeled version 1.1 will be rejected - must set FXML11 flag
  // DONE: It's ok to have FCursor=nil now
  doc.AppendChild(FDocType);
  Initialize(ASource);
  ParseMarkupDecl;
end;

procedure TXMLReader.AppendReference(AEntity: TDOMEntityEx);
var
  s: WideString;
begin
  if AEntity = nil then
    SetString(s, FName.Buffer, FName.Length)
  else
    s := AEntity.nodeName;
  FCursor.AppendChild(doc.CreateEntityReference(s));
end;


// The code below does the bulk of the parsing, and must be as fast as possible.
// To minimize CPU cache effects, methods from different classes are kept together

function TXMLDecodingSource.SkipUntil(var ToFill: TWideCharBuf; const Delim: TSetOfChar;
  wsflag: PBoolean): WideChar;
var
  old: PWideChar;
  nonws: Boolean;
  wc: WideChar;
begin
  nonws := False;
  repeat
    old := FBuf;
    repeat
      wc := FBuf^;
      if (wc = #10) or (wc = #13) or (FXML11Rules and ((wc = #$85) or
        (wc = #$2028))) then
      begin
// strictly this is needed only for 2-byte lineendings
        BufAppendChunk(ToFill, old, FBuf);
        NewLine;
        old := FBuf;
        wc := FBuf^
      end
      else if ((wc < #32) and (not ((wc = #0) and (FBuf >= FBufEnd))) and
        (wc <> #9)) or (wc > #$FFFD) or
        (FXML11Rules and (wc >= #$7F) and (wc <= #$9F)) then
             FReader.FatalError('Invalid character');
      if (wc < #255) and (Char(ord(wc)) in Delim) then
        Break;
// the checks above filter away everything below #32 that isn't a whitespace
      if wc > #32 then
        nonws := True;
      Inc(FBuf);
    until False;
    Result := wc;
    BufAppendChunk(ToFill, old, FBuf);
  until (Result <> #0) or (not Reload);
  if Assigned(wsflag) then
    wsflag^ := wsflag^ or nonws;
end;

const
  TextDelims: array[Boolean] of TSetOfChar = (
    [#0, '<', '&', '>'],
    [#0, '>']
  );

type
  TXMLToken = (xtNone, xtText, xtElement, xtEndElement, xtCDSect, xtComment, xtPI, xtDoctype, xtEntity, xtEntityEnd);

procedure TXMLReader.ParseContent;
var
  nonWs: Boolean;
  wc: WideChar;
  ent: TDOMEntityEx;
  InCDATA: Boolean;
  tok: TXMLToken;
begin
  InCDATA := False;
  StoreLocation(FTokenStart);
  nonWs := False;
  FValue.Length := 0;
  repeat
    wc := FSource.SkipUntil(FValue, TextDelims[InCDATA], @nonWs);
    if wc = '<' then
    begin
      Inc(FSource.FBuf);
      if FSource.FBufEnd < FSource.FBuf + 2 then
        FSource.Reload;
      if FSource.FBuf^ = '/' then
        tok := xtEndElement
      else if CheckName([cnOptional]) then
        tok := xtElement
      else if FSource.FBuf^ = '!' then
      begin
        Inc(FSource.FBuf);
        if FSource.FBuf^ = '[' then
        begin
          ExpectString('[CDATA[');
          if FState <> rsRoot then
            FatalError('Illegal at document level');
          StoreLocation(FTokenStart);
          InCDATA := True;
          if FCDSectionsAsText or (FValue.Length = 0) then
            Continue;
          tok := xtCDSect;
        end
        else if FSource.FBuf^ = '-' then
        begin
          if FIgnoreComments then
          begin
            ParseComment;
            Continue;
          end;
          tok := xtComment;
        end
        else
          tok := xtDoctype;
      end
      else if FSource.FBuf^ = '?' then
        tok := xtPI
      else
        RaiseNameNotFound;
    end
    else if wc = #0 then
    begin
      if InCDATA then
        FatalError('Unterminated CDATA section', -1);
      if FNesting > FSource.FStartNesting then
        FatalError('End-tag is missing for ''%s''', [FValidator[FNesting].FElement.NSI.QName^.Key]);
      if ContextPop then Continue;
      Break;
    end
    else if wc = '>' then
    begin
      BufAppend(FValue, wc);
      FSource.NextChar;

      if (FValue.Length <= 2) or (FValue.Buffer[FValue.Length-2] <> ']') or
        (FValue.Buffer[FValue.Length-3] <> ']') then Continue;

      if InCData then   // got a ']]>' separator
      begin
        Dec(FValue.Length, 3);
        InCDATA := False;
        if FCDSectionsAsText then
          Continue;
        tok := xtText;
      end
      else
        FatalError('Literal '']]>'' is not allowed in text', 3);
    end
    else if wc = '&' then
    begin
      if FState <> rsRoot then
        FatalError('Illegal at document level');

      if FCurrContentType = ctEmpty then
        ValidationError('References are illegal in EMPTY elements', []);

      if ParseRef(FValue) or ResolvePredefined then
      begin
        nonWs := True; // CharRef to whitespace is not considered whitespace
        Continue;
      end
      else
      begin
        ent := EntityCheck;
        if Assigned(ent) and FExpandEntities then
        begin
          ContextPush(ent);
          Continue;
        end;
        tok := xtEntity;
      end;
    end;
    // flush text accumulated this far
    if tok = xtText then
      DoCDSect(FValue.Buffer, FValue.Length)
    else
      DoText(FValue.Buffer, FValue.Length, not nonWs);
    case tok of
      xtEntity:     AppendReference(ent);
      xtElement:    ParseStartTag;
      xtEndElement: ParseEndTag;
      xtPI:         ParsePI;
      xtDoctype:    ParseDoctypeDecl;
      xtComment:    ParseComment;
    end;
    StoreLocation(FTokenStart);
    FValue.Length := 0;
    nonWs := False;
  until False;
  DoText(FValue.Buffer, FValue.Length, not nonWs);
end;

procedure TXMLCharSource.NextChar;
begin
  Inc(FBuf);
  if FBuf >= FBufEnd then
    Reload;
end;

procedure TXMLReader.ExpectChar(wc: WideChar);
begin
  if FSource.FBuf^ = wc then
    FSource.NextChar
  else
    FatalError(wc);
end;

// Element name already in FNameBuffer
procedure TXMLReader.ParseStartTag;    // [39] [40] [44]
var
  NewElem: TDOMElement;
  ElDef: TDOMElementDef;
  IsEmpty: Boolean;
  ElName: PHashItem;
begin
  if FState > rsRoot then
    FatalError('Only one top-level element allowed', FName.Length)
  else if FState < rsRoot then
  begin
    if FValidate then
      ValidateRoot;
    FState := rsRoot;
  end;

  NewElem := doc.CreateElementBuf(FName.Buffer, FName.Length);
  FCursor.AppendChild(NewElem);
  // we're about to process a new set of attributes
  Inc(FAttrTag);

  // Remember the hash entry, we'll need it often
  ElName := NewElem.NSI.QName;

  // Find declaration for this element
  ElDef := TDOMElementDef(ElName^.Data);
  if (ElDef = nil) or (ElDef.ContentType = ctUndeclared) then
    ValidationError('Using undeclared element ''%s''',[ElName^.Key], FName.Length);

  // Check if new element is allowed in current context
  if FValidate and not FValidator[FNesting].IsElementAllowed(ElDef) then
    ValidationError('Element ''%s'' is not allowed in this context',[ElName^.Key], FName.Length);

  IsEmpty := False;
  while (FSource.FBuf^ <> '>') and (FSource.FBuf^ <> '/') do
  begin
    SkipS(True);
    if (FSource.FBuf^ = '>') or (FSource.FBuf^ = '/') then
      Break;
    ParseAttribute(NewElem, ElDef);
  end;

  if FSource.FBuf^ = '/' then
  begin
    IsEmpty := True;
    FSource.NextChar;
  end;
  ExpectChar('>');

  if Assigned(ElDef) and Assigned(ElDef.FAttributes) then
    ProcessDefaultAttributes(NewElem, ElDef.FAttributes);
  PushVC(NewElem, ElDef);  // this increases FNesting
  if FNamespaces then
    ProcessNamespaceAtts(NewElem);

  if not IsEmpty then
  begin
    FCursor := NewElem;
    if not FPreserveWhitespace then   // critical for testsuite compliance
      SkipS;
  end
  else
    DoEndElement(0);
end;

procedure TXMLReader.DoEndElement(ErrOffset: Integer);
var
  NewElem: TDOMElement;
begin
  NewElem := FValidator[FNesting].FElement;
  TDOMNode(FCursor) := NewElem.ParentNode;
  if FCursor = doc then
    FState := rsEpilog;

  if FValidate and FValidator[FNesting].Incomplete then
    ValidationError('Element ''%s'' is missing required sub-elements', [NewElem.NSI.QName^.Key], ErrOffset);

  if FNamespaces then
    FNSHelper.EndElement;
  PopVC;
end;

procedure TXMLReader.ParseEndTag;     // [42]
var
  ElName: PHashItem;
begin
  if FNesting <= FSource.FStartNesting then
    FatalError('End-tag is not allowed here');
  Inc(FSource.FBuf);

  ElName := FValidator[FNesting].FElement.NSI.QName;

  CheckName;
  if not BufEquals(FName, ElName^.Key) then
    FatalError('Unmatching element end tag (expected "</%s>")', [ElName^.Key], FName.Length);
  if FSource.FBuf^ = '>' then    // this handles majority of cases
  begin
    FSource.NextChar;
    DoEndElement(FName.Length+1);
  end
  else    // but if closing '>' is preceded by whitespace,
  begin   // skipping it is likely to lose position info.
    StoreLocation(FTokenStart);
    Dec(FTokenStart.LinePos, FName.Length);
    SkipS;
    ExpectChar('>');
    DoEndElement(-1);
  end;
end;

procedure TXMLReader.ParseAttribute(Elem: TDOMElement; ElDef: TDOMElementDef);
var
  attr: TDOMAttr;
  AttDef: TDOMAttrDef;
  OldAttr: TDOMNode;

procedure CheckValue;
var
  AttValue, OldValue: WideString;
begin
  if FStandalone and AttDef.ExternallyDeclared then
  begin
    OldValue := Attr.Value;
    Attr.DataType := AttDef.DataType;
    AttValue := Attr.Value;
    if AttValue <> OldValue then
      StandaloneError(-1);
  end
  else
  begin
    Attr.DataType := AttDef.DataType;
    AttValue := Attr.Value;
  end;
  // TODO: what about normalization of AttDef.Value? (Currently it IS normalized)
  if (AttDef.Default = adFixed) and (AttDef.Value <> AttValue) then
    ValidationError('Value of attribute ''%s'' does not match its #FIXED default',[AttDef.Name], -1);
  if not ValidateAttrSyntax(AttDef, AttValue) then
    ValidationError('Attribute ''%s'' type mismatch', [AttDef.Name], -1);
  ValidateAttrValue(Attr, AttValue);
end;

begin
  CheckName;
  attr := doc.CreateAttributeBuf(FName.Buffer, FName.Length);

  if Assigned(ElDef) then
  begin
    AttDef := TDOMAttrDef(ElDef.GetAttributeNode(attr.NSI.QName^.Key));
    if AttDef = nil then
      ValidationError('Using undeclared attribute ''%s'' on element ''%s''',[attr.NSI.QName^.Key, Elem.NSI.QName^.Key], FName.Length)
    else
      AttDef.Tag := FAttrTag;  // indicates that this one is specified
  end
  else
    AttDef := nil;

  // !!cannot use TDOMElement.SetAttributeNode because it will free old attribute
  OldAttr := Elem.Attributes.SetNamedItem(Attr);
  if Assigned(OldAttr) then
  begin
    OldAttr.Free;
    FatalError('Duplicate attribute', FName.Length);
  end;
  ExpectEq;
  FCursor := attr;
  ExpectAttValue;

  if Assigned(AttDef) and ((AttDef.DataType <> dtCdata) or (AttDef.Default = adFixed)) then
    CheckValue;
end;

procedure TXMLReader.AddForwardRef(aList: TFPList; Buf: PWideChar; Length: Integer);
var
  w: PForwardRef;
begin
  New(w);
  SetString(w^.Value, Buf, Length);
  w^.Loc := FTokenStart;
  aList.Add(w);
end;

procedure TXMLReader.ClearRefs(aList: TFPList);
var
  I: Integer;
begin
  for I := 0 to aList.Count-1 do
    Dispose(PForwardRef(aList.List^[I]));
  aList.Clear;
end;

procedure TXMLReader.ValidateIdRefs;
var
  I: Integer;
begin
  for I := 0 to FIDRefs.Count-1 do
    with PForwardRef(FIDRefs.List^[I])^ do
      if Doc.GetElementById(Value) = nil then
        DoErrorPos(esError, Format('The ID ''%s'' does not match any element', [Value]), Loc);
  ClearRefs(FIDRefs);
end;

procedure TXMLReader.ProcessDefaultAttributes(Element: TDOMElement; Map: TDOMNamedNodeMap);
var
  I: Integer;
  AttDef: TDOMAttrDef;
  Attr: TDOMAttr;
begin
  for I := 0 to Map.Length-1 do
  begin
    AttDef := Map[I] as TDOMAttrDef;

    if AttDef.Tag <> FAttrTag then  // this one wasn't specified
    begin
      case AttDef.Default of
        adDefault, adFixed: begin
          if FStandalone and AttDef.ExternallyDeclared then
            StandaloneError;
          Attr := TDOMAttr(AttDef.CloneNode(True));
          Element.SetAttributeNode(Attr);
          ValidateAttrValue(Attr, Attr.Value);
        end;
        adRequired:  ValidationError('Required attribute ''%s'' of element ''%s'' is missing',[AttDef.Name, Element.TagName], 0)
      end;
    end;
  end;
end;


procedure TXMLReader.AddBinding(Attr: TDOMAttr; PrefixPtr: PWideChar; PrefixLen: Integer);
var
  nsUri: DOMString;
  Pfx: PHashItem;
begin
  nsUri := Attr.NodeValue;
  Pfx := FNSHelper.GetPrefix(PrefixPtr, PrefixLen);
  { 'xml' is allowed to be bound to the correct namespace }
  if ((nsUri = stduri_xml) <> (Pfx = FStdPrefix_xml)) or
   (Pfx = FStdPrefix_xmlns) or
   (nsUri = stduri_xmlns) then
  begin
    if (Pfx = FStdPrefix_xml) or (Pfx = FStdPrefix_xmlns) then
      FatalError('Illegal usage of reserved prefix ''%s''', [Pfx^.Key])
    else
      FatalError('Illegal usage of reserved namespace URI ''%s''', [nsUri]);
  end;

  if (nsUri = '') and not (FXML11 or (Pfx^.Key = '')) then
    FatalError('Illegal undefining of namespace');  { position - ? }

  FNSHelper.BindPrefix(nsURI, Pfx);
end;

procedure TXMLReader.ProcessNamespaceAtts(Element: TDOMElement);
var
  I, J: Integer;
  Map: TDOMNamedNodeMap;
  Pfx, AttrName: PHashItem;
  Attr: TDOMAttr;
  PrefixCount: Integer;
  b: TBinding;
begin
  FNSHelper.StartElement;

  PrefixCount := 0;
  if Element.HasAttributes then
  begin
    Map := Element.Attributes;
    if Map.Length > LongWord(Length(FWorkAtts)) then
      SetLength(FWorkAtts, Map.Length+10);
    { Pass 1, identify prefixed attrs and assign prefixes }
    for I := 0 to Map.Length-1 do
    begin
      Attr := TDOMAttr(Map[I]);
      AttrName := Attr.NSI.QName;
      if Pos(WideString('xmlns'), AttrName^.Key) = 1 then
      begin
        { this is a namespace declaration }
        if Length(AttrName^.Key) = 5 then
        begin
          // TODO: check all consequences of having zero PrefixLength
          Attr.SetNSI(stduri_xmlns, 0);
          AddBinding(Attr, nil, 0);
        end
        else if AttrName^.Key[6] = ':' then
        begin
          Attr.SetNSI(stduri_xmlns, 6);
          AddBinding(Attr, @AttrName^.Key[7], Length(AttrName^.Key)-6);
        end;
      end
      else
      begin
        J := Pos(WideChar(':'), AttrName^.Key);
        if J > 1 then
        begin
          FWorkAtts[PrefixCount].Attr := Attr;
          FWorkAtts[PrefixCount].PrefixLen := J;
          Inc(PrefixCount);
        end;
      end;
    end;
  end;
  { Pass 2, now all bindings are known, handle remaining prefixed attributes }
  if PrefixCount > 0 then
  begin
    FNsAttHash.Init(PrefixCount);
    for I := 0 to PrefixCount-1 do
    begin
      AttrName := FWorkAtts[I].Attr.NSI.QName;
      if not FNSHelper.IsPrefixBound(PWideChar(AttrName^.Key), FWorkAtts[I].PrefixLen-1, Pfx) then
        FatalError('Unbound prefix "%s"', [Pfx^.Key]);

      b := TBinding(Pfx^.Data);
      { detect duplicates }
      J := FWorkAtts[I].PrefixLen+1;

      if FNsAttHash.Locate(@b.uri, @AttrName^.Key[J], Length(AttrName^.Key) - J+1) then
        FatalError('Duplicate prefixed attribute');

      // convert Attr into namespaced one (by hack for the time being)
      FWorkAtts[I].Attr.SetNSI(b.uri, J-1);
    end;
  end;
  { Finally, expand the element name }
  J := Pos(WideChar(':'), Element.NSI.QName^.Key);
  if J > 1 then
  begin
    if not FNSHelper.IsPrefixBound(PWideChar(Element.NSI.QName^.Key), J-1, Pfx) then
      FatalError('Unbound prefix "%s"', [Pfx^.Key]);
    b := TBinding(Pfx^.Data);
    Element.SetNSI(b.uri, J);
  end
  else
  begin
    b := FNSHelper.DefaultNSBinding;
    if Assigned(b) then
      Element.SetNSI(b.uri, 0);
  end;
end;

function TXMLReader.ParseExternalID(out SysID, PubID: WideString;     // [75]
  SysIdOptional: Boolean): Boolean;
var
  I: Integer;
  wc: WideChar;
begin
  Result := False;
  if FSource.Matches('SYSTEM') then
    SysIdOptional := False
  else if FSource.Matches('PUBLIC') then
  begin
    ExpectWhitespace;
    ParseLiteral(FValue, ltPubid, True);
    SetString(PubID, FValue.Buffer, FValue.Length);
    for I := 1 to Length(PubID) do
    begin
      wc := PubID[I];
      if (wc > #255) or not (Char(ord(wc)) in PubidChars) then
        FatalError('Illegal Public ID literal', -1);
    end;
  end
  else
    Exit;

  if SysIdOptional then
    SkipWhitespace
  else
    ExpectWhitespace;
  if ParseLiteral(FValue, ltPlain, not SysIdOptional) then
    SetString(SysID, FValue.Buffer, FValue.Length);
  Result := True;
end;

function TXMLReader.ValidateAttrSyntax(AttrDef: TDOMAttrDef; const aValue: WideString): Boolean;
begin
  case AttrDef.DataType of
    dtId, dtIdRef, dtEntity: Result := IsXmlName(aValue, FXML11) and
      ((not FNamespaces) or (Pos(WideChar(':'), aValue) = 0));
    dtIdRefs, dtEntities: Result := IsXmlNames(aValue, FXML11) and
      ((not FNamespaces) or (Pos(WideChar(':'), aValue) = 0));
    dtNmToken: Result := IsXmlNmToken(aValue, FXML11) and AttrDef.HasEnumToken(aValue);
    dtNmTokens: Result := IsXmlNmTokens(aValue, FXML11);
    // IsXmlName() not necessary - enum is never empty and contains valid names
    dtNotation: Result := AttrDef.HasEnumToken(aValue);
  else
    Result := True;
  end;
end;

procedure TXMLReader.ValidateAttrValue(Attr: TDOMAttr; const aValue: WideString);
var
  L, StartPos, EndPos: Integer;
  Entity: TDOMEntity;
begin
  L := Length(aValue);
  case Attr.DataType of
    dtId: if not Doc.AddID(Attr) then
            ValidationError('The ID ''%s'' is not unique', [aValue], -1);

    dtIdRef, dtIdRefs: begin
      StartPos := 1;
      while StartPos <= L do
      begin
        EndPos := StartPos;
        while (EndPos <= L) and (aValue[EndPos] <> #32) do
          Inc(EndPos);
        AddForwardRef(FIDRefs, @aValue[StartPos], EndPos-StartPos);
        StartPos := EndPos + 1;
      end;
    end;

    dtEntity, dtEntities: begin
      StartPos := 1;
      while StartPos <= L do
      begin
        EndPos := StartPos;
        while (EndPos <= L) and (aValue[EndPos] <> #32) do
          Inc(EndPos);
        Entity := TDOMEntity(FDocType.Entities.GetNamedItem(Copy(aValue, StartPos, EndPos-StartPos)));
        if (Entity = nil) or (Entity.NotationName = '') then
          ValidationError('Attribute ''%s'' type mismatch', [Attr.Name], -1);
        StartPos := EndPos + 1;
      end;
    end;
  end;
end;

procedure TXMLReader.ValidateRoot;
begin
  if Assigned(FDocType) then
  begin
    if not BufEquals(FName, FDocType.Name) then
      ValidationError('Root element name does not match DTD', [], FName.Length);
  end
  else
    ValidationError('Missing DTD', [], FName.Length);
end;

procedure TXMLReader.ValidateDTD;
var
  I: Integer;
begin
  if FValidate then
    for I := 0 to FNotationRefs.Count-1 do
      with PForwardRef(FNotationRefs[I])^ do
        if FDocType.Notations.GetNamedItem(Value) = nil then
          DoErrorPos(esError, Format('Notation ''%s'' is not declared', [Value]), Loc);
  ClearRefs(FNotationRefs);
end;

procedure TXMLReader.DoText(ch: PWideChar; Count: Integer; Whitespace: Boolean);
var
  TextNode: TDOMText;
begin
  if FState <> rsRoot then
    if not Whitespace then
      FatalError('Illegal at document level', -1)
    else
      Exit;  

  if (Whitespace and (not FPreserveWhitespace)) or (Count = 0) then
    Exit;

  // Validating filter part
  case FCurrContentType of
    ctChildren:
      if not Whitespace then
        ValidationError('Character data is not allowed in element-only content',[])
      else
        if FSaViolation then
          StandaloneError(-1);
    ctEmpty:
      ValidationError('Character data is not allowed in EMPTY elements', []);
  end;

  // Document builder part
  TextNode := Doc.CreateTextNodeBuf(ch, Count, Whitespace and (FCurrContentType = ctChildren));
  FCursor.AppendChild(TextNode);
end;

procedure TXMLReader.DoAttrText(ch: PWideChar; Count: Integer);
begin
  FCursor.AppendChild(Doc.CreateTextNodeBuf(ch, Count, False));
end;

procedure TXMLReader.DoComment(ch: PWideChar; Count: Integer);
var
  Node: TDOMComment;
begin
  // validation filter part
  if FCurrContentType = ctEmpty then
    ValidationError('Comments are not allowed within EMPTY elements', []);

  // DOM builder part
  if (not FIgnoreComments) and Assigned(FCursor) then
  begin
    Node := Doc.CreateCommentBuf(ch, Count);
    FCursor.AppendChild(Node);
  end;
end;

procedure TXMLReader.DoCDSect(ch: PWideChar; Count: Integer);
var
  s: WideString;
begin
  Assert(not FCDSectionsAsText, 'Should not be called when CDSectionsAsText=True');

  if FCurrContentType = ctChildren then
    ValidationError('CDATA sections are not allowed in element-only content',[]);

  SetString(s, ch, Count);
  FCursor.AppendChild(doc.CreateCDATASection(s));
end;

procedure TXMLReader.DoNotationDecl(const aName, aPubID, aSysID: WideString);
var
  Notation: TDOMNotationEx;
begin
  if FDocType.Notations.GetNamedItem(aName) = nil then
  begin
    Notation := TDOMNotationEx(TDOMNotation.Create(doc));
    Notation.FName := aName;
    Notation.FPublicID := aPubID;
    Notation.FSystemID := aSysID;
    FDocType.Notations.SetNamedItem(Notation);
  end
  else
    ValidationError('Duplicate notation declaration: ''%s''', [aName]);
end;

procedure TXMLReader.PushVC(aElement: TDOMElement; aElDef: TDOMElementDef);
begin
  Inc(FNesting);
  if FNesting >= Length(FValidator) then
    SetLength(FValidator, FNesting * 2);
  FValidator[FNesting].FElement := aElement;
  FValidator[FNesting].FElementDef := aElDef;
  FValidator[FNesting].FCurCP := nil;
  FValidator[FNesting].FFailed := False;
  UpdateConstraints;
end;

procedure TXMLReader.PopVC;
begin
  if FNesting > 0 then Dec(FNesting);
  UpdateConstraints;
end;

procedure TXMLReader.UpdateConstraints;
begin
  if FValidate and Assigned(FValidator[FNesting].FElementDef) then
  begin
    FCurrContentType := FValidator[FNesting].FElementDef.ContentType;
    FSaViolation := FStandalone and (FValidator[FNesting].FElementDef.FExternallyDeclared);
  end
  else
  begin
    FCurrContentType := ctAny;
    FSaViolation := False;
  end;
end;

{ TElementValidator }

function TElementValidator.IsElementAllowed(Def: TDOMElementDef): Boolean;
var
  I: Integer;
  Next: TContentParticle;
begin
  Result := True;
  // if element is not declared, non-validity has been already reported, no need to report again...
  if Assigned(Def) and Assigned(FElementDef) then
  begin
    case FElementDef.ContentType of
      ctMixed: begin
        for I := 0 to FElementDef.RootCP.ChildCount-1 do
        begin
          if Def = FElementDef.RootCP.Children[I].Def then
          Exit;
        end;
        Result := False;
      end;

      ctEmpty: Result := False;

      ctChildren: begin
        if FCurCP = nil then
          Next := FElementDef.RootCP.FindFirst(Def)
        else
          Next := FCurCP.FindNext(Def, 0); { second arg ignored here }
        Result := Assigned(Next);
        if Result then
          FCurCP := Next
        else
          FFailed := True;  // used to prevent extra error at the end of element
      end;
      // ctAny, ctUndeclared: returns True by default
    end;
  end;
end;

function TElementValidator.Incomplete: Boolean;
begin
  if Assigned(FElementDef) and (FElementDef.ContentType = ctChildren) and (not FFailed) then
  begin
    if FCurCP <> nil then
      Result := FCurCP.MoreRequired(0) { arg ignored here }
    else
      Result := FElementDef.RootCP.IsRequired;
  end
  else
    Result := False;
end;

{ TContentParticle }

function TContentParticle.Add: TContentParticle;
begin
  if FChildren = nil then
    FChildren := TFPList.Create;
  Result := TContentParticle.Create;
  Result.FParent := Self;
  Result.FIndex := FChildren.Add(Result);
end;

destructor TContentParticle.Destroy;
var
  I: Integer;
begin
  if Assigned(FChildren) then
    for I := FChildren.Count-1 downto 0 do
      TObject(FChildren[I]).Free;
  FChildren.Free;
  inherited Destroy;
end;

function TContentParticle.GetChild(Index: Integer): TContentParticle;
begin
  Result := TContentParticle(FChildren[Index]);
end;

function TContentParticle.GetChildCount: Integer;
begin
  if Assigned(FChildren) then
    Result := FChildren.Count
  else
    Result := 0;
end;

function TContentParticle.IsRequired: Boolean;
var
  I: Integer;
begin
  Result := (CPQuant = cqOnce) or (CPQuant = cqOnceOrMore);
  // do not return True if all children are optional
  if (CPType <> ctName) and Result then
  begin
    for I := 0 to ChildCount-1 do
    begin
      Result := Children[I].IsRequired;
      if Result then Exit;
    end;
  end;
end;

function TContentParticle.MoreRequired(ChildIdx: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if CPType = ctSeq then
  begin
    for I := ChildIdx + 1 to ChildCount-1 do
    begin
      Result := Children[I].IsRequired;
      if Result then Exit;
    end;
  end;
  if Assigned(FParent) then
    Result := FParent.MoreRequired(FIndex);
end;

function TContentParticle.FindFirst(aDef: TDOMElementDef): TContentParticle;
var
  I: Integer;
begin
  Result := nil;
  case CPType of
    ctSeq:
      for I := 0 to ChildCount-1 do with Children[I] do
      begin
        Result := FindFirst(aDef);
        if Assigned(Result) or IsRequired then
          Exit;
      end;
    ctChoice:
      for I := 0 to ChildCount-1 do with Children[I] do
      begin
        Result := FindFirst(aDef);
        if Assigned(Result) then
          Exit;
      end;
  else // ctName
    if aDef = Self.Def then
      Result := Self
  end;
end;

function TContentParticle.FindNext(aDef: TDOMElementDef;
  ChildIdx: Integer): TContentParticle;
var
  I: Integer;
begin
  Result := nil;
  if CPType = ctSeq then   // search sequence to its end
  begin
    for I := ChildIdx + 1 to ChildCount-1 do with Children[I] do
    begin
      Result := FindFirst(aDef);
      if (Result <> nil) or IsRequired then
        Exit;
    end;
  end;
  if (CPQuant = cqZeroOrMore) or (CPQuant = cqOnceOrMore) then
    Result := FindFirst(aDef);
  if (Result = nil) and Assigned(FParent) then
    Result := FParent.FindNext(aDef, FIndex);
end;

{ TDOMElementDef }

destructor TDOMElementDef.Destroy;
begin
  RootCP.Free;
  inherited Destroy;
end;

{ plain calls }

procedure ReadXMLFile(out ADoc: TXMLDocument; var f: Text);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  ADoc := nil;
  Src := TXMLFileInputSource.Create(f);
  Reader := TXMLReader.Create;
  try
    Reader.ProcessXML(Src);
  finally
    ADoc := TXMLDocument(Reader.Doc);
    Reader.Free;
  end;
end;

procedure ReadXMLFile(out ADoc: TXMLDocument; f: TStream; const ABaseURI: String);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  ADoc := nil;
  Reader := TXMLReader.Create;
  try
    Src := TXMLStreamInputSource.Create(f, False);
    Src.SystemID := ABaseURI;
    Reader.ProcessXML(Src);
  finally
    ADoc := TXMLDocument(Reader.doc);
    Reader.Free;
  end;
end;

procedure ReadXMLFile(out ADoc: TXMLDocument; f: TStream);
begin
  ReadXMLFile(ADoc, f, 'stream:');
end;

procedure ReadXMLFile(out ADoc: TXMLDocument; const AFilename: String);
var
  FileStream: TStream;
begin
  ADoc := nil;
  FileStream := TFileStream.Create(AFilename, fmOpenRead+fmShareDenyWrite);
  try
    ReadXMLFile(ADoc, FileStream, FilenameToURI(AFilename));
  finally
    FileStream.Free;
  end;
end;

procedure ReadXMLFragment(AParentNode: TDOMNode; var f: Text);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  Reader := TXMLReader.Create;
  try
    Src := TXMLFileInputSource.Create(f);
    Reader.ProcessFragment(Src, AParentNode);
  finally
    Reader.Free;
  end;
end;

procedure ReadXMLFragment(AParentNode: TDOMNode; f: TStream; const ABaseURI: String);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  Reader := TXMLReader.Create;
  try
    Src := TXMLStreamInputSource.Create(f, False);
    Src.SystemID := ABaseURI;
    Reader.ProcessFragment(Src, AParentNode);
  finally
    Reader.Free;
  end;
end;

procedure ReadXMLFragment(AParentNode: TDOMNode; f: TStream);
begin
  ReadXMLFragment(AParentNode, f, 'stream:');
end;

procedure ReadXMLFragment(AParentNode: TDOMNode; const AFilename: String);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(AFilename, fmOpenRead+fmShareDenyWrite);
  try
    ReadXMLFragment(AParentNode, Stream, FilenameToURI(AFilename));
  finally
    Stream.Free;
  end;
end;


procedure ReadDTDFile(out ADoc: TXMLDocument; var f: Text);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  ADoc := nil;
  Reader := TXMLReader.Create;
  try
    Src := TXMLFileInputSource.Create(f);
    Reader.ProcessDTD(Src);
  finally
    ADoc := TXMLDocument(Reader.doc);
    Reader.Free;
  end;
end;

procedure ReadDTDFile(out ADoc: TXMLDocument; f: TStream; const ABaseURI: String);
var
  Reader: TXMLReader;
  Src: TXMLCharSource;
begin
  ADoc := nil;
  Reader := TXMLReader.Create;
  try
    Src := TXMLStreamInputSource.Create(f, False);
    Src.SystemID := ABaseURI;
    Reader.ProcessDTD(Src);
  finally
    ADoc := TXMLDocument(Reader.doc);
    Reader.Free;
  end;
end;

procedure ReadDTDFile(out ADoc: TXMLDocument; f: TStream);
begin
  ReadDTDFile(ADoc, f, 'stream:');
end;

procedure ReadDTDFile(out ADoc: TXMLDocument; const AFilename: String);
var
  Stream: TStream;
begin
  ADoc := nil;
  Stream := TFileStream.Create(AFilename, fmOpenRead+fmShareDenyWrite);
  try
    ReadDTDFile(ADoc, Stream, FilenameToURI(AFilename));
  finally
    Stream.Free;
  end;
end;




end.
