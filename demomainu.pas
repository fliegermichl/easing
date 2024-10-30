unit demomainu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, easing, lclintf, lcltype;

type

  { TEasingDemo }

  TEasingDemo = class(TForm)
    btnDoIt: TButton;
    edStartX: TEdit;
    edStopX: TEdit;
    edStartY: TEdit;
    edStopY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pb: TPaintBox;
    Panel1: TPanel;
    rgEasingFunction: TRadioGroup;
    rgEasingMode: TRadioGroup;
    Splitter1: TSplitter;
    tbSpeed: TTrackBar;
    DemoTimer: TTimer;
    tbResolution: TTrackBar;
    procedure btnDoItClick(Sender: TObject);
    procedure DemoTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pbPaint(Sender: TObject);
    procedure rgEasingFunctionSelectionChanged(Sender: TObject);
    procedure tbResolutionChange(Sender: TObject);
    procedure tbSpeedChange(Sender: TObject);
  private
    fbmp : TBitmap;
    fPosition,
    fStep : Single;
    fForward : boolean;
    fDemoIsRunning : boolean;
    feasingFunction : TEasingFunction;
  public

  end;

var
  EasingDemo: TEasingDemo;

implementation

{$R *.lfm}

{ TEasingDemo }

procedure TEasingDemo.btnDoItClick(Sender: TObject);
begin
  fDemoIsRunning := not fDemoIsRunning;
  if fDemoIsRunning then
  begin
    btnDoIt.Caption := 'Stop';
    DemoTimer.Interval:=100-tbSpeed.Position;
    fStep := 1 / tbResolution.Position;
    fPosition := 0;
    fForward := true;
    fEasingFunction := GetEasingFunction(TEasingMode(rgEasingMode.ItemIndex), TEasingCurveType(rgEasingFunction.ItemIndex));
    DemoTimer.Enabled := True;
  end else
  begin
    btnDoIt.Caption := 'Start';
    DemoTimer.Enabled := False;
  end;
end;

procedure TEasingDemo.DemoTimerTimer(Sender: TObject);
begin
  if fForward then
    fPosition += fStep
  else
    fPosition -= fStep;
  if fPosition >= 1 then
  begin
    fForward := false;
    fPosition := 1;
  end else
  if fPosition <= 0 then
  begin
    fPosition := 0;
    fForward := true;
  end;
  pbPaint(pb);
end;

procedure TEasingDemo.FormCreate(Sender: TObject);
begin
  fbmp := TBitmap.Create;
  fbmp.Width := pb.ClientWidth;
  fbmp.Height := pb.ClientHeight;
  fbmp.Canvas.Brush.Color := clWhite;
  fbmp.Canvas.Pen.Color := clBlack;
  fForward := true;
end;

procedure TEasingDemo.FormDestroy(Sender: TObject);
begin
  fbmp.Free;
end;

procedure TEasingDemo.pbPaint(Sender: TObject);
var x, y : integer;
    Distanz : Single;
    ax, ex, ay, ey : integer;
begin
  fbmp.Canvas.FillRect(0, 0, fbmp.Width, fbmp.Height);
  ax := StrToInt(edStartX.Text);
  ex := StrToInt(edStopX.Text);
  ay := StrToInt(edStartY.Text);
  ey := StrToInt(edStopY.Text);
  if not fDemoIsRunning then
  begin
    x := ax;
    y := ay;
  end else
  begin
    Distanz := ex-ax;
    x := Round(ax + (Distanz * fEasingFunction(fPosition)));
    Distanz := ey-ay;
    y := Round(ay + (Distanz * fEasingFunction(fPosition)));
  end;
  fbmp.Canvas.Brush.Color := clBlack;
  fbmp.Canvas.Ellipse(x-4, y-4, x+4, y+4);
  fbmp.Canvas.Brush.Color := clWhite;
  BitBlt(pb.Canvas.Handle, 0, 0, fbmp.Width, fbmp.Height, fbmp.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TEasingDemo.rgEasingFunctionSelectionChanged(Sender: TObject);
begin
  fEasingFunction := GetEasingFunction(TEasingMode(rgEasingMode.ItemIndex), TEasingCurveType(rgEasingFunction.ItemIndex));
end;

procedure TEasingDemo.tbResolutionChange(Sender: TObject);
begin
  fStep := 1 / tbResolution.Position;
end;

procedure TEasingDemo.tbSpeedChange(Sender: TObject);
begin
  DemoTimer.Interval := 100 - tbSpeed.Position;
end;

end.

