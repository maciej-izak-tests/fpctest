{$WARNINGS OFF}

  {$IFDEF FPC}
    {$mode objfpc}{$H+}
    {$DEFINE HAS_QWORD}
    {$DEFINE ATT_PROC_ADDRESS}
    {$DEFINE HAS_UNICODE}  
    {$IF Defined(FPC_RELEASE) and (FPC_RELEASE > 0) }
      {$define FCL_HAS_TDOMElementList}
      {$IF Defined(FPC_VERSION) and (FPC_RELEASE >= 5) }
        {$DEFINE HAS_CURR_TO_STR_SETTINGS}
      {$IFEND}
    {$IFEND}
    {$DEFINE USE_INLINE}
  {$ELSE}
    {$UNDEF HAS_QWORD}
    {$UNDEF USE_INLINE}
    {$UNDEF ATT_PROC_ADDRESS}
    {$DEFINE DELPHI}
    {$DEFINE INTF_DOM}
    {$IFDEF VER200}
      {$DEFINE HAS_UNICODE}
    {$ENDIF}
    {$IFDEF VER210}
      {$DEFINE HAS_UNICODE}
    {$ENDIF}     
    {$IFDEF VER220} //DelphiXE
      {$DEFINE HAS_UNICODE}
    {$ENDIF}
    {$IF Defined(CompilerVersion) and (CompilerVersion >= 20)}
      {$DEFINE HAS_UNICODE}
    {$IFEND}
    {$IF Defined(CompilerVersion) and (CompilerVersion < 23)}
      {$DEFINE WINDOWS}
    {$IFEND}
    {$IFDEF MSWINDOWS}
      {$DEFINE WINDOWS}
    {$ENDIF}
    {$IFDEF HAS_UNICODE}
      {$DEFINE DEFAULT_UNICODE}
    {$ENDIF}
  {$ENDIF}

{$WARNINGS ON}

{$UNDEF EQUALITY_USE_SET_NULL}
{$DEFINE TEST_GENERATE_FILE}

{$DEFINE HAS_SDO_BYTES}
{$DEFINE HAS_SDO_CHAR}
{$DEFINE HAS_SDO_DOUBLE}
{$DEFINE HAS_SDO_FLOAT}
{$DEFINE HAS_SDO_LONG}
{$DEFINE HAS_SDO_SHORT}
{$DEFINE HAS_SDO_CURRENCY}

{$IFDEF HAS_UNICODE}
  {$DEFINE USE_UNICODE}
  {$IFDEF DELPHI}
    {$DEFINE HAS_CP_STRING}
  {$ENDIF}
{$ENDIF}
