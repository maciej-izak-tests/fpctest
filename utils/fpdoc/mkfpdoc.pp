unit mkfpdoc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dglobals, DOM, fpdocxmlopts, dwriter, pscanner, pparser, fpdocproj;

const
  DefOSTarget    = {$I %FPCTARGETOS%};
  DefCPUTarget   = {$I %FPCTARGETCPU%};
  DefFPCVersion  = {$I %FPCVERSION%};
  DefFPCDate     = {$I %FPCDATE%};

Type

  { TFPDocCreator }

  TFPDocCreator = Class(TComponent)
  Private
    FBaseDescrDir: String;
    FBaseInputDir: String;
    FCurPackage : TFPDocPackage;
    FProcessedUnits : TStrings;
    FOnLog: TPasParserLogHandler;
    FPParserLogEvents: TPParserLogEvents;
    FProject : TFPDocProject;
    FScannerLogEvents: TPScannerLogEvents;
    FVerbose: Boolean;
    function GetOptions: TEngineOptions;
    function GetPackages: TFPDocPackages;
    procedure SetBaseDescrDir(AValue: String);
    procedure SetBaseInputDir(AValue: String);
  Protected
    Function FixInputFile(Const AFileName : String) : String;
    Function FixDescrFile(Const AFileName : String) : String;
    Procedure DoBeforeEmitNote(Sender : TObject; Note : TDomElement; Var EmitNote : Boolean); virtual;
    procedure HandleOnParseUnit(Sender: TObject; const AUnitName: String; out AInputFile, OSTarget, CPUTarget: String);
    procedure SetVerbose(AValue: Boolean); virtual;
    Procedure DoLog(Const Msg : String);
    procedure DoLog(Const Fmt : String; Args : Array of Const);
    procedure CreateOutput(APackage: TFPDocPackage; Engine: TFPDocEngine); virtual;
  Public
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure CreateDocumentation(APackage : TFPDocPackage; ParseOnly : Boolean); virtual; //Writes out documentation in selected format
    Procedure CreateProjectFile(Const AFileName : string); //Writes out project file with the chosen options
    Procedure LoadProjectFile(Const AFileName: string);
    Property Project : TFPDocProject Read FProject;
    Property ScannerLogEvents : TPScannerLogEvents Read FScannerLogEvents Write FScannerLogEvents;
    Property ParserLogEvents : TPParserLogEvents Read FPParserLogEvents Write FPParserLogEvents;
    Property Verbose : Boolean Read FVerbose Write SetVerbose;
    Property OnLog : TPasParserLogHandler Read FOnLog Write FOnLog;
    // Easy access
    Property Options : TEngineOptions Read GetOptions;
    Property Packages : TFPDocPackages Read GetPackages;
    // When set, they will be prepended to non-absolute filenames.
    Property BaseInputDir : String Read FBaseInputDir Write SetBaseInputDir;
    Property BaseDescrDir : String Read FBaseDescrDir Write SetBaseDescrDir;
  end;

implementation


{ TFPDocCreator }

procedure TFPDocCreator.SetVerbose(AValue: Boolean);
begin
  if FVerbose=AValue then Exit;
  FVerbose:=AValue;
  if FVerbose then
    begin
    ScannerLogEvents:=[sleFile];
    ParserLogEvents:=[];
    end
  else
    begin
    ScannerLogEvents:=[];
    ParserLogEvents:=[];
    end;
end;

Procedure TFPDocCreator.DoLog(Const Msg: String);
begin
  If Assigned(OnLog) then
    OnLog(Self,Msg);
end;

procedure TFPDocCreator.DoLog(Const Fmt: String; Args: Array of Const);
begin
  DoLog(Format(Fmt,Args));
end;

procedure TFPDocCreator.HandleOnParseUnit(Sender: TObject;
  const AUnitName: String; out AInputFile, OSTarget, CPUTarget: String);

Var
  I : Integer;
  S,un,opts : String;

begin
  AInputFile:='';
  OSTarget:='';
  CPUTarget:='';
  if Assigned(FCurPackage) then
    begin
    I:=0;
    While (AInputFIle='') and (I<FCurPackage.Inputs.Count) do
       begin
       S:=FCurPackage.Inputs[i];
       SplitInputFIleOption(S,UN,Opts);
       if CompareText(ChangeFileExt(ExtractFileName(Un),''),AUnitName)=0 then
         begin
         AInputFile:=FixInputFile(UN)+' '+Opts;
         OSTarget:=FProject.Options.OSTarget;
         CPUTarget:=FProject.Options.CPUTarget;
         FProcessedUnits.Add(UN);
         end;
       Inc(I);
       end;
   end;
end;

function TFPDocCreator.GetOptions: TEngineOptions;
begin
  Result:=FProject.Options;
end;

function TFPDocCreator.GetPackages: TFPDocPackages;
begin
  Result:=FProject.Packages;
end;

Function TFPDocCreator.FixInputFile(Const AFileName: String): String;
begin
  Result:=AFileName;
  If Result='' then exit;
  if (ExtractFileDrive(Result)='') and (Result[1]<>PathDelim) then
    Result:=BaseInputDir+Result;
end;

Function TFPDocCreator.FixDescrFile(Const AFileName: String): String;
begin
  Result:=AFileName;
  If Result='' then exit;
  if (ExtractFileDrive(Result)='') and (Result[1]<>PathDelim) then
    Result:=BaseDescrDir+Result;
end;

procedure TFPDocCreator.SetBaseDescrDir(AValue: String);
begin
  if FBaseDescrDir=AValue then Exit;
  FBaseDescrDir:=AValue;
  If FBaseDescrDir<>'' then
    FBaseDescrDir:=IncludeTrailingPathDelimiter(FBaseDescrDir);
end;

procedure TFPDocCreator.SetBaseInputDir(AValue: String);
begin
  if FBaseInputDir=AValue then Exit;
  FBaseInputDir:=AValue;
  If FBaseInputDir<>'' then
    FBaseInputDir:=IncludeTrailingPathDelimiter(FBaseInputDir);
end;

Procedure TFPDocCreator.DoBeforeEmitNote(Sender: TObject; Note: TDomElement;
  Var EmitNote: Boolean);
begin
  EmitNote:=True;
end;

Constructor TFPDocCreator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProject:=TFPDocProject.Create(Self);
  FProject.Options.StopOnParseError:=False;
  FProject.Options.CPUTarget:=DefCPUTarget;
  FProject.Options.OSTarget:=DefOSTarget;
  FProcessedUnits:=TStringList.Create;
end;

Destructor TFPDocCreator.Destroy;
begin
  FreeAndNil(FProcessedUnits);
  FreeAndNil(FProject);
  inherited Destroy;
end;

procedure TFPDocCreator.CreateOutput(APackage: TFPDocPackage;Engine : TFPDocEngine);

Var
  WriterClass : TFPDocWriterClass;
  Writer : TFPDocWriter;
  I : Integer;
  Cmd,Arg : String;

begin
  WriterClass:=GetWriterClass(Options.Backend);
  Writer:=WriterClass.Create(Engine.Package,Engine);
  With Writer do
    Try
      If FVerbose then
        DoLog('Writing documentation');
      OnLog:=Self.OnLog;
      BeforeEmitNote:=@self.DoBeforeEmitNote;
      EmitNotes:=Options.EmitNotes;
      If Options.BackendOptions.Count>0 then
        for I:=0 to ((Options.BackendOptions.Count-1) div 2) do
          begin
          Cmd:=Options.BackendOptions[I*2];
          Arg:=Options.BackendOptions[I*2+1];
          If not InterPretOption(Cmd,Arg) then
            DoLog(SCmdLineInvalidOption,[Cmd+'='+Arg]);
          end;
      WriteDoc;
    Finally
      Free;
    end;
  if Length(APackage.ContentFile) > 0 then
    Engine.WriteContentFile(APackage.ContentFile);
end;

Procedure TFPDocCreator.CreateDocumentation(APackage: TFPDocPackage;
  ParseOnly: Boolean);

var
  i,j: Integer;
  Engine : TFPDocEngine;
  Cmd,Arg : String;
  WriterClass: TFPDocWriterClass;

begin
  Cmd:='';
  FCurPackage:=APackage;
  Engine:=TFPDocEngine.Create;
  try
    WriterClass:=GetWriterClass(Options.Backend);
    For J:=0 to Apackage.Imports.Count-1 do
      begin
      Arg:=Apackage.Imports[j];
      WriterClass.SplitImport(Arg,Cmd);
      Engine.ReadContentFile(Arg, Cmd);
      end;
    for i := 0 to APackage.Descriptions.Count - 1 do
      Engine.AddDocFile(FixDescrFile(APackage.Descriptions[i]),Options.donttrim);
    Engine.SetPackageName(APackage.Name);
    Engine.Output:=APackage.Output;
    Engine.OnLog:=Self.OnLog;
    Engine.ScannerLogEvents:=Self.ScannerLogEvents;
    Engine.ParserLogEvents:=Self.ParserLogEvents;
    Engine.HideProtected:=Options.HideProtected;
    Engine.HidePrivate:=Not Options.ShowPrivate;
    Engine.OnParseUnit:=@HandleOnParseUnit;
    Engine.WarnNoNode:=Options.WarnNoNode;
    if Length(Options.Language) > 0 then
      TranslateDocStrings(Options.Language);
    for i := 0 to APackage.Inputs.Count - 1 do
      try
        SplitInputFileOption(APackage.Inputs[i],Cmd,Arg);
        Cmd:=FixInputFIle(Cmd);
        if FProcessedUnits.IndexOf(Cmd)=-1 then
          begin
          FProcessedUnits.Add(Cmd);
          ParseSource(Engine,Cmd+' '+Arg, Options.OSTarget, Options.CPUTarget);
          end;
      except
        on e: EParserError do
          If Options.StopOnParseError then
            Raise
          else
            DoLog('%s(%d,%d): %s',[e.Filename, e.Row, e.Column, e.Message]);
      end;
    if Not ParseOnly then
      begin
      Engine.StartDocumenting;
      CreateOutput(APackage,Engine);
      end;
  finally
    FreeAndNil(Engine);
    FCurPackage:=Nil;
  end;
end;

Procedure TFPDocCreator.CreateProjectFile(Const AFileName: string);
begin
  With TXMLFPDocOptions.Create(Self) do
  try
    SaveOptionsToFile(FProject,AFileName);
  finally
    Free;
  end;
end;

Procedure TFPDocCreator.LoadProjectFile(Const AFileName: string);
begin
  With TXMLFPDocOptions.Create(self) do
    try
      LoadOptionsFromFile(FProject,AFileName);
    finally
      Free;
    end;
end;

end.

