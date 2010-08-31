{
Writes an SVG Document

License: The same modified LGPL as the Free Pascal RTL
         See the file COPYING.modifiedLGPL for more details

AUTHORS: Felipe Monteiro de Carvalho
}
unit svgvectorialwriter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, fpvectorial;

type
  { TvSVGVectorialWriter }

  TvSVGVectorialWriter = class(TvCustomVectorialWriter)
  private
    FPointSeparator, FCommaSeparator: TFormatSettings;
    procedure WriteDocumentSize(AStrings: TStrings; AData: TvVectorialDocument);
    procedure WriteDocumentName(AStrings: TStrings; AData: TvVectorialDocument);
    procedure WritePaths(AStrings: TStrings; AData: TvVectorialDocument);
    procedure WriteTexts(AStrings: TStrings; AData: TvVectorialDocument);
    procedure WriteBeziers(AStrings: TStrings; AData: TvVectorialDocument);
    procedure ConvertFPVCoordinatesToSVGCoordinates(
      const AData: TvVectorialDocument;
      const ASrcX, ASrcY: Double; var ADestX, ADestY: double);
  public
    { General reading methods }
    procedure WriteToStrings(AStrings: TStrings; AData: TvVectorialDocument); override;
  end;

implementation

const
  FLOAT_MILIMETERS_PER_PIXEL = 0.3528;

{ TvSVGVectorialWriter }

procedure TvSVGVectorialWriter.WriteDocumentSize(AStrings: TStrings; AData: TvVectorialDocument);
begin
  AStrings.Add('  width="' + FloatToStr(AData.Width, FPointSeparator) + 'mm"');
  AStrings.Add('  height="' + FloatToStr(AData.Height, FPointSeparator) + 'mm"');
end;

procedure TvSVGVectorialWriter.WriteDocumentName(AStrings: TStrings; AData: TvVectorialDocument);
begin
  AStrings.Add('  sodipodi:docname="New document 1">');
end;

{@@
  SVG Coordinate system measures things only in pixels, so that we have to
  hardcode a DPI value for the screen, which is usually 72.
  FPVectorial uses only milimeters (mm).

  The initial point in FPVectorial is in the bottom-left corner of the document
  and it grows to the top and to the right. In SVG, on the other hand, the
  initial point is in the top-left corner, growing to the bottom and right.
  Besides that, coordinates in SVG are also lengths in comparison to the
  previous point and not absolute coordinates.

  SVG uses commas "," to separate the X,Y coordinates, so it always uses points
  "." as decimal separators and uses no thousand separators
}
procedure TvSVGVectorialWriter.WritePaths(AStrings: TStrings; AData: TvVectorialDocument);
var
  i, j: Integer;
  PathStr: string;
  lPath: TPath;
  PtX, PtY, OldPtX, OldPtY: double;
begin
  for i := 0 to AData.GetPathCount() - 1 do
  begin
    OldPtX := 0;
    OldPtY := 0;

    PathStr := 'm ';
    lPath := AData.GetPath(i);
    for j := 0 to lPath.Len - 1 do
    begin
      if (lPath.Points[j].SegmentType <> st2DLine)
        and (lPath.Points[j].SegmentType <> stMoveTo)
        then Break; // unsupported line type
//      PtX := lPath.Points[j].X;
//      PtY := lPath.Points[j].Y;
//      PathStr := PathStr + FloatToStr(PtX, FPointSeparator) + ','  // + 'mm,'
//        + FloatToStr(PtY, FPointSeparator) + ' '; // + 'mm ';
      // Coordinate conversion from fpvectorial to SVG
      ConvertFPVCoordinatesToSVGCoordinates(
        AData, lPath.Points[j].X, lPath.Points[j].Y, PtX, PtY);
      PtX := PtX - OldPtX;
      PtY := PtY - OldPtY;

      PathStr := PathStr + FloatToStr(PtX, FPointSeparator) + ','
        + FloatToStr(PtY, FPointSeparator) + ' ';

      // Store the current position for future points
      OldPtX := OldPtX + PtX;
      OldPtY := OldPtY + PtY;
    end;

    AStrings.Add('  <path');
    AStrings.Add('    style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"');
    AStrings.Add('    d="' + PathStr + '"');
    AStrings.Add('  id="path' + IntToStr(i) + '" />');
  end;
end;

procedure TvSVGVectorialWriter.ConvertFPVCoordinatesToSVGCoordinates(
  const AData: TvVectorialDocument; const ASrcX, ASrcY: Double; var ADestX,
  ADestY: double);
begin
  ADestX := ASrcX / FLOAT_MILIMETERS_PER_PIXEL;
  ADestY := (AData.Height - ASrcY) / FLOAT_MILIMETERS_PER_PIXEL;
end;

procedure TvSVGVectorialWriter.WriteToStrings(AStrings: TStrings;
  AData: TvVectorialDocument);
begin
  // Format seetings to convert a string to a float
  FPointSeparator := DefaultFormatSettings;
  FPointSeparator.DecimalSeparator := '.';
  FPointSeparator.ThousandSeparator := '#';// disable the thousand separator
  FCommaSeparator := DefaultFormatSettings;
  FCommaSeparator.DecimalSeparator := ',';
  FCommaSeparator.ThousandSeparator := '#';// disable the thousand separator

  // Headers
  AStrings.Add('<?xml version="1.0" encoding="UTF-8" standalone="no"?>');
  AStrings.Add('<!-- Created with fpVectorial (http://wiki.lazarus.freepascal.org/fpvectorial) -->');
  AStrings.Add('');
  AStrings.Add('<svg');
  AStrings.Add('  xmlns:dc="http://purl.org/dc/elements/1.1/"');
  AStrings.Add('  xmlns:cc="http://creativecommons.org/ns#"');
  AStrings.Add('  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"');
  AStrings.Add('  xmlns:svg="http://www.w3.org/2000/svg"');
  AStrings.Add('  xmlns="http://www.w3.org/2000/svg"');
  AStrings.Add('  xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"');
  WriteDocumentSize(AStrings, AData);
  AStrings.Add('  id="svg2"');
  AStrings.Add('  version="1.1"');
  WriteDocumentName(AStrings, AData);

  // Now data
  AStrings.Add('  <g id="layer1">');
  WritePaths(AStrings, AData);
  WriteTexts(AStrings, AData);
  WriteBeziers(AStrings, AData);
  AStrings.Add('  </g>');

  // finalization
  AStrings.Add('</svg>');
end;

procedure TvSVGVectorialWriter.WriteTexts(AStrings: TStrings; AData: TvVectorialDocument);
var
  i, j, FontSize: Integer;
  TextStr, FontName: string;
  ltest: TvText;
  PtX, PtY: double;
begin
  for i := 0 to AData.GetTextCount() - 1 do
  begin
    TextStr := '';
    ltest := AData.GetText(i);
    //PtX := ltest.X;
    //PtY := ltest.Y;
    ConvertFPVCoordinatesToSVGCoordinates(
        AData, ltest.X, ltest.Y, PtX, PtY);
    TextStr := ltest.Value;
    FontSize:= ceil(ltest.FontSize / FLOAT_MILIMETERS_PER_PIXEL);
    FontName:=ltest.FontName;
    AStrings.Add('  <text');
    AStrings.Add('    style="font-size:'
    +IntToStr(FontSize)+'px;font-style:normal;font-weight:normal;line-height:125%;'
    +'letter-spacing:0px;word-spacing:0px;fill:#000000;fill-opacity:1;stroke:none;'
    +'font-family:'+FontName+'"><tspan');
    AStrings.Add('     x="' + FloatToStr(PtX, FPointSeparator) + '"');
    AStrings.Add('     y="' + FloatToStr(PtY, FPointSeparator) + '"');
    AStrings.Add('     id="tspan3071">' + TextStr + '</tspan></text>');
  end;
end;

procedure TvSVGVectorialWriter.WriteBeziers(AStrings: TStrings; AData: TvVectorialDocument);
var
  i, j: Integer;
  PathStr: string;
  lPath: TPath;
  PtX, PtY, OldPtX, OldPtY, PtX2, PtY2, OldPtX2, OldPtY2,
    PtX3, PtY3, OldPtX3, OldPtY3: double;
  BezierType: TSegmentType;
begin
  for i := 0 to AData.GetPathCount() - 1 do
  begin
    OldPtX  := 0;
    OldPtY  := 0;
    OldPtX2 := 0;
    OldPtY2 := 0;
    OldPtX3 := 0;
    OldPtY3 := 0;

    PathStr := 'm ';
    lPath   := AData.GetPath(i);
    for j := 0 to lPath.Len - 1 do
    begin
      BezierType := lPath.Points[j].SegmentType;
      if j>0 then
      if (BezierType <> st2DBezier) and (BezierType <> st3DBezier)
        and (BezierType<> st2DLine)
      then Break; // unsupported Bezier type

      //ConvertFPVCoordinatesToSVGCoordinates(
      //  AData, lPath.Points[j].X, lPath.Points[j].Y, PtX, PtY);

      if (BezierType = st2DBezier) or (BezierType = stMoveTo) then
      begin
      PtX  := lPath.Points[j].X / FLOAT_MILIMETERS_PER_PIXEL;
      PtY  := (AData.Height - lPath.Points[j].Y) / FLOAT_MILIMETERS_PER_PIXEL;
      PtX2 := lPath.Points[j].X2 / FLOAT_MILIMETERS_PER_PIXEL;
      PtY2 := (AData.Height - lPath.Points[j].Y2) / FLOAT_MILIMETERS_PER_PIXEL;
      PtX3 := lPath.Points[j].X3 / FLOAT_MILIMETERS_PER_PIXEL;
      PtY3 := (AData.Height - lPath.Points[j].Y3) / FLOAT_MILIMETERS_PER_PIXEL;

      PtX  := PtX - OldPtX;
      PtY  := PtY - OldPtY;
      PtX2 := PtX2 - OldPtX2;
      PtY2 := PtY2 - OldPtY2;
      PtX3 := PtX3 - OldPtX3;
      PtY3 := PtY3 - OldPtY3;

      if j = 0 then
        PathStr := PathStr + FloatToStr(PtX, FPointSeparator) + ','
          + FloatToStr(PtY, FPointSeparator) + ' ';

      if j = 0 then
      begin
 //       if BezierType = st2DBezier then
          PathStr := PathStr + 'q';
        if BezierType = st3DBezier then
          PathStr := PathStr + 'c';
      end;

      if j > 0 then
        PathStr := PathStr + FloatToStr(PtX, FPointSeparator) + ','
          + FloatToStr(PtY, FPointSeparator) + ' '
          + FloatToStr(PtX2, FPointSeparator) + ','
          + FloatToStr(PtY2, FPointSeparator) + ' '
          + FloatToStr(PtX3, FPointSeparator) + ','
          + FloatToStr(PtY3, FPointSeparator) + ' ';

      // Store the current position for future points
      OldPtX  := OldPtX + PtX;
      OldPtY  := OldPtY + PtY;
      OldPtX2 := OldPtX2 + PtX2;
      OldPtY2 := OldPtY2 + PtY2;
      OldPtX3 := OldPtX3 + PtX3;
      OldPtY3 := OldPtY3 + PtY3;
    end;

    end;

    AStrings.Add('  <path');
    AStrings.Add('    style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"');
    AStrings.Add('    d="' + PathStr + '"');
    AStrings.Add('  id="Bezier' + IntToStr(i) + '" />');
  end;
end;

initialization

  RegisterVectorialWriter(TvSVGVectorialWriter, vfSVG);

end.

