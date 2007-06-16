{
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998-2000 by Berczi Gabor

    Main program of the IDE

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program FP;

{$ifdef IncRes}
{$ifdef Windows}
{$R fpw32t.rc}
{$R fpw32ico.rc}
{$endif Windows}
{$endif IncRes}

{$I globdir.inc}
(**********************************************************************)
(* CONDITIONAL DEFINES                                                *)
(*  - NODEBUG    No Debugging support                                 *)
(*  - TP         Turbo Pascal mode                                    *)
(*  - i386       Target is an i386 IDE                                *)
(**********************************************************************)

uses
{$ifdef Windows}
  windows,
{$endif Windows}
{$ifndef NODEBUG}
{$ifdef Windows}
  fpcygwin,
{$endif Windows}
{$endif NODEBUG}
{$ifdef IDEHeapTrc}
  PPheap,
{$endif IDEHeapTrc}
{$ifdef Use_DBGHEAP}
  dbgheap,
{$endif Use_DBGHEAP}
{$ifdef go32v2}
  dpmiexcp,
{$endif go32v2}
{$ifdef fpc}
  keyboard,video,mouse,
{$endif fpc}
{$ifdef HasSignal}
  fpcatch,
{$endif HasSignal}
  Dos,Objects,
  BrowCol,Version,
{$ifndef NODEBUG}
  gdbint,
{$endif NODEBUG}
  FVConsts,
  Drivers,Views,App,Dialogs,HistList,
  Menus,StdDlg,Validate,
  WEditor,WCEdit,
{$ifdef COLORSEL}
  ColorSel,
{$endif COLORSEL}
  ASCIITab,
  WUtils,WViews,WHTMLScn,WHelp,
  FPIDE,FPCalc,FPCompil,
  FPIni,FPViews,FPConst,FPVars,FPUtils,FPHelp,FPSwitch,FPUsrScr,
  FPTools,
{$ifndef NODEBUG}
  FPDebug,FPRegs,
{$endif}
  FPTemplt,FPRedir,FPDesk,
  FPCodTmp,FPCodCmp,

  systems;


{$ifdef fpc}
Const
  DummyMouseDriver : TMouseDriver = (
    useDefaultQueue : true;
    InitDriver      : nil;
    DoneDriver      : nil;
    DetectMouse     : nil;
    ShowMouse       : nil;
    HideMouse       : nil;
    GetMouseX       : nil;
    GetMouseY       : nil;
    GetMouseButtons : nil;
    SetMouseXY      : nil;
    GetMouseEvent   : nil;
    PollMouseEvent  : nil;
    PutMouseEvent   : nil;
  );
{$endif fpc}

{$ifdef useresstrings}
resourcestring
{$else}
const
{$endif}
      { caught signals or abnormal exits }
            { Debugger messages and status hints }
      error_programexitedwitherror = #3'Program generated a RTE %d'#13+
                                     #3'at address $%s.'#13+
                                     #3'Save your sources and restart the IDE.';
      error_programexitedwithsignal = #3'Program generated a signal %d.'#13+
                                      #3'Save your sources and restart the IDE.';

      continue_despite_error = #3'The IDE generated an internal error'#13+
                            #3'Do you really want to continue?'#13+
                            #3'The IDE could be in an unstable state.';

      leaving_after_error = #3'The IDE generated an internal error'#13+
                            #3'and will now be closed.';

{$ifdef DEBUG}
const
  CloseImmediately : boolean = false;
var
  StartTime : real;

  function getrealtime : real;
  var
    h,m,s,s100 : word;
  begin
    gettime(h,m,s,s100);
    getrealtime:=h*3600.0+m*60.0+s+s100/100.0;
  end;

{$endif DEBUG}

procedure ProcessParams(BeforeINI: boolean);

  function IsSwitch(const Param: string): boolean;
  begin
    IsSwitch:=(Param<>'') and (Param[1]<>DirSep) { <- allow UNIX root-relative paths            }
          and (Param[1] in ['-','/']);           { <- but still accept dos switch char, eg. '/' }
  end;

var I: Sw_integer;
    Param: string;
begin
  for I:=1 to ParamCount do
  begin
    Param:=System.ParamStr(I);
    if IsSwitch(Param) then
      begin
        Param:=copy(Param,2,255);
        if Param<>'' then
        if UpcaseStr(copy(Param,1,2))='HM' then
          { HeapMonitor }
          begin
            if (copy(Param,3,1)='+') or (copy(Param,3,1)='') then
              StartupOptions:=StartupOptions or soHeapMonitor
            else
            if (copy(Param,3,1)='-') then
              StartupOptions:=StartupOptions and not soHeapMonitor;
          end else
{$ifdef go32v2}
        if UpcaseStr(Param)='NOLFN' then
          begin
            LFNSupport:=false;
          end else
{$endif go32v2}
        if UpcaseStr(Param)='README' then
          begin
            ShowReadme:=true;
          end else
        case Upcase(Param[1]) of
          'C' : { custom config file (BP compatiblity) }
           if BeforeINI then
            begin
              if (length(Param)>=1) and (Param[1] in['=',':']) then
                Delete(Param,1,1); { eat separator }
              IniFileName:=Param;
            end;
          'R' : { enter the directory last exited from (BP comp.) }
            begin
              Param:=copy(Param,2,255);
              if (Param='') or (Param='+') then
                StartupOptions:=StartupOptions or soReturnToLastDir
              else
              if (Param='-') then
                StartupOptions:=StartupOptions and (not soReturnToLastDir);
            end;
          'S' :
             if Length(Param)=1 then
               begin
                 UseMouse:=false;
{$ifdef fpc}
                 DoneMouse;
                 SetMouseDriver(DummyMouseDriver);
{$endif fpc}
                 ButtonCount:=0;
               end;
{$ifdef fpc}
{          'F' :
             if Length(Param)=1 then
               NoExtendedFrame:=true;}
{$ifdef Unix}
          'T' :  DebuggeeTTY:=Copy(Param,2,High(Param));
{$endif Unix}
         { 'M' : TryToMaximizeScreen:=true;}
{$endif fpc}
{$ifdef DEBUG}
          'Z' : UseOldBufStreamMethod:=true;
          'X' : CloseImmediately:=true;
{$endif DEBUG}
        end;
      end
    else
      if not BeforeINI then
        TryToOpenFile(nil,Param,0,0,{false}true);
  end;
end;

Procedure MyStreamError(Var S: TStream); {$ifndef FPC}far;{$endif}
var ErrS: string;
begin
  case S.Status of
    stGetError : ErrS:='Get of unregistered object type';
    stPutError : ErrS:='Put of unregistered object type';
  else ErrS:='';
  end;
  if ErrS<>'' then
  begin
    if (application<>nil) and (ideapp.displaymode=dmIDE) then
      ErrorBox('Stream error: '+#13+ErrS,nil)
    else

      writeln('Error: ',ErrS);
  end;
end;

{$ifdef linux}
procedure detect_debian;

var attr:word;
    f:text;

begin
  assign(f,'/etc/debian_version');
  getfattr(f,attr);
  if doserror=0 then
    errorbox('Debian system detected!'#13#13+
             'Debian systems use an incompatible gpm'#13+
             'library, therefore your system might'#13+
             'suffer from Debian bug 412927. Please'#13+
             'see http://bugs.debian.org/cgi-bin/'#13+
             'bugreport.cgi?bug=412927 for details.',nil);
end;
{$endif}

procedure DelTempFiles;
begin
  DeleteFile(FPOutFileName);
  DeleteFile(FPErrFileName);
  DeleteFile(GDBOutFileName);
  DeleteFile(GDBOutPutFileName);
  DeleteFile(GREPOutName);
  DeleteFile(GREPErrName);
end;

procedure RegisterIDEObjects;
begin
  RegisterApp;
  RegisterCodeComplete;
  RegisterCodeTemplates;
{$ifdef COLORSEL}
  RegisterColorSel;
{$endif COLORSEL}
  RegisterAsciiTab;
  RegisterDialogs;
  RegisterWEditor;
  RegisterWCEdit;
  RegisterFPCalc;
  RegisterFPCompile;
  RegisterFPTools;
  RegisterFPViews;
{$ifndef NODEBUG}
  RegisterFPDebugViews;
  RegisterFPRegsViews;
{$endif}
  RegisterMenus;
  RegisterStdDlg;
  RegisterSymbols;
  RegisterObjects;
  RegisterValidate;
  RegisterViews;

  RegisterWHTMLScan;
  RegisterWUtils;
  RegisterWViews;
end;

var CanExit : boolean;
    SetJmpRes : longint;
    StoreExitProc : pointer;
    ErrS : String;
    P : record
          l1 : longint;
          s : pstring;
        end;
const
  ExitIntercepted : boolean = false;
  SeenExitCode : longint =0;
  SeenErrorAddr : pointer = nil;
  UserWantsToGoOn: boolean = false;


procedure InterceptExit;
begin
{$IFDEF HasSignal}
  if StopJmpValid then
    begin
      ExitIntercepted:=true;
      SeenExitCode:=ExitCode;
      SeenErrorAddr:=ErrorAddr;
      LongJmp(StopJmp,1);
    end;
{$ENDIF}
end;

{The square bullet needs an MS-DOS code page. On Unix it is for sure the code
 page is not available before video is initialized. (And only in certain
 circumstances after that, so, use a plain ascii character as bullet on Unix.)}

{$ifdef unix}
const bullet='*';
{$else}
const bullet='�';
{$endif}

BEGIN
{$IFDEF HasSignal}
  EnableCatchSignals;
{$ENDIF}
{$ifdef DEV}
  HeapLimit:=4096;
{$endif}
  HistorySize:=16384;

  { Startup info }
  writeln(bullet+' Free Pascal IDE Version '+VersionStr+' ['+{$i %date%}+']');
  writeln(bullet+' Compiler Version '+Full_Version_String);
{$ifndef NODEBUG}
  writeln(bullet+' GBD Version '+GDBVersion);
 {$ifdef Windows}
   writeln(bullet+' Cygwin "',GetCygwinFullName,'" version ',GetCygwinVersionString);
   CheckCygwinVersion;
 {$endif Windows}
{$endif NODEBUG}

  ProcessParams(true);

{$ifdef DEBUG}
  StartTime:=getrealtime;
{$endif DEBUG}

  InitDirs;

  RegisterIDEObjects;
  StreamError:=@MyStreamError;

  ShowReadme:=ShowReadme or (LocateFile(INIFileName)='');

{$ifdef VESA}
  InitVESAScreenModes;
{$endif}
  InitRedir;
{$ifndef NODEBUG}
  InitBreakpoints;
  InitWatches;
{$endif}
  InitReservedWords;
  InitHelpFiles;
  InitSwitches;
  InitINIFile;
  InitUserScreen;
  InitTools;
  InitTemplates;
  InitCodeTemplates;
  InitCodeComplete;

  { init target information etc. }
  InitSystems;

  IDEApp.Init;
  CheckINIFile;
  ReadSwitches(SwitchesPath);
  { load all options after init because of open files }
  ReadINIFile;
  InitDesktopFile;
  LoadDesktop;

  {Menubar might be changed because of loading INI file.}
  IDEapp.reload_menubar;

  { Handle Standard Units }
  if UseAllUnitsInCodeComplete then
    AddAvailableUnitsToCodeComplete(false);

  if UseStandardUnitsInCodeComplete and not assigned(UnitsCodeCompleteWords) then
    AddStandardUnitsToCodeComplete;

  { why are the screen contents parsed at startup? Gabor
    to be able to find location of error in last compilation
    from command line PM }
  ParseUserScreen;

  { Update IDE }
  IDEApp.Update;
  IDEApp.UpdateMode;
  IDEApp.UpdateTarget;

  ProcessParams(false);

  if ShowReadme then
  begin
  {$ifdef linux}
    {Regrettably we do not have a proper solution.}
    detect_debian;
  {$endif}
    PutCommand(Application,evCommand,cmShowReadme,nil);
    ShowReadme:=false; { do not show next time }
  end;

  StoreExitProc:=ExitProc;
  ExitProc:=@InterceptExit;


  repeat
{$IFDEF HasSignal}
     SetJmpRes:=setjmp(StopJmp);
     StopJmpValid:=true;
{$ENDIF}
    UserWantsToGoOn:=false;

    if SetJmpRes=0 then
      begin
{$ifdef DEBUG}
        if not CloseImmediately then
{$endif DEBUG}
          IDEApp.Run;
      end
    else
      begin
        if (SetJmpRes=1) and ExitIntercepted then
          begin
            { If ExitProc=@InterceptExit then
              ExitProc:=StoreExitProc;}
            Str(SeenExitCode,ErrS);
            if (application<>nil) and (ideapp.displaymode=dmIDE) then
              begin
                P.l1:=SeenExitCode;
                ErrS:=hexstr(longint(SeenErrorAddr),8);
                P.s:=@ErrS;
                if OKCancelBox(error_programexitedwitherror,@P)=cmCancel then
                  UserWantsToGoOn:=true;
              end
            else
              writeln('Abnormal exit error: ',ErrS);
          end
        else
          begin
            Str(SetJmpRes,ErrS);
          { Longjmp was called by fpcatch }
            if (application<>nil) and (ideapp.displaymode=dmIDE) then
              begin
                P.l1:=SetJmpRes;
                if OKCancelBox(error_programexitedwithsignal,@P)=cmCancel then
                  UserWantsToGoOn:=true;
              end
            else
              writeln('Signal error: ',ErrS);
          end;
        if ideapp.displaymode=dmUser then
          begin
            writeln('Fatal exception occured while in user screen mode. File save message boxes');
            writeln('cannot be displayed. We are sorry, but need to terminate now.');
            halt(255);
          end;
      end;

    if (AutoSaveOptions and asEditorFiles)=0 then
      CanExit:=IDEApp.AskSaveAll
    else
      CanExit:=IDEApp.SaveAll;
{$IFDEF HasSignal}
     StopJmpValid:=false;
{$ENDIF}
    if (SetJmpRes<>0) then
      begin
        if (not CanExit) or UserWantsToGoOn then
          begin
            if ConfirmBox(continue_despite_error,nil,false)=cmNo then
              CanExit:=true
            else
              CanExit:=false;
          end
        else
          begin
            ErrorBox(leaving_after_error,nil);
          end;
      end;
  until CanExit;

  If ExitProc=pointer(@InterceptExit) then
    ExitProc:=StoreExitProc;
  IDEApp.AutoSave;

  DoneDesktopFile;

  DelTempFiles;
  IDEApp.Done;
  WriteSwitches(SwitchesPath);

{$IFDEF HasSignal}
   DisableCatchSignals;
{$ENDIF}

  DoneCodeComplete;
  DoneCodeTemplates;
  DoneTemplates;
  DoneTools;
  DoneUserScreen;
  DoneSwitches;
  DoneHelpFiles;
  DoneHelpFilesTypes;
  DoneReservedWords;
  DoneToolMessages;
  DoneBrowserCol;
{$ifndef NODEBUG}
  DoneDebugger;
  DoneBreakpoints;
  DoneWatches;
{$endif}
{$ifdef fpc}
{$ifdef unix}
  Video.ClearScreen;
{$endif unix}
{  Video.DoneVideo;
  Keyboard.DoneKeyboard;}
{$endif fpc}
{$ifdef VESA}
  DoneVESAScreenModes;
{$endif}
{$if defined(unix)}
  Keyboard.RestoreStartMode;
{$endif defined(unix)}
{$if defined(windows)}
  SetConsoleMode(GetStdHandle(cardinal(Std_Input_Handle)),StartupConsoleMode);
{$endif defined(windows)}
  StreamError:=nil;
{$ifdef DEBUG}
  if CloseImmediately then
    writeln('Used time is ',getrealtime-StartTime:0:2);
{$endif DEBUG}
END.
