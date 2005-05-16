{******************************************************************************}
{                                                                              }
{ Graphics Device Interface API interface Unit for Object Pascal               }
{                                                                              }
{ Portions created by Microsoft are Copyright (C) 1995-2001 Microsoft          }
{ Corporation. All Rights Reserved.                                            }
{                                                                              }
{ The original file is: wingdi.h, released June 2000. The original Pascal      }
{ code is: WinGDI.pas, released December 2000. The initial developer of the    }
{ Pascal code is Marcel van Brakel (brakelm att chello dott nl).               }
{                                                                              }
{ Portions created by Marcel van Brakel are Copyright (C) 1999-2001            }
{ Marcel van Brakel. All Rights Reserved.                                      }
{                                                                              }
{ Obtained through: Joint Endeavour of Delphi Innovators (Project JEDI)        }
{                                                                              }
{ You may retrieve the latest version of this file at the Project JEDI         }
{ APILIB home page, located at http://jedi-apilib.sourceforge.net              }
{                                                                              }
{ The contents of this file are used with permission, subject to the Mozilla   }
{ Public License Version 1.1 (the "License"); you may not use this file except }
{ in compliance with the License. You may obtain a copy of the License at      }
{ http://www.mozilla.org/MPL/MPL-1.1.html                                      }
{                                                                              }
{ Software distributed under the License is distributed on an "AS IS" basis,   }
{ WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for }
{ the specific language governing rights and limitations under the License.    }
{                                                                              }
{ Alternatively, the contents of this file may be used under the terms of the  }
{ GNU Lesser General Public License (the  "LGPL License"), in which case the   }
{ provisions of the LGPL License are applicable instead of those above.        }
{ If you wish to allow use of your version of this file only under the terms   }
{ of the LGPL License and not to allow others to use your version of this file }
{ under the MPL, indicate your decision by deleting  the provisions above and  }
{ replace  them with the notice and other provisions required by the LGPL      }
{ License.  If you do not delete the provisions above, a recipient may use     }
{ your version of this file under either the MPL or the LGPL License.          }
{                                                                              }
{ For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html }
{                                                                              }
{******************************************************************************}

// $Id: jwawingdi.pas,v 1.1 2005/04/04 07:56:11 marco Exp $

unit JwaWinGDI;

{$WEAKPACKAGEUNIT}

{$HPPEMIT ''}
{$HPPEMIT '#include "WinGDI.h"'}
{$HPPEMIT ''}

{$I jediapilib.inc}

interface

uses
  JwaWinNT, JwaWinType;

// Binary raster ops

const
  R2_BLACK       = 1; // 0
  {$EXTERNALSYM R2_BLACK}
  R2_NOTMERGEPEN = 2; // DPon
  {$EXTERNALSYM R2_NOTMERGEPEN}
  R2_MASKNOTPEN  = 3; // DPna
  {$EXTERNALSYM R2_MASKNOTPEN}
  R2_NOTCOPYPEN  = 4; // PN
  {$EXTERNALSYM R2_NOTCOPYPEN}
  R2_MASKPENNOT  = 5; // PDna
  {$EXTERNALSYM R2_MASKPENNOT}
  R2_NOT         = 6; // Dn
  {$EXTERNALSYM R2_NOT}
  R2_XORPEN      = 7; // DPx
  {$EXTERNALSYM R2_XORPEN}
  R2_NOTMASKPEN  = 8; // DPan
  {$EXTERNALSYM R2_NOTMASKPEN}
  R2_MASKPEN     = 9; // DPa
  {$EXTERNALSYM R2_MASKPEN}
  R2_NOTXORPEN   = 10; // DPxn
  {$EXTERNALSYM R2_NOTXORPEN}
  R2_NOP         = 11; // D
  {$EXTERNALSYM R2_NOP}
  R2_MERGENOTPEN = 12; // DPno
  {$EXTERNALSYM R2_MERGENOTPEN}
  R2_COPYPEN     = 13; // P
  {$EXTERNALSYM R2_COPYPEN}
  R2_MERGEPENNOT = 14; // PDno
  {$EXTERNALSYM R2_MERGEPENNOT}
  R2_MERGEPEN    = 15; // DPo
  {$EXTERNALSYM R2_MERGEPEN}
  R2_WHITE       = 16; // 1
  {$EXTERNALSYM R2_WHITE}
  R2_LAST        = 16;
  {$EXTERNALSYM R2_LAST}

// Ternary raster operations

  SRCCOPY     = DWORD($00CC0020); // dest = source
  {$EXTERNALSYM SRCCOPY}
  SRCPAINT    = DWORD($00EE0086); // dest = source OR dest
  {$EXTERNALSYM SRCPAINT}
  SRCAND      = DWORD($008800C6); // dest = source AND dest
  {$EXTERNALSYM SRCAND}
  SRCINVERT   = DWORD($00660046); // dest = source XOR dest
  {$EXTERNALSYM SRCINVERT}
  SRCERASE    = DWORD($00440328); // dest = source AND (NOT dest )
  {$EXTERNALSYM SRCERASE}
  NOTSRCCOPY  = DWORD($00330008); // dest = (NOT source)
  {$EXTERNALSYM NOTSRCCOPY}
  NOTSRCERASE = DWORD($001100A6); // dest = (NOT src) AND (NOT dest)
  {$EXTERNALSYM NOTSRCERASE}
  MERGECOPY   = DWORD($00C000CA); // dest = (source AND pattern)
  {$EXTERNALSYM MERGECOPY}
  MERGEPAINT  = DWORD($00BB0226); // dest = (NOT source) OR dest
  {$EXTERNALSYM MERGEPAINT}
  PATCOPY     = DWORD($00F00021); // dest = pattern
  {$EXTERNALSYM PATCOPY}
  PATPAINT    = DWORD($00FB0A09); // dest = DPSnoo
  {$EXTERNALSYM PATPAINT}
  PATINVERT   = DWORD($005A0049); // dest = pattern XOR dest
  {$EXTERNALSYM PATINVERT}
  DSTINVERT   = DWORD($00550009); // dest = (NOT dest)
  {$EXTERNALSYM DSTINVERT}
  BLACKNESS   = DWORD($00000042); // dest = BLACK
  {$EXTERNALSYM BLACKNESS}
  WHITENESS   = DWORD($00FF0062); // dest = WHITE
  {$EXTERNALSYM WHITENESS}

  NOMIRRORBITMAP = DWORD($80000000); // Do not Mirror the bitmap in this call
  {$EXTERNALSYM NOMIRRORBITMAP}
  CAPTUREBLT     = DWORD($40000000); // Include layered windows
  {$EXTERNALSYM CAPTUREBLT}

// Quaternary raster codes

function MAKEROP4(Fore, Back: DWORD): DWORD;
{$EXTERNALSYM MAKEROP4}

const
  GDI_ERROR = DWORD($FFFFFFFF);
  {$EXTERNALSYM GDI_ERROR}
  HGDI_ERROR = HANDLE($FFFFFFFF);
  {$EXTERNALSYM HGDI_ERROR}

// Region Flags

  ERROR         = 0;
  {$EXTERNALSYM ERROR}
  NULLREGION    = 1;
  {$EXTERNALSYM NULLREGION}
  SIMPLEREGION  = 2;
  {$EXTERNALSYM SIMPLEREGION}
  COMPLEXREGION = 3;
  {$EXTERNALSYM COMPLEXREGION}
  RGN_ERROR     = ERROR;
  {$EXTERNALSYM RGN_ERROR}

// CombineRgn() Styles

  RGN_AND  = 1;
  {$EXTERNALSYM RGN_AND}
  RGN_OR   = 2;
  {$EXTERNALSYM RGN_OR}
  RGN_XOR  = 3;
  {$EXTERNALSYM RGN_XOR}
  RGN_DIFF = 4;
  {$EXTERNALSYM RGN_DIFF}
  RGN_COPY = 5;
  {$EXTERNALSYM RGN_COPY}
  RGN_MIN  = RGN_AND;
  {$EXTERNALSYM RGN_MIN}
  RGN_MAX  = RGN_COPY;
  {$EXTERNALSYM RGN_MAX}

// StretchBlt() Modes

  BLACKONWHITE      = 1;
  {$EXTERNALSYM BLACKONWHITE}
  WHITEONBLACK      = 2;
  {$EXTERNALSYM WHITEONBLACK}
  COLORONCOLOR      = 3;
  {$EXTERNALSYM COLORONCOLOR}
  HALFTONE          = 4;
  {$EXTERNALSYM HALFTONE}
  MAXSTRETCHBLTMODE = 4;
  {$EXTERNALSYM MAXSTRETCHBLTMODE}

// New StretchBlt() Modes

  STRETCH_ANDSCANS    = BLACKONWHITE;
  {$EXTERNALSYM STRETCH_ANDSCANS}
  STRETCH_ORSCANS     = WHITEONBLACK;
  {$EXTERNALSYM STRETCH_ORSCANS}
  STRETCH_DELETESCANS = COLORONCOLOR;
  {$EXTERNALSYM STRETCH_DELETESCANS}
  STRETCH_HALFTONE    = HALFTONE;
  {$EXTERNALSYM STRETCH_HALFTONE}

// PolyFill() Modes

  ALTERNATE     = 1;
  {$EXTERNALSYM ALTERNATE}
  WINDING       = 2;
  {$EXTERNALSYM WINDING}
  POLYFILL_LAST = 2;
  {$EXTERNALSYM POLYFILL_LAST}

// Layout Orientation Options

  LAYOUT_RTL                        = $00000001; // Right to left
  {$EXTERNALSYM LAYOUT_RTL}
  LAYOUT_BTT                        = $00000002; // Bottom to top
  {$EXTERNALSYM LAYOUT_BTT}
  LAYOUT_VBH                        = $00000004; // Vertical before horizontal
  {$EXTERNALSYM LAYOUT_VBH}
  LAYOUT_ORIENTATIONMASK            = LAYOUT_RTL or LAYOUT_BTT or LAYOUT_VBH;
  {$EXTERNALSYM LAYOUT_ORIENTATIONMASK}
  LAYOUT_BITMAPORIENTATIONPRESERVED = $00000008;
  {$EXTERNALSYM LAYOUT_BITMAPORIENTATIONPRESERVED}

// Text Alignment Options

  TA_NOUPDATECP = 0;
  {$EXTERNALSYM TA_NOUPDATECP}
  TA_UPDATECP   = 1;
  {$EXTERNALSYM TA_UPDATECP}

  TA_LEFT   = 0;
  {$EXTERNALSYM TA_LEFT}
  TA_RIGHT  = 2;
  {$EXTERNALSYM TA_RIGHT}
  TA_CENTER = 6;
  {$EXTERNALSYM TA_CENTER}

  TA_TOP      = 0;
  {$EXTERNALSYM TA_TOP}
  TA_BOTTOM   = 8;
  {$EXTERNALSYM TA_BOTTOM}
  TA_BASELINE = 24;
  {$EXTERNALSYM TA_BASELINE}

  TA_RTLREADING = 256;
  {$EXTERNALSYM TA_RTLREADING}

  TA_MASK       = TA_BASELINE + TA_CENTER + TA_UPDATECP + TA_RTLREADING;
  {$EXTERNALSYM TA_MASK}

  VTA_BASELINE = TA_BASELINE;
  {$EXTERNALSYM VTA_BASELINE}
  VTA_LEFT     = TA_BOTTOM;
  {$EXTERNALSYM VTA_LEFT}
  VTA_RIGHT    = TA_TOP;
  {$EXTERNALSYM VTA_RIGHT}
  VTA_CENTER   = TA_CENTER;
  {$EXTERNALSYM VTA_CENTER}
  VTA_BOTTOM   = TA_RIGHT;
  {$EXTERNALSYM VTA_BOTTOM}
  VTA_TOP      = TA_LEFT;
  {$EXTERNALSYM VTA_TOP}

  ETO_OPAQUE  = $0002;
  {$EXTERNALSYM ETO_OPAQUE}
  ETO_CLIPPED = $0004;
  {$EXTERNALSYM ETO_CLIPPED}

  ETO_GLYPH_INDEX    = $0010;
  {$EXTERNALSYM ETO_GLYPH_INDEX}
  ETO_RTLREADING     = $0080;
  {$EXTERNALSYM ETO_RTLREADING}
  ETO_NUMERICSLOCAL  = $0400;
  {$EXTERNALSYM ETO_NUMERICSLOCAL}
  ETO_NUMERICSLATIN  = $0800;
  {$EXTERNALSYM ETO_NUMERICSLATIN}
  ETO_IGNORELANGUAGE = $1000;
  {$EXTERNALSYM ETO_IGNORELANGUAGE}

  ETO_PDY = $2000;
  {$EXTERNALSYM ETO_PDY}

  ASPECT_FILTERING = $0001;
  {$EXTERNALSYM ASPECT_FILTERING}

// Bounds Accumulation APIs

  DCB_RESET      = $0001;
  {$EXTERNALSYM DCB_RESET}
  DCB_ACCUMULATE = $0002;
  {$EXTERNALSYM DCB_ACCUMULATE}
  DCB_DIRTY      = DCB_ACCUMULATE;
  {$EXTERNALSYM DCB_DIRTY}
  DCB_SET        = DCB_RESET or DCB_ACCUMULATE;
  {$EXTERNALSYM DCB_SET}
  DCB_ENABLE     = $0004;
  {$EXTERNALSYM DCB_ENABLE}
  DCB_DISABLE    = $0008;
  {$EXTERNALSYM DCB_DISABLE}

// Metafile Functions

  META_SETBKCOLOR            = $0201;
  {$EXTERNALSYM META_SETBKCOLOR}
  META_SETBKMODE             = $0102;
  {$EXTERNALSYM META_SETBKMODE}
  META_SETMAPMODE            = $0103;
  {$EXTERNALSYM META_SETMAPMODE}
  META_SETROP2               = $0104;
  {$EXTERNALSYM META_SETROP2}
  META_SETRELABS             = $0105;
  {$EXTERNALSYM META_SETRELABS}
  META_SETPOLYFILLMODE       = $0106;
  {$EXTERNALSYM META_SETPOLYFILLMODE}
  META_SETSTRETCHBLTMODE     = $0107;
  {$EXTERNALSYM META_SETSTRETCHBLTMODE}
  META_SETTEXTCHAREXTRA      = $0108;
  {$EXTERNALSYM META_SETTEXTCHAREXTRA}
  META_SETTEXTCOLOR          = $0209;
  {$EXTERNALSYM META_SETTEXTCOLOR}
  META_SETTEXTJUSTIFICATION  = $020A;
  {$EXTERNALSYM META_SETTEXTJUSTIFICATION}
  META_SETWINDOWORG          = $020B;
  {$EXTERNALSYM META_SETWINDOWORG}
  META_SETWINDOWEXT          = $020C;
  {$EXTERNALSYM META_SETWINDOWEXT}
  META_SETVIEWPORTORG        = $020D;
  {$EXTERNALSYM META_SETVIEWPORTORG}
  META_SETVIEWPORTEXT        = $020E;
  {$EXTERNALSYM META_SETVIEWPORTEXT}
  META_OFFSETWINDOWORG       = $020F;
  {$EXTERNALSYM META_OFFSETWINDOWORG}
  META_SCALEWINDOWEXT        = $0410;
  {$EXTERNALSYM META_SCALEWINDOWEXT}
  META_OFFSETVIEWPORTORG     = $0211;
  {$EXTERNALSYM META_OFFSETVIEWPORTORG}
  META_SCALEVIEWPORTEXT      = $0412;
  {$EXTERNALSYM META_SCALEVIEWPORTEXT}
  META_LINETO                = $0213;
  {$EXTERNALSYM META_LINETO}
  META_MOVETO                = $0214;
  {$EXTERNALSYM META_MOVETO}
  META_EXCLUDECLIPRECT       = $0415;
  {$EXTERNALSYM META_EXCLUDECLIPRECT}
  META_INTERSECTCLIPRECT     = $0416;
  {$EXTERNALSYM META_INTERSECTCLIPRECT}
  META_ARC                   = $0817;
  {$EXTERNALSYM META_ARC}
  META_ELLIPSE               = $0418;
  {$EXTERNALSYM META_ELLIPSE}
  META_FLOODFILL             = $0419;
  {$EXTERNALSYM META_FLOODFILL}
  META_PIE                   = $081A;
  {$EXTERNALSYM META_PIE}
  META_RECTANGLE             = $041B;
  {$EXTERNALSYM META_RECTANGLE}
  META_ROUNDRECT             = $061C;
  {$EXTERNALSYM META_ROUNDRECT}
  META_PATBLT                = $061D;
  {$EXTERNALSYM META_PATBLT}
  META_SAVEDC                = $001E;
  {$EXTERNALSYM META_SAVEDC}
  META_SETPIXEL              = $041F;
  {$EXTERNALSYM META_SETPIXEL}
  META_OFFSETCLIPRGN         = $0220;
  {$EXTERNALSYM META_OFFSETCLIPRGN}
  META_TEXTOUT               = $0521;
  {$EXTERNALSYM META_TEXTOUT}
  META_BITBLT                = $0922;
  {$EXTERNALSYM META_BITBLT}
  META_STRETCHBLT            = $0B23;
  {$EXTERNALSYM META_STRETCHBLT}
  META_POLYGON               = $0324;
  {$EXTERNALSYM META_POLYGON}
  META_POLYLINE              = $0325;
  {$EXTERNALSYM META_POLYLINE}
  META_ESCAPE                = $0626;
  {$EXTERNALSYM META_ESCAPE}
  META_RESTOREDC             = $0127;
  {$EXTERNALSYM META_RESTOREDC}
  META_FILLREGION            = $0228;
  {$EXTERNALSYM META_FILLREGION}
  META_FRAMEREGION           = $0429;
  {$EXTERNALSYM META_FRAMEREGION}
  META_INVERTREGION          = $012A;
  {$EXTERNALSYM META_INVERTREGION}
  META_PAINTREGION           = $012B;
  {$EXTERNALSYM META_PAINTREGION}
  META_SELECTCLIPREGION      = $012C;
  {$EXTERNALSYM META_SELECTCLIPREGION}
  META_SELECTOBJECT          = $012D;
  {$EXTERNALSYM META_SELECTOBJECT}
  META_SETTEXTALIGN          = $012E;
  {$EXTERNALSYM META_SETTEXTALIGN}
  META_CHORD                 = $0830;
  {$EXTERNALSYM META_CHORD}
  META_SETMAPPERFLAGS        = $0231;
  {$EXTERNALSYM META_SETMAPPERFLAGS}
  META_EXTTEXTOUT            = $0a32;
  {$EXTERNALSYM META_EXTTEXTOUT}
  META_SETDIBTODEV           = $0d33;
  {$EXTERNALSYM META_SETDIBTODEV}
  META_SELECTPALETTE         = $0234;
  {$EXTERNALSYM META_SELECTPALETTE}
  META_REALIZEPALETTE        = $0035;
  {$EXTERNALSYM META_REALIZEPALETTE}
  META_ANIMATEPALETTE        = $0436;
  {$EXTERNALSYM META_ANIMATEPALETTE}
  META_SETPALENTRIES         = $0037;
  {$EXTERNALSYM META_SETPALENTRIES}
  META_POLYPOLYGON           = $0538;
  {$EXTERNALSYM META_POLYPOLYGON}
  META_RESIZEPALETTE         = $0139;
  {$EXTERNALSYM META_RESIZEPALETTE}
  META_DIBBITBLT             = $0940;
  {$EXTERNALSYM META_DIBBITBLT}
  META_DIBSTRETCHBLT         = $0b41;
  {$EXTERNALSYM META_DIBSTRETCHBLT}
  META_DIBCREATEPATTERNBRUSH = $0142;
  {$EXTERNALSYM META_DIBCREATEPATTERNBRUSH}
  META_STRETCHDIB            = $0f43;
  {$EXTERNALSYM META_STRETCHDIB}
  META_EXTFLOODFILL          = $0548;
  {$EXTERNALSYM META_EXTFLOODFILL}
  META_SETLAYOUT             = $0149;
  {$EXTERNALSYM META_SETLAYOUT}
  META_DELETEOBJECT          = $01f0;
  {$EXTERNALSYM META_DELETEOBJECT}
  META_CREATEPALETTE         = $00f7;
  {$EXTERNALSYM META_CREATEPALETTE}
  META_CREATEPATTERNBRUSH    = $01F9;
  {$EXTERNALSYM META_CREATEPATTERNBRUSH}
  META_CREATEPENINDIRECT     = $02FA;
  {$EXTERNALSYM META_CREATEPENINDIRECT}
  META_CREATEFONTINDIRECT    = $02FB;
  {$EXTERNALSYM META_CREATEFONTINDIRECT}
  META_CREATEBRUSHINDIRECT   = $02FC;
  {$EXTERNALSYM META_CREATEBRUSHINDIRECT}
  META_CREATEREGION          = $06FF;
  {$EXTERNALSYM META_CREATEREGION}

type
  PDrawPatRect = ^TDrawPatRect;
  _DRAWPATRECT = record
    ptPosition: POINT;
    ptSize: POINT;
    wStyle: WORD;
    wPattern: WORD;
  end;
  {$EXTERNALSYM _DRAWPATRECT}
  DRAWPATRECT = _DRAWPATRECT;
  {$EXTERNALSYM DRAWPATRECT}
  TDrawPatRect = _DRAWPATRECT;

// GDI Escapes

const
  NEWFRAME           = 1;
  {$EXTERNALSYM NEWFRAME}
  _ABORTDOC          = 2; // Underscore prfix by translator (nameclash)
  {$EXTERNALSYM ABORTDOC}
  NEXTBAND           = 3;
  {$EXTERNALSYM NEXTBAND}
  SETCOLORTABLE      = 4;
  {$EXTERNALSYM SETCOLORTABLE}
  GETCOLORTABLE      = 5;
  {$EXTERNALSYM GETCOLORTABLE}
  FLUSHOUTPUT        = 6;
  {$EXTERNALSYM FLUSHOUTPUT}
  DRAFTMODE          = 7;
  {$EXTERNALSYM DRAFTMODE}
  QUERYESCSUPPORT    = 8;
  {$EXTERNALSYM QUERYESCSUPPORT}
  SETABORTPROC_      = 9;  // Underscore prfix by translator (nameclash)
  {$EXTERNALSYM SETABORTPROC}
  STARTDOC_          = 10; // Underscore prfix by translator (nameclash)
  {$EXTERNALSYM STARTDOC}
  ENDDOC_            = 11; // Underscore prfix by translator (nameclash)
  {$EXTERNALSYM ENDDOC}
  GETPHYSPAGESIZE    = 12;
  {$EXTERNALSYM GETPHYSPAGESIZE}
  GETPRINTINGOFFSET  = 13;
  {$EXTERNALSYM GETPRINTINGOFFSET}
  GETSCALINGFACTOR   = 14;
  {$EXTERNALSYM GETSCALINGFACTOR}
  MFCOMMENT          = 15;
  {$EXTERNALSYM MFCOMMENT}
  GETPENWIDTH        = 16;
  {$EXTERNALSYM GETPENWIDTH}
  SETCOPYCOUNT       = 17;
  {$EXTERNALSYM SETCOPYCOUNT}
  SELECTPAPERSOURCE  = 18;
  {$EXTERNALSYM SELECTPAPERSOURCE}
  DEVICEDATA         = 19;
  {$EXTERNALSYM DEVICEDATA}
  PASSTHROUGH        = 19;
  {$EXTERNALSYM PASSTHROUGH}
  GETTECHNOLGY       = 20;
  {$EXTERNALSYM GETTECHNOLGY}
  GETTECHNOLOGY      = 20;
  {$EXTERNALSYM GETTECHNOLOGY}
  SETLINECAP         = 21;
  {$EXTERNALSYM SETLINECAP}
  SETLINEJOIN        = 22;
  {$EXTERNALSYM SETLINEJOIN}
  SETMITERLIMIT_     = 23; // underscore prefix by translator (nameclash)
  {$EXTERNALSYM SETMITERLIMIT}
  BANDINFO           = 24;
  {$EXTERNALSYM BANDINFO}
  DRAWPATTERNRECT    = 25;
  {$EXTERNALSYM DRAWPATTERNRECT}
  GETVECTORPENSIZE   = 26;
  {$EXTERNALSYM GETVECTORPENSIZE}
  GETVECTORBRUSHSIZE = 27;
  {$EXTERNALSYM GETVECTORBRUSHSIZE}
  ENABLEDUPLEX       = 28;
  {$EXTERNALSYM ENABLEDUPLEX}
  GETSETPAPERBINS    = 29;
  {$EXTERNALSYM GETSETPAPERBINS}
  GETSETPRINTORIENT  = 30;
  {$EXTERNALSYM GETSETPRINTORIENT}
  ENUMPAPERBINS      = 31;
  {$EXTERNALSYM ENUMPAPERBINS}
  SETDIBSCALING      = 32;
  {$EXTERNALSYM SETDIBSCALING}
  EPSPRINTING        = 33;
  {$EXTERNALSYM EPSPRINTING}
  ENUMPAPERMETRICS   = 34;
  {$EXTERNALSYM ENUMPAPERMETRICS}
  GETSETPAPERMETRICS = 35;
  {$EXTERNALSYM GETSETPAPERMETRICS}
  POSTSCRIPT_DATA    = 37;
  {$EXTERNALSYM POSTSCRIPT_DATA}
  POSTSCRIPT_IGNORE  = 38;
  {$EXTERNALSYM POSTSCRIPT_IGNORE}
  MOUSETRAILS        = 39;
  {$EXTERNALSYM MOUSETRAILS}
  GETDEVICEUNITS     = 42;
  {$EXTERNALSYM GETDEVICEUNITS}

  GETEXTENDEDTEXTMETRICS = 256;
  {$EXTERNALSYM GETEXTENDEDTEXTMETRICS}
  GETEXTENTTABLE         = 257;
  {$EXTERNALSYM GETEXTENTTABLE}
  GETPAIRKERNTABLE       = 258;
  {$EXTERNALSYM GETPAIRKERNTABLE}
  GETTRACKKERNTABLE      = 259;
  {$EXTERNALSYM GETTRACKKERNTABLE}
  EXTTEXTOUT_            = 512; // underscore prefix by translator (nameclash)
  {$EXTERNALSYM EXTTEXTOUT}
  GETFACENAME            = 513;
  {$EXTERNALSYM GETFACENAME}
  DOWNLOADFACE           = 514;
  {$EXTERNALSYM DOWNLOADFACE}
  ENABLERELATIVEWIDTHS   = 768;
  {$EXTERNALSYM ENABLERELATIVEWIDTHS}
  ENABLEPAIRKERNING      = 769;
  {$EXTERNALSYM ENABLEPAIRKERNING}
  SETKERNTRACK           = 770;
  {$EXTERNALSYM SETKERNTRACK}
  SETALLJUSTVALUES       = 771;
  {$EXTERNALSYM SETALLJUSTVALUES}
  SETCHARSET             = 772;
  {$EXTERNALSYM SETCHARSET}

  STRETCHBLT_ESCAPE       = 2048; // suffix _ESCAPE by translator because of 
                                  // name-clash with StretchBlt function
  {$EXTERNALSYM STRETCHBLT}
  METAFILE_DRIVER         = 2049;
  {$EXTERNALSYM METAFILE_DRIVER}
  GETSETSCREENPARAMS      = 3072;
  {$EXTERNALSYM GETSETSCREENPARAMS}
  QUERYDIBSUPPORT         = 3073;
  {$EXTERNALSYM QUERYDIBSUPPORT}
  BEGIN_PATH              = 4096;
  {$EXTERNALSYM BEGIN_PATH}
  CLIP_TO_PATH            = 4097;
  {$EXTERNALSYM CLIP_TO_PATH}
  END_PATH                = 4098;
  {$EXTERNALSYM END_PATH}
  EXT_DEVICE_CAPS         = 4099;
  {$EXTERNALSYM EXT_DEVICE_CAPS}
  RESTORE_CTM             = 4100;
  {$EXTERNALSYM RESTORE_CTM}
  SAVE_CTM                = 4101;
  {$EXTERNALSYM SAVE_CTM}
  SET_ARC_DIRECTION       = 4102;
  {$EXTERNALSYM SET_ARC_DIRECTION}
  SET_BACKGROUND_COLOR    = 4103;
  {$EXTERNALSYM SET_BACKGROUND_COLOR}
  SET_POLY_MODE           = 4104;
  {$EXTERNALSYM SET_POLY_MODE}
  SET_SCREEN_ANGLE        = 4105;
  {$EXTERNALSYM SET_SCREEN_ANGLE}
  SET_SPREAD              = 4106;
  {$EXTERNALSYM SET_SPREAD}
  TRANSFORM_CTM           = 4107;
  {$EXTERNALSYM TRANSFORM_CTM}
  SET_CLIP_BOX            = 4108;
  {$EXTERNALSYM SET_CLIP_BOX}
  SET_BOUNDS              = 4109;
  {$EXTERNALSYM SET_BOUNDS}
  SET_MIRROR_MODE         = 4110;
  {$EXTERNALSYM SET_MIRROR_MODE}
  OPENCHANNEL             = 4110;
  {$EXTERNALSYM OPENCHANNEL}
  DOWNLOADHEADER          = 4111;
  {$EXTERNALSYM DOWNLOADHEADER}
  CLOSECHANNEL            = 4112;
  {$EXTERNALSYM CLOSECHANNEL}
  POSTSCRIPT_PASSTHROUGH  = 4115;
  {$EXTERNALSYM POSTSCRIPT_PASSTHROUGH}
  ENCAPSULATED_POSTSCRIPT = 4116;
  {$EXTERNALSYM ENCAPSULATED_POSTSCRIPT}

  POSTSCRIPT_IDENTIFY  = 4117; // new escape for NT5 pscript driver
  {$EXTERNALSYM POSTSCRIPT_IDENTIFY}
  POSTSCRIPT_INJECTION = 4118; // new escape for NT5 pscript driver
  {$EXTERNALSYM POSTSCRIPT_INJECTION}

  CHECKJPEGFORMAT = 4119;
  {$EXTERNALSYM CHECKJPEGFORMAT}
  CHECKPNGFORMAT  = 4120;
  {$EXTERNALSYM CHECKPNGFORMAT}

  GET_PS_FEATURESETTING = 4121; // new escape for NT5 pscript driver
  {$EXTERNALSYM GET_PS_FEATURESETTING}

  SPCLPASSTHROUGH2 = 4568; // new escape for NT5 pscript driver
  {$EXTERNALSYM SPCLPASSTHROUGH2}

//
// Parameters for POSTSCRIPT_IDENTIFY escape
//

  PSIDENT_GDICENTRIC = 0;
  {$EXTERNALSYM PSIDENT_GDICENTRIC}
  PSIDENT_PSCENTRIC  = 1;
  {$EXTERNALSYM PSIDENT_PSCENTRIC}

//
// Header structure for the input buffer to POSTSCRIPT_INJECTION escape
//

type
  PPsInjectData = ^TPsInjectData;
  _PSINJECTDATA = record
    DataBytes: DWORD;     // number of raw data bytes (NOT including this header)
    InjectionPoint: WORD; // injection point
    PageNumber: WORD;     // page number to apply the injection
                          // Followed by raw data to be injected
  end;
  {$EXTERNALSYM _PSINJECTDATA}
  PSINJECTDATA = _PSINJECTDATA;
  {$EXTERNALSYM PSINJECTDATA}
  TPsInjectData = _PSINJECTDATA;

//
// Constants for PSINJECTDATA.InjectionPoint field
//

const
  PSINJECT_BEGINSTREAM = 1;
  {$EXTERNALSYM PSINJECT_BEGINSTREAM}
  PSINJECT_PSADOBE     = 2;
  {$EXTERNALSYM PSINJECT_PSADOBE}
  PSINJECT_PAGESATEND  = 3;
  {$EXTERNALSYM PSINJECT_PAGESATEND}
  PSINJECT_PAGES       = 4;
  {$EXTERNALSYM PSINJECT_PAGES}

  PSINJECT_DOCNEEDEDRES          = 5;
  {$EXTERNALSYM PSINJECT_DOCNEEDEDRES}
  PSINJECT_DOCSUPPLIEDRES        = 6;
  {$EXTERNALSYM PSINJECT_DOCSUPPLIEDRES}
  PSINJECT_PAGEORDER             = 7;
  {$EXTERNALSYM PSINJECT_PAGEORDER}
  PSINJECT_ORIENTATION           = 8;
  {$EXTERNALSYM PSINJECT_ORIENTATION}
  PSINJECT_BOUNDINGBOX           = 9;
  {$EXTERNALSYM PSINJECT_BOUNDINGBOX}
  PSINJECT_DOCUMENTPROCESSCOLORS = 10;
  {$EXTERNALSYM PSINJECT_DOCUMENTPROCESSCOLORS}

  PSINJECT_COMMENTS                   = 11;
  {$EXTERNALSYM PSINJECT_COMMENTS}
  PSINJECT_BEGINDEFAULTS              = 12;
  {$EXTERNALSYM PSINJECT_BEGINDEFAULTS}
  PSINJECT_ENDDEFAULTS                = 13;
  {$EXTERNALSYM PSINJECT_ENDDEFAULTS}
  PSINJECT_BEGINPROLOG                = 14;
  {$EXTERNALSYM PSINJECT_BEGINPROLOG}
  PSINJECT_ENDPROLOG                  = 15;
  {$EXTERNALSYM PSINJECT_ENDPROLOG}
  PSINJECT_BEGINSETUP                 = 16;
  {$EXTERNALSYM PSINJECT_BEGINSETUP}
  PSINJECT_ENDSETUP                   = 17;
  {$EXTERNALSYM PSINJECT_ENDSETUP}
  PSINJECT_TRAILER                    = 18;
  {$EXTERNALSYM PSINJECT_TRAILER}
  PSINJECT_EOF                        = 19;
  {$EXTERNALSYM PSINJECT_EOF}
  PSINJECT_ENDSTREAM                  = 20;
  {$EXTERNALSYM PSINJECT_ENDSTREAM}
  PSINJECT_DOCUMENTPROCESSCOLORSATEND = 21;
  {$EXTERNALSYM PSINJECT_DOCUMENTPROCESSCOLORSATEND}

  PSINJECT_PAGENUMBER     = 100;
  {$EXTERNALSYM PSINJECT_PAGENUMBER}
  PSINJECT_BEGINPAGESETUP = 101;
  {$EXTERNALSYM PSINJECT_BEGINPAGESETUP}
  PSINJECT_ENDPAGESETUP   = 102;
  {$EXTERNALSYM PSINJECT_ENDPAGESETUP}
  PSINJECT_PAGETRAILER    = 103;
  {$EXTERNALSYM PSINJECT_PAGETRAILER}
  PSINJECT_PLATECOLOR     = 104;
  {$EXTERNALSYM PSINJECT_PLATECOLOR}

  PSINJECT_SHOWPAGE        = 105;
  {$EXTERNALSYM PSINJECT_SHOWPAGE}
  PSINJECT_PAGEBBOX        = 106;
  {$EXTERNALSYM PSINJECT_PAGEBBOX}
  PSINJECT_ENDPAGECOMMENTS = 107;
  {$EXTERNALSYM PSINJECT_ENDPAGECOMMENTS}

  PSINJECT_VMSAVE    = 200;
  {$EXTERNALSYM PSINJECT_VMSAVE}
  PSINJECT_VMRESTORE = 201;
  {$EXTERNALSYM PSINJECT_VMRESTORE}

//
// Parameter for GET_PS_FEATURESETTING escape
//

  FEATURESETTING_NUP       = 0;
  {$EXTERNALSYM FEATURESETTING_NUP}
  FEATURESETTING_OUTPUT    = 1;
  {$EXTERNALSYM FEATURESETTING_OUTPUT}
  FEATURESETTING_PSLEVEL   = 2;
  {$EXTERNALSYM FEATURESETTING_PSLEVEL}
  FEATURESETTING_CUSTPAPER = 3;
  {$EXTERNALSYM FEATURESETTING_CUSTPAPER}
  FEATURESETTING_MIRROR    = 4;
  {$EXTERNALSYM FEATURESETTING_MIRROR}
  FEATURESETTING_NEGATIVE  = 5;
  {$EXTERNALSYM FEATURESETTING_NEGATIVE}
  FEATURESETTING_PROTOCOL  = 6;
  {$EXTERNALSYM FEATURESETTING_PROTOCOL}

//
// The range of selectors between FEATURESETTING_PRIVATE_BEGIN and
// FEATURESETTING_PRIVATE_END is reserved by Microsoft for private use
//

  FEATURESETTING_PRIVATE_BEGIN = $1000;
  {$EXTERNALSYM FEATURESETTING_PRIVATE_BEGIN}
  FEATURESETTING_PRIVATE_END   = $1FFF;
  {$EXTERNALSYM FEATURESETTING_PRIVATE_END}

//
// Information about output options
//

type
  PPsFeatureOutput = ^TPsFeatureOutput;
  _PSFEATURE_OUTPUT = record
    bPageIndependent: BOOL;
    bSetPageDevice: BOOL;
  end;
  {$EXTERNALSYM _PSFEATURE_OUTPUT}
  PSFEATURE_OUTPUT = _PSFEATURE_OUTPUT;
  {$EXTERNALSYM PSFEATURE_OUTPUT}
  PPSFEATURE_OUTPUT = ^PSFEATURE_OUTPUT;
  {$EXTERNALSYM PPSFEATURE_OUTPUT}
  TPsFeatureOutput = _PSFEATURE_OUTPUT;

//
// Information about custom paper size
//

  PPsFeatureCustPaper = ^TPsFeatureCustPaper;
  _PSFEATURE_CUSTPAPER = record
    lOrientation: LONG;
    lWidth: LONG;
    lHeight: LONG;
    lWidthOffset: LONG;
    lHeightOffset: LONG;
  end;
  {$EXTERNALSYM _PSFEATURE_CUSTPAPER}
  PSFEATURE_CUSTPAPER = _PSFEATURE_CUSTPAPER;
  {$EXTERNALSYM PSFEATURE_CUSTPAPER}
  PPSFEATURE_CUSTPAPER = ^PSFEATURE_CUSTPAPER;
  {$EXTERNALSYM PPSFEATURE_CUSTPAPER}
  TPsFeatureCustPaper = _PSFEATURE_CUSTPAPER;

// Value returned for FEATURESETTING_PROTOCOL

const
  PSPROTOCOL_ASCII  = 0;
  {$EXTERNALSYM PSPROTOCOL_ASCII}
  PSPROTOCOL_BCP    = 1;
  {$EXTERNALSYM PSPROTOCOL_BCP}
  PSPROTOCOL_TBCP   = 2;
  {$EXTERNALSYM PSPROTOCOL_TBCP}
  PSPROTOCOL_BINARY = 3;
  {$EXTERNALSYM PSPROTOCOL_BINARY}

// Flag returned from QUERYDIBSUPPORT

  QDI_SETDIBITS   = 1;
  {$EXTERNALSYM QDI_SETDIBITS}
  QDI_GETDIBITS   = 2;
  {$EXTERNALSYM QDI_GETDIBITS}
  QDI_DIBTOSCREEN = 4;
  {$EXTERNALSYM QDI_DIBTOSCREEN}
  QDI_STRETCHDIB  = 8;
  {$EXTERNALSYM QDI_STRETCHDIB}

// Spooler Error Codes

  SP_NOTREPORTED = $4000;
  {$EXTERNALSYM SP_NOTREPORTED}
  SP_ERROR       = DWORD(-1);
  {$EXTERNALSYM SP_ERROR}
  SP_APPABORT    = DWORD(-2);
  {$EXTERNALSYM SP_APPABORT}
  SP_USERABORT   = DWORD(-3);
  {$EXTERNALSYM SP_USERABORT}
  SP_OUTOFDISK   = DWORD(-4);
  {$EXTERNALSYM SP_OUTOFDISK}
  SP_OUTOFMEMORY = DWORD(-5);
  {$EXTERNALSYM SP_OUTOFMEMORY}

  PR_JOBSTATUS = $0000;
  {$EXTERNALSYM PR_JOBSTATUS}

// Object Definitions for EnumObjects()

  OBJ_PEN         = 1;
  {$EXTERNALSYM OBJ_PEN}
  OBJ_BRUSH       = 2;
  {$EXTERNALSYM OBJ_BRUSH}
  OBJ_DC          = 3;
  {$EXTERNALSYM OBJ_DC}
  OBJ_METADC      = 4;
  {$EXTERNALSYM OBJ_METADC}
  OBJ_PAL         = 5;
  {$EXTERNALSYM OBJ_PAL}
  OBJ_FONT        = 6;
  {$EXTERNALSYM OBJ_FONT}
  OBJ_BITMAP      = 7;
  {$EXTERNALSYM OBJ_BITMAP}
  OBJ_REGION      = 8;
  {$EXTERNALSYM OBJ_REGION}
  OBJ_METAFILE    = 9;
  {$EXTERNALSYM OBJ_METAFILE}
  OBJ_MEMDC       = 10;
  {$EXTERNALSYM OBJ_MEMDC}
  OBJ_EXTPEN      = 11;
  {$EXTERNALSYM OBJ_EXTPEN}
  OBJ_ENHMETADC   = 12;
  {$EXTERNALSYM OBJ_ENHMETADC}
  OBJ_ENHMETAFILE = 13;
  {$EXTERNALSYM OBJ_ENHMETAFILE}
  OBJ_COLORSPACE  = 14;
  {$EXTERNALSYM OBJ_COLORSPACE}

// xform stuff

  MWT_IDENTITY      = 1;
  {$EXTERNALSYM MWT_IDENTITY}
  MWT_LEFTMULTIPLY  = 2;
  {$EXTERNALSYM MWT_LEFTMULTIPLY}
  MWT_RIGHTMULTIPLY = 3;
  {$EXTERNALSYM MWT_RIGHTMULTIPLY}

  MWT_MIN = MWT_IDENTITY;
  {$EXTERNALSYM MWT_MIN}
  MWT_MAX = MWT_RIGHTMULTIPLY;
  {$EXTERNALSYM MWT_MAX}

type
  PXform = ^TXform;
  tagXFORM = record
    eM11: FLOAT;
    eM12: FLOAT;
    eM21: FLOAT;
    eM22: FLOAT;
    eDx: FLOAT;
    eDy: FLOAT;
  end;
  {$EXTERNALSYM tagXFORM}
  XFORM = tagXFORM;
  {$EXTERNALSYM XFORM}
  LPXFORM = ^XFORM;
  {$EXTERNALSYM LPXFORM}
  TXform = XFORM;

// Bitmap Header Definition

  PBitmap = ^TBitmap;
  tagBITMAP = record
    bmType: LONG;
    bmWidth: LONG;
    bmHeight: LONG;
    bmWidthBytes: LONG;
    bmPlanes: WORD;
    bmBitsPixel: WORD;
    bmBits: LPVOID;
  end;
  {$EXTERNALSYM tagBITMAP}
  BITMAP = tagBITMAP;
  {$EXTERNALSYM BITMAP}
  LPBITMAP = ^BITMAP;
  {$EXTERNALSYM LPBITMAP}
  NPBITMAP = ^BITMAP;
  {$EXTERNALSYM NPBITMAP}
  TBitmap = BITMAP;

// #include <pshpack1.h>

  PRgbTriple = ^TRgbTriple;
  tagRGBTRIPLE = packed record
    rgbtBlue: BYTE;
    rgbtGreen: BYTE;
    rgbtRed: BYTE;
  end;
  {$EXTERNALSYM tagRGBTRIPLE}
  RGBTRIPLE = tagRGBTRIPLE;
  {$EXTERNALSYM RGBTRIPLE}
  TRgbTriple = RGBTRIPLE;

// #include <poppack.h>

  PRgbQuad = ^TRgbQuad;
  tagRGBQUAD = record
    rgbBlue: BYTE;
    rgbGreen: BYTE;
    rgbRed: BYTE;
    rgbReserved: BYTE;
  end;
  {$EXTERNALSYM tagRGBQUAD}
  RGBQUAD = tagRGBQUAD;
  {$EXTERNALSYM RGBQUAD}
  LPRGBQUAD = ^RGBQUAD;
  {$EXTERNALSYM LPRGBQUAD}
  TRgbQuad = RGBQUAD;

// Image Color Matching color definitions

const
  CS_ENABLE           = $00000001;
  {$EXTERNALSYM CS_ENABLE}
  CS_DISABLE          = $00000002;
  {$EXTERNALSYM CS_DISABLE}
  CS_DELETE_TRANSFORM = $00000003;
  {$EXTERNALSYM CS_DELETE_TRANSFORM}

// Logcolorspace signature

  LCS_SIGNATURE = 'PSOC';
  {$EXTERNALSYM LCS_SIGNATURE}

// Logcolorspace lcsType values

  LCS_sRGB                = 'sRGB';
  {$EXTERNALSYM LCS_sRGB}
  LCS_WINDOWS_COLOR_SPACE = 'Win '; // Windows default color space
  {$EXTERNALSYM LCS_WINDOWS_COLOR_SPACE}

type
  LCSCSTYPE = LONG;
  {$EXTERNALSYM LCSCSTYPE}

const
  LCS_CALIBRATED_RGB = $00000000;
  {$EXTERNALSYM LCS_CALIBRATED_RGB}

type
  LCSGAMUTMATCH = LONG;
  {$EXTERNALSYM LCSGAMUTMATCH }

const
  LCS_GM_BUSINESS         = $00000001;
  {$EXTERNALSYM LCS_GM_BUSINESS}
  LCS_GM_GRAPHICS         = $00000002;
  {$EXTERNALSYM LCS_GM_GRAPHICS}
  LCS_GM_IMAGES           = $00000004;
  {$EXTERNALSYM LCS_GM_IMAGES}
  LCS_GM_ABS_COLORIMETRIC = $00000008;
  {$EXTERNALSYM LCS_GM_ABS_COLORIMETRIC}

// ICM Defines for results from CheckColorInGamut()

  CM_OUT_OF_GAMUT = 255;
  {$EXTERNALSYM CM_OUT_OF_GAMUT}
  CM_IN_GAMUT     = 0;
  {$EXTERNALSYM CM_IN_GAMUT}

// UpdateICMRegKey Constants

  ICM_ADDPROFILE          = 1;
  {$EXTERNALSYM ICM_ADDPROFILE}
  ICM_DELETEPROFILE       = 2;
  {$EXTERNALSYM ICM_DELETEPROFILE}
  ICM_QUERYPROFILE        = 3;
  {$EXTERNALSYM ICM_QUERYPROFILE}
  ICM_SETDEFAULTPROFILE   = 4;
  {$EXTERNALSYM ICM_SETDEFAULTPROFILE}
  ICM_REGISTERICMATCHER   = 5;
  {$EXTERNALSYM ICM_REGISTERICMATCHER}
  ICM_UNREGISTERICMATCHER = 6;
  {$EXTERNALSYM ICM_UNREGISTERICMATCHER}
  ICM_QUERYMATCH          = 7;
  {$EXTERNALSYM ICM_QUERYMATCH}

// Macros to retrieve CMYK values from a COLORREF

function GetKValue(cmyk: COLORREF): BYTE;
{$EXTERNALSYM GetKValue}
function GetYValue(cmyk: COLORREF): BYTE;
{$EXTERNALSYM GetYValue}
function GetMValue(cmyk: COLORREF): BYTE;
{$EXTERNALSYM GetMValue}
function GetCValue(cmyk: COLORREF): BYTE;
{$EXTERNALSYM GetCValue}
function CMYK(c, m, y, k: BYTE): COLORREF;
{$EXTERNALSYM CMYK}

type
  FXPT16DOT16 = Longint;
  {$EXTERNALSYM FXPT16DOT16}
  LPFXPT16DOT16 = ^FXPT16DOT16;
  {$EXTERNALSYM LPFXPT16DOT16}

  FXPT2DOT30 = Longint;
  {$EXTERNALSYM FXPT2DOT30}
  LPFXPT2DOT30 = ^FXPT2DOT30;
  {$EXTERNALSYM LPFXPT2DOT30}

// ICM Color Definitions
// The following two structures are used for defining RGB's in terms of CIEXYZ.

  PCieXyz = ^TCieXyz;
  tagCIEXYZ = record
    ciexyzX: FXPT2DOT30;
    ciexyzY: FXPT2DOT30;
    ciexyzZ: FXPT2DOT30;
  end;
  {$EXTERNALSYM tagCIEXYZ}
  CIEXYZ = tagCIEXYZ;
  {$EXTERNALSYM CIEXYZ}
  LPCIEXYZ = ^CIEXYZ;
  {$EXTERNALSYM LPCIEXYZ}
  TCieXyz = CIEXYZ;

  PCieXyzTriple = ^TCieXyzTriple;
  tagCIEXYZTRIPLE = record
    ciexyzRed: CIEXYZ;
    ciexyzGreen: CIEXYZ;
    ciexyzBlue: CIEXYZ;
  end;
  {$EXTERNALSYM tagCIEXYZTRIPLE}
  CIEXYZTRIPLE = tagCIEXYZTRIPLE;
  {$EXTERNALSYM CIEXYZTRIPLE}
  LPCIEXYZTRIPLE = ^CIEXYZTRIPLE;
  {$EXTERNALSYM LPCIEXYZTRIPLE}
  TCieXyzTriple = CIEXYZTRIPLE;

// The next structures the logical color space. Unlike pens and brushes,
// but like palettes, there is only one way to create a LogColorSpace.
// A pointer to it must be passed, its elements can't be pushed as
// arguments.

  PLogColorSpaceA = ^TLogColorSpaceA;
  tagLOGCOLORSPACEA = record
    lcsSignature: DWORD;
    lcsVersion: DWORD;
    lcsSize: DWORD;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: CIEXYZTRIPLE;
    lcsGammaRed: DWORD;
    lcsGammaGreen: DWORD;
    lcsGammaBlue: DWORD;
    lcsFilename: array [0..MAX_PATH - 1] of CHAR;
  end;
  {$EXTERNALSYM tagLOGCOLORSPACEA}
  LOGCOLORSPACEA = tagLOGCOLORSPACEA;
  {$EXTERNALSYM LOGCOLORSPACEA}
  LPLOGCOLORSPACEA = ^LOGCOLORSPACEA;
  {$EXTERNALSYM LPLOGCOLORSPACEA}
  TLogColorSpaceA = LOGCOLORSPACEA;

  PLogColorSpaceW = ^TLogColorSpaceW;
  tagLOGCOLORSPACEW = record
    lcsSignature: DWORD;
    lcsVersion: DWORD;
    lcsSize: DWORD;
    lcsCSType: LCSCSTYPE;
    lcsIntent: LCSGAMUTMATCH;
    lcsEndpoints: CIEXYZTRIPLE;
    lcsGammaRed: DWORD;
    lcsGammaGreen: DWORD;
    lcsGammaBlue: DWORD;
    lcsFilename: array [0..MAX_PATH - 1] of WCHAR;
  end;
  {$EXTERNALSYM tagLOGCOLORSPACEW}
  LOGCOLORSPACEW = tagLOGCOLORSPACEW;
  {$EXTERNALSYM LOGCOLORSPACEW}
  LPLOGCOLORSPACEW = ^LOGCOLORSPACEW;
  {$EXTERNALSYM LPLOGCOLORSPACEW}
  TLogColorSpaceW = LOGCOLORSPACEW;

  {$IFDEF UNICODE}
  LOGCOLORSPACE = LOGCOLORSPACEW;
  {$EXTERNALSYM LOGCOLORSPACE}
  LPLOGCOLORSPACE = LPLOGCOLORSPACEW;
  {$EXTERNALSYM LPLOGCOLORSPACE}
  TLogColorSpace = TLogColorSpaceW;
  PLogColorSpace = PLogColorSpaceW;
  {$ELSE}
  LOGCOLORSPACE = LOGCOLORSPACEA;
  {$EXTERNALSYM LOGCOLORSPACE}
  LPLOGCOLORSPACE = LPLOGCOLORSPACEA;
  {$EXTERNALSYM LPLOGCOLORSPACE}
  TLogColorSpace = TLogColorSpaceA;
  PLogColorSpace = PLogColorSpaceA;
  {$ENDIF UNICODE}

// structures for defining DIBs

  PBitmapCoreHeader = ^TBitmapCoreHeader;
  tagBITMAPCOREHEADER = record
    bcSize: DWORD;
    bcWidth: WORD;
    bcHeight: WORD;
    bcPlanes: WORD;
    bcBitCount: WORD;
  end;
  {$EXTERNALSYM tagBITMAPCOREHEADER}
  BITMAPCOREHEADER = tagBITMAPCOREHEADER;
  {$EXTERNALSYM BITMAPCOREHEADER}
  LPBITMAPCOREHEADER = ^BITMAPCOREHEADER;
  {$EXTERNALSYM LPBITMAPCOREHEADER}
  TBitmapCoreHeader = BITMAPCOREHEADER;

  PBitmapInfoHeader = ^TBitmapInfoHeader;
  tagBITMAPINFOHEADER = record
    biSize: DWORD;
    biWidth: LONG;
    biHeight: LONG;
    biPlanes: WORD;
    biBitCount: WORD;
    biCompression: DWORD;
    biSizeImage: DWORD;
    biXPelsPerMeter: LONG;
    biYPelsPerMeter: LONG;
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;
  {$EXTERNALSYM tagBITMAPINFOHEADER}
  BITMAPINFOHEADER = tagBITMAPINFOHEADER;
  {$EXTERNALSYM BITMAPINFOHEADER}
  LPBITMAPINFOHEADER = ^BITMAPINFOHEADER;
  {$EXTERNALSYM LPBITMAPINFOHEADER}
  TBitmapInfoHeader = BITMAPINFOHEADER;

  PBitmapV4Header = ^TBitmapV4Header;
  BITMAPV4HEADER = record
    bV4Size: DWORD;
    bV4Width: LONG;
    bV4Height: LONG;
    bV4Planes: WORD;
    bV4BitCount: WORD;
    bV4V4Compression: DWORD;
    bV4SizeImage: DWORD;
    bV4XPelsPerMeter: LONG;
    bV4YPelsPerMeter: LONG;
    bV4ClrUsed: DWORD;
    bV4ClrImportant: DWORD;
    bV4RedMask: DWORD;
    bV4GreenMask: DWORD;
    bV4BlueMask: DWORD;
    bV4AlphaMask: DWORD;
    bV4CSType: DWORD;
    bV4Endpoints: CIEXYZTRIPLE;
    bV4GammaRed: DWORD;
    bV4GammaGreen: DWORD;
    bV4GammaBlue: DWORD;
  end;
  {$EXTERNALSYM BITMAPV4HEADER}
  LPBITMAPV4HEADER = ^BITMAPV4HEADER;
  {$EXTERNALSYM LPBITMAPV4HEADER}
  TBitmapV4Header = BITMAPV4HEADER;

  PBitmapV5Header = ^TBitmapV5Header;
  BITMAPV5HEADER = record
    bV5Size: DWORD;
    bV5Width: LONG;
    bV5Height: LONG;
    bV5Planes: WORD;
    bV5BitCount: WORD;
    bV5Compression: DWORD;
    bV5SizeImage: DWORD;
    bV5XPelsPerMeter: LONG;
    bV5YPelsPerMeter: LONG;
    bV5ClrUsed: DWORD;
    bV5ClrImportant: DWORD;
    bV5RedMask: DWORD;
    bV5GreenMask: DWORD;
    bV5BlueMask: DWORD;
    bV5AlphaMask: DWORD;
    bV5CSType: DWORD;
    bV5Endpoints: CIEXYZTRIPLE;
    bV5GammaRed: DWORD;
    bV5GammaGreen: DWORD;
    bV5GammaBlue: DWORD;
    bV5Intent: DWORD;
    bV5ProfileData: DWORD;
    bV5ProfileSize: DWORD;
    bV5Reserved: DWORD;
  end;
  {$EXTERNALSYM BITMAPV5HEADER}
  LPBITMAPV5HEADER = ^BITMAPV5HEADER;
  {$EXTERNALSYM LPBITMAPV5HEADER}
  TBitmapV5Header = BITMAPV5HEADER;

// Values for bV5CSType

const
  PROFILE_LINKED   = 'LINK';
  {$EXTERNALSYM PROFILE_LINKED}
  PROFILE_EMBEDDED = 'MBED';
  {$EXTERNALSYM PROFILE_EMBEDDED}

// constants for the biCompression field

  BI_RGB       = 0;
  {$EXTERNALSYM BI_RGB}
  BI_RLE8      = 1;
  {$EXTERNALSYM BI_RLE8}
  BI_RLE4      = 2;
  {$EXTERNALSYM BI_RLE4}
  BI_BITFIELDS = 3;
  {$EXTERNALSYM BI_BITFIELDS}
  BI_JPEG      = 4;
  {$EXTERNALSYM BI_JPEG}
  BI_PNG       = 5;
  {$EXTERNALSYM BI_PNG}

type
  PBitmapInfo = ^TBitmapInfo;
  tagBITMAPINFO = record
    bmiHeader: BITMAPINFOHEADER;
    bmiColors: array [0..0] of RGBQUAD;
  end;
  {$EXTERNALSYM tagBITMAPINFO}
  BITMAPINFO = tagBITMAPINFO;
  {$EXTERNALSYM BITMAPINFO}
  LPBITMAPINFO = ^BITMAPINFO;
  {$EXTERNALSYM LPBITMAPINFO}
  TBitmapInfo = BITMAPINFO;

  PBitmapCoreInfo = ^TBitmapCoreInfo;
  tagBITMAPCOREINFO = record
    bmciHeader: BITMAPCOREHEADER;
    bmciColors: array [0..0] of RGBTRIPLE;
  end;
  {$EXTERNALSYM tagBITMAPCOREINFO}
  BITMAPCOREINFO = tagBITMAPCOREINFO;
  {$EXTERNALSYM BITMAPCOREINFO}
  LPBITMAPCOREINFO = ^BITMAPCOREINFO;
  {$EXTERNALSYM LPBITMAPCOREINFO}
  TBitmapCoreInfo = BITMAPCOREINFO;

// #include <pshpack2.h>

  PBitmapFileHeader = ^TBitmapFileHeader;
  tagBITMAPFILEHEADER = packed record
    bfType: WORD;
    bfSize: DWORD;
    bfReserved1: WORD;
    bfReserved2: WORD;
    bfOffBits: DWORD;
  end;
  {$EXTERNALSYM tagBITMAPFILEHEADER}
  BITMAPFILEHEADER = tagBITMAPFILEHEADER;
  {$EXTERNALSYM BITMAPFILEHEADER}
  LPBITMAPFILEHEADER = ^BITMAPFILEHEADER;
  {$EXTERNALSYM BITMAPFILEHEADER}
  TBitmapFileHeader = BITMAPFILEHEADER;

// #include <poppack.h>

function MAKEPOINTS(l: DWORD): POINTS;
{$EXTERNALSYM MAKEPOINTS}

type
  PFontSignature = ^TFontSignature;
  tagFONTSIGNATURE = record
    fsUsb: array [0..3] of DWORD;
    fsCsb: array [0..1] of DWORD;
  end;
  {$EXTERNALSYM tagFONTSIGNATURE}
  FONTSIGNATURE = tagFONTSIGNATURE;
  {$EXTERNALSYM FONTSIGNATURE}
  LPFONTSIGNATURE = ^FONTSIGNATURE;
  {$EXTERNALSYM LPFONTSIGNATURE}
  TFontSignature = FONTSIGNATURE;

  PCharSetInfo = ^TCharSetInfo;
  tagCHARSETINFO = record
    ciCharset: UINT;
    ciACP: UINT;
    fs: FONTSIGNATURE;
  end;
  {$EXTERNALSYM tagCHARSETINFO}
  CHARSETINFO = tagCHARSETINFO;
  {$EXTERNALSYM CHARSETINFO}
  LPCHARSETINFO = ^CHARSETINFO;
  {$EXTERNALSYM LPCHARSETINFO}
  NPCHARSETINFO = ^CHARSETINFO;
  {$EXTERNALSYM NPCHARSETINFO}
  TCharSetInfo = CHARSETINFO;

const
  TCI_SRCCHARSET  = 1;
  {$EXTERNALSYM TCI_SRCCHARSET}
  TCI_SRCCODEPAGE = 2;
  {$EXTERNALSYM TCI_SRCCODEPAGE}
  TCI_SRCFONTSIG  = 3;
  {$EXTERNALSYM TCI_SRCFONTSIG}
  TCI_SRCLOCALE   = $1000;
  {$EXTERNALSYM TCI_SRCLOCALE}

type
  PLocaleSignature = ^TLocaleSignature;
  tagLOCALESIGNATURE = record
    lsUsb: array [0..3] of DWORD;
    lsCsbDefault: array [0..1] of DWORD;
    lsCsbSupported: array [0..1] of DWORD;
  end;
  {$EXTERNALSYM tagLOCALESIGNATURE}
  LOCALESIGNATURE = tagLOCALESIGNATURE;
  {$EXTERNALSYM LOCALESIGNATURE}
  LPLOCALESIGNATURE = ^LOCALESIGNATURE;
  {$EXTERNALSYM LPLOCALESIGNATURE}
  TLocaleSignature = LOCALESIGNATURE;

// Clipboard Metafile Picture Structure

  PHandleTable = ^THandleTable;
  tagHANDLETABLE = record
    objectHandle: array [0..0] of HGDIOBJ;
  end;
  {$EXTERNALSYM tagHANDLETABLE}
  HANDLETABLE = tagHANDLETABLE;
  {$EXTERNALSYM HANDLETABLE}
  LPHANDLETABLE = ^HANDLETABLE;
  {$EXTERNALSYM LPHANDLETABLE}
  THandleTable = HANDLETABLE;

  PMetaRecord = ^TMetaRecord;
  tagMETARECORD = record
    rdSize: DWORD;
    rdFunction: WORD;
    rdParm: array [0..0] of WORD;
  end;
  {$EXTERNALSYM tagMETARECORD}
  METARECORD = tagMETARECORD;
  {$EXTERNALSYM METARECORD}
  LPMETARECORD = ^METARECORD;
  {$EXTERNALSYM LPMETARECORD}
  TMetaRecord = METARECORD;

  PMetaFilePict = ^TMetaFilePict;
  tagMETAFILEPICT = record
    mm: LONG;
    xExt: LONG;
    yExt: LONG;
    hMF: HMETAFILE;
  end;
  {$EXTERNALSYM tagMETAFILEPICT}
  METAFILEPICT = tagMETAFILEPICT;
  {$EXTERNALSYM METAFILEPICT}
  LPMETAFILEPICT = ^METAFILEPICT;
  {$EXTERNALSYM LPMETAFILEPICT}
  TMetaFilePict = METAFILEPICT;

// #include <pshpack2.h>

  PMetaHeader = ^TMetaHeader;
  tagMETAHEADER = packed record
    mtType: WORD;
    mtHeaderSize: WORD;
    mtVersion: WORD;
    mtSize: DWORD;
    mtNoObjects: WORD;
    mtMaxRecord: DWORD;
    mtNoParameters: WORD;
  end;
  {$EXTERNALSYM tagMETAHEADER}
  METAHEADER = tagMETAHEADER;
  {$EXTERNALSYM METAHEADER}
  LPMETAHEADER = ^METAHEADER;
  {$EXTERNALSYM LPMETAHEADER}
  TMetaHeader = METAHEADER;

// #include <poppack.h>

// Enhanced Metafile structures

  PEnhMetaRecord = ^TEnhMetaRecord;
  tagENHMETARECORD = record
    iType: DWORD; // Record type EMR_XXX
    nSize: DWORD; // Record size in bytes
    dParm: array [0..0] of DWORD; // Parameters
  end;
  {$EXTERNALSYM tagENHMETARECORD}
  ENHMETARECORD = tagENHMETARECORD;
  {$EXTERNALSYM ENHMETARECORD}
  LPENHMETARECORD = ^ENHMETARECORD;
  {$EXTERNALSYM LPENHMETARECORD}
  TEnhMetaRecord = ENHMETARECORD;

  PEnhMetaHeader = ^TEnhMetaHeader;
  tagENHMETAHEADER = record
    iType: DWORD;              // Record type EMR_HEADER
    nSize: DWORD;              // Record size in bytes.  This may be greater
                               // than the sizeof(ENHMETAHEADER).
    rclBounds: RECTL;          // Inclusive-inclusive bounds in device units
    rclFrame: RECTL;           // Inclusive-inclusive Picture Frame of metafile in .01 mm units
    dSignature: DWORD;         // Signature.  Must be ENHMETA_SIGNATURE.
    nVersion: DWORD;           // Version number
    nBytes: DWORD;             // Size of the metafile in bytes
    nRecords: DWORD;           // Number of records in the metafile
    nHandles: WORD;            // Number of handles in the handle table
                               // Handle index zero is reserved.
    sReserved: WORD;           // Reserved.  Must be zero.
    nDescription: DWORD;       // Number of chars in the unicode description string
                               // This is 0 if there is no description string
    offDescription: DWORD;     // Offset to the metafile description record.
                               // This is 0 if there is no description string
    nPalEntries: DWORD;        // Number of entries in the metafile palette.
    szlDevice: SIZEL;          // Size of the reference device in pels
    szlMillimeters: SIZEL;     // Size of the reference device in millimeters
    cbPixelFormat: DWORD;      // Size of PIXELFORMATDESCRIPTOR information
                               // This is 0 if no pixel format is set
    offPixelFormat: DWORD;     // Offset to PIXELFORMATDESCRIPTOR
                               // This is 0 if no pixel format is set
    bOpenGL: DWORD;            // TRUE if OpenGL commands are present in
                               // the metafile, otherwise FALSE
    {$IFDEF WIN98ME_UP}
    szlMicrometers: SIZEL;     // Size of the reference device in micrometers
    {$ENDIF WIN98ME_UP}
  end;
  {$EXTERNALSYM tagENHMETAHEADER}
  ENHMETAHEADER = tagENHMETAHEADER;
  {$EXTERNALSYM ENHMETAHEADER}
  LPENHMETAHEADER = ^ENHMETAHEADER;
  {$EXTERNALSYM LPENHMETAHEADER}
  TEnhMetaHeader = tagENHMETAHEADER;

// tmPitchAndFamily flags

const
  TMPF_FIXED_PITCH = $01;
  {$EXTERNALSYM TMPF_FIXED_PITCH}
  TMPF_VECTOR      = $02;
  {$EXTERNALSYM TMPF_VECTOR}
  TMPF_DEVICE      = $08;
  {$EXTERNALSYM TMPF_DEVICE}
  TMPF_TRUETYPE    = $04;
  {$EXTERNALSYM TMPF_TRUETYPE}

//
// BCHAR definition for APPs
//

type
  {$IFDEF UNICODE}
  BCHAR = WCHAR;
  {$EXTERNALSYM BCHAR}
  {$ELSE}
  BCHAR = BYTE;
  {$EXTERNALSYM BCHAR}
  {$ENDIF UNICODE}

type
  PTextMetricA = ^TTextMetricA;
  tagTEXTMETRICA = record
    tmHeight: LONG;
    tmAscent: LONG;
    tmDescent: LONG;
    tmInternalLeading: LONG;
    tmExternalLeading: LONG;
    tmAveCharWidth: LONG;
    tmMaxCharWidth: LONG;
    tmWeight: LONG;
    tmOverhang: LONG;
    tmDigitizedAspectX: LONG;
    tmDigitizedAspectY: LONG;
    tmFirstChar: BYTE;
    tmLastChar: BYTE;
    tmDefaultChar: BYTE;
    tmBreakChar: BYTE;
    tmItalic: BYTE;
    tmUnderlined: BYTE;
    tmStruckOut: BYTE;
    tmPitchAndFamily: BYTE;
    tmCharSet: BYTE;
  end;
  {$EXTERNALSYM tagTEXTMETRICA}
  TEXTMETRICA = tagTEXTMETRICA;
  {$EXTERNALSYM TEXTMETRICA}
  LPTEXTMETRICA = ^TEXTMETRICA;
  {$EXTERNALSYM LPTEXTMETRICA}
  NPTEXTMETRICA = ^TEXTMETRICA;
  {$EXTERNALSYM NPTEXTMETRICA}
  TTextMetricA = TEXTMETRICA;

  PTextMetricW = ^TTextMetricW;
  tagTEXTMETRICW = record
    tmHeight: LONG;
    tmAscent: LONG;
    tmDescent: LONG;
    tmInternalLeading: LONG;
    tmExternalLeading: LONG;
    tmAveCharWidth: LONG;
    tmMaxCharWidth: LONG;
    tmWeight: LONG;
    tmOverhang: LONG;
    tmDigitizedAspectX: LONG;
    tmDigitizedAspectY: LONG;
    tmFirstChar: WCHAR;
    tmLastChar: WCHAR;
    tmDefaultChar: WCHAR;
    tmBreakChar: WCHAR;
    tmItalic: BYTE;
    tmUnderlined: BYTE;
    tmStruckOut: BYTE;
    tmPitchAndFamily: BYTE;
    tmCharSet: BYTE;
  end;
  {$EXTERNALSYM tagTEXTMETRICW}
  TEXTMETRICW = tagTEXTMETRICW;
  {$EXTERNALSYM TEXTMETRICW}
  LPTEXTMETRICW = ^TEXTMETRICW;
  {$EXTERNALSYM LPTEXTMETRICW}
  NPTEXTMETRICW = ^TEXTMETRICW;
  {$EXTERNALSYM NPTEXTMETRICW}
  TTextMetricW = TEXTMETRICW;

  {$IFDEF UNICODE}
  TEXTMETRIC = TEXTMETRICW;
  {$EXTERNALSYM TEXTMETRIC}
  PTEXTMETRIC = PTEXTMETRICW;
  {$EXTERNALSYM PTEXTMETRIC}
  NPTEXTMETRIC = NPTEXTMETRICW;
  {$EXTERNALSYM NPTEXTMETRIC}
  LPTEXTMETRIC = LPTEXTMETRICW;
  {$EXTERNALSYM LPTEXTMETRIC}
  TTextMetric = TTextMetricW;
  {$ELSE}
  TEXTMETRIC = TEXTMETRICA;
  {$EXTERNALSYM TEXTMETRIC}
  NPTEXTMETRIC = NPTEXTMETRICA;
  {$EXTERNALSYM NPTEXTMETRIC}
  LPTEXTMETRIC = LPTEXTMETRICA;
  {$EXTERNALSYM LPTEXTMETRIC}
  TTextMetric = TTextMetricA;
  {$ENDIF UNICODE}

// ntmFlags field flags

const
  NTM_REGULAR = $00000040;
  {$EXTERNALSYM NTM_REGULAR}
  NTM_BOLD    = $00000020;
  {$EXTERNALSYM NTM_BOLD}
  NTM_ITALIC  = $00000001;
  {$EXTERNALSYM NTM_ITALIC}

// new in NT 5.0

  NTM_NONNEGATIVE_AC = $00010000;
  {$EXTERNALSYM NTM_NONNEGATIVE_AC}
  NTM_PS_OPENTYPE    = $00020000;
  {$EXTERNALSYM NTM_PS_OPENTYPE}
  NTM_TT_OPENTYPE    = $00040000;
  {$EXTERNALSYM NTM_TT_OPENTYPE}
  NTM_MULTIPLEMASTER = $00080000;
  {$EXTERNALSYM NTM_MULTIPLEMASTER}
  NTM_TYPE1          = $00100000;
  {$EXTERNALSYM NTM_TYPE1}
  NTM_DSIG           = $00200000;
  {$EXTERNALSYM NTM_DSIG}

// #include <pshpack4.h>

type
  PNewTextMetricA = ^TNewTextMetricA;
  tagNEWTEXTMETRICA = record
    tmHeight: LONG;
    tmAscent: LONG;
    tmDescent: LONG;
    tmInternalLeading: LONG;
    tmExternalLeading: LONG;
    tmAveCharWidth: LONG;
    tmMaxCharWidth: LONG;
    tmWeight: LONG;
    tmOverhang: LONG;
    tmDigitizedAspectX: LONG;
    tmDigitizedAspectY: LONG;
    tmFirstChar: BYTE;
    tmLastChar: BYTE;
    tmDefaultChar: BYTE;
    tmBreakChar: BYTE;
    tmItalic: BYTE;
    tmUnderlined: BYTE;
    tmStruckOut: BYTE;
    tmPitchAndFamily: BYTE;
    tmCharSet: BYTE;
    ntmFlags: DWORD;
    ntmSizeEM: UINT;
    ntmCellHeight: UINT;
    ntmAvgWidth: UINT;
  end;
  {$EXTERNALSYM tagNEWTEXTMETRICA}
  NEWTEXTMETRICA = tagNEWTEXTMETRICA;
  {$EXTERNALSYM NEWTEXTMETRICA}
  LPNEWTEXTMETRICA = ^NEWTEXTMETRICA;
  {$EXTERNALSYM LPNEWTEXTMETRICA}
  NPNEWTEXTMETRICA = ^NEWTEXTMETRICA;
  {$EXTERNALSYM NPNEWTEXTMETRICA}
  TNewTextMetricA = NEWTEXTMETRICA;

  PNewTextMetricW = ^TNewTextMetricW;
  tagNEWTEXTMETRICW = record
    tmHeight: LONG;
    tmAscent: LONG;
    tmDescent: LONG;
    tmInternalLeading: LONG;
    tmExternalLeading: LONG;
    tmAveCharWidth: LONG;
    tmMaxCharWidth: LONG;
    tmWeight: LONG;
    tmOverhang: LONG;
    tmDigitizedAspectX: LONG;
    tmDigitizedAspectY: LONG;
    tmFirstChar: WCHAR;
    tmLastChar: WCHAR;
    tmDefaultChar: WCHAR;
    tmBreakChar: WCHAR;
    tmItalic: BYTE;
    tmUnderlined: BYTE;
    tmStruckOut: BYTE;
    tmPitchAndFamily: BYTE;
    tmCharSet: BYTE;
    ntmFlags: DWORD;
    ntmSizeEM: UINT;
    ntmCellHeight: UINT;
    ntmAvgWidth: UINT;
  end;
  {$EXTERNALSYM tagNEWTEXTMETRICW}
  NEWTEXTMETRICW = tagNEWTEXTMETRICW;
  {$EXTERNALSYM NEWTEXTMETRICW}
  LPNEWTEXTMETRICW = ^NEWTEXTMETRICW;
  {$EXTERNALSYM LPNEWTEXTMETRICW}
  NPNEWTEXTMETRICW = ^NEWTEXTMETRICW;
  {$EXTERNALSYM NPNEWTEXTMETRICW}
  TNewTextMetricW = NEWTEXTMETRICW;

  {$IFDEF UNICODE}
  NEWTEXTMETRIC = NEWTEXTMETRICW;
  {$EXTERNALSYM NEWTEXTMETRIC}
  PNEWTEXTMETRIC = PNEWTEXTMETRICW;
  {$EXTERNALSYM PNEWTEXTMETRIC}
  NPNEWTEXTMETRIC = NPNEWTEXTMETRICW;
  {$EXTERNALSYM NPNEWTEXTMETRIC}
  LPNEWTEXTMETRIC = LPNEWTEXTMETRICW;
  {$EXTERNALSYM LPNEWTEXTMETRIC}
  TNewTextMetric = TNewTextMetricW;
  {$ELSE}
  NEWTEXTMETRIC = NEWTEXTMETRICW;
  {$EXTERNALSYM NEWTEXTMETRIC}
  PNEWTEXTMETRIC = PNEWTEXTMETRICW;
  {$EXTERNALSYM PNEWTEXTMETRIC}
  NPNEWTEXTMETRIC = NPNEWTEXTMETRICW;
  {$EXTERNALSYM NPNEWTEXTMETRIC}
  LPNEWTEXTMETRIC = LPNEWTEXTMETRICW;
  {$EXTERNALSYM LPNEWTEXTMETRIC}
  TNewTextMetric = TNewTextMetricW;
  {$ENDIF UNICODE}

// #include <poppack.h>

  PNewTextMetricExA = ^TNewTextMetricExA;
  tagNEWTEXTMETRICEXA = record
    ntmTm: NEWTEXTMETRICA;
    ntmFontSig: FONTSIGNATURE;
  end;
  {$EXTERNALSYM tagNEWTEXTMETRICEXA}
  NEWTEXTMETRICEXA = tagNEWTEXTMETRICEXA;
  {$EXTERNALSYM NEWTEXTMETRICEXA}
  TNewTextMetricExA = NEWTEXTMETRICEXA;

  PNewTextMetricExW = ^TNewTextMetricExW;
  tagNEWTEXTMETRICEXW = record
    ntmTm: NEWTEXTMETRICW;
    ntmFontSig: FONTSIGNATURE;
  end;
  {$EXTERNALSYM tagNEWTEXTMETRICEXW}
  NEWTEXTMETRICEXW = tagNEWTEXTMETRICEXW;
  {$EXTERNALSYM NEWTEXTMETRICEXW}
  TNewTextMetricExW = NEWTEXTMETRICEXW;

  {$IFDEF UNICODE}
  NEWTEXTMETRICEX = NEWTEXTMETRICEXW;
  {$EXTERNALSYM NEWTEXTMETRICEX}
  TNewTextMetricEx = TNewTextMetricExW;
  PNewTextMetricEx = PNewTextMetricExW;
  {$ELSE}
  NEWTEXTMETRICEX = NEWTEXTMETRICEXA;
  {$EXTERNALSYM NEWTEXTMETRICEX}
  TNewTextMetricEx = TNewTextMetricExA;
  PNewTextMetricEx = PNewTextMetricExA;
  {$ENDIF UNICODE}

// GDI Logical Objects:

// Pel Array

  PPelArray = ^TPelArray;
  tagPELARRAY = record
    paXCount: LONG;
    paYCount: LONG;
    paXExt: LONG;
    paYExt: LONG;
    paRGBs: BYTE;
  end;
  {$EXTERNALSYM tagPELARRAY}
  PELARRAY = tagPELARRAY;
  {$EXTERNALSYM PELARRAY}
  LPPELARRAY = ^PELARRAY;
  {$EXTERNALSYM LPPELARRAY}
  TPelArray = PELARRAY;

// Logical Brush (or Pattern)

  PLogBrush = ^TLogBrush;
  tagLOGBRUSH = record
    lbStyle: UINT;
    lbColor: COLORREF;
    lbHatch: ULONG_PTR; // Sundown: lbHatch could hold a HANDLE
  end;
  {$EXTERNALSYM tagLOGBRUSH}
  LOGBRUSH = tagLOGBRUSH;
  {$EXTERNALSYM LOGBRUSH}
  LPLOGBRUSH = ^LOGBRUSH;
  {$EXTERNALSYM LPLOGBRUSH}
  NPLOGBRUSH = ^LOGBRUSH;
  {$EXTERNALSYM NPLOGBRUSH}
  TLogBrush = LOGBRUSH;

  PLogBrush32 = ^TLogBrush32;
  tagLOGBRUSH32 = record
    lbStyle: UINT;
    lbColor: COLORREF;
    lbHatch: ULONG;
  end;
  {$EXTERNALSYM tagLOGBRUSH32}
  LOGBRUSH32 = tagLOGBRUSH32;
  {$EXTERNALSYM LOGBRUSH32}
  LPLOGBRUSH32 = ^LOGBRUSH32;
  {$EXTERNALSYM LPLOGBRUSH32}
  NPLOGBRUSH32 = ^LOGBRUSH32;
  {$EXTERNALSYM NPLOGBRUSH32}
  TLogBrush32 = LOGBRUSH32;

  PATTERN = LOGBRUSH;
  {$EXTERNALSYM PATTERN}
  PPATTERN = ^PATTERN;
  {$EXTERNALSYM PPATTERN}
  LPPATTERN = ^PATTERN;
  {$EXTERNALSYM LPPATTERN}
  NPPATTERN = ^PATTERN;
  {$EXTERNALSYM NPPATTERN}

// Logical Pen

  PLogPen = ^TLogPen;
  tagLOGPEN = record
    lopnStyle: UINT;
    lopnWidth: POINT;
    lopnColor: COLORREF;
  end;
  {$EXTERNALSYM tagLOGPEN}
  LOGPEN = tagLOGPEN;
  {$EXTERNALSYM LOGPEN}
  LPLOGPEN = ^LOGPEN;
  {$EXTERNALSYM LPLOGPEN}
  NPLOGPEN = ^LOGPEN;
  {$EXTERNALSYM NPLOGPEN}
  TLogPen = LOGPEN;

  PExtLogPen = ^TExtLogPen;
  tagEXTLOGPEN = record
    elpPenStyle: DWORD;
    elpWidth: DWORD;
    elpBrushStyle: UINT;
    elpColor: COLORREF;
    elpHatch: ULONG_PTR; // Sundown: elpHatch could take a HANDLE
    elpNumEntries: DWORD;
    elpStyleEntry: array [0..0] of DWORD;
  end;
  {$EXTERNALSYM tagEXTLOGPEN}
  EXTLOGPEN = tagEXTLOGPEN;
  {$EXTERNALSYM EXTLOGPEN}
  LPEXTLOGPEN = ^EXTLOGPEN;
  {$EXTERNALSYM LPEXTLOGPEN}
  NPEXTLOGPEN = ^EXTLOGPEN;
  {$EXTERNALSYM NPEXTLOGPEN}
  TExtLogPen = EXTLOGPEN;

  PPaletteEntry = ^TPaletteEntry;
  tagPALETTEENTRY = record
    peRed: BYTE;
    peGreen: BYTE;
    peBlue: BYTE;
    peFlags: BYTE;
  end;
  {$EXTERNALSYM tagPALETTEENTRY}
  PALETTEENTRY = tagPALETTEENTRY;
  {$EXTERNALSYM PALETTEENTRY}
  LPPALETTEENTRY = ^PALETTEENTRY;
  {$EXTERNALSYM LPPALETTEENTRY}
  TPaletteEntry = PALETTEENTRY;

// Logical Palette

  PLogPalette = ^TLogPalette;
  tagLOGPALETTE = record
    palVersion: WORD;
    palNumEntries: WORD;
    palPalEntry: array [0..0] of PALETTEENTRY;
  end;
  {$EXTERNALSYM tagLOGPALETTE}
  LOGPALETTE = tagLOGPALETTE;
  {$EXTERNALSYM LOGPALETTE}
  LPLOGPALETTE = ^LOGPALETTE;
  {$EXTERNALSYM LPLOGPALETTE}
  NPLOGPALETTE = ^LOGPALETTE;
  {$EXTERNALSYM NPLOGPALETTE}
  TLogPalette = LOGPALETTE;

// Logical Font

const
  LF_FACESIZE = 32;
  {$EXTERNALSYM LF_FACESIZE}

type
  PLogFontA = ^TLogFontA;
  tagLOGFONTA = record
    lfHeight: LONG;
    lfWidth: LONG;
    lfEscapement: LONG;
    lfOrientation: LONG;
    lfWeight: LONG;
    lfItalic: BYTE;
    lfUnderline: BYTE;
    lfStrikeOut: BYTE;
    lfCharSet: BYTE;
    lfOutPrecision: BYTE;
    lfClipPrecision: BYTE;
    lfQuality: BYTE;
    lfPitchAndFamily: BYTE;
    lfFaceName: array [0..LF_FACESIZE - 1] of CHAR;
  end;
  {$EXTERNALSYM tagLOGFONTA}
  LOGFONTA = tagLOGFONTA;
  {$EXTERNALSYM LOGFONTA}
  LPLOGFONTA = ^LOGFONTA;
  {$EXTERNALSYM LPLOGFONTA}
  NPLOGFONTA = ^LOGFONTA;
  {$EXTERNALSYM NPLOGFONTA}
  TLogFontA = LOGFONTA;

  PLogFontW = ^TLogFontW;
  tagLOGFONTW = record
    lfHeight: LONG;
    lfWidth: LONG;
    lfEscapement: LONG;
    lfOrientation: LONG;
    lfWeight: LONG;
    lfItalic: BYTE;
    lfUnderline: BYTE;
    lfStrikeOut: BYTE;
    lfCharSet: BYTE;
    lfOutPrecision: BYTE;
    lfClipPrecision: BYTE;
    lfQuality: BYTE;
    lfPitchAndFamily: BYTE;
    lfFaceName: array [0..LF_FACESIZE - 1] of WCHAR;
  end;
  {$EXTERNALSYM tagLOGFONTW}
  LOGFONTW = tagLOGFONTW;
  {$EXTERNALSYM LOGFONTW}
  LPLOGFONTW = ^LOGFONTW;
  {$EXTERNALSYM LPLOGFONTW}
  NPLOGFONTW = ^LOGFONTW;
  {$EXTERNALSYM NPLOGFONTW}
  TLogFontW = LOGFONTW;

  {$IFDEF UNICODE}
  LOGFONT = LOGFONTW;
  {$EXTERNALSYM LOGFONT}
  PLOGFONT = PLOGFONTW;
  {$EXTERNALSYM PLOGFONT}
  NPLOGFONT = NPLOGFONTW;
  {$EXTERNALSYM NPLOGFONT}
  LPLOGFONT = LPLOGFONTW;
  {$EXTERNALSYM LPLOGFONT}
  TLogFont = TLogFontW;
  {$ELSE}
  LOGFONT = LOGFONTA;
  {$EXTERNALSYM LOGFONT}
  PLOGFONT = PLOGFONTA;
  {$EXTERNALSYM PLOGFONT}
  NPLOGFONT = NPLOGFONTA;
  {$EXTERNALSYM NPLOGFONT}
  LPLOGFONT = LPLOGFONTA;
  {$EXTERNALSYM LPLOGFONT}
  TLogFont = TLogFontA;
  {$ENDIF UNICODE}

const
  LF_FULLFACESIZE = 64;
  {$EXTERNALSYM LF_FULLFACESIZE}

// Structure passed to FONTENUMPROC

type
  PEnumLogFontA = ^TEnumLogFontA;
  tagENUMLOGFONTA = record
    elfLogFont: LOGFONTA;
    elfFullName: array [ 0..LF_FULLFACESIZE - 1] of BYTE;
    elfStyle: array [0..LF_FACESIZE - 1] of BYTE;
  end;
  {$EXTERNALSYM tagENUMLOGFONTA}
  ENUMLOGFONTA = tagENUMLOGFONTA;
  {$EXTERNALSYM ENUMLOGFONTA}
  LPENUMLOGFONTA = ^ENUMLOGFONTA;
  {$EXTERNALSYM LPENUMLOGFONTA}
  TEnumLogFontA = ENUMLOGFONTA;

// Structure passed to FONTENUMPROC

  PEnumLogFontW = ^TEnumLogFontW;
  tagENUMLOGFONTW = record
    elfLogFont: LOGFONTW;
    elfFullName: array [0..LF_FULLFACESIZE - 1] of WCHAR;
    elfStyle: array [0..LF_FACESIZE - 1] of WCHAR;
  end;
  {$EXTERNALSYM tagENUMLOGFONTW}
  ENUMLOGFONTW = tagENUMLOGFONTW;
  {$EXTERNALSYM ENUMLOGFONTW}
  LPENUMLOGFONTW = ^ENUMLOGFONTW;
  {$EXTERNALSYM LPENUMLOGFONTW}
  TEnumLogFontW = ENUMLOGFONTW;

  {$IFDEF UNICODE}
  ENUMLOGFONT = ENUMLOGFONTW;
  {$EXTERNALSYM ENUMLOGFONT}
  LPENUMLOGFONT = LPENUMLOGFONTW;
  {$EXTERNALSYM LPENUMLOGFONT}
  TEnumLogFont = TEnumLogFontW;
  PEnumLogFont = PEnumLogFontW;
  {$ELSE}
  ENUMLOGFONT = ENUMLOGFONTA;
  {$EXTERNALSYM ENUMLOGFONT}
  LPENUMLOGFONT = LPENUMLOGFONTA;
  {$EXTERNALSYM LPENUMLOGFONT}
  TEnumLogFont = TEnumLogFontA;
  PEnumLogFont = PEnumLogFontA;
  {$ENDIF UNICODE}

  PEnumLogFontExA = ^TEnumLogFontExA;
  tagENUMLOGFONTEXA = record
    elfLogFont: LOGFONTA;
    elfFullName: array [0..LF_FULLFACESIZE - 1] of BYTE;
    elfStyle: array [0..LF_FACESIZE - 1] of BYTE;
    elfScript: array [0..LF_FACESIZE - 1] of BYTE;
  end;
  {$EXTERNALSYM tagENUMLOGFONTEXA}
  ENUMLOGFONTEXA = tagENUMLOGFONTEXA;
  {$EXTERNALSYM ENUMLOGFONTEXA}
  LPENUMLOGFONTEXA = ^ENUMLOGFONTEXA;
  {$EXTERNALSYM LPENUMLOGFONTEXA}
  TEnumLogFontExA = ENUMLOGFONTEXA;

  PEnumLogFontExW = ^TEnumLogFontExW;
  tagENUMLOGFONTEXW = record
    elfLogFont: LOGFONTW;
    elfFullName: array [0..LF_FULLFACESIZE - 1] of WCHAR;
    elfStyle: array [0..LF_FACESIZE - 1] of WCHAR;
    elfScript: array [0..LF_FACESIZE - 1] of WCHAR;
  end;
  {$EXTERNALSYM tagENUMLOGFONTEXW}
  ENUMLOGFONTEXW = tagENUMLOGFONTEXW;
  {$EXTERNALSYM ENUMLOGFONTEXW}
  LPENUMLOGFONTEXW = ^ENUMLOGFONTEXW;
  {$EXTERNALSYM LPENUMLOGFONTEXW}
  TEnumLogFontExW = ENUMLOGFONTEXW;

  {$IFDEF UNICODE}
  ENUMLOGFONTEX = ENUMLOGFONTEXW;
  {$EXTERNALSYM ENUMLOGFONTEX}
  LPENUMLOGFONTEX = LPENUMLOGFONTEXW;
  {$EXTERNALSYM LPENUMLOGFONTEX}
  TEnumLogFontEx = TEnumLogFontExW;
  PEnumLogFontEx = PEnumLogFontExW;
  {$ELSE}
  ENUMLOGFONTEX = ENUMLOGFONTEXA;
  {$EXTERNALSYM ENUMLOGFONTEX}
  LPENUMLOGFONTEX = LPENUMLOGFONTEXA;
  {$EXTERNALSYM LPENUMLOGFONTEX}
  TEnumLogFontEx = TEnumLogFontExA;
  PEnumLogFontEx = PEnumLogFontExA;
  {$ENDIF UNICODE}

const
  OUT_DEFAULT_PRECIS        = 0;
  {$EXTERNALSYM OUT_DEFAULT_PRECIS}
  OUT_STRING_PRECIS         = 1;
  {$EXTERNALSYM OUT_STRING_PRECIS}
  OUT_CHARACTER_PRECIS      = 2;
  {$EXTERNALSYM OUT_CHARACTER_PRECIS}
  OUT_STROKE_PRECIS         = 3;
  {$EXTERNALSYM OUT_STROKE_PRECIS}
  OUT_TT_PRECIS             = 4;
  {$EXTERNALSYM OUT_TT_PRECIS}
  OUT_DEVICE_PRECIS         = 5;
  {$EXTERNALSYM OUT_DEVICE_PRECIS}
  OUT_RASTER_PRECIS         = 6;
  {$EXTERNALSYM OUT_RASTER_PRECIS}
  OUT_TT_ONLY_PRECIS        = 7;
  {$EXTERNALSYM OUT_TT_ONLY_PRECIS}
  OUT_OUTLINE_PRECIS        = 8;
  {$EXTERNALSYM OUT_OUTLINE_PRECIS}
  OUT_SCREEN_OUTLINE_PRECIS = 9;
  {$EXTERNALSYM OUT_SCREEN_OUTLINE_PRECIS}
  OUT_PS_ONLY_PRECIS        = 10;
  {$EXTERNALSYM OUT_PS_ONLY_PRECIS}

  CLIP_DEFAULT_PRECIS   = 0;
  {$EXTERNALSYM CLIP_DEFAULT_PRECIS}
  CLIP_CHARACTER_PRECIS = 1;
  {$EXTERNALSYM CLIP_CHARACTER_PRECIS}
  CLIP_STROKE_PRECIS    = 2;
  {$EXTERNALSYM CLIP_STROKE_PRECIS}
  CLIP_MASK             = $f;
  {$EXTERNALSYM CLIP_MASK}
  CLIP_LH_ANGLES        = 1 shl 4;
  {$EXTERNALSYM CLIP_LH_ANGLES}
  CLIP_TT_ALWAYS        = 2 shl 4;
  {$EXTERNALSYM CLIP_TT_ALWAYS}
  CLIP_DFA_DISABLE      = 4 shl 4;
  {$EXTERNALSYM CLIP_DFA_DISABLE}
  CLIP_EMBEDDED         = 8 shl 4;
  {$EXTERNALSYM CLIP_EMBEDDED}

  DEFAULT_QUALITY        = 0;
  {$EXTERNALSYM DEFAULT_QUALITY}
  DRAFT_QUALITY          = 1;
  {$EXTERNALSYM DRAFT_QUALITY}
  PROOF_QUALITY          = 2;
  {$EXTERNALSYM PROOF_QUALITY}
  NONANTIALIASED_QUALITY = 3;
  {$EXTERNALSYM NONANTIALIASED_QUALITY}
  ANTIALIASED_QUALITY    = 4;
  {$EXTERNALSYM ANTIALIASED_QUALITY}
  CLEARTYPE_QUALITY      = 5;
  {$EXTERNALSYM CLEARTYPE_QUALITY}

//#if (_WIN32_WINNT >= 0x0501)
  CLEARTYPE_NATURAL_QUALITY = 6;
  {$EXTERNALSYM CLEARTYPE_NATURAL_QUALITY}
//#endif

  DEFAULT_PITCH  = 0;
  {$EXTERNALSYM DEFAULT_PITCH}
  FIXED_PITCH    = 1;
  {$EXTERNALSYM FIXED_PITCH}
  VARIABLE_PITCH = 2;
  {$EXTERNALSYM VARIABLE_PITCH}
  MONO_FONT      = 8;
  {$EXTERNALSYM MONO_FONT}

  ANSI_CHARSET        = 0;
  {$EXTERNALSYM ANSI_CHARSET}
  DEFAULT_CHARSET     = 1;
  {$EXTERNALSYM DEFAULT_CHARSET}
  SYMBOL_CHARSET      = 2;
  {$EXTERNALSYM SYMBOL_CHARSET}
  SHIFTJIS_CHARSET    = 128;
  {$EXTERNALSYM SHIFTJIS_CHARSET}
  HANGEUL_CHARSET     = 129;
  {$EXTERNALSYM HANGEUL_CHARSET}
  HANGUL_CHARSET      = 129;
  {$EXTERNALSYM HANGUL_CHARSET}
  GB2312_CHARSET      = 134;
  {$EXTERNALSYM GB2312_CHARSET}
  CHINESEBIG5_CHARSET = 136;
  {$EXTERNALSYM CHINESEBIG5_CHARSET}
  OEM_CHARSET         = 255;
  {$EXTERNALSYM OEM_CHARSET}
  JOHAB_CHARSET       = 130;
  {$EXTERNALSYM JOHAB_CHARSET}
  HEBREW_CHARSET      = 177;
  {$EXTERNALSYM HEBREW_CHARSET}
  ARABIC_CHARSET      = 178;
  {$EXTERNALSYM ARABIC_CHARSET}
  GREEK_CHARSET       = 161;
  {$EXTERNALSYM GREEK_CHARSET}
  TURKISH_CHARSET     = 162;
  {$EXTERNALSYM TURKISH_CHARSET}
  VIETNAMESE_CHARSET  = 163;
  {$EXTERNALSYM VIETNAMESE_CHARSET}
  THAI_CHARSET        = 222;
  {$EXTERNALSYM THAI_CHARSET}
  EASTEUROPE_CHARSET  = 238;
  {$EXTERNALSYM EASTEUROPE_CHARSET}
  RUSSIAN_CHARSET     = 204;
  {$EXTERNALSYM RUSSIAN_CHARSET}

  MAC_CHARSET    = 77;
  {$EXTERNALSYM MAC_CHARSET}
  BALTIC_CHARSET = 186;
  {$EXTERNALSYM BALTIC_CHARSET}

  FS_LATIN1      = $00000001;
  {$EXTERNALSYM FS_LATIN1}
  FS_LATIN2      = $00000002;
  {$EXTERNALSYM FS_LATIN2}
  FS_CYRILLIC    = $00000004;
  {$EXTERNALSYM FS_CYRILLIC}
  FS_GREEK       = $00000008;
  {$EXTERNALSYM FS_GREEK}
  FS_TURKISH     = $00000010;
  {$EXTERNALSYM FS_TURKISH}
  FS_HEBREW      = $00000020;
  {$EXTERNALSYM FS_HEBREW}
  FS_ARABIC      = $00000040;
  {$EXTERNALSYM FS_ARABIC}
  FS_BALTIC      = $00000080;
  {$EXTERNALSYM FS_BALTIC}
  FS_VIETNAMESE  = $00000100;
  {$EXTERNALSYM FS_VIETNAMESE}
  FS_THAI        = $00010000;
  {$EXTERNALSYM FS_THAI}
  FS_JISJAPAN    = $00020000;
  {$EXTERNALSYM FS_JISJAPAN}
  FS_CHINESESIMP = $00040000;
  {$EXTERNALSYM FS_CHINESESIMP}
  FS_WANSUNG     = $00080000;
  {$EXTERNALSYM FS_WANSUNG}
  FS_CHINESETRAD = $00100000;
  {$EXTERNALSYM FS_CHINESETRAD}
  FS_JOHAB       = $00200000;
  {$EXTERNALSYM FS_JOHAB}
  FS_SYMBOL      = $80000000;
  {$EXTERNALSYM FS_SYMBOL}

// Font Families

  FF_DONTCARE   = 0 shl 4; // Don't care or don't know.
  {$EXTERNALSYM FF_DONTCARE}
  FF_ROMAN      = 1 shl 4; // Variable stroke width, serifed.
  {$EXTERNALSYM FF_ROMAN}
                             // Times Roman, Century Schoolbook, etc.
  FF_SWISS      = 2 shl 4; // Variable stroke width, sans-serifed.
  {$EXTERNALSYM FF_SWISS}
                             // Helvetica, Swiss, etc.
  FF_MODERN     = 3 shl 4; // Constant stroke width, serifed or sans-serifed.
  {$EXTERNALSYM FF_MODERN}
                             // Pica, Elite, Courier, etc.
  FF_SCRIPT     = 4 shl 4; // Cursive, etc.
  {$EXTERNALSYM FF_SCRIPT}
  FF_DECORATIVE = 5 shl 4; // Old English, etc.
  {$EXTERNALSYM FF_DECORATIVE}

// Font Weights

  FW_DONTCARE   = 0;
  {$EXTERNALSYM FW_DONTCARE}
  FW_THIN       = 100;
  {$EXTERNALSYM FW_THIN}
  FW_EXTRALIGHT = 200;
  {$EXTERNALSYM FW_EXTRALIGHT}
  FW_LIGHT      = 300;
  {$EXTERNALSYM FW_LIGHT}
  FW_NORMAL     = 400;
  {$EXTERNALSYM FW_NORMAL}
  FW_MEDIUM     = 500;
  {$EXTERNALSYM FW_MEDIUM}
  FW_SEMIBOLD   = 600;
  {$EXTERNALSYM FW_SEMIBOLD}
  FW_BOLD       = 700;
  {$EXTERNALSYM FW_BOLD}
  FW_EXTRABOLD  = 800;
  {$EXTERNALSYM FW_EXTRABOLD}
  FW_HEAVY      = 900;
  {$EXTERNALSYM FW_HEAVY}

  FW_ULTRALIGHT = FW_EXTRALIGHT;
  {$EXTERNALSYM FW_ULTRALIGHT}
  FW_REGULAR    = FW_NORMAL;
  {$EXTERNALSYM FW_REGULAR}
  FW_DEMIBOLD   = FW_SEMIBOLD;
  {$EXTERNALSYM FW_DEMIBOLD}
  FW_ULTRABOLD  = FW_EXTRABOLD;
  {$EXTERNALSYM FW_ULTRABOLD}
  FW_BLACK      = FW_HEAVY;
  {$EXTERNALSYM FW_BLACK}

  PANOSE_COUNT              = 10;
  {$EXTERNALSYM PANOSE_COUNT}
  PAN_FAMILYTYPE_INDEX      = 0;
  {$EXTERNALSYM PAN_FAMILYTYPE_INDEX}
  PAN_SERIFSTYLE_INDEX      = 1;
  {$EXTERNALSYM PAN_SERIFSTYLE_INDEX}
  PAN_WEIGHT_INDEX          = 2;
  {$EXTERNALSYM PAN_WEIGHT_INDEX}
  PAN_PROPORTION_INDEX      = 3;
  {$EXTERNALSYM PAN_PROPORTION_INDEX}
  PAN_CONTRAST_INDEX        = 4;
  {$EXTERNALSYM PAN_CONTRAST_INDEX}
  PAN_STROKEVARIATION_INDEX = 5;
  {$EXTERNALSYM PAN_STROKEVARIATION_INDEX}
  PAN_ARMSTYLE_INDEX        = 6;
  {$EXTERNALSYM PAN_ARMSTYLE_INDEX}
  PAN_LETTERFORM_INDEX      = 7;
  {$EXTERNALSYM PAN_LETTERFORM_INDEX}
  PAN_MIDLINE_INDEX         = 8;
  {$EXTERNALSYM PAN_MIDLINE_INDEX}
  PAN_XHEIGHT_INDEX         = 9;
  {$EXTERNALSYM PAN_XHEIGHT_INDEX}

  PAN_CULTURE_LATIN = 0;
  {$EXTERNALSYM PAN_CULTURE_LATIN}

type
  PPanose = ^TPanose;
  tagPANOSE = record
    bFamilyType: BYTE;
    bSerifStyle: BYTE;
    bWeight: BYTE;
    bProportion: BYTE;
    bContrast: BYTE;
    bStrokeVariation: BYTE;
    bArmStyle: BYTE;
    bLetterform: BYTE;
    bMidline: BYTE;
    bXHeight: BYTE;
  end;
  {$EXTERNALSYM tagPANOSE}
  PANOSE = tagPANOSE;
  {$EXTERNALSYM PANOSE}
  LPPANOSE = ^PANOSE;
  {$EXTERNALSYM LPPANOSE}
  TPanose = PANOSE;

const
  PAN_ANY    = 0; // Any
  {$EXTERNALSYM PAN_ANY}
  PAN_NO_FIT = 1; // No Fit
  {$EXTERNALSYM PAN_NO_FIT}

  PAN_FAMILY_TEXT_DISPLAY = 2; // Text and Display
  {$EXTERNALSYM PAN_FAMILY_TEXT_DISPLAY}
  PAN_FAMILY_SCRIPT       = 3; // Script
  {$EXTERNALSYM PAN_FAMILY_SCRIPT}
  PAN_FAMILY_DECORATIVE   = 4; // Decorative
  {$EXTERNALSYM PAN_FAMILY_DECORATIVE}
  PAN_FAMILY_PICTORIAL    = 5; // Pictorial
  {$EXTERNALSYM PAN_FAMILY_PICTORIAL}

  PAN_SERIF_COVE               = 2; // Cove
  {$EXTERNALSYM PAN_SERIF_COVE}
  PAN_SERIF_OBTUSE_COVE        = 3; // Obtuse Cove
  {$EXTERNALSYM PAN_SERIF_OBTUSE_COVE}
  PAN_SERIF_SQUARE_COVE        = 4; // Square Cove
  {$EXTERNALSYM PAN_SERIF_SQUARE_COVE}
  PAN_SERIF_OBTUSE_SQUARE_COVE = 5; // Obtuse Square Cove
  {$EXTERNALSYM PAN_SERIF_OBTUSE_SQUARE_COVE}
  PAN_SERIF_SQUARE             = 6; // Square
  {$EXTERNALSYM PAN_SERIF_SQUARE}
  PAN_SERIF_THIN               = 7; // Thin
  {$EXTERNALSYM PAN_SERIF_THIN}
  PAN_SERIF_BONE               = 8; // Bone
  {$EXTERNALSYM PAN_SERIF_BONE}
  PAN_SERIF_EXAGGERATED        = 9; // Exaggerated
  {$EXTERNALSYM PAN_SERIF_EXAGGERATED}
  PAN_SERIF_TRIANGLE           = 10; // Triangle
  {$EXTERNALSYM PAN_SERIF_TRIANGLE}
  PAN_SERIF_NORMAL_SANS        = 11; // Normal Sans
  {$EXTERNALSYM PAN_SERIF_NORMAL_SANS}
  PAN_SERIF_OBTUSE_SANS        = 12; // Obtuse Sans
  {$EXTERNALSYM PAN_SERIF_OBTUSE_SANS}
  PAN_SERIF_PERP_SANS          = 13; // Prep Sans
  {$EXTERNALSYM PAN_SERIF_PERP_SANS}
  PAN_SERIF_FLARED             = 14; // Flared
  {$EXTERNALSYM PAN_SERIF_FLARED}
  PAN_SERIF_ROUNDED            = 15; // Rounded
  {$EXTERNALSYM PAN_SERIF_ROUNDED}

  PAN_WEIGHT_VERY_LIGHT = 2; // Very Light
  {$EXTERNALSYM PAN_WEIGHT_VERY_LIGHT}
  PAN_WEIGHT_LIGHT      = 3; // Light
  {$EXTERNALSYM PAN_WEIGHT_LIGHT}
  PAN_WEIGHT_THIN       = 4; // Thin
  {$EXTERNALSYM PAN_WEIGHT_THIN}
  PAN_WEIGHT_BOOK       = 5; // Book
  {$EXTERNALSYM PAN_WEIGHT_BOOK}
  PAN_WEIGHT_MEDIUM     = 6; // Medium
  {$EXTERNALSYM PAN_WEIGHT_MEDIUM}
  PAN_WEIGHT_DEMI       = 7; // Demi
  {$EXTERNALSYM PAN_WEIGHT_DEMI}
  PAN_WEIGHT_BOLD       = 8; // Bold
  {$EXTERNALSYM PAN_WEIGHT_BOLD}
  PAN_WEIGHT_HEAVY      = 9; // Heavy
  {$EXTERNALSYM PAN_WEIGHT_HEAVY}
  PAN_WEIGHT_BLACK      = 10; // Black
  {$EXTERNALSYM PAN_WEIGHT_BLACK}
  PAN_WEIGHT_NORD       = 11; // Nord
  {$EXTERNALSYM PAN_WEIGHT_NORD}

  PAN_PROP_OLD_STYLE      = 2; // Old Style
  {$EXTERNALSYM PAN_PROP_OLD_STYLE}
  PAN_PROP_MODERN         = 3; // Modern
  {$EXTERNALSYM PAN_PROP_MODERN}
  PAN_PROP_EVEN_WIDTH     = 4; // Even Width
  {$EXTERNALSYM PAN_PROP_EVEN_WIDTH}
  PAN_PROP_EXPANDED       = 5; // Expanded
  {$EXTERNALSYM PAN_PROP_EXPANDED}
  PAN_PROP_CONDENSED      = 6; // Condensed
  {$EXTERNALSYM PAN_PROP_CONDENSED}
  PAN_PROP_VERY_EXPANDED  = 7; // Very Expanded
  {$EXTERNALSYM PAN_PROP_VERY_EXPANDED}
  PAN_PROP_VERY_CONDENSED = 8; // Very Condensed
  {$EXTERNALSYM PAN_PROP_VERY_CONDENSED}
  PAN_PROP_MONOSPACED     = 9; // Monospaced
  {$EXTERNALSYM PAN_PROP_MONOSPACED}

  PAN_CONTRAST_NONE        = 2; // None
  {$EXTERNALSYM PAN_CONTRAST_NONE}
  PAN_CONTRAST_VERY_LOW    = 3; // Very Low
  {$EXTERNALSYM PAN_CONTRAST_VERY_LOW}
  PAN_CONTRAST_LOW         = 4; // Low
  {$EXTERNALSYM PAN_CONTRAST_LOW}
  PAN_CONTRAST_MEDIUM_LOW  = 5; // Medium Low
  {$EXTERNALSYM PAN_CONTRAST_MEDIUM_LOW}
  PAN_CONTRAST_MEDIUM      = 6; // Medium
  {$EXTERNALSYM PAN_CONTRAST_MEDIUM}
  PAN_CONTRAST_MEDIUM_HIGH = 7; // Mediim High
  {$EXTERNALSYM PAN_CONTRAST_MEDIUM_HIGH}
  PAN_CONTRAST_HIGH        = 8; // High
  {$EXTERNALSYM PAN_CONTRAST_HIGH}
  PAN_CONTRAST_VERY_HIGH   = 9; // Very High
  {$EXTERNALSYM PAN_CONTRAST_VERY_HIGH}

  PAN_STROKE_GRADUAL_DIAG = 2; // Gradual/Diagonal
  {$EXTERNALSYM PAN_STROKE_GRADUAL_DIAG}
  PAN_STROKE_GRADUAL_TRAN = 3; // Gradual/Transitional
  {$EXTERNALSYM PAN_STROKE_GRADUAL_TRAN}
  PAN_STROKE_GRADUAL_VERT = 4; // Gradual/Vertical
  {$EXTERNALSYM PAN_STROKE_GRADUAL_VERT}
  PAN_STROKE_GRADUAL_HORZ = 5; // Gradual/Horizontal
  {$EXTERNALSYM PAN_STROKE_GRADUAL_HORZ}
  PAN_STROKE_RAPID_VERT   = 6; // Rapid/Vertical
  {$EXTERNALSYM PAN_STROKE_RAPID_VERT}
  PAN_STROKE_RAPID_HORZ   = 7; // Rapid/Horizontal
  {$EXTERNALSYM PAN_STROKE_RAPID_HORZ}
  PAN_STROKE_INSTANT_VERT = 8; // Instant/Vertical
  {$EXTERNALSYM PAN_STROKE_INSTANT_VERT}

  PAN_STRAIGHT_ARMS_HORZ         = 2; // Straight Arms/Horizontal
  {$EXTERNALSYM PAN_STRAIGHT_ARMS_HORZ}
  PAN_STRAIGHT_ARMS_WEDGE        = 3; // Straight Arms/Wedge
  {$EXTERNALSYM PAN_STRAIGHT_ARMS_WEDGE}
  PAN_STRAIGHT_ARMS_VERT         = 4; // Straight Arms/Vertical
  {$EXTERNALSYM PAN_STRAIGHT_ARMS_VERT}
  PAN_STRAIGHT_ARMS_SINGLE_SERIF = 5; // Straight Arms/Single-Serif
  {$EXTERNALSYM PAN_STRAIGHT_ARMS_SINGLE_SERIF}
  PAN_STRAIGHT_ARMS_DOUBLE_SERIF = 6; // Straight Arms/Double-Serif
  {$EXTERNALSYM PAN_STRAIGHT_ARMS_DOUBLE_SERIF}
  PAN_BENT_ARMS_HORZ             = 7; // Non-Straight Arms/Horizontal
  {$EXTERNALSYM PAN_BENT_ARMS_HORZ}
  PAN_BENT_ARMS_WEDGE            = 8; // Non-Straight Arms/Wedge
  {$EXTERNALSYM PAN_BENT_ARMS_WEDGE}
  PAN_BENT_ARMS_VERT             = 9; // Non-Straight Arms/Vertical
  {$EXTERNALSYM PAN_BENT_ARMS_VERT}
  PAN_BENT_ARMS_SINGLE_SERIF     = 10; // Non-Straight Arms/Single-Serif
  {$EXTERNALSYM PAN_BENT_ARMS_SINGLE_SERIF}
  PAN_BENT_ARMS_DOUBLE_SERIF     = 11; // Non-Straight Arms/Double-Serif
  {$EXTERNALSYM PAN_BENT_ARMS_DOUBLE_SERIF}

  PAN_LETT_NORMAL_CONTACT     = 2; // Normal/Contact
  {$EXTERNALSYM PAN_LETT_NORMAL_CONTACT}
  PAN_LETT_NORMAL_WEIGHTED    = 3; // Normal/Weighted
  {$EXTERNALSYM PAN_LETT_NORMAL_WEIGHTED}
  PAN_LETT_NORMAL_BOXED       = 4; // Normal/Boxed
  {$EXTERNALSYM PAN_LETT_NORMAL_BOXED}
  PAN_LETT_NORMAL_FLATTENED   = 5; // Normal/Flattened
  {$EXTERNALSYM PAN_LETT_NORMAL_FLATTENED}
  PAN_LETT_NORMAL_ROUNDED     = 6; // Normal/Rounded
  {$EXTERNALSYM PAN_LETT_NORMAL_ROUNDED}
  PAN_LETT_NORMAL_OFF_CENTER  = 7; // Normal/Off Center
  {$EXTERNALSYM PAN_LETT_NORMAL_OFF_CENTER}
  PAN_LETT_NORMAL_SQUARE      = 8; // Normal/Square
  {$EXTERNALSYM PAN_LETT_NORMAL_SQUARE}
  PAN_LETT_OBLIQUE_CONTACT    = 9; // Oblique/Contact
  {$EXTERNALSYM PAN_LETT_OBLIQUE_CONTACT}
  PAN_LETT_OBLIQUE_WEIGHTED   = 10; // Oblique/Weighted
  {$EXTERNALSYM PAN_LETT_OBLIQUE_WEIGHTED}
  PAN_LETT_OBLIQUE_BOXED      = 11; // Oblique/Boxed
  {$EXTERNALSYM PAN_LETT_OBLIQUE_BOXED}
  PAN_LETT_OBLIQUE_FLATTENED  = 12; // Oblique/Flattened
  {$EXTERNALSYM PAN_LETT_OBLIQUE_FLATTENED}
  PAN_LETT_OBLIQUE_ROUNDED    = 13; // Oblique/Rounded
  {$EXTERNALSYM PAN_LETT_OBLIQUE_ROUNDED}
  PAN_LETT_OBLIQUE_OFF_CENTER = 14; // Oblique/Off Center
  {$EXTERNALSYM PAN_LETT_OBLIQUE_OFF_CENTER}
  PAN_LETT_OBLIQUE_SQUARE     = 15; // Oblique/Square
  {$EXTERNALSYM PAN_LETT_OBLIQUE_SQUARE}

  PAN_MIDLINE_STANDARD_TRIMMED = 2; // Standard/Trimmed
  {$EXTERNALSYM PAN_MIDLINE_STANDARD_TRIMMED}
  PAN_MIDLINE_STANDARD_POINTED = 3; // Standard/Pointed
  {$EXTERNALSYM PAN_MIDLINE_STANDARD_POINTED}
  PAN_MIDLINE_STANDARD_SERIFED = 4; // Standard/Serifed
  {$EXTERNALSYM PAN_MIDLINE_STANDARD_SERIFED}
  PAN_MIDLINE_HIGH_TRIMMED     = 5; // High/Trimmed
  {$EXTERNALSYM PAN_MIDLINE_HIGH_TRIMMED}
  PAN_MIDLINE_HIGH_POINTED     = 6; // High/Pointed
  {$EXTERNALSYM PAN_MIDLINE_HIGH_POINTED}
  PAN_MIDLINE_HIGH_SERIFED     = 7; // High/Serifed
  {$EXTERNALSYM PAN_MIDLINE_HIGH_SERIFED}
  PAN_MIDLINE_CONSTANT_TRIMMED = 8; // Constant/Trimmed
  {$EXTERNALSYM PAN_MIDLINE_CONSTANT_TRIMMED}
  PAN_MIDLINE_CONSTANT_POINTED = 9; // Constant/Pointed
  {$EXTERNALSYM PAN_MIDLINE_CONSTANT_POINTED}
  PAN_MIDLINE_CONSTANT_SERIFED = 10; // Constant/Serifed
  {$EXTERNALSYM PAN_MIDLINE_CONSTANT_SERIFED}
  PAN_MIDLINE_LOW_TRIMMED      = 11; // Low/Trimmed
  {$EXTERNALSYM PAN_MIDLINE_LOW_TRIMMED}
  PAN_MIDLINE_LOW_POINTED      = 12; // Low/Pointed
  {$EXTERNALSYM PAN_MIDLINE_LOW_POINTED}
  PAN_MIDLINE_LOW_SERIFED      = 13; // Low/Serifed
  {$EXTERNALSYM PAN_MIDLINE_LOW_SERIFED}

  PAN_XHEIGHT_CONSTANT_SMALL = 2; // Constant/Small
  {$EXTERNALSYM PAN_XHEIGHT_CONSTANT_SMALL}
  PAN_XHEIGHT_CONSTANT_STD   = 3; // Constant/Standard
  {$EXTERNALSYM PAN_XHEIGHT_CONSTANT_STD}
  PAN_XHEIGHT_CONSTANT_LARGE = 4; // Constant/Large
  {$EXTERNALSYM PAN_XHEIGHT_CONSTANT_LARGE}
  PAN_XHEIGHT_DUCKING_SMALL  = 5; // Ducking/Small
  {$EXTERNALSYM PAN_XHEIGHT_DUCKING_SMALL}
  PAN_XHEIGHT_DUCKING_STD    = 6; // Ducking/Standard
  {$EXTERNALSYM PAN_XHEIGHT_DUCKING_STD}
  PAN_XHEIGHT_DUCKING_LARGE  = 7; // Ducking/Large
  {$EXTERNALSYM PAN_XHEIGHT_DUCKING_LARGE}

  ELF_VENDOR_SIZE = 4;
  {$EXTERNALSYM ELF_VENDOR_SIZE}

// The extended logical font
// An extension of the ENUMLOGFONT

type
  PExtLogFontA = ^TExtLogFontA;
  tagEXTLOGFONTA = record
    elfLogFont: LOGFONTA;
    elfFullName: array [0..LF_FULLFACESIZE - 1] of BYTE;
    elfStyle: array [0..LF_FACESIZE - 1] of BYTE;
    elfVersion: DWORD;
    elfStyleSize: DWORD;
    elfMatch: DWORD;
    elfReserved: DWORD;
    elfVendorId: array [0..ELF_VENDOR_SIZE - 1] of BYTE;
    elfCulture: DWORD;
    elfPanose: PANOSE;
  end;
  {$EXTERNALSYM tagEXTLOGFONTA}
  EXTLOGFONTA = tagEXTLOGFONTA;
  {$EXTERNALSYM EXTLOGFONTA}
  LPEXTLOGFONTA = ^EXTLOGFONTA;
  {$EXTERNALSYM LPEXTLOGFONTA}
  NPEXTLOGFONTA = ^EXTLOGFONTA;
  {$EXTERNALSYM NPEXTLOGFONTA}
  TExtLogFontA = EXTLOGFONTA;

  PExtLogFontW = ^TExtLogFontW;
  tagEXTLOGFONTW = record
    elfLogFont: LOGFONTW;
    elfFullName: array [0..LF_FULLFACESIZE - 1] of WCHAR;
    elfStyle: array [0..LF_FACESIZE - 1] of WCHAR;
    elfVersion: DWORD;
    elfStyleSize: DWORD;
    elfMatch: DWORD;
    elfReserved: DWORD;
    elfVendorId: array [0..ELF_VENDOR_SIZE - 1] of BYTE;
    elfCulture: DWORD;
    elfPanose: PANOSE;
  end;
  {$EXTERNALSYM tagEXTLOGFONTW}
  EXTLOGFONTW = tagEXTLOGFONTW;
  {$EXTERNALSYM EXTLOGFONTW}
  LPEXTLOGFONTW = ^EXTLOGFONTW;
  {$EXTERNALSYM LPEXTLOGFONTW}
  NPEXTLOGFONTW = ^EXTLOGFONTW;
  {$EXTERNALSYM NPEXTLOGFONTW}
  TExtLogFontW = EXTLOGFONTW;

  {$IFDEF UNICODE}
  EXTLOGFONT = EXTLOGFONTW;
  {$EXTERNALSYM EXTLOGFONT}
  PEXTLOGFONT = PEXTLOGFONTW;
  {$EXTERNALSYM PEXTLOGFONT}
  NPEXTLOGFONT = NPEXTLOGFONTW;
  {$EXTERNALSYM NPEXTLOGFONT}
  LPEXTLOGFONT = LPEXTLOGFONTW;
  {$EXTERNALSYM LPEXTLOGFONT}
  TExtLogFont = TExtLogFontW;
  {$ELSE}
  EXTLOGFONT = EXTLOGFONTA;
  {$EXTERNALSYM EXTLOGFONT}
  PEXTLOGFONT = PEXTLOGFONTA;
  {$EXTERNALSYM PEXTLOGFONT}
  NPEXTLOGFONT = NPEXTLOGFONTA;
  {$EXTERNALSYM NPEXTLOGFONT}
  LPEXTLOGFONT = LPEXTLOGFONTA;
  {$EXTERNALSYM LPEXTLOGFONT}
  TExtLogFont = TExtLogFontA;
  {$ENDIF UNICODE}

const
  ELF_VERSION       = 0;
  {$EXTERNALSYM ELF_VERSION}
  ELF_CULTURE_LATIN = 0;
  {$EXTERNALSYM ELF_CULTURE_LATIN}

// EnumFonts Masks

  RASTER_FONTTYPE   = $0001;
  {$EXTERNALSYM RASTER_FONTTYPE}
  DEVICE_FONTTYPE   = $002;
  {$EXTERNALSYM DEVICE_FONTTYPE}
  TRUETYPE_FONTTYPE = $004;
  {$EXTERNALSYM TRUETYPE_FONTTYPE}

function RGB(r, g, b: BYTE): COLORREF;
{$EXTERNALSYM RGB}
function PALETTERGB(r, g, b: BYTE): COLORREF;
{$EXTERNALSYM PALETTERGB}
function PALETTEINDEX(i: WORD): COLORREF;
{$EXTERNALSYM PALETTEINDEX}

// palette entry flags

const
  PC_RESERVED   = $01; // palette index used for animation
  {$EXTERNALSYM PC_RESERVED}
  PC_EXPLICIT   = $02; // palette index is explicit to device
  {$EXTERNALSYM PC_EXPLICIT}
  PC_NOCOLLAPSE = $04; // do not match color to system palette
  {$EXTERNALSYM PC_NOCOLLAPSE}

function GetRValue(rgb: COLORREF): BYTE;
{$EXTERNALSYM GetRValue}
function GetGValue(rgb: COLORREF): BYTE;
{$EXTERNALSYM GetGValue}
function GetBValue(rgb: COLORREF): BYTE;
{$EXTERNALSYM GetBValue}

// Background Modes

const
  TRANSPARENT = 1;
  {$EXTERNALSYM TRANSPARENT}
  OPAQUE      = 2;
  {$EXTERNALSYM OPAQUE}
  BKMODE_LAST = 2;
  {$EXTERNALSYM BKMODE_LAST}

// Graphics Modes

  GM_COMPATIBLE = 1;
  {$EXTERNALSYM GM_COMPATIBLE}
  GM_ADVANCED   = 2;
  {$EXTERNALSYM GM_ADVANCED}
  GM_LAST       = 2;
  {$EXTERNALSYM GM_LAST}

// PolyDraw and GetPath point types

  PT_CLOSEFIGURE = $01;
  {$EXTERNALSYM PT_CLOSEFIGURE}
  PT_LINETO      = $02;
  {$EXTERNALSYM PT_LINETO}
  PT_BEZIERTO    = $04;
  {$EXTERNALSYM PT_BEZIERTO}
  PT_MOVETO      = $06;
  {$EXTERNALSYM PT_MOVETO}

// Mapping Modes

  MM_TEXT        = 1;
  {$EXTERNALSYM MM_TEXT}
  MM_LOMETRIC    = 2;
  {$EXTERNALSYM MM_LOMETRIC}
  MM_HIMETRIC    = 3;
  {$EXTERNALSYM MM_HIMETRIC}
  MM_LOENGLISH   = 4;
  {$EXTERNALSYM MM_LOENGLISH}
  MM_HIENGLISH   = 5;
  {$EXTERNALSYM MM_HIENGLISH}
  MM_TWIPS       = 6;
  {$EXTERNALSYM MM_TWIPS}
  MM_ISOTROPIC   = 7;
  {$EXTERNALSYM MM_ISOTROPIC}
  MM_ANISOTROPIC = 8;
  {$EXTERNALSYM MM_ANISOTROPIC}

// Min and Max Mapping Mode values

  MM_MIN            = MM_TEXT;
  {$EXTERNALSYM MM_MIN}
  MM_MAX            = MM_ANISOTROPIC;
  {$EXTERNALSYM MM_MAX}
  MM_MAX_FIXEDSCALE = MM_TWIPS;
  {$EXTERNALSYM MM_MAX_FIXEDSCALE}

// Coordinate Modes

  ABSOLUTE = 1;
  {$EXTERNALSYM ABSOLUTE}
  RELATIVE = 2;
  {$EXTERNALSYM RELATIVE}

// Stock Logical Objects

  WHITE_BRUSH         = 0;
  {$EXTERNALSYM WHITE_BRUSH}
  LTGRAY_BRUSH        = 1;
  {$EXTERNALSYM LTGRAY_BRUSH}
  GRAY_BRUSH          = 2;
  {$EXTERNALSYM GRAY_BRUSH}
  DKGRAY_BRUSH        = 3;
  {$EXTERNALSYM DKGRAY_BRUSH}
  BLACK_BRUSH         = 4;
  {$EXTERNALSYM BLACK_BRUSH}
  NULL_BRUSH          = 5;
  {$EXTERNALSYM NULL_BRUSH}
  HOLLOW_BRUSH        = NULL_BRUSH;
  {$EXTERNALSYM HOLLOW_BRUSH}
  WHITE_PEN           = 6;
  {$EXTERNALSYM WHITE_PEN}
  BLACK_PEN           = 7;
  {$EXTERNALSYM BLACK_PEN}
  NULL_PEN            = 8;
  {$EXTERNALSYM NULL_PEN}
  OEM_FIXED_FONT      = 10;
  {$EXTERNALSYM OEM_FIXED_FONT}
  ANSI_FIXED_FONT     = 11;
  {$EXTERNALSYM ANSI_FIXED_FONT}
  ANSI_VAR_FONT       = 12;
  {$EXTERNALSYM ANSI_VAR_FONT}
  SYSTEM_FONT         = 13;
  {$EXTERNALSYM SYSTEM_FONT}
  DEVICE_DEFAULT_FONT = 14;
  {$EXTERNALSYM DEVICE_DEFAULT_FONT}
  DEFAULT_PALETTE     = 15;
  {$EXTERNALSYM DEFAULT_PALETTE}
  SYSTEM_FIXED_FONT   = 16;
  {$EXTERNALSYM SYSTEM_FIXED_FONT}

  DEFAULT_GUI_FONT = 17;
  {$EXTERNALSYM DEFAULT_GUI_FONT}

  DC_BRUSH = 18;
  {$EXTERNALSYM DC_BRUSH}
  DC_PEN   = 19;
  {$EXTERNALSYM DC_PEN}

  {$IFDEF WIN2000_UP}
  STOCK_LAST = 19;
  {$EXTERNALSYM STOCK_LAST}
  {$ELSE}
  {$IFDEF WIN95_UP}
  STOCK_LAST = 17;
  {$EXTERNALSYM STOCK_LAST}
  {$ELSE}
  STOCK_LAST = 16;
  {$EXTERNALSYM STOCK_LAST}
  {$ENDIF WIN95_UP}
  {$ENDIF WIN2000_UP}

  CLR_INVALID = DWORD($FFFFFFFF);
  {$EXTERNALSYM CLR_INVALID}

// Brush Styles

  BS_SOLID         = 0;
  {$EXTERNALSYM BS_SOLID}
  BS_NULL          = 1;
  {$EXTERNALSYM BS_NULL}
  BS_HOLLOW        = BS_NULL;
  {$EXTERNALSYM BS_HOLLOW}
  BS_HATCHED       = 2;
  {$EXTERNALSYM BS_HATCHED}
  BS_PATTERN       = 3;
  {$EXTERNALSYM BS_PATTERN}
  BS_INDEXED       = 4;
  {$EXTERNALSYM BS_INDEXED}
  BS_DIBPATTERN    = 5;
  {$EXTERNALSYM BS_DIBPATTERN}
  BS_DIBPATTERNPT  = 6;
  {$EXTERNALSYM BS_DIBPATTERNPT}
  BS_PATTERN8X8    = 7;
  {$EXTERNALSYM BS_PATTERN8X8}
  BS_DIBPATTERN8X8 = 8;
  {$EXTERNALSYM BS_DIBPATTERN8X8}
  BS_MONOPATTERN   = 9;
  {$EXTERNALSYM BS_MONOPATTERN}

// Hatch Styles

  HS_HORIZONTAL = 0; // -----
  {$EXTERNALSYM HS_HORIZONTAL}
  HS_VERTICAL   = 1; // |||||
  {$EXTERNALSYM HS_VERTICAL}
  HS_FDIAGONAL  = 2; // \\\\\
  {$EXTERNALSYM HS_FDIAGONAL}
  HS_BDIAGONAL  = 3; // /////
  {$EXTERNALSYM HS_BDIAGONAL}
  HS_CROSS      = 4; // +++++
  {$EXTERNALSYM HS_CROSS}
  HS_DIAGCROSS  = 5; // xxxxx
  {$EXTERNALSYM HS_DIAGCROSS}

// Pen Styles

  PS_SOLID       = 0;
  {$EXTERNALSYM PS_SOLID}
  PS_DASH        = 1; // -------
  {$EXTERNALSYM PS_DASH}
  PS_DOT         = 2; // .......
  {$EXTERNALSYM PS_DOT}
  PS_DASHDOT     = 3; // _._._._
  {$EXTERNALSYM PS_DASHDOT}
  PS_DASHDOTDOT  = 4; // _.._.._
  {$EXTERNALSYM PS_DASHDOTDOT}
  PS_NULL        = 5;
  {$EXTERNALSYM PS_NULL}
  PS_INSIDEFRAME = 6;
  {$EXTERNALSYM PS_INSIDEFRAME}
  PS_USERSTYLE   = 7;
  {$EXTERNALSYM PS_USERSTYLE}
  PS_ALTERNATE   = 8;
  {$EXTERNALSYM PS_ALTERNATE}
  PS_STYLE_MASK  = $0000000F;
  {$EXTERNALSYM PS_STYLE_MASK}

  PS_ENDCAP_ROUND  = $00000000;
  {$EXTERNALSYM PS_ENDCAP_ROUND}
  PS_ENDCAP_SQUARE = $00000100;
  {$EXTERNALSYM PS_ENDCAP_SQUARE}
  PS_ENDCAP_FLAT   = $00000200;
  {$EXTERNALSYM PS_ENDCAP_FLAT}
  PS_ENDCAP_MASK   = $00000F00;
  {$EXTERNALSYM PS_ENDCAP_MASK}

  PS_JOIN_ROUND = $00000000;
  {$EXTERNALSYM PS_JOIN_ROUND}
  PS_JOIN_BEVEL = $00001000;
  {$EXTERNALSYM PS_JOIN_BEVEL}
  PS_JOIN_MITER = $00002000;
  {$EXTERNALSYM PS_JOIN_MITER}
  PS_JOIN_MASK  = $0000F000;
  {$EXTERNALSYM PS_JOIN_MASK}

  PS_COSMETIC  = $00000000;
  {$EXTERNALSYM PS_COSMETIC}
  PS_GEOMETRIC = $00010000;
  {$EXTERNALSYM PS_GEOMETRIC}
  PS_TYPE_MASK = $000F0000;
  {$EXTERNALSYM PS_TYPE_MASK}

  AD_COUNTERCLOCKWISE = 1;
  {$EXTERNALSYM AD_COUNTERCLOCKWISE}
  AD_CLOCKWISE        = 2;
  {$EXTERNALSYM AD_CLOCKWISE}

// Device Parameters for GetDeviceCaps()

  DRIVERVERSION = 0; // Device driver version
  {$EXTERNALSYM DRIVERVERSION}
  TECHNOLOGY    = 2; // Device classification
  {$EXTERNALSYM TECHNOLOGY}
  HORZSIZE      = 4; // Horizontal size in millimeters
  {$EXTERNALSYM HORZSIZE}
  VERTSIZE      = 6; // Vertical size in millimeters
  {$EXTERNALSYM VERTSIZE}
  HORZRES       = 8; // Horizontal width in pixels
  {$EXTERNALSYM HORZRES}
  VERTRES       = 10; // Vertical height in pixels
  {$EXTERNALSYM VERTRES}
  BITSPIXEL     = 12; // Number of bits per pixel
  {$EXTERNALSYM BITSPIXEL}
  PLANES        = 14; // Number of planes
  {$EXTERNALSYM PLANES}
  NUMBRUSHES    = 16; // Number of brushes the device has
  {$EXTERNALSYM NUMBRUSHES}
  NUMPENS       = 18; // Number of pens the device has
  {$EXTERNALSYM NUMPENS}
  NUMMARKERS    = 20; // Number of markers the device has
  {$EXTERNALSYM NUMMARKERS}
  NUMFONTS      = 22; // Number of fonts the device has
  {$EXTERNALSYM NUMFONTS}
  NUMCOLORS     = 24; // Number of colors the device supports
  {$EXTERNALSYM NUMCOLORS}
  PDEVICESIZE   = 26; // Size required for device descriptor
  {$EXTERNALSYM PDEVICESIZE}
  CURVECAPS     = 28; // Curve capabilities
  {$EXTERNALSYM CURVECAPS}
  LINECAPS      = 30; // Line capabilities
  {$EXTERNALSYM LINECAPS}
  POLYGONALCAPS = 32; // Polygonal capabilities
  {$EXTERNALSYM POLYGONALCAPS}
  TEXTCAPS      = 34; // Text capabilities
  {$EXTERNALSYM TEXTCAPS}
  CLIPCAPS      = 36; // Clipping capabilities
  {$EXTERNALSYM CLIPCAPS}
  RASTERCAPS    = 38; // Bitblt capabilities
  {$EXTERNALSYM RASTERCAPS}
  ASPECTX       = 40; // Length of the X leg
  {$EXTERNALSYM ASPECTX}
  ASPECTY       = 42; // Length of the Y leg
  {$EXTERNALSYM ASPECTY}
  ASPECTXY      = 44; // Length of the hypotenuse
  {$EXTERNALSYM ASPECTXY}

  LOGPIXELSX = 88; // Logical pixels/inch in X
  {$EXTERNALSYM LOGPIXELSX}
  LOGPIXELSY = 90; // Logical pixels/inch in Y
  {$EXTERNALSYM LOGPIXELSY}

  SIZEPALETTE = 104; // Number of entries in physical palette
  {$EXTERNALSYM SIZEPALETTE}
  NUMRESERVED = 106; // Number of reserved entries in palette
  {$EXTERNALSYM NUMRESERVED}
  COLORRES    = 108; // Actual color resolution
  {$EXTERNALSYM COLORRES}

// Printing related DeviceCaps. These replace the appropriate Escapes

  PHYSICALWIDTH   = 110; // Physical Width in device units
  {$EXTERNALSYM PHYSICALWIDTH}
  PHYSICALHEIGHT  = 111; // Physical Height in device units
  {$EXTERNALSYM PHYSICALHEIGHT}
  PHYSICALOFFSETX = 112; // Physical Printable Area x margin
  {$EXTERNALSYM PHYSICALOFFSETX}
  PHYSICALOFFSETY = 113; // Physical Printable Area y margin
  {$EXTERNALSYM PHYSICALOFFSETY}
  SCALINGFACTORX  = 114; // Scaling factor x
  {$EXTERNALSYM SCALINGFACTORX}
  SCALINGFACTORY  = 115; // Scaling factor y
  {$EXTERNALSYM SCALINGFACTORY}

// Display driver specific

  VREFRESH = 116;       // Current vertical refresh rate of the
  {$EXTERNALSYM VREFRESH}
                        // display device (for displays only) in Hz
  DESKTOPVERTRES = 117; // Horizontal width of entire desktop in
  {$EXTERNALSYM DESKTOPVERTRES}
                        // pixels
  DESKTOPHORZRES = 118; // Vertical height of entire desktop in
  {$EXTERNALSYM DESKTOPHORZRES}
                        // pixels
  BLTALIGNMENT = 119;   // Preferred blt alignment
  {$EXTERNALSYM BLTALIGNMENT}

  SHADEBLENDCAPS = 120; // Shading and blending caps
  {$EXTERNALSYM SHADEBLENDCAPS}
  COLORMGMTCAPS  = 121; // Color Management caps
  {$EXTERNALSYM COLORMGMTCAPS}

// Device Capability Masks:

// Device Technologies

  DT_PLOTTER    = 0; // Vector plotter
  {$EXTERNALSYM DT_PLOTTER}
  DT_RASDISPLAY = 1; // Raster display
  {$EXTERNALSYM DT_RASDISPLAY}
  DT_RASPRINTER = 2; // Raster printer
  {$EXTERNALSYM DT_RASPRINTER}
  DT_RASCAMERA  = 3; // Raster camera
  {$EXTERNALSYM DT_RASCAMERA}
  DT_CHARSTREAM = 4; // Character-stream, PLP
  {$EXTERNALSYM DT_CHARSTREAM}
  DT_METAFILE   = 5; // Metafile, VDM
  {$EXTERNALSYM DT_METAFILE}
  DT_DISPFILE   = 6; // Display-file
  {$EXTERNALSYM DT_DISPFILE}

// Curve Capabilities

  CC_NONE       = 0; // Curves not supported
  {$EXTERNALSYM CC_NONE}
  CC_CIRCLES    = 1; // Can do circles
  {$EXTERNALSYM CC_CIRCLES}
  CC_PIE        = 2; // Can do pie wedges
  {$EXTERNALSYM CC_PIE}
  CC_CHORD      = 4; // Can do chord arcs
  {$EXTERNALSYM CC_CHORD}
  CC_ELLIPSES   = 8; // Can do ellipese
  {$EXTERNALSYM CC_ELLIPSES}
  CC_WIDE       = 16; // Can do wide lines
  {$EXTERNALSYM CC_WIDE}
  CC_STYLED     = 32; // Can do styled lines
  {$EXTERNALSYM CC_STYLED}
  CC_WIDESTYLED = 64; // Can do wide styled lines
  {$EXTERNALSYM CC_WIDESTYLED}
  CC_INTERIORS  = 128; // Can do interiors
  {$EXTERNALSYM CC_INTERIORS}
  CC_ROUNDRECT  = 256;
  {$EXTERNALSYM CC_ROUNDRECT}

// Line Capabilities

  LC_NONE       = 0; // Lines not supported
  {$EXTERNALSYM LC_NONE}
  LC_POLYLINE   = 2; // Can do polylines
  {$EXTERNALSYM LC_POLYLINE}
  LC_MARKER     = 4; // Can do markers
  {$EXTERNALSYM LC_MARKER}
  LC_POLYMARKER = 8; // Can do polymarkers
  {$EXTERNALSYM LC_POLYMARKER}
  LC_WIDE       = 16; // Can do wide lines
  {$EXTERNALSYM LC_WIDE}
  LC_STYLED     = 32; // Can do styled lines
  {$EXTERNALSYM LC_STYLED}
  LC_WIDESTYLED = 64; // Can do wide styled lines
  {$EXTERNALSYM LC_WIDESTYLED}
  LC_INTERIORS  = 128; // Can do interiors
  {$EXTERNALSYM LC_INTERIORS}

// Polygonal Capabilities

  PC_NONE        = 0; // Polygonals not supported
  {$EXTERNALSYM PC_NONE}
  PC_POLYGON     = 1; // Can do polygons
  {$EXTERNALSYM PC_POLYGON}
  PC_RECTANGLE   = 2; // Can do rectangles
  {$EXTERNALSYM PC_RECTANGLE}
  PC_WINDPOLYGON = 4; // Can do winding polygons
  {$EXTERNALSYM PC_WINDPOLYGON}
  PC_TRAPEZOID   = 4; // Can do trapezoids
  {$EXTERNALSYM PC_TRAPEZOID}
  PC_SCANLINE    = 8; // Can do scanlines
  {$EXTERNALSYM PC_SCANLINE}
  PC_WIDE        = 16; // Can do wide borders
  {$EXTERNALSYM PC_WIDE}
  PC_STYLED      = 32; // Can do styled borders
  {$EXTERNALSYM PC_STYLED}
  PC_WIDESTYLED  = 64; // Can do wide styled borders
  {$EXTERNALSYM PC_WIDESTYLED}
  PC_INTERIORS   = 128; // Can do interiors
  {$EXTERNALSYM PC_INTERIORS}
  PC_POLYPOLYGON = 256; // Can do polypolygons
  {$EXTERNALSYM PC_POLYPOLYGON}
  PC_PATHS       = 512; // Can do paths
  {$EXTERNALSYM PC_PATHS}

// Clipping Capabilities

  CP_NONE      = 0; // No clipping of output
  {$EXTERNALSYM CP_NONE}
  CP_RECTANGLE = 1; // Output clipped to rects
  {$EXTERNALSYM CP_RECTANGLE}
  CP_REGION    = 2; // obsolete
  {$EXTERNALSYM CP_REGION}

// Text Capabilities

  TC_OP_CHARACTER = $00000001; // Can do OutputPrecision   CHARACTER
  {$EXTERNALSYM TC_OP_CHARACTER}
  TC_OP_STROKE    = $00000002; // Can do OutputPrecision   STROKE
  {$EXTERNALSYM TC_OP_STROKE}
  TC_CP_STROKE    = $00000004; // Can do ClipPrecision     STROKE
  {$EXTERNALSYM TC_CP_STROKE}
  TC_CR_90        = $00000008; // Can do CharRotAbility    90
  {$EXTERNALSYM TC_CR_90}
  TC_CR_ANY       = $00000010; // Can do CharRotAbility    ANY
  {$EXTERNALSYM TC_CR_ANY}
  TC_SF_X_YINDEP  = $00000020; // Can do ScaleFreedom      X_YINDEPENDENT
  {$EXTERNALSYM TC_SF_X_YINDEP}
  TC_SA_DOUBLE    = $00000040; // Can do ScaleAbility      DOUBLE
  {$EXTERNALSYM TC_SA_DOUBLE}
  TC_SA_INTEGER   = $00000080; // Can do ScaleAbility      INTEGER
  {$EXTERNALSYM TC_SA_INTEGER}
  TC_SA_CONTIN    = $00000100; // Can do ScaleAbility      CONTINUOUS
  {$EXTERNALSYM TC_SA_CONTIN}
  TC_EA_DOUBLE    = $00000200; // Can do EmboldenAbility   DOUBLE
  {$EXTERNALSYM TC_EA_DOUBLE}
  TC_IA_ABLE      = $00000400; // Can do ItalisizeAbility  ABLE
  {$EXTERNALSYM TC_IA_ABLE}
  TC_UA_ABLE      = $00000800; // Can do UnderlineAbility  ABLE
  {$EXTERNALSYM TC_UA_ABLE}
  TC_SO_ABLE      = $00001000; // Can do StrikeOutAbility  ABLE
  {$EXTERNALSYM TC_SO_ABLE}
  TC_RA_ABLE      = $00002000; // Can do RasterFontAble    ABLE
  {$EXTERNALSYM TC_RA_ABLE}
  TC_VA_ABLE      = $00004000; // Can do VectorFontAble    ABLE
  {$EXTERNALSYM TC_VA_ABLE}
  TC_RESERVED     = $00008000;
  {$EXTERNALSYM TC_RESERVED}
  TC_SCROLLBLT    = $00010000; // Don't do text scroll with blt
  {$EXTERNALSYM TC_SCROLLBLT}

// Raster Capabilities

  RC_BITBLT       = 1; // Can do standard BLT.
  {$EXTERNALSYM RC_BITBLT}
  RC_BANDING      = 2; // Device requires banding support
  {$EXTERNALSYM RC_BANDING}
  RC_SCALING      = 4; // Device requires scaling support
  {$EXTERNALSYM RC_SCALING}
  RC_BITMAP64     = 8; // Device can support >64K bitmap
  {$EXTERNALSYM RC_BITMAP64}
  RC_GDI20_OUTPUT = $0010; // has 2.0 output calls
  {$EXTERNALSYM RC_GDI20_OUTPUT}
  RC_GDI20_STATE  = $0020;
  {$EXTERNALSYM RC_GDI20_STATE}
  RC_SAVEBITMAP   = $0040;
  {$EXTERNALSYM RC_SAVEBITMAP}
  RC_DI_BITMAP    = $0080; // supports DIB to memory
  {$EXTERNALSYM RC_DI_BITMAP}
  RC_PALETTE      = $0100; // supports a palette
  {$EXTERNALSYM RC_PALETTE}
  RC_DIBTODEV     = $0200; // supports DIBitsToDevice
  {$EXTERNALSYM RC_DIBTODEV}
  RC_BIGFONT      = $0400; // supports >64K fonts
  {$EXTERNALSYM RC_BIGFONT}
  RC_STRETCHBLT   = $0800; // supports StretchBlt
  {$EXTERNALSYM RC_STRETCHBLT}
  RC_FLOODFILL    = $1000; // supports FloodFill
  {$EXTERNALSYM RC_FLOODFILL}
  RC_STRETCHDIB   = $2000; // supports StretchDIBits
  {$EXTERNALSYM RC_STRETCHDIB}
  RC_OP_DX_OUTPUT = $4000;
  {$EXTERNALSYM RC_OP_DX_OUTPUT}
  RC_DEVBITS      = $8000;
  {$EXTERNALSYM RC_DEVBITS}

// Shading and blending caps

  SB_NONE          = $00000000;
  {$EXTERNALSYM SB_NONE}
  SB_CONST_ALPHA   = $00000001;
  {$EXTERNALSYM SB_CONST_ALPHA}
  SB_PIXEL_ALPHA   = $00000002;
  {$EXTERNALSYM SB_PIXEL_ALPHA}
  SB_PREMULT_ALPHA = $00000004;
  {$EXTERNALSYM SB_PREMULT_ALPHA}

  SB_GRAD_RECT = $00000010;
  {$EXTERNALSYM SB_GRAD_RECT}
  SB_GRAD_TRI  = $00000020;
  {$EXTERNALSYM SB_GRAD_TRI}

// Color Management caps

  CM_NONE       = $00000000;
  {$EXTERNALSYM CM_NONE}
  CM_DEVICE_ICM = $00000001;
  {$EXTERNALSYM CM_DEVICE_ICM}
  CM_GAMMA_RAMP = $00000002;
  {$EXTERNALSYM CM_GAMMA_RAMP}
  CM_CMYK_COLOR = $00000004;
  {$EXTERNALSYM CM_CMYK_COLOR}

// DIB color table identifiers

  DIB_RGB_COLORS = 0; // color table in RGBs
  {$EXTERNALSYM DIB_RGB_COLORS}
  DIB_PAL_COLORS = 1; // color table in palette indices
  {$EXTERNALSYM DIB_PAL_COLORS}

// constants for Get/SetSystemPaletteUse()

  SYSPAL_ERROR       = 0;
  {$EXTERNALSYM SYSPAL_ERROR}
  SYSPAL_STATIC      = 1;
  {$EXTERNALSYM SYSPAL_STATIC}
  SYSPAL_NOSTATIC    = 2;
  {$EXTERNALSYM SYSPAL_NOSTATIC}
  SYSPAL_NOSTATIC256 = 3;
  {$EXTERNALSYM SYSPAL_NOSTATIC256}

// constants for CreateDIBitmap

  CBM_INIT = $04; // initialize bitmap
  {$EXTERNALSYM CBM_INIT}

// ExtFloodFill style flags

  FLOODFILLBORDER  = 0;
  {$EXTERNALSYM FLOODFILLBORDER}
  FLOODFILLSURFACE = 1;
  {$EXTERNALSYM FLOODFILLSURFACE}

// size of a device name string

  CCHDEVICENAME = 32;
  {$EXTERNALSYM CCHDEVICENAME}

// size of a form name string

  CCHFORMNAME = 32;
  {$EXTERNALSYM CCHFORMNAME}

{$IFDEF WIN98ME}
{$IFNDEF WINNT4}
{$DEFINE WIN98ME_UP_EXCEPT_NT4}
{$ENDIF !WINNT4}
{$ENDIF WIN98ME}

type
  TDmDisplayFlagsUnion = record
    case Integer of
      0: (
        dmDisplayFlags: DWORD);
      1: (
        dmNup: DWORD);
  end;

  _devicemodeA = record
    dmDeviceName: array [0..CCHDEVICENAME - 1] of BYTE;
    dmSpecVersion: WORD;
    dmDriverVersion: WORD;
    dmSize: WORD;
    dmDriverExtra: WORD;
    dmFields: DWORD;
    union1: record
    case Integer of
      // printer only fields
      0: (
        dmOrientation: Smallint;
        dmPaperSize: Smallint;
        dmPaperLength: Smallint;
        dmPaperWidth: Smallint;
        dmScale: Smallint;
        dmCopies: Smallint;
        dmDefaultSource: Smallint;
        dmPrintQuality: Smallint);
      // display only fields
      1: (
        dmPosition: POINTL;
        dmDisplayOrientation: DWORD;
        dmDisplayFixedOutput: DWORD);
    end;
    dmColor: Shortint;
    dmDuplex: Shortint;
    dmYResolution: Shortint;
    dmTTOption: Shortint;
    dmCollate: Shortint;
    dmFormName: array [0..CCHFORMNAME - 1] of BYTE;
    dmLogPixels: WORD;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: TDmDisplayFlagsUnion;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmReserved1: DWORD;
    dmReserved2: DWORD;
    {$IFDEF WIN98ME_UP_EXCEPT_NT4}
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
    {$ENDIF WIN98ME_UP_EXCEPT_NT4}
  end;
  {$EXTERNALSYM _devicemodeA}
  DEVMODEA = _devicemodeA;
  {$EXTERNALSYM DEVMODEA}
  PDEVMODEA = ^DEVMODEA;
  {$EXTERNALSYM PDEVMODEA}
  LPDEVMODEA = ^DEVMODEA;
  {$EXTERNALSYM LPDEVMODEA}
  NPDEVMODEA = ^DEVMODEA;
  {$EXTERNALSYM NPDEVMODEA}
  TDevModeA = _devicemodeA;

  _devicemodeW = record
    dmDeviceName: array [0..CCHDEVICENAME - 1] of WCHAR;
    dmSpecVersion: WORD;
    dmDriverVersion: WORD;
    dmSize: WORD;
    dmDriverExtra: WORD;
    dmFields: DWORD;
    union1: record
    case Integer of
      // printer only fields
      0: (
        dmOrientation: Smallint;
        dmPaperSize: Smallint;
        dmPaperLength: Smallint;
        dmPaperWidth: Smallint;
        dmScale: Smallint;
        dmCopies: Smallint;
        dmDefaultSource: Smallint;
        dmPrintQuality: Smallint);
      // display only fields
      1: (
        dmPosition: POINTL;
        dmDisplayOrientation: DWORD;
        dmDisplayFixedOutput: DWORD);
    end;
    dmColor: Shortint;
    dmDuplex: Shortint;
    dmYResolution: Shortint;
    dmTTOption: Shortint;
    dmCollate: Shortint;
    dmFormName: array [0..CCHFORMNAME - 1] of WCHAR;
    dmLogPixels: WORD;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDiusplayFlags: TDmDisplayFlagsUnion;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmReserved1: DWORD;
    dmReserved2: DWORD;
    {$IFDEF WIN98ME_UP_EXCEPT_NT4}
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
    {$ENDIF WIN98ME_UP_EXCEPT_NT4}
  end;
  {$EXTERNALSYM _devicemodeW}
  DEVMODEW = _devicemodeW;
  {$EXTERNALSYM DEVMODEW}
  PDEVMODEW = ^DEVMODEW;
  {$EXTERNALSYM PDEVMODEW}
  LPDEVMODEW = ^DEVMODEW;
  {$EXTERNALSYM LPDEVMODEW}
  NPDEVMODEW = ^DEVMODEW;
  {$EXTERNALSYM NPDEVMODEW}
  TDevModeW = _devicemodeW;

  {$IFDEF UNICODE}
  DEVMODE = DEVMODEW;
  {$EXTERNALSYM DEVMODE}
  PDEVMODE = PDEVMODEW;
  {$EXTERNALSYM PDEVMODE}
  NPDEVMODE = NPDEVMODEW;
  {$EXTERNALSYM NPDEVMODE}
  LPDEVMODE = LPDEVMODEW;
  {$EXTERNALSYM LPDEVMODE}
  TDevMode = TDevModeW;
  {$ELSE}
  DEVMODE = DEVMODEA;
  {$EXTERNALSYM DEVMODE}
  PDEVMODE = PDEVMODEA;
  {$EXTERNALSYM PDEVMODE}
  NPDEVMODE = NPDEVMODEA;
  {$EXTERNALSYM NPDEVMODE}
  LPDEVMODE = LPDEVMODEA;
  {$EXTERNALSYM LPDEVMODE}
  TDevMode = TDevModeA;
  {$ENDIF UNICODE}

// current version of specification

const
  {$IFDEF WIN98ME_UP_EXCEPT_NT4}
  DM_SPECVERSION = $0401;
  {$EXTERNALSYM DM_SPECVERSION}
  {$ELSE}
  DM_SPECVERSION = $0400;
  {$EXTERNALSYM DM_SPECVERSION}
  {$ENDIF WIN98ME_UP_EXCEPT_NT4}

{$UNDEF WIN98ME_UP_EXCEPT_NT4}

// field selection bits

const
  DM_ORIENTATION      = $00000001;
  {$EXTERNALSYM DM_ORIENTATION}
  DM_PAPERSIZE        = $00000002;
  {$EXTERNALSYM DM_PAPERSIZE}
  DM_PAPERLENGTH      = $00000004;
  {$EXTERNALSYM DM_PAPERLENGTH}
  DM_PAPERWIDTH       = $00000008;
  {$EXTERNALSYM DM_PAPERWIDTH}
  DM_SCALE            = $00000010;
  {$EXTERNALSYM DM_SCALE}
  DM_POSITION         = $00000020;
  {$EXTERNALSYM DM_POSITION}
  DM_NUP              = $00000040;
  {$EXTERNALSYM DM_NUP}
//#if(WINVER >= 0x0501)
  DM_DISPLAYORIENTATION = $00000080;
  {$EXTERNALSYM DM_DISPLAYORIENTATION}
//#endif /* WINVER >= 0x0501 */
  DM_COPIES           = $00000100;
  {$EXTERNALSYM DM_COPIES}
  DM_DEFAULTSOURCE    = $00000200;
  {$EXTERNALSYM DM_DEFAULTSOURCE}
  DM_PRINTQUALITY     = $00000400;
  {$EXTERNALSYM DM_PRINTQUALITY}
  DM_COLOR            = $00000800;
  {$EXTERNALSYM DM_COLOR}
  DM_DUPLEX           = $00001000;
  {$EXTERNALSYM DM_DUPLEX}
  DM_YRESOLUTION      = $00002000;
  {$EXTERNALSYM DM_YRESOLUTION}
  DM_TTOPTION         = $00004000;
  {$EXTERNALSYM DM_TTOPTION}
  DM_COLLATE          = $00008000;
  {$EXTERNALSYM DM_COLLATE}
  DM_FORMNAME         = $00010000;
  {$EXTERNALSYM DM_FORMNAME}
  DM_LOGPIXELS        = $00020000;
  {$EXTERNALSYM DM_LOGPIXELS}
  DM_BITSPERPEL       = $00040000;
  {$EXTERNALSYM DM_BITSPERPEL}
  DM_PELSWIDTH        = $00080000;
  {$EXTERNALSYM DM_PELSWIDTH}
  DM_PELSHEIGHT       = $00100000;
  {$EXTERNALSYM DM_PELSHEIGHT}
  DM_DISPLAYFLAGS     = $00200000;
  {$EXTERNALSYM DM_DISPLAYFLAGS}
  DM_DISPLAYFREQUENCY = $00400000;
  {$EXTERNALSYM DM_DISPLAYFREQUENCY}
  DM_ICMMETHOD        = $00800000;
  {$EXTERNALSYM DM_ICMMETHOD}
  DM_ICMINTENT        = $01000000;
  {$EXTERNALSYM DM_ICMINTENT}
  DM_MEDIATYPE        = $02000000;
  {$EXTERNALSYM DM_MEDIATYPE}
  DM_DITHERTYPE       = $04000000;
  {$EXTERNALSYM DM_DITHERTYPE}
  DM_PANNINGWIDTH     = $08000000;
  {$EXTERNALSYM DM_PANNINGWIDTH}
  DM_PANNINGHEIGHT    = $10000000;
  {$EXTERNALSYM DM_PANNINGHEIGHT}
//#if(WINVER >= 0x0501)
  DM_DISPLAYFIXEDOUTPUT = $20000000;
  {$EXTERNALSYM DM_DISPLAYFIXEDOUTPUT}
//#endif /* WINVER >= 0x0501 */

// orientation selections

  DMORIENT_PORTRAIT  = 1;
  {$EXTERNALSYM DMORIENT_PORTRAIT}
  DMORIENT_LANDSCAPE = 2;
  {$EXTERNALSYM DMORIENT_LANDSCAPE}

// paper selections

  DMPAPER_LETTER                  = 1; // Letter 8 1/2 x 11 in
  {$EXTERNALSYM DMPAPER_LETTER}
  DMPAPER_FIRST                   = DMPAPER_LETTER;
  {$EXTERNALSYM DMPAPER_FIRST}
  DMPAPER_LETTERSMALL             = 2; // Letter Small 8 1/2 x 11 in
  {$EXTERNALSYM DMPAPER_LETTERSMALL}
  DMPAPER_TABLOID                 = 3; // Tabloid 11 x 17 in
  {$EXTERNALSYM DMPAPER_TABLOID}
  DMPAPER_LEDGER                  = 4; // Ledger 17 x 11 in
  {$EXTERNALSYM DMPAPER_LEDGER}
  DMPAPER_LEGAL                   = 5; // Legal 8 1/2 x 14 in
  {$EXTERNALSYM DMPAPER_LEGAL}
  DMPAPER_STATEMENT               = 6; // Statement 5 1/2 x 8 1/2 in
  {$EXTERNALSYM DMPAPER_STATEMENT}
  DMPAPER_EXECUTIVE               = 7; // Executive 7 1/4 x 10 1/2 in
  {$EXTERNALSYM DMPAPER_EXECUTIVE}
  DMPAPER_A3                      = 8; // A3 297 x 420 mm
  {$EXTERNALSYM DMPAPER_A3}
  DMPAPER_A4                      = 9; // A4 210 x 297 mm
  {$EXTERNALSYM DMPAPER_A4}
  DMPAPER_A4SMALL                 = 10; // A4 Small 210 x 297 mm
  {$EXTERNALSYM DMPAPER_A4SMALL}
  DMPAPER_A5                      = 11; // A5 148 x 210 mm
  {$EXTERNALSYM DMPAPER_A5}
  DMPAPER_B4                      = 12; // B4 (JIS) 250 x 354
  {$EXTERNALSYM DMPAPER_B4}
  DMPAPER_B5                      = 13; // B5 (JIS) 182 x 257 mm
  {$EXTERNALSYM DMPAPER_B5}
  DMPAPER_FOLIO                   = 14; // Folio 8 1/2 x 13 in
  {$EXTERNALSYM DMPAPER_FOLIO}
  DMPAPER_QUARTO                  = 15; // Quarto 215 x 275 mm
  {$EXTERNALSYM DMPAPER_QUARTO}
  DMPAPER_10X14                   = 16; // 10x14 in
  {$EXTERNALSYM DMPAPER_10X14}
  DMPAPER_11X17                   = 17; // 11x17 in
  {$EXTERNALSYM DMPAPER_11X17}
  DMPAPER_NOTE                    = 18; // Note 8 1/2 x 11 in
  {$EXTERNALSYM DMPAPER_NOTE}
  DMPAPER_ENV_9                   = 19; // Envelope #9 3 7/8 x 8 7/8
  {$EXTERNALSYM DMPAPER_ENV_9}
  DMPAPER_ENV_10                  = 20; // Envelope #10 4 1/8 x 9 1/2
  {$EXTERNALSYM DMPAPER_ENV_10}
  DMPAPER_ENV_11                  = 21; // Envelope #11 4 1/2 x 10 3/8
  {$EXTERNALSYM DMPAPER_ENV_11}
  DMPAPER_ENV_12                  = 22; // Envelope #12 4 \276 x 11
  {$EXTERNALSYM DMPAPER_ENV_12}
  DMPAPER_ENV_14                  = 23; // Envelope #14 5 x 11 1/2
  {$EXTERNALSYM DMPAPER_ENV_14}
  DMPAPER_CSHEET                  = 24; // C size sheet
  {$EXTERNALSYM DMPAPER_CSHEET}
  DMPAPER_DSHEET                  = 25; // D size sheet
  {$EXTERNALSYM DMPAPER_DSHEET}
  DMPAPER_ESHEET                  = 26; // E size sheet
  {$EXTERNALSYM DMPAPER_ESHEET}
  DMPAPER_ENV_DL                  = 27; // Envelope DL 110 x 220mm
  {$EXTERNALSYM DMPAPER_ENV_DL}
  DMPAPER_ENV_C5                  = 28; // Envelope C5 162 x 229 mm
  {$EXTERNALSYM DMPAPER_ENV_C5}
  DMPAPER_ENV_C3                  = 29; // Envelope C3  324 x 458 mm
  {$EXTERNALSYM DMPAPER_ENV_C3}
  DMPAPER_ENV_C4                  = 30; // Envelope C4  229 x 324 mm
  {$EXTERNALSYM DMPAPER_ENV_C4}
  DMPAPER_ENV_C6                  = 31; // Envelope C6  114 x 162 mm
  {$EXTERNALSYM DMPAPER_ENV_C6}
  DMPAPER_ENV_C65                 = 32; // Envelope C65 114 x 229 mm
  {$EXTERNALSYM DMPAPER_ENV_C65}
  DMPAPER_ENV_B4                  = 33; // Envelope B4  250 x 353 mm
  {$EXTERNALSYM DMPAPER_ENV_B4}
  DMPAPER_ENV_B5                  = 34; // Envelope B5  176 x 250 mm
  {$EXTERNALSYM DMPAPER_ENV_B5}
  DMPAPER_ENV_B6                  = 35; // Envelope B6  176 x 125 mm
  {$EXTERNALSYM DMPAPER_ENV_B6}
  DMPAPER_ENV_ITALY               = 36; // Envelope 110 x 230 mm
  {$EXTERNALSYM DMPAPER_ENV_ITALY}
  DMPAPER_ENV_MONARCH             = 37; // Envelope Monarch 3.875 x 7.5 in
  {$EXTERNALSYM DMPAPER_ENV_MONARCH}
  DMPAPER_ENV_PERSONAL            = 38; // 6 3/4 Envelope 3 5/8 x 6 1/2 in
  {$EXTERNALSYM DMPAPER_ENV_PERSONAL}
  DMPAPER_FANFOLD_US              = 39; // US Std Fanfold 14 7/8 x 11 in
  {$EXTERNALSYM DMPAPER_FANFOLD_US}
  DMPAPER_FANFOLD_STD_GERMAN      = 40; // German Std Fanfold 8 1/2 x 12 in
  {$EXTERNALSYM DMPAPER_FANFOLD_STD_GERMAN}
  DMPAPER_FANFOLD_LGL_GERMAN      = 41; // German Legal Fanfold 8 1/2 x 13 in
  {$EXTERNALSYM DMPAPER_FANFOLD_LGL_GERMAN}
  DMPAPER_ISO_B4                  = 42; // B4 (ISO) 250 x 353 mm
  {$EXTERNALSYM DMPAPER_ISO_B4}
  DMPAPER_JAPANESE_POSTCARD       = 43; // Japanese Postcard 100 x 148 mm
  {$EXTERNALSYM DMPAPER_JAPANESE_POSTCARD}
  DMPAPER_9X11                    = 44; // 9 x 11 in
  {$EXTERNALSYM DMPAPER_9X11}
  DMPAPER_10X11                   = 45; // 10 x 11 in
  {$EXTERNALSYM DMPAPER_10X11}
  DMPAPER_15X11                   = 46; // 15 x 11 in
  {$EXTERNALSYM DMPAPER_15X11}
  DMPAPER_ENV_INVITE              = 47; // Envelope Invite 220 x 220 mm
  {$EXTERNALSYM DMPAPER_ENV_INVITE}
  DMPAPER_RESERVED_48             = 48; // RESERVED--DO NOT USE
  {$EXTERNALSYM DMPAPER_RESERVED_48}
  DMPAPER_RESERVED_49             = 49; // RESERVED--DO NOT USE
  {$EXTERNALSYM DMPAPER_RESERVED_49}
  DMPAPER_LETTER_EXTRA            = 50; // Letter Extra 9 \275 x 12 in
  {$EXTERNALSYM DMPAPER_LETTER_EXTRA}
  DMPAPER_LEGAL_EXTRA             = 51; // Legal Extra 9 \275 x 15 in
  {$EXTERNALSYM DMPAPER_LEGAL_EXTRA}
  DMPAPER_TABLOID_EXTRA           = 52; // Tabloid Extra 11.69 x 18 in
  {$EXTERNALSYM DMPAPER_TABLOID_EXTRA}
  DMPAPER_A4_EXTRA                = 53; // A4 Extra 9.27 x 12.69 in
  {$EXTERNALSYM DMPAPER_A4_EXTRA}
  DMPAPER_LETTER_TRANSVERSE       = 54; // Letter Transverse 8 \275 x 11 in
  {$EXTERNALSYM DMPAPER_LETTER_TRANSVERSE}
  DMPAPER_A4_TRANSVERSE           = 55; // A4 Transverse 210 x 297 mm
  {$EXTERNALSYM DMPAPER_A4_TRANSVERSE}
  DMPAPER_LETTER_EXTRA_TRANSVERSE = 56; // Letter Extra Transverse 9\275 x 12 in
  {$EXTERNALSYM DMPAPER_LETTER_EXTRA_TRANSVERSE}
  DMPAPER_A_PLUS                  = 57; // SuperA/SuperA/A4 227 x 356 mm
  {$EXTERNALSYM DMPAPER_A_PLUS}
  DMPAPER_B_PLUS                  = 58; // SuperB/SuperB/A3 305 x 487 mm
  {$EXTERNALSYM DMPAPER_B_PLUS}
  DMPAPER_LETTER_PLUS             = 59; // Letter Plus 8.5 x 12.69 in
  {$EXTERNALSYM DMPAPER_LETTER_PLUS}
  DMPAPER_A4_PLUS                 = 60; // A4 Plus 210 x 330 mm
  {$EXTERNALSYM DMPAPER_A4_PLUS}
  DMPAPER_A5_TRANSVERSE           = 61; // A5 Transverse 148 x 210 mm
  {$EXTERNALSYM DMPAPER_A5_TRANSVERSE}
  DMPAPER_B5_TRANSVERSE           = 62; // B5 (JIS) Transverse 182 x 257 mm
  {$EXTERNALSYM DMPAPER_B5_TRANSVERSE}
  DMPAPER_A3_EXTRA                = 63; // A3 Extra 322 x 445 mm
  {$EXTERNALSYM DMPAPER_A3_EXTRA}
  DMPAPER_A5_EXTRA                = 64; // A5 Extra 174 x 235 mm
  {$EXTERNALSYM DMPAPER_A5_EXTRA}
  DMPAPER_B5_EXTRA                = 65; // B5 (ISO) Extra 201 x 276 mm
  {$EXTERNALSYM DMPAPER_B5_EXTRA}
  DMPAPER_A2                      = 66; // A2 420 x 594 mm
  {$EXTERNALSYM DMPAPER_A2}
  DMPAPER_A3_TRANSVERSE           = 67; // A3 Transverse 297 x 420 mm
  {$EXTERNALSYM DMPAPER_A3_TRANSVERSE}
  DMPAPER_A3_EXTRA_TRANSVERSE     = 68; // A3 Extra Transverse 322 x 445 mm
  {$EXTERNALSYM DMPAPER_A3_EXTRA_TRANSVERSE}

  DMPAPER_DBL_JAPANESE_POSTCARD         = 69; // Japanese Double Postcard 200 x 148 mm
  {$EXTERNALSYM DMPAPER_DBL_JAPANESE_POSTCARD}
  DMPAPER_A6                            = 70; // A6 105 x 148 mm
  {$EXTERNALSYM DMPAPER_A6}
  DMPAPER_JENV_KAKU2                    = 71; // Japanese Envelope Kaku #2
  {$EXTERNALSYM DMPAPER_JENV_KAKU2}
  DMPAPER_JENV_KAKU3                    = 72; // Japanese Envelope Kaku #3
  {$EXTERNALSYM DMPAPER_JENV_KAKU3}
  DMPAPER_JENV_CHOU3                    = 73; // Japanese Envelope Chou #3
  {$EXTERNALSYM DMPAPER_JENV_CHOU3}
  DMPAPER_JENV_CHOU4                    = 74; // Japanese Envelope Chou #4
  {$EXTERNALSYM DMPAPER_JENV_CHOU4}
  DMPAPER_LETTER_ROTATED                = 75; // Letter Rotated 11 x 8 1/2 11 in
  {$EXTERNALSYM DMPAPER_LETTER_ROTATED}
  DMPAPER_A3_ROTATED                    = 76; // A3 Rotated 420 x 297 mm
  {$EXTERNALSYM DMPAPER_A3_ROTATED}
  DMPAPER_A4_ROTATED                    = 77; // A4 Rotated 297 x 210 mm
  {$EXTERNALSYM DMPAPER_A4_ROTATED}
  DMPAPER_A5_ROTATED                    = 78; // A5 Rotated 210 x 148 mm
  {$EXTERNALSYM DMPAPER_A5_ROTATED}
  DMPAPER_B4_JIS_ROTATED                = 79; // B4 (JIS) Rotated 364 x 257 mm
  {$EXTERNALSYM DMPAPER_B4_JIS_ROTATED}
  DMPAPER_B5_JIS_ROTATED                = 80; // B5 (JIS) Rotated 257 x 182 mm
  {$EXTERNALSYM DMPAPER_B5_JIS_ROTATED}
  DMPAPER_JAPANESE_POSTCARD_ROTATED     = 81; // Japanese Postcard Rotated 148 x 100 mm
  {$EXTERNALSYM DMPAPER_JAPANESE_POSTCARD_ROTATED}
  DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED = 82; // Double Japanese Postcard Rotated 148 x 200 mm
  {$EXTERNALSYM DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED}
  DMPAPER_A6_ROTATED                    = 83; // A6 Rotated 148 x 105 mm
  {$EXTERNALSYM DMPAPER_A6_ROTATED}
  DMPAPER_JENV_KAKU2_ROTATED            = 84; // Japanese Envelope Kaku #2 Rotated
  {$EXTERNALSYM DMPAPER_JENV_KAKU2_ROTATED}
  DMPAPER_JENV_KAKU3_ROTATED            = 85; // Japanese Envelope Kaku #3 Rotated
  {$EXTERNALSYM DMPAPER_JENV_KAKU3_ROTATED}
  DMPAPER_JENV_CHOU3_ROTATED            = 86; // Japanese Envelope Chou #3 Rotated
  {$EXTERNALSYM DMPAPER_JENV_CHOU3_ROTATED}
  DMPAPER_JENV_CHOU4_ROTATED            = 87; // Japanese Envelope Chou #4 Rotated
  {$EXTERNALSYM DMPAPER_JENV_CHOU4_ROTATED}
  DMPAPER_B6_JIS                        = 88; // B6 (JIS) 128 x 182 mm
  {$EXTERNALSYM DMPAPER_B6_JIS}
  DMPAPER_B6_JIS_ROTATED                = 89; // B6 (JIS) Rotated 182 x 128 mm
  {$EXTERNALSYM DMPAPER_B6_JIS_ROTATED}
  DMPAPER_12X11                         = 90; // 12 x 11 in
  {$EXTERNALSYM DMPAPER_12X11}
  DMPAPER_JENV_YOU4                     = 91; // Japanese Envelope You #4
  {$EXTERNALSYM DMPAPER_JENV_YOU4}
  DMPAPER_JENV_YOU4_ROTATED             = 92; // Japanese Envelope You #4 Rotated
  {$EXTERNALSYM DMPAPER_JENV_YOU4_ROTATED}
  DMPAPER_P16K                          = 93; // PRC 16K 146 x 215 mm
  {$EXTERNALSYM DMPAPER_P16K}
  DMPAPER_P32K                          = 94; // PRC 32K 97 x 151 mm
  {$EXTERNALSYM DMPAPER_P32K}
  DMPAPER_P32KBIG                       = 95; // PRC 32K(Big) 97 x 151 mm
  {$EXTERNALSYM DMPAPER_P32KBIG}
  DMPAPER_PENV_1                        = 96; // PRC Envelope #1 102 x 165 mm
  {$EXTERNALSYM DMPAPER_PENV_1}
  DMPAPER_PENV_2                        = 97; // PRC Envelope #2 102 x 176 mm
  {$EXTERNALSYM DMPAPER_PENV_2}
  DMPAPER_PENV_3                        = 98; // PRC Envelope #3 125 x 176 mm
  {$EXTERNALSYM DMPAPER_PENV_3}
  DMPAPER_PENV_4                        = 99; // PRC Envelope #4 110 x 208 mm
  {$EXTERNALSYM DMPAPER_PENV_4}
  DMPAPER_PENV_5                        = 100; // PRC Envelope #5 110 x 220 mm
  {$EXTERNALSYM DMPAPER_PENV_5}
  DMPAPER_PENV_6                        = 101; // PRC Envelope #6 120 x 230 mm
  {$EXTERNALSYM DMPAPER_PENV_6}
  DMPAPER_PENV_7                        = 102; // PRC Envelope #7 160 x 230 mm
  {$EXTERNALSYM DMPAPER_PENV_7}
  DMPAPER_PENV_8                        = 103; // PRC Envelope #8 120 x 309 mm
  {$EXTERNALSYM DMPAPER_PENV_8}
  DMPAPER_PENV_9                        = 104; // PRC Envelope #9 229 x 324 mm
  {$EXTERNALSYM DMPAPER_PENV_9}
  DMPAPER_PENV_10                       = 105; // PRC Envelope #10 324 x 458 mm
  {$EXTERNALSYM DMPAPER_PENV_10}
  DMPAPER_P16K_ROTATED                  = 106; // PRC 16K Rotated
  {$EXTERNALSYM DMPAPER_P16K_ROTATED}
  DMPAPER_P32K_ROTATED                  = 107; // PRC 32K Rotated
  {$EXTERNALSYM DMPAPER_P32K_ROTATED}
  DMPAPER_P32KBIG_ROTATED               = 108; // PRC 32K(Big) Rotated
  {$EXTERNALSYM DMPAPER_P32KBIG_ROTATED}
  DMPAPER_PENV_1_ROTATED                = 109; // PRC Envelope #1 Rotated 165 x 102 mm
  {$EXTERNALSYM DMPAPER_PENV_1_ROTATED}
  DMPAPER_PENV_2_ROTATED                = 110; // PRC Envelope #2 Rotated 176 x 102 mm
  {$EXTERNALSYM DMPAPER_PENV_2_ROTATED}
  DMPAPER_PENV_3_ROTATED                = 111; // PRC Envelope #3 Rotated 176 x 125 mm
  {$EXTERNALSYM DMPAPER_PENV_3_ROTATED}
  DMPAPER_PENV_4_ROTATED                = 112; // PRC Envelope #4 Rotated 208 x 110 mm
  {$EXTERNALSYM DMPAPER_PENV_4_ROTATED}
  DMPAPER_PENV_5_ROTATED                = 113; // PRC Envelope #5 Rotated 220 x 110 mm
  {$EXTERNALSYM DMPAPER_PENV_5_ROTATED}
  DMPAPER_PENV_6_ROTATED                = 114; // PRC Envelope #6 Rotated 230 x 120 mm
  {$EXTERNALSYM DMPAPER_PENV_6_ROTATED}
  DMPAPER_PENV_7_ROTATED                = 115; // PRC Envelope #7 Rotated 230 x 160 mm
  {$EXTERNALSYM DMPAPER_PENV_7_ROTATED}
  DMPAPER_PENV_8_ROTATED                = 116; // PRC Envelope #8 Rotated 309 x 120 mm
  {$EXTERNALSYM DMPAPER_PENV_8_ROTATED}
  DMPAPER_PENV_9_ROTATED                = 117; // PRC Envelope #9 Rotated 324 x 229 mm
  {$EXTERNALSYM DMPAPER_PENV_9_ROTATED}
  DMPAPER_PENV_10_ROTATED               = 118; // PRC Envelope #10 Rotated 458 x 324 mm
  {$EXTERNALSYM DMPAPER_PENV_10_ROTATED}

  {$IFDEF WIN98ME_UP}
  DMPAPER_LAST = DMPAPER_PENV_10_ROTATED;
  {$EXTERNALSYM DMPAPER_LAST}
  {$ELSE}
  DMPAPER_LAST = DMPAPER_A3_EXTRA_TRANSVERSE;
  {$EXTERNALSYM DMPAPER_LAST}
  {$ENDIF WIN98ME_UP}

  DMPAPER_USER = 256;
  {$EXTERNALSYM DMPAPER_USER}

// bin selections

  DMBIN_UPPER         = 1;
  {$EXTERNALSYM DMBIN_UPPER}
  DMBIN_FIRST         = DMBIN_UPPER;
  {$EXTERNALSYM DMBIN_FIRST}
  DMBIN_ONLYONE       = 1;
  {$EXTERNALSYM DMBIN_ONLYONE}
  DMBIN_LOWER         = 2;
  {$EXTERNALSYM DMBIN_LOWER}
  DMBIN_MIDDLE        = 3;
  {$EXTERNALSYM DMBIN_MIDDLE}
  DMBIN_MANUAL        = 4;
  {$EXTERNALSYM DMBIN_MANUAL}
  DMBIN_ENVELOPE      = 5;
  {$EXTERNALSYM DMBIN_ENVELOPE}
  DMBIN_ENVMANUAL     = 6;
  {$EXTERNALSYM DMBIN_ENVMANUAL}
  DMBIN_AUTO          = 7;
  {$EXTERNALSYM DMBIN_AUTO}
  DMBIN_TRACTOR       = 8;
  {$EXTERNALSYM DMBIN_TRACTOR}
  DMBIN_SMALLFMT      = 9;
  {$EXTERNALSYM DMBIN_SMALLFMT}
  DMBIN_LARGEFMT      = 10;
  {$EXTERNALSYM DMBIN_LARGEFMT}
  DMBIN_LARGECAPACITY = 11;
  {$EXTERNALSYM DMBIN_LARGECAPACITY}
  DMBIN_CASSETTE      = 14;
  {$EXTERNALSYM DMBIN_CASSETTE}
  DMBIN_FORMSOURCE    = 15;
  {$EXTERNALSYM DMBIN_FORMSOURCE}
  DMBIN_LAST          = DMBIN_FORMSOURCE;
  {$EXTERNALSYM DMBIN_LAST}

  DMBIN_USER = 256; // device specific bins start here
  {$EXTERNALSYM DMBIN_USER}

// print qualities

  DMRES_DRAFT  = DWORD(-1);
  {$EXTERNALSYM DMRES_DRAFT}
  DMRES_LOW    = DWORD(-2);
  {$EXTERNALSYM DMRES_LOW}
  DMRES_MEDIUM = DWORD(-3);
  {$EXTERNALSYM DMRES_MEDIUM}
  DMRES_HIGH   = DWORD(-4);
  {$EXTERNALSYM DMRES_HIGH}

// color enable/disable for color printers

  DMCOLOR_MONOCHROME = 1;
  {$EXTERNALSYM DMCOLOR_MONOCHROME}
  DMCOLOR_COLOR      = 2;
  {$EXTERNALSYM DMCOLOR_COLOR}

// duplex enable

  DMDUP_SIMPLEX    = 1;
  {$EXTERNALSYM DMDUP_SIMPLEX}
  DMDUP_VERTICAL   = 2;
  {$EXTERNALSYM DMDUP_VERTICAL}
  DMDUP_HORIZONTAL = 3;
  {$EXTERNALSYM DMDUP_HORIZONTAL}

// TrueType options

  DMTT_BITMAP           = 1; // print TT fonts as graphics
  {$EXTERNALSYM DMTT_BITMAP}
  DMTT_DOWNLOAD         = 2; // download TT fonts as soft fonts
  {$EXTERNALSYM DMTT_DOWNLOAD}
  DMTT_SUBDEV           = 3; // substitute device fonts for TT fonts
  {$EXTERNALSYM DMTT_SUBDEV}
  DMTT_DOWNLOAD_OUTLINE = 4; // download TT fonts as outline soft fonts
  {$EXTERNALSYM DMTT_DOWNLOAD_OUTLINE}

// Collation selections

  DMCOLLATE_FALSE = 0;
  {$EXTERNALSYM DMCOLLATE_FALSE}
  DMCOLLATE_TRUE  = 1;
  {$EXTERNALSYM DMCOLLATE_TRUE}

//#if(WINVER >= 0x0501)

// DEVMODE dmDisplayOrientation specifiations

  DMDO_DEFAULT   = 0;
  {$EXTERNALSYM DMDO_DEFAULT}
  DMDO_90        = 1;
  {$EXTERNALSYM DMDO_90}
  DMDO_180       = 2;
  {$EXTERNALSYM DMDO_180}
  DMDO_270       = 3;
  {$EXTERNALSYM DMDO_270}

// DEVMODE dmDisplayFixedOutput specifiations

  DMDFO_DEFAULT  = 0;
  {$EXTERNALSYM DMDFO_DEFAULT}
  DMDFO_STRETCH  = 1;
  {$EXTERNALSYM DMDFO_STRETCH}
  DMDFO_CENTER   = 2;
  {$EXTERNALSYM DMDFO_CENTER}

//#endif /* WINVER >= 0x0501 */

// DEVMODE dmDisplayFlags flags

// #define DM_GRAYSCALE            0x00000001 /* This flag is no longer valid */
// #define DM_INTERLACED           0x00000002 /* This flag is no longer valid */

  DMDISPLAYFLAGS_TEXTMODE = $00000004;
  {$EXTERNALSYM DMDISPLAYFLAGS_TEXTMODE}

// dmNup , multiple logical page per physical page options

  DMNUP_SYSTEM = 1;
  {$EXTERNALSYM DMNUP_SYSTEM}
  DMNUP_ONEUP  = 2;
  {$EXTERNALSYM DMNUP_ONEUP}

// ICM methods

  DMICMMETHOD_NONE   = 1; // ICM disabled
  {$EXTERNALSYM DMICMMETHOD_NONE}
  DMICMMETHOD_SYSTEM = 2; // ICM handled by system
  {$EXTERNALSYM DMICMMETHOD_SYSTEM}
  DMICMMETHOD_DRIVER = 3; // ICM handled by driver
  {$EXTERNALSYM DMICMMETHOD_DRIVER}
  DMICMMETHOD_DEVICE = 4; // ICM handled by device
  {$EXTERNALSYM DMICMMETHOD_DEVICE}

  DMICMMETHOD_USER = 256; // Device-specific methods start here
  {$EXTERNALSYM DMICMMETHOD_USER}

// ICM Intents

  DMICM_SATURATE         = 1; // Maximize color saturation
  {$EXTERNALSYM DMICM_SATURATE}
  DMICM_CONTRAST         = 2; // Maximize color contrast
  {$EXTERNALSYM DMICM_CONTRAST}
  DMICM_COLORIMETRIC     = 3; // Use specific color metric
  {$EXTERNALSYM DMICM_COLORIMETRIC}
  DMICM_ABS_COLORIMETRIC = 4; // Use specific color metric
  {$EXTERNALSYM DMICM_ABS_COLORIMETRIC}

  DMICM_USER = 256; // Device-specific intents start here
  {$EXTERNALSYM DMICM_USER}

// Media types

  DMMEDIA_STANDARD     = 1; // Standard paper
  {$EXTERNALSYM DMMEDIA_STANDARD}
  DMMEDIA_TRANSPARENCY = 2; // Transparency
  {$EXTERNALSYM DMMEDIA_TRANSPARENCY}
  DMMEDIA_GLOSSY       = 3; // Glossy paper
  {$EXTERNALSYM DMMEDIA_GLOSSY}

  DMMEDIA_USER = 256; // Device-specific media start here
  {$EXTERNALSYM DMMEDIA_USER}

// Dither types

  DMDITHER_NONE           = 1; // No dithering
  {$EXTERNALSYM DMDITHER_NONE}
  DMDITHER_COARSE         = 2; // Dither with a coarse brush
  {$EXTERNALSYM DMDITHER_COARSE}
  DMDITHER_FINE           = 3; // Dither with a fine brush
  {$EXTERNALSYM DMDITHER_FINE}
  DMDITHER_LINEART        = 4; // LineArt dithering
  {$EXTERNALSYM DMDITHER_LINEART}
  DMDITHER_ERRORDIFFUSION = 5; // LineArt dithering
  {$EXTERNALSYM DMDITHER_ERRORDIFFUSION}
  DMDITHER_RESERVED6      = 6; // LineArt dithering
  {$EXTERNALSYM DMDITHER_RESERVED6}
  DMDITHER_RESERVED7      = 7; // LineArt dithering
  {$EXTERNALSYM DMDITHER_RESERVED7}
  DMDITHER_RESERVED8      = 8; // LineArt dithering
  {$EXTERNALSYM DMDITHER_RESERVED8}
  DMDITHER_RESERVED9      = 9; // LineArt dithering
  {$EXTERNALSYM DMDITHER_RESERVED9}
  DMDITHER_GRAYSCALE      = 10; // Device does grayscaling
  {$EXTERNALSYM DMDITHER_GRAYSCALE}

  DMDITHER_USER = 256; // Device-specific dithers start here
  {$EXTERNALSYM DMDITHER_USER}

type
  PDisplayDeviceA = ^TDisplayDeviceA;
  _DISPLAY_DEVICEA = record
    cb: DWORD;
    DeviceName: array [0..32 - 1] of CHAR;
    DeviceString: array [0..128 - 1] of CHAR;
    StateFlags: DWORD;
    DeviceID: array [0..128 - 1] of CHAR;
    DeviceKey: array [0..128 - 1] of CHAR;
  end;
  {$EXTERNALSYM _DISPLAY_DEVICEA}
  DISPLAY_DEVICEA = _DISPLAY_DEVICEA;
  {$EXTERNALSYM DISPLAY_DEVICEA}
  LPDISPLAY_DEVICEA = ^DISPLAY_DEVICEA;
  {$EXTERNALSYM LPDISPLAY_DEVICEA}
  PDISPLAY_DEVICEA = ^DISPLAY_DEVICEA;
  {$EXTERNALSYM PDISPLAY_DEVICEA}
  TDisplayDeviceA = _DISPLAY_DEVICEA;

  PDisplayDeviceW = ^TDisplayDeviceW;
  _DISPLAY_DEVICEW = record
    cb: DWORD;
    DeviceName: array [0..32 - 1] of WCHAR;
    DeviceString: array [0..128 - 1] of WCHAR;
    StateFlags: DWORD;
    DeviceID: array [0..128 - 1] of WCHAR;
    DeviceKey: array [0..128 - 1] of WCHAR;
  end;
  {$EXTERNALSYM _DISPLAY_DEVICEW}
  DISPLAY_DEVICEW = _DISPLAY_DEVICEW;
  {$EXTERNALSYM DISPLAY_DEVICEW}
  LPDISPLAY_DEVICEW = ^DISPLAY_DEVICEW;
  {$EXTERNALSYM LPDISPLAY_DEVICEW}
  PDISPLAY_DEVICEW = ^DISPLAY_DEVICEW;
  {$EXTERNALSYM PDISPLAY_DEVICEW}
  TDisplayDeviceW = _DISPLAY_DEVICEW;

  {$IFDEF UNICODE}
  DISPLAY_DEVICE = DISPLAY_DEVICEW;
  {$EXTERNALSYM DISPLAY_DEVICE}
  PDISPLAY_DEVICE = PDISPLAY_DEVICEW;
  {$EXTERNALSYM PDISPLAY_DEVICE}
  LPDISPLAY_DEVICE = LPDISPLAY_DEVICEW;
  {$EXTERNALSYM LPDISPLAY_DEVICE}
  TDisplayDevice = TDisplayDeviceW;
  PDisplayDevice = PDisplayDeviceW;
  {$ELSE}
  DISPLAY_DEVICE = DISPLAY_DEVICEA;
  {$EXTERNALSYM DISPLAY_DEVICE}
  PDISPLAY_DEVICE = PDISPLAY_DEVICEA;
  {$EXTERNALSYM PDISPLAY_DEVICE}
  LPDISPLAY_DEVICE = LPDISPLAY_DEVICEA;
  {$EXTERNALSYM LPDISPLAY_DEVICE}
  TDisplayDevice = TDisplayDeviceA;
  PDisplayDevice = PDisplayDeviceA;
  {$ENDIF UNICODE}

const
  DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = $00000001;
  {$EXTERNALSYM DISPLAY_DEVICE_ATTACHED_TO_DESKTOP}
  DISPLAY_DEVICE_MULTI_DRIVER        = $00000002;
  {$EXTERNALSYM DISPLAY_DEVICE_MULTI_DRIVER}
  DISPLAY_DEVICE_PRIMARY_DEVICE      = $00000004;
  {$EXTERNALSYM DISPLAY_DEVICE_PRIMARY_DEVICE}
  DISPLAY_DEVICE_MIRRORING_DRIVER    = $00000008;
  {$EXTERNALSYM DISPLAY_DEVICE_MIRRORING_DRIVER}
  DISPLAY_DEVICE_VGA_COMPATIBLE      = $00000010;
  {$EXTERNALSYM DISPLAY_DEVICE_VGA_COMPATIBLE}
  DISPLAY_DEVICE_REMOVABLE           = $00000020;
  {$EXTERNALSYM DISPLAY_DEVICE_REMOVABLE}
  DISPLAY_DEVICE_MODESPRUNED         = $08000000;
  {$EXTERNALSYM DISPLAY_DEVICE_MODESPRUNED}
  DISPLAY_DEVICE_REMOTE              = $04000000;
  {$EXTERNALSYM DISPLAY_DEVICE_REMOTE}
  DISPLAY_DEVICE_DISCONNECT          = $02000000;
  {$EXTERNALSYM DISPLAY_DEVICE_DISCONNECT}

// Child device state

  DISPLAY_DEVICE_ACTIVE              = $00000001;
  {$EXTERNALSYM DISPLAY_DEVICE_ACTIVE}
  DISPLAY_DEVICE_ATTACHED            = $00000002;
  {$EXTERNALSYM DISPLAY_DEVICE_ATTACHED}

// GetRegionData/ExtCreateRegion

  RDH_RECTANGLES = 1;
  {$EXTERNALSYM RDH_RECTANGLES}

type
  PRgnDataHeader = ^TRgnDataHeader;
  _RGNDATAHEADER = record
    dwSize: DWORD;
    iType: DWORD;
    nCount: DWORD;
    nRgnSize: DWORD;
    rcBound: RECT;
  end;
  {$EXTERNALSYM _RGNDATAHEADER}
  RGNDATAHEADER = _RGNDATAHEADER;
  {$EXTERNALSYM RGNDATAHEADER}
  TRgnDataHeader = _RGNDATAHEADER;

  PRgnData = ^TRgnData;
  _RGNDATA = record
    rdh: RGNDATAHEADER;
    Buffer: array [0..0] of Char;
  end;
  {$EXTERNALSYM _RGNDATA}
  RGNDATA = _RGNDATA;
  {$EXTERNALSYM RGNDATA}
  LPRGNDATA = ^RGNDATA;
  {$EXTERNALSYM LPRGNDATA}
  NPRGNDATA = ^RGNDATA;
  {$EXTERNALSYM NPRGNDATA}
  TRgnData = _RGNDATA;

// for GetRandomRgn

const
  SYSRGN = 4;
  {$EXTERNALSYM SYSRGN}

type
  PAbc = ^TAbc;
  _ABC = record
    abcA: Integer;
    abcB: UINT;
    abcC: Integer;
  end;
  {$EXTERNALSYM _ABC}
  ABC = _ABC;
  {$EXTERNALSYM ABC}
  LPABC = ^ABC;
  {$EXTERNALSYM LPABC}
  NPABC = ^ABC;
  {$EXTERNALSYM NPABC}
  TAbc = _ABC;

  PAbcFloat = ^TAbcFloat;
  _ABCFLOAT = record
    abcfA: FLOAT;
    abcfB: FLOAT;
    abcfC: FLOAT;
  end;
  {$EXTERNALSYM _ABCFLOAT}
  ABCFLOAT = _ABCFLOAT;
  {$EXTERNALSYM ABCFLOAT}
  LPABCFLOAT = ^ABCFLOAT;
  {$EXTERNALSYM LPABCFLOAT}
  NPABCFLOAT = ^ABCFLOAT;
  {$EXTERNALSYM NPABCFLOAT}
  TAbcFloat = _ABCFLOAT;

  POutlineTextMetricA = ^TOutlineTextMetricA;
  _OUTLINETEXTMETRICA = record
    otmSize: UINT;
    otmTextMetrics: TEXTMETRICA;
    otmFiller: BYTE;
    otmPanoseNumber: PANOSE;
    otmfsSelection: UINT;
    otmfsType: UINT;
    otmsCharSlopeRise: Integer;
    otmsCharSlopeRun: Integer;
    otmItalicAngle: Integer;
    otmEMSquare: UINT;
    otmAscent: Integer;
    otmDescent: Integer;
    otmLineGap: UINT;
    otmsCapEmHeight: UINT;
    otmsXHeight: UINT;
    otmrcFontBox: RECT;
    otmMacAscent: Integer;
    otmMacDescent: Integer;
    otmMacLineGap: UINT;
    otmusMinimumPPEM: UINT;
    otmptSubscriptSize: POINT;
    otmptSubscriptOffset: POINT;
    otmptSuperscriptSize: POINT;
    otmptSuperscriptOffset: POINT;
    otmsStrikeoutSize: UINT;
    otmsStrikeoutPosition: Integer;
    otmsUnderscoreSize: Integer;
    otmsUnderscorePosition: Integer;
    otmpFamilyName: PSTR;
    otmpFaceName: PSTR;
    otmpStyleName: PSTR;
    otmpFullName: PSTR;
  end;
  {$EXTERNALSYM _OUTLINETEXTMETRICA}
  OUTLINETEXTMETRICA = _OUTLINETEXTMETRICA;
  {$EXTERNALSYM OUTLINETEXTMETRICA}
  LPOUTLINETEXTMETRICA = ^OUTLINETEXTMETRICA;
  {$EXTERNALSYM LPOUTLINETEXTMETRICA}
  NPOUTLINETEXTMETRICA = ^OUTLINETEXTMETRICA;
  {$EXTERNALSYM NPOUTLINETEXTMETRICA}
  TOutlineTextMetricA = _OUTLINETEXTMETRICA;

  POutlineTextMetricW = ^TOutlineTextMetricW;
  _OUTLINETEXTMETRICW = record
    otmSize: UINT;
    otmTextMetrics: TEXTMETRICW;
    otmFiller: BYTE;
    otmPanoseNumber: PANOSE;
    otmfsSelection: UINT;
    otmfsType: UINT;
    otmsCharSlopeRise: Integer;
    otmsCharSlopeRun: Integer;
    otmItalicAngle: Integer;
    otmEMSquare: UINT;
    otmAscent: Integer;
    otmDescent: Integer;
    otmLineGap: UINT;
    otmsCapEmHeight: UINT;
    otmsXHeight: UINT;
    otmrcFontBox: RECT;
    otmMacAscent: Integer;
    otmMacDescent: Integer;
    otmMacLineGap: UINT;
    otmusMinimumPPEM: UINT;
    otmptSubscriptSize: POINT;
    otmptSubscriptOffset: POINT;
    otmptSuperscriptSize: POINT;
    otmptSuperscriptOffset: POINT;
    otmsStrikeoutSize: UINT;
    otmsStrikeoutPosition: Integer;
    otmsUnderscoreSize: Integer;
    otmsUnderscorePosition: Integer;
    otmpFamilyName: PSTR;
    otmpFaceName: PSTR;
    otmpStyleName: PSTR;
    otmpFullName: PSTR;
  end;
  {$EXTERNALSYM _OUTLINETEXTMETRICW}
  OUTLINETEXTMETRICW = _OUTLINETEXTMETRICW;
  {$EXTERNALSYM OUTLINETEXTMETRICW}
  LPOUTLINETEXTMETRICW = ^OUTLINETEXTMETRICW;
  {$EXTERNALSYM LPOUTLINETEXTMETRICW}
  NPOUTLINETEXTMETRICW = ^OUTLINETEXTMETRICW;
  {$EXTERNALSYM NPOUTLINETEXTMETRICW}
  TOutlineTextMetricW = _OUTLINETEXTMETRICW;

  {$IFDEF UNICODE}
  OUTLINETEXTMETRIC = OUTLINETEXTMETRICW;
  {$EXTERNALSYM OUTLINETEXTMETRIC}
  POUTLINETEXTMETRIC = POUTLINETEXTMETRICW;
  {$EXTERNALSYM POUTLINETEXTMETRIC}
  NPOUTLINETEXTMETRIC = NPOUTLINETEXTMETRICW;
  {$EXTERNALSYM NPOUTLINETEXTMETRIC}
  LPOUTLINETEXTMETRIC = LPOUTLINETEXTMETRICW;
  {$EXTERNALSYM LPOUTLINETEXTMETRIC}
  TOutlineTextMetric = TOutlineTextMetricW;
  {$ELSE}
  OUTLINETEXTMETRIC = OUTLINETEXTMETRICA;
  {$EXTERNALSYM OUTLINETEXTMETRIC}
  POUTLINETEXTMETRIC = POUTLINETEXTMETRICA;
  {$EXTERNALSYM POUTLINETEXTMETRIC}
  NPOUTLINETEXTMETRIC = NPOUTLINETEXTMETRICA;
  {$EXTERNALSYM NPOUTLINETEXTMETRIC}
  LPOUTLINETEXTMETRIC = LPOUTLINETEXTMETRICA;
  {$EXTERNALSYM LPOUTLINETEXTMETRIC}
  TOutlineTextMetric = TOutlineTextMetricA;
  {$ENDIF UNICODE}

  PPolytextA = ^TPolytextA;
  tagPOLYTEXTA = record
    x: Integer;
    y: Integer;
    n: UINT;
    lpstr: LPCSTR;
    uiFlags: UINT;
    rcl: RECT;
    pdx: PINT;
  end;
  {$EXTERNALSYM tagPOLYTEXTA}
  POLYTEXTA = tagPOLYTEXTA;
  {$EXTERNALSYM POLYTEXTA}
  LPPOLYTEXTA = ^POLYTEXTA;
  {$EXTERNALSYM LPPOLYTEXTA}
  NPPOLYTEXTA = ^POLYTEXTA;
  {$EXTERNALSYM NPPOLYTEXTA}
  TPolytextA = POLYTEXTA;

  PPolytextW = ^TPolytextW;
  tagPOLYTEXTW = record
    x: Integer;
    y: Integer;
    n: UINT;
    lpstr: LPCWSTR;
    uiFlags: UINT;
    rcl: RECT;
    pdx: PINT;
  end;
  {$EXTERNALSYM tagPOLYTEXTW}
  POLYTEXTW = tagPOLYTEXTW;
  {$EXTERNALSYM POLYTEXTW}
  LPPOLYTEXTW = ^POLYTEXTW;
  {$EXTERNALSYM LPPOLYTEXTW}
  NPPOLYTEXTW = ^POLYTEXTW;
  {$EXTERNALSYM NPPOLYTEXTW}
  TPolytextW = POLYTEXTW;

  {$IFDEF UNICODE}
  POLYTEXT = POLYTEXTW;
  {$EXTERNALSYM POLYTEXT}
  PPOLYTEXT = PPOLYTEXTW;
  {$EXTERNALSYM PPOLYTEXT}
  NPPOLYTEXT = NPPOLYTEXTW;
  {$EXTERNALSYM NPPOLYTEXT}
  LPPOLYTEXT = LPPOLYTEXTW;
  {$EXTERNALSYM LPPOLYTEXT}
  TPolyText = TPolyTextW;
  {$ELSE}
  POLYTEXT = POLYTEXTA;
  {$EXTERNALSYM POLYTEXT}
  PPOLYTEXT = PPOLYTEXTA;
  {$EXTERNALSYM PPOLYTEXT}
  NPPOLYTEXT = NPPOLYTEXTA;
  {$EXTERNALSYM NPPOLYTEXT}
  LPPOLYTEXT = LPPOLYTEXTA;
  {$EXTERNALSYM LPPOLYTEXT}
  TPolyText = TPolyTextA;
  {$ENDIF UNICODE}

  PFixed = ^TFixed;
  _FIXED = record
    fract: WORD;
    value: short;
  end;
  {$EXTERNALSYM _FIXED}
  FIXED = _FIXED;
  {$EXTERNALSYM FIXED}
  TFixed = _FIXED;

  PMat2 = ^TMat2;
  _MAT2 = record
    eM11: FIXED;
    eM12: FIXED;
    eM21: FIXED;
    eM22: FIXED;
  end;
  {$EXTERNALSYM _MAT2}
  MAT2 = _MAT2;
  {$EXTERNALSYM MAT2}
  LPMAT2 = ^MAT2;
  {$EXTERNALSYM LPMAT2}
  TMat2 = _MAT2;

  PGlyphMetrics = ^TGlyphMetrics;
  _GLYPHMETRICS = record
    gmBlackBoxX: UINT;
    gmBlackBoxY: UINT;
    gmptGlyphOrigin: POINT;
    gmCellIncX: short;
    gmCellIncY: short;
  end;
  {$EXTERNALSYM _GLYPHMETRICS}
  GLYPHMETRICS = _GLYPHMETRICS;
  {$EXTERNALSYM GLYPHMETRICS}
  LPGLYPHMETRICS = ^GLYPHMETRICS;
  {$EXTERNALSYM LPGLYPHMETRICS}
  TGlyphMetrics = _GLYPHMETRICS;

//  GetGlyphOutline constants

const
  GGO_METRICS = 0;
  {$EXTERNALSYM GGO_METRICS}
  GGO_BITMAP  = 1;
  {$EXTERNALSYM GGO_BITMAP}
  GGO_NATIVE  = 2;
  {$EXTERNALSYM GGO_NATIVE}
  GGO_BEZIER  = 3;
  {$EXTERNALSYM GGO_BEZIER}

  GGO_GRAY2_BITMAP = 4;
  {$EXTERNALSYM GGO_GRAY2_BITMAP}
  GGO_GRAY4_BITMAP = 5;
  {$EXTERNALSYM GGO_GRAY4_BITMAP}
  GGO_GRAY8_BITMAP = 6;
  {$EXTERNALSYM GGO_GRAY8_BITMAP}
  GGO_GLYPH_INDEX  = $0080;
  {$EXTERNALSYM GGO_GLYPH_INDEX}

  GGO_UNHINTED = $0100;
  {$EXTERNALSYM GGO_UNHINTED}

  TT_POLYGON_TYPE = 24;
  {$EXTERNALSYM TT_POLYGON_TYPE}

  TT_PRIM_LINE    = 1;
  {$EXTERNALSYM TT_PRIM_LINE}
  TT_PRIM_QSPLINE = 2;
  {$EXTERNALSYM TT_PRIM_QSPLINE}
  TT_PRIM_CSPLINE = 3;
  {$EXTERNALSYM TT_PRIM_CSPLINE}

type
  PPointFx = ^TPointFx;
  tagPOINTFX = record
    x: FIXED;
    y: FIXED;
  end;
  {$EXTERNALSYM tagPOINTFX}
  POINTFX = tagPOINTFX;
  {$EXTERNALSYM POINTFX}
  LPPOINTFX = ^POINTFX;
  {$EXTERNALSYM LPPOINTFX}
  TPointFx = POINTFX;

  PTtPolyCurve = ^TTtPolyCurve;
  tagTTPOLYCURVE = record
    wType: WORD;
    cpfx: WORD;
    apfx: array [0..0] of POINTFX;
  end;
  {$EXTERNALSYM tagTTPOLYCURVE}
  TTPOLYCURVE = tagTTPOLYCURVE;
  {$EXTERNALSYM TTPOLYCURVE}
  LPTTPOLYCURVE = ^TTPOLYCURVE;
  {$EXTERNALSYM LPTTPOLYCURVE}
  TTtPolyCurve = TTPOLYCURVE;

  PTtPolygonHeader = ^TTtPolygonHeader;
  tagTTPOLYGONHEADER = record
    cb: DWORD;
    dwType: DWORD;
    pfxStart: POINTFX;
  end;
  {$EXTERNALSYM tagTTPOLYGONHEADER}
  TTPOLYGONHEADER = tagTTPOLYGONHEADER;
  {$EXTERNALSYM TTPOLYGONHEADER}
  LPTTPOLYGONHEADER = ^TTPOLYGONHEADER;
  {$EXTERNALSYM LPTTPOLYGONHEADER}
  TTtPolygonHeader = TTPOLYGONHEADER;

const
  GCP_DBCS       = $0001;
  {$EXTERNALSYM GCP_DBCS}
  GCP_REORDER    = $0002;
  {$EXTERNALSYM GCP_REORDER}
  GCP_USEKERNING = $0008;
  {$EXTERNALSYM GCP_USEKERNING}
  GCP_GLYPHSHAPE = $0010;
  {$EXTERNALSYM GCP_GLYPHSHAPE}
  GCP_LIGATE     = $0020;
  {$EXTERNALSYM GCP_LIGATE}
////#define GCP_GLYPHINDEXING  0x0080
  GCP_DIACRITIC = $0100;
  {$EXTERNALSYM GCP_DIACRITIC}
  GCP_KASHIDA   = $0400;
  {$EXTERNALSYM GCP_KASHIDA}
  GCP_ERROR     = $8000;
  {$EXTERNALSYM GCP_ERROR}
  FLI_MASK      = $103B;
  {$EXTERNALSYM FLI_MASK}

  GCP_JUSTIFY = $00010000;
  {$EXTERNALSYM GCP_JUSTIFY}
////#define GCP_NODIACRITICS   0x00020000L
  FLI_GLYPHS          = $00040000;
  {$EXTERNALSYM FLI_GLYPHS}
  GCP_CLASSIN         = $00080000;
  {$EXTERNALSYM GCP_CLASSIN}
  GCP_MAXEXTENT       = $00100000;
  {$EXTERNALSYM GCP_MAXEXTENT}
  GCP_JUSTIFYIN       = $00200000;
  {$EXTERNALSYM GCP_JUSTIFYIN}
  GCP_DISPLAYZWG      = $00400000;
  {$EXTERNALSYM GCP_DISPLAYZWG}
  GCP_SYMSWAPOFF      = $00800000;
  {$EXTERNALSYM GCP_SYMSWAPOFF}
  GCP_NUMERICOVERRIDE = $01000000;
  {$EXTERNALSYM GCP_NUMERICOVERRIDE}
  GCP_NEUTRALOVERRIDE = $02000000;
  {$EXTERNALSYM GCP_NEUTRALOVERRIDE}
  GCP_NUMERICSLATIN   = $04000000;
  {$EXTERNALSYM GCP_NUMERICSLATIN}
  GCP_NUMERICSLOCAL   = $08000000;
  {$EXTERNALSYM GCP_NUMERICSLOCAL}

  GCPCLASS_LATIN                  = 1;
  {$EXTERNALSYM GCPCLASS_LATIN}
  GCPCLASS_HEBREW                 = 2;
  {$EXTERNALSYM GCPCLASS_HEBREW}
  GCPCLASS_ARABIC                 = 2;
  {$EXTERNALSYM GCPCLASS_ARABIC}
  GCPCLASS_NEUTRAL                = 3;
  {$EXTERNALSYM GCPCLASS_NEUTRAL}
  GCPCLASS_LOCALNUMBER            = 4;
  {$EXTERNALSYM GCPCLASS_LOCALNUMBER}
  GCPCLASS_LATINNUMBER            = 5;
  {$EXTERNALSYM GCPCLASS_LATINNUMBER}
  GCPCLASS_LATINNUMERICTERMINATOR = 6;
  {$EXTERNALSYM GCPCLASS_LATINNUMERICTERMINATOR}
  GCPCLASS_LATINNUMERICSEPARATOR  = 7;
  {$EXTERNALSYM GCPCLASS_LATINNUMERICSEPARATOR}
  GCPCLASS_NUMERICSEPARATOR       = 8;
  {$EXTERNALSYM GCPCLASS_NUMERICSEPARATOR}
  GCPCLASS_PREBOUNDLTR            = $80;
  {$EXTERNALSYM GCPCLASS_PREBOUNDLTR}
  GCPCLASS_PREBOUNDRTL            = $40;
  {$EXTERNALSYM GCPCLASS_PREBOUNDRTL}
  GCPCLASS_POSTBOUNDLTR           = $20;
  {$EXTERNALSYM GCPCLASS_POSTBOUNDLTR}
  GCPCLASS_POSTBOUNDRTL           = $10;
  {$EXTERNALSYM GCPCLASS_POSTBOUNDRTL}

  GCPGLYPH_LINKBEFORE = $8000;
  {$EXTERNALSYM GCPGLYPH_LINKBEFORE}
  GCPGLYPH_LINKAFTER  = $4000;
  {$EXTERNALSYM GCPGLYPH_LINKAFTER}

type
  PGcpResultsA = ^TGcpResultsA;
  tagGCP_RESULTSA = record
    lStructSize: DWORD;
    lpOutString: LPSTR;
    lpOrder: LPUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: LPSTR;
    lpGlyphs: LPWSTR;
    nGlyphs: UINT;
    nMaxFit: Integer;
  end;
  {$EXTERNALSYM tagGCP_RESULTSA}
  GCP_RESULTSA = tagGCP_RESULTSA;
  {$EXTERNALSYM GCP_RESULTSA}
  LPGCP_RESULTSA = ^GCP_RESULTSA;
  {$EXTERNALSYM LPGCP_RESULTSA}
  TGcpResultsA = GCP_RESULTSA;

  PGcpResultsW = ^TGcpResultsW;
  tagGCP_RESULTSW = record
    lStructSize: DWORD;
    lpOutString: LPWSTR;
    lpOrder: LPUINT;
    lpDx: PINT;
    lpCaretPos: PINT;
    lpClass: LPSTR;
    lpGlyphs: LPWSTR;
    nGlyphs: UINT;
    nMaxFit: Integer;
  end;
  {$EXTERNALSYM tagGCP_RESULTSW}
  GCP_RESULTSW = tagGCP_RESULTSW;
  {$EXTERNALSYM GCP_RESULTSW}
  LPGCP_RESULTSW = ^GCP_RESULTSW;
  {$EXTERNALSYM LPGCP_RESULTSW}
  TGcpResultsW = GCP_RESULTSW;

  {$IFDEF UNICODE}
  GCP_RESULTS = GCP_RESULTSW;
  {$EXTERNALSYM GCP_RESULTS}
  LPGCP_RESULTS = LPGCP_RESULTSW;
  {$EXTERNALSYM LPGCP_RESULTS}
  TGcpResults = TGcpResultsW;
  PGcpResults = PGcpResultsW;
  {$ELSE}
  GCP_RESULTS = GCP_RESULTSA;
  {$EXTERNALSYM GCP_RESULTS}
  LPGCP_RESULTS = LPGCP_RESULTSA;
  {$EXTERNALSYM LPGCP_RESULTS}
  TGcpResults = TGcpResultsA;
  PGcpResults = PGcpResultsA;
  {$ENDIF UNICODE}

  PRasterizerStatus = ^TRasterizerStatus;
  _RASTERIZER_STATUS = record
    nSize: short;
    wFlags: short;
    nLanguageID: short;
  end;
  {$EXTERNALSYM _RASTERIZER_STATUS}
  RASTERIZER_STATUS = _RASTERIZER_STATUS;
  {$EXTERNALSYM RASTERIZER_STATUS}
  LPRASTERIZER_STATUS = ^RASTERIZER_STATUS;
  {$EXTERNALSYM LPRASTERIZER_STATUS}
  TRasterizerStatus = _RASTERIZER_STATUS;

// bits defined in wFlags of RASTERIZER_STATUS

const
  TT_AVAILABLE = $0001;
  {$EXTERNALSYM TT_AVAILABLE}
  TT_ENABLED   = $0002;
  {$EXTERNALSYM TT_ENABLED}

// Pixel format descriptor

type
  PPixelFormatDescriptor = ^TPixelFormatDescriptor;
  tagPIXELFORMATDESCRIPTOR = record
    nSize: WORD;
    nVersion: WORD;
    dwFlags: DWORD;
    iPixelType: BYTE;
    cColorBits: BYTE;
    cRedBits: BYTE;
    cRedShift: BYTE;
    cGreenBits: BYTE;
    cGreenShift: BYTE;
    cBlueBits: BYTE;
    cBlueShift: BYTE;
    cAlphaBits: BYTE;
    cAlphaShift: BYTE;
    cAccumBits: BYTE;
    cAccumRedBits: BYTE;
    cAccumGreenBits: BYTE;
    cAccumBlueBits: BYTE;
    cAccumAlphaBits: BYTE;
    cDepthBits: BYTE;
    cStencilBits: BYTE;
    cAuxBuffers: BYTE;
    iLayerType: BYTE;
    bReserved: BYTE;
    dwLayerMask: DWORD;
    dwVisibleMask: DWORD;
    dwDamageMask: DWORD;
  end;
  {$EXTERNALSYM tagPIXELFORMATDESCRIPTOR}
  PIXELFORMATDESCRIPTOR = tagPIXELFORMATDESCRIPTOR;
  {$EXTERNALSYM PIXELFORMATDESCRIPTOR}
  LPPIXELFORMATDESCRIPTOR = ^PIXELFORMATDESCRIPTOR;
  {$EXTERNALSYM LPPIXELFORMATDESCRIPTOR}
  TPixelFormatDescriptor = PIXELFORMATDESCRIPTOR;

// pixel types

const
  PFD_TYPE_RGBA       = 0;
  {$EXTERNALSYM PFD_TYPE_RGBA}
  PFD_TYPE_COLORINDEX = 1;
  {$EXTERNALSYM PFD_TYPE_COLORINDEX}

// layer types

  PFD_MAIN_PLANE     = 0;
  {$EXTERNALSYM PFD_MAIN_PLANE}
  PFD_OVERLAY_PLANE  = 1;
  {$EXTERNALSYM PFD_OVERLAY_PLANE}
  PFD_UNDERLAY_PLANE = DWORD(-1);
  {$EXTERNALSYM PFD_UNDERLAY_PLANE}

// PIXELFORMATDESCRIPTOR flags

  PFD_DOUBLEBUFFER        = $00000001;
  {$EXTERNALSYM PFD_DOUBLEBUFFER}
  PFD_STEREO              = $00000002;
  {$EXTERNALSYM PFD_STEREO}
  PFD_DRAW_TO_WINDOW      = $00000004;
  {$EXTERNALSYM PFD_DRAW_TO_WINDOW}
  PFD_DRAW_TO_BITMAP      = $00000008;
  {$EXTERNALSYM PFD_DRAW_TO_BITMAP}
  PFD_SUPPORT_GDI         = $00000010;
  {$EXTERNALSYM PFD_SUPPORT_GDI}
  PFD_SUPPORT_OPENGL      = $00000020;
  {$EXTERNALSYM PFD_SUPPORT_OPENGL}
  PFD_GENERIC_FORMAT      = $00000040;
  {$EXTERNALSYM PFD_GENERIC_FORMAT}
  PFD_NEED_PALETTE        = $00000080;
  {$EXTERNALSYM PFD_NEED_PALETTE}
  PFD_NEED_SYSTEM_PALETTE = $00000100;
  {$EXTERNALSYM PFD_NEED_SYSTEM_PALETTE}
  PFD_SWAP_EXCHANGE       = $00000200;
  {$EXTERNALSYM PFD_SWAP_EXCHANGE}
  PFD_SWAP_COPY           = $00000400;
  {$EXTERNALSYM PFD_SWAP_COPY}
  PFD_SWAP_LAYER_BUFFERS  = $00000800;
  {$EXTERNALSYM PFD_SWAP_LAYER_BUFFERS}
  PFD_GENERIC_ACCELERATED = $00001000;
  {$EXTERNALSYM PFD_GENERIC_ACCELERATED}
  PFD_SUPPORT_DIRECTDRAW  = $00002000;
  {$EXTERNALSYM PFD_SUPPORT_DIRECTDRAW}

// PIXELFORMATDESCRIPTOR flags for use in ChoosePixelFormat only

  PFD_DEPTH_DONTCARE        = DWORD($20000000);
  {$EXTERNALSYM PFD_DEPTH_DONTCARE}
  PFD_DOUBLEBUFFER_DONTCARE = DWORD($40000000);
  {$EXTERNALSYM PFD_DOUBLEBUFFER_DONTCARE}
  PFD_STEREO_DONTCARE       = DWORD($80000000);
  {$EXTERNALSYM PFD_STEREO_DONTCARE}

type
  OLDFONTENUMPROCA = function(lpelf: LPLOGFONTA; lpntm: LPTEXTMETRICA; FontType: DWORD; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM OLDFONTENUMPROCA}
  OLDFONTENUMPROCW = function(lpelf: LPLOGFONTW; lpntm: LPTEXTMETRICW; FontType: DWORD; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM OLDFONTENUMPROCW}
  OLDFONTENUMPROC = function(lpelf: LPLOGFONT; lpntm: LPTEXTMETRIC; FontType: DWORD; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM OLDFONTENUMPROC}

  FONTENUMPROCA = OLDFONTENUMPROCA;
  {$EXTERNALSYM FONTENUMPROCA}
  FONTENUMPROCW = OLDFONTENUMPROCW;
  {$EXTERNALSYM FONTENUMPROCW}
  FONTENUMPROC = OLDFONTENUMPROC;
  {$EXTERNALSYM FONTENUMPROC}

  GOBJENUMPROC = function(lpLogObject: LPVOID; lpData: LPARAM): Integer; stdcall;
  {$EXTERNALSYM GOBJENUMPROC}
  LINEDDAPROC = procedure(X, Y: Integer; lpData: LPARAM); stdcall;
  {$EXTERNALSYM LINEDDAPROC}

function AddFontResourceA(lpszFileName: LPCSTR): Integer; stdcall;
{$EXTERNALSYM AddFontResourceA}
function AddFontResourceW(lpszFileName: LPCWSTR): Integer; stdcall;
{$EXTERNALSYM AddFontResourceW}
function AddFontResource(lpszFileName: LPCTSTR): Integer; stdcall;
{$EXTERNALSYM AddFontResource}

function AnimatePalette(hPal: HPALETTE; iStartIndex: UINT; cEntries: UINT; ppe: PPALETTEENTRY): BOOL; stdcall;
{$EXTERNALSYM AnimatePalette}
function Arc(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect, nxStartArc, nyStartArc, nXEndArc, nYEndArc: Integer): BOOL; stdcall;
{$EXTERNALSYM Arc}
function BitBlt(hdcDEst: HDC; nXDest, nYDest, nWidth, nHeight: Integer; hdcSrc: HDC; nXSrc, nYSrc: Integer; dwRop: DWORD): BOOL; stdcall;
{$EXTERNALSYM BitBlt}
function CancelDC(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM CancelDC}
function Chord(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2: Integer): BOOL; stdcall;
{$EXTERNALSYM Chord}
function ChoosePixelFormat(hdc: HDC; const ppfd: PIXELFORMATDESCRIPTOR): Integer; stdcall;
{$EXTERNALSYM ChoosePixelFormat}
function CloseMetaFile(hdc: HDC): HMETAFILE; stdcall;
{$EXTERNALSYM CloseMetaFile}
function CombineRgn(hrgnDest, hrgnSrc1, hrgnSrc2: HRGN; fnCombineMode: Integer): Integer; stdcall;
{$EXTERNALSYM CombineRgn}
function CopyMetaFileA(hmfSrc: HMETAFILE; lpszFile: LPCSTR): HMETAFILE; stdcall;
{$EXTERNALSYM CopyMetaFileA}
function CopyMetaFileW(hmfSrc: HMETAFILE; lpszFile: LPCWSTR): HMETAFILE; stdcall;
{$EXTERNALSYM CopyMetaFileW}
function CopyMetaFile(hmfSrc: HMETAFILE; lpszFile: LPCTSTR): HMETAFILE; stdcall;
{$EXTERNALSYM CopyMetaFile}
function CreateBitmap(nWidth, nHeight: Integer; Cplanes, cBitsPerPel: UINT; lpvBits: PVOID): HBITMAP; stdcall;
{$EXTERNALSYM CreateBitmap}
function CreateBitmapIndirect(const lpbm: BITMAP): HBITMAP; stdcall;
{$EXTERNALSYM CreateBitmapIndirect}
function CreateBrushIndirect(const lplb: LOGBRUSH): HBRUSH; stdcall;
{$EXTERNALSYM CreateBrushIndirect}
function CreateCompatibleBitmap(hdc: HDC; nWidth, nHeight: Integer): HBITMAP; stdcall;
{$EXTERNALSYM CreateCompatibleBitmap}
function CreateDiscardableBitmap(hdc: HDC; nWidth, nHeight: Integer): HBITMAP; stdcall;
{$EXTERNALSYM CreateDiscardableBitmap}
function CreateCompatibleDC(hdc: HDC): HDC; stdcall;
{$EXTERNALSYM CreateCompatibleDC}
function CreateDCA(lpszDriver, lpszDevice, lpszOutput: LPCSTR; lpInitData: LPDEVMODEA): HDC; stdcall;
{$EXTERNALSYM CreateDCA}
function CreateDCW(lpszDriver, lpszDevice, lpszOutput: LPCWSTR; lpInitData: LPDEVMODEW): HDC; stdcall;
{$EXTERNALSYM CreateDCW}
function CreateDC(lpszDriver, lpszDevice, lpszOutput: LPCTSTR; lpInitData: LPDEVMODE): HDC; stdcall;
{$EXTERNALSYM CreateDC}
function CreateDIBitmap(hdc: HDC; const lpbmih: BITMAPINFOHEADER; fdwInit: DWORD; lpbInit: PVOID; const lpbmi: BITMAPINFO; fuUsage: UINT): HBITMAP; stdcall;
{$EXTERNALSYM CreateDIBitmap}
function CreateDIBPatternBrush(hglbDIBPacked: HGLOBAL; fuColorSpec: UINT): HBRUSH; stdcall;
{$EXTERNALSYM CreateDIBPatternBrush}
function CreateDIBPatternBrushPt(lpPackedDIB: PVOID; iUsage: UINT): HBRUSH; stdcall;
{$EXTERNALSYM CreateDIBPatternBrushPt}
function CreateEllipticRgn(nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): HRGN; stdcall;
{$EXTERNALSYM CreateEllipticRgn}
function CreateEllipticRgnIndirect(const lprc: RECT): HRGN; stdcall;
{$EXTERNALSYM CreateEllipticRgnIndirect}
function CreateFontIndirectA(const lplf: LOGFONTA): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirectA}
function CreateFontIndirectW(const lplf: LOGFONTW): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirectW}
function CreateFontIndirect(const lplf: LOGFONT): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirect}
function CreateFontA(nHeight, nWidth, nEscapement, nOrientation, fnWeight: Integer; fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: LPCSTR): HFONT; stdcall;
{$EXTERNALSYM CreateFontA}
function CreateFontW(nHeight, nWidth, nEscapement, nOrientation, fnWeight: Integer; fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: LPCWSTR): HFONT; stdcall;
{$EXTERNALSYM CreateFontW}
function CreateFont(nHeight, nWidth, nEscapement, nOrientation, fnWeight: Integer; fdwItalic, fdwUnderline, fdwStrikeOut, fdwCharSet, fdwOutputPrecision, fdwClipPrecision, fdwQuality, fdwPitchAndFamily: DWORD; lpszFace: LPCTSTR): HFONT; stdcall;
{$EXTERNALSYM CreateFont}
function CreateHatchBrush(fnStyle: Integer; clrref: COLORREF): HBRUSH; stdcall;
{$EXTERNALSYM CreateHatchBrush}
function CreateICA(lpszDriver, lpszDevice, lpszOutput: LPCSTR; lpdvmInit: LPDEVMODEA): HDC; stdcall;
{$EXTERNALSYM CreateICA}
function CreateICW(lpszDriver, lpszDevice, lpszOutput: LPCWSTR; lpdvmInit: LPDEVMODEW): HDC; stdcall;
{$EXTERNALSYM CreateICW}
function CreateIC(lpszDriver, lpszDevice, lpszOutput: LPCWSTR; lpdvmInit: LPDEVMODE): HDC; stdcall;
{$EXTERNALSYM CreateIC}
function CreateMetaFileA(lpszFile: LPCSTR): HDC; stdcall;
{$EXTERNALSYM CreateMetaFileA}
function CreateMetaFileW(lpszFile: LPCWSTR): HDC; stdcall;
{$EXTERNALSYM CreateMetaFileW}
function CreateMetaFile(lpszFile: LPCTSTR): HDC; stdcall;
{$EXTERNALSYM CreateMetaFile}
function CreatePalette(const lplgpl: LOGPALETTE): HPALETTE; stdcall;
{$EXTERNALSYM CreatePalette}
function CreatePen(fnPenStyle, nWidth: Integer; crColor: COLORREF): HPEN; stdcall;
{$EXTERNALSYM CreatePen}
function CreatePenIndirect(const lplgpn: LOGPEN): HPEN; stdcall;
{$EXTERNALSYM CreatePenIndirect}
function CreatePolyPolygonRgn(lppt: LPPOINT; lpPolyCounts: LPINT; nCount, fnPolyFillMode: Integer): HRGN; stdcall;
{$EXTERNALSYM CreatePolyPolygonRgn}
function CreatePatternBrush(hbmp: HBITMAP): HBRUSH; stdcall;
{$EXTERNALSYM CreatePatternBrush}
function CreateRectRgn(nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): HRGN; stdcall;
{$EXTERNALSYM CreateRectRgn}
function CreateRectRgnIndirect(const lprc: RECT): HRGN; stdcall;
{$EXTERNALSYM CreateRectRgnIndirect}
function CreateRoundRectRgn(nLeftRect, nTopRect, nRightRect, nBottomRect, nWidthEllipse, nHeightEllipse: Integer): HRGN; stdcall;
{$EXTERNALSYM CreateRoundRectRgn}
function CreateScalableFontResourceA(fdwHidden: DWORD; lpszFontRes, lpszFontFile, lpszCurrentPath: LPCSTR): BOOL; stdcall;
{$EXTERNALSYM CreateScalableFontResourceA}
function CreateScalableFontResourceW(fdwHidden: DWORD; lpszFontRes, lpszFontFile, lpszCurrentPath: LPCWSTR): BOOL; stdcall;
{$EXTERNALSYM CreateScalableFontResourceW}
function CreateScalableFontResource(fdwHidden: DWORD; lpszFontRes, lpszFontFile, lpszCurrentPath: LPCTSTR): BOOL; stdcall;
{$EXTERNALSYM CreateScalableFontResource}
function CreateSolidBrush(crColor: COLORREF): HBRUSH; stdcall;
{$EXTERNALSYM CreateSolidBrush}
function DeleteDC(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM DeleteDC}
function DeleteMetaFile(hmf: HMETAFILE): BOOL; stdcall;
{$EXTERNALSYM DeleteMetaFile}
function DeleteObject(hObject: HGDIOBJ): BOOL; stdcall;
{$EXTERNALSYM DeleteObject}
function DescribePixelFormat(hdc: HDC; iPixelFormat: Integer; nBytes: UINT; ppfd: LPPIXELFORMATDESCRIPTOR): Integer; stdcall;
{$EXTERNALSYM DescribePixelFormat}

// mode selections for the device mode function

const
  DM_UPDATE = 1;
  {$EXTERNALSYM DM_UPDATE}
  DM_COPY   = 2;
  {$EXTERNALSYM DM_COPY}
  DM_PROMPT = 4;
  {$EXTERNALSYM DM_PROMPT}
  DM_MODIFY = 8;
  {$EXTERNALSYM DM_MODIFY}

  DM_IN_BUFFER   = DM_MODIFY;
  {$EXTERNALSYM DM_IN_BUFFER}
  DM_IN_PROMPT   = DM_PROMPT;
  {$EXTERNALSYM DM_IN_PROMPT}
  DM_OUT_BUFFER  = DM_COPY;
  {$EXTERNALSYM DM_OUT_BUFFER}
  DM_OUT_DEFAULT = DM_UPDATE;
  {$EXTERNALSYM DM_OUT_DEFAULT}

// device capabilities indices

  DC_FIELDS            = 1;
  {$EXTERNALSYM DC_FIELDS}
  DC_PAPERS            = 2;
  {$EXTERNALSYM DC_PAPERS}
  DC_PAPERSIZE         = 3;
  {$EXTERNALSYM DC_PAPERSIZE}
  DC_MINEXTENT         = 4;
  {$EXTERNALSYM DC_MINEXTENT}
  DC_MAXEXTENT         = 5;
  {$EXTERNALSYM DC_MAXEXTENT}
  DC_BINS              = 6;
  {$EXTERNALSYM DC_BINS}
  DC_DUPLEX            = 7;
  {$EXTERNALSYM DC_DUPLEX}
  DC_SIZE              = 8;
  {$EXTERNALSYM DC_SIZE}
  DC_EXTRA             = 9;
  {$EXTERNALSYM DC_EXTRA}
  DC_VERSION           = 10;
  {$EXTERNALSYM DC_VERSION}
  DC_DRIVER            = 11;
  {$EXTERNALSYM DC_DRIVER}
  DC_BINNAMES          = 12;
  {$EXTERNALSYM DC_BINNAMES}
  DC_ENUMRESOLUTIONS   = 13;
  {$EXTERNALSYM DC_ENUMRESOLUTIONS}
  DC_FILEDEPENDENCIES  = 14;
  {$EXTERNALSYM DC_FILEDEPENDENCIES}
  DC_TRUETYPE          = 15;
  {$EXTERNALSYM DC_TRUETYPE}
  DC_PAPERNAMES        = 16;
  {$EXTERNALSYM DC_PAPERNAMES}
  DC_ORIENTATION       = 17;
  {$EXTERNALSYM DC_ORIENTATION}
  DC_COPIES            = 18;
  {$EXTERNALSYM DC_COPIES}
  DC_BINADJUST         = 19;
  {$EXTERNALSYM DC_BINADJUST}
  DC_EMF_COMPLIANT     = 20;
  {$EXTERNALSYM DC_EMF_COMPLIANT}
  DC_DATATYPE_PRODUCED = 21;
  {$EXTERNALSYM DC_DATATYPE_PRODUCED}
  DC_COLLATE           = 22;
  {$EXTERNALSYM DC_COLLATE}
  DC_MANUFACTURER      = 23;
  {$EXTERNALSYM DC_MANUFACTURER}
  DC_MODEL             = 24;
  {$EXTERNALSYM DC_MODEL}

  DC_PERSONALITY    = 25;
  {$EXTERNALSYM DC_PERSONALITY}
  DC_PRINTRATE      = 26;
  {$EXTERNALSYM DC_PRINTRATE}
  DC_PRINTRATEUNIT  = 27;
  {$EXTERNALSYM DC_PRINTRATEUNIT}
  PRINTRATEUNIT_PPM = 1;
  {$EXTERNALSYM PRINTRATEUNIT_PPM}
  PRINTRATEUNIT_CPS = 2;
  {$EXTERNALSYM PRINTRATEUNIT_CPS}
  PRINTRATEUNIT_LPM = 3;
  {$EXTERNALSYM PRINTRATEUNIT_LPM}
  PRINTRATEUNIT_IPM = 4;
  {$EXTERNALSYM PRINTRATEUNIT_IPM}
  DC_PRINTERMEM     = 28;
  {$EXTERNALSYM DC_PRINTERMEM}
  DC_MEDIAREADY     = 29;
  {$EXTERNALSYM DC_MEDIAREADY}
  DC_STAPLE         = 30;
  {$EXTERNALSYM DC_STAPLE}
  DC_PRINTRATEPPM   = 31;
  {$EXTERNALSYM DC_PRINTRATEPPM}
  DC_COLORDEVICE    = 32;
  {$EXTERNALSYM DC_COLORDEVICE}
  DC_NUP            = 33;
  {$EXTERNALSYM DC_NUP}
  DC_MEDIATYPENAMES = 34;
  {$EXTERNALSYM DC_MEDIATYPENAMES}
  DC_MEDIATYPES     = 35;
  {$EXTERNALSYM DC_MEDIATYPES}

// bit fields of the return value (DWORD) for DC_TRUETYPE

  DCTT_BITMAP           = $0000001;
  {$EXTERNALSYM DCTT_BITMAP}
  DCTT_DOWNLOAD         = $0000002;
  {$EXTERNALSYM DCTT_DOWNLOAD}
  DCTT_SUBDEV           = $0000004;
  {$EXTERNALSYM DCTT_SUBDEV}
  DCTT_DOWNLOAD_OUTLINE = $0000008;
  {$EXTERNALSYM DCTT_DOWNLOAD_OUTLINE}

// return values for DC_BINADJUST

  DCBA_FACEUPNONE     = $0000;
  {$EXTERNALSYM DCBA_FACEUPNONE}
  DCBA_FACEUPCENTER   = $0001;
  {$EXTERNALSYM DCBA_FACEUPCENTER}
  DCBA_FACEUPLEFT     = $0002;
  {$EXTERNALSYM DCBA_FACEUPLEFT}
  DCBA_FACEUPRIGHT    = $0003;
  {$EXTERNALSYM DCBA_FACEUPRIGHT}
  DCBA_FACEDOWNNONE   = $0100;
  {$EXTERNALSYM DCBA_FACEDOWNNONE}
  DCBA_FACEDOWNCENTER = $0101;
  {$EXTERNALSYM DCBA_FACEDOWNCENTER}
  DCBA_FACEDOWNLEFT   = $0102;
  {$EXTERNALSYM DCBA_FACEDOWNLEFT}
  DCBA_FACEDOWNRIGHT  = $0103;
  {$EXTERNALSYM DCBA_FACEDOWNRIGHT}

function DeviceCapabilitiesA(pDevice, pPort: LPCSTR; fwCapability: WORD; pOutput: LPSTR; pDevMode: LPDEVMODEA): Integer; stdcall;
{$EXTERNALSYM DeviceCapabilitiesA}
function DeviceCapabilitiesW(pDevice, pPort: LPCWSTR; fwCapability: WORD; pOutput: LPWSTR; pDevMode: LPDEVMODEW): Integer; stdcall;
{$EXTERNALSYM DeviceCapabilitiesW}
function DeviceCapabilities(pDevice, pPort: LPCTSTR; fwCapability: WORD; pOutput: LPTSTR; pDevMode: LPDEVMODE): Integer; stdcall;
{$EXTERNALSYM DeviceCapabilities}
function DrawEscape(hdc: HDC; nEscape, cbInput: Integer; lpszInData: LPCSTR): Integer; stdcall;
{$EXTERNALSYM DrawEscape}
function Ellipse(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): BOOL; stdcall;
{$EXTERNALSYM Ellipse}
function EnumFontFamiliesExA(hdc: HDC; lpLogFont: LPLOGFONTA; lpEnumFontFamExProc: FONTENUMPROCA; lParam: LPARAM; dwFlags: DWORD): Integer; stdcall;
{$EXTERNALSYM EnumFontFamiliesExA}
function EnumFontFamiliesExW(hdc: HDC; lpLogFont: LPLOGFONTW; lpEnumFontFamExProc: FONTENUMPROCW; lParam: LPARAM; dwFlags: DWORD): Integer; stdcall;
{$EXTERNALSYM EnumFontFamiliesExW}
function EnumFontFamiliesEx(hdc: HDC; lpLogFont: LPLOGFONT; lpEnumFontFamExProc: FONTENUMPROC; lParam: LPARAM; dwFlags: DWORD): Integer; stdcall;
{$EXTERNALSYM EnumFontFamiliesEx}

function EnumFontFamiliesA(hdc: HDC; lpszFamily: LPCSTR; lpEnumFontFamProc: FONTENUMPROCA; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFontFamiliesA}
function EnumFontFamiliesW(hdc: HDC; lpszFamily: LPCWSTR; lpEnumFontFamProc: FONTENUMPROCW; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFontFamiliesW}
function EnumFontFamilies(hdc: HDC; lpszFamily: LPCTSTR; lpEnumFontFamProc: FONTENUMPROC; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFontFamilies}

function EnumFontsA(hdc: HDC; lpFaceName: LPCSTR; lpFontFunc: FONTENUMPROCA; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFontsA}
function EnumFontsW(hdc: HDC; lpFaceName: LPCWSTR; lpFontFunc: FONTENUMPROCW; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFontsW}
function EnumFonts(hdc: HDC; lpFaceName: LPCTSTR; lpFontFunc: FONTENUMPROC; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumFonts}

function EnumObjects(hdc: HDC; mObjectType: Integer; lpObjectFunc: GOBJENUMPROC; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumObjects}

function EqualRgn(hSrcRgn1, hSrcRgn2: HRGN): BOOL; stdcall;
{$EXTERNALSYM EqualRgn}
function Escape(hdc: HDC; nEscape, cbInput: Integer; lpvInData: LPCSTR; lpvOutData: LPVOID): Integer; stdcall;
{$EXTERNALSYM Escape}
function ExtEscape(hdc: HDC; nEscape, cbInput: Integer; lpszInData: LPCSTR; cbOutput: Integer; lpszOutData: LPSTR): Integer; stdcall;
{$EXTERNALSYM ExtEscape}
function ExcludeClipRect(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): Integer; stdcall;
{$EXTERNALSYM ExcludeClipRect}
function ExtCreateRegion(lpXForm: LPXFORM; nCount: DWORD; lpRgnData: LPRGNDATA): HRGN; stdcall;
{$EXTERNALSYM ExtCreateRegion}
function ExtFloodFill(hdc: HDC; nXStart, nYStart: Integer; crColor: COLORREF; fuFillType: UINT): BOOL; stdcall;
{$EXTERNALSYM ExtFloodFill}
function FillRgn(hdc: HDC; hrgn: HRGN; hbr: HBRUSH): BOOL; stdcall;
{$EXTERNALSYM FillRgn}
function FloodFill(hdc: HDC; nXStart, nYStart: Integer; crFill: COLORREF): BOOL; stdcall;
{$EXTERNALSYM FloodFill}
function FrameRgn(hdc: HDC; hrgn: HRGN; hbr: HBRUSH; nWidth, nHeight: Integer): BOOL; stdcall;
{$EXTERNALSYM FrameRgn}
function GetROP2(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetROP2}
function GetAspectRatioFilterEx(hdc: HDC; var lpAspectRatio: TSize): BOOL; stdcall;
{$EXTERNALSYM GetAspectRatioFilterEx}
function GetBkColor(hdc: HDC): COLORREF; stdcall;
{$EXTERNALSYM GetBkColor}

function GetDCBrushColor(hdc: HDC): COLORREF; stdcall;
{$EXTERNALSYM GetDCBrushColor}
function GetDCPenColor(hdc: HDC): COLORREF; stdcall;
{$EXTERNALSYM GetDCPenColor}

function GetBkMode(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetBkMode}
function GetBitmapBits(hbmp: HBITMAP; cbBuffer: LONG; lpvBits: LPVOID): LONG; stdcall;
{$EXTERNALSYM GetBitmapBits}
function GetBitmapDimensionEx(hBitmap: HBITMAP; var lpDimension: TSize): BOOL; stdcall;
{$EXTERNALSYM GetBitmapDimensionEx}
function GetBoundsRect(hdc: HDC; var lprcBounds: RECT; flags: UINT): UINT; stdcall;
{$EXTERNALSYM GetBoundsRect}

function GetBrushOrgEx(hdc: HDC; var lppt: POINT): BOOL; stdcall;
{$EXTERNALSYM GetBrushOrgEx}

function GetCharWidthA(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthA}
function GetCharWidthW(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthW}
function GetCharWidth(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidth}
function GetCharWidth32A(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidth32A}
function GetCharWidth32W(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidth32W}
function GetCharWidth32(hdc: HDC; iFirstChar, iLastChar: UINT; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidth32}
function GetCharWidthFloatA(hdc: HDC; iFirstChar, iLastChar: UINT; pxBuffer: PFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthFloatA}
function GetCharWidthFloatW(hdc: HDC; iFirstChar, iLastChar: UINT; pxBuffer: PFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthFloatW}
function GetCharWidthFloat(hdc: HDC; iFirstChar, iLastChar: UINT; pxBuffer: PFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthFloat}
function GetCharABCWidthsA(hdc: HDC; uFirstChar, uLastChar: UINT; lpAbc: LPABC): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsA}
function GetCharABCWidthsW(hdc: HDC; uFirstChar, uLastChar: UINT; lpAbc: LPABC): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsW}
function GetCharABCWidths(hdc: HDC; uFirstChar, uLastChar: UINT; lpAbc: LPABC): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidths}
function GetCharABCWidthsFloatA(hdc: HDC; iFirstChar, iLastChar: UINT; lpAbcF: LPABCFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsFloatA}
function GetCharABCWidthsFloatW(hdc: HDC; iFirstChar, iLastChar: UINT; lpAbcF: LPABCFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsFloatW}
function GetCharABCWidthsFloat(hdc: HDC; iFirstChar, iLastChar: UINT; lpAbcF: LPABCFLOAT): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsFloat}

function GetClipBox(hdc: HDC; var lprc: RECT): Integer; stdcall;
{$EXTERNALSYM GetClipBox}
function GetClipRgn(hdc: HDC; hrgn: HRGN): Integer; stdcall;
{$EXTERNALSYM GetClipRgn}
function GetMetaRgn(hdc: HDC; hrgn: HRGN): Integer; stdcall;
{$EXTERNALSYM GetMetaRgn}
function GetCurrentObject(hdc: HDC; uObjectType: UINT): HGDIOBJ; stdcall;
{$EXTERNALSYM GetCurrentObject}
function GetCurrentPositionEx(hdc: HDC; var lpPoint: POINT): BOOL; stdcall;
{$EXTERNALSYM GetCurrentPositionEx}
function GetDeviceCaps(hdc: HDC; nIndex: Integer): Integer; stdcall;
{$EXTERNALSYM GetDeviceCaps}
function GetDIBits(hdc: HDC; hbmp: HBITMAP; uStartScan, cScanLines: UINT; lpvBits: LPVOID; var lpbi: BITMAPINFO; uUsage: UINT): Integer; stdcall;
{$EXTERNALSYM GetDIBits}
function GetFontData(hdc: HDC; dwTable, dwOffset: DWORD; lpvBuffer: LPVOID; cbData: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetFontData}
function GetGlyphOutlineA(hdc: HDC; uChar, uFormat: UINT; var lpgm: GLYPHMETRICS; cbBuffer: DWORD; lpvBuffer: LPVOID; const lpMat2: MAT2): DWORD; stdcall;
{$EXTERNALSYM GetGlyphOutlineA}
function GetGlyphOutlineW(hdc: HDC; uChar, uFormat: UINT; var lpgm: GLYPHMETRICS; cbBuffer: DWORD; lpvBuffer: LPVOID; const lpMat2: MAT2): DWORD; stdcall;
{$EXTERNALSYM GetGlyphOutlineW}
function GetGlyphOutline(hdc: HDC; uChar, uFormat: UINT; var lpgm: GLYPHMETRICS; cbBuffer: DWORD; lpvBuffer: LPVOID; const lpMat2: MAT2): DWORD; stdcall;
{$EXTERNALSYM GetGlyphOutline}
function GetGraphicsMode(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetGraphicsMode}
function GetMapMode(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetMapMode}
function GetMetaFileBitsEx(hmf: HMETAFILE; nSize: UINT; lpvData: LPVOID): UINT; stdcall;
{$EXTERNALSYM GetMetaFileBitsEx}
function GetMetaFileA(lpszMetaFile: LPCSTR): HMETAFILE; stdcall;
{$EXTERNALSYM GetMetaFileA}
function GetMetaFileW(lpszMetaFile: LPCWSTR): HMETAFILE; stdcall;
{$EXTERNALSYM GetMetaFileW}
function GetMetaFile(lpszMetaFile: LPCTSTR): HMETAFILE; stdcall;
{$EXTERNALSYM GetMetaFile}
function GetNearestColor(hdc: HDC; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM GetNearestColor}
function GetNearestPaletteIndex(hPal: HPALETTE; crColor: COLORREF): UINT; stdcall;
{$EXTERNALSYM GetNearestPaletteIndex}
function GetObjectType(h: HGDIOBJ): DWORD; stdcall;
{$EXTERNALSYM GetObjectType}

function GetOutlineTextMetricsA(hdc: HDC; cbData: UINT; lpOTM: LPOUTLINETEXTMETRICA): UINT; stdcall;
{$EXTERNALSYM GetOutlineTextMetricsA}
function GetOutlineTextMetricsW(hdc: HDC; cbData: UINT; lpOTM: LPOUTLINETEXTMETRICW): UINT; stdcall;
{$EXTERNALSYM GetOutlineTextMetricsW}
function GetOutlineTextMetrics(hdc: HDC; cbData: UINT; lpOTM: LPOUTLINETEXTMETRIC): UINT; stdcall;
{$EXTERNALSYM GetOutlineTextMetrics}
function GetPaletteEntries(hPal: HPALETTE; iStartIndex, nEntries: UINT; lppe: LPPALETTEENTRY): UINT; stdcall;
{$EXTERNALSYM GetPaletteEntries}
function GetPixel(hdc: HDC; nXPos, nYPos: Integer): COLORREF; stdcall;
{$EXTERNALSYM GetPixel}
function GetPixelFormat(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetPixelFormat}
function GetPolyFillMode(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetPolyFillMode}
function GetRasterizerCaps(var lprs: RASTERIZER_STATUS; cb: UINT): BOOL; stdcall;
{$EXTERNALSYM GetRasterizerCaps}
function GetRandomRgn(hdc: HDC; hrgn: HRGN; iNum: Integer): Integer; stdcall;
{$EXTERNALSYM GetRandomRgn}
function GetRegionData(hrgn: HRGN; dwCount: DWORD; lpRgnData: LPRGNDATA): DWORD; stdcall;
{$EXTERNALSYM GetRegionData}
function GetRgnBox(hrgn: HRGN; var lprc: RECT): Integer; stdcall;
{$EXTERNALSYM GetRgnBox}
function GetStockObject(fnObject: Integer): HGDIOBJ; stdcall;
{$EXTERNALSYM GetStockObject}
function GetStretchBltMode(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetStretchBltMode}
function GetSystemPaletteEntries(hdc: HDC; iStartIndex, nEntries: UINT; lppe: LPPALETTEENTRY): UINT; stdcall;
{$EXTERNALSYM GetSystemPaletteEntries}
function GetSystemPaletteUse(hdc: HDC): UINT; stdcall;
{$EXTERNALSYM GetSystemPaletteUse}
function GetTextCharacterExtra(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetTextCharacterExtra}
function GetTextAlign(hdc: HDC): UINT; stdcall;
{$EXTERNALSYM GetTextAlign}
function GetTextColor(hdc: HDC): COLORREF; stdcall;
{$EXTERNALSYM GetTextColor}

function GetTextExtentPointA(hdc: HDC; lpString: LPCSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPointA}
function GetTextExtentPointW(hdc: HDC; lpString: LPCWSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPointW}
function GetTextExtentPoint(hdc: HDC; lpString: LPCTSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPoint}
function GetTextExtentPoint32A(hdc: HDC; lpString: LPCSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPoint32A}
function GetTextExtentPoint32W(hdc: HDC; lpString: LPCWSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPoint32W}
function GetTextExtentPoint32(hdc: HDC; lpString: LPCTSTR; cbString: Integer; var Size: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPoint32}
function GetTextExtentExPointA(hdc: HDC; lpszStr: LPCSTR; cchString, nMaxExtend: Integer; lpnFit, alpDx: LPINT; var lpSize: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentExPointA}
function GetTextExtentExPointW(hdc: HDC; lpszStr: LPCWSTR; cchString, nMaxExtend: Integer; lpnFit, alpDx: LPINT; var lpSize: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentExPointW}
function GetTextExtentExPoint(hdc: HDC; lpszStr: LPCTSTR; cchString, nMaxExtend: Integer; lpnFit, alpDx: LPINT; var lpSize: TSize): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentExPoint}
function GetTextCharset(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetTextCharset}
function GetTextCharsetInfo(hdc: HDC; lpSig: LPFONTSIGNATURE; dwFlags: DWORD): Integer; stdcall;
{$EXTERNALSYM GetTextCharsetInfo}
function TranslateCharsetInfo(lpSrc: LPDWORD; lpCs: LPCHARSETINFO; dwFlags: DWORD): BOOL; stdcall;
{$EXTERNALSYM TranslateCharsetInfo}
function GetFontLanguageInfo(hdc: HDC): DWORD; stdcall;
{$EXTERNALSYM GetFontLanguageInfo}
function GetCharacterPlacementA(hdc: HDC; lpString: LPCSTR; nCount, nMaxExtend: Integer; var lpResults: GCP_RESULTSA; dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetCharacterPlacementA}
function GetCharacterPlacementW(hdc: HDC; lpString: LPCWSTR; nCount, nMaxExtend: Integer; var lpResults: GCP_RESULTSW; dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetCharacterPlacementW}
function GetCharacterPlacement(hdc: HDC; lpString: LPCTSTR; nCount, nMaxExtend: Integer; var lpResults: GCP_RESULTS; dwFlags: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetCharacterPlacement}

type
  PWcRange = ^TWcRange;
  tagWCRANGE = record
    wcLow: WCHAR;
    cGlyphs: USHORT;
  end;
  {$EXTERNALSYM tagWCRANGE}
  WCRANGE = tagWCRANGE;
  {$EXTERNALSYM WCRANGE}
  LPWCRANGE = ^WCRANGE;
  {$EXTERNALSYM LPWCRANGE}
  TWcRange = WCRANGE;

  PGlyphSet = ^TGlyphSet;
  tagGLYPHSET = record
    cbThis: DWORD;
    flAccel: DWORD;
    cGlyphsSupported: DWORD;
    cRanges: DWORD;
    ranges: array [0..0] of WCRANGE;
  end;
  {$EXTERNALSYM tagGLYPHSET}
  GLYPHSET = tagGLYPHSET;
  {$EXTERNALSYM GLYPHSET}
  LPGLYPHSET = ^GLYPHSET;
  {$EXTERNALSYM LPGLYPHSET}
  TGlyphSet = GLYPHSET;

// flAccel flags for the GLYPHSET structure above

const
  GS_8BIT_INDICES = $00000001;
  {$EXTERNALSYM GS_8BIT_INDICES}

// flags for GetGlyphIndices

  GGI_MARK_NONEXISTING_GLYPHS = $0001;
  {$EXTERNALSYM GGI_MARK_NONEXISTING_GLYPHS}

function GetFontUnicodeRanges(hdc: HDC; lpgs: LPGLYPHSET): DWORD; stdcall;
{$EXTERNALSYM GetFontUnicodeRanges}

function GetGlyphIndicesA(hdc: HDC; lpstr: LPCSTR; c: Integer; pgi: LPWORD; fl: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetGlyphIndicesA}
function GetGlyphIndicesW(hdc: HDC; lpstr: LPCWSTR; c: Integer; pgi: LPWORD; fl: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetGlyphIndicesW}
function GetGlyphIndices(hdc: HDC; lpstr: LPCTSTR; c: Integer; pgi: LPWORD; fl: DWORD): DWORD; stdcall;
{$EXTERNALSYM GetGlyphIndices}

function GetTextExtentPointI(hdc: HDC; pgiIn: LPWORD; cgi: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentPointI}
function GetTextExtentExPointI(hdc: HDC; pgiIn: LPWORD; cgi, nMaxExtend: Integer;
  lpnFit, alpDx: LPINT; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM GetTextExtentExPointI}
function GetCharWidthI(hdc: HDC; giFirst, cgi: UINT; pgi: LPWORD; lpBuffer: LPINT): BOOL; stdcall;
{$EXTERNALSYM GetCharWidthI}
function GetCharABCWidthsI(hdc: HDC; giFirst, cgi: UINT; pgi: LPWORD; lpAbc: LPABC): BOOL; stdcall;
{$EXTERNALSYM GetCharABCWidthsI}

const
  STAMP_DESIGNVECTOR = $8000000 + Ord('d') + (Ord('v') shl 8);
  {$EXTERNALSYM STAMP_DESIGNVECTOR}
  STAMP_AXESLIST     = $8000000 + Ord('a') + (Ord('l') shl 8);
  {$EXTERNALSYM STAMP_AXESLIST}
  MM_MAX_NUMAXES     = 16;
  {$EXTERNALSYM MM_MAX_NUMAXES}

type
  PDesignVector = ^TDesignVector;
  tagDESIGNVECTOR = record
    dvReserved: DWORD;
    dvNumAxes: DWORD;
    dvValues: array [0..MM_MAX_NUMAXES - 1] of LONG;
  end;
  {$EXTERNALSYM tagDESIGNVECTOR}
  DESIGNVECTOR = tagDESIGNVECTOR;
  {$EXTERNALSYM DESIGNVECTOR}
  LPDESIGNVECTOR = ^DESIGNVECTOR;
  {$EXTERNALSYM LPDESIGNVECTOR}
  TDesignVector = DESIGNVECTOR;

function AddFontResourceExA(lpszFilename: LPCSTR; fl: DWORD; pdv: PVOID): Integer; stdcall;
{$EXTERNALSYM AddFontResourceExA}
function AddFontResourceExW(lpszFilename: LPCWSTR; fl: DWORD; pdv: PVOID): Integer; stdcall;
{$EXTERNALSYM AddFontResourceExW}
function AddFontResourceEx(lpszFilename: LPCTSTR; fl: DWORD; pdv: PVOID): Integer; stdcall;
{$EXTERNALSYM AddFontResourceEx}

function RemoveFontResourceExA(lpFilename: LPCSTR; fl: DWORD; pdv: PVOID): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResourceExA}
function RemoveFontResourceExW(lpFilename: LPCWSTR; fl: DWORD; pdv: PVOID): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResourceExW}
function RemoveFontResourceEx(lpFilename: LPCTSTR; fl: DWORD; pdv: PVOID): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResourceEx}

function AddFontMemResourceEx(pbFont: PVOID; cbFont: DWORD; pdv: PVOID; pcFonts: LPDWORD): HANDLE; stdcall;
{$EXTERNALSYM AddFontMemResourceEx}
function RemoveFontMemResourceEx(fh: HANDLE): BOOL; stdcall;
{$EXTERNALSYM RemoveFontMemResourceEx}

const
  FR_PRIVATE    = $10;
  {$EXTERNALSYM FR_PRIVATE}
  FR_NOT_ENUM   = $20;
  {$EXTERNALSYM FR_NOT_ENUM}

// The actual size of the DESIGNVECTOR and ENUMLOGFONTEXDV structures
// is determined by dvNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

const
  MM_MAX_AXES_NAMELEN = 16;
  {$EXTERNALSYM MM_MAX_AXES_NAMELEN}

type
  PAxisInfoA = ^TAxisInfoA;
  tagAXISINFOA = record
    axMinValue: LONG;
    axMaxValue: LONG;
    axAxisName: array [0..MM_MAX_AXES_NAMELEN - 1] of BYTE;
  end;
  {$EXTERNALSYM tagAXISINFOA}
  AXISINFOA = tagAXISINFOA;
  {$EXTERNALSYM AXISINFOA}
  LPAXISINFOA = ^AXISINFOA;
  {$EXTERNALSYM LPAXISINFOA}
  TAxisInfoA = AXISINFOA;

  PAxisInfoW = ^TAxisInfoW;
  tagAXISINFOW = record
    axMinValue: LONG;
    axMaxValue: LONG;
    axAxisName: array [0..MM_MAX_AXES_NAMELEN - 1] of WCHAR;
  end;
  {$EXTERNALSYM tagAXISINFOW}
  AXISINFOW = tagAXISINFOW;
  {$EXTERNALSYM AXISINFOW}
  LPAXISINFOW = ^AXISINFOW;
  {$EXTERNALSYM LPAXISINFOW}
  TAxisInfoW = AXISINFOW;

  {$IFDEF UNICODE}
  AXISINFO = AXISINFOW;
  {$EXTERNALSYM AXISINFO}
  PAXISINFO = PAXISINFOW;
  {$EXTERNALSYM PAXISINFO}
  LPAXISINFO = LPAXISINFOW;
  {$EXTERNALSYM LPAXISINFO}
  TAxisInfo = TAxisInfoW;
  {$ELSE}
  AXISINFO = AXISINFOA;
  {$EXTERNALSYM AXISINFO}
  PAXISINFO = PAXISINFOA;
  {$EXTERNALSYM PAXISINFO}
  LPAXISINFO = LPAXISINFOA;
  {$EXTERNALSYM LPAXISINFO}
  TAxisInfo = TAxisInfoA;
  {$ENDIF UNICODE}

  PAxesListA = ^TAxesListA;
  tagAXESLISTA = record
    axlReserved: DWORD;
    axlNumAxes: DWORD;
    axlAxisInfo: array [0..MM_MAX_NUMAXES - 1] of AXISINFOA;
  end;
  {$EXTERNALSYM tagAXESLISTA}
  AXESLISTA = tagAXESLISTA;
  {$EXTERNALSYM AXESLISTA}
  LPAXESLISTA = ^AXESLISTA;
  {$EXTERNALSYM LPAXESLISTA}
  TAxesListA = tagAXESLISTA;

  PAxesListW = ^TAxesListW;
  tagAXESLISTW = record
    axlReserved: DWORD;
    axlNumAxes: DWORD;
    axlAxisInfo: array [0..MM_MAX_NUMAXES - 1] of AXISINFOW;
  end;
  {$EXTERNALSYM tagAXESLISTW}
  AXESLISTW = tagAXESLISTW;
  {$EXTERNALSYM AXESLISTW}
  LPAXESLISTW = ^AXESLISTW;
  {$EXTERNALSYM LPAXESLISTW}
  TAxesListW = tagAXESLISTW;

  {$IFDEF UNICODE}
  AXESLIST = AXESLISTW;
  {$EXTERNALSYM AXESLIST}
  PAXESLIST = PAXESLISTW;
  {$EXTERNALSYM PAXESLIST}
  LPAXESLIST = LPAXESLISTW;
  {$EXTERNALSYM LPAXESLIST}
  TAxesList = TAxesListW;
  {$ELSE}
  AXESLIST = AXESLISTA;
  {$EXTERNALSYM AXESLIST}
  PAXESLIST = PAXESLISTA;
  {$EXTERNALSYM PAXESLIST}
  LPAXESLIST = LPAXESLISTA;
  {$EXTERNALSYM LPAXESLIST}
  TAxesList = TAxesListA;
  {$ENDIF UNICODE}

// The actual size of the AXESLIST and ENUMTEXTMETRIC structure is
// determined by axlNumAxes,
// MM_MAX_NUMAXES only detemines the maximal size allowed

  PEnumLogFontExDVA = ^TEnumLogFontExDVA;
  tagENUMLOGFONTEXDVA = record
    elfEnumLogfontEx: ENUMLOGFONTEXA;
    elfDesignVector: DESIGNVECTOR;
  end;
  {$EXTERNALSYM tagENUMLOGFONTEXDVA}
  ENUMLOGFONTEXDVA = tagENUMLOGFONTEXDVA;
  {$EXTERNALSYM ENUMLOGFONTEXDVA}
  LPENUMLOGFONTEXDVA = ^ENUMLOGFONTEXDVA;
  {$EXTERNALSYM LPENUMLOGFONTEXDVA}
  TEnumLogFontExDVA = tagENUMLOGFONTEXDVA;

  PEnumLogFontExDVW = ^TEnumLogFontExDVW;
  tagENUMLOGFONTEXDVW = record
    elfEnumLogfontEx: ENUMLOGFONTEXW;
    elfDesignVector: DESIGNVECTOR;
  end;
  {$EXTERNALSYM tagENUMLOGFONTEXDVw}
  ENUMLOGFONTEXDVW = tagENUMLOGFONTEXDVW;
  {$EXTERNALSYM ENUMLOGFONTEXDVW}
  LPENUMLOGFONTEXDVW = ^ENUMLOGFONTEXDVW;
  {$EXTERNALSYM LPENUMLOGFONTEXDVW}
  TEnumLogFontExDVW = tagENUMLOGFONTEXDVW;

  {$IFDEF UNICODE}
  ENUMLOGFONTEXDV = ENUMLOGFONTEXDVW;
  {$EXTERNALSYM ENUMLOGFONTEXDV}
  PENUMLOGFONTEXDV = PENUMLOGFONTEXDVW;
  {$EXTERNALSYM PENUMLOGFONTEXDV}
  LPENUMLOGFONTEXDV = LPENUMLOGFONTEXDVW;
  {$EXTERNALSYM LPENUMLOGFONTEXDV}
  TEnumLogFontExDV = TEnumLogFontExDVW;
  {$ELSE}
  ENUMLOGFONTEXDV = ENUMLOGFONTEXDVA;
  {$EXTERNALSYM ENUMLOGFONTEXDV}
  PENUMLOGFONTEXDV = PENUMLOGFONTEXDVA;
  {$EXTERNALSYM PENUMLOGFONTEXDV}
  LPENUMLOGFONTEXDV = LPENUMLOGFONTEXDVA;
  {$EXTERNALSYM LPENUMLOGFONTEXDV}
  TEnumLogFontExDV = TEnumLogFontExDVA;
  {$ENDIF UNICODE}

function CreateFontIndirectExA(penumlfex: LPENUMLOGFONTEXDVA): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirectExA}
function CreateFontIndirectExW(penumlfex: LPENUMLOGFONTEXDVW): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirectExW}
function CreateFontIndirectEx(penumlfex: LPENUMLOGFONTEXDV): HFONT; stdcall;
{$EXTERNALSYM CreateFontIndirectEx}

type
  PEnumTextMetricA = ^TEnumTextMetricA;
  tagENUMTEXTMETRICA = record
    etmNewTextMetricEx: NEWTEXTMETRICEXA;
    etmAxesList: AXESLISTA;
  end;
  {$EXTERNALSYM tagENUMTEXTMETRICA}
  ENUMTEXTMETRICA = tagENUMTEXTMETRICA;
  {$EXTERNALSYM ENUMTEXTMETRICA}
  LPENUMTEXTMETRICA = ^ENUMTEXTMETRICA;
  {$EXTERNALSYM LPENUMTEXTMETRICA}
  TEnumTextMetricA = tagENUMTEXTMETRICA;

  PEnumTextMetricW = ^TEnumTextMetricW;
  tagENUMTEXTMETRICW = record
    etmNewTextMetricEx: NEWTEXTMETRICEXW;
    etmAxesList: AXESLISTW;
  end;
  {$EXTERNALSYM tagENUMTEXTMETRICW}
  ENUMTEXTMETRICW = tagENUMTEXTMETRICW;
  {$EXTERNALSYM ENUMTEXTMETRICW}
  LPENUMTEXTMETRICW = ^ENUMTEXTMETRICW;
  {$EXTERNALSYM LPENUMTEXTMETRICW}
  TEnumTextMetricW = tagENUMTEXTMETRICW;

  {$IFDEF UNICODE}
  ENUMTEXTMETRIC = ENUMTEXTMETRICW;
  {$EXTERNALSYM ENUMTEXTMETRIC}
  PENUMTEXTMETRIC = PENUMTEXTMETRICW;
  {$EXTERNALSYM PENUMTEXTMETRIC}
  LPENUMTEXTMETRIC = LPENUMTEXTMETRICW;
  {$EXTERNALSYM LPENUMTEXTMETRIC}
  TEnumTextMetric = TEnumTextMetricW;
  {$ELSE}
  ENUMTEXTMETRIC = ENUMTEXTMETRICA;
  {$EXTERNALSYM ENUMTEXTMETRIC}
  PENUMTEXTMETRIC = PENUMTEXTMETRICA;
  {$EXTERNALSYM PENUMTEXTMETRIC}
  LPENUMTEXTMETRIC = LPENUMTEXTMETRICA;
  {$EXTERNALSYM LPENUMTEXTMETRIC}
  TEnumTextMetric = TEnumTextMetricA;
  {$ENDIF UNICODE}

function GetViewportExtEx(hdc: HDC; var lpSize: TSize): BOOL; stdcall;
{$EXTERNALSYM GetViewportExtEx}
function GetViewportOrgEx(hdc: HDC; var lpPoint: POINT): BOOL; stdcall;
{$EXTERNALSYM GetViewportOrgEx}
function GetWindowExtEx(hdc: HDC; var lpSize: TSize): BOOL; stdcall;
{$EXTERNALSYM GetWindowExtEx}
function GetWindowOrgEx(hdc: HDC; var lpPoint: POINT): BOOL; stdcall;
{$EXTERNALSYM GetWindowOrgEx}

function IntersectClipRect(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): Integer; stdcall;
{$EXTERNALSYM IntersectClipRect}
function InvertRgn(hdc: HDC; hrgn: HRGN): BOOL; stdcall;
{$EXTERNALSYM InvertRgn}
function LineDDA(nXStart, nYStart, nXEnd, nYEnd: Integer; lpLineFunc: LINEDDAPROC; lpData: LPARAM): BOOL; stdcall;
{$EXTERNALSYM LineDDA}
function LineTo(hdc: HDC; nXEnd, nYEnd: Integer): BOOL; stdcall;
{$EXTERNALSYM LineTo}
function MaskBlt(hdc: HDC; nXDest, nYDest, nWidth, nHeight: Integer; hdcSrc: HDC; nXSrc, nYSrc: Integer; hbmMask: HBITMAP; xMask, yMask: Integer; dwRop: DWORD): BOOL; stdcall;
{$EXTERNALSYM MaskBlt}
function PlgBlt(hdc: HDC; lpPoint: LPPOINT; hdcSrc: HDC; nXSrc, nYSrc, nWidth, nHeight: Integer; hbmMask: HBITMAP; xMask, yMask: Integer): BOOL; stdcall;
{$EXTERNALSYM PlgBlt}

function OffsetClipRgn(hdc: HDC; nXOffset, nYOffset: Integer): Integer; stdcall;
{$EXTERNALSYM OffsetClipRgn}
function OffsetRgn(hrgn: HRGN; nXOffset, nYOffset: Integer): Integer; stdcall;
{$EXTERNALSYM OffsetRgn}
function PatBlt(hdc: HDC; nXLeft, nYLeft, nWidth, nHeight: Integer; dwRop: DWORD): BOOL; stdcall;
{$EXTERNALSYM PatBlt}
function Pie(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2: Integer): BOOL; stdcall;
{$EXTERNALSYM Pie}
function PlayMetaFile(hdc: HDC; hmf: HMETAFILE): BOOL; stdcall;
{$EXTERNALSYM PlayMetaFile}
function PaintRgn(hdc: HDC; hrgn: HRGN): BOOL; stdcall;
{$EXTERNALSYM PaintRgn}
function PolyPolygon(hdc: HDC; lpPoints: LPPOINT; lpPolyCounts: LPINT; nCount: Integer): BOOL; stdcall;
{$EXTERNALSYM PolyPolygon}
function PtInRegion(hrgn: HRGN; X, Y: Integer): BOOL; stdcall;
{$EXTERNALSYM PtInRegion}
function PtVisible(hdc: HDC; X, Y: Integer): BOOL; stdcall;
{$EXTERNALSYM PtVisible}
function RectInRegion(hrgn: HRGN; const lprc: RECT): BOOL; stdcall;
{$EXTERNALSYM RectInRegion}
function RectVisible(hdc: HDC; const lprc: RECT): BOOL; stdcall;
{$EXTERNALSYM RectVisible}
function Rectangle(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): BOOL; stdcall;
{$EXTERNALSYM Rectangle}
function RestoreDC(hdc: HDC; nSavedDc: Integer): BOOL; stdcall;
{$EXTERNALSYM RestoreDC}
function ResetDCA(hdc: HDC; const lpInitData: DEVMODEA): HDC; stdcall;
{$EXTERNALSYM ResetDCA}
function ResetDCW(hdc: HDC; const lpInitData: DEVMODEW): HDC; stdcall;
{$EXTERNALSYM ResetDCW}
function ResetDC(hdc: HDC; const lpInitData: DEVMODE): HDC; stdcall;
{$EXTERNALSYM ResetDC}
function RealizePalette(hdc: HDC): UINT; stdcall;
{$EXTERNALSYM RealizePalette}
function RemoveFontResourceA(lpFileName: LPCSTR): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResourceA}
function RemoveFontResourceW(lpFileName: LPCWSTR): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResourceW}
function RemoveFontResource(lpFileName: LPCTSTR): BOOL; stdcall;
{$EXTERNALSYM RemoveFontResource}
function RoundRect(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect, nWidth, nHeight: Integer): BOOL; stdcall;
{$EXTERNALSYM RoundRect}
function ResizePalette(hPal: HPALETTE; nEntries: UINT): BOOL; stdcall;
{$EXTERNALSYM ResizePalette}
function SaveDC(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM SaveDC}
function SelectClipRgn(hdc: HDC; hrgn: HRGN): Integer; stdcall;
{$EXTERNALSYM SelectClipRgn}
function ExtSelectClipRgn(hdc: HDC; hrgn: HRGN; fnMode: Integer): Integer; stdcall;
{$EXTERNALSYM ExtSelectClipRgn}
function SetMetaRgn(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM SetMetaRgn}
function SelectObject(hdc: HDC; hgdiobj: HGDIOBJ): HGDIOBJ; stdcall;
{$EXTERNALSYM SelectObject}
function SelectPalette(hdc: HDC; hpal: HPALETTE; nForceBackground: BOOL): HPALETTE; stdcall;
{$EXTERNALSYM SelectPalette}
function SetBkColor(hdc: HDC; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM SetBkColor}

function SetDCBrushColor(hdc: HDC; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM SetDCBrushColor}
function SetDCPenColor(hdc: HDC; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM SetDCPenColor}

function SetBkMode(hdc: HDC; iBlMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetBkMode}
function SetBitmapBits(hbmp: HBITMAP; cBytes: DWORD; lpBits: LPVOID): LONG; stdcall;
{$EXTERNALSYM SetBitmapBits}

function SetBoundsRect(hdc: HDC; lprcBounds: LPRECT; flags: UINT): UINT; stdcall;
{$EXTERNALSYM SetBoundsRect}
function SetDIBits(hdc: HDC; hbmp: HBITMAP; uStartScan, cScanLines: UINT; lpvBits: LPVOID; const lpbmi: BITMAPINFO; fuColorUse: UINT): Integer; stdcall;
{$EXTERNALSYM SetDIBits}
function SetDIBitsToDevice(hdc: HDC; xDest, yDest: Integer; dwWidth, dwHeight: DWORD; XSrc, YSrc: Integer; uStartScan, cScanLines: UINT; lpvBits: LPVOID; const lpbmi: BITMAPINFO; fuColorUse: UINT): Integer; stdcall;
{$EXTERNALSYM SetDIBitsToDevice}
function SetMapperFlags(hdc: HDC; dwFlag: DWORD): DWORD; stdcall;
{$EXTERNALSYM SetMapperFlags}
function SetGraphicsMode(hdc: HDC; iMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetGraphicsMode}
function SetMapMode(hdc: HDC; fnMapMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetMapMode}

function SetLayout(hdc: HDC; dwLayOut: DWORD): DWORD; stdcall;
{$EXTERNALSYM SetLayout}
function GetLayout(hdc: HDC): DWORD; stdcall;
{$EXTERNALSYM GetLayout}

function SetMetaFileBitsEx(nSize: UINT; lpData: LPBYTE): HMETAFILE; stdcall;
{$EXTERNALSYM SetMetaFileBitsEx}
function SetPaletteEntries(hPal: HPALETTE; cStart, nEntries: UINT; lppe: LPPALETTEENTRY): UINT; stdcall;
{$EXTERNALSYM SetPaletteEntries}
function SetPixel(hdc: HDC; X, Y: Integer; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM SetPixel}
function SetPixelV(hdc: HDC; X, Y: Integer; crColor: COLORREF): BOOL; stdcall;
{$EXTERNALSYM SetPixelV}
function SetPixelFormat(hdc: HDC; iPixelFormat: Integer; const ppfd: PIXELFORMATDESCRIPTOR): BOOL; stdcall;
{$EXTERNALSYM SetPixelFormat}
function SetPolyFillMode(hdc: HDC; iPolyFillMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetPolyFillMode}
function StretchBlt(hdc: HDC; nXOriginDest, nYOriginDest, nWidthDest, nHeightDest: Integer; hdcSrc: HDC; nXOriginSrc, nYOriginSrc, nWidthSrc, nHeightSrc: Integer; dwRop: DWORD): BOOL; stdcall;
{$EXTERNALSYM StretchBlt}
function SetRectRgn(hrgn: HRGN; nLeftRect, nTopRect, nRightRect, nBottomRect: Integer): BOOL; stdcall;
{$EXTERNALSYM SetRectRgn}
function StretchDIBits(hdc: HDC; XDest, YDest, nDestWidth, nYDestHeight, XSrc, YSrc, nSrcWidth, nSrcHeight: Integer; lpBits: LPVOID; const lpBitsInfo: BITMAPINFO; iUsage: UINT; dwRop: DWORD): Integer; stdcall;
{$EXTERNALSYM StretchDIBits}
function SetROP2(hdc: HDC; fnDrawMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetROP2}
function SetStretchBltMode(hdc: HDC; iStretchMode: Integer): Integer; stdcall;
{$EXTERNALSYM SetStretchBltMode}
function SetSystemPaletteUse(hdc: HDC; uUsage: UINT): UINT; stdcall;
{$EXTERNALSYM SetSystemPaletteUse}
function SetTextCharacterExtra(hdc: HDC; nCharExtra: Integer): Integer; stdcall;
{$EXTERNALSYM SetTextCharacterExtra}
function SetTextColor(hdc: HDC; crColor: COLORREF): COLORREF; stdcall;
{$EXTERNALSYM SetTextColor}
function SetTextAlign(hdc: HDC; fMode: UINT): UINT; stdcall;
{$EXTERNALSYM SetTextAlign}
function SetTextJustification(hdc: HDC; nBreakExtra, nBreakCount: Integer): BOOL; stdcall;
{$EXTERNALSYM SetTextJustification}
function UpdateColors(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM UpdateColors}

//
// image blt
//

type
  COLOR16 = USHORT;
  {$EXTERNALSYM COLOR16}

  PTriVertex = ^TTriVertex;
  _TRIVERTEX = record
    x: LONG;
    y: LONG;
    Red: COLOR16;
    Green: COLOR16;
    Blue: COLOR16;
    Alpha: COLOR16;
  end;
  {$EXTERNALSYM _TRIVERTEX}
  TRIVERTEX = _TRIVERTEX;
  {$EXTERNALSYM TRIVERTEX}
  LPTRIVERTEX = ^TRIVERTEX;
  {$EXTERNALSYM LPTRIVERTEX}
  TTriVertex = _TRIVERTEX;

  PGradientTriangle = ^TGradientTriangle;
  _GRADIENT_TRIANGLE = record
    Vertex1: ULONG;
    Vertex2: ULONG;
    Vertex3: ULONG;
  end;
  {$EXTERNALSYM _GRADIENT_TRIANGLE}
  GRADIENT_TRIANGLE = _GRADIENT_TRIANGLE;
  {$EXTERNALSYM GRADIENT_TRIANGLE}
  LPGRADIENT_TRIANGLE = ^GRADIENT_TRIANGLE;
  {$EXTERNALSYM LPGRADIENT_TRIANGLE}
  PGRADIENT_TRIANGLE = ^GRADIENT_TRIANGLE;
  {$EXTERNALSYM PGRADIENT_TRIANGLE}
  TGradientTriangle = _GRADIENT_TRIANGLE;

  PGradientRect = ^TGradientRect;
  _GRADIENT_RECT = record
    UpperLeft: ULONG;
    LowerRight: ULONG;
  end;
  {$EXTERNALSYM _GRADIENT_RECT}
  GRADIENT_RECT = _GRADIENT_RECT;
  {$EXTERNALSYM GRADIENT_RECT}
  LPGRADIENT_RECT = ^GRADIENT_RECT;
  {$EXTERNALSYM LPGRADIENT_RECT}
  PGRADIENT_RECT = ^GRADIENT_RECT;
  {$EXTERNALSYM PGRADIENT_RECT}
  TGradientRect = _GRADIENT_RECT;

  PBlendFunction = ^TBlendFunction;
  _BLENDFUNCTION = record
    BlendOp: BYTE;
    BlendFlags: BYTE;
    SourceConstantAlpha: BYTE;
    AlphaFormat: BYTE;
  end;
  {$EXTERNALSYM _BLENDFUNCTION}
  BLENDFUNCTION = _BLENDFUNCTION;
  {$EXTERNALSYM BLENDFUNCTION}
  LPBLENDFUNCTION = ^BLENDFUNCTION;
  {$EXTERNALSYM LPBLENDFUNCTION}
  TBlendFunction = _BLENDFUNCTION;

//
// currentlly defined blend function
//

const
  AC_SRC_OVER = $00;
  {$EXTERNALSYM AC_SRC_OVER}

//
// alpha format flags
//

  AC_SRC_ALPHA = $01;
  {$EXTERNALSYM AC_SRC_ALPHA}

function AlphaBlend(hdcDest: HDC; nXOriginDest, nYOriginDest, nWidthDest,
  nHeightDest: Integer; hdcSrc: HDC; nXOriginSrc, nYOriginSrc, nWidthSrc,
  nHeightSrc: Integer; blendFunction: BLENDFUNCTION): BOOL; stdcall;
{$EXTERNALSYM AlphaBlend}

function TransparentBlt(hdcSrc: HDC; nXOriginSrc, nYOriginSrc, nWidthSrc,
  nHeightSrc: Integer; hdcDest: HDC; nXOriginDest, nYOriginDest, nWidthDest,
  nHeightDest: Integer; blendFunction: BLENDFUNCTION): BOOL; stdcall;
{$EXTERNALSYM TransparentBlt}

//
// gradient drawing modes
//

const
  GRADIENT_FILL_RECT_H   = $00000000;
  {$EXTERNALSYM GRADIENT_FILL_RECT_H}
  GRADIENT_FILL_RECT_V   = $00000001;
  {$EXTERNALSYM GRADIENT_FILL_RECT_V}
  GRADIENT_FILL_TRIANGLE = $00000002;
  {$EXTERNALSYM GRADIENT_FILL_TRIANGLE}
  GRADIENT_FILL_OP_FLAG  = $000000ff;
  {$EXTERNALSYM GRADIENT_FILL_OP_FLAG}

function GradientFill(hdc: HDC; pVertex: PTRIVERTEX; dwNumVertex: ULONG; pMesh: PVOID; dwNumMesh, dwMode: ULONG): BOOL; stdcall;
{$EXTERNALSYM GradientFill}
function PlayMetaFileRecord(hdc: HDC; lpHandleTable: LPHANDLETABLE; lpMetaRecord: LPMETARECORD; nHandles: UINT): BOOL; stdcall;
{$EXTERNALSYM PlayMetaFileRecord}

type
  MFENUMPROC = function(hdc: HDC; lpHTable: LPHANDLETABLE; lpMFR: LPMETARECORD; nObj: Integer; lpClientData: LPARAM): Integer; stdcall;
  {$EXTERNALSYM MFENUMPROC}

function EnumMetaFile(hdc: HDC; hemf: HMETAFILE; lpMetaFunc: MFENUMPROC; lParam: LPARAM): BOOL; stdcall;
{$EXTERNALSYM EnumMetaFile}

type
  ENHMFENUMPROC = function(hdc: HDC; lpHTable: LPHANDLETABLE; lpEMFR: LPENHMETARECORD; nObj: Integer; lpData: LPARAM): Integer; stdcall;
  {$EXTERNALSYM ENHMFENUMPROC}

// Enhanced Metafile Function Declarations

function CloseEnhMetaFile(hdc: HDC): HENHMETAFILE; stdcall;
{$EXTERNALSYM CloseEnhMetaFile}
function CopyEnhMetaFileA(hemfSrc: HENHMETAFILE; lpszFile: LPCSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM CopyEnhMetaFileA}
function CopyEnhMetaFileW(hemfSrc: HENHMETAFILE; lpszFile: LPCWSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM CopyEnhMetaFileW}
function CopyEnhMetaFile(hemfSrc: HENHMETAFILE; lpszFile: LPCTSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM CopyEnhMetaFile}
function CreateEnhMetaFileA(hdcRef: HDC; lpFileName: LPCSTR; const lpRect: RECT; lpDescription: LPCSTR): HDC; stdcall;
{$EXTERNALSYM CreateEnhMetaFileA}
function CreateEnhMetaFileW(hdcRef: HDC; lpFileName: LPCWSTR; const lpRect: RECT; lpDescription: LPCWSTR): HDC; stdcall;
{$EXTERNALSYM CreateEnhMetaFileW}
function CreateEnhMetaFile(hdcRef: HDC; lpFileName: LPCTSTR; const lpRect: RECT; lpDescription: LPCTSTR): HDC; stdcall;
{$EXTERNALSYM CreateEnhMetaFile}

function DeleteEnhMetaFile(hemf: HENHMETAFILE): BOOL; stdcall;
{$EXTERNALSYM DeleteEnhMetaFile}
function EnumEnhMetaFile(hdc: HDC; hemf: HENHMETAFILE; lpEnhMetaFunc: ENHMFENUMPROC; lpData: LPVOID; const lpRect: RECT): BOOL; stdcall;
{$EXTERNALSYM EnumEnhMetaFile}
function GetEnhMetaFileA(lpszMetaFile: LPCSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM GetEnhMetaFileA}
function GetEnhMetaFileW(lpszMetaFile: LPCWSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM GetEnhMetaFileW}
function GetEnhMetaFile(lpszMetaFile: LPCTSTR): HENHMETAFILE; stdcall;
{$EXTERNALSYM GetEnhMetaFile}
function GetEnhMetaFileBits(hemf: HENHMETAFILE; cbBuffer: UINT; lpBuffer: LPBYTE): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFileBits}
function GetEnhMetaFileDescriptionA(hemf: HENHMETAFILE; cchBuffer: UINT; lpszDescription: LPSTR): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFileDescriptionA}
function GetEnhMetaFileDescriptionW(hemf: HENHMETAFILE; cchBuffer: UINT; lpszDescription: LPWSTR): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFileDescriptionW}
function GetEnhMetaFileDescription(hemf: HENHMETAFILE; cchBuffer: UINT; lpszDescription: LPTSTR): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFileDescription}
function GetEnhMetaFileHeader(hemf: HENHMETAFILE; cbBuffer: UINT; lpemh: LPENHMETAHEADER ): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFileHeader}
function GetEnhMetaFilePaletteEntries(hemf: HENHMETAFILE; cEntries: UINT; lppe: LPPALETTEENTRY ): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFilePaletteEntries}
function GetEnhMetaFilePixelFormat(hemf: HENHMETAFILE; cbBuffer: UINT; var ppfd: PIXELFORMATDESCRIPTOR): UINT; stdcall;
{$EXTERNALSYM GetEnhMetaFilePixelFormat}
function GetWinMetaFileBits(hemf: HENHMETAFILE; cbBuffer: UINT; lpbBuffer: LPBYTE; fnMapMode: Integer; hdcRef: HDC): UINT; stdcall;
{$EXTERNALSYM GetWinMetaFileBits}
function PlayEnhMetaFile(hdc: HDC; hemf: HENHMETAFILE; const lpRect: RECT): BOOL; stdcall;
{$EXTERNALSYM PlayEnhMetaFile}
function PlayEnhMetaFileRecord(hdc: HDC; lpHandleTable: LPHANDLETABLE; lpEnhMetaRecord: LPENHMETARECORD; nHandles: UINT): BOOL; stdcall;
{$EXTERNALSYM PlayEnhMetaFileRecord}
function SetEnhMetaFileBits(cbBuffer: UINT; lpData: LPBYTE): HENHMETAFILE; stdcall;
{$EXTERNALSYM SetEnhMetaFileBits}
function SetWinMetaFileBits(cbBuffer: UINT; lpbBuffer: LPBYTE; hdcRef: HDC; const lpmfp: METAFILEPICT): HENHMETAFILE; stdcall;
{$EXTERNALSYM SetWinMetaFileBits}
function GdiComment(hdc: HDC; cbSize: UINT; lpData: LPBYTE): BOOL; stdcall;
{$EXTERNALSYM GdiComment}

function GetTextMetricsA(hdc: HDC; var lptm: TEXTMETRICA): BOOL; stdcall;
{$EXTERNALSYM GetTextMetricsA}
function GetTextMetricsW(hdc: HDC; var lptm: TEXTMETRICW): BOOL; stdcall;
{$EXTERNALSYM GetTextMetricsW}
function GetTextMetrics(hdc: HDC; var lptm: TEXTMETRIC): BOOL; stdcall;
{$EXTERNALSYM GetTextMetrics}

// new GDI

type
  PDibSection = ^TDibSection;
  tagDIBSECTION = record
    dsBm: BITMAP;
    dsBmih: BITMAPINFOHEADER;
    dsBitfields: array [0..2] of DWORD;
    dshSection: HANDLE;
    dsOffset: DWORD;
  end;
  {$EXTERNALSYM tagDIBSECTION}
  DIBSECTION = tagDIBSECTION;
  {$EXTERNALSYM DIBSECTION}
  LPDIBSECTION = ^DIBSECTION;
  {$EXTERNALSYM LPDIBSECTION}
  TDibSection = DIBSECTION;

function AngleArc(hdc: HDC; X, Y: Integer; dwRadius: DWORD; eStartAngle, eSweepAngle: FLOAT): BOOL; stdcall;
{$EXTERNALSYM AngleArc}
function PolyPolyline(hdc: HDC; lppt: LPPOINT; lpdwPolyPoints: LPDWORD; cCount: DWORD): BOOL; stdcall;
{$EXTERNALSYM PolyPolyline}
function GetWorldTransform(hdc: HDC; lpXform: LPXFORM): BOOL; stdcall;
{$EXTERNALSYM GetWorldTransform}
function SetWorldTransform(hdc: HDC; lpXform: LPXFORM): BOOL; stdcall;
{$EXTERNALSYM SetWorldTransform}
function ModifyWorldTransform(hdc: HDC; lpXform: LPXFORM; iMode: DWORD): BOOL; stdcall;
{$EXTERNALSYM ModifyWorldTransform}
function CombineTransform(lpxformResult, lpXform1, lpXform2: LPXFORM): BOOL; stdcall;
{$EXTERNALSYM CombineTransform}
function CreateDIBSection(hdc: HDC; pbmi: LPBITMAPINFO; iUsage: UINT;
  ppvBits: PPVOID; hSection: HANDLE; dwOffset: DWORD): HBITMAP; stdcall;
{$EXTERNALSYM CreateDIBSection}
function GetDIBColorTable(hdc: HDC; uStartIndex, cEntries: UINT; pColors: PRGBQUAD): UINT; stdcall;
{$EXTERNALSYM GetDIBColorTable}
function SetDIBColorTable(hdc: HDC; uStartIndex, cEntries: UINT; pColors: PRGBQUAD): UINT; stdcall;
{$EXTERNALSYM SetDIBColorTable}

// Flags value for COLORADJUSTMENT

const
  CA_NEGATIVE   = $0001;
  {$EXTERNALSYM CA_NEGATIVE}
  CA_LOG_FILTER = $0002;
  {$EXTERNALSYM CA_LOG_FILTER}

// IlluminantIndex values

  ILLUMINANT_DEVICE_DEFAULT = 0;
  {$EXTERNALSYM ILLUMINANT_DEVICE_DEFAULT}
  ILLUMINANT_A              = 1;
  {$EXTERNALSYM ILLUMINANT_A}
  ILLUMINANT_B              = 2;
  {$EXTERNALSYM ILLUMINANT_B}
  ILLUMINANT_C              = 3;
  {$EXTERNALSYM ILLUMINANT_C}
  ILLUMINANT_D50            = 4;
  {$EXTERNALSYM ILLUMINANT_D50}
  ILLUMINANT_D55            = 5;
  {$EXTERNALSYM ILLUMINANT_D55}
  ILLUMINANT_D65            = 6;
  {$EXTERNALSYM ILLUMINANT_D65}
  ILLUMINANT_D75            = 7;
  {$EXTERNALSYM ILLUMINANT_D75}
  ILLUMINANT_F2             = 8;
  {$EXTERNALSYM ILLUMINANT_F2}
  ILLUMINANT_MAX_INDEX      = ILLUMINANT_F2;
  {$EXTERNALSYM ILLUMINANT_MAX_INDEX}

  ILLUMINANT_TUNGSTEN    = ILLUMINANT_A;
  {$EXTERNALSYM ILLUMINANT_TUNGSTEN}
  ILLUMINANT_DAYLIGHT    = ILLUMINANT_C;
  {$EXTERNALSYM ILLUMINANT_DAYLIGHT}
  ILLUMINANT_FLUORESCENT = ILLUMINANT_F2;
  {$EXTERNALSYM ILLUMINANT_FLUORESCENT}
  ILLUMINANT_NTSC        = ILLUMINANT_C;
  {$EXTERNALSYM ILLUMINANT_NTSC}

// Min and max for RedGamma, GreenGamma, BlueGamma

  RGB_GAMMA_MIN = WORD(02500);
  {$EXTERNALSYM RGB_GAMMA_MIN}
  RGB_GAMMA_MAX = WORD(65000);
  {$EXTERNALSYM RGB_GAMMA_MAX}

// Min and max for ReferenceBlack and ReferenceWhite

  REFERENCE_WHITE_MIN = WORD(6000);
  {$EXTERNALSYM REFERENCE_WHITE_MIN}
  REFERENCE_WHITE_MAX = WORD(10000);
  {$EXTERNALSYM REFERENCE_WHITE_MAX}
  REFERENCE_BLACK_MIN = WORD(0);
  {$EXTERNALSYM REFERENCE_BLACK_MIN}
  REFERENCE_BLACK_MAX = WORD(4000);
  {$EXTERNALSYM REFERENCE_BLACK_MAX}

// Min and max for Contrast, Brightness, Colorfulness, RedGreenTint

  COLOR_ADJ_MIN = SHORT(-100);
  {$EXTERNALSYM COLOR_ADJ_MIN}
  COLOR_ADJ_MAX = SHORT(100);
  {$EXTERNALSYM COLOR_ADJ_MAX}

type
  PColorAdjustment = ^TColorAdjustment;
  tagCOLORADJUSTMENT = record
    caSize: WORD;
    caFlags: WORD;
    caIlluminantIndex: WORD;
    caRedGamma: WORD;
    caGreenGamma: WORD;
    caBlueGamma: WORD;
    caReferenceBlack: WORD;
    caReferenceWhite: WORD;
    caContrast: SHORT;
    caBrightness: SHORT;
    caColorfulness: SHORT;
    caRedGreenTint: SHORT;
  end;
  {$EXTERNALSYM tagCOLORADJUSTMENT}
  COLORADJUSTMENT = tagCOLORADJUSTMENT;
  {$EXTERNALSYM COLORADJUSTMENT}
  LPCOLORADJUSTMENT = ^COLORADJUSTMENT;
  {$EXTERNALSYM LPCOLORADJUSTMENT}
  TColorAdjustment = COLORADJUSTMENT;

function SetColorAdjustment(hdc: HDC; lpca: LPCOLORADJUSTMENT): BOOL; stdcall;
{$EXTERNALSYM SetColorAdjustment}
function GetColorAdjustment(hdc: HDC; lpca: LPCOLORADJUSTMENT): BOOL; stdcall;
{$EXTERNALSYM GetColorAdjustment}
function CreateHalftonePalette(hdc: HDC): HPALETTE; stdcall;
{$EXTERNALSYM CreateHalftonePalette}

type
  ABORTPROC = function(hdc: HDC; iError: Integer): BOOL; stdcall;
  {$EXTERNALSYM ABORTPROC}

  PDocInfoA = ^TDocInfoA;
  _DOCINFOA = record
    cbSize: Integer;
    lpszDocName: LPCSTR;
    lpszOutput: LPCSTR;
    lpszDatatype: LPCSTR;
    fwType: DWORD;
  end;
  {$EXTERNALSYM _DOCINFOA}
  DOCINFOA = _DOCINFOA;
  {$EXTERNALSYM DOCINFOA}
  LPDOCINFOA = ^DOCINFOA;
  {$EXTERNALSYM LPDOCINFOA}
  TDocInfoA = _DOCINFOA;

  PDocInfoW = ^TDocInfoW;
  _DOCINFOW = record
    cbSize: Integer;
    lpszDocName: LPCWSTR;
    lpszOutput: LPCWSTR;
    lpszDatatype: LPCWSTR;
    fwType: DWORD;
  end;
  {$EXTERNALSYM _DOCINFOW}
  DOCINFOW = _DOCINFOW;
  {$EXTERNALSYM DOCINFOW}
  LPDOCINFOW = ^DOCINFOW;
  {$EXTERNALSYM LPDOCINFOW}
  TDocInfoW = _DOCINFOW;

  {$IFDEF UNICODE}
  DOCINFO = DOCINFOW;
  {$EXTERNALSYM DOCINFO}
  LPDOCINFO = LPDOCINFOW;
  {$EXTERNALSYM LPDOCINFO}
  TDocInfo = TDocInfoW;
  PDocInfo = PDocInfoW;
  {$ELSE}
  DOCINFO = DOCINFOA;
  {$EXTERNALSYM DOCINFO}
  LPDOCINFO = LPDOCINFOA;
  {$EXTERNALSYM LPDOCINFO}
  TDocInfo = TDocInfoA;
  PDocInfo = PDocInfoA;
  {$ENDIF UNICODE}

const
  DI_APPBANDING            = $00000001;
  {$EXTERNALSYM DI_APPBANDING}
  DI_ROPS_READ_DESTINATION = $00000002;
  {$EXTERNALSYM DI_ROPS_READ_DESTINATION}

function StartDocA(hdc: HDC; const lpdi: DOCINFOA): Integer; stdcall;
{$EXTERNALSYM StartDocA}
function StartDocW(hdc: HDC; const lpdi: DOCINFOW): Integer; stdcall;
{$EXTERNALSYM StartDocW}
function StartDoc(hdc: HDC; const lpdi: DOCINFO): Integer; stdcall;
{$EXTERNALSYM StartDoc}
function EndDoc(dc: HDC): Integer; stdcall;
{$EXTERNALSYM EndDoc}
function StartPage(dc: HDC): Integer; stdcall;
{$EXTERNALSYM StartPage}
function EndPage(dc: HDC): Integer; stdcall;
{$EXTERNALSYM EndPage}
function AbortDoc(dc: HDC): Integer; stdcall;
{$EXTERNALSYM AbortDoc}
function SetAbortProc(dc: HDC; lpAbortProc: ABORTPROC): Integer; stdcall;
{$EXTERNALSYM SetAbortProc}

function AbortPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM AbortPath}
function ArcTo(hdc: HDC; nLeftRect, nTopRect, nRightRect, nBottomRect, nXRadial1, nYRadial1, nXRadial2, nYRadial2: Integer): BOOL; stdcall;
{$EXTERNALSYM ArcTo}
function BeginPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM BeginPath}
function CloseFigure(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM CloseFigure}
function EndPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM EndPath}
function FillPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM FillPath}
function FlattenPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM FlattenPath}
function GetPath(hdc: HDC; lpPoints: LPPOINT; lpTypes: LPBYTE; nSize: Integer): Integer; stdcall;
{$EXTERNALSYM GetPath}
function PathToRegion(hdc: HDC): HRGN; stdcall;
{$EXTERNALSYM PathToRegion}
function PolyDraw(hdc: HDC; lppt: LPPOINT; lpbTypes: LPBYTE; cCount: Integer): BOOL; stdcall;
{$EXTERNALSYM PolyDraw}
function SelectClipPath(hdc: HDC; iMode: Integer): BOOL; stdcall;
{$EXTERNALSYM SelectClipPath}
function SetArcDirection(hdc: HDC; ArcDirection: Integer): Integer; stdcall;
{$EXTERNALSYM SetArcDirection}
function SetMiterLimit(hdc: HDC; eNewLimit: FLOAT; peOldLimit: PFLOAT): BOOL; stdcall;
{$EXTERNALSYM SetMiterLimit}
function StrokeAndFillPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM StrokeAndFillPath}
function StrokePath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM StrokePath}
function WidenPath(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM WidenPath}
function ExtCreatePen(dwPenStyle, dwWidth: DWORD; const lplb: LOGBRUSH; dwStyleCount: DWORD; lpStyle: DWORD): HPEN; stdcall;
{$EXTERNALSYM ExtCreatePen}
function GetMiterLimit(hdc: HDC; var peLimit: FLOAT): BOOL; stdcall;
{$EXTERNALSYM GetMiterLimit}
function GetArcDirection(hdc: HDC): Integer; stdcall;
{$EXTERNALSYM GetArcDirection}

function GetObjectA(hgdiobj: HGDIOBJ; cbBuffer: Integer; lpvObject: LPVOID): Integer; stdcall;
{$EXTERNALSYM GetObjectA}
function GetObjectW(hgdiobj: HGDIOBJ; cbBuffer: Integer; lpvObject: LPVOID): Integer; stdcall;
{$EXTERNALSYM GetObjectW}
function GetObject(hgdiobj: HGDIOBJ; cbBuffer: Integer; lpvObject: LPVOID): Integer; stdcall;
{$EXTERNALSYM GetObject}
function MoveToEx(hdc: HDC; X, Y: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM MoveToEx}
function TextOutA(hdc: HDC; nXStart, nYStart: Integer; lpString: LPCSTR; cbString: Integer): BOOL; stdcall;
{$EXTERNALSYM TextOutA}
function TextOutW(hdc: HDC; nXStart, nYStart: Integer; lpString: LPCWSTR; cbString: Integer): BOOL; stdcall;
{$EXTERNALSYM TextOutW}
function TextOut(hdc: HDC; nXStart, nYStart: Integer; lpString: LPCTSTR; cbString: Integer): BOOL; stdcall;
{$EXTERNALSYM TextOut}
function ExtTextOutA(hdc: HDC; X, Y: Integer; fuOptions: UINT; lprc: LPRECT; lpString: LPCSTR; cbCount: UINT; lpDx: LPINT): BOOL; stdcall;
{$EXTERNALSYM ExtTextOutA}
function ExtTextOutW(hdc: HDC; X, Y: Integer; fuOptions: UINT; lprc: LPRECT; lpString: LPCWSTR; cbCount: UINT; lpDx: LPINT): BOOL; stdcall;
{$EXTERNALSYM ExtTextOutW}
function ExtTextOut(hdc: HDC; X, Y: Integer; fuOptions: UINT; lprc: LPRECT; lpString: LPCTSTR; cbCount: UINT; lpDx: LPINT): BOOL; stdcall;
{$EXTERNALSYM ExtTextOut}
function PolyTextOutA(hdc: HDC; pptxt: LPPOLYTEXTA; cStrings: Integer): BOOL; stdcall;
{$EXTERNALSYM PolyTextOutA}
function PolyTextOutW(hdc: HDC; pptxt: LPPOLYTEXTW; cStrings: Integer): BOOL; stdcall;
{$EXTERNALSYM PolyTextOutW}
function PolyTextOut(hdc: HDC; pptxt: LPPOLYTEXT; cStrings: Integer): BOOL; stdcall;
{$EXTERNALSYM PolyTextOut}

function CreatePolygonRgn(lppt: LPPOINT; cPoints, fnPolyFillMode: Integer): HRGN; stdcall;
{$EXTERNALSYM CreatePolygonRgn}
function DPtoLP(hdc: HDC; lpPoints: LPPOINT; nCount: Integer): BOOL; stdcall;
{$EXTERNALSYM DPtoLP}
function LPtoDP(hdc: HDC; lpPoints: LPPOINT; nCount: Integer): BOOL; stdcall;
{$EXTERNALSYM LPtoDP}
function Polygon(hdc: HDC; lpPoints: LPPOINT; nCount: Integer): BOOL; stdcall;
{$EXTERNALSYM Polygon}
function Polyline(hdc: HDC; lppt: LPPOINT; nCount: Integer): BOOL; stdcall;
{$EXTERNALSYM Polyline}

function PolyBezier(hdc: HDC; lppt: LPPOINT; cPoints: DWORD): BOOL; stdcall;
{$EXTERNALSYM PolyBezier}
function PolyBezierTo(hdc: HDC; lppt: LPPOINT; cCount: DWORD): BOOL; stdcall;
{$EXTERNALSYM PolyBezierTo}
function PolylineTo(hdc: HDC; lppt: LPPOINT; cCount: DWORD): BOOL; stdcall;
{$EXTERNALSYM PolylineTo}

function SetViewportExtEx(hdc: HDC; nXExtend, nYExtend: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM SetViewportExtEx}
function SetViewportOrgEx(hdc: HDC; X, Y: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM SetViewportOrgEx}
function SetWindowExtEx(hdc: HDC; nXExtend, nYExtend: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM SetWindowExtEx}
function SetWindowOrgEx(hdc: HDC; X, Y: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM SetWindowOrgEx}

function OffsetViewportOrgEx(hdc: HDC; nXOffset, nYOffset: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM OffsetViewportOrgEx}
function OffsetWindowOrgEx(hdc: HDC; nXOffset, nYOffset: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM OffsetWindowOrgEx}
function ScaleViewportExtEx(hdc: HDC; Xnum, Xdenom, Ynum, Ydenom: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM ScaleViewportExtEx}
function ScaleWindowExtEx(hdc: HDC; Xnum, Xdenom, Ynum, Ydenom: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM ScaleWindowExtEx}
function SetBitmapDimensionEx(hBitmap: HBITMAP; nWidth, nHeight: Integer; lpSize: LPSIZE): BOOL; stdcall;
{$EXTERNALSYM SetBitmapDimensionEx}
function SetBrushOrgEx(hdc: HDC; nXOrg, nYOrg: Integer; lppt: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM SetBrushOrgEx}

function GetTextFaceA(hdc: HDC; nCount: Integer; lpFaceName: LPSTR): Integer; stdcall;
{$EXTERNALSYM GetTextFaceA}
function GetTextFaceW(hdc: HDC; nCount: Integer; lpFaceName: LPWSTR): Integer; stdcall;
{$EXTERNALSYM GetTextFaceW}
function GetTextFace(hdc: HDC; nCount: Integer; lpFaceName: LPTSTR): Integer; stdcall;
{$EXTERNALSYM GetTextFace}

const
  FONTMAPPER_MAX = 10;
  {$EXTERNALSYM FONTMAPPER_MAX}

type
  PKerningPair = ^TKerningPair;
  tagKERNINGPAIR = record
    wFirst: WORD;
    wSecond: WORD;
    iKernAmount: Integer;
  end;
  {$EXTERNALSYM tagKERNINGPAIR}
  KERNINGPAIR = tagKERNINGPAIR;
  {$EXTERNALSYM KERNINGPAIR}
  LPKERNINGPAIR = ^KERNINGPAIR;
  {$EXTERNALSYM LPKERNINGPAIR}
  TKerningPair = KERNINGPAIR;

function GetKerningPairsA(hDc: HDC; nNumPairs: DWORD; lpkrnpair: LPKERNINGPAIR): DWORD; stdcall;
{$EXTERNALSYM GetKerningPairsA}
function GetKerningPairsW(hDc: HDC; nNumPairs: DWORD; lpkrnpair: LPKERNINGPAIR): DWORD; stdcall;
{$EXTERNALSYM GetKerningPairsW}
function GetKerningPairs(hDc: HDC; nNumPairs: DWORD; lpkrnpair: LPKERNINGPAIR): DWORD; stdcall;
{$EXTERNALSYM GetKerningPairs}

function GetDCOrgEx(hdc: HDC; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM GetDCOrgEx}
function FixBrushOrgEx(hDc: HDC; I1, I2: Integer; lpPoint: LPPOINT): BOOL; stdcall;
{$EXTERNALSYM FixBrushOrgEx}
function UnrealizeObject(hgdiobj: HGDIOBJ): BOOL; stdcall;
{$EXTERNALSYM UnrealizeObject}

function GdiFlush: BOOL; stdcall;
{$EXTERNALSYM GdiFlush}
function GdiSetBatchLimit(dwLimit: DWORD): DWORD; stdcall;
{$EXTERNALSYM GdiSetBatchLimit}
function GdiGetBatchLimit: DWORD; stdcall;
{$EXTERNALSYM GdiGetBatchLimit}

const
  ICM_OFF            = 1;
  {$EXTERNALSYM ICM_OFF}
  ICM_ON             = 2;
  {$EXTERNALSYM ICM_ON}
  ICM_QUERY          = 3;
  {$EXTERNALSYM ICM_QUERY}
  ICM_DONE_OUTSIDEDC = 4;
  {$EXTERNALSYM ICM_DONE_OUTSIDEDC}

type
  ICMENUMPROCA = function(lpszFileName: LPSTR; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM ICMENUMPROCA}
  ICMENUMPROCW = function(lpszFileName: LPWSTR; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM ICMENUMPROCW}
  ICMENUMPROC = function(lpszFileName: LPTSTR; lParam: LPARAM): Integer; stdcall;
  {$EXTERNALSYM ICMENUMPROC}

function SetICMMode(hDc: HDC; iEnableICM: Integer): Integer; stdcall;
{$EXTERNALSYM SetICMMode}
function CheckColorsInGamut(hDc: HDC; lpRGBTriples, lpBuffer: LPVOID; nCount: DWORD): BOOL; stdcall;
{$EXTERNALSYM CheckColorsInGamut}
function GetColorSpace(hDc: HDC): HCOLORSPACE; stdcall;
{$EXTERNALSYM GetColorSpace}

function GetLogColorSpaceA(hColorSpace: HCOLORSPACE; lpBuffer: LPLOGCOLORSPACEA; nSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetLogColorSpaceA}
function GetLogColorSpaceW(hColorSpace: HCOLORSPACE; lpBuffer: LPLOGCOLORSPACEW; nSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetLogColorSpaceW}
function GetLogColorSpace(hColorSpace: HCOLORSPACE; lpBuffer: LPLOGCOLORSPACE; nSize: DWORD): BOOL; stdcall;
{$EXTERNALSYM GetLogColorSpace}

function CreateColorSpaceA(lpLogColorSpace: LPLOGCOLORSPACEA): HCOLORSPACE; stdcall;
{$EXTERNALSYM CreateColorSpaceA}
function CreateColorSpaceW(lpLogColorSpace: LPLOGCOLORSPACEW): HCOLORSPACE; stdcall;
{$EXTERNALSYM CreateColorSpaceW}
function CreateColorSpace(lpLogColorSpace: LPLOGCOLORSPACE): HCOLORSPACE; stdcall;
{$EXTERNALSYM CreateColorSpace}

function SetColorSpace(hDc: HDC; hColorSpace: HCOLORSPACE): HCOLORSPACE; stdcall;
{$EXTERNALSYM SetColorSpace}
function DeleteColorSpace(hColorSpace: HCOLORSPACE): BOOL; stdcall;
{$EXTERNALSYM DeleteColorSpace}
function GetICMProfileA(hDc: HDC; lpcbName: LPDWORD; lpszFilename: LPSTR): BOOL; stdcall;
{$EXTERNALSYM GetICMProfileA}
function GetICMProfileW(hDc: HDC; lpcbName: LPDWORD; lpszFilename: LPWSTR): BOOL; stdcall;
{$EXTERNALSYM GetICMProfileW}
function GetICMProfile(hDc: HDC; lpcbName: LPDWORD; lpszFilename: LPTSTR): BOOL; stdcall;
{$EXTERNALSYM GetICMProfile}

function SetICMProfileA(hDc: HDC; lpFileName: LPSTR): BOOL; stdcall;
{$EXTERNALSYM SetICMProfileA}
function SetICMProfileW(hDc: HDC; lpFileName: LPWSTR): BOOL; stdcall;
{$EXTERNALSYM SetICMProfileW}
function SetICMProfile(hDc: HDC; lpFileName: LPTSTR): BOOL; stdcall;
{$EXTERNALSYM SetICMProfile}

function GetDeviceGammaRamp(hDc: HDC; lpRamp: LPVOID): BOOL; stdcall;
{$EXTERNALSYM GetDeviceGammaRamp}
function SetDeviceGammaRamp(hDc: HDC; lpRamp: LPVOID): BOOL; stdcall;
{$EXTERNALSYM SetDeviceGammaRamp}
function ColorMatchToTarget(hDc, hdcTarget: HDC; uiAction: DWORD): BOOL; stdcall;
{$EXTERNALSYM ColorMatchToTarget}

function EnumICMProfilesA(hDc: HDC; lpEnumProc: ICMENUMPROCA; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumICMProfilesA}
function EnumICMProfilesW(hDc: HDC; lpEnumProc: ICMENUMPROCW; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumICMProfilesW}
function EnumICMProfiles(hDc: HDC; lpEnumProc: ICMENUMPROC; lParam: LPARAM): Integer; stdcall;
{$EXTERNALSYM EnumICMProfiles}

function UpdateICMRegKeyA(dwReserved: DWORD; lpszCMID, lpszFileName: LPSTR; nCommand: UINT): BOOL; stdcall;
{$EXTERNALSYM UpdateICMRegKeyA}
function UpdateICMRegKeyW(dwReserved: DWORD; lpszCMID, lpszFileName: LPWSTR; nCommand: UINT): BOOL; stdcall;
{$EXTERNALSYM UpdateICMRegKeyW}
function UpdateICMRegKey(dwReserved: DWORD; lpszCMID, lpszFileName: LPTSTR; nCommand: UINT): BOOL; stdcall;
{$EXTERNALSYM UpdateICMRegKey}

function ColorCorrectPalette(hDc: HDC; hColorPalette: HPALETTE; dwFirstEntry, dwNumOfEntries: DWORD): BOOL; stdcall;
{$EXTERNALSYM ColorCorrectPalette}

// Enhanced metafile constants.

const
  ENHMETA_SIGNATURE = $464D4520;
  {$EXTERNALSYM ENHMETA_SIGNATURE}

// Stock object flag used in the object handle index in the enhanced
// metafile records.
// E.g. The object handle index (META_STOCK_OBJECT | BLACK_BRUSH)
// represents the stock object BLACK_BRUSH.

  ENHMETA_STOCK_OBJECT = DWORD($80000000);
  {$EXTERNALSYM ENHMETA_STOCK_OBJECT}

// Enhanced metafile record types.

  EMR_HEADER               = 1;
  {$EXTERNALSYM EMR_HEADER}
  EMR_POLYBEZIER           = 2;
  {$EXTERNALSYM EMR_POLYBEZIER}
  EMR_POLYGON              = 3;
  {$EXTERNALSYM EMR_POLYGON}
  EMR_POLYLINE             = 4;
  {$EXTERNALSYM EMR_POLYLINE}
  EMR_POLYBEZIERTO         = 5;
  {$EXTERNALSYM EMR_POLYBEZIERTO}
  EMR_POLYLINETO           = 6;
  {$EXTERNALSYM EMR_POLYLINETO}
  EMR_POLYPOLYLINE         = 7;
  {$EXTERNALSYM EMR_POLYPOLYLINE}
  EMR_POLYPOLYGON          = 8;
  {$EXTERNALSYM EMR_POLYPOLYGON}
  EMR_SETWINDOWEXTEX       = 9;
  {$EXTERNALSYM EMR_SETWINDOWEXTEX}
  EMR_SETWINDOWORGEX       = 10;
  {$EXTERNALSYM EMR_SETWINDOWORGEX}
  EMR_SETVIEWPORTEXTEX     = 11;
  {$EXTERNALSYM EMR_SETVIEWPORTEXTEX}
  EMR_SETVIEWPORTORGEX     = 12;
  {$EXTERNALSYM EMR_SETVIEWPORTORGEX}
  EMR_SETBRUSHORGEX        = 13;
  {$EXTERNALSYM EMR_SETBRUSHORGEX}
  EMR_EOF                  = 14;
  {$EXTERNALSYM EMR_EOF}
  EMR_SETPIXELV            = 15;
  {$EXTERNALSYM EMR_SETPIXELV}
  EMR_SETMAPPERFLAGS       = 16;
  {$EXTERNALSYM EMR_SETMAPPERFLAGS}
  EMR_SETMAPMODE           = 17;
  {$EXTERNALSYM EMR_SETMAPMODE}
  EMR_SETBKMODE            = 18;
  {$EXTERNALSYM EMR_SETBKMODE}
  EMR_SETPOLYFILLMODE      = 19;
  {$EXTERNALSYM EMR_SETPOLYFILLMODE}
  EMR_SETROP2              = 20;
  {$EXTERNALSYM EMR_SETROP2}
  EMR_SETSTRETCHBLTMODE    = 21;
  {$EXTERNALSYM EMR_SETSTRETCHBLTMODE}
  EMR_SETTEXTALIGN         = 22;
  {$EXTERNALSYM EMR_SETTEXTALIGN}
  EMR_SETCOLORADJUSTMENT   = 23;
  {$EXTERNALSYM EMR_SETCOLORADJUSTMENT}
  EMR_SETTEXTCOLOR         = 24;
  {$EXTERNALSYM EMR_SETTEXTCOLOR}
  EMR_SETBKCOLOR           = 25;
  {$EXTERNALSYM EMR_SETBKCOLOR}
  EMR_OFFSETCLIPRGN        = 26;
  {$EXTERNALSYM EMR_OFFSETCLIPRGN}
  EMR_MOVETOEX             = 27;
  {$EXTERNALSYM EMR_MOVETOEX}
  EMR_SETMETARGN           = 28;
  {$EXTERNALSYM EMR_SETMETARGN}
  EMR_EXCLUDECLIPRECT      = 29;
  {$EXTERNALSYM EMR_EXCLUDECLIPRECT}
  EMR_INTERSECTCLIPRECT    = 30;
  {$EXTERNALSYM EMR_INTERSECTCLIPRECT}
  EMR_SCALEVIEWPORTEXTEX   = 31;
  {$EXTERNALSYM EMR_SCALEVIEWPORTEXTEX}
  EMR_SCALEWINDOWEXTEX     = 32;
  {$EXTERNALSYM EMR_SCALEWINDOWEXTEX}
  EMR_SAVEDC               = 33;
  {$EXTERNALSYM EMR_SAVEDC}
  EMR_RESTOREDC            = 34;
  {$EXTERNALSYM EMR_RESTOREDC}
  EMR_SETWORLDTRANSFORM    = 35;
  {$EXTERNALSYM EMR_SETWORLDTRANSFORM}
  EMR_MODIFYWORLDTRANSFORM = 36;
  {$EXTERNALSYM EMR_MODIFYWORLDTRANSFORM}
  EMR_SELECTOBJECT         = 37;
  {$EXTERNALSYM EMR_SELECTOBJECT}
  EMR_CREATEPEN            = 38;
  {$EXTERNALSYM EMR_CREATEPEN}
  EMR_CREATEBRUSHINDIRECT  = 39;
  {$EXTERNALSYM EMR_CREATEBRUSHINDIRECT}
  EMR_DELETEOBJECT         = 40;
  {$EXTERNALSYM EMR_DELETEOBJECT}
  EMR_ANGLEARC             = 41;
  {$EXTERNALSYM EMR_ANGLEARC}
  EMR_ELLIPSE              = 42;
  {$EXTERNALSYM EMR_ELLIPSE}
  EMR_RECTANGLE            = 43;
  {$EXTERNALSYM EMR_RECTANGLE}
  EMR_ROUNDRECT            = 44;
  {$EXTERNALSYM EMR_ROUNDRECT}
  EMR_ARC                  = 45;
  {$EXTERNALSYM EMR_ARC}
  EMR_CHORD                = 46;
  {$EXTERNALSYM EMR_CHORD}
  EMR_PIE                  = 47;
  {$EXTERNALSYM EMR_PIE}
  EMR_SELECTPALETTE        = 48;
  {$EXTERNALSYM EMR_SELECTPALETTE}
  EMR_CREATEPALETTE        = 49;
  {$EXTERNALSYM EMR_CREATEPALETTE}
  EMR_SETPALETTEENTRIES    = 50;
  {$EXTERNALSYM EMR_SETPALETTEENTRIES}
  EMR_RESIZEPALETTE        = 51;
  {$EXTERNALSYM EMR_RESIZEPALETTE}
  EMR_REALIZEPALETTE       = 52;
  {$EXTERNALSYM EMR_REALIZEPALETTE}
  EMR_EXTFLOODFILL         = 53;
  {$EXTERNALSYM EMR_EXTFLOODFILL}
  EMR_LINETO               = 54;
  {$EXTERNALSYM EMR_LINETO}
  EMR_ARCTO                = 55;
  {$EXTERNALSYM EMR_ARCTO}
  EMR_POLYDRAW             = 56;
  {$EXTERNALSYM EMR_POLYDRAW}
  EMR_SETARCDIRECTION      = 57;
  {$EXTERNALSYM EMR_SETARCDIRECTION}
  EMR_SETMITERLIMIT        = 58;
  {$EXTERNALSYM EMR_SETMITERLIMIT}
  EMR_BEGINPATH            = 59;
  {$EXTERNALSYM EMR_BEGINPATH}
  EMR_ENDPATH              = 60;
  {$EXTERNALSYM EMR_ENDPATH}
  EMR_CLOSEFIGURE          = 61;
  {$EXTERNALSYM EMR_CLOSEFIGURE}
  EMR_FILLPATH             = 62;
  {$EXTERNALSYM EMR_FILLPATH}
  EMR_STROKEANDFILLPATH    = 63;
  {$EXTERNALSYM EMR_STROKEANDFILLPATH}
  EMR_STROKEPATH           = 64;
  {$EXTERNALSYM EMR_STROKEPATH}
  EMR_FLATTENPATH          = 65;
  {$EXTERNALSYM EMR_FLATTENPATH}
  EMR_WIDENPATH            = 66;
  {$EXTERNALSYM EMR_WIDENPATH}
  EMR_SELECTCLIPPATH       = 67;
  {$EXTERNALSYM EMR_SELECTCLIPPATH}
  EMR_ABORTPATH            = 68;
  {$EXTERNALSYM EMR_ABORTPATH}

  EMR_GDICOMMENT              = 70;
  {$EXTERNALSYM EMR_GDICOMMENT}
  EMR_FILLRGN                 = 71;
  {$EXTERNALSYM EMR_FILLRGN}
  EMR_FRAMERGN                = 72;
  {$EXTERNALSYM EMR_FRAMERGN}
  EMR_INVERTRGN               = 73;
  {$EXTERNALSYM EMR_INVERTRGN}
  EMR_PAINTRGN                = 74;
  {$EXTERNALSYM EMR_PAINTRGN}
  EMR_EXTSELECTCLIPRGN        = 75;
  {$EXTERNALSYM EMR_EXTSELECTCLIPRGN}
  EMR_BITBLT                  = 76;
  {$EXTERNALSYM EMR_BITBLT}
  EMR_STRETCHBLT              = 77;
  {$EXTERNALSYM EMR_STRETCHBLT}
  EMR_MASKBLT                 = 78;
  {$EXTERNALSYM EMR_MASKBLT}
  EMR_PLGBLT                  = 79;
  {$EXTERNALSYM EMR_PLGBLT}
  EMR_SETDIBITSTODEVICE       = 80;
  {$EXTERNALSYM EMR_SETDIBITSTODEVICE}
  EMR_STRETCHDIBITS           = 81;
  {$EXTERNALSYM EMR_STRETCHDIBITS}
  EMR_EXTCREATEFONTINDIRECTW  = 82;
  {$EXTERNALSYM EMR_EXTCREATEFONTINDIRECTW}
  EMR_EXTTEXTOUTA             = 83;
  {$EXTERNALSYM EMR_EXTTEXTOUTA}
  EMR_EXTTEXTOUTW             = 84;
  {$EXTERNALSYM EMR_EXTTEXTOUTW}
  EMR_POLYBEZIER16            = 85;
  {$EXTERNALSYM EMR_POLYBEZIER16}
  EMR_POLYGON16               = 86;
  {$EXTERNALSYM EMR_POLYGON16}
  EMR_POLYLINE16              = 87;
  {$EXTERNALSYM EMR_POLYLINE16}
  EMR_POLYBEZIERTO16          = 88;
  {$EXTERNALSYM EMR_POLYBEZIERTO16}
  EMR_POLYLINETO16            = 89;
  {$EXTERNALSYM EMR_POLYLINETO16}
  EMR_POLYPOLYLINE16          = 90;
  {$EXTERNALSYM EMR_POLYPOLYLINE16}
  EMR_POLYPOLYGON16           = 91;
  {$EXTERNALSYM EMR_POLYPOLYGON16}
  EMR_POLYDRAW16              = 92;
  {$EXTERNALSYM EMR_POLYDRAW16}
  EMR_CREATEMONOBRUSH         = 93;
  {$EXTERNALSYM EMR_CREATEMONOBRUSH}
  EMR_CREATEDIBPATTERNBRUSHPT = 94;
  {$EXTERNALSYM EMR_CREATEDIBPATTERNBRUSHPT}
  EMR_EXTCREATEPEN            = 95;
  {$EXTERNALSYM EMR_EXTCREATEPEN}
  EMR_POLYTEXTOUTA            = 96;
  {$EXTERNALSYM EMR_POLYTEXTOUTA}
  EMR_POLYTEXTOUTW            = 97;
  {$EXTERNALSYM EMR_POLYTEXTOUTW}

  EMR_SETICMMODE       = 98;
  {$EXTERNALSYM EMR_SETICMMODE}
  EMR_CREATECOLORSPACE = 99;
  {$EXTERNALSYM EMR_CREATECOLORSPACE}
  EMR_SETCOLORSPACE    = 100;
  {$EXTERNALSYM EMR_SETCOLORSPACE}
  EMR_DELETECOLORSPACE = 101;
  {$EXTERNALSYM EMR_DELETECOLORSPACE}
  EMR_GLSRECORD        = 102;
  {$EXTERNALSYM EMR_GLSRECORD}
  EMR_GLSBOUNDEDRECORD = 103;
  {$EXTERNALSYM EMR_GLSBOUNDEDRECORD}
  EMR_PIXELFORMAT      = 104;
  {$EXTERNALSYM EMR_PIXELFORMAT}

  EMR_RESERVED_105        = 105;
  {$EXTERNALSYM EMR_RESERVED_105}
  EMR_RESERVED_106        = 106;
  {$EXTERNALSYM EMR_RESERVED_106}
  EMR_RESERVED_107        = 107;
  {$EXTERNALSYM EMR_RESERVED_107}
  EMR_RESERVED_108        = 108;
  {$EXTERNALSYM EMR_RESERVED_108}
  EMR_RESERVED_109        = 109;
  {$EXTERNALSYM EMR_RESERVED_109}
  EMR_RESERVED_110        = 110;
  {$EXTERNALSYM EMR_RESERVED_110}
  EMR_COLORCORRECTPALETTE = 111;
  {$EXTERNALSYM EMR_COLORCORRECTPALETTE}
  EMR_SETICMPROFILEA      = 112;
  {$EXTERNALSYM EMR_SETICMPROFILEA}
  EMR_SETICMPROFILEW      = 113;
  {$EXTERNALSYM EMR_SETICMPROFILEW}
  EMR_ALPHABLEND          = 114;
  {$EXTERNALSYM EMR_ALPHABLEND}
  EMR_SETLAYOUT           = 115;
  {$EXTERNALSYM EMR_SETLAYOUT}
  EMR_TRANSPARENTBLT      = 116;
  {$EXTERNALSYM EMR_TRANSPARENTBLT}
  EMR_RESERVED_117        = 117;
  {$EXTERNALSYM EMR_RESERVED_117}
  EMR_GRADIENTFILL        = 118;
  {$EXTERNALSYM EMR_GRADIENTFILL}
  EMR_RESERVED_119        = 119;
  {$EXTERNALSYM EMR_RESERVED_119}
  EMR_RESERVED_120        = 120;
  {$EXTERNALSYM EMR_RESERVED_120}
  EMR_COLORMATCHTOTARGETW = 121;
  {$EXTERNALSYM EMR_COLORMATCHTOTARGETW}
  EMR_CREATECOLORSPACEW   = 122;
  {$EXTERNALSYM EMR_CREATECOLORSPACEW}

  EMR_MIN = 1;
  {$EXTERNALSYM EMR_MIN}

  {$IFDEF WIN98ME_UP}
  EMR_MAX = 122;
  {$EXTERNALSYM EMR_MAX}
  {$ELSE}
  EMR_MAX = 104;
  {$EXTERNALSYM EMR_MAX}
  {$ENDIF WIN98ME_UP}

// Base record type for the enhanced metafile.

type
  PEmr = ^TEmr;
  tagEMR = record
    iType: DWORD; // Enhanced metafile record type
    nSize: DWORD; // Length of the record in bytes.
                  // This must be a multiple of 4.
  end;
  {$EXTERNALSYM tagEMR}
  EMR = tagEMR;
  {$EXTERNALSYM EMR}
  TEmr = EMR;

// Base text record type for the enhanced metafile.

  PEmrText = ^TEmrText;
  tagEMRTEXT = record
    ptlReference: POINTL;
    nChars: DWORD;
    offString: DWORD; // Offset to the string
    fOptions: DWORD;
    rcl: RECTL;
    offDx: DWORD; // Offset to the inter-character spacing array.
    // This is always given.
  end;
  {$EXTERNALSYM tagEMRTEXT}
  EMRTEXT = tagEMRTEXT;
  {$EXTERNALSYM EMRTEXT}
  TEmrText = EMRTEXT;

// Record structures for the enhanced metafile.

  PAbortPath = ^TAbortPath;
  tagABORTPATH = record
    emr: EMR;
  end;
  {$EXTERNALSYM tagABORTPATH}
  TAbortPath = tagABORTPATH;
  EMRABORTPATH = tagABORTPATH;
  {$EXTERNALSYM EMRABORTPATH}
  PEMRABORTPATH = ^EMRABORTPATH;
  {$EXTERNALSYM PEMRABORTPATH}
  EMRBEGINPATH = tagABORTPATH;
  {$EXTERNALSYM EMRBEGINPATH}
  PEMRBEGINPATH = ^EMRBEGINPATH;
  {$EXTERNALSYM PEMRBEGINPATH}
  EMRENDPATH = tagABORTPATH;
  {$EXTERNALSYM EMRENDPATH}
  PEMRENDPATH = ^EMRENDPATH;
  {$EXTERNALSYM PEMRENDPATH}
  EMRCLOSEFIGURE = tagABORTPATH;
  {$EXTERNALSYM EMRCLOSEFIGURE}
  PEMRCLOSEFIGURE = ^EMRCLOSEFIGURE;
  {$EXTERNALSYM PEMRCLOSEFIGURE}
  EMRFLATTENPATH = tagABORTPATH;
  {$EXTERNALSYM EMRFLATTENPATH}
  PEMRFLATTENPATH = ^EMRFLATTENPATH;
  {$EXTERNALSYM PEMRFLATTENPATH}
  EMRWIDENPATH = tagABORTPATH;
  {$EXTERNALSYM EMRWIDENPATH}
  PEMRWIDENPATH = ^EMRWIDENPATH;
  {$EXTERNALSYM PEMRWIDENPATH}
  EMRSETMETARGN = tagABORTPATH;
  {$EXTERNALSYM EMRSETMETARGN}
  PEMRSETMETARGN = ^EMRSETMETARGN;
  {$EXTERNALSYM PEMRSETMETARGN}
  EMRSAVEDC = tagABORTPATH;
  {$EXTERNALSYM EMRSAVEDC}
  PEMRSAVEDC = ^EMRSAVEDC;
  {$EXTERNALSYM PEMRSAVEDC}
  EMRREALIZEPALETTE = tagABORTPATH;
  {$EXTERNALSYM EMRREALIZEPALETTE}
  PEMRREALIZEPALETTE = ^EMRREALIZEPALETTE;
  {$EXTERNALSYM PEMRREALIZEPALETTE}

  PEmrSelectClipPath = ^TEmrSelectClipPath;
  tagEMRSELECTCLIPPATH = record
    emr: EMR;
    iMode: DWORD;
  end;
  {$EXTERNALSYM tagEMRSELECTCLIPPATH}
  EMRSELECTCLIPPATH = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSELECTCLIPPATH}
  LPEMRSELECTCLIPPATH = ^EMRSELECTCLIPPATH;
  {$EXTERNALSYM LPEMRSELECTCLIPPATH}
  TEmrSelectClipPath = EMRSELECTCLIPPATH;

  EMRSETBKMODE = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETBKMODE}
  PEMRSETBKMODE = ^EMRSETBKMODE;
  {$EXTERNALSYM PEMRSETBKMODE}
  EMRSETMAPMODE = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETMAPMODE}
  PEMRSETMAPMODE = ^EMRSETMAPMODE;
  {$EXTERNALSYM PEMRSETMAPMODE}
  EMRSETLAYOUT = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETLAYOUT}
  PEMRSETLAYOUT = ^EMRSETLAYOUT;
  {$EXTERNALSYM PEMRSETLAYOUT}
  EMRSETPOLYFILLMODE = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETPOLYFILLMODE}
  PEMRSETPOLYFILLMODE = EMRSETPOLYFILLMODE;
  {$EXTERNALSYM PEMRSETPOLYFILLMODE}
  EMRSETROP2 = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETROP2}
  PEMRSETROP2 = ^EMRSETROP2;
  {$EXTERNALSYM PEMRSETROP2}
  EMRSETSTRETCHBLTMODE = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETSTRETCHBLTMODE}
  PEMRSETSTRETCHBLTMODE = ^EMRSETSTRETCHBLTMODE;
  {$EXTERNALSYM PEMRSETSTRETCHBLTMODE}
  EMRSETICMMODE = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETICMMODE}
  PEMRSETICMMODE = ^EMRSETICMMODE;
  {$EXTERNALSYM PEMRSETICMMODE}
  EMRSETTEXTALIGN = tagEMRSELECTCLIPPATH;
  {$EXTERNALSYM EMRSETTEXTALIGN}
  PEMRSETTEXTALIGN = ^EMRSETTEXTALIGN;
  {$EXTERNALSYM PEMRSETTEXTALIGN}

  PEmrSetMiterLimit = ^TEmrSetMiterLimit;
  tagEMRSETMITERLIMIT = record
    emr: EMR;
    eMiterLimit: FLOAT;
  end;
  {$EXTERNALSYM tagEMRSETMITERLIMIT}
  EMRSETMITERLIMIT = tagEMRSETMITERLIMIT;
  {$EXTERNALSYM EMRSETMITERLIMIT}
  TEmrSetMiterLimit = EMRSETMITERLIMIT;

  PEmrRestoreDc = ^TEmrRestoreDc;
  tagEMRRESTOREDC = record
    emr: EMR;
    iRelative: LONG; // Specifies a relative instance
  end;
  {$EXTERNALSYM tagEMRRESTOREDC}
  EMRRESTOREDC = tagEMRRESTOREDC;
  {$EXTERNALSYM EMRRESTOREDC}
  TEmrRestoreDc = EMRRESTOREDC;

  PEmrSetArcDirection = ^TEmrSetArcDirection;
  tagEMRSETARCDIRECTION = record
    emr: EMR;
    iArcDirection: DWORD; // Specifies the arc direction in the
    // advanced graphics mode.
  end;
  {$EXTERNALSYM tagEMRSETARCDIRECTION}
  EMRSETARCDIRECTION = tagEMRSETARCDIRECTION;
  {$EXTERNALSYM EMRSETARCDIRECTION}
  TEmrSetArcDirection = EMRSETARCDIRECTION;

  PEmrSetMapperFlags = ^TEmrSetMapperFlags;
  tagEMRSETMAPPERFLAGS = record
    emr: EMR;
    dwFlags: DWORD;
  end;
  {$EXTERNALSYM tagEMRSETMAPPERFLAGS}
  EMRSETMAPPERFLAGS = tagEMRSETMAPPERFLAGS;
  {$EXTERNALSYM EMRSETMAPPERFLAGS}
  TEmrSetMapperFlags = EMRSETMAPPERFLAGS;

  PEmrSetTextColor = ^TEmrSetTextColor;
  tagEMRSETTEXTCOLOR = record
    emr: EMR;
    crColor: COLORREF;
  end;
  {$EXTERNALSYM tagEMRSETTEXTCOLOR}
  EMRSETTEXTCOLOR = tagEMRSETTEXTCOLOR;
  {$EXTERNALSYM EMRSETTEXTCOLOR}
  EMRSETBKCOLOR = tagEMRSETTEXTCOLOR;
  {$EXTERNALSYM EMRSETBKCOLOR}
  PEMRSETBKCOLOR = ^EMRSETTEXTCOLOR;
  {$EXTERNALSYM PEMRSETBKCOLOR}
  TEmrSetTextColor = EMRSETTEXTCOLOR;

  PEmrSelectObject = ^TEmrSelectObject;
  tagEMRSELECTOBJECT = record
    emr: EMR;
    ihObject: DWORD; // Object handle index
  end;
  {$EXTERNALSYM tagEMRSELECTOBJECT}
  EMRSELECTOBJECT = tagEMRSELECTOBJECT;
  {$EXTERNALSYM EMRSELECTOBJECT}
  EMRDELETEOBJECT = tagEMRSELECTOBJECT;
  {$EXTERNALSYM EMRDELETEOBJECT}
  PEMRDELETEOBJECT = ^EMRDELETEOBJECT;
  {$EXTERNALSYM PEMRDELETEOBJECT}
  TEmrSelectObject = EMRSELECTOBJECT;

  PEmrSelectPalette = ^TEmrSelectPalette;
  tagEMRSELECTPALETTE = record
    emr: EMR;
    ihPal: DWORD; // Palette handle index, background mode only
  end;
  {$EXTERNALSYM tagEMRSELECTPALETTE}
  EMRSELECTPALETTE = tagEMRSELECTPALETTE;
  {$EXTERNALSYM EMRSELECTPALETTE}
  TEmrSelectPalette = EMRSELECTPALETTE;

  PEmrResizePalette = ^TEmrResizePalette;
  tagEMRRESIZEPALETTE = record
    emr: EMR;
    ihPal: DWORD; // Palette handle index
    cEntries: DWORD;
  end;
  {$EXTERNALSYM tagEMRRESIZEPALETTE}
  EMRRESIZEPALETTE = tagEMRRESIZEPALETTE;
  {$EXTERNALSYM EMRRESIZEPALETTE}
  TEmrResizePalette = EMRRESIZEPALETTE;

  PEmrSetPaletteEntries = ^TEmrSetPaletteEntries;
  tagEMRSETPALETTEENTRIES = record
    emr: EMR;
    ihPal: DWORD; // Palette handle index
    iStart: DWORD;
    cEntries: DWORD;
    aPalEntries: array [0..0] of PALETTEENTRY; // The peFlags fields do not contain any flags
  end;
  {$EXTERNALSYM tagEMRSETPALETTEENTRIES}
  EMRSETPALETTEENTRIES = tagEMRSETPALETTEENTRIES;
  {$EXTERNALSYM EMRSETPALETTEENTRIES}
  TEmrSetPaletteEntries = EMRSETPALETTEENTRIES;

  PEmrSetColorAdjustment = ^TEmrSetColorAdjustment;
  tagEMRSETCOLORADJUSTMENT = record
    emr: EMR;
    ColorAdjustment: COLORADJUSTMENT;
  end;
  {$EXTERNALSYM tagEMRSETCOLORADJUSTMENT}
  EMRSETCOLORADJUSTMENT = tagEMRSETCOLORADJUSTMENT;
  {$EXTERNALSYM EMRSETCOLORADJUSTMENT}
  TEmrSetColorAdjustment = EMRSETCOLORADJUSTMENT;

  PEmrGdiComment = ^TEmrGdiComment;
  tagEMRGDICOMMENT = record
    emr: EMR;
    cbData: DWORD; // Size of data in bytes
    Data: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRGDICOMMENT}
  EMRGDICOMMENT = tagEMRGDICOMMENT;
  {$EXTERNALSYM EMRGDICOMMENT}
  TEmrGdiComment = EMRGDICOMMENT;

  PEmrEof = ^TEmrEof;
  tagEMREOF = record
    emr: EMR;
    nPalEntries: DWORD; // Number of palette entries
    offPalEntries: DWORD; // Offset to the palette entries
    nSizeLast: DWORD; // Same as nSize and must be the last DWORD
    // of the record.  The palette entries,
    // if exist, precede this field.
  end;
  {$EXTERNALSYM tagEMREOF}
  EMREOF = tagEMREOF;
  {$EXTERNALSYM EMREOF}
  TEmrEof = EMREOF;

  PEmrLineTo = ^TEmrLineTo;
  tagEMRLINETO = record
    emr: EMR;
    ptl: POINTL;
  end;
  {$EXTERNALSYM tagEMRLINETO}
  EMRLINETO = tagEMRLINETO;
  {$EXTERNALSYM EMRLINETO}
  EMRMOVETOEX = tagEMRLINETO;
  {$EXTERNALSYM EMRMOVETOEX}
  PEMRMOVETOEX = ^EMRMOVETOEX;
  {$EXTERNALSYM PEMRMOVETOEX}
  TEmrLineTo = EMRLINETO;

  PEmrOffsetClipRgn = ^TEmrOffsetClipRgn;
  tagEMROFFSETCLIPRGN = record
    emr: EMR;
    ptlOffset: POINTL;
  end;
  {$EXTERNALSYM tagEMROFFSETCLIPRGN}
  EMROFFSETCLIPRGN = tagEMROFFSETCLIPRGN;
  {$EXTERNALSYM EMROFFSETCLIPRGN}
  TEmrOffsetClipRgn = EMROFFSETCLIPRGN;

  PEmrFillPath = ^TEmrFillPath;
  tagEMRFILLPATH = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
  end;
  {$EXTERNALSYM tagEMRFILLPATH}
  EMRFILLPATH = tagEMRFILLPATH;
  {$EXTERNALSYM EMRFILLPATH}
  EMRSTROKEANDFILLPATH = tagEMRFILLPATH;
  {$EXTERNALSYM EMRSTROKEANDFILLPATH}
  PEMRSTROKEANDFILLPATH = ^EMRSTROKEANDFILLPATH;
  {$EXTERNALSYM PEMRSTROKEANDFILLPATH}
  EMRSTROKEPATH = tagEMRFILLPATH;
  {$EXTERNALSYM EMRSTROKEPATH}
  PEMRSTROKEPATH = ^EMRSTROKEPATH;
  {$EXTERNALSYM PEMRSTROKEPATH}
  TEmrFillPath = EMRFILLPATH;

  PEmrExcludeClipRect = ^TEmrExcludeClipRect;
  tagEMREXCLUDECLIPRECT = record
    emr: EMR;
    rclClip: RECTL;
  end;
  {$EXTERNALSYM tagEMREXCLUDECLIPRECT}
  EMREXCLUDECLIPRECT = tagEMREXCLUDECLIPRECT;
  {$EXTERNALSYM EMREXCLUDECLIPRECT}
  EMRINTERSECTCLIPRECT = tagEMREXCLUDECLIPRECT;
  {$EXTERNALSYM EMRINTERSECTCLIPRECT}
  PEMRINTERSECTCLIPRECT = ^EMRINTERSECTCLIPRECT;
  {$EXTERNALSYM PEMRINTERSECTCLIPRECT}
  TEmrExcludeClipRect = EMREXCLUDECLIPRECT;

  PEmrSetViewPortOrgEx = ^TEmrSetViewPortOrgEx;
  tagEMRSETVIEWPORTORGEX = record
    emr: EMR;
    ptlOrigin: POINTL;
  end;
  {$EXTERNALSYM tagEMRSETVIEWPORTORGEX}
  EMRSETVIEWPORTORGEX = tagEMRSETVIEWPORTORGEX;
  {$EXTERNALSYM EMRSETVIEWPORTORGEX}
  EMRSETWINDOWORGEX = tagEMRSETVIEWPORTORGEX;
  {$EXTERNALSYM EMRSETWINDOWORGEX}
  PEMRSETWINDOWORGEX = ^EMRSETWINDOWORGEX;
  {$EXTERNALSYM PEMRSETWINDOWORGEX}
  EMRSETBRUSHORGEX = tagEMRSETVIEWPORTORGEX;
  {$EXTERNALSYM EMRSETBRUSHORGEX}
  PEMRSETBRUSHORGEX = ^EMRSETBRUSHORGEX;
  {$EXTERNALSYM PEMRSETBRUSHORGEX}
  TEmrSetViewPortOrgEx = EMRSETVIEWPORTORGEX;

  PEmrSetViewPortExtEx = ^TEmrSetViewPortExtEx;
  tagEMRSETVIEWPORTEXTEX = record
    emr: EMR;
    szlExtent: SIZEL;
  end;
  {$EXTERNALSYM tagEMRSETVIEWPORTEXTEX}
  EMRSETVIEWPORTEXTEX = tagEMRSETVIEWPORTEXTEX;
  {$EXTERNALSYM EMRSETVIEWPORTEXTEX}
  EMRSETWINDOWEXTEX = tagEMRSETVIEWPORTEXTEX;
  {$EXTERNALSYM EMRSETWINDOWEXTEX}
  TEmrSetViewPortExtEx = EMRSETVIEWPORTEXTEX;

  PEmrScaleViewPortExtEx = ^TEmrScaleViewPortExtEx;
  tagEMRSCALEVIEWPORTEXTEX = record
    emr: EMR;
    xNum: LONG;
    xDenom: LONG;
    yNum: LONG;
    yDenom: LONG;
  end;
  {$EXTERNALSYM tagEMRSCALEVIEWPORTEXTEX}
  EMRSCALEVIEWPORTEXTEX = tagEMRSCALEVIEWPORTEXTEX;
  {$EXTERNALSYM EMRSCALEVIEWPORTEXTEX}
  EMRSCALEWINDOWEXTEX = tagEMRSCALEVIEWPORTEXTEX;
  {$EXTERNALSYM EMRSCALEWINDOWEXTEX}
  PEMRSCALEWINDOWEXTEX = ^EMRSCALEWINDOWEXTEX;
  {$EXTERNALSYM PEMRSCALEWINDOWEXTEX}
  TEmrScaleViewPortExtEx = EMRSCALEVIEWPORTEXTEX;

  PEmrSetWorldTransform = ^TEmrSetWorldTransform;
  tagEMRSETWORLDTRANSFORM = record
    emr: EMR;
    xform: XFORM;
  end;
  {$EXTERNALSYM tagEMRSETWORLDTRANSFORM}
  EMRSETWORLDTRANSFORM = tagEMRSETWORLDTRANSFORM;
  {$EXTERNALSYM EMRSETWORLDTRANSFORM}
  TEmrSetWorldTransform = EMRSETWORLDTRANSFORM;

  PEmrModifyWorldTransform = ^TEmrModifyWorldTransform;
  tagEMRMODIFYWORLDTRANSFORM = record
    emr: EMR;
    xform: XFORM;
    iMode: DWORD;
  end;
  {$EXTERNALSYM tagEMRMODIFYWORLDTRANSFORM}
  EMRMODIFYWORLDTRANSFORM = tagEMRMODIFYWORLDTRANSFORM;
  {$EXTERNALSYM EMRMODIFYWORLDTRANSFORM}
  TEmrModifyWorldTransform = EMRMODIFYWORLDTRANSFORM;

  PEmrSetPixelV = ^TEmrSetPixelV;
  tagEMRSETPIXELV = record
    emr: EMR;
    ptlPixel: POINTL;
    crColor: COLORREF;
  end;
  {$EXTERNALSYM tagEMRSETPIXELV}
  EMRSETPIXELV = tagEMRSETPIXELV;
  {$EXTERNALSYM EMRSETPIXELV}
  TEmrSetPixelV = EMRSETPIXELV;

  PEmrExtFloodFill = ^TEmrExtFloodFill;
  tagEMREXTFLOODFILL = record
    emr: EMR;
    ptlStart: POINTL;
    crColor: COLORREF;
    iMode: DWORD;
  end;
  {$EXTERNALSYM tagEMREXTFLOODFILL}
  EMREXTFLOODFILL = tagEMREXTFLOODFILL;
  {$EXTERNALSYM EMREXTFLOODFILL}
  TEmrExtFloodFill = EMREXTFLOODFILL;

  PEmrEllipse = ^TEmrEllipse;
  tagEMRELLIPSE = record
    emr: EMR;
    rclBox: RECTL; // Inclusive-inclusive bounding rectangle
  end;
  {$EXTERNALSYM tagEMRELLIPSE}
  EMRELLIPSE = tagEMRELLIPSE;
  {$EXTERNALSYM EMRELLIPSE}
  EMRRECTANGLE = tagEMRELLIPSE;
  {$EXTERNALSYM EMRRECTANGLE}
  PEMRRECTANGLE = ^EMRRECTANGLE;
  {$EXTERNALSYM PEMRRECTANGLE}
  TEmrEllipse = EMRELLIPSE;

  PEmrRoundRect = ^TEmrRoundRect;
  tagEMRROUNDRECT = record
    emr: EMR;
    rclBox: RECTL; // Inclusive-inclusive bounding rectangle
    szlCorner: SIZEL;
  end;
  {$EXTERNALSYM tagEMRROUNDRECT}
  EMRROUNDRECT = tagEMRROUNDRECT;
  {$EXTERNALSYM EMRROUNDRECT}
  TEmrRoundRect = EMRROUNDRECT;

  PEmrArc = ^TEmrArc;
  tagEMRARC = record
    emr: EMR;
    rclBox: RECTL; // Inclusive-inclusive bounding rectangle
    ptlStart: POINTL;
    ptlEnd: POINTL;
  end;
  {$EXTERNALSYM tagEMRARC}
  EMRARC = tagEMRARC;
  {$EXTERNALSYM EMRARC}
  EMRARCTO = tagEMRARC;
  {$EXTERNALSYM EMRARCTO}
  PEMRARCTO = ^EMRARCTO;
  {$EXTERNALSYM PEMRARCTO}
  EMRCHORD = tagEMRARC;
  {$EXTERNALSYM EMRCHORD}
  PEMRCHORD = ^EMRCHORD;
  {$EXTERNALSYM PEMRCHORD}
  EMRPIE = tagEMRARC;
  {$EXTERNALSYM EMRPIE}
  PEMRPIE = ^EMRPIE;
  {$EXTERNALSYM PEMRPIE}
  TEmrArc = EMRARC;

  PEmrAngleArc = ^TEmrAngleArc;
  tagEMRANGLEARC = record
    emr: EMR;
    ptlCenter: POINTL;
    nRadius: DWORD;
    eStartAngle: FLOAT;
    eSweepAngle: FLOAT;
  end;
  {$EXTERNALSYM tagEMRANGLEARC}
  EMRANGLEARC = tagEMRANGLEARC;
  {$EXTERNALSYM EMRANGLEARC}
  TEmrAngleArc = EMRANGLEARC;

  PEmrPolyline = ^TEmrPolyline;
  tagEMRPOLYLINE = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cptl: DWORD;
    aptl: array [0..0] of POINTL;
  end;
  {$EXTERNALSYM tagEMRPOLYLINE}
  EMRPOLYLINE = tagEMRPOLYLINE;
  {$EXTERNALSYM EMRPOLYLINE}
  EMRPOLYBEZIER = tagEMRPOLYLINE;
  {$EXTERNALSYM EMRPOLYBEZIER}
  PEMRPOLYBEZIER = ^EMRPOLYBEZIER;
  {$EXTERNALSYM PEMRPOLYBEZIER}
  EMRPOLYGON = tagEMRPOLYLINE;
  {$EXTERNALSYM EMRPOLYGON}
  PEMRPOLYGON = ^EMRPOLYGON;
  {$EXTERNALSYM PEMRPOLYGON}
  EMRPOLYBEZIERTO = tagEMRPOLYLINE;
  {$EXTERNALSYM EMRPOLYBEZIERTO}
  PEMRPOLYBEZIERTO = ^EMRPOLYBEZIERTO;
  {$EXTERNALSYM PEMRPOLYBEZIERTO}
  EMRPOLYLINETO = tagEMRPOLYLINE;
  {$EXTERNALSYM EMRPOLYLINETO}
  PEMRPOLYLINETO = ^EMRPOLYLINETO;
  {$EXTERNALSYM PEMRPOLYLINETO}
  TEmrPolyline = EMRPOLYLINE;

  PEmrPolyline16 = ^TEmrPolyline16;
  tagEMRPOLYLINE16 = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cpts: DWORD;
    apts: array [0..0] of POINTS;
  end;
  {$EXTERNALSYM tagEMRPOLYLINE16}
  EMRPOLYLINE16 = tagEMRPOLYLINE16;
  {$EXTERNALSYM EMRPOLYLINE16}
  EMRPOLYBEZIER16 = tagEMRPOLYLINE16;
  {$EXTERNALSYM EMRPOLYBEZIER16}
  PEMRPOLYBEZIER16 = ^EMRPOLYBEZIER16;
  {$EXTERNALSYM PEMRPOLYBEZIER16}
  EMRPOLYGON16 = tagEMRPOLYLINE16;
  {$EXTERNALSYM EMRPOLYGON16}
  PEMRPOLYGON16 = ^EMRPOLYGON16;
  {$EXTERNALSYM PEMRPOLYGON16}
  EMRPOLYBEZIERTO16 = tagEMRPOLYLINE16;
  {$EXTERNALSYM EMRPOLYBEZIERTO16}
  PEMRPOLYBEZIERTO16 = ^EMRPOLYBEZIERTO16;
  {$EXTERNALSYM PEMRPOLYBEZIERTO16}
  EMRPOLYLINETO16 = tagEMRPOLYLINE16;
  {$EXTERNALSYM EMRPOLYLINETO16}
  PEMRPOLYLINETO16 = ^EMRPOLYLINETO16;
  {$EXTERNALSYM PEMRPOLYLINETO16}
  TEmrPolyline16 = EMRPOLYLINE16;

  PEmrPolyDraw = ^TEmrPolyDraw;
  tagEMRPOLYDRAW = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cptl: DWORD; // Number of points
    aptl: array [0..0] of POINTL; // Array of points
    abTypes: array [0..0] of BYTE; // Array of point types
  end;
  {$EXTERNALSYM tagEMRPOLYDRAW}
  EMRPOLYDRAW = tagEMRPOLYDRAW;
  {$EXTERNALSYM EMRPOLYDRAW}
  TEmrPolyDraw = EMRPOLYDRAW;

  PEmrPolyDraw16 = ^TEmrPolyDraw16;
  tagEMRPOLYDRAW16 = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cpts: DWORD; // Number of points
    apts: array [0..0] of POINTS; // Array of points
    abTypes: array [0..0] of BYTE; // Array of point types
  end;
  {$EXTERNALSYM tagEMRPOLYDRAW16}
  EMRPOLYDRAW16 = tagEMRPOLYDRAW16;
  {$EXTERNALSYM EMRPOLYDRAW16}
  TEmrPolyDraw16 = EMRPOLYDRAW16;

  PEmrPolyPolyline = ^TEmrPolyPolyline;
  tagEMRPOLYPOLYLINE = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    nPolys: DWORD; // Number of polys
    cptl: DWORD; // Total number of points in all polys
    aPolyCounts: array [0..0] of DWORD; // Array of point counts for each poly
    aptl: array [0..0] of POINTL; // Array of points
  end;
  {$EXTERNALSYM tagEMRPOLYPOLYLINE}
  EMRPOLYPOLYLINE = tagEMRPOLYPOLYLINE;
  {$EXTERNALSYM EMRPOLYPOLYLINE}
  EMRPOLYPOLYGON = tagEMRPOLYPOLYLINE;
  {$EXTERNALSYM EMRPOLYPOLYGON}
  TEmrPolyPolyline = EMRPOLYPOLYLINE;

  PEmrPolyPolyline16 = ^TEmrPolyPolyline16;
  tagEMRPOLYPOLYLINE16 = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    nPolys: DWORD; // Number of polys
    cpts: DWORD; // Total number of points in all polys
    aPolyCounts: array [0..0] of DWORD; // Array of point counts for each poly
    apts: array [0..0] of POINTS; // Array of points
  end;
  {$EXTERNALSYM tagEMRPOLYPOLYLINE16}
  EMRPOLYPOLYLINE16 = tagEMRPOLYPOLYLINE16;
  {$EXTERNALSYM EMRPOLYPOLYLINE16}
  EMRPOLYPOLYGON16 = tagEMRPOLYPOLYLINE16;
  {$EXTERNALSYM EMRPOLYPOLYGON16}
  PEMRPOLYPOLYGON16 = ^EMRPOLYPOLYGON16;
  {$EXTERNALSYM PEMRPOLYPOLYGON16}
  TEmrPolyPolyline16 = EMRPOLYPOLYLINE16;

  PEmrInvertRgn = ^TEmrInvertRgn;
  tagEMRINVERTRGN = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cbRgnData: DWORD; // Size of region data in bytes
    RgnData: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRINVERTRGN}
  EMRINVERTRGN = tagEMRINVERTRGN;
  {$EXTERNALSYM EMRINVERTRGN}
  EMRPAINTRGN = tagEMRINVERTRGN;
  {$EXTERNALSYM EMRPAINTRGN}
  TEmrInvertRgn = EMRINVERTRGN;

  PEmrFillRgn = ^TEmrFillRgn;
  tagEMRFILLRGN = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cbRgnData: DWORD; // Size of region data in bytes
    ihBrush: DWORD; // Brush handle index
    RgnData: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRFILLRGN}
  EMRFILLRGN = tagEMRFILLRGN;
  {$EXTERNALSYM EMRFILLRGN}
  TEmrFillRgn = EMRFILLRGN;

  PEmrFrameRgn = ^TEmrFrameRgn;
  tagEMRFRAMERGN = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    cbRgnData: DWORD; // Size of region data in bytes
    ihBrush: DWORD; // Brush handle index
    szlStroke: SIZEL;
    RgnData: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRFRAMERGN}
  EMRFRAMERGN = tagEMRFRAMERGN;
  {$EXTERNALSYM EMRFRAMERGN}
  TEmrFrameRgn = EMRFRAMERGN;

  PEmrExtSelectClipRgn = ^TEmrExtSelectClipRgn;
  tagEMREXTSELECTCLIPRGN = record
    emr: EMR;
    cbRgnData: DWORD; // Size of region data in bytes
    iMode: DWORD;
    RgnData: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMREXTSELECTCLIPRGN}
  EMREXTSELECTCLIPRGN = tagEMREXTSELECTCLIPRGN;
  {$EXTERNALSYM EMREXTSELECTCLIPRGN}
  TEmrExtSelectClipRgn = EMREXTSELECTCLIPRGN;

  PEmrExtTextOutA = ^TEmrExtTextOutA;
  tagEMREXTTEXTOUTA = record
    emr: EMR;
    rclBounds: RECTL;     // Inclusive-inclusive bounds in device units
    iGraphicsMode: DWORD; // Current graphics mode
    exScale: FLOAT;       // X and Y scales from Page units to .01mm units
    eyScale: FLOAT;       // if graphics mode is GM_COMPATIBLE.
    emrtext: EMRTEXT;     // This is followed by the string and spacing array
  end;
  {$EXTERNALSYM tagEMREXTTEXTOUTA}
  EMREXTTEXTOUTA = tagEMREXTTEXTOUTA;
  {$EXTERNALSYM EMREXTTEXTOUTA}
  EMREXTTEXTOUTW = tagEMREXTTEXTOUTA;
  {$EXTERNALSYM EMREXTTEXTOUTW}
  PEMREXTTEXTOUTW = ^EMREXTTEXTOUTW;
  {$EXTERNALSYM PEMREXTTEXTOUTW}
  TEmrExtTextOutA = EMREXTTEXTOUTA;

  PEmrPolyTextOutA = ^TEmrPolyTextOutA;
  tagEMRPOLYTEXTOUTA = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    iGraphicsMode: DWORD; // Current graphics mode
    exScale: FLOAT; // X and Y scales from Page units to .01mm units
    eyScale: FLOAT; // if graphics mode is GM_COMPATIBLE.
    cStrings: LONG;
    aemrtext: array [0..0] of EMRTEXT; // Array of EMRTEXT structures.  This is
    // followed by the strings and spacing arrays.
  end;
  {$EXTERNALSYM tagEMRPOLYTEXTOUTA}
  EMRPOLYTEXTOUTA = tagEMRPOLYTEXTOUTA;
  {$EXTERNALSYM EMRPOLYTEXTOUTA}
  EMRPOLYTEXTOUTW = tagEMRPOLYTEXTOUTA;
  {$EXTERNALSYM EMRPOLYTEXTOUTW}
  PEMRPOLYTEXTOUTW = ^EMRPOLYTEXTOUTW;
  {$EXTERNALSYM PEMRPOLYTEXTOUTW}
  TEmrPolyTextOutA = EMRPOLYTEXTOUTA;

  PEmrBitBlt = ^TEmrBitBlt;
  tagEMRBITBLT = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    cxDest: LONG;
    cyDest: LONG;
    dwRop: DWORD;
    xSrc: LONG;
    ySrc: LONG;
    xformSrc: XFORM; // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD; // Source bitmap info color table usage
    // (DIB_RGB_COLORS)
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
  end;
  {$EXTERNALSYM tagEMRBITBLT}
  EMRBITBLT = tagEMRBITBLT;
  {$EXTERNALSYM EMRBITBLT}
  TEmrBitBlt = EMRBITBLT;

  PEmrStretchBlt = ^TEmrStretchBlt;
  tagEMRSTRETCHBLT = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    cxDest: LONG;
    cyDest: LONG;
    dwRop: DWORD;
    xSrc: LONG;
    ySrc: LONG;
    xformSrc: XFORM; // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD; // Source bitmap info color table usage
    // (DIB_RGB_COLORS)
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
    cxSrc: LONG;
    cySrc: LONG;
  end;
  {$EXTERNALSYM tagEMRSTRETCHBLT}
  EMRSTRETCHBLT = tagEMRSTRETCHBLT;
  {$EXTERNALSYM EMRSTRETCHBLT}
  TEmrStretchBlt = EMRSTRETCHBLT;

  PEmrMaskBlt = ^TEmrMaskBlt;
  tagEMRMASKBLT = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    cxDest: LONG;
    cyDest: LONG;
    dwRop: DWORD;
    xSrc: LONG;
    ySrc: LONG;
    xformSrc: XFORM; // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD; // Source bitmap info color table usage
    // (DIB_RGB_COLORS)
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
    xMask: LONG;
    yMask: LONG;
    iUsageMask: DWORD; // Mask bitmap info color table usage
    offBmiMask: DWORD; // Offset to the mask BITMAPINFO structure if any
    cbBmiMask: DWORD; // Size of the mask BITMAPINFO structure if any
    offBitsMask: DWORD; // Offset to the mask bitmap bits if any
    cbBitsMask: DWORD; // Size of the mask bitmap bits if any
  end;
  {$EXTERNALSYM tagEMRMASKBLT}
  EMRMASKBLT = tagEMRMASKBLT;
  {$EXTERNALSYM EMRMASKBLT}
  TEmrMaskBlt = EMRMASKBLT;

  PEmrPlgBlt = ^TEmrPlgBlt;
  tagEMRPLGBLT = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    aptlDest: array[0..2] of POINTL;
    xSrc: LONG;
    ySrc: LONG;
    cxSrc: LONG;
    cySrc: LONG;
    xformSrc: XFORM; // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD; // Source bitmap info color table usage
    // (DIB_RGB_COLORS)
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
    xMask: LONG;
    yMask: LONG;
    iUsageMask: DWORD; // Mask bitmap info color table usage
    offBmiMask: DWORD; // Offset to the mask BITMAPINFO structure if any
    cbBmiMask: DWORD; // Size of the mask BITMAPINFO structure if any
    offBitsMask: DWORD; // Offset to the mask bitmap bits if any
    cbBitsMask: DWORD; // Size of the mask bitmap bits if any
  end;
  {$EXTERNALSYM tagEMRPLGBLT}
  EMRPLGBLT = tagEMRPLGBLT;
  {$EXTERNALSYM EMRPLGBLT}
  TEmrPlgBlt = EMRPLGBLT;

  PEmrSetDiBitsToDevice = ^TEmrSetDiBitsToDevice;
  tagEMRSETDIBITSTODEVICE = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    xSrc: LONG;
    ySrc: LONG;
    cxSrc: LONG;
    cySrc: LONG;
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
    iUsageSrc: DWORD; // Source bitmap info color table usage
    iStartScan: DWORD;
    cScans: DWORD;
  end;
  {$EXTERNALSYM tagEMRSETDIBITSTODEVICE}
  EMRSETDIBITSTODEVICE = tagEMRSETDIBITSTODEVICE;
  {$EXTERNALSYM EMRSETDIBITSTODEVICE}
  TEmrSetDiBitsToDevice = EMRSETDIBITSTODEVICE;

  PEmrStretchDiBits = ^TEmrStretchDiBits;
  tagEMRSTRETCHDIBITS = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    xSrc: LONG;
    ySrc: LONG;
    cxSrc: LONG;
    cySrc: LONG;
    offBmiSrc: DWORD; // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD; // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD; // Offset to the source bitmap bits
    cbBitsSrc: DWORD; // Size of the source bitmap bits
    iUsageSrc: DWORD; // Source bitmap info color table usage
    dwRop: DWORD;
    cxDest: LONG;
    cyDest: LONG;
  end;
  {$EXTERNALSYM tagEMRSTRETCHDIBITS}
  EMRSTRETCHDIBITS = tagEMRSTRETCHDIBITS;
  {$EXTERNALSYM EMRSTRETCHDIBITS}
  TEmrStretchDiBits = EMRSTRETCHDIBITS;

  PEmrExtCreateFontIndirectW = ^TEmrExtCreateFontIndirectW;
  tagEMREXTCREATEFONTINDIRECTW = record
    emr: EMR;
    ihFont: DWORD; // Font handle index
    elfw: EXTLOGFONTW;
  end;
  {$EXTERNALSYM tagEMREXTCREATEFONTINDIRECTW}
  EMREXTCREATEFONTINDIRECTW = tagEMREXTCREATEFONTINDIRECTW;
  {$EXTERNALSYM EMREXTCREATEFONTINDIRECTW}
  TEmrExtCreateFontIndirectW = EMREXTCREATEFONTINDIRECTW;

  PEmrCreatePalette = ^TEmrCreatePalette;
  tagEMRCREATEPALETTE = record
    emr: EMR;
    ihPal: DWORD; // Palette handle index
    lgpl: LOGPALETTE; // The peFlags fields in the palette entries
    // do not contain any flags
  end;
  {$EXTERNALSYM tagEMRCREATEPALETTE}
  EMRCREATEPALETTE = tagEMRCREATEPALETTE;
  {$EXTERNALSYM EMRCREATEPALETTE}
  TEmrCreatePalette = EMRCREATEPALETTE;

  PEmrCreatePen = ^TEmrCreatePen;
  tagEMRCREATEPEN = record
    emr: EMR;
    ihPen: DWORD; // Pen handle index
    lopn: LOGPEN;
  end;
  {$EXTERNALSYM tagEMRCREATEPEN}
  EMRCREATEPEN = tagEMRCREATEPEN;
  {$EXTERNALSYM EMRCREATEPEN}
  TEmrCreatePen = EMRCREATEPEN;

  PEmrExtCreatePen = ^TEmrExtCreatePen;
  tagEMREXTCREATEPEN = record
    emr: EMR;
    ihPen: DWORD; // Pen handle index
    offBmi: DWORD; // Offset to the BITMAPINFO structure if any
    cbBmi: DWORD; // Size of the BITMAPINFO structure if any
    // The bitmap info is followed by the bitmap
    // bits to form a packed DIB.
    offBits: DWORD; // Offset to the brush bitmap bits if any
    cbBits: DWORD; // Size of the brush bitmap bits if any
    elp: EXTLOGPEN; // The extended pen with the style array.
  end;
  {$EXTERNALSYM tagEMREXTCREATEPEN}
  EMREXTCREATEPEN = tagEMREXTCREATEPEN;
  {$EXTERNALSYM EMREXTCREATEPEN}
  TEmrExtCreatePen = EMREXTCREATEPEN;

  PEmrCreateBrushIndirect = ^TEmrCreateBrushIndirect;
  tagEMRCREATEBRUSHINDIRECT = record
    emr: EMR;
    ihBrush: DWORD; // Brush handle index
    lb: LOGBRUSH32; // The style must be BS_SOLID, BS_HOLLOW,
    // BS_NULL or BS_HATCHED.
  end;
  {$EXTERNALSYM tagEMRCREATEBRUSHINDIRECT}
  EMRCREATEBRUSHINDIRECT = tagEMRCREATEBRUSHINDIRECT;
  {$EXTERNALSYM EMRCREATEBRUSHINDIRECT}
  TEmrCreateBrushIndirect = EMRCREATEBRUSHINDIRECT;

  PEmrCreateMonoBrush = ^TEmrCreateMonoBrush;
  tagEMRCREATEMONOBRUSH = record
    emr: EMR;
    ihBrush: DWORD; // Brush handle index
    iUsage: DWORD; // Bitmap info color table usage
    offBmi: DWORD; // Offset to the BITMAPINFO structure
    cbBmi: DWORD; // Size of the BITMAPINFO structure
    offBits: DWORD; // Offset to the bitmap bits
    cbBits: DWORD; // Size of the bitmap bits
  end;
  {$EXTERNALSYM tagEMRCREATEMONOBRUSH}
  EMRCREATEMONOBRUSH = tagEMRCREATEMONOBRUSH;
  {$EXTERNALSYM EMRCREATEMONOBRUSH}
  TEmrCreateMonoBrush = EMRCREATEMONOBRUSH;

  PEmrCreateDibPatternBrushPt = ^TEmrCreateDibPatternBrushPt;
  tagEMRCREATEDIBPATTERNBRUSHPT = record
    emr: EMR;
    ihBrush: DWORD; // Brush handle index
    iUsage: DWORD; // Bitmap info color table usage
    offBmi: DWORD; // Offset to the BITMAPINFO structure
    cbBmi: DWORD; // Size of the BITMAPINFO structure
    // The bitmap info is followed by the bitmap
    // bits to form a packed DIB.
    offBits: DWORD; // Offset to the bitmap bits
    cbBits: DWORD; // Size of the bitmap bits
  end;
  {$EXTERNALSYM tagEMRCREATEDIBPATTERNBRUSHPT}
  EMRCREATEDIBPATTERNBRUSHPT = tagEMRCREATEDIBPATTERNBRUSHPT;
  {$EXTERNALSYM EMRCREATEDIBPATTERNBRUSHPT}
  TEmrCreateDibPatternBrushPt = EMRCREATEDIBPATTERNBRUSHPT;

  PEmrFormat = ^TEmrFormat;
  tagEMRFORMAT = record
    dSignature: DWORD; // Format signature, e.g. ENHMETA_SIGNATURE.
    nVersion: DWORD; // Format version number.
    cbData: DWORD; // Size of data in bytes.
    offData: DWORD; // Offset to data from GDICOMMENT_IDENTIFIER.
    // It must begin at a DWORD offset.
  end;
  {$EXTERNALSYM tagEMRFORMAT}
  EMRFORMAT = tagEMRFORMAT;
  {$EXTERNALSYM EMRFORMAT}
  TEmrFormat = EMRFORMAT;

  PEmrGlsRecord = ^TEmrGlsRecord;
  tagEMRGLSRECORD = record
    emr: EMR;
    cbData: DWORD; // Size of data in bytes
    Data: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRGLSRECORD}
  EMRGLSRECORD = tagEMRGLSRECORD;
  {$EXTERNALSYM EMRGLSRECORD}
  TEmrGlsRecord = EMRGLSRECORD;

  PEmrGlsBoundedRecord = ^TEmrGlsBoundedRecord;
  tagEMRGLSBOUNDEDRECORD = record
    emr: EMR;
    rclBounds: RECTL; // Bounds in recording coordinates
    cbData: DWORD; // Size of data in bytes
    Data: array [0..0] of BYTE;
  end;
  {$EXTERNALSYM tagEMRGLSBOUNDEDRECORD}
  EMRGLSBOUNDEDRECORD = tagEMRGLSBOUNDEDRECORD;
  {$EXTERNALSYM EMRGLSBOUNDEDRECORD}
  TEmrGlsBoundedRecord = EMRGLSBOUNDEDRECORD;

  PEmrPixelFormat = ^TEmrPixelFormat;
  tagEMRPIXELFORMAT = record
    emr: EMR;
    pfd: PIXELFORMATDESCRIPTOR;
  end;
  {$EXTERNALSYM tagEMRPIXELFORMAT}
  EMRPIXELFORMAT = tagEMRPIXELFORMAT;
  {$EXTERNALSYM EMRPIXELFORMAT}
  TEmrPixelFormat = EMRPIXELFORMAT;

  PEmrCreateColorSpace = ^TEmrCreateColorSpace;
  tagEMRCREATECOLORSPACE = record
    emr: EMR;
    ihCS: DWORD; // ColorSpace handle index
    lcs: LOGCOLORSPACEA; // Ansi version of LOGCOLORSPACE
  end;
  {$EXTERNALSYM tagEMRCREATECOLORSPACE}
  EMRCREATECOLORSPACE = tagEMRCREATECOLORSPACE;
  {$EXTERNALSYM EMRCREATECOLORSPACE}
  TEmrCreateColorSpace = EMRCREATECOLORSPACE;

  PEmrSetColorSpace = ^TEmrSetColorSpace;
  tagEMRSETCOLORSPACE = record
    emr: EMR;
    ihCS: DWORD; // ColorSpace handle index
  end;
  {$EXTERNALSYM tagEMRSETCOLORSPACE}
  EMRSETCOLORSPACE = tagEMRSETCOLORSPACE;
  {$EXTERNALSYM EMRSETCOLORSPACE}
  EMRSELECTCOLORSPACE = tagEMRSETCOLORSPACE;
  {$EXTERNALSYM EMRSELECTCOLORSPACE}
  PEMRSELECTCOLORSPACE = ^EMRSELECTCOLORSPACE;
  {$EXTERNALSYM PEMRSELECTCOLORSPACE}
  EMRDELETECOLORSPACE = tagEMRSETCOLORSPACE;
  {$EXTERNALSYM EMRDELETECOLORSPACE}
  PEMRDELETECOLORSPACE = ^EMRDELETECOLORSPACE;
  {$EXTERNALSYM PEMRDELETECOLORSPACE}
  TEmrSetColorSpace = EMRSETCOLORSPACE;

  PEmrExtEscape = ^TEmrExtEscape;
  tagEMREXTESCAPE = record
    emr: EMR;
    iEscape: INT; // Escape code
    cbEscData: INT; // Size of escape data
    EscData: array [0..0] of BYTE; // Escape data
  end;
  {$EXTERNALSYM tagEMREXTESCAPE}
  EMREXTESCAPE = tagEMREXTESCAPE;
  {$EXTERNALSYM EMREXTESCAPE}
  EMRDRAWESCAPE = tagEMREXTESCAPE;
  {$EXTERNALSYM EMRDRAWESCAPE}
  PEMRDRAWESCAPE = ^EMRDRAWESCAPE;
  {$EXTERNALSYM PEMRDRAWESCAPE}
  TEmrExtEscape = EMREXTESCAPE;

  PEmrNamedEscape = ^TEmrNamedEscape;
  tagEMRNAMEDESCAPE = record
    emr: EMR;
    iEscape: INT; // Escape code
    cbDriver: INT; // Size of driver name
    cbEscData: INT; // Size of escape data
    EscData: array [0..0] of BYTE; // Driver name and Escape data
  end;
  {$EXTERNALSYM tagEMRNAMEDESCAPE}
  EMRNAMEDESCAPE = tagEMRNAMEDESCAPE;
  {$EXTERNALSYM EMRNAMEDESCAPE}
  TEmrNamedEscape = EMRNAMEDESCAPE;

const
  SETICMPROFILE_EMBEDED = $00000001;
  {$EXTERNALSYM SETICMPROFILE_EMBEDED}

type
  PEmrSetIcmProfile = ^TEmrSetIcmProfile;
  tagEMRSETICMPROFILE = record
    emr: EMR;
    dwFlags: DWORD; // flags
    cbName: DWORD; // Size of desired profile name
    cbData: DWORD; // Size of raw profile data if attached
    Data: array [0..0] of BYTE; // Array size is cbName + cbData
  end;
  {$EXTERNALSYM tagEMRSETICMPROFILE}
  EMRSETICMPROFILE = tagEMRSETICMPROFILE;
  {$EXTERNALSYM EMRSETICMPROFILE}
  EMRSETICMPROFILEA = tagEMRSETICMPROFILE;
  {$EXTERNALSYM EMRSETICMPROFILEA}
  PEMRSETICMPROFILEA = ^EMRSETICMPROFILEA;
  {$EXTERNALSYM PEMRSETICMPROFILEA}
  EMRSETICMPROFILEW = tagEMRSETICMPROFILE;
  {$EXTERNALSYM EMRSETICMPROFILEW}
  PEMRSETICMPROFILEW = ^EMRSETICMPROFILEW;
  {$EXTERNALSYM PEMRSETICMPROFILEW}
  TEmrSetIcmProfile = EMRSETICMPROFILE;

const
  CREATECOLORSPACE_EMBEDED = $00000001;
  {$EXTERNALSYM CREATECOLORSPACE_EMBEDED}

type
  PEmrCreateColorSpaceW = ^TEmrCreateColorSpaceW;
  tagEMRCREATECOLORSPACEW = record
    emr: EMR;
    ihCS: DWORD; // ColorSpace handle index
    lcs: LOGCOLORSPACEW; // Unicode version of logical color space structure
    dwFlags: DWORD; // flags
    cbData: DWORD; // size of raw source profile data if attached
    Data: array [0..0] of BYTE; // Array size is cbData
  end;
  {$EXTERNALSYM tagEMRCREATECOLORSPACEW}
  EMRCREATECOLORSPACEW = tagEMRCREATECOLORSPACEW;
  {$EXTERNALSYM EMRCREATECOLORSPACEW}
  TEmrCreateColorSpaceW = EMRCREATECOLORSPACEW;

const
  COLORMATCHTOTARGET_EMBEDED = $00000001;
  {$EXTERNALSYM COLORMATCHTOTARGET_EMBEDED}

type
  PColorMatchToTarget = ^TColorMatchToTarget;
  tagCOLORMATCHTOTARGET = record
    emr: EMR;
    dwAction: DWORD;  // CS_ENABLE, CS_DISABLE or CS_DELETE_TRANSFORM
    dwFlags: DWORD;   // flags
    cbName: DWORD;    // Size of desired target profile name
    cbData: DWORD;    // Size of raw target profile data if attached
    Data: array [0..0] of BYTE; // Array size is cbName + cbData
  end;
  {$EXTERNALSYM tagCOLORMATCHTOTARGET}
  //COLORMATCHTOTARGET = tagCOLORMATCHTOTARGET;
  //{$EXTERNALSYM COLORMATCHTOTARGET}
  TColorMatchToTarget = tagCOLORMATCHTOTARGET;

  PColorCorrectPalette = ^TColorCorrectPalette;
  tagCOLORCORRECTPALETTE = record
    emr: EMR;
    ihPalette: DWORD;   // Palette handle index
    nFirstEntry: DWORD; // Index of first entry to correct
    nPalEntries: DWORD; // Number of palette entries to correct
    nReserved: DWORD;   // Reserved
  end;
  {$EXTERNALSYM tagCOLORCORRECTPALETTE}
  //COLORCORRECTPALETTE = tagCOLORCORRECTPALETTE;
  //{$EXTERNALSYM COLORCORRECTPALETTE}
  TColorCorrectPalette = tagCOLORCORRECTPALETTE;

  PEmrAlphaBlend = ^TEmrAlphaBlend;
  tagEMRALPHABLEND = record
    emr: EMR;
    rclBounds: RECTL;       // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    cxDest: LONG;
    cyDest: LONG;
    dwRop: DWORD;
    xSrc: LONG;
    ySrc: LONG;
    xformSrc: XFORM;        // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD;       // Source bitmap info color table usage (DIB_RGB_COLORS)
    offBmiSrc: DWORD;       // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD;        // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD;      // Offset to the source bitmap bits
    cbBitsSrc: DWORD;       // Size of the source bitmap bits
    cxSrc: LONG;
    cySrc: LONG;
  end;
  {$EXTERNALSYM tagEMRALPHABLEND}
  EMRALPHABLEND = tagEMRALPHABLEND;
  {$EXTERNALSYM EMRALPHABLEND}
  TEmrAlphaBlend = EMRALPHABLEND;

  PEmrGradientFill = ^TEmrGradientFill;
  tagEMRGRADIENTFILL = record
    emr: EMR;
    rclBounds: RECTL; // Inclusive-inclusive bounds in device units
    nVer: DWORD;
    nTri: DWORD;
    ulMode: ULONG;
    Ver: array [0..0] of TRIVERTEX;
  end;
  {$EXTERNALSYM tagEMRGRADIENTFILL}
  EMRGRADIENTFILL = tagEMRGRADIENTFILL;
  {$EXTERNALSYM EMRGRADIENTFILL}
  TEmrGradientFill = EMRGRADIENTFILL;

  PEmrTransparentBlt = ^TEmrTransparentBlt;
  tagEMRTRANSPARENTBLT = record
    emr: EMR;
    rclBounds: RECTL;       // Inclusive-inclusive bounds in device units
    xDest: LONG;
    yDest: LONG;
    cxDest: LONG;
    cyDest: LONG;
    dwRop: DWORD;
    xSrc: LONG;
    ySrc: LONG;
    xformSrc: XFORM;        // Source DC transform
    crBkColorSrc: COLORREF; // Source DC BkColor in RGB
    iUsageSrc: DWORD;       // Source bitmap info color table usage
                            // (DIB_RGB_COLORS)
    offBmiSrc: DWORD;       // Offset to the source BITMAPINFO structure
    cbBmiSrc: DWORD;        // Size of the source BITMAPINFO structure
    offBitsSrc: DWORD;      // Offset to the source bitmap bits
    cbBitsSrc: DWORD;       // Size of the source bitmap bits
    cxSrc: LONG;
    cySrc: LONG;
  end;
  {$EXTERNALSYM tagEMRTRANSPARENTBLT}
  EMRTRANSPARENTBLT = tagEMRTRANSPARENTBLT;
  {$EXTERNALSYM EMRTRANSPARENTBLT}
  TEmrTransparentBlt = EMRTRANSPARENTBLT;

const
  GDICOMMENT_IDENTIFIER       = $43494447;
  {$EXTERNALSYM GDICOMMENT_IDENTIFIER}
  GDICOMMENT_WINDOWS_METAFILE = DWORD($80000001);
  {$EXTERNALSYM GDICOMMENT_WINDOWS_METAFILE}
  GDICOMMENT_BEGINGROUP       = $00000002;
  {$EXTERNALSYM GDICOMMENT_BEGINGROUP}
  GDICOMMENT_ENDGROUP         = $00000003;
  {$EXTERNALSYM GDICOMMENT_ENDGROUP}
  GDICOMMENT_MULTIFORMATS     = $40000004;
  {$EXTERNALSYM GDICOMMENT_MULTIFORMATS}
  EPS_SIGNATURE               = $46535045;
  {$EXTERNALSYM EPS_SIGNATURE}
  GDICOMMENT_UNICODE_STRING   = $00000040;
  {$EXTERNALSYM GDICOMMENT_UNICODE_STRING}
  GDICOMMENT_UNICODE_END      = $00000080;
  {$EXTERNALSYM GDICOMMENT_UNICODE_END}

// OpenGL wgl prototypes

function wglCopyContext(hglrcSrc, hglrcDest: HGLRC; mask: UINT): BOOL; stdcall;
{$EXTERNALSYM wglCopyContext}
function wglCreateContext(hdc: HDC): HGLRC; stdcall;
{$EXTERNALSYM wglCreateContext}
function wglCreateLayerContext(hdc: HDC; iLayerPlane: Integer): HGLRC; stdcall;
{$EXTERNALSYM wglCreateLayerContext}
function wglDeleteContext(hglrc: HGLRC): BOOL; stdcall;
{$EXTERNALSYM wglDeleteContext}
function wglGetCurrentContext: HGLRC; stdcall;
{$EXTERNALSYM wglGetCurrentContext}
function wglGetCurrentDC: HDC; stdcall;
{$EXTERNALSYM wglGetCurrentDC}
function wglGetProcAddress(lpszProc: LPCSTR): PROC; stdcall;
{$EXTERNALSYM wglGetProcAddress}
function wglMakeCurrent(hdc: HDC; hglrc: HGLRC): BOOL; stdcall;
{$EXTERNALSYM wglMakeCurrent}
function wglShareLists(hglrc1, hglrc2: HGLRC): BOOL; stdcall;
{$EXTERNALSYM wglShareLists}

function wglUseFontBitmapsA(hdc: HDC; first, count, listBase: DWORD): BOOL; stdcall;
{$EXTERNALSYM wglUseFontBitmapsA}
function wglUseFontBitmapsW(hdc: HDC; first, count, listBase: DWORD): BOOL; stdcall;
{$EXTERNALSYM wglUseFontBitmapsW}
function wglUseFontBitmaps(hdc: HDC; first, count, listBase: DWORD): BOOL; stdcall;
{$EXTERNALSYM wglUseFontBitmaps}

function SwapBuffers(hdc: HDC): BOOL; stdcall;
{$EXTERNALSYM SwapBuffers}

type
  PPointFloat = ^TPointFloat;
  _POINTFLOAT = record
    x: FLOAT;
    y: FLOAT;
  end;
  {$EXTERNALSYM _POINTFLOAT}
  POINTFLOAT = _POINTFLOAT;
  {$EXTERNALSYM POINTFLOAT}
  TPointFloat = _POINTFLOAT;

  PGlyphMetricsFloat = ^TGlyphMetricsFloat;
  _GLYPHMETRICSFLOAT = record
    gmfBlackBoxX: FLOAT;
    gmfBlackBoxY: FLOAT;
    gmfptGlyphOrigin: POINTFLOAT;
    gmfCellIncX: FLOAT;
    gmfCellIncY: FLOAT;
  end;
  {$EXTERNALSYM _GLYPHMETRICSFLOAT}
  GLYPHMETRICSFLOAT = _GLYPHMETRICSFLOAT;
  {$EXTERNALSYM GLYPHMETRICSFLOAT}
  LPGLYPHMETRICSFLOAT = ^GLYPHMETRICSFLOAT;
  {$EXTERNALSYM LPGLYPHMETRICSFLOAT}
  TGlyphMetricsFloat = _GLYPHMETRICSFLOAT;

const
  WGL_FONT_LINES    = 0;
  {$EXTERNALSYM WGL_FONT_LINES}
  WGL_FONT_POLYGONS = 1;
  {$EXTERNALSYM WGL_FONT_POLYGONS}

function wglUseFontOutlinesA(hdc: HDC; first, count, listBase: DWORD; deviation,
  extrusion: FLOAT; format: Integer; lpgmf: LPGLYPHMETRICSFLOAT): BOOL; stdcall;
{$EXTERNALSYM wglUseFontOutlinesA}
function wglUseFontOutlinesW(hdc: HDC; first, count, listBase: DWORD; deviation,
  extrusion: FLOAT; format: Integer; lpgmf: LPGLYPHMETRICSFLOAT): BOOL; stdcall;
{$EXTERNALSYM wglUseFontOutlinesW}
function wglUseFontOutlines(hdc: HDC; first, count, listBase: DWORD; deviation,
  extrusion: FLOAT; format: Integer; lpgmf: LPGLYPHMETRICSFLOAT): BOOL; stdcall;
{$EXTERNALSYM wglUseFontOutlines}

// Layer plane descriptor

type
  PLayerPlaneDescriptor = ^TLayerPlaneDescriptor;
  tagLAYERPLANEDESCRIPTOR = record
    nSize: WORD;
    nVersion: WORD;
    dwFlags: DWORD;
    iPixelType: BYTE;
    cColorBits: BYTE;
    cRedBits: BYTE;
    cRedShift: BYTE;
    cGreenBits: BYTE;
    cGreenShift: BYTE;
    cBlueBits: BYTE;
    cBlueShift: BYTE;
    cAlphaBits: BYTE;
    cAlphaShift: BYTE;
    cAccumBits: BYTE;
    cAccumRedBits: BYTE;
    cAccumGreenBits: BYTE;
    cAccumBlueBits: BYTE;
    cAccumAlphaBits: BYTE;
    cDepthBits: BYTE;
    cStencilBits: BYTE;
    cAuxBuffers: BYTE;
    iLayerPlane: BYTE;
    bReserved: BYTE;
    crTransparent: COLORREF;
  end;
  {$EXTERNALSYM tagLAYERPLANEDESCRIPTOR}
  LAYERPLANEDESCRIPTOR = tagLAYERPLANEDESCRIPTOR;
  {$EXTERNALSYM LAYERPLANEDESCRIPTOR}
  LPLAYERPLANEDESCRIPTOR = ^LAYERPLANEDESCRIPTOR;
  {$EXTERNALSYM LPLAYERPLANEDESCRIPTOR}
  TLayerPlaneDescriptor = LAYERPLANEDESCRIPTOR;

// LAYERPLANEDESCRIPTOR flags

const
  LPD_DOUBLEBUFFER   = $00000001;
  {$EXTERNALSYM LPD_DOUBLEBUFFER}
  LPD_STEREO         = $00000002;
  {$EXTERNALSYM LPD_STEREO}
  LPD_SUPPORT_GDI    = $00000010;
  {$EXTERNALSYM LPD_SUPPORT_GDI}
  LPD_SUPPORT_OPENGL = $00000020;
  {$EXTERNALSYM LPD_SUPPORT_OPENGL}
  LPD_SHARE_DEPTH    = $00000040;
  {$EXTERNALSYM LPD_SHARE_DEPTH}
  LPD_SHARE_STENCIL  = $00000080;
  {$EXTERNALSYM LPD_SHARE_STENCIL}
  LPD_SHARE_ACCUM    = $00000100;
  {$EXTERNALSYM LPD_SHARE_ACCUM}
  LPD_SWAP_EXCHANGE  = $00000200;
  {$EXTERNALSYM LPD_SWAP_EXCHANGE}
  LPD_SWAP_COPY      = $00000400;
  {$EXTERNALSYM LPD_SWAP_COPY}
  LPD_TRANSPARENT    = $00001000;
  {$EXTERNALSYM LPD_TRANSPARENT}

  LPD_TYPE_RGBA       = 0;
  {$EXTERNALSYM LPD_TYPE_RGBA}
  LPD_TYPE_COLORINDEX = 1;
  {$EXTERNALSYM LPD_TYPE_COLORINDEX}

// wglSwapLayerBuffers flags

  WGL_SWAP_MAIN_PLANE = $00000001;
  {$EXTERNALSYM WGL_SWAP_MAIN_PLANE}
  WGL_SWAP_OVERLAY1   = $00000002;
  {$EXTERNALSYM WGL_SWAP_OVERLAY1}
  WGL_SWAP_OVERLAY2   = $00000004;
  {$EXTERNALSYM WGL_SWAP_OVERLAY2}
  WGL_SWAP_OVERLAY3   = $00000008;
  {$EXTERNALSYM WGL_SWAP_OVERLAY3}
  WGL_SWAP_OVERLAY4   = $00000010;
  {$EXTERNALSYM WGL_SWAP_OVERLAY4}
  WGL_SWAP_OVERLAY5   = $00000020;
  {$EXTERNALSYM WGL_SWAP_OVERLAY5}
  WGL_SWAP_OVERLAY6   = $00000040;
  {$EXTERNALSYM WGL_SWAP_OVERLAY6}
  WGL_SWAP_OVERLAY7   = $00000080;
  {$EXTERNALSYM WGL_SWAP_OVERLAY7}
  WGL_SWAP_OVERLAY8   = $00000100;
  {$EXTERNALSYM WGL_SWAP_OVERLAY8}
  WGL_SWAP_OVERLAY9   = $00000200;
  {$EXTERNALSYM WGL_SWAP_OVERLAY9}
  WGL_SWAP_OVERLAY10  = $00000400;
  {$EXTERNALSYM WGL_SWAP_OVERLAY10}
  WGL_SWAP_OVERLAY11  = $00000800;
  {$EXTERNALSYM WGL_SWAP_OVERLAY11}
  WGL_SWAP_OVERLAY12  = $00001000;
  {$EXTERNALSYM WGL_SWAP_OVERLAY12}
  WGL_SWAP_OVERLAY13  = $00002000;
  {$EXTERNALSYM WGL_SWAP_OVERLAY13}
  WGL_SWAP_OVERLAY14  = $00004000;
  {$EXTERNALSYM WGL_SWAP_OVERLAY14}
  WGL_SWAP_OVERLAY15  = $00008000;
  {$EXTERNALSYM WGL_SWAP_OVERLAY15}
  WGL_SWAP_UNDERLAY1  = $00010000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY1}
  WGL_SWAP_UNDERLAY2  = $00020000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY2}
  WGL_SWAP_UNDERLAY3  = $00040000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY3}
  WGL_SWAP_UNDERLAY4  = $00080000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY4}
  WGL_SWAP_UNDERLAY5  = $00100000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY5}
  WGL_SWAP_UNDERLAY6  = $00200000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY6}
  WGL_SWAP_UNDERLAY7  = $00400000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY7}
  WGL_SWAP_UNDERLAY8  = $00800000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY8}
  WGL_SWAP_UNDERLAY9  = $01000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY9}
  WGL_SWAP_UNDERLAY10 = $02000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY10}
  WGL_SWAP_UNDERLAY11 = $04000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY11}
  WGL_SWAP_UNDERLAY12 = $08000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY12}
  WGL_SWAP_UNDERLAY13 = $10000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY13}
  WGL_SWAP_UNDERLAY14 = $20000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY14}
  WGL_SWAP_UNDERLAY15 = $40000000;
  {$EXTERNALSYM WGL_SWAP_UNDERLAY15}

function wglDescribeLayerPlane(hdc: HDC; iPixelFormat, iLayerPlane: Integer;
  nBytes: UINT; plpd: LPLAYERPLANEDESCRIPTOR): BOOL; stdcall;
{$EXTERNALSYM wglDescribeLayerPlane}
function wglSetLayerPaletteEntries(hdc: HDC; iLayerPlane, iStart, cEntries: Integer;
  pcr: LPCOLORREF): Integer; stdcall;
{$EXTERNALSYM wglSetLayerPaletteEntries}
function wglGetLayerPaletteEntries(hdc: HDC; iLayerPlane, iStart, cEntries: Integer;
  pcr: LPCOLORREF): Integer; stdcall;
{$EXTERNALSYM wglGetLayerPaletteEntries}
function wglRealizeLayerPalette(hdc: HDC; iLayerPlane: Integer; bRealize: BOOL): BOOL; stdcall;
{$EXTERNALSYM wglRealizeLayerPalette}
function wglSwapLayerBuffers(hdc: HDC; fuPlanes: UINT): BOOL; stdcall;
{$EXTERNALSYM wglSwapLayerBuffers}

type
  PWglSwap = ^TWglSwap;
  _WGLSWAP = record
    hdc: HDC;
    uiFlags: UINT;
  end;
  {$EXTERNALSYM _WGLSWAP}
  WGLSWAP = _WGLSWAP;
  {$EXTERNALSYM WGLSWAP}
  LPWGLSWAP = ^WGLSWAP;
  {$EXTERNALSYM LPWGLSWAP}
  TWglSwap = _WGLSWAP;

const
  WGL_SWAPMULTIPLE_MAX = 16;
  {$EXTERNALSYM WGL_SWAPMULTIPLE_MAX}

function wglSwapMultipleBuffers(fuCount: UINT; lpBuffers: LPWGLSWAP): DWORD; stdcall;
{$EXTERNALSYM wglSwapMultipleBuffers}

implementation

const
  gdi32 = 'gdi32.dll';
  msimg32 = 'msimg32.dll';
  winspool32 = 'winspool32.drv';
  opengl32 = 'opengl32.dll';
  {$IFDEF UNICODE}
  AWSuffix = 'W';
  {$ELSE}
  AWSuffix = 'A';
  {$ENDIF UNICODE}

function MAKEROP4(Fore, Back: DWORD): DWORD;
begin
  Result := ((Back shl 8) and DWORD($FF000000)) or Fore;
end;

function GetKValue(cmyk: COLORREF): BYTE;
begin
  Result := BYTE(cmyk);
end;

function GetYValue(cmyk: COLORREF): BYTE;
begin
  Result := BYTE(cmyk shr 8);
end;

function GetMValue(cmyk: COLORREF): BYTE;
begin
  Result := BYTE(cmyk shr 16);
end;

function GetCValue(cmyk: COLORREF): BYTE;
begin
  Result := BYTE(cmyk shr 24);
end;

function CMYK(c, m, y, k: BYTE): COLORREF;
begin
  Result := COLORREF(k or (y shl 8) or (m shl 16) or (c shl 24));
end;

function MAKEPOINTS(l: DWORD): POINTS;
begin
  Result.x := LOWORD(l);
  Result.y := HIWORD(l);  
end;

function RGB(r, g, b: BYTE): COLORREF;
begin
  Result := COLORREF(r or (g shl 8) or (b shl 16));
end;

function PALETTERGB(r, g, b: BYTE): COLORREF;
begin
  Result := $02000000 or RGB(r, g, b);
end;

function PALETTEINDEX(i: WORD): COLORREF;
begin
  Result := COLORREF($01000000 or DWORD(i));
end;

function GetRValue(rgb: COLORREF): BYTE;
begin
  Result := BYTE(RGB);
end;

function GetGValue(rgb: COLORREF): BYTE;
begin
  Result := BYTE(rgb shr 8);
end;

function GetBValue(rgb: COLORREF): BYTE;
begin
  Result := BYTE(rgb shr 16);
end;

{$IFDEF DYNAMIC_LINK}

var
  _AddFontResourceA: Pointer;

function AddFontResourceA;
begin
  GetProcedureAddress(_AddFontResourceA, gdi32, 'AddFontResourceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResourceA]
  end;
end;

var
  _AddFontResourceW: Pointer;

function AddFontResourceW;
begin
  GetProcedureAddress(_AddFontResourceW, gdi32, 'AddFontResourceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResourceW]
  end;
end;

var
  _AddFontResource: Pointer;

function AddFontResource;
begin
  GetProcedureAddress(_AddFontResource, gdi32, 'AddFontResource' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResource]
  end;
end;

var
  _AnimatePalette: Pointer;

function AnimatePalette;
begin
  GetProcedureAddress(_AnimatePalette, gdi32, 'AnimatePalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AnimatePalette]
  end;
end;

var
  _Arc: Pointer;

function Arc;
begin
  GetProcedureAddress(_Arc, gdi32, 'Arc');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Arc]
  end;
end;

var
  _BitBlt: Pointer;

function BitBlt;
begin
  GetProcedureAddress(_BitBlt, gdi32, 'BitBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_BitBlt]
  end;
end;

var
  _CancelDC: Pointer;

function CancelDC;
begin
  GetProcedureAddress(_CancelDC, gdi32, 'CancelDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CancelDC]
  end;
end;

var
  _Chord: Pointer;

function Chord;
begin
  GetProcedureAddress(_Chord, gdi32, 'Chord');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Chord]
  end;
end;

var
  _ChoosePixelFormat: Pointer;

function ChoosePixelFormat;
begin
  GetProcedureAddress(_ChoosePixelFormat, gdi32, 'ChoosePixelFormat');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ChoosePixelFormat]
  end;
end;

var
  _CloseMetaFile: Pointer;

function CloseMetaFile;
begin
  GetProcedureAddress(_CloseMetaFile, gdi32, 'CloseMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CloseMetaFile]
  end;
end;

var
  _CombineRgn: Pointer;

function CombineRgn;
begin
  GetProcedureAddress(_CombineRgn, gdi32, 'CombineRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CombineRgn]
  end;
end;

var
  _CopyMetaFileA: Pointer;

function CopyMetaFileA;
begin
  GetProcedureAddress(_CopyMetaFileA, gdi32, 'CopyMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyMetaFileA]
  end;
end;

var
  _CopyMetaFileW: Pointer;

function CopyMetaFileW;
begin
  GetProcedureAddress(_CopyMetaFileW, gdi32, 'CopyMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyMetaFileW]
  end;
end;

var
  _CopyMetaFile: Pointer;

function CopyMetaFile;
begin
  GetProcedureAddress(_CopyMetaFile, gdi32, 'CopyMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyMetaFile]
  end;
end;

var
  _CreateBitmap: Pointer;

function CreateBitmap;
begin
  GetProcedureAddress(_CreateBitmap, gdi32, 'CreateBitmap');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateBitmap]
  end;
end;

var
  _CreateBitmapIndirect: Pointer;

function CreateBitmapIndirect;
begin
  GetProcedureAddress(_CreateBitmapIndirect, gdi32, 'CreateBitmapIndirect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateBitmapIndirect]
  end;
end;

var
  _CreateBrushIndirect: Pointer;

function CreateBrushIndirect;
begin
  GetProcedureAddress(_CreateBrushIndirect, gdi32, 'CreateBrushIndirect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateBrushIndirect]
  end;
end;

var
  _CreateCompatibleBitmap: Pointer;

function CreateCompatibleBitmap;
begin
  GetProcedureAddress(_CreateCompatibleBitmap, gdi32, 'CreateCompatibleBitmap');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateCompatibleBitmap]
  end;
end;

var
  _CreateDiscardableBitmap: Pointer;

function CreateDiscardableBitmap;
begin
  GetProcedureAddress(_CreateDiscardableBitmap, gdi32, 'CreateDiscardableBitmap');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDiscardableBitmap]
  end;
end;

var
  _CreateCompatibleDC: Pointer;

function CreateCompatibleDC;
begin
  GetProcedureAddress(_CreateCompatibleDC, gdi32, 'CreateCompatibleDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateCompatibleDC]
  end;
end;

var
  _CreateDCA: Pointer;

function CreateDCA;
begin
  GetProcedureAddress(_CreateDCA, gdi32, 'CreateDCA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDCA]
  end;
end;

var
  _CreateDCW: Pointer;

function CreateDCW;
begin
  GetProcedureAddress(_CreateDCW, gdi32, 'CreateDCW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDCW]
  end;
end;

var
  _CreateDC: Pointer;

function CreateDC;
begin
  GetProcedureAddress(_CreateDC, gdi32, 'CreateDC' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDC]
  end;
end;

var
  _CreateDIBitmap: Pointer;

function CreateDIBitmap;
begin
  GetProcedureAddress(_CreateDIBitmap, gdi32, 'CreateDIBitmap');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDIBitmap]
  end;
end;

var
  _CreateDIBPatternBrush: Pointer;

function CreateDIBPatternBrush;
begin
  GetProcedureAddress(_CreateDIBPatternBrush, gdi32, 'CreateDIBPatternBrush');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDIBPatternBrush]
  end;
end;

var
  _CreateDIBPatternBrushPt: Pointer;

function CreateDIBPatternBrushPt;
begin
  GetProcedureAddress(_CreateDIBPatternBrushPt, gdi32, 'CreateDIBPatternBrushPt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDIBPatternBrushPt]
  end;
end;

var
  _CreateEllipticRgn: Pointer;

function CreateEllipticRgn;
begin
  GetProcedureAddress(_CreateEllipticRgn, gdi32, 'CreateEllipticRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateEllipticRgn]
  end;
end;

var
  _CreateEllipticRgnIndirect: Pointer;

function CreateEllipticRgnIndirect;
begin
  GetProcedureAddress(_CreateEllipticRgnIndirect, gdi32, 'CreateEllipticRgnIndirect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateEllipticRgnIndirect]
  end;
end;

var
  _CreateFontIndirectA: Pointer;

function CreateFontIndirectA;
begin
  GetProcedureAddress(_CreateFontIndirectA, gdi32, 'CreateFontIndirectA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirectA]
  end;
end;

var
  _CreateFontIndirectW: Pointer;

function CreateFontIndirectW;
begin
  GetProcedureAddress(_CreateFontIndirectW, gdi32, 'CreateFontIndirectW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirectW]
  end;
end;

var
  _CreateFontIndirect: Pointer;

function CreateFontIndirect;
begin
  GetProcedureAddress(_CreateFontIndirect, gdi32, 'CreateFontIndirect' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirect]
  end;
end;

var
  _CreateFontA: Pointer;

function CreateFontA;
begin
  GetProcedureAddress(_CreateFontA, gdi32, 'CreateFontA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontA]
  end;
end;

var
  _CreateFontW: Pointer;

function CreateFontW;
begin
  GetProcedureAddress(_CreateFontW, gdi32, 'CreateFontW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontW]
  end;
end;

var
  _CreateFont: Pointer;

function CreateFont;
begin
  GetProcedureAddress(_CreateFont, gdi32, 'CreateFont' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFont]
  end;
end;

var
  _CreateHatchBrush: Pointer;

function CreateHatchBrush;
begin
  GetProcedureAddress(_CreateHatchBrush, gdi32, 'CreateHatchBrush');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateHatchBrush]
  end;
end;

var
  _CreateICA: Pointer;

function CreateICA;
begin
  GetProcedureAddress(_CreateICA, gdi32, 'CreateICA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateICA]
  end;
end;

var
  _CreateICW: Pointer;

function CreateICW;
begin
  GetProcedureAddress(_CreateICW, gdi32, 'CreateICW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateICW]
  end;
end;

var
  _CreateIC: Pointer;

function CreateIC;
begin
  GetProcedureAddress(_CreateIC, gdi32, 'CreateIC' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateIC]
  end;
end;

var
  _CreateMetaFileA: Pointer;

function CreateMetaFileA;
begin
  GetProcedureAddress(_CreateMetaFileA, gdi32, 'CreateMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateMetaFileA]
  end;
end;

var
  _CreateMetaFileW: Pointer;

function CreateMetaFileW;
begin
  GetProcedureAddress(_CreateMetaFileW, gdi32, 'CreateMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateMetaFileW]
  end;
end;

var
  _CreateMetaFile: Pointer;

function CreateMetaFile;
begin
  GetProcedureAddress(_CreateMetaFile, gdi32, 'CreateMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateMetaFile]
  end;
end;

var
  _CreatePalette: Pointer;

function CreatePalette;
begin
  GetProcedureAddress(_CreatePalette, gdi32, 'CreatePalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePalette]
  end;
end;

var
  _CreatePen: Pointer;

function CreatePen;
begin
  GetProcedureAddress(_CreatePen, gdi32, 'CreatePen');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePen]
  end;
end;

var
  _CreatePenIndirect: Pointer;

function CreatePenIndirect;
begin
  GetProcedureAddress(_CreatePenIndirect, gdi32, 'CreatePenIndirect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePenIndirect]
  end;
end;

var
  _CreatePolyPolygonRgn: Pointer;

function CreatePolyPolygonRgn;
begin
  GetProcedureAddress(_CreatePolyPolygonRgn, gdi32, 'CreatePolyPolygonRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePolyPolygonRgn]
  end;
end;

var
  _CreatePatternBrush: Pointer;

function CreatePatternBrush;
begin
  GetProcedureAddress(_CreatePatternBrush, gdi32, 'CreatePatternBrush');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePatternBrush]
  end;
end;

var
  _CreateRectRgn: Pointer;

function CreateRectRgn;
begin
  GetProcedureAddress(_CreateRectRgn, gdi32, 'CreateRectRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateRectRgn]
  end;
end;

var
  _CreateRectRgnIndirect: Pointer;

function CreateRectRgnIndirect;
begin
  GetProcedureAddress(_CreateRectRgnIndirect, gdi32, 'CreateRectRgnIndirect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateRectRgnIndirect]
  end;
end;

var
  _CreateRoundRectRgn: Pointer;

function CreateRoundRectRgn;
begin
  GetProcedureAddress(_CreateRoundRectRgn, gdi32, 'CreateRoundRectRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateRoundRectRgn]
  end;
end;

var
  _CreateScalableFontResourceA: Pointer;

function CreateScalableFontResourceA;
begin
  GetProcedureAddress(_CreateScalableFontResourceA, gdi32, 'CreateScalableFontResourceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateScalableFontResourceA]
  end;
end;

var
  _CreateScalableFontResourceW: Pointer;

function CreateScalableFontResourceW;
begin
  GetProcedureAddress(_CreateScalableFontResourceW, gdi32, 'CreateScalableFontResourceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateScalableFontResourceW]
  end;
end;

var
  _CreateScalableFontResource: Pointer;

function CreateScalableFontResource;
begin
  GetProcedureAddress(_CreateScalableFontResource, gdi32, 'CreateScalableFontResource' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateScalableFontResource]
  end;
end;

var
  _CreateSolidBrush: Pointer;

function CreateSolidBrush;
begin
  GetProcedureAddress(_CreateSolidBrush, gdi32, 'CreateSolidBrush');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateSolidBrush]
  end;
end;

var
  _DeleteDC: Pointer;

function DeleteDC;
begin
  GetProcedureAddress(_DeleteDC, gdi32, 'DeleteDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeleteDC]
  end;
end;

var
  _DeleteMetaFile: Pointer;

function DeleteMetaFile;
begin
  GetProcedureAddress(_DeleteMetaFile, gdi32, 'DeleteMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeleteMetaFile]
  end;
end;

var
  _DeleteObject: Pointer;

function DeleteObject;
begin
  GetProcedureAddress(_DeleteObject, gdi32, 'DeleteObject');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeleteObject]
  end;
end;

var
  _DescribePixelFormat: Pointer;

function DescribePixelFormat;
begin
  GetProcedureAddress(_DescribePixelFormat, gdi32, 'DescribePixelFormat');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DescribePixelFormat]
  end;
end;

var
  _DeviceCapabilitiesA: Pointer;

function DeviceCapabilitiesA;
begin
  GetProcedureAddress(_DeviceCapabilitiesA, winspool32, 'DeviceCapabilitiesA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeviceCapabilitiesA]
  end;
end;

var
  _DeviceCapabilitiesW: Pointer;

function DeviceCapabilitiesW;
begin
  GetProcedureAddress(_DeviceCapabilitiesW, winspool32, 'DeviceCapabilitiesW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeviceCapabilitiesW]
  end;
end;

var
  _DeviceCapabilities: Pointer;

function DeviceCapabilities;
begin
  GetProcedureAddress(_DeviceCapabilities, winspool32, 'DeviceCapabilities' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeviceCapabilities]
  end;
end;

var
  _DrawEscape: Pointer;

function DrawEscape;
begin
  GetProcedureAddress(_DrawEscape, gdi32, 'DrawEscape');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DrawEscape]
  end;
end;

var
  _Ellipse: Pointer;

function Ellipse;
begin
  GetProcedureAddress(_Ellipse, gdi32, 'Ellipse');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Ellipse]
  end;
end;

var
  _EnumFontFamiliesExA: Pointer;

function EnumFontFamiliesExA;
begin
  GetProcedureAddress(_EnumFontFamiliesExA, gdi32, 'EnumFontFamiliesExA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamiliesExA]
  end;
end;

var
  _EnumFontFamiliesExW: Pointer;

function EnumFontFamiliesExW;
begin
  GetProcedureAddress(_EnumFontFamiliesExW, gdi32, 'EnumFontFamiliesExW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamiliesExW]
  end;
end;

var
  _EnumFontFamiliesEx: Pointer;

function EnumFontFamiliesEx;
begin
  GetProcedureAddress(_EnumFontFamiliesEx, gdi32, 'EnumFontFamiliesEx' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamiliesEx]
  end;
end;

var
  _EnumFontFamiliesA: Pointer;

function EnumFontFamiliesA;
begin
  GetProcedureAddress(_EnumFontFamiliesA, gdi32, 'EnumFontFamiliesA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamiliesA]
  end;
end;

var
  _EnumFontFamiliesW: Pointer;

function EnumFontFamiliesW;
begin
  GetProcedureAddress(_EnumFontFamiliesW, gdi32, 'EnumFontFamiliesW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamiliesW]
  end;
end;

var
  _EnumFontFamilies: Pointer;

function EnumFontFamilies;
begin
  GetProcedureAddress(_EnumFontFamilies, gdi32, 'EnumFontFamilies' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontFamilies]
  end;
end;

var
  _EnumFontsA: Pointer;

function EnumFontsA;
begin
  GetProcedureAddress(_EnumFontsA, gdi32, 'EnumFontsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontsA]
  end;
end;

var
  _EnumFontsW: Pointer;

function EnumFontsW;
begin
  GetProcedureAddress(_EnumFontsW, gdi32, 'EnumFontsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFontsW]
  end;
end;

var
  _EnumFonts: Pointer;

function EnumFonts;
begin
  GetProcedureAddress(_EnumFonts, gdi32, 'EnumFonts' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumFonts]
  end;
end;

var
  _EnumObjects: Pointer;

function EnumObjects;
begin
  GetProcedureAddress(_EnumObjects, gdi32, 'EnumObjects');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumObjects]
  end;
end;

var
  _EqualRgn: Pointer;

function EqualRgn;
begin
  GetProcedureAddress(_EqualRgn, gdi32, 'EqualRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EqualRgn]
  end;
end;

var
  _Escape: Pointer;

function Escape;
begin
  GetProcedureAddress(_Escape, gdi32, 'Escape');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Escape]
  end;
end;

var
  _ExtEscape: Pointer;

function ExtEscape;
begin
  GetProcedureAddress(_ExtEscape, gdi32, 'ExtEscape');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtEscape]
  end;
end;

var
  _ExcludeClipRect: Pointer;

function ExcludeClipRect;
begin
  GetProcedureAddress(_ExcludeClipRect, gdi32, 'ExcludeClipRect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExcludeClipRect]
  end;
end;

var
  _ExtCreateRegion: Pointer;

function ExtCreateRegion;
begin
  GetProcedureAddress(_ExtCreateRegion, gdi32, 'ExtCreateRegion');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtCreateRegion]
  end;
end;

var
  _ExtFloodFill: Pointer;

function ExtFloodFill;
begin
  GetProcedureAddress(_ExtFloodFill, gdi32, 'ExtFloodFill');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtFloodFill]
  end;
end;

var
  _FillRgn: Pointer;

function FillRgn;
begin
  GetProcedureAddress(_FillRgn, gdi32, 'FillRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FillRgn]
  end;
end;

var
  _FloodFill: Pointer;

function FloodFill;
begin
  GetProcedureAddress(_FloodFill, gdi32, 'FloodFill');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FloodFill]
  end;
end;

var
  _FrameRgn: Pointer;

function FrameRgn;
begin
  GetProcedureAddress(_FrameRgn, gdi32, 'FrameRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FrameRgn]
  end;
end;

var
  _GetROP2: Pointer;

function GetROP2;
begin
  GetProcedureAddress(_GetROP2, gdi32, 'GetROP2');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetROP2]
  end;
end;

var
  _GetAspectRatioFilterEx: Pointer;

function GetAspectRatioFilterEx;
begin
  GetProcedureAddress(_GetAspectRatioFilterEx, gdi32, 'GetAspectRatioFilterEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetAspectRatioFilterEx]
  end;
end;

var
  _GetBkColor: Pointer;

function GetBkColor;
begin
  GetProcedureAddress(_GetBkColor, gdi32, 'GetBkColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBkColor]
  end;
end;

var
  _GetDCBrushColor: Pointer;

function GetDCBrushColor;
begin
  GetProcedureAddress(_GetDCBrushColor, gdi32, 'GetDCBrushColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDCBrushColor]
  end;
end;

var
  _GetDCPenColor: Pointer;

function GetDCPenColor;
begin
  GetProcedureAddress(_GetDCPenColor, gdi32, 'GetDCPenColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDCPenColor]
  end;
end;

var
  _GetBkMode: Pointer;

function GetBkMode;
begin
  GetProcedureAddress(_GetBkMode, gdi32, 'GetBkMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBkMode]
  end;
end;

var
  _GetBitmapBits: Pointer;

function GetBitmapBits;
begin
  GetProcedureAddress(_GetBitmapBits, gdi32, 'GetBitmapBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBitmapBits]
  end;
end;

var
  _GetBitmapDimensionEx: Pointer;

function GetBitmapDimensionEx;
begin
  GetProcedureAddress(_GetBitmapDimensionEx, gdi32, 'GetBitmapDimensionEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBitmapDimensionEx]
  end;
end;

var
  _GetBoundsRect: Pointer;

function GetBoundsRect;
begin
  GetProcedureAddress(_GetBoundsRect, gdi32, 'GetBoundsRect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBoundsRect]
  end;
end;

var
  _GetBrushOrgEx: Pointer;

function GetBrushOrgEx;
begin
  GetProcedureAddress(_GetBrushOrgEx, gdi32, 'GetBrushOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetBrushOrgEx]
  end;
end;

var
  _GetCharWidthA: Pointer;

function GetCharWidthA;
begin
  GetProcedureAddress(_GetCharWidthA, gdi32, 'GetCharWidthA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthA]
  end;
end;

var
  _GetCharWidthW: Pointer;

function GetCharWidthW;
begin
  GetProcedureAddress(_GetCharWidthW, gdi32, 'GetCharWidthW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthW]
  end;
end;

var
  _GetCharWidth: Pointer;

function GetCharWidth;
begin
  GetProcedureAddress(_GetCharWidth, gdi32, 'GetCharWidth' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidth]
  end;
end;

var
  _GetCharWidth32A: Pointer;

function GetCharWidth32A;
begin
  GetProcedureAddress(_GetCharWidth32A, gdi32, 'GetCharWidth32A');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidth32A]
  end;
end;

var
  _GetCharWidth32W: Pointer;

function GetCharWidth32W;
begin
  GetProcedureAddress(_GetCharWidth32W, gdi32, 'GetCharWidth32W');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidth32W]
  end;
end;

var
  _GetCharWidth32: Pointer;

function GetCharWidth32;
begin
  GetProcedureAddress(_GetCharWidth32, gdi32, 'GetCharWidth32' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidth32]
  end;
end;

var
  _GetCharWidthFloatA: Pointer;

function GetCharWidthFloatA;
begin
  GetProcedureAddress(_GetCharWidthFloatA, gdi32, 'GetCharWidthFloatA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthFloatA]
  end;
end;

var
  _GetCharWidthFloatW: Pointer;

function GetCharWidthFloatW;
begin
  GetProcedureAddress(_GetCharWidthFloatW, gdi32, 'GetCharWidthFloatW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthFloatW]
  end;
end;

var
  _GetCharWidthFloat: Pointer;

function GetCharWidthFloat;
begin
  GetProcedureAddress(_GetCharWidthFloat, gdi32, 'GetCharWidthFloat' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthFloat]
  end;
end;

var
  _GetCharABCWidthsA: Pointer;

function GetCharABCWidthsA;
begin
  GetProcedureAddress(_GetCharABCWidthsA, gdi32, 'GetCharABCWidthsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsA]
  end;
end;

var
  _GetCharABCWidthsW: Pointer;

function GetCharABCWidthsW;
begin
  GetProcedureAddress(_GetCharABCWidthsW, gdi32, 'GetCharABCWidthsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsW]
  end;
end;

var
  _GetCharABCWidths: Pointer;

function GetCharABCWidths;
begin
  GetProcedureAddress(_GetCharABCWidths, gdi32, 'GetCharABCWidths' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidths]
  end;
end;

var
  _GetCharABCWidthsFloatA: Pointer;

function GetCharABCWidthsFloatA;
begin
  GetProcedureAddress(_GetCharABCWidthsFloatA, gdi32, 'GetCharABCWidthsFloatA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsFloatA]
  end;
end;

var
  _GetCharABCWidthsFloatW: Pointer;

function GetCharABCWidthsFloatW;
begin
  GetProcedureAddress(_GetCharABCWidthsFloatW, gdi32, 'GetCharABCWidthsFloatW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsFloatW]
  end;
end;

var
  _GetCharABCWidthsFloat: Pointer;

function GetCharABCWidthsFloat;
begin
  GetProcedureAddress(_GetCharABCWidthsFloat, gdi32, 'GetCharABCWidthsFloat' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsFloat]
  end;
end;

var
  _GetClipBox: Pointer;

function GetClipBox;
begin
  GetProcedureAddress(_GetClipBox, gdi32, 'GetClipBox');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetClipBox]
  end;
end;

var
  _GetClipRgn: Pointer;

function GetClipRgn;
begin
  GetProcedureAddress(_GetClipRgn, gdi32, 'GetClipRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetClipRgn]
  end;
end;

var
  _GetMetaRgn: Pointer;

function GetMetaRgn;
begin
  GetProcedureAddress(_GetMetaRgn, gdi32, 'GetMetaRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMetaRgn]
  end;
end;

var
  _GetCurrentObject: Pointer;

function GetCurrentObject;
begin
  GetProcedureAddress(_GetCurrentObject, gdi32, 'GetCurrentObject');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCurrentObject]
  end;
end;

var
  _GetCurrentPositionEx: Pointer;

function GetCurrentPositionEx;
begin
  GetProcedureAddress(_GetCurrentPositionEx, gdi32, 'GetCurrentPositionEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCurrentPositionEx]
  end;
end;

var
  _GetDeviceCaps: Pointer;

function GetDeviceCaps;
begin
  GetProcedureAddress(_GetDeviceCaps, gdi32, 'GetDeviceCaps');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDeviceCaps]
  end;
end;

var
  _GetDIBits: Pointer;

function GetDIBits;
begin
  GetProcedureAddress(_GetDIBits, gdi32, 'GetDIBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDIBits]
  end;
end;

var
  _GetFontData: Pointer;

function GetFontData;
begin
  GetProcedureAddress(_GetFontData, gdi32, 'GetFontData');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetFontData]
  end;
end;

var
  _GetGlyphOutlineA: Pointer;

function GetGlyphOutlineA;
begin
  GetProcedureAddress(_GetGlyphOutlineA, gdi32, 'GetGlyphOutlineA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphOutlineA]
  end;
end;

var
  _GetGlyphOutlineW: Pointer;

function GetGlyphOutlineW;
begin
  GetProcedureAddress(_GetGlyphOutlineW, gdi32, 'GetGlyphOutlineW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphOutlineW]
  end;
end;

var
  _GetGlyphOutline: Pointer;

function GetGlyphOutline;
begin
  GetProcedureAddress(_GetGlyphOutline, gdi32, 'GetGlyphOutline' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphOutline]
  end;
end;

var
  _GetGraphicsMode: Pointer;

function GetGraphicsMode;
begin
  GetProcedureAddress(_GetGraphicsMode, gdi32, 'GetGraphicsMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGraphicsMode]
  end;
end;

var
  _GetMapMode: Pointer;

function GetMapMode;
begin
  GetProcedureAddress(_GetMapMode, gdi32, 'GetMapMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMapMode]
  end;
end;

var
  _GetMetaFileBitsEx: Pointer;

function GetMetaFileBitsEx;
begin
  GetProcedureAddress(_GetMetaFileBitsEx, gdi32, 'GetMetaFileBitsEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMetaFileBitsEx]
  end;
end;

var
  _GetMetaFileA: Pointer;

function GetMetaFileA;
begin
  GetProcedureAddress(_GetMetaFileA, gdi32, 'GetMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMetaFileA]
  end;
end;

var
  _GetMetaFileW: Pointer;

function GetMetaFileW;
begin
  GetProcedureAddress(_GetMetaFileW, gdi32, 'GetMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMetaFileW]
  end;
end;

var
  _GetMetaFile: Pointer;

function GetMetaFile;
begin
  GetProcedureAddress(_GetMetaFile, gdi32, 'GetMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMetaFile]
  end;
end;

var
  _GetNearestColor: Pointer;

function GetNearestColor;
begin
  GetProcedureAddress(_GetNearestColor, gdi32, 'GetNearestColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetNearestColor]
  end;
end;

var
  _GetNearestPaletteIndex: Pointer;

function GetNearestPaletteIndex;
begin
  GetProcedureAddress(_GetNearestPaletteIndex, gdi32, 'GetNearestPaletteIndex');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetNearestPaletteIndex]
  end;
end;

var
  _GetObjectType: Pointer;

function GetObjectType;
begin
  GetProcedureAddress(_GetObjectType, gdi32, 'GetObjectType');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetObjectType]
  end;
end;

var
  _GetOutlineTextMetricsA: Pointer;

function GetOutlineTextMetricsA;
begin
  GetProcedureAddress(_GetOutlineTextMetricsA, gdi32, 'GetOutlineTextMetricsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetOutlineTextMetricsA]
  end;
end;

var
  _GetOutlineTextMetricsW: Pointer;

function GetOutlineTextMetricsW;
begin
  GetProcedureAddress(_GetOutlineTextMetricsW, gdi32, 'GetOutlineTextMetricsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetOutlineTextMetricsW]
  end;
end;

var
  _GetOutlineTextMetrics: Pointer;

function GetOutlineTextMetrics;
begin
  GetProcedureAddress(_GetOutlineTextMetrics, gdi32, 'GetOutlineTextMetrics' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetOutlineTextMetrics]
  end;
end;

var
  _GetPaletteEntries: Pointer;

function GetPaletteEntries;
begin
  GetProcedureAddress(_GetPaletteEntries, gdi32, 'GetPaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetPaletteEntries]
  end;
end;

var
  _GetPixel: Pointer;

function GetPixel;
begin
  GetProcedureAddress(_GetPixel, gdi32, 'GetPixel');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetPixel]
  end;
end;

var
  _GetPixelFormat: Pointer;

function GetPixelFormat;
begin
  GetProcedureAddress(_GetPixelFormat, gdi32, 'GetPixelFormat');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetPixelFormat]
  end;
end;

var
  _GetPolyFillMode: Pointer;

function GetPolyFillMode;
begin
  GetProcedureAddress(_GetPolyFillMode, gdi32, 'GetPolyFillMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetPolyFillMode]
  end;
end;

var
  _GetRasterizerCaps: Pointer;

function GetRasterizerCaps;
begin
  GetProcedureAddress(_GetRasterizerCaps, gdi32, 'GetRasterizerCaps');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetRasterizerCaps]
  end;
end;

var
  _GetRandomRgn: Pointer;

function GetRandomRgn;
begin
  GetProcedureAddress(_GetRandomRgn, gdi32, 'GetRandomRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetRandomRgn]
  end;
end;

var
  _GetRegionData: Pointer;

function GetRegionData;
begin
  GetProcedureAddress(_GetRegionData, gdi32, 'GetRegionData');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetRegionData]
  end;
end;

var
  _GetRgnBox: Pointer;

function GetRgnBox;
begin
  GetProcedureAddress(_GetRgnBox, gdi32, 'GetRgnBox');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetRgnBox]
  end;
end;

var
  _GetStockObject: Pointer;

function GetStockObject;
begin
  GetProcedureAddress(_GetStockObject, gdi32, 'GetStockObject');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetStockObject]
  end;
end;

var
  _GetStretchBltMode: Pointer;

function GetStretchBltMode;
begin
  GetProcedureAddress(_GetStretchBltMode, gdi32, 'GetStretchBltMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetStretchBltMode]
  end;
end;

var
  _GetSystemPaletteEntries: Pointer;

function GetSystemPaletteEntries;
begin
  GetProcedureAddress(_GetSystemPaletteEntries, gdi32, 'GetSystemPaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetSystemPaletteEntries]
  end;
end;

var
  _GetSystemPaletteUse: Pointer;

function GetSystemPaletteUse;
begin
  GetProcedureAddress(_GetSystemPaletteUse, gdi32, 'GetSystemPaletteUse');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetSystemPaletteUse]
  end;
end;

var
  _GetTextCharacterExtra: Pointer;

function GetTextCharacterExtra;
begin
  GetProcedureAddress(_GetTextCharacterExtra, gdi32, 'GetTextCharacterExtra');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextCharacterExtra]
  end;
end;

var
  _GetTextAlign: Pointer;

function GetTextAlign;
begin
  GetProcedureAddress(_GetTextAlign, gdi32, 'GetTextAlign');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextAlign]
  end;
end;

var
  _GetTextColor: Pointer;

function GetTextColor;
begin
  GetProcedureAddress(_GetTextColor, gdi32, 'GetTextColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextColor]
  end;
end;

var
  _GetTextExtentPointA: Pointer;

function GetTextExtentPointA;
begin
  GetProcedureAddress(_GetTextExtentPointA, gdi32, 'GetTextExtentPointA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPointA]
  end;
end;

var
  _GetTextExtentPointW: Pointer;

function GetTextExtentPointW;
begin
  GetProcedureAddress(_GetTextExtentPointW, gdi32, 'GetTextExtentPointW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPointW]
  end;
end;

var
  _GetTextExtentPoint: Pointer;

function GetTextExtentPoint;
begin
  GetProcedureAddress(_GetTextExtentPoint, gdi32, 'GetTextExtentPoint' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPoint]
  end;
end;

var
  _GetTextExtentPoint32A: Pointer;

function GetTextExtentPoint32A;
begin
  GetProcedureAddress(_GetTextExtentPoint32A, gdi32, 'GetTextExtentPoint32A');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPoint32A]
  end;
end;

var
  _GetTextExtentPoint32W: Pointer;

function GetTextExtentPoint32W;
begin
  GetProcedureAddress(_GetTextExtentPoint32W, gdi32, 'GetTextExtentPoint32W');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPoint32W]
  end;
end;

var
  _GetTextExtentPoint32: Pointer;

function GetTextExtentPoint32;
begin
  GetProcedureAddress(_GetTextExtentPoint32, gdi32, 'GetTextExtentPoint32' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPoint32]
  end;
end;

var
  _GetTextExtentExPointA: Pointer;

function GetTextExtentExPointA;
begin
  GetProcedureAddress(_GetTextExtentExPointA, gdi32, 'GetTextExtentExPointA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentExPointA]
  end;
end;

var
  _GetTextExtentExPointW: Pointer;

function GetTextExtentExPointW;
begin
  GetProcedureAddress(_GetTextExtentExPointW, gdi32, 'GetTextExtentExPointW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentExPointW]
  end;
end;

var
  _GetTextExtentExPoint: Pointer;

function GetTextExtentExPoint;
begin
  GetProcedureAddress(_GetTextExtentExPoint, gdi32, 'GetTextExtentExPoint' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentExPoint]
  end;
end;

var
  _GetTextCharset: Pointer;

function GetTextCharset;
begin
  GetProcedureAddress(_GetTextCharset, gdi32, 'GetTextCharset');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextCharset]
  end;
end;

var
  _GetTextCharsetInfo: Pointer;

function GetTextCharsetInfo;
begin
  GetProcedureAddress(_GetTextCharsetInfo, gdi32, 'GetTextCharsetInfo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextCharsetInfo]
  end;
end;

var
  _TranslateCharsetInfo: Pointer;

function TranslateCharsetInfo;
begin
  GetProcedureAddress(_TranslateCharsetInfo, gdi32, 'TranslateCharsetInfo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_TranslateCharsetInfo]
  end;
end;

var
  _GetFontLanguageInfo: Pointer;

function GetFontLanguageInfo;
begin
  GetProcedureAddress(_GetFontLanguageInfo, gdi32, 'GetFontLanguageInfo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetFontLanguageInfo]
  end;
end;

var
  _GetCharacterPlacementA: Pointer;

function GetCharacterPlacementA;
begin
  GetProcedureAddress(_GetCharacterPlacementA, gdi32, 'GetCharacterPlacementA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharacterPlacementA]
  end;
end;

var
  _GetCharacterPlacementW: Pointer;

function GetCharacterPlacementW;
begin
  GetProcedureAddress(_GetCharacterPlacementW, gdi32, 'GetCharacterPlacementW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharacterPlacementW]
  end;
end;

var
  _GetCharacterPlacement: Pointer;

function GetCharacterPlacement;
begin
  GetProcedureAddress(_GetCharacterPlacement, gdi32, 'GetCharacterPlacement' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharacterPlacement]
  end;
end;

var
  _GetFontUnicodeRanges: Pointer;

function GetFontUnicodeRanges;
begin
  GetProcedureAddress(_GetFontUnicodeRanges, gdi32, 'GetFontUnicodeRanges');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetFontUnicodeRanges]
  end;
end;

var
  _GetGlyphIndicesA: Pointer;

function GetGlyphIndicesA;
begin
  GetProcedureAddress(_GetGlyphIndicesA, gdi32, 'GetGlyphIndicesA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphIndicesA]
  end;
end;

var
  _GetGlyphIndicesW: Pointer;

function GetGlyphIndicesW;
begin
  GetProcedureAddress(_GetGlyphIndicesW, gdi32, 'GetGlyphIndicesW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphIndicesW]
  end;
end;

var
  _GetGlyphIndices: Pointer;

function GetGlyphIndices;
begin
  GetProcedureAddress(_GetGlyphIndices, gdi32, 'GetGlyphIndices' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetGlyphIndices]
  end;
end;

var
  _GetTextExtentPointI: Pointer;

function GetTextExtentPointI;
begin
  GetProcedureAddress(_GetTextExtentPointI, gdi32, 'GetTextExtentPointI');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentPointI]
  end;
end;

var
  _GetTextExtentExPointI: Pointer;

function GetTextExtentExPointI;
begin
  GetProcedureAddress(_GetTextExtentExPointI, gdi32, 'GetTextExtentExPointI');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextExtentExPointI]
  end;
end;

var
  _GetCharWidthI: Pointer;

function GetCharWidthI;
begin
  GetProcedureAddress(_GetCharWidthI, gdi32, 'GetCharWidthI');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharWidthI]
  end;
end;

var
  _GetCharABCWidthsI: Pointer;

function GetCharABCWidthsI;
begin
  GetProcedureAddress(_GetCharABCWidthsI, gdi32, 'GetCharABCWidthsI');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetCharABCWidthsI]
  end;
end;

var
  _AddFontResourceExA: Pointer;

function AddFontResourceExA;
begin
  GetProcedureAddress(_AddFontResourceExA, gdi32, 'AddFontResourceExA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResourceExA]
  end;
end;

var
  _AddFontResourceExW: Pointer;

function AddFontResourceExW;
begin
  GetProcedureAddress(_AddFontResourceExW, gdi32, 'AddFontResourceExW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResourceExW]
  end;
end;

var
  _AddFontResourceEx: Pointer;

function AddFontResourceEx;
begin
  GetProcedureAddress(_AddFontResourceEx, gdi32, 'AddFontResourceEx' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontResourceEx]
  end;
end;

var
  _RemoveFontResourceExA: Pointer;

function RemoveFontResourceExA;
begin
  GetProcedureAddress(_RemoveFontResourceExA, gdi32, 'RemoveFontResourceExA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResourceExA]
  end;
end;

var
  _RemoveFontResourceExW: Pointer;

function RemoveFontResourceExW;
begin
  GetProcedureAddress(_RemoveFontResourceExW, gdi32, 'RemoveFontResourceExW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResourceExW]
  end;
end;

var
  _RemoveFontResourceEx: Pointer;

function RemoveFontResourceEx;
begin
  GetProcedureAddress(_RemoveFontResourceEx, gdi32, 'RemoveFontResourceEx' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResourceEx]
  end;
end;

var
  _AddFontMemResourceEx: Pointer;

function AddFontMemResourceEx;
begin
  GetProcedureAddress(_AddFontMemResourceEx, gdi32, 'AddFontMemResourceEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AddFontMemResourceEx]
  end;
end;

var
  _RemoveFontMemResourceEx: Pointer;

function RemoveFontMemResourceEx;
begin
  GetProcedureAddress(_RemoveFontMemResourceEx, gdi32, 'RemoveFontMemResourceEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontMemResourceEx]
  end;
end;

var
  _CreateFontIndirectExA: Pointer;

function CreateFontIndirectExA;
begin
  GetProcedureAddress(_CreateFontIndirectExA, gdi32, 'CreateFontIndirectExA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirectExA]
  end;
end;

var
  _CreateFontIndirectExW: Pointer;

function CreateFontIndirectExW;
begin
  GetProcedureAddress(_CreateFontIndirectExW, gdi32, 'CreateFontIndirectExW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirectExW]
  end;
end;

var
  _CreateFontIndirectEx: Pointer;

function CreateFontIndirectEx;
begin
  GetProcedureAddress(_CreateFontIndirectEx, gdi32, 'CreateFontIndirectEx' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateFontIndirectEx]
  end;
end;

var
  _GetViewportExtEx: Pointer;

function GetViewportExtEx;
begin
  GetProcedureAddress(_GetViewportExtEx, gdi32, 'GetViewportExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetViewportExtEx]
  end;
end;

var
  _GetViewportOrgEx: Pointer;

function GetViewportOrgEx;
begin
  GetProcedureAddress(_GetViewportOrgEx, gdi32, 'GetViewportOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetViewportOrgEx]
  end;
end;

var
  _GetWindowExtEx: Pointer;

function GetWindowExtEx;
begin
  GetProcedureAddress(_GetWindowExtEx, gdi32, 'GetWindowExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetWindowExtEx]
  end;
end;

var
  _GetWindowOrgEx: Pointer;

function GetWindowOrgEx;
begin
  GetProcedureAddress(_GetWindowOrgEx, gdi32, 'GetWindowOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetWindowOrgEx]
  end;
end;

var
  _IntersectClipRect: Pointer;

function IntersectClipRect;
begin
  GetProcedureAddress(_IntersectClipRect, gdi32, 'IntersectClipRect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_IntersectClipRect]
  end;
end;

var
  _InvertRgn: Pointer;

function InvertRgn;
begin
  GetProcedureAddress(_InvertRgn, gdi32, 'InvertRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_InvertRgn]
  end;
end;

var
  _LineDDA: Pointer;

function LineDDA;
begin
  GetProcedureAddress(_LineDDA, gdi32, 'LineDDA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_LineDDA]
  end;
end;

var
  _LineTo: Pointer;

function LineTo;
begin
  GetProcedureAddress(_LineTo, gdi32, 'LineTo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_LineTo]
  end;
end;

var
  _MaskBlt: Pointer;

function MaskBlt;
begin
  GetProcedureAddress(_MaskBlt, gdi32, 'MaskBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_MaskBlt]
  end;
end;

var
  _PlgBlt: Pointer;

function PlgBlt;
begin
  GetProcedureAddress(_PlgBlt, gdi32, 'PlgBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PlgBlt]
  end;
end;

var
  _OffsetClipRgn: Pointer;

function OffsetClipRgn;
begin
  GetProcedureAddress(_OffsetClipRgn, gdi32, 'OffsetClipRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_OffsetClipRgn]
  end;
end;

var
  _OffsetRgn: Pointer;

function OffsetRgn;
begin
  GetProcedureAddress(_OffsetRgn, gdi32, 'OffsetRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_OffsetRgn]
  end;
end;

var
  _PatBlt: Pointer;

function PatBlt;
begin
  GetProcedureAddress(_PatBlt, gdi32, 'PatBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PatBlt]
  end;
end;

var
  _Pie: Pointer;

function Pie;
begin
  GetProcedureAddress(_Pie, gdi32, 'Pie');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Pie]
  end;
end;

var
  _PlayMetaFile: Pointer;

function PlayMetaFile;
begin
  GetProcedureAddress(_PlayMetaFile, gdi32, 'PlayMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PlayMetaFile]
  end;
end;

var
  _PaintRgn: Pointer;

function PaintRgn;
begin
  GetProcedureAddress(_PaintRgn, gdi32, 'PaintRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PaintRgn]
  end;
end;

var
  _PolyPolygon: Pointer;

function PolyPolygon;
begin
  GetProcedureAddress(_PolyPolygon, gdi32, 'PolyPolygon');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyPolygon]
  end;
end;

var
  _PtInRegion: Pointer;

function PtInRegion;
begin
  GetProcedureAddress(_PtInRegion, gdi32, 'PtInRegion');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PtInRegion]
  end;
end;

var
  _PtVisible: Pointer;

function PtVisible;
begin
  GetProcedureAddress(_PtVisible, gdi32, 'PtVisible');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PtVisible]
  end;
end;

var
  _RectInRegion: Pointer;

function RectInRegion;
begin
  GetProcedureAddress(_RectInRegion, gdi32, 'RectInRegion');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RectInRegion]
  end;
end;

var
  _RectVisible: Pointer;

function RectVisible;
begin
  GetProcedureAddress(_RectVisible, gdi32, 'RectVisible');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RectVisible]
  end;
end;

var
  _Rectangle: Pointer;

function Rectangle;
begin
  GetProcedureAddress(_Rectangle, gdi32, 'Rectangle');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Rectangle]
  end;
end;

var
  _RestoreDC: Pointer;

function RestoreDC;
begin
  GetProcedureAddress(_RestoreDC, gdi32, 'RestoreDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RestoreDC]
  end;
end;

var
  _ResetDCA: Pointer;

function ResetDCA;
begin
  GetProcedureAddress(_ResetDCA, gdi32, 'ResetDCA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ResetDCA]
  end;
end;

var
  _ResetDCW: Pointer;

function ResetDCW;
begin
  GetProcedureAddress(_ResetDCW, gdi32, 'ResetDCW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ResetDCW]
  end;
end;

var
  _ResetDC: Pointer;

function ResetDC;
begin
  GetProcedureAddress(_ResetDC, gdi32, 'ResetDC' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ResetDC]
  end;
end;

var
  _RealizePalette: Pointer;

function RealizePalette;
begin
  GetProcedureAddress(_RealizePalette, gdi32, 'RealizePalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RealizePalette]
  end;
end;

var
  _RemoveFontResourceA: Pointer;

function RemoveFontResourceA;
begin
  GetProcedureAddress(_RemoveFontResourceA, gdi32, 'RemoveFontResourceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResourceA]
  end;
end;

var
  _RemoveFontResourceW: Pointer;

function RemoveFontResourceW;
begin
  GetProcedureAddress(_RemoveFontResourceW, gdi32, 'RemoveFontResourceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResourceW]
  end;
end;

var
  _RemoveFontResource: Pointer;

function RemoveFontResource;
begin
  GetProcedureAddress(_RemoveFontResource, gdi32, 'RemoveFontResource' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RemoveFontResource]
  end;
end;

var
  _RoundRect: Pointer;

function RoundRect;
begin
  GetProcedureAddress(_RoundRect, gdi32, 'RoundRect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_RoundRect]
  end;
end;

var
  _ResizePalette: Pointer;

function ResizePalette;
begin
  GetProcedureAddress(_ResizePalette, gdi32, 'ResizePalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ResizePalette]
  end;
end;

var
  _SaveDC: Pointer;

function SaveDC;
begin
  GetProcedureAddress(_SaveDC, gdi32, 'SaveDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SaveDC]
  end;
end;

var
  _SelectClipRgn: Pointer;

function SelectClipRgn;
begin
  GetProcedureAddress(_SelectClipRgn, gdi32, 'SelectClipRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SelectClipRgn]
  end;
end;

var
  _ExtSelectClipRgn: Pointer;

function ExtSelectClipRgn;
begin
  GetProcedureAddress(_ExtSelectClipRgn, gdi32, 'ExtSelectClipRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtSelectClipRgn]
  end;
end;

var
  _SetMetaRgn: Pointer;

function SetMetaRgn;
begin
  GetProcedureAddress(_SetMetaRgn, gdi32, 'SetMetaRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetMetaRgn]
  end;
end;

var
  _SelectObject: Pointer;

function SelectObject;
begin
  GetProcedureAddress(_SelectObject, gdi32, 'SelectObject');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SelectObject]
  end;
end;

var
  _SelectPalette: Pointer;

function SelectPalette;
begin
  GetProcedureAddress(_SelectPalette, gdi32, 'SelectPalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SelectPalette]
  end;
end;

var
  _SetBkColor: Pointer;

function SetBkColor;
begin
  GetProcedureAddress(_SetBkColor, gdi32, 'SetBkColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBkColor]
  end;
end;

var
  _SetDCBrushColor: Pointer;

function SetDCBrushColor;
begin
  GetProcedureAddress(_SetDCBrushColor, gdi32, 'SetDCBrushColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDCBrushColor]
  end;
end;

var
  _SetDCPenColor: Pointer;

function SetDCPenColor;
begin
  GetProcedureAddress(_SetDCPenColor, gdi32, 'SetDCPenColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDCPenColor]
  end;
end;

var
  _SetBkMode: Pointer;

function SetBkMode;
begin
  GetProcedureAddress(_SetBkMode, gdi32, 'SetBkMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBkMode]
  end;
end;

var
  _SetBitmapBits: Pointer;

function SetBitmapBits;
begin
  GetProcedureAddress(_SetBitmapBits, gdi32, 'SetBitmapBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBitmapBits]
  end;
end;

var
  _SetBoundsRect: Pointer;

function SetBoundsRect;
begin
  GetProcedureAddress(_SetBoundsRect, gdi32, 'SetBoundsRect');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBoundsRect]
  end;
end;

var
  _SetDIBits: Pointer;

function SetDIBits;
begin
  GetProcedureAddress(_SetDIBits, gdi32, 'SetDIBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDIBits]
  end;
end;

var
  _SetDIBitsToDevice: Pointer;

function SetDIBitsToDevice;
begin
  GetProcedureAddress(_SetDIBitsToDevice, gdi32, 'SetDIBitsToDevice');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDIBitsToDevice]
  end;
end;

var
  _SetMapperFlags: Pointer;

function SetMapperFlags;
begin
  GetProcedureAddress(_SetMapperFlags, gdi32, 'SetMapperFlags');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetMapperFlags]
  end;
end;

var
  _SetGraphicsMode: Pointer;

function SetGraphicsMode;
begin
  GetProcedureAddress(_SetGraphicsMode, gdi32, 'SetGraphicsMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetGraphicsMode]
  end;
end;

var
  _SetMapMode: Pointer;

function SetMapMode;
begin
  GetProcedureAddress(_SetMapMode, gdi32, 'SetMapMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetMapMode]
  end;
end;

var
  _SetLayout: Pointer;

function SetLayout;
begin
  GetProcedureAddress(_SetLayout, gdi32, 'SetLayout');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetLayout]
  end;
end;

var
  _GetLayout: Pointer;

function GetLayout;
begin
  GetProcedureAddress(_GetLayout, gdi32, 'GetLayout');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetLayout]
  end;
end;

var
  _SetMetaFileBitsEx: Pointer;

function SetMetaFileBitsEx;
begin
  GetProcedureAddress(_SetMetaFileBitsEx, gdi32, 'SetMetaFileBitsEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetMetaFileBitsEx]
  end;
end;

var
  _SetPaletteEntries: Pointer;

function SetPaletteEntries;
begin
  GetProcedureAddress(_SetPaletteEntries, gdi32, 'SetPaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetPaletteEntries]
  end;
end;

var
  _SetPixel: Pointer;

function SetPixel;
begin
  GetProcedureAddress(_SetPixel, gdi32, 'SetPixel');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetPixel]
  end;
end;

var
  _SetPixelV: Pointer;

function SetPixelV;
begin
  GetProcedureAddress(_SetPixelV, gdi32, 'SetPixelV');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetPixelV]
  end;
end;

var
  _SetPixelFormat: Pointer;

function SetPixelFormat;
begin
  GetProcedureAddress(_SetPixelFormat, gdi32, 'SetPixelFormat');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetPixelFormat]
  end;
end;

var
  _SetPolyFillMode: Pointer;

function SetPolyFillMode;
begin
  GetProcedureAddress(_SetPolyFillMode, gdi32, 'SetPolyFillMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetPolyFillMode]
  end;
end;

var
  _StretchBlt: Pointer;

function StretchBlt;
begin
  GetProcedureAddress(_StretchBlt, gdi32, 'StretchBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StretchBlt]
  end;
end;

var
  _SetRectRgn: Pointer;

function SetRectRgn;
begin
  GetProcedureAddress(_SetRectRgn, gdi32, 'SetRectRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetRectRgn]
  end;
end;

var
  _StretchDIBits: Pointer;

function StretchDIBits;
begin
  GetProcedureAddress(_StretchDIBits, gdi32, 'StretchDIBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StretchDIBits]
  end;
end;

var
  _SetROP2: Pointer;

function SetROP2;
begin
  GetProcedureAddress(_SetROP2, gdi32, 'SetROP2');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetROP2]
  end;
end;

var
  _SetStretchBltMode: Pointer;

function SetStretchBltMode;
begin
  GetProcedureAddress(_SetStretchBltMode, gdi32, 'SetStretchBltMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetStretchBltMode]
  end;
end;

var
  _SetSystemPaletteUse: Pointer;

function SetSystemPaletteUse;
begin
  GetProcedureAddress(_SetSystemPaletteUse, gdi32, 'SetSystemPaletteUse');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetSystemPaletteUse]
  end;
end;

var
  _SetTextCharacterExtra: Pointer;

function SetTextCharacterExtra;
begin
  GetProcedureAddress(_SetTextCharacterExtra, gdi32, 'SetTextCharacterExtra');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetTextCharacterExtra]
  end;
end;

var
  _SetTextColor: Pointer;

function SetTextColor;
begin
  GetProcedureAddress(_SetTextColor, gdi32, 'SetTextColor');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetTextColor]
  end;
end;

var
  _SetTextAlign: Pointer;

function SetTextAlign;
begin
  GetProcedureAddress(_SetTextAlign, gdi32, 'SetTextAlign');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetTextAlign]
  end;
end;

var
  _SetTextJustification: Pointer;

function SetTextJustification;
begin
  GetProcedureAddress(_SetTextJustification, gdi32, 'SetTextJustification');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetTextJustification]
  end;
end;

var
  _UpdateColors: Pointer;

function UpdateColors;
begin
  GetProcedureAddress(_UpdateColors, gdi32, 'UpdateColors');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_UpdateColors]
  end;
end;

var
  _AlphaBlend: Pointer;

function AlphaBlend;
begin
  GetProcedureAddress(_AlphaBlend, msimg32, 'AlphaBlend');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AlphaBlend]
  end;
end;

var
  _TransparentBlt: Pointer;

function TransparentBlt;
begin
  GetProcedureAddress(_TransparentBlt, msimg32, 'TransparentBlt');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_TransparentBlt]
  end;
end;

var
  _GradientFill: Pointer;

function GradientFill;
begin
  GetProcedureAddress(_GradientFill, msimg32, 'GradientFill');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GradientFill]
  end;
end;

var
  _PlayMetaFileRecord: Pointer;

function PlayMetaFileRecord;
begin
  GetProcedureAddress(_PlayMetaFileRecord, gdi32, 'PlayMetaFileRecord');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PlayMetaFileRecord]
  end;
end;

var
  _EnumMetaFile: Pointer;

function EnumMetaFile;
begin
  GetProcedureAddress(_EnumMetaFile, gdi32, 'EnumMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumMetaFile]
  end;
end;

var
  _CloseEnhMetaFile: Pointer;

function CloseEnhMetaFile;
begin
  GetProcedureAddress(_CloseEnhMetaFile, gdi32, 'CloseEnhMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CloseEnhMetaFile]
  end;
end;

var
  _CopyEnhMetaFileA: Pointer;

function CopyEnhMetaFileA;
begin
  GetProcedureAddress(_CopyEnhMetaFileA, gdi32, 'CopyEnhMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyEnhMetaFileA]
  end;
end;

var
  _CopyEnhMetaFileW: Pointer;

function CopyEnhMetaFileW;
begin
  GetProcedureAddress(_CopyEnhMetaFileW, gdi32, 'CopyEnhMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyEnhMetaFileW]
  end;
end;

var
  _CopyEnhMetaFile: Pointer;

function CopyEnhMetaFile;
begin
  GetProcedureAddress(_CopyEnhMetaFile, gdi32, 'CopyEnhMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CopyEnhMetaFile]
  end;
end;

var
  _CreateEnhMetaFileA: Pointer;

function CreateEnhMetaFileA;
begin
  GetProcedureAddress(_CreateEnhMetaFileA, gdi32, 'CreateEnhMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateEnhMetaFileA]
  end;
end;

var
  _CreateEnhMetaFileW: Pointer;

function CreateEnhMetaFileW;
begin
  GetProcedureAddress(_CreateEnhMetaFileW, gdi32, 'CreateEnhMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateEnhMetaFileW]
  end;
end;

var
  _CreateEnhMetaFile: Pointer;

function CreateEnhMetaFile;
begin
  GetProcedureAddress(_CreateEnhMetaFile, gdi32, 'CreateEnhMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateEnhMetaFile]
  end;
end;

var
  _DeleteEnhMetaFile: Pointer;

function DeleteEnhMetaFile;
begin
  GetProcedureAddress(_DeleteEnhMetaFile, gdi32, 'DeleteEnhMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeleteEnhMetaFile]
  end;
end;

var
  _EnumEnhMetaFile: Pointer;

function EnumEnhMetaFile;
begin
  GetProcedureAddress(_EnumEnhMetaFile, gdi32, 'EnumEnhMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumEnhMetaFile]
  end;
end;

var
  _GetEnhMetaFileA: Pointer;

function GetEnhMetaFileA;
begin
  GetProcedureAddress(_GetEnhMetaFileA, gdi32, 'GetEnhMetaFileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileA]
  end;
end;

var
  _GetEnhMetaFileW: Pointer;

function GetEnhMetaFileW;
begin
  GetProcedureAddress(_GetEnhMetaFileW, gdi32, 'GetEnhMetaFileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileW]
  end;
end;

var
  _GetEnhMetaFile: Pointer;

function GetEnhMetaFile;
begin
  GetProcedureAddress(_GetEnhMetaFile, gdi32, 'GetEnhMetaFile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFile]
  end;
end;

var
  _GetEnhMetaFileBits: Pointer;

function GetEnhMetaFileBits;
begin
  GetProcedureAddress(_GetEnhMetaFileBits, gdi32, 'GetEnhMetaFileBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileBits]
  end;
end;

var
  _GetEnhMetaFileDescriptionA: Pointer;

function GetEnhMetaFileDescriptionA;
begin
  GetProcedureAddress(_GetEnhMetaFileDescriptionA, gdi32, 'GetEnhMetaFileDescriptionA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileDescriptionA]
  end;
end;

var
  _GetEnhMetaFileDescriptionW: Pointer;

function GetEnhMetaFileDescriptionW;
begin
  GetProcedureAddress(_GetEnhMetaFileDescriptionW, gdi32, 'GetEnhMetaFileDescriptionW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileDescriptionW]
  end;
end;

var
  _GetEnhMetaFileDescription: Pointer;

function GetEnhMetaFileDescription;
begin
  GetProcedureAddress(_GetEnhMetaFileDescription, gdi32, 'GetEnhMetaFileDescription' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileDescription]
  end;
end;

var
  _GetEnhMetaFileHeader: Pointer;

function GetEnhMetaFileHeader;
begin
  GetProcedureAddress(_GetEnhMetaFileHeader, gdi32, 'GetEnhMetaFileHeader');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFileHeader]
  end;
end;

var
  _GetEnhMetaFilePaletteEntries: Pointer;

function GetEnhMetaFilePaletteEntries;
begin
  GetProcedureAddress(_GetEnhMetaFilePaletteEntries, gdi32, 'GetEnhMetaFilePaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFilePaletteEntries]
  end;
end;

var
  _GetEnhMetaFilePixelFormat: Pointer;

function GetEnhMetaFilePixelFormat;
begin
  GetProcedureAddress(_GetEnhMetaFilePixelFormat, gdi32, 'GetEnhMetaFilePixelFormat');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetEnhMetaFilePixelFormat]
  end;
end;

var
  _GetWinMetaFileBits: Pointer;

function GetWinMetaFileBits;
begin
  GetProcedureAddress(_GetWinMetaFileBits, gdi32, 'GetWinMetaFileBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetWinMetaFileBits]
  end;
end;

var
  _PlayEnhMetaFile: Pointer;

function PlayEnhMetaFile;
begin
  GetProcedureAddress(_PlayEnhMetaFile, gdi32, 'PlayEnhMetaFile');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PlayEnhMetaFile]
  end;
end;

var
  _PlayEnhMetaFileRecord: Pointer;

function PlayEnhMetaFileRecord;
begin
  GetProcedureAddress(_PlayEnhMetaFileRecord, gdi32, 'PlayEnhMetaFileRecord');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PlayEnhMetaFileRecord]
  end;
end;

var
  _SetEnhMetaFileBits: Pointer;

function SetEnhMetaFileBits;
begin
  GetProcedureAddress(_SetEnhMetaFileBits, gdi32, 'SetEnhMetaFileBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetEnhMetaFileBits]
  end;
end;

var
  _SetWinMetaFileBits: Pointer;

function SetWinMetaFileBits;
begin
  GetProcedureAddress(_SetWinMetaFileBits, gdi32, 'SetWinMetaFileBits');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetWinMetaFileBits]
  end;
end;

var
  _GdiComment: Pointer;

function GdiComment;
begin
  GetProcedureAddress(_GdiComment, gdi32, 'GdiComment');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GdiComment]
  end;
end;

var
  _GetTextMetricsA: Pointer;

function GetTextMetricsA;
begin
  GetProcedureAddress(_GetTextMetricsA, gdi32, 'GetTextMetricsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextMetricsA]
  end;
end;

var
  _GetTextMetricsW: Pointer;

function GetTextMetricsW;
begin
  GetProcedureAddress(_GetTextMetricsW, gdi32, 'GetTextMetricsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextMetricsW]
  end;
end;

var
  _GetTextMetrics: Pointer;

function GetTextMetrics;
begin
  GetProcedureAddress(_GetTextMetrics, gdi32, 'GetTextMetrics' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextMetrics]
  end;
end;

var
  _AngleArc: Pointer;

function AngleArc;
begin
  GetProcedureAddress(_AngleArc, gdi32, 'AngleArc');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AngleArc]
  end;
end;

var
  _PolyPolyline: Pointer;

function PolyPolyline;
begin
  GetProcedureAddress(_PolyPolyline, gdi32, 'PolyPolyline');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyPolyline]
  end;
end;

var
  _GetWorldTransform: Pointer;

function GetWorldTransform;
begin
  GetProcedureAddress(_GetWorldTransform, gdi32, 'GetWorldTransform');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetWorldTransform]
  end;
end;

var
  _SetWorldTransform: Pointer;

function SetWorldTransform;
begin
  GetProcedureAddress(_SetWorldTransform, gdi32, 'SetWorldTransform');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetWorldTransform]
  end;
end;

var
  _ModifyWorldTransform: Pointer;

function ModifyWorldTransform;
begin
  GetProcedureAddress(_ModifyWorldTransform, gdi32, 'ModifyWorldTransform');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ModifyWorldTransform]
  end;
end;

var
  _CombineTransform: Pointer;

function CombineTransform;
begin
  GetProcedureAddress(_CombineTransform, gdi32, 'CombineTransform');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CombineTransform]
  end;
end;

var
  _CreateDIBSection: Pointer;

function CreateDIBSection;
begin
  GetProcedureAddress(_CreateDIBSection, gdi32, 'CreateDIBSection');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateDIBSection]
  end;
end;

var
  _GetDIBColorTable: Pointer;

function GetDIBColorTable;
begin
  GetProcedureAddress(_GetDIBColorTable, gdi32, 'GetDIBColorTable');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDIBColorTable]
  end;
end;

var
  _SetDIBColorTable: Pointer;

function SetDIBColorTable;
begin
  GetProcedureAddress(_SetDIBColorTable, gdi32, 'SetDIBColorTable');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDIBColorTable]
  end;
end;

var
  _SetColorAdjustment: Pointer;

function SetColorAdjustment;
begin
  GetProcedureAddress(_SetColorAdjustment, gdi32, 'SetColorAdjustment');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetColorAdjustment]
  end;
end;

var
  _GetColorAdjustment: Pointer;

function GetColorAdjustment;
begin
  GetProcedureAddress(_GetColorAdjustment, gdi32, 'GetColorAdjustment');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetColorAdjustment]
  end;
end;

var
  _CreateHalftonePalette: Pointer;

function CreateHalftonePalette;
begin
  GetProcedureAddress(_CreateHalftonePalette, gdi32, 'CreateHalftonePalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateHalftonePalette]
  end;
end;

var
  _StartDocA: Pointer;

function StartDocA;
begin
  GetProcedureAddress(_StartDocA, gdi32, 'StartDocA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StartDocA]
  end;
end;

var
  _StartDocW: Pointer;

function StartDocW;
begin
  GetProcedureAddress(_StartDocW, gdi32, 'StartDocW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StartDocW]
  end;
end;

var
  _StartDoc: Pointer;

function StartDoc;
begin
  GetProcedureAddress(_StartDoc, gdi32, 'StartDoc' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StartDoc]
  end;
end;

var
  __EndDoc: Pointer;

function EndDoc;
begin
  GetProcedureAddress(__EndDoc, gdi32, 'EndDoc');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [__EndDoc]
  end;
end;

var
  _StartPage: Pointer;

function StartPage;
begin
  GetProcedureAddress(_StartPage, gdi32, 'StartPage');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StartPage]
  end;
end;

var
  _EndPage: Pointer;

function EndPage;
begin
  GetProcedureAddress(_EndPage, gdi32, 'EndPage');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EndPage]
  end;
end;

var
  __AbortDoc: Pointer;

function AbortDoc;
begin
  GetProcedureAddress(__AbortDoc, gdi32, 'AbortDoc');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [__AbortDoc]
  end;
end;

var
  _SetAbortProc: Pointer;

function SetAbortProc;
begin
  GetProcedureAddress(_SetAbortProc, gdi32, 'SetAbortProc');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetAbortProc]
  end;
end;

var
  _AbortPath: Pointer;

function AbortPath;
begin
  GetProcedureAddress(_AbortPath, gdi32, 'AbortPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_AbortPath]
  end;
end;

var
  _ArcTo: Pointer;

function ArcTo;
begin
  GetProcedureAddress(_ArcTo, gdi32, 'ArcTo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ArcTo]
  end;
end;

var
  _BeginPath: Pointer;

function BeginPath;
begin
  GetProcedureAddress(_BeginPath, gdi32, 'BeginPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_BeginPath]
  end;
end;

var
  _CloseFigure: Pointer;

function CloseFigure;
begin
  GetProcedureAddress(_CloseFigure, gdi32, 'CloseFigure');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CloseFigure]
  end;
end;

var
  _EndPath: Pointer;

function EndPath;
begin
  GetProcedureAddress(_EndPath, gdi32, 'EndPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EndPath]
  end;
end;

var
  _FillPath: Pointer;

function FillPath;
begin
  GetProcedureAddress(_FillPath, gdi32, 'FillPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FillPath]
  end;
end;

var
  _FlattenPath: Pointer;

function FlattenPath;
begin
  GetProcedureAddress(_FlattenPath, gdi32, 'FlattenPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FlattenPath]
  end;
end;

var
  _GetPath: Pointer;

function GetPath;
begin
  GetProcedureAddress(_GetPath, gdi32, 'GetPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetPath]
  end;
end;

var
  _PathToRegion: Pointer;

function PathToRegion;
begin
  GetProcedureAddress(_PathToRegion, gdi32, 'PathToRegion');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PathToRegion]
  end;
end;

var
  _PolyDraw: Pointer;

function PolyDraw;
begin
  GetProcedureAddress(_PolyDraw, gdi32, 'PolyDraw');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyDraw]
  end;
end;

var
  _SelectClipPath: Pointer;

function SelectClipPath;
begin
  GetProcedureAddress(_SelectClipPath, gdi32, 'SelectClipPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SelectClipPath]
  end;
end;

var
  _SetArcDirection: Pointer;

function SetArcDirection;
begin
  GetProcedureAddress(_SetArcDirection, gdi32, 'SetArcDirection');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetArcDirection]
  end;
end;

var
  _SetMiterLimit: Pointer;

function SetMiterLimit;
begin
  GetProcedureAddress(_SetMiterLimit, gdi32, 'SetMiterLimit');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetMiterLimit]
  end;
end;

var
  _StrokeAndFillPath: Pointer;

function StrokeAndFillPath;
begin
  GetProcedureAddress(_StrokeAndFillPath, gdi32, 'StrokeAndFillPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StrokeAndFillPath]
  end;
end;

var
  _StrokePath: Pointer;

function StrokePath;
begin
  GetProcedureAddress(_StrokePath, gdi32, 'StrokePath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_StrokePath]
  end;
end;

var
  _WidenPath: Pointer;

function WidenPath;
begin
  GetProcedureAddress(_WidenPath, gdi32, 'WidenPath');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_WidenPath]
  end;
end;

var
  _ExtCreatePen: Pointer;

function ExtCreatePen;
begin
  GetProcedureAddress(_ExtCreatePen, gdi32, 'ExtCreatePen');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtCreatePen]
  end;
end;

var
  _GetMiterLimit: Pointer;

function GetMiterLimit;
begin
  GetProcedureAddress(_GetMiterLimit, gdi32, 'GetMiterLimit');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetMiterLimit]
  end;
end;

var
  _GetArcDirection: Pointer;

function GetArcDirection;
begin
  GetProcedureAddress(_GetArcDirection, gdi32, 'GetArcDirection');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetArcDirection]
  end;
end;

var
  _GetObjectA: Pointer;

function GetObjectA;
begin
  GetProcedureAddress(_GetObjectA, gdi32, 'GetObjectA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetObjectA]
  end;
end;

var
  _GetObjectW: Pointer;

function GetObjectW;
begin
  GetProcedureAddress(_GetObjectW, gdi32, 'GetObjectW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetObjectW]
  end;
end;

var
  _GetObject: Pointer;

function GetObject;
begin
  GetProcedureAddress(_GetObject, gdi32, 'GetObject' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetObject]
  end;
end;

var
  _MoveToEx: Pointer;

function MoveToEx;
begin
  GetProcedureAddress(_MoveToEx, gdi32, 'MoveToEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_MoveToEx]
  end;
end;

var
  _TextOutA: Pointer;

function TextOutA;
begin
  GetProcedureAddress(_TextOutA, gdi32, 'TextOutA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_TextOutA]
  end;
end;

var
  _TextOutW: Pointer;

function TextOutW;
begin
  GetProcedureAddress(_TextOutW, gdi32, 'TextOutW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_TextOutW]
  end;
end;

var
  _TextOut: Pointer;

function TextOut;
begin
  GetProcedureAddress(_TextOut, gdi32, 'TextOut' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_TextOut]
  end;
end;

var
  _ExtTextOutA: Pointer;

function ExtTextOutA;
begin
  GetProcedureAddress(_ExtTextOutA, gdi32, 'ExtTextOutA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtTextOutA]
  end;
end;

var
  _ExtTextOutW: Pointer;

function ExtTextOutW;
begin
  GetProcedureAddress(_ExtTextOutW, gdi32, 'ExtTextOutW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtTextOutW]
  end;
end;

var
  _ExtTextOut: Pointer;

function ExtTextOut;
begin
  GetProcedureAddress(_ExtTextOut, gdi32, 'ExtTextOut' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ExtTextOut]
  end;
end;

var
  _PolyTextOutA: Pointer;

function PolyTextOutA;
begin
  GetProcedureAddress(_PolyTextOutA, gdi32, 'PolyTextOutA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyTextOutA]
  end;
end;

var
  _PolyTextOutW: Pointer;

function PolyTextOutW;
begin
  GetProcedureAddress(_PolyTextOutW, gdi32, 'PolyTextOutW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyTextOutW]
  end;
end;

var
  _PolyTextOut: Pointer;

function PolyTextOut;
begin
  GetProcedureAddress(_PolyTextOut, gdi32, 'PolyTextOut' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyTextOut]
  end;
end;

var
  _CreatePolygonRgn: Pointer;

function CreatePolygonRgn;
begin
  GetProcedureAddress(_CreatePolygonRgn, gdi32, 'CreatePolygonRgn');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreatePolygonRgn]
  end;
end;

var
  _DPtoLP: Pointer;

function DPtoLP;
begin
  GetProcedureAddress(_DPtoLP, gdi32, 'DPtoLP');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DPtoLP]
  end;
end;

var
  _LPtoDP: Pointer;

function LPtoDP;
begin
  GetProcedureAddress(_LPtoDP, gdi32, 'LPtoDP');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_LPtoDP]
  end;
end;

var
  _Polygon: Pointer;

function Polygon;
begin
  GetProcedureAddress(_Polygon, gdi32, 'Polygon');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Polygon]
  end;
end;

var
  _Polyline: Pointer;

function Polyline;
begin
  GetProcedureAddress(_Polyline, gdi32, 'Polyline');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_Polyline]
  end;
end;

var
  _PolyBezier: Pointer;

function PolyBezier;
begin
  GetProcedureAddress(_PolyBezier, gdi32, 'PolyBezier');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyBezier]
  end;
end;

var
  _PolyBezierTo: Pointer;

function PolyBezierTo;
begin
  GetProcedureAddress(_PolyBezierTo, gdi32, 'PolyBezierTo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolyBezierTo]
  end;
end;

var
  _PolylineTo: Pointer;

function PolylineTo;
begin
  GetProcedureAddress(_PolylineTo, gdi32, 'PolylineTo');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_PolylineTo]
  end;
end;

var
  _SetViewportExtEx: Pointer;

function SetViewportExtEx;
begin
  GetProcedureAddress(_SetViewportExtEx, gdi32, 'SetViewportExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetViewportExtEx]
  end;
end;

var
  _SetViewportOrgEx: Pointer;

function SetViewportOrgEx;
begin
  GetProcedureAddress(_SetViewportOrgEx, gdi32, 'SetViewportOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetViewportOrgEx]
  end;
end;

var
  _SetWindowExtEx: Pointer;

function SetWindowExtEx;
begin
  GetProcedureAddress(_SetWindowExtEx, gdi32, 'SetWindowExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetWindowExtEx]
  end;
end;

var
  _SetWindowOrgEx: Pointer;

function SetWindowOrgEx;
begin
  GetProcedureAddress(_SetWindowOrgEx, gdi32, 'SetWindowOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetWindowOrgEx]
  end;
end;

var
  _OffsetViewportOrgEx: Pointer;

function OffsetViewportOrgEx;
begin
  GetProcedureAddress(_OffsetViewportOrgEx, gdi32, 'OffsetViewportOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_OffsetViewportOrgEx]
  end;
end;

var
  _OffsetWindowOrgEx: Pointer;

function OffsetWindowOrgEx;
begin
  GetProcedureAddress(_OffsetWindowOrgEx, gdi32, 'OffsetWindowOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_OffsetWindowOrgEx]
  end;
end;

var
  _ScaleViewportExtEx: Pointer;

function ScaleViewportExtEx;
begin
  GetProcedureAddress(_ScaleViewportExtEx, gdi32, 'ScaleViewportExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ScaleViewportExtEx]
  end;
end;

var
  _ScaleWindowExtEx: Pointer;

function ScaleWindowExtEx;
begin
  GetProcedureAddress(_ScaleWindowExtEx, gdi32, 'ScaleWindowExtEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ScaleWindowExtEx]
  end;
end;

var
  _SetBitmapDimensionEx: Pointer;

function SetBitmapDimensionEx;
begin
  GetProcedureAddress(_SetBitmapDimensionEx, gdi32, 'SetBitmapDimensionEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBitmapDimensionEx]
  end;
end;

var
  _SetBrushOrgEx: Pointer;

function SetBrushOrgEx;
begin
  GetProcedureAddress(_SetBrushOrgEx, gdi32, 'SetBrushOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetBrushOrgEx]
  end;
end;

var
  _GetTextFaceA: Pointer;

function GetTextFaceA;
begin
  GetProcedureAddress(_GetTextFaceA, gdi32, 'GetTextFaceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextFaceA]
  end;
end;

var
  _GetTextFaceW: Pointer;

function GetTextFaceW;
begin
  GetProcedureAddress(_GetTextFaceW, gdi32, 'GetTextFaceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextFaceW]
  end;
end;

var
  _GetTextFace: Pointer;

function GetTextFace;
begin
  GetProcedureAddress(_GetTextFace, gdi32, 'GetTextFace' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetTextFace]
  end;
end;

var
  _GetKerningPairsA: Pointer;

function GetKerningPairsA;
begin
  GetProcedureAddress(_GetKerningPairsA, gdi32, 'GetKerningPairsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetKerningPairsA]
  end;
end;

var
  _GetKerningPairsW: Pointer;

function GetKerningPairsW;
begin
  GetProcedureAddress(_GetKerningPairsW, gdi32, 'GetKerningPairsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetKerningPairsW]
  end;
end;

var
  _GetKerningPairs: Pointer;

function GetKerningPairs;
begin
  GetProcedureAddress(_GetKerningPairs, gdi32, 'GetKerningPairs' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetKerningPairs]
  end;
end;

var
  _GetDCOrgEx: Pointer;

function GetDCOrgEx;
begin
  GetProcedureAddress(_GetDCOrgEx, gdi32, 'GetDCOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDCOrgEx]
  end;
end;

var
  _FixBrushOrgEx: Pointer;

function FixBrushOrgEx;
begin
  GetProcedureAddress(_FixBrushOrgEx, gdi32, 'FixBrushOrgEx');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_FixBrushOrgEx]
  end;
end;

var
  _UnrealizeObject: Pointer;

function UnrealizeObject;
begin
  GetProcedureAddress(_UnrealizeObject, gdi32, 'UnrealizeObject');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_UnrealizeObject]
  end;
end;

var
  _GdiFlush: Pointer;

function GdiFlush;
begin
  GetProcedureAddress(_GdiFlush, gdi32, 'GdiFlush');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GdiFlush]
  end;
end;

var
  _GdiSetBatchLimit: Pointer;

function GdiSetBatchLimit;
begin
  GetProcedureAddress(_GdiSetBatchLimit, gdi32, 'GdiSetBatchLimit');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GdiSetBatchLimit]
  end;
end;

var
  _GdiGetBatchLimit: Pointer;

function GdiGetBatchLimit;
begin
  GetProcedureAddress(_GdiGetBatchLimit, gdi32, 'GdiGetBatchLimit');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GdiGetBatchLimit]
  end;
end;

var
  _SetICMMode: Pointer;

function SetICMMode;
begin
  GetProcedureAddress(_SetICMMode, gdi32, 'SetICMMode');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetICMMode]
  end;
end;

var
  _CheckColorsInGamut: Pointer;

function CheckColorsInGamut;
begin
  GetProcedureAddress(_CheckColorsInGamut, gdi32, 'CheckColorsInGamut');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CheckColorsInGamut]
  end;
end;

var
  _GetColorSpace: Pointer;

function GetColorSpace;
begin
  GetProcedureAddress(_GetColorSpace, gdi32, 'GetColorSpace');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetColorSpace]
  end;
end;

var
  _GetLogColorSpaceA: Pointer;

function GetLogColorSpaceA;
begin
  GetProcedureAddress(_GetLogColorSpaceA, gdi32, 'GetLogColorSpaceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetLogColorSpaceA]
  end;
end;

var
  _GetLogColorSpaceW: Pointer;

function GetLogColorSpaceW;
begin
  GetProcedureAddress(_GetLogColorSpaceW, gdi32, 'GetLogColorSpaceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetLogColorSpaceW]
  end;
end;

var
  _GetLogColorSpace: Pointer;

function GetLogColorSpace;
begin
  GetProcedureAddress(_GetLogColorSpace, gdi32, 'GetLogColorSpace' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetLogColorSpace]
  end;
end;

var
  _CreateColorSpaceA: Pointer;

function CreateColorSpaceA;
begin
  GetProcedureAddress(_CreateColorSpaceA, gdi32, 'CreateColorSpaceA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateColorSpaceA]
  end;
end;

var
  _CreateColorSpaceW: Pointer;

function CreateColorSpaceW;
begin
  GetProcedureAddress(_CreateColorSpaceW, gdi32, 'CreateColorSpaceW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateColorSpaceW]
  end;
end;

var
  _CreateColorSpace: Pointer;

function CreateColorSpace;
begin
  GetProcedureAddress(_CreateColorSpace, gdi32, 'CreateColorSpace' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_CreateColorSpace]
  end;
end;

var
  _SetColorSpace: Pointer;

function SetColorSpace;
begin
  GetProcedureAddress(_SetColorSpace, gdi32, 'SetColorSpace');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetColorSpace]
  end;
end;

var
  _DeleteColorSpace: Pointer;

function DeleteColorSpace;
begin
  GetProcedureAddress(_DeleteColorSpace, gdi32, 'DeleteColorSpace');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_DeleteColorSpace]
  end;
end;

var
  _GetICMProfileA: Pointer;

function GetICMProfileA;
begin
  GetProcedureAddress(_GetICMProfileA, gdi32, 'GetICMProfileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetICMProfileA]
  end;
end;

var
  _GetICMProfileW: Pointer;

function GetICMProfileW;
begin
  GetProcedureAddress(_GetICMProfileW, gdi32, 'GetICMProfileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetICMProfileW]
  end;
end;

var
  _GetICMProfile: Pointer;

function GetICMProfile;
begin
  GetProcedureAddress(_GetICMProfile, gdi32, 'GetICMProfile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetICMProfile]
  end;
end;

var
  _SetICMProfileA: Pointer;

function SetICMProfileA;
begin
  GetProcedureAddress(_SetICMProfileA, gdi32, 'SetICMProfileA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetICMProfileA]
  end;
end;

var
  _SetICMProfileW: Pointer;

function SetICMProfileW;
begin
  GetProcedureAddress(_SetICMProfileW, gdi32, 'SetICMProfileW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetICMProfileW]
  end;
end;

var
  _SetICMProfile: Pointer;

function SetICMProfile;
begin
  GetProcedureAddress(_SetICMProfile, gdi32, 'SetICMProfile' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetICMProfile]
  end;
end;

var
  _GetDeviceGammaRamp: Pointer;

function GetDeviceGammaRamp;
begin
  GetProcedureAddress(_GetDeviceGammaRamp, gdi32, 'GetDeviceGammaRamp');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_GetDeviceGammaRamp]
  end;
end;

var
  _SetDeviceGammaRamp: Pointer;

function SetDeviceGammaRamp;
begin
  GetProcedureAddress(_SetDeviceGammaRamp, gdi32, 'SetDeviceGammaRamp');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SetDeviceGammaRamp]
  end;
end;

var
  _ColorMatchToTarget: Pointer;

function ColorMatchToTarget;
begin
  GetProcedureAddress(_ColorMatchToTarget, gdi32, 'ColorMatchToTarget');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ColorMatchToTarget]
  end;
end;

var
  _EnumICMProfilesA: Pointer;

function EnumICMProfilesA;
begin
  GetProcedureAddress(_EnumICMProfilesA, gdi32, 'EnumICMProfilesA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumICMProfilesA]
  end;
end;

var
  _EnumICMProfilesW: Pointer;

function EnumICMProfilesW;
begin
  GetProcedureAddress(_EnumICMProfilesW, gdi32, 'EnumICMProfilesW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumICMProfilesW]
  end;
end;

var
  _EnumICMProfiles: Pointer;

function EnumICMProfiles;
begin
  GetProcedureAddress(_EnumICMProfiles, gdi32, 'EnumICMProfiles' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_EnumICMProfiles]
  end;
end;

var
  _UpdateICMRegKeyA: Pointer;

function UpdateICMRegKeyA;
begin
  GetProcedureAddress(_UpdateICMRegKeyA, gdi32, 'UpdateICMRegKeyA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_UpdateICMRegKeyA]
  end;
end;

var
  _UpdateICMRegKeyW: Pointer;

function UpdateICMRegKeyW;
begin
  GetProcedureAddress(_UpdateICMRegKeyW, gdi32, 'UpdateICMRegKeyW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_UpdateICMRegKeyW]
  end;
end;

var
  _UpdateICMRegKey: Pointer;

function UpdateICMRegKey;
begin
  GetProcedureAddress(_UpdateICMRegKey, gdi32, 'UpdateICMRegKey' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_UpdateICMRegKey]
  end;
end;

var
  _ColorCorrectPalette: Pointer;

function ColorCorrectPalette;
begin
  GetProcedureAddress(_ColorCorrectPalette, gdi32, 'ColorCorrectPalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_ColorCorrectPalette]
  end;
end;

var
  _wglCopyContext: Pointer;

function wglCopyContext;
begin
  GetProcedureAddress(_wglCopyContext, opengl32, 'wglCopyContext');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglCopyContext]
  end;
end;

var
  _wglCreateContext: Pointer;

function wglCreateContext;
begin
  GetProcedureAddress(_wglCreateContext, opengl32, 'wglCreateContext');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglCreateContext]
  end;
end;

var
  _wglCreateLayerContext: Pointer;

function wglCreateLayerContext;
begin
  GetProcedureAddress(_wglCreateLayerContext, opengl32, 'wglCreateLayerContext');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglCreateLayerContext]
  end;
end;

var
  _wglDeleteContext: Pointer;

function wglDeleteContext;
begin
  GetProcedureAddress(_wglDeleteContext, opengl32, 'wglDeleteContext');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglDeleteContext]
  end;
end;

var
  _wglGetCurrentContext: Pointer;

function wglGetCurrentContext;
begin
  GetProcedureAddress(_wglGetCurrentContext, opengl32, 'wglGetCurrentContext');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglGetCurrentContext]
  end;
end;

var
  _wglGetCurrentDC: Pointer;

function wglGetCurrentDC;
begin
  GetProcedureAddress(_wglGetCurrentDC, opengl32, 'wglGetCurrentDC');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglGetCurrentDC]
  end;
end;

var
  _wglGetProcAddress: Pointer;

function wglGetProcAddress;
begin
  GetProcedureAddress(_wglGetProcAddress, opengl32, 'wglGetProcAddress');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglGetProcAddress]
  end;
end;

var
  _wglMakeCurrent: Pointer;

function wglMakeCurrent;
begin
  GetProcedureAddress(_wglMakeCurrent, opengl32, 'wglMakeCurrent');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglMakeCurrent]
  end;
end;

var
  _wglShareLists: Pointer;

function wglShareLists;
begin
  GetProcedureAddress(_wglShareLists, opengl32, 'wglShareLists');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglShareLists]
  end;
end;

var
  _wglUseFontBitmapsA: Pointer;

function wglUseFontBitmapsA;
begin
  GetProcedureAddress(_wglUseFontBitmapsA, opengl32, 'wglUseFontBitmapsA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontBitmapsA]
  end;
end;

var
  _wglUseFontBitmapsW: Pointer;

function wglUseFontBitmapsW;
begin
  GetProcedureAddress(_wglUseFontBitmapsW, opengl32, 'wglUseFontBitmapsW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontBitmapsW]
  end;
end;

var
  _wglUseFontBitmaps: Pointer;

function wglUseFontBitmaps;
begin
  GetProcedureAddress(_wglUseFontBitmaps, opengl32, 'wglUseFontBitmaps' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontBitmaps]
  end;
end;

var
  _SwapBuffers: Pointer;

function SwapBuffers;
begin
  GetProcedureAddress(_SwapBuffers, opengl32, 'SwapBuffers');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_SwapBuffers]
  end;
end;

var
  _wglUseFontOutlinesA: Pointer;

function wglUseFontOutlinesA;
begin
  GetProcedureAddress(_wglUseFontOutlinesA, opengl32, 'wglUseFontOutlinesA');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontOutlinesA]
  end;
end;

var
  _wglUseFontOutlinesW: Pointer;

function wglUseFontOutlinesW;
begin
  GetProcedureAddress(_wglUseFontOutlinesW, opengl32, 'wglUseFontOutlinesW');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontOutlinesW]
  end;
end;

var
  _wglUseFontOutlines: Pointer;

function wglUseFontOutlines;
begin
  GetProcedureAddress(_wglUseFontOutlines, opengl32, 'wglUseFontOutlines' + AWSuffix);
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglUseFontOutlines]
  end;
end;

var
  _wglDescribeLayerPlane: Pointer;

function wglDescribeLayerPlane;
begin
  GetProcedureAddress(_wglDescribeLayerPlane, opengl32, 'wglDescribeLayerPlane');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglDescribeLayerPlane]
  end;
end;

var
  _wglSetLayerPaletteEntries: Pointer;

function wglSetLayerPaletteEntries;
begin
  GetProcedureAddress(_wglSetLayerPaletteEntries, opengl32, 'wglSetLayerPaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglSetLayerPaletteEntries]
  end;
end;

var
  _wglGetLayerPaletteEntries: Pointer;

function wglGetLayerPaletteEntries;
begin
  GetProcedureAddress(_wglGetLayerPaletteEntries, opengl32, 'wglGetLayerPaletteEntries');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglGetLayerPaletteEntries]
  end;
end;

var
  _wglRealizeLayerPalette: Pointer;

function wglRealizeLayerPalette;
begin
  GetProcedureAddress(_wglRealizeLayerPalette, opengl32, 'wglRealizeLayerPalette');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglRealizeLayerPalette]
  end;
end;

var
  _wglSwapLayerBuffers: Pointer;

function wglSwapLayerBuffers;
begin
  GetProcedureAddress(_wglSwapLayerBuffers, opengl32, 'wglSwapLayerBuffers');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglSwapLayerBuffers]
  end;
end;

var
  _wglSwapMultipleBuffers: Pointer;

function wglSwapMultipleBuffers;
begin
  GetProcedureAddress(_wglSwapMultipleBuffers, opengl32, 'wglSwapMultipleBuffers');
  asm
        MOV     ESP, EBP
        POP     EBP
        JMP     [_wglSwapMultipleBuffers]
  end;
end;

{$ELSE}

function AddFontResourceA; external gdi32 name 'AddFontResourceA';
function AddFontResourceW; external gdi32 name 'AddFontResourceW';
function AddFontResource; external gdi32 name 'AddFontResource' + AWSuffix;
function AnimatePalette; external gdi32 name 'AnimatePalette';
function Arc; external gdi32 name 'Arc';
function BitBlt; external gdi32 name 'BitBlt';
function CancelDC; external gdi32 name 'CancelDC';
function Chord; external gdi32 name 'Chord';
function ChoosePixelFormat; external gdi32 name 'ChoosePixelFormat';
function CloseMetaFile; external gdi32 name 'CloseMetaFile';
function CombineRgn; external gdi32 name 'CombineRgn';
function CopyMetaFileA; external gdi32 name 'CopyMetaFileA';
function CopyMetaFileW; external gdi32 name 'CopyMetaFileW';
function CopyMetaFile; external gdi32 name 'CopyMetaFile' + AWSuffix;
function CreateBitmap; external gdi32 name 'CreateBitmap';
function CreateBitmapIndirect; external gdi32 name 'CreateBitmapIndirect';
function CreateBrushIndirect; external gdi32 name 'CreateBrushIndirect';
function CreateCompatibleBitmap; external gdi32 name 'CreateCompatibleBitmap';
function CreateDiscardableBitmap; external gdi32 name 'CreateDiscardableBitmap';
function CreateCompatibleDC; external gdi32 name 'CreateCompatibleDC';
function CreateDCA; external gdi32 name 'CreateDCA';
function CreateDCW; external gdi32 name 'CreateDCW';
function CreateDC; external gdi32 name 'CreateDC' + AWSuffix;
function CreateDIBitmap; external gdi32 name 'CreateDIBitmap';
function CreateDIBPatternBrush; external gdi32 name 'CreateDIBPatternBrush';
function CreateDIBPatternBrushPt; external gdi32 name 'CreateDIBPatternBrushPt';
function CreateEllipticRgn; external gdi32 name 'CreateEllipticRgn';
function CreateEllipticRgnIndirect; external gdi32 name 'CreateEllipticRgnIndirect';
function CreateFontIndirectA; external gdi32 name 'CreateFontIndirectA';
function CreateFontIndirectW; external gdi32 name 'CreateFontIndirectW';
function CreateFontIndirect; external gdi32 name 'CreateFontIndirect' + AWSuffix;
function CreateFontA; external gdi32 name 'CreateFontA';
function CreateFontW; external gdi32 name 'CreateFontW';
function CreateFont; external gdi32 name 'CreateFont' + AWSuffix;
function CreateHatchBrush; external gdi32 name 'CreateHatchBrush';
function CreateICA; external gdi32 name 'CreateICA';
function CreateICW; external gdi32 name 'CreateICW';
function CreateIC; external gdi32 name 'CreateIC' + AWSuffix;
function CreateMetaFileA; external gdi32 name 'CreateMetaFileA';
function CreateMetaFileW; external gdi32 name 'CreateMetaFileW';
function CreateMetaFile; external gdi32 name 'CreateMetaFile' + AWSuffix;
function CreatePalette; external gdi32 name 'CreatePalette';
function CreatePen; external gdi32 name 'CreatePen';
function CreatePenIndirect; external gdi32 name 'CreatePenIndirect';
function CreatePolyPolygonRgn; external gdi32 name 'CreatePolyPolygonRgn';
function CreatePatternBrush; external gdi32 name 'CreatePatternBrush';
function CreateRectRgn; external gdi32 name 'CreateRectRgn';
function CreateRectRgnIndirect; external gdi32 name 'CreateRectRgnIndirect';
function CreateRoundRectRgn; external gdi32 name 'CreateRoundRectRgn';
function CreateScalableFontResourceA; external gdi32 name 'CreateScalableFontResourceA';
function CreateScalableFontResourceW; external gdi32 name 'CreateScalableFontResourceW';
function CreateScalableFontResource; external gdi32 name 'CreateScalableFontResource' + AWSuffix;
function CreateSolidBrush; external gdi32 name 'CreateSolidBrush';
function DeleteDC; external gdi32 name 'DeleteDC';
function DeleteMetaFile; external gdi32 name 'DeleteMetaFile';
function DeleteObject; external gdi32 name 'DeleteObject';
function DescribePixelFormat; external gdi32 name 'DescribePixelFormat';
function DeviceCapabilitiesA; external winspool32 name 'DeviceCapabilitiesA';
function DeviceCapabilitiesW; external winspool32 name 'DeviceCapabilitiesW';
function DeviceCapabilities; external winspool32 name 'DeviceCapabilities' + AWSuffix;
function DrawEscape; external gdi32 name 'DrawEscape';
function Ellipse; external gdi32 name 'Ellipse';
function EnumFontFamiliesExA; external gdi32 name 'EnumFontFamiliesExA';
function EnumFontFamiliesExW; external gdi32 name 'EnumFontFamiliesExW';
function EnumFontFamiliesEx; external gdi32 name 'EnumFontFamiliesEx' + AWSuffix;
function EnumFontFamiliesA; external gdi32 name 'EnumFontFamiliesA';
function EnumFontFamiliesW; external gdi32 name 'EnumFontFamiliesW';
function EnumFontFamilies; external gdi32 name 'EnumFontFamilies' + AWSuffix;
function EnumFontsA; external gdi32 name 'EnumFontsA';
function EnumFontsW; external gdi32 name 'EnumFontsW';
function EnumFonts; external gdi32 name 'EnumFonts' + AWSuffix;
function EnumObjects; external gdi32 name 'EnumObjects';
function EqualRgn; external gdi32 name 'EqualRgn';
function Escape; external gdi32 name 'Escape';
function ExtEscape; external gdi32 name 'ExtEscape';
function ExcludeClipRect; external gdi32 name 'ExcludeClipRect';
function ExtCreateRegion; external gdi32 name 'ExtCreateRegion';
function ExtFloodFill; external gdi32 name 'ExtFloodFill';
function FillRgn; external gdi32 name 'FillRgn';
function FloodFill; external gdi32 name 'FloodFill';
function FrameRgn; external gdi32 name 'FrameRgn';
function GetROP2; external gdi32 name 'GetROP2';
function GetAspectRatioFilterEx; external gdi32 name 'GetAspectRatioFilterEx';
function GetBkColor; external gdi32 name 'GetBkColor';
function GetDCBrushColor; external gdi32 name 'GetDCBrushColor';
function GetDCPenColor; external gdi32 name 'GetDCPenColor';
function GetBkMode; external gdi32 name 'GetBkMode';
function GetBitmapBits; external gdi32 name 'GetBitmapBits';
function GetBitmapDimensionEx; external gdi32 name 'GetBitmapDimensionEx';
function GetBoundsRect; external gdi32 name 'GetBoundsRect';
function GetBrushOrgEx; external gdi32 name 'GetBrushOrgEx';
function GetCharWidthA; external gdi32 name 'GetCharWidthA';
function GetCharWidthW; external gdi32 name 'GetCharWidthW';
function GetCharWidth; external gdi32 name 'GetCharWidth' + AWSuffix;
function GetCharWidth32A; external gdi32 name 'GetCharWidth32A';
function GetCharWidth32W; external gdi32 name 'GetCharWidth32W';
function GetCharWidth32; external gdi32 name 'GetCharWidth32' + AWSuffix;
function GetCharWidthFloatA; external gdi32 name 'GetCharWidthFloatA';
function GetCharWidthFloatW; external gdi32 name 'GetCharWidthFloatW';
function GetCharWidthFloat; external gdi32 name 'GetCharWidthFloat' + AWSuffix;
function GetCharABCWidthsA; external gdi32 name 'GetCharABCWidthsA';
function GetCharABCWidthsW; external gdi32 name 'GetCharABCWidthsW';
function GetCharABCWidths; external gdi32 name 'GetCharABCWidths' + AWSuffix;
function GetCharABCWidthsFloatA; external gdi32 name 'GetCharABCWidthsFloatA';
function GetCharABCWidthsFloatW; external gdi32 name 'GetCharABCWidthsFloatW';
function GetCharABCWidthsFloat; external gdi32 name 'GetCharABCWidthsFloat' + AWSuffix;
function GetClipBox; external gdi32 name 'GetClipBox';
function GetClipRgn; external gdi32 name 'GetClipRgn';
function GetMetaRgn; external gdi32 name 'GetMetaRgn';
function GetCurrentObject; external gdi32 name 'GetCurrentObject';
function GetCurrentPositionEx; external gdi32 name 'GetCurrentPositionEx';
function GetDeviceCaps; external gdi32 name 'GetDeviceCaps';
function GetDIBits; external gdi32 name 'GetDIBits';
function GetFontData; external gdi32 name 'GetFontData';
function GetGlyphOutlineA; external gdi32 name 'GetGlyphOutlineA';
function GetGlyphOutlineW; external gdi32 name 'GetGlyphOutlineW';
function GetGlyphOutline; external gdi32 name 'GetGlyphOutline' + AWSuffix;
function GetGraphicsMode; external gdi32 name 'GetGraphicsMode';
function GetMapMode; external gdi32 name 'GetMapMode';
function GetMetaFileBitsEx; external gdi32 name 'GetMetaFileBitsEx';
function GetMetaFileA; external gdi32 name 'GetMetaFileA';
function GetMetaFileW; external gdi32 name 'GetMetaFileW';
function GetMetaFile; external gdi32 name 'GetMetaFile' + AWSuffix;
function GetNearestColor; external gdi32 name 'GetNearestColor';
function GetNearestPaletteIndex; external gdi32 name 'GetNearestPaletteIndex';
function GetObjectType; external gdi32 name 'GetObjectType';
function GetOutlineTextMetricsA; external gdi32 name 'GetOutlineTextMetricsA';
function GetOutlineTextMetricsW; external gdi32 name 'GetOutlineTextMetricsW';
function GetOutlineTextMetrics; external gdi32 name 'GetOutlineTextMetrics' + AWSuffix;
function GetPaletteEntries; external gdi32 name 'GetPaletteEntries';
function GetPixel; external gdi32 name 'GetPixel';
function GetPixelFormat; external gdi32 name 'GetPixelFormat';
function GetPolyFillMode; external gdi32 name 'GetPolyFillMode';
function GetRasterizerCaps; external gdi32 name 'GetRasterizerCaps';
function GetRandomRgn; external gdi32 name 'GetRandomRgn';
function GetRegionData; external gdi32 name 'GetRegionData';
function GetRgnBox; external gdi32 name 'GetRgnBox';
function GetStockObject; external gdi32 name 'GetStockObject';
function GetStretchBltMode; external gdi32 name 'GetStretchBltMode';
function GetSystemPaletteEntries; external gdi32 name 'GetSystemPaletteEntries';
function GetSystemPaletteUse; external gdi32 name 'GetSystemPaletteUse';
function GetTextCharacterExtra; external gdi32 name 'GetTextCharacterExtra';
function GetTextAlign; external gdi32 name 'GetTextAlign';
function GetTextColor; external gdi32 name 'GetTextColor';
function GetTextExtentPointA; external gdi32 name 'GetTextExtentPointA';
function GetTextExtentPointW; external gdi32 name 'GetTextExtentPointW';
function GetTextExtentPoint; external gdi32 name 'GetTextExtentPoint' + AWSuffix;
function GetTextExtentPoint32A; external gdi32 name 'GetTextExtentPoint32A';
function GetTextExtentPoint32W; external gdi32 name 'GetTextExtentPoint32W';
function GetTextExtentPoint32; external gdi32 name 'GetTextExtentPoint32' + AWSuffix;
function GetTextExtentExPointA; external gdi32 name 'GetTextExtentExPointA';
function GetTextExtentExPointW; external gdi32 name 'GetTextExtentExPointW';
function GetTextExtentExPoint; external gdi32 name 'GetTextExtentExPoint' + AWSuffix;
function GetTextCharset; external gdi32 name 'GetTextCharset';
function GetTextCharsetInfo; external gdi32 name 'GetTextCharsetInfo';
function TranslateCharsetInfo; external gdi32 name 'TranslateCharsetInfo';
function GetFontLanguageInfo; external gdi32 name 'GetFontLanguageInfo';
function GetCharacterPlacementA; external gdi32 name 'GetCharacterPlacementA';
function GetCharacterPlacementW; external gdi32 name 'GetCharacterPlacementW';
function GetCharacterPlacement; external gdi32 name 'GetCharacterPlacement' + AWSuffix;
function GetFontUnicodeRanges; external gdi32 name 'GetFontUnicodeRanges';
function GetGlyphIndicesA; external gdi32 name 'GetGlyphIndicesA';
function GetGlyphIndicesW; external gdi32 name 'GetGlyphIndicesW';
function GetGlyphIndices; external gdi32 name 'GetGlyphIndices' + AWSuffix;
function GetTextExtentPointI; external gdi32 name 'GetTextExtentPointI';
function GetTextExtentExPointI; external gdi32 name 'GetTextExtentExPointI';
function GetCharWidthI; external gdi32 name 'GetCharWidthI';
function GetCharABCWidthsI; external gdi32 name 'GetCharABCWidthsI';
function AddFontResourceExA; external gdi32 name 'AddFontResourceExA';
function AddFontResourceExW; external gdi32 name 'AddFontResourceExW';
function AddFontResourceEx; external gdi32 name 'AddFontResourceEx' + AWSuffix;
function RemoveFontResourceExA; external gdi32 name 'RemoveFontResourceExA';
function RemoveFontResourceExW; external gdi32 name 'RemoveFontResourceExW';
function RemoveFontResourceEx; external gdi32 name 'RemoveFontResourceEx' + AWSuffix;
function AddFontMemResourceEx; external gdi32 name 'AddFontMemResourceEx';
function RemoveFontMemResourceEx; external gdi32 name 'RemoveFontMemResourceEx';
function CreateFontIndirectExA; external gdi32 name 'CreateFontIndirectExA';
function CreateFontIndirectExW; external gdi32 name 'CreateFontIndirectExW';
function CreateFontIndirectEx; external gdi32 name 'CreateFontIndirectEx' + AWSuffix;
function GetViewportExtEx; external gdi32 name 'GetViewportExtEx';
function GetViewportOrgEx; external gdi32 name 'GetViewportOrgEx';
function GetWindowExtEx; external gdi32 name 'GetWindowExtEx';
function GetWindowOrgEx; external gdi32 name 'GetWindowOrgEx';
function IntersectClipRect; external gdi32 name 'IntersectClipRect';
function InvertRgn; external gdi32 name 'InvertRgn';
function LineDDA; external gdi32 name 'LineDDA';
function LineTo; external gdi32 name 'LineTo';
function MaskBlt; external gdi32 name 'MaskBlt';
function PlgBlt; external gdi32 name 'PlgBlt';
function OffsetClipRgn; external gdi32 name 'OffsetClipRgn';
function OffsetRgn; external gdi32 name 'OffsetRgn';
function PatBlt; external gdi32 name 'PatBlt';
function Pie; external gdi32 name 'Pie';
function PlayMetaFile; external gdi32 name 'PlayMetaFile';
function PaintRgn; external gdi32 name 'PaintRgn';
function PolyPolygon; external gdi32 name 'PolyPolygon';
function PtInRegion; external gdi32 name 'PtInRegion';
function PtVisible; external gdi32 name 'PtVisible';
function RectInRegion; external gdi32 name 'RectInRegion';
function RectVisible; external gdi32 name 'RectVisible';
function Rectangle; external gdi32 name 'Rectangle';
function RestoreDC; external gdi32 name 'RestoreDC';
function ResetDCA; external gdi32 name 'ResetDCA';
function ResetDCW; external gdi32 name 'ResetDCW';
function ResetDC; external gdi32 name 'ResetDC' + AWSuffix;
function RealizePalette; external gdi32 name 'RealizePalette';
function RemoveFontResourceA; external gdi32 name 'RemoveFontResourceA';
function RemoveFontResourceW; external gdi32 name 'RemoveFontResourceW';
function RemoveFontResource; external gdi32 name 'RemoveFontResource' + AWSuffix;
function RoundRect; external gdi32 name 'RoundRect';
function ResizePalette; external gdi32 name 'ResizePalette';
function SaveDC; external gdi32 name 'SaveDC';
function SelectClipRgn; external gdi32 name 'SelectClipRgn';
function ExtSelectClipRgn; external gdi32 name 'ExtSelectClipRgn';
function SetMetaRgn; external gdi32 name 'SetMetaRgn';
function SelectObject; external gdi32 name 'SelectObject';
function SelectPalette; external gdi32 name 'SelectPalette';
function SetBkColor; external gdi32 name 'SetBkColor';
function SetDCBrushColor; external gdi32 name 'SetDCBrushColor';
function SetDCPenColor; external gdi32 name 'SetDCPenColor';
function SetBkMode; external gdi32 name 'SetBkMode';
function SetBitmapBits; external gdi32 name 'SetBitmapBits';
function SetBoundsRect; external gdi32 name 'SetBoundsRect';
function SetDIBits; external gdi32 name 'SetDIBits';
function SetDIBitsToDevice; external gdi32 name 'SetDIBitsToDevice';
function SetMapperFlags; external gdi32 name 'SetMapperFlags';
function SetGraphicsMode; external gdi32 name 'SetGraphicsMode';
function SetMapMode; external gdi32 name 'SetMapMode';
function SetLayout; external gdi32 name 'SetLayout';
function GetLayout; external gdi32 name 'GetLayout';
function SetMetaFileBitsEx; external gdi32 name 'SetMetaFileBitsEx';
function SetPaletteEntries; external gdi32 name 'SetPaletteEntries';
function SetPixel; external gdi32 name 'SetPixel';
function SetPixelV; external gdi32 name 'SetPixelV';
function SetPixelFormat; external gdi32 name 'SetPixelFormat';
function SetPolyFillMode; external gdi32 name 'SetPolyFillMode';
function StretchBlt; external gdi32 name 'StretchBlt';
function SetRectRgn; external gdi32 name 'SetRectRgn';
function StretchDIBits; external gdi32 name 'StretchDIBits';
function SetROP2; external gdi32 name 'SetROP2';
function SetStretchBltMode; external gdi32 name 'SetStretchBltMode';
function SetSystemPaletteUse; external gdi32 name 'SetSystemPaletteUse';
function SetTextCharacterExtra; external gdi32 name 'SetTextCharacterExtra';
function SetTextColor; external gdi32 name 'SetTextColor';
function SetTextAlign; external gdi32 name 'SetTextAlign';
function SetTextJustification; external gdi32 name 'SetTextJustification';
function UpdateColors; external gdi32 name 'UpdateColors';
function AlphaBlend; external msimg32 name 'AlphaBlend';
function TransparentBlt; external msimg32 name 'TransparentBlt';
function GradientFill; external msimg32 name 'GradientFill';
function PlayMetaFileRecord; external gdi32 name 'PlayMetaFileRecord';
function EnumMetaFile; external gdi32 name 'EnumMetaFile';
function CloseEnhMetaFile; external gdi32 name 'CloseEnhMetaFile';
function CopyEnhMetaFileA; external gdi32 name 'CopyEnhMetaFileA';
function CopyEnhMetaFileW; external gdi32 name 'CopyEnhMetaFileW';
function CopyEnhMetaFile; external gdi32 name 'CopyEnhMetaFile' + AWSuffix;
function CreateEnhMetaFileA; external gdi32 name 'CreateEnhMetaFileA';
function CreateEnhMetaFileW; external gdi32 name 'CreateEnhMetaFileW';
function CreateEnhMetaFile; external gdi32 name 'CreateEnhMetaFile' + AWSuffix;
function DeleteEnhMetaFile; external gdi32 name 'DeleteEnhMetaFile';
function EnumEnhMetaFile; external gdi32 name 'EnumEnhMetaFile';
function GetEnhMetaFileA; external gdi32 name 'GetEnhMetaFileA';
function GetEnhMetaFileW; external gdi32 name 'GetEnhMetaFileW';
function GetEnhMetaFile; external gdi32 name 'GetEnhMetaFile' + AWSuffix;
function GetEnhMetaFileBits; external gdi32 name 'GetEnhMetaFileBits';
function GetEnhMetaFileDescriptionA; external gdi32 name 'GetEnhMetaFileDescriptionA';
function GetEnhMetaFileDescriptionW; external gdi32 name 'GetEnhMetaFileDescriptionW';
function GetEnhMetaFileDescription; external gdi32 name 'GetEnhMetaFileDescription' + AWSuffix;
function GetEnhMetaFileHeader; external gdi32 name 'GetEnhMetaFileHeader';
function GetEnhMetaFilePaletteEntries; external gdi32 name 'GetEnhMetaFilePaletteEntries';
function GetEnhMetaFilePixelFormat; external gdi32 name 'GetEnhMetaFilePixelFormat';
function GetWinMetaFileBits; external gdi32 name 'GetWinMetaFileBits';
function PlayEnhMetaFile; external gdi32 name 'PlayEnhMetaFile';
function PlayEnhMetaFileRecord; external gdi32 name 'PlayEnhMetaFileRecord';
function SetEnhMetaFileBits; external gdi32 name 'SetEnhMetaFileBits';
function SetWinMetaFileBits; external gdi32 name 'SetWinMetaFileBits';
function GdiComment; external gdi32 name 'GdiComment';
function GetTextMetricsA; external gdi32 name 'GetTextMetricsA';
function GetTextMetricsW; external gdi32 name 'GetTextMetricsW';
function GetTextMetrics; external gdi32 name 'GetTextMetrics' + AWSuffix;
function AngleArc; external gdi32 name 'AngleArc';
function PolyPolyline; external gdi32 name 'PolyPolyline';
function GetWorldTransform; external gdi32 name 'GetWorldTransform';
function SetWorldTransform; external gdi32 name 'SetWorldTransform';
function ModifyWorldTransform; external gdi32 name 'ModifyWorldTransform';
function CombineTransform; external gdi32 name 'CombineTransform';
function CreateDIBSection; external gdi32 name 'CreateDIBSection';
function GetDIBColorTable; external gdi32 name 'GetDIBColorTable';
function SetDIBColorTable; external gdi32 name 'SetDIBColorTable';
function SetColorAdjustment; external gdi32 name 'SetColorAdjustment';
function GetColorAdjustment; external gdi32 name 'GetColorAdjustment';
function CreateHalftonePalette; external gdi32 name 'CreateHalftonePalette';
function StartDocA; external gdi32 name 'StartDocA';
function StartDocW; external gdi32 name 'StartDocW';
function StartDoc; external gdi32 name 'StartDoc' + AWSuffix;
function EndDoc; external gdi32 name 'EndDoc';
function StartPage; external gdi32 name 'StartPage';
function EndPage; external gdi32 name 'EndPage';
function AbortDoc; external gdi32 name 'AbortDoc';
function SetAbortProc; external gdi32 name 'SetAbortProc';
function AbortPath; external gdi32 name 'AbortPath';
function ArcTo; external gdi32 name 'ArcTo';
function BeginPath; external gdi32 name 'BeginPath';
function CloseFigure; external gdi32 name 'CloseFigure';
function EndPath; external gdi32 name 'EndPath';
function FillPath; external gdi32 name 'FillPath';
function FlattenPath; external gdi32 name 'FlattenPath';
function GetPath; external gdi32 name 'GetPath';
function PathToRegion; external gdi32 name 'PathToRegion';
function PolyDraw; external gdi32 name 'PolyDraw';
function SelectClipPath; external gdi32 name 'SelectClipPath';
function SetArcDirection; external gdi32 name 'SetArcDirection';
function SetMiterLimit; external gdi32 name 'SetMiterLimit';
function StrokeAndFillPath; external gdi32 name 'StrokeAndFillPath';
function StrokePath; external gdi32 name 'StrokePath';
function WidenPath; external gdi32 name 'WidenPath';
function ExtCreatePen; external gdi32 name 'ExtCreatePen';
function GetMiterLimit; external gdi32 name 'GetMiterLimit';
function GetArcDirection; external gdi32 name 'GetArcDirection';
function GetObjectA; external gdi32 name 'GetObjectA';
function GetObjectW; external gdi32 name 'GetObjectW';
function GetObject; external gdi32 name 'GetObject' + AWSuffix;
function MoveToEx; external gdi32 name 'MoveToEx';
function TextOutA; external gdi32 name 'TextOutA';
function TextOutW; external gdi32 name 'TextOutW';
function TextOut; external gdi32 name 'TextOut' + AWSuffix;
function ExtTextOutA; external gdi32 name 'ExtTextOutA';
function ExtTextOutW; external gdi32 name 'ExtTextOutW';
function ExtTextOut; external gdi32 name 'ExtTextOut' + AWSuffix;
function PolyTextOutA; external gdi32 name 'PolyTextOutA';
function PolyTextOutW; external gdi32 name 'PolyTextOutW';
function PolyTextOut; external gdi32 name 'PolyTextOut' + AWSuffix;
function CreatePolygonRgn; external gdi32 name 'CreatePolygonRgn';
function DPtoLP; external gdi32 name 'DPtoLP';
function LPtoDP; external gdi32 name 'LPtoDP';
function Polygon; external gdi32 name 'Polygon';
function Polyline; external gdi32 name 'Polyline';
function PolyBezier; external gdi32 name 'PolyBezier';
function PolyBezierTo; external gdi32 name 'PolyBezierTo';
function PolylineTo; external gdi32 name 'PolylineTo';
function SetViewportExtEx; external gdi32 name 'SetViewportExtEx';
function SetViewportOrgEx; external gdi32 name 'SetViewportOrgEx';
function SetWindowExtEx; external gdi32 name 'SetWindowExtEx';
function SetWindowOrgEx; external gdi32 name 'SetWindowOrgEx';
function OffsetViewportOrgEx; external gdi32 name 'OffsetViewportOrgEx';
function OffsetWindowOrgEx; external gdi32 name 'OffsetWindowOrgEx';
function ScaleViewportExtEx; external gdi32 name 'ScaleViewportExtEx';
function ScaleWindowExtEx; external gdi32 name 'ScaleWindowExtEx';
function SetBitmapDimensionEx; external gdi32 name 'SetBitmapDimensionEx';
function SetBrushOrgEx; external gdi32 name 'SetBrushOrgEx';
function GetTextFaceA; external gdi32 name 'GetTextFaceA';
function GetTextFaceW; external gdi32 name 'GetTextFaceW';
function GetTextFace; external gdi32 name 'GetTextFace' + AWSuffix;
function GetKerningPairsA; external gdi32 name 'GetKerningPairsA';
function GetKerningPairsW; external gdi32 name 'GetKerningPairsW';
function GetKerningPairs; external gdi32 name 'GetKerningPairs' + AWSuffix;
function GetDCOrgEx; external gdi32 name 'GetDCOrgEx';
function FixBrushOrgEx; external gdi32 name 'FixBrushOrgEx';
function UnrealizeObject; external gdi32 name 'UnrealizeObject';
function GdiFlush; external gdi32 name 'GdiFlush';
function GdiSetBatchLimit; external gdi32 name 'GdiSetBatchLimit';
function GdiGetBatchLimit; external gdi32 name 'GdiGetBatchLimit';
function SetICMMode; external gdi32 name 'SetICMMode';
function CheckColorsInGamut; external gdi32 name 'CheckColorsInGamut';
function GetColorSpace; external gdi32 name 'GetColorSpace';
function GetLogColorSpaceA; external gdi32 name 'GetLogColorSpaceA';
function GetLogColorSpaceW; external gdi32 name 'GetLogColorSpaceW';
function GetLogColorSpace; external gdi32 name 'GetLogColorSpace' + AWSuffix;
function CreateColorSpaceA; external gdi32 name 'CreateColorSpaceA';
function CreateColorSpaceW; external gdi32 name 'CreateColorSpaceW';
function CreateColorSpace; external gdi32 name 'CreateColorSpace' + AWSuffix;
function SetColorSpace; external gdi32 name 'SetColorSpace';
function DeleteColorSpace; external gdi32 name 'DeleteColorSpace';
function GetICMProfileA; external gdi32 name 'GetICMProfileA';
function GetICMProfileW; external gdi32 name 'GetICMProfileW';
function GetICMProfile; external gdi32 name 'GetICMProfile' + AWSuffix;
function SetICMProfileA; external gdi32 name 'SetICMProfileA';
function SetICMProfileW; external gdi32 name 'SetICMProfileW';
function SetICMProfile; external gdi32 name 'SetICMProfile' + AWSuffix;
function GetDeviceGammaRamp; external gdi32 name 'GetDeviceGammaRamp';
function SetDeviceGammaRamp; external gdi32 name 'SetDeviceGammaRamp';
function ColorMatchToTarget; external gdi32 name 'ColorMatchToTarget';
function EnumICMProfilesA; external gdi32 name 'EnumICMProfilesA';
function EnumICMProfilesW; external gdi32 name 'EnumICMProfilesW';
function EnumICMProfiles; external gdi32 name 'EnumICMProfiles' + AWSuffix;
function UpdateICMRegKeyA; external gdi32 name 'UpdateICMRegKeyA';
function UpdateICMRegKeyW; external gdi32 name 'UpdateICMRegKeyW';
function UpdateICMRegKey; external gdi32 name 'UpdateICMRegKey' + AWSuffix;
function ColorCorrectPalette; external gdi32 name 'ColorCorrectPalette';
function wglCopyContext; external opengl32 name 'wglCopyContext';
function wglCreateContext; external opengl32 name 'wglCreateContext';
function wglCreateLayerContext; external opengl32 name 'wglCreateLayerContext';
function wglDeleteContext; external opengl32 name 'wglDeleteContext';
function wglGetCurrentContext; external opengl32 name 'wglGetCurrentContext';
function wglGetCurrentDC; external opengl32 name 'wglGetCurrentDC';
function wglGetProcAddress; external opengl32 name 'wglGetProcAddress';
function wglMakeCurrent; external opengl32 name 'wglMakeCurrent';
function wglShareLists; external opengl32 name 'wglShareLists';
function wglUseFontBitmapsA; external opengl32 name 'wglUseFontBitmapsA';
function wglUseFontBitmapsW; external opengl32 name 'wglUseFontBitmapsW';
function wglUseFontBitmaps; external opengl32 name 'wglUseFontBitmaps' + AWSuffix;
function SwapBuffers; external opengl32 name 'SwapBuffers';
function wglUseFontOutlinesA; external opengl32 name 'wglUseFontOutlinesA';
function wglUseFontOutlinesW; external opengl32 name 'wglUseFontOutlinesW';
function wglUseFontOutlines; external opengl32 name 'wglUseFontOutlines' + AWSuffix;
function wglDescribeLayerPlane; external opengl32 name 'wglDescribeLayerPlane';
function wglSetLayerPaletteEntries; external opengl32 name 'wglSetLayerPaletteEntries';
function wglGetLayerPaletteEntries; external opengl32 name 'wglGetLayerPaletteEntries';
function wglRealizeLayerPalette; external opengl32 name 'wglRealizeLayerPalette';
function wglSwapLayerBuffers; external opengl32 name 'wglSwapLayerBuffers';
function wglSwapMultipleBuffers; external opengl32 name 'wglSwapMultipleBuffers';

{$ENDIF DYNAMIC_LINK}

end.
