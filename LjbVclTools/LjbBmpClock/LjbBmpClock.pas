{ *********************************************************************** }
{                                                                         }
{                 LjbBmpClock  V 3.5 (AnalogClock Component);                }
{                        TLjbBmpClock  Unit                                  }
{                                                                         }
{                Copyright (c) 2003-2006 sail2000 studio                  }
{                                                                         }
{ *********************************************************************** }
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //     可以自由设置表针的长度,反向长度,自定义位图背景,       //
      //  透明位图,并使用后台双缓冲消除闪烁，减少资源占用。        //
      //                                                           //
      //                         E-MAIL :  sail2000@126.com        //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //    重点改进了时钟的表针的算法; 而且增加了多个可以由用户   //
      //    自定义的功能，将主要的属性定义都交给用户,方便使用;     //
      //                                                           //
      //      本软件由“小帆工作室”，版权所有，保留全部权利。     //
      //                                                           //
      //         如果你对此代码进行改进,请遵守 GNU GPL 条约，本软  //
      //     件受 GNU GPL 条约的保护。                             //
      //     请保留原作者的一切信息，同时，请不要忘记给我也寄      //
      //     一份你修改后的源代码!                                 //
      //                                                           //
      //  ** 如果你找到或者写了更好的组件，请不忘也给我一份哦！**  //
      //                                                           //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //                      重  要  事  项                       //
      //      本软件（包括全部源代码，演示程序，以及软件相关附带   //
      //   档案），未经作者的正式书面许可和授权，不得用于商业场合。//
      //   如有违反此授权协议，将会受到法律起诉，所有责任将由违反  //
      //   此授权协议的一方承担全部法律责任。                      //
      //                                            小帆           //
      //                                         2006.01.01        //
      //                                                           //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //                   源代码统计结果输出                      //
      //  文件名：LjbBmpClock.pas                                     //
      //  总字节数：29,710                                         //
      //  代码字节数：17,453                                       //
      //  注释字节数：7,433                                        //
      //  总行数：1029                                             //
      //  有效行数：874                                            //
      //  空行数：155                                              //
      //  代码行数：762                                            //
      //  注释行数：170                                            //
      //  注释块数：170                                            //
      //                                                           //
      ///////////////////////////////////////////////////////////////

unit LjbBmpClock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, Forms,
  ExtCtrls, jpeg;

type
  THour = procedure(Sender: TObject; Hour: word) of object;
  TMinute = procedure(Sender: TObject; Minute: word) of object;
  TSecond = procedure(Sender: TObject; Second: word) of object;
  TBgStyle = (bgPicture, bgColor);
  TPictureStyle = (psNone, psStretch, psTile);
  TThemeStyle = (tsNone, tsCircle, tsRoundRect, tsAuto);

  TLjbBmpClock = class; //申明  TLjbBmpClock

  TCenter = class(TPersistent) //建立钟表指针
  private
    FX: Integer;
    FY: Integer;
    FParent: TLjbBmpClock;

    procedure SetX(Value: Integer);
    procedure SetY(Value: Integer);
  protected
    procedure UpdateParent;
  public
    constructor Create;
    property Parent: TLjbBmpClock read FParent write FParent;
  published
    property X: Integer read FX write SetX default 50;
    property Y: Integer read FY write SetY default 50;
  end;

  THand = class(TPersistent) //建立钟表指针
  private
    FRadius: Integer;
    FBackRadius: Integer;
    FWidth: Integer;
    FColor: TColor;
    FParent: TLjbBmpClock;

    procedure SetRadius(Value: Integer);
    procedure SetBackRadius(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetColor(Value: TColor);
  protected
    procedure UpdateParent;
  public
    constructor Create;
    property Parent: TLjbBmpClock read FParent write FParent;
  published
    property Radius: Integer read FRadius write SetRadius;
    property BackRadius: Integer read FBackRadius write SetBackRadius;
    property Width: Integer read FWidth write SetWidth;
    property Color: TColor read FColor write SetColor;
  end;

  TCenterPoint = class(TPersistent) //建立中心点
  private
    FPointSize: Integer;
    FPenSize: Integer;
    FFillColor: TColor;
    FPenColor: TColor;

    FParent: TLjbBmpClock;

    procedure SetPonitSize(Value: Integer);
    procedure SetPenSize(Value: Integer);
    procedure SetPenColor(Value: TColor);
    procedure SetFillColor(Value: TColor);
  protected
    procedure UpdateParent;
  public
    constructor Create;
    property Parent: TLjbBmpClock read FParent write FParent;
  published
    property PointSize: Integer read FPointSize write SetPonitSize default 4; //中心填充点大小
    property PenSize: Integer read FPenSize write SetPenSize default 1; //中心边缘圆圈大小
    property FillColor: TColor read FFillColor write SetFillColor default clBlack; //填充颜色
    property PenColor: TColor read FPenColor write SetPenColor default clWhite; //边缘颜色
  end;

  TLjbBmpClock = class(TCustomControl)
  private
    FTransParentColor: TColor; //透明的颜色 ;
    FTransparent: Boolean;
    FStepTime: TTimer;
    FInterval: Word;
    FInterActive: Boolean;
    FPicture: TPicture;
    WorkImage, DisImage: TBitmap;

    h, m, s: Word;
    OldHour, OldMinute, OldSecond: Word;

    FHour: THour;
    FMinute: TMinute;
    FSecond: TSecond;
    FOnTimer: TNotifyEvent;

    FVerInfo: string;

    FColorOrBmp: TBgStyle;
    FPictureStyle: TPictureStyle;
    FBgUseColor: TColor;

    FCenterPoint: Boolean;

    FCenter: TCenter;

    FHourHand: THand; //建立指针
    FMinuteHand: THand;
    FSecondHand: THand;

    FDrawCenterPoint: TCenterPoint;
    FAutoCenter: Boolean;
    FCurAngle: Real; //读取当前指针角度

    FThemeStyle: TThemeStyle;
    FRoundX: Integer;
    FRoundY: Integer;
    FoldWidth, FoldHeight: Integer;
    FHourHandEnabled, FMinuteHandEnabled, FSecondHandEnabled: Boolean;
    FHoleRound: Boolean; //中间镂空指针效果；
    FSecJump: Boolean;
    FGMTTime: Shortint;
    FLocalGMT: ShortInt;

    procedure SetPicture(Value: TPicture); //设置位图过程 ;
    procedure SetTransParent(Value: Boolean); //设置透明
    procedure SetTransParentColor(Value: TColor); //设置透明遮罩颜色
    procedure SetInterval(Value: Word); //设置时钟周期
    procedure SetActive(Value: Boolean); //设置计时开始
    procedure VersionMark(Value: string); //版本信息 (唯读属性）
    procedure SetBgColor(Value: TColor); //设置背景颜色
    procedure SetBgStyle(Value: TBgStyle); //启用背景颜色
    procedure SetCenterPoint(Value: Boolean); //设置中心点图像
    procedure SetAutoCenter(Value: Boolean); //设置自动中心
    procedure SetHourHandEnabled(Value: Boolean);
    procedure SetMinuteHandEnabled(Value: Boolean);
    procedure SetSecondHandEnabled(Value: Boolean);
    procedure SetPictureStyle(Value: TPictureStyle); //设置背景拉伸效果
    procedure SetThemeStyle(Value: TThemeStyle);
    procedure SetRoundX(Value: Integer);
    procedure SetRoundY(Value: Integer);
    procedure SetHoleRound(Value: Boolean);
    procedure SetSecJump(Value: Boolean);
    procedure SetGMTTime(Value: ShortInt);
    procedure SetLocalGMT(Value: ShortInt);
  protected
    procedure CmEnabledChanged(var message: TWMNoParams); message CM_ENABLEDCHANGED;
    procedure UpdateClock(Sender: TObject); //事件定义过程;
    procedure DrawHand(Radius, BackRadius, HandWidth: Integer; HandColor: TColor; Angle: Real);

    procedure Drawponit(PointSize, PenSize: Integer; FillColor, PenColor: TColor);

    procedure StyleChanged;

    procedure Loaded; override;
    procedure Paint; override; //重画时钟;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property Picture: TPicture read FPicture write SetPicture; //自定义背景图
    property TransParentColor: TColor read FTransParentColor write SetTransParentColor default clFuchsia; //设置透明颜色
    property TransParent: Boolean read FTransparent write SetTransParent default False;
    property Interval: Word read FInterval write SetInterval default 100; //时钟周期
    property Active: Boolean read FInterActive write SetActive default False; //启用计时
    property OnHour: THour read FHour write FHour;
    property OnMinute: TMinute read FMinute write FMinute;
    property OnSecond: TSecond read FSecond write FSecond;
    property OnTime: TNotifyEvent read FOnTimer write FOnTimer;
    property VersionInfo: string read FVerInfo write VersionMark stored False;
    property BackGroundStyle: TBgStyle read FColorOrBmp write SetBgStyle default bgPicture;
    property BackGroundColor: TColor read FBgUseColor write SetBgColor default clBlack; //设置单颜色背景色
    property CenterPoint: Boolean read FCenterPoint write SetCenterPoint default True;
    property AutoCenter: Boolean read FAutoCenter write SetAutoCenter default True;
    property HourHandEnabled: Boolean read FHourHandEnabled write SetHourHandEnabled default True;
    property MinuteHandEnabled: Boolean read FMinuteHandEnabled write SetMinuteHandEnabled default True;
    property SecondHandEnabled: Boolean read FSecondHandEnabled write SetSecondHandEnabled default True;
    property Center: TCenter read FCenter write FCenter;
    property HourHand: THand read FHourHand write FHourHand;
    property MinuteHand: THand read FMinuteHand write FMinuteHand;
    property SecondHand: THand read FSecondHand write FSecondHand;
    property CenterMark: TCenterPoint read FDrawCenterPoint write FDrawCenterPoint;
    property PictureStyle: TPictureStyle read FPictureStyle write SetPictureStyle default psNone; //背景图样式
    property ThemeStyle: TThemeStyle read FThemeStyle write SetThemeStyle default tsNone;
    property RoundX: Integer read FRoundX write SetRoundX default 25;
    property RoundY: Integer read FRoundY write SetRoundY default 25;
    property RoundHole: Boolean read FHoleRound write SetHoleRound default False;
    property SecJump: Boolean read FSecJump write SetSecJump default False;
    property LocalGMT: ShortInt read FLocalGMT write SetLocalGMT default 0;
    property GMT: ShortInt read FGMTTime write SetGMTTime default 0;

    property Align;
    property Color;
    property Enabled;
    property Hint;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property PopupMenu;
    property ParentShowHint;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

//**********************************开始 TBmpclock *****************************

{$R LjbBmpClock.RES}

function CurGMT: TDateTime;
var
  TimeRec: TSystemTime;
begin
  GetSystemTime(TimeRec);
  Result := SystemTimeToDateTime(TimeRec);
end;

function GetTimeZoneDelta: TDateTime;
var
  TzInfo: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(TzInfo) of
  TIME_ZONE_ID_UNKNOWN:
    Result := TzInfo.Bias / 1440;
  TIME_ZONE_ID_STANDARD:
    Result := (TzInfo.Bias + TzInfo.StandardBias) / 1440;
  TIME_ZONE_ID_DAYLIGHT:
    Result := (TzInfo.Bias + TzInfo.DayLightBias) / 1440;
  else
    RaiseLastWin32Error;
  end;
end;

function CurGmtToLocalHoursOffset: integer;
var
  t1,g2,t3: tDateTime;
begin
  t3 := Now;
  repeat
    t1 := t3;
    g2 := CurGmt;
    t3 := Now;
  until abs(t1-t3) < 1/24/60/4;
    Result := round((t3-g2)*24);
end;

{===================初始化并创建组件====================}

constructor TLjbBmpClock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 100;
  FoldWidth := Width;
  FoldHeight := Height;
  FTransParentColor := clFuchsia;
  FTransparent := False;

  DisImage := TBitmap.Create;
  WorkImage := TBitmap.Create;

  FPicture := TPicture.Create;
  FPicture.Bitmap.LoadFromResourceName(HInstance, 'BMPCLOCK');

  FSteptime := TTimer.Create(self); //建立时钟发生器
  FInterval := 100;
  FInterActive := True;
  FSteptime.Enabled := FInterActive;
  FSteptime.Interval := FInterval;
  FSteptime.OnTimer := UpdateClock;

  FVerInfo := 'LjbBmpClock V3.5';

  FColorOrBmp := bgPicture;
  FAutoCenter := True;
  FHourHandEnabled := True;
  FMinuteHandEnabled := True;
  FSecondHandEnabled := True;

  FPictureStyle := psNone;

  FThemeStyle := tsNone;
  FRoundX := 25;
  FRoundY := 25;

  FHoleRound := False;
  FSecJump := False;
  FGMTTime := 0;
  FCenter := TCenter.Create;
  with FCenter do
  begin
    Parent := Self;
    FX := 50;
    FY := 50;
  end;

  {------画时针------}
  FHourHand := THand.Create;
  with FHourHand do
  begin
    Parent := Self;
    BackRadius := 6;
    Color := clGreen;
    Radius := 25;
    Width := 2;
  end;
  {------画分针------}
  FMinuteHand := THand.Create;
  with FMinuteHand do
  begin
    Parent := Self;
    BackRadius := 6;
    Color := clBlue;
    Radius := 30;
    Width := 2;
  end;
  {------画秒针------}
  FSecondHand := THand.Create;
  with FSecondHand do
  begin
    Parent := Self;
    BackRadius := 11;
    Color := clRed;
    Radius := 38;
    Width := 1;
  end;

  {-----画中心点----}
  FDrawCenterPoint := TCenterPoint.Create;
  with FDrawCenterPoint do
  begin
    Parent := Self;
    PointSize := 4;
    PenSize := 1;
    FillColor := clBlack;
    PenColor := clWhite;
  end;

  FCenterPoint := True;
  FLocalGMT :=CurGmtToLocalHoursOffset;
  FGMTTime :=8;
end;

{======================销毁对像=========================}

destructor TLjbBmpClock.Destroy;
begin
  FStepTime.Free;
  WorkImage.Free;
  DisImage.Free;
  FPicture.Free;
  FHourHand.Free;
  FMinuteHand.Free;
  FSecondHand.Free;
  FDrawCenterPoint.Free;
  FCenter.Free;
  inherited Destroy;
end;

{=================时钟重画,产生时间比较=================}

procedure TLjbBmpClock.UpdateClock(Sender: TObject);
var
  HSec: Word;
begin
  DecodeTime(Time, h, m, s, HSec);
  paint; //  <--------此处必须为 Paint, 不能为 Repaint, 否则组件闪烁得厉害!!!
  if s <> OldSecond then begin //于整秒事件
    if Assigned(FSecond) then FSecond(Self, s);
    OldSecond := s;
  end;
  if m <> OldMinute then begin //于整分事件
    if Assigned(FMinute) then FMinute(Self, m);
    OldMinute := m;
  end;
  if h <> OldHour then begin //于整点事件
    if Assigned(FHour) then FHour(Self, h);
    OldHour := h;
  end;
  if Assigned(FOnTimer) then FOnTimer(Self); //于计时周期事件
end;

procedure TLjbBmpClock.Loaded;
var
  HSec: Word;
begin
  inherited Loaded;
  DecodeTime(Now, OldHour, OldMinute, OldSecond, HSec);
end;

{=================重新定义 GMT 时区时===================}
procedure TLjbBmpClock.SetLocalGMT(Value: ShortInt);
begin
  if Value <> FLocalGMT then begin
    FLocalGMT :=Value;
    Repaint;
  end;
end;

{========在发生定时器事件时重画表盘 (核心代码 II)=======}

procedure TLjbBmpClock.Paint;
var
  H, M, S, MS: word; //从 DecodeTime 函数取得时间;
  R: TRect;
  X, Y, Wi, Hi: LongInt;
  DTGMT: TDateTime;
begin
  if (csDestroying in Componentstate) then Exit;
  DisImage.Assign(FPicture.Graphic);

  WorkImage.Height := Height;
  WorkImage.Width := Width;

  WorkImage.Canvas.Brush.Color := Self.Color;
  WorkImage.Canvas.Brush.Style := bsSolid;
  WorkImage.Canvas.Pen.Color := Self.Color;
  R.Left := 0;
  R.Top := 0;
  R.Right := Width;
  R.Bottom := Height;
  WorkImage.Canvas.Rectangle(0, 0, Width, Height);

  if FColorOrBmp = bgColor then begin //用颜色填充背景作为背景颜色
    WorkImage.Canvas.Brush.Color := FBgUseColor;
    WorkImage.Canvas.Rectangle(0, 0, Width, Height);
  end
  else begin //位图背景
    case FPictureStyle of

      psStretch: //拉伸背景
        begin
          DisImage.Width := Width;
          DisImage.Height := Height;
          DisImage.Canvas.StretchDraw(R, FPicture.Bitmap);
          if FTransparent then begin
            WorkImage.Canvas.BrushCopy(ClientRect, DisImage, ClientRect, FTransParentColor);
          end
          else begin
            WorkImage.Canvas.Draw(0, 0, DisImage);
          end;
        end;

      psNone:
        begin //原来背景
          if FTransparent then //透明背景
            WorkImage.Canvas.BrushCopy(ClientRect, DisImage, ClientRect, FTransParentColor)
          else //非透明背景
            WorkImage.Canvas.Draw(0, 0, DisImage);
        end;

      psTile:
        begin //平铺背景
          DisImage.Width := Width;
          DisImage.Height := Height;
          with FPicture.Bitmap do
          begin
            Wi := Width;
            Hi := Height;
          end;
          Y := 0;
          while Y < Height do
          begin
            X := 0;
            while X < Width do
            begin
              if FTransparent then begin //透明背景
                DisImage.Canvas.Draw(X, Y, FPicture.Bitmap);
                WorkImage.Canvas.BrushCopy(ClientRect, DisImage, ClientRect, FTransParentColor)
              end
              else begin //非透明背景，平铺
                WorkImage.Canvas.Draw(X, Y, DisImage);
              end;
              Inc(X, Wi);
            end; {while X}
            Inc(Y, Hi);
          end; {while Y}
        end; {with}
    end; {case}
  end; {else}

  with WorkImage do
  begin
      {---------取出时针,分针,秒针 的旋转角度--------}
    DTGMT := Now;
    DTGMT := DTGMT + ((FGMTTime - FLocalGMT)/ 24);
    Decodetime(DTGMT, H, M, S, MS);

      {---------画出时针-----------}
    FCurAngle := 2 * pi * (H + M / 60) / 12; //当前应该画出的角度
    if FHourHandEnabled then begin
      DrawHand(HourHand.Radius, HourHand.BackRadius, HourHand.Width, HourHand.Color, FCurAngle);
    end;

      {---------画出分针-----------}
    FCurAngle := 2 * Pi * M / 60;
    if FMinuteHandEnabled then begin
      DrawHand(MinuteHand.Radius, MinuteHand.BackRadius, MinuteHand.Width, MinuteHand.Color, FCurAngle);
    end;

      {---------画出秒针-----------}
    if FSecJump then
      FCurAngle := (2 * Pi * S / 60)
    else
      FCurAngle := (Pi / 3000) * (((S * 1000) + MS) div 10);
    if FSecondHandEnabled then begin
      DrawHand(SecondHand.Radius, SecondHand.BackRadius, SecondHand.Width, SecondHand.Color, FCurAngle);
    end;

      {---------画中心点-----------}
    if FCenterPoint then begin
      Drawponit(CenterMark.FPointSize, CenterMark.FPenSize, CenterMark.FFillColor, CenterMark.FPenColor);
    end;

  end; {with}
  Self.Canvas.Draw(0, 0, WorkImage); //将结果画到前台

  if (FoldWidth <> Width) or (FoldHeight <> Height) then begin //大小改变时，重画形状;
    FoldWidth := Width;
    FoldHeight := Height;
    StyleChanged;
  end;
end;

{===================自定义背景位图======================}

procedure TLjbBmpClock.SetPicture(Value: TPicture);
begin
  if not (Value.Graphic.Empty) then begin
    FPicture.Assign(value);
    Width := FPicture.Width;
    Height := FPicture.Height;
    Repaint;
  end;
end;

{====================设置背景透明=======================}

procedure TLjbBmpClock.SetTransParent(Value: Boolean);
begin
  if Value <> FTransparent then begin
    FTransparent := Value;
    Repaint;
  end;
end;

{====================设置背景透明的颜色=================}

procedure TLjbBmpClock.SetTransParentColor(Value: TColor);
begin
  if Value <> FTransParentColor then begin
    FTransParentColor := Value;
    Repaint;
  end;
end;

{=====================设置时钟计时周期==================}

procedure TLjbBmpClock.SetInterval(Value: Word);
begin
  if Value <> FInterval then begin
    FInterval := Value;
    FStepTime.Interval := FInterval;
    Repaint;
  end;
end;

{======================启动时钟计时=====================}

procedure TLjbBmpClock.SetActive(Value: Boolean);
begin
  if Value <> Active then begin
    FInterActive := Value;
    FStepTime.Enabled := FInterActive;
    Repaint;
  end;
end;

{======================更改启用属性=====================}

procedure TLjbBmpClock.CmEnabledChanged(var message: TWMNoParams);
begin
  inherited;
  FStepTime.Enabled := Self.Enabled;
  FInterActive := Self.Enabled;
  Repaint;
end;

{=======================版本信息（唯读属性）============}

procedure TLjbBmpClock.VersionMark(Value: string);
var
  s: string;
begin
  s := 'LjbBmpClock V3.5 版权所有(C) 2003-2006 小帆工作室';
  if Value <> FVerInfo then begin
    MessageBox(HANDLE, PChar(s),
      '关于 LjbBmpClock V3.5', MB_OK + MB_ICONINFORMATION);
    FVerInfo := s;
  end;
end;

{===================设置自动中心========================}

procedure TLjbBmpClock.SetAutoCenter(Value: Boolean);
begin
  if Value <> FAutoCenter then
  begin
    if Value then
    begin
      with FCenter do
      begin
        X := Width div 2;
        Y := Height div 2;
      end;
    end;
    FAutoCenter := Value;
    Repaint;
  end;
end;

{========================使用纯颜色背景=================}

procedure TLjbBmpClock.SetBgStyle(Value: TBgStyle);
begin
  if Value <> FColorOrBmp then begin
    FColorOrBmp := Value;
    Repaint;
  end;
end;

{=====================设置背景颜色======================}

procedure TLjbBmpClock.SetBgColor(Value: TColor);
begin
  if Value <> FBgUseColor then begin
    FBgUseColor := Value;
    Repaint;
  end;
end;

{======================设置中心点=======================}

procedure TLjbBmpClock.SetCenterPoint(Value: Boolean);
begin
  if Value <> FCenterPoint then begin
    FCenterPoint := Value;
    Repaint;
  end;
end;

{================指针算法 （核心代码 I )================}

procedure TLjbBmpClock.DrawHand(Radius, BackRadius, HandWidth: Integer; HandColor: TColor; Angle: Real);
var
  X, Y, Xh, Yh, Xb, Yb, FXCenter, FYCenter: Integer;
begin
  {---------定义中心-----------}
  if FAutoCenter then begin
    FXCenter := Width div 2;
    FYCenter := Height div 2
  end
  else begin
    FXCenter := FCenter.FX;
    FYCenter := FCenter.FY;
  end;

  with WorkImage.Canvas do begin
    Pen.Width := HandWidth;
    Pen.Color := HandColor;

    Angle := FCurAngle; //取得当前指针角度

    X := Round(FXCenter + Radius * sin(Angle));
    Y := Round(FYCenter - Radius * cos(Angle));

    Xb := Round(FXCenter - BackRadius * sin(Angle));
    Yb := Round(FYCenter + BackRadius * cos(Angle));

    Xh := Round(FXCenter + BackRadius * sin(Angle));
    Yh := Round(FYCenter - BackRadius * cos(Angle));

    if FHoleRound then begin
      MoveTo(Xh, Yh);
      LineTo(X, Y);
    end
    else begin
      MoveTo(Xb, Yb);
      LineTo(X, Y); //画时钟指针;
    end;
  end;
end;

procedure TLjbBmpClock.SetHoleRound(Value: Boolean);
begin
  if Value <> FHoleRound then
  begin
    FHoleRound := Value;
    Repaint;
  end;
end;

{====================画中心点过程=======================}

procedure TLjbBmpClock.DrawPonit(PointSize, PenSize: Integer; FillColor, PenColor: TColor);
var
  FXCenter, FYCenter: Integer;
begin
  if FAutoCenter then begin
    FXCenter := Width div 2;
    FYCenter := Height div 2
  end
  else begin
    FXCenter := FCenter.FX;
    FYCenter := FCenter.FY;
  end;
  with WorkImage.Canvas do begin
    Pen.Width := PenSize;
    Pen.Color := PenColor;
    Brush.Color := FillColor;
    RoundRect((FXCenter) - PointSize, (FYCenter) - PointSize, (FXCenter) + PointSize, (FYCenter) + PointSize, Width, Height);
  end;
end;

{====================是否启用时针=======================}

procedure TLjbBmpClock.SetHourHandEnabled(Value: Boolean);
begin
  if Value <> FHourHandEnabled then begin
    FHourHandEnabled := Value;
    Repaint;
  end;
end;

{=====================是否启用分针======================}

procedure TLjbBmpClock.SetMinuteHandEnabled(Value: Boolean);
begin
  if Value <> FMinuteHandEnabled then begin
    FMinuteHandEnabled := Value;
    Repaint;
  end;
end;

{====================是否启用秒针=======================}

procedure TLjbBmpClock.SetSecondHandEnabled(Value: Boolean);
begin
  if Value <> FSecondHandEnabled then begin
    FSecondHandEnabled := Value;
    Repaint;
  end;
end;

{==================是否启用平滑/跳动秒针=================}

procedure TLjbBmpClock.SetSecJump(Value: Boolean);
begin
  if Value <> FSecJump then begin
    FSecJump := Value;
    Repaint;
  end;
end;

{===================== GMT 时区=========================}

procedure TLjbBmpClock.SetGMTTime(Value: ShortInt);
begin
  if Value <> FGMTTime then begin
    FGMTTime := Value;
    Repaint;
  end;
end;

{====================设置背景图效果=====================}

procedure TLjbBmpClock.SetPictureStyle(Value: TPictureStyle);
begin
  if Value <> FPictureStyle then begin
    FPictureStyle := Value;
    Repaint;
  end;
end;

{====================设置控件外形=======================}

procedure TLjbBmpClock.SetThemeStyle(Value: TThemeStyle);
begin
  if value <> FThemeStyle then
  begin
    FThemeStyle := Value;
    StyleChanged;
  end;
end;

{=================设置圆角 X============================}

procedure TLjbBmpClock.SetRoundX(Value: Integer);
begin
  if Value <> FRoundX then
  begin
    FRoundX := Value;
    StyleChanged;
  end;
end;

{===================设置圆角 Y==========================}

procedure TLjbBmpClock.SetRoundY(Value: Integer);
begin
  if Value <> FRoundY then
  begin
    FRoundY := Value;
    StyleChanged;
  end;
end;

{=================设置形状过程==========================}

procedure TLjbBmpClock.StyleChanged;
var
  HT: THandle;
begin
  HT := CreateRectRgn(0, 0, Width, Height);
  case FThemeStyle of
    tsNone:
      begin
        HT := CreateRectRgn(0, 0, Width, Height);
      end;
    tsCircle:
      begin
        HT := CreateEllipticRgn(0, 0, Width, Height);
      end;
    tsRoundRect:
      begin
        HT := CreateRoundRectRgn(0, 0, Width, Height, FRoundX, FRoundY);
      end;
  end;
  SetWindowRgn(Handle, HT, True);
  Repaint;
end;

//***********************************开始 TCenter*******************************
{=======================构造 中心=======================}

constructor TCenter.Create;
begin
  inherited Create;
  FX := 50;
  FY := 50;
end;

{===================设置中心的 X 坐标===================}

procedure TCenter.SetX(Value: Integer);
begin
  if Value <> FX then
  begin
    FX := Value;
    UpdateParent;
  end;
end;

{===================设置中心的 Y 坐标===================}

procedure TCenter.SetY(Value: Integer);
begin
  if Value <> FY then
  begin
    FY := Value;
    UpdateParent;
  end;
end;

{======================刷新父控件=======================}

procedure TCenter.UpdateParent;
begin
  Parent.Repaint;
end;

//*******************************开始 THand ************************************

{======================建立指针==========================}

constructor THand.Create;
begin
  inherited Create;
end;

{====================更改属性后，刷新父控件==============}

procedure THand.UpdateParent;
begin
  Parent.RePaint;
end;

{===================设置指针正向长度=====================}

procedure THand.SetRadius(Value: integer);
begin
  if Value <> FRadius then
  begin
    FRadius := Value;
    UpdateParent;
  end;
end;

{===================设置指针反向长度=====================}

procedure THand.SetBackRadius(Value: integer);
begin
  if Value <> FBackRadius then
  begin
    FBackRadius := Value;
    UpdateParent;
  end;
end;

{===================设置指针宽度=========================}

procedure THand.SetWidth(Value: integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    UpdateParent;
  end;
end;

{===================设置指针颜色=========================}

procedure THand.SetColor(Value: TColor);
begin
  if Value <> FColor then
  begin
    FColor := Value;
    UpdateParent;
  end;
end;

//*****************************开始 TCenterPoint *******************************
{======================建立中心点========================}

constructor TCenterPoint.Create;
begin
  inherited Create;
  FPointSize := 4;
  FPenSize := 1;
  FFillColor := clBlack;
  FPenColor := clWhite;
end;

{========================中心点大小======================}

procedure TCenterPoint.SetPonitSize(Value: Integer);
begin
  if Value <> FPointSize then
  begin
    FPointSize := Value;
    UpdateParent;
  end;
end;

{=======================边缘圆圈大小=====================}

procedure TCenterPoint.SetPenSize(Value: Integer);
begin
  if Value <> FPenSize then
  begin
    FPenSize := Value;
    UpdateParent;
  end;
end;

{=====================设置边缘圆圈颜色===================}

procedure TCenterPoint.SetPenColor(Value: TColor);
begin
  if Value <> FPenColor then
  begin
    FPenColor := Value;
    UpdateParent;
  end;
end;

{=======================设置填充颜色=====================}

procedure TCenterPoint.SetFillColor(Value: TColor);
begin
  if Value <> FFillColor then
  begin
    FFillColor := Value;
    UpdateParent;
  end;
end;

{==================设置中心属性后刷新父控件==============}

procedure TCenterPoint.UpdateParent;
begin
  Parent.Repaint;
end;

{=====================注册组件===========================}

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbBmpClock]);
end;

end.

