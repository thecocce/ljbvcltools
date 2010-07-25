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
      //     �����������ñ���ĳ���,���򳤶�,�Զ���λͼ����,       //
      //  ͸��λͼ,��ʹ�ú�̨˫����������˸��������Դռ�á�        //
      //                                                           //
      //                         E-MAIL :  sail2000@126.com        //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //    �ص�Ľ���ʱ�ӵı�����㷨; ���������˶���������û�   //
      //    �Զ���Ĺ��ܣ�����Ҫ�����Զ��嶼�����û�,����ʹ��;     //
      //                                                           //
      //      ������ɡ�С�������ҡ�����Ȩ���У�����ȫ��Ȩ����     //
      //                                                           //
      //         �����Դ˴�����иĽ�,������ GNU GPL ��Լ������  //
      //     ���� GNU GPL ��Լ�ı�����                             //
      //     �뱣��ԭ���ߵ�һ����Ϣ��ͬʱ���벻Ҫ���Ǹ���Ҳ��      //
      //     һ�����޸ĺ��Դ����!                                 //
      //                                                           //
      //  ** ������ҵ�����д�˸��õ�������벻��Ҳ����һ��Ŷ��**  //
      //                                                           //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //                      ��  Ҫ  ��  ��                       //
      //      �����������ȫ��Դ���룬��ʾ�����Լ������ظ���   //
      //   ��������δ�����ߵ���ʽ������ɺ���Ȩ������������ҵ���ϡ�//
      //   ����Υ������ȨЭ�飬�����ܵ��������ߣ��������ν���Υ��  //
      //   ����ȨЭ���һ���е�ȫ���������Ρ�                      //
      //                                            С��           //
      //                                         2006.01.01        //
      //                                                           //
      ///////////////////////////////////////////////////////////////
      //                                                           //
      //                   Դ����ͳ�ƽ�����                      //
      //  �ļ�����LjbBmpClock.pas                                     //
      //  ���ֽ�����29,710                                         //
      //  �����ֽ�����17,453                                       //
      //  ע���ֽ�����7,433                                        //
      //  ��������1029                                             //
      //  ��Ч������874                                            //
      //  ��������155                                              //
      //  ����������762                                            //
      //  ע��������170                                            //
      //  ע�Ϳ�����170                                            //
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

  TLjbBmpClock = class; //����  TLjbBmpClock

  TCenter = class(TPersistent) //�����ӱ�ָ��
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

  THand = class(TPersistent) //�����ӱ�ָ��
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

  TCenterPoint = class(TPersistent) //�������ĵ�
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
    property PointSize: Integer read FPointSize write SetPonitSize default 4; //���������С
    property PenSize: Integer read FPenSize write SetPenSize default 1; //���ı�ԵԲȦ��С
    property FillColor: TColor read FFillColor write SetFillColor default clBlack; //�����ɫ
    property PenColor: TColor read FPenColor write SetPenColor default clWhite; //��Ե��ɫ
  end;

  TLjbBmpClock = class(TCustomControl)
  private
    FTransParentColor: TColor; //͸������ɫ ;
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

    FHourHand: THand; //����ָ��
    FMinuteHand: THand;
    FSecondHand: THand;

    FDrawCenterPoint: TCenterPoint;
    FAutoCenter: Boolean;
    FCurAngle: Real; //��ȡ��ǰָ��Ƕ�

    FThemeStyle: TThemeStyle;
    FRoundX: Integer;
    FRoundY: Integer;
    FoldWidth, FoldHeight: Integer;
    FHourHandEnabled, FMinuteHandEnabled, FSecondHandEnabled: Boolean;
    FHoleRound: Boolean; //�м��ο�ָ��Ч����
    FSecJump: Boolean;
    FGMTTime: Shortint;
    FLocalGMT: ShortInt;

    procedure SetPicture(Value: TPicture); //����λͼ���� ;
    procedure SetTransParent(Value: Boolean); //����͸��
    procedure SetTransParentColor(Value: TColor); //����͸��������ɫ
    procedure SetInterval(Value: Word); //����ʱ������
    procedure SetActive(Value: Boolean); //���ü�ʱ��ʼ
    procedure VersionMark(Value: string); //�汾��Ϣ (Ψ�����ԣ�
    procedure SetBgColor(Value: TColor); //���ñ�����ɫ
    procedure SetBgStyle(Value: TBgStyle); //���ñ�����ɫ
    procedure SetCenterPoint(Value: Boolean); //�������ĵ�ͼ��
    procedure SetAutoCenter(Value: Boolean); //�����Զ�����
    procedure SetHourHandEnabled(Value: Boolean);
    procedure SetMinuteHandEnabled(Value: Boolean);
    procedure SetSecondHandEnabled(Value: Boolean);
    procedure SetPictureStyle(Value: TPictureStyle); //���ñ�������Ч��
    procedure SetThemeStyle(Value: TThemeStyle);
    procedure SetRoundX(Value: Integer);
    procedure SetRoundY(Value: Integer);
    procedure SetHoleRound(Value: Boolean);
    procedure SetSecJump(Value: Boolean);
    procedure SetGMTTime(Value: ShortInt);
    procedure SetLocalGMT(Value: ShortInt);
  protected
    procedure CmEnabledChanged(var message: TWMNoParams); message CM_ENABLEDCHANGED;
    procedure UpdateClock(Sender: TObject); //�¼��������;
    procedure DrawHand(Radius, BackRadius, HandWidth: Integer; HandColor: TColor; Angle: Real);

    procedure Drawponit(PointSize, PenSize: Integer; FillColor, PenColor: TColor);

    procedure StyleChanged;

    procedure Loaded; override;
    procedure Paint; override; //�ػ�ʱ��;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property Picture: TPicture read FPicture write SetPicture; //�Զ��屳��ͼ
    property TransParentColor: TColor read FTransParentColor write SetTransParentColor default clFuchsia; //����͸����ɫ
    property TransParent: Boolean read FTransparent write SetTransParent default False;
    property Interval: Word read FInterval write SetInterval default 100; //ʱ������
    property Active: Boolean read FInterActive write SetActive default False; //���ü�ʱ
    property OnHour: THour read FHour write FHour;
    property OnMinute: TMinute read FMinute write FMinute;
    property OnSecond: TSecond read FSecond write FSecond;
    property OnTime: TNotifyEvent read FOnTimer write FOnTimer;
    property VersionInfo: string read FVerInfo write VersionMark stored False;
    property BackGroundStyle: TBgStyle read FColorOrBmp write SetBgStyle default bgPicture;
    property BackGroundColor: TColor read FBgUseColor write SetBgColor default clBlack; //���õ���ɫ����ɫ
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
    property PictureStyle: TPictureStyle read FPictureStyle write SetPictureStyle default psNone; //����ͼ��ʽ
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

//**********************************��ʼ TBmpclock *****************************

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

{===================��ʼ�����������====================}

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

  FSteptime := TTimer.Create(self); //����ʱ�ӷ�����
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

  {------��ʱ��------}
  FHourHand := THand.Create;
  with FHourHand do
  begin
    Parent := Self;
    BackRadius := 6;
    Color := clGreen;
    Radius := 25;
    Width := 2;
  end;
  {------������------}
  FMinuteHand := THand.Create;
  with FMinuteHand do
  begin
    Parent := Self;
    BackRadius := 6;
    Color := clBlue;
    Radius := 30;
    Width := 2;
  end;
  {------������------}
  FSecondHand := THand.Create;
  with FSecondHand do
  begin
    Parent := Self;
    BackRadius := 11;
    Color := clRed;
    Radius := 38;
    Width := 1;
  end;

  {-----�����ĵ�----}
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

{======================���ٶ���=========================}

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

{=================ʱ���ػ�,����ʱ��Ƚ�=================}

procedure TLjbBmpClock.UpdateClock(Sender: TObject);
var
  HSec: Word;
begin
  DecodeTime(Time, h, m, s, HSec);
  paint; //  <--------�˴�����Ϊ Paint, ����Ϊ Repaint, ���������˸������!!!
  if s <> OldSecond then begin //�������¼�
    if Assigned(FSecond) then FSecond(Self, s);
    OldSecond := s;
  end;
  if m <> OldMinute then begin //�������¼�
    if Assigned(FMinute) then FMinute(Self, m);
    OldMinute := m;
  end;
  if h <> OldHour then begin //�������¼�
    if Assigned(FHour) then FHour(Self, h);
    OldHour := h;
  end;
  if Assigned(FOnTimer) then FOnTimer(Self); //�ڼ�ʱ�����¼�
end;

procedure TLjbBmpClock.Loaded;
var
  HSec: Word;
begin
  inherited Loaded;
  DecodeTime(Now, OldHour, OldMinute, OldSecond, HSec);
end;

{=================���¶��� GMT ʱ��ʱ===================}
procedure TLjbBmpClock.SetLocalGMT(Value: ShortInt);
begin
  if Value <> FLocalGMT then begin
    FLocalGMT :=Value;
    Repaint;
  end;
end;

{========�ڷ�����ʱ���¼�ʱ�ػ����� (���Ĵ��� II)=======}

procedure TLjbBmpClock.Paint;
var
  H, M, S, MS: word; //�� DecodeTime ����ȡ��ʱ��;
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

  if FColorOrBmp = bgColor then begin //����ɫ��䱳����Ϊ������ɫ
    WorkImage.Canvas.Brush.Color := FBgUseColor;
    WorkImage.Canvas.Rectangle(0, 0, Width, Height);
  end
  else begin //λͼ����
    case FPictureStyle of

      psStretch: //���챳��
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
        begin //ԭ������
          if FTransparent then //͸������
            WorkImage.Canvas.BrushCopy(ClientRect, DisImage, ClientRect, FTransParentColor)
          else //��͸������
            WorkImage.Canvas.Draw(0, 0, DisImage);
        end;

      psTile:
        begin //ƽ�̱���
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
              if FTransparent then begin //͸������
                DisImage.Canvas.Draw(X, Y, FPicture.Bitmap);
                WorkImage.Canvas.BrushCopy(ClientRect, DisImage, ClientRect, FTransParentColor)
              end
              else begin //��͸��������ƽ��
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
      {---------ȡ��ʱ��,����,���� ����ת�Ƕ�--------}
    DTGMT := Now;
    DTGMT := DTGMT + ((FGMTTime - FLocalGMT)/ 24);
    Decodetime(DTGMT, H, M, S, MS);

      {---------����ʱ��-----------}
    FCurAngle := 2 * pi * (H + M / 60) / 12; //��ǰӦ�û����ĽǶ�
    if FHourHandEnabled then begin
      DrawHand(HourHand.Radius, HourHand.BackRadius, HourHand.Width, HourHand.Color, FCurAngle);
    end;

      {---------��������-----------}
    FCurAngle := 2 * Pi * M / 60;
    if FMinuteHandEnabled then begin
      DrawHand(MinuteHand.Radius, MinuteHand.BackRadius, MinuteHand.Width, MinuteHand.Color, FCurAngle);
    end;

      {---------��������-----------}
    if FSecJump then
      FCurAngle := (2 * Pi * S / 60)
    else
      FCurAngle := (Pi / 3000) * (((S * 1000) + MS) div 10);
    if FSecondHandEnabled then begin
      DrawHand(SecondHand.Radius, SecondHand.BackRadius, SecondHand.Width, SecondHand.Color, FCurAngle);
    end;

      {---------�����ĵ�-----------}
    if FCenterPoint then begin
      Drawponit(CenterMark.FPointSize, CenterMark.FPenSize, CenterMark.FFillColor, CenterMark.FPenColor);
    end;

  end; {with}
  Self.Canvas.Draw(0, 0, WorkImage); //���������ǰ̨

  if (FoldWidth <> Width) or (FoldHeight <> Height) then begin //��С�ı�ʱ���ػ���״;
    FoldWidth := Width;
    FoldHeight := Height;
    StyleChanged;
  end;
end;

{===================�Զ��屳��λͼ======================}

procedure TLjbBmpClock.SetPicture(Value: TPicture);
begin
  if not (Value.Graphic.Empty) then begin
    FPicture.Assign(value);
    Width := FPicture.Width;
    Height := FPicture.Height;
    Repaint;
  end;
end;

{====================���ñ���͸��=======================}

procedure TLjbBmpClock.SetTransParent(Value: Boolean);
begin
  if Value <> FTransparent then begin
    FTransparent := Value;
    Repaint;
  end;
end;

{====================���ñ���͸������ɫ=================}

procedure TLjbBmpClock.SetTransParentColor(Value: TColor);
begin
  if Value <> FTransParentColor then begin
    FTransParentColor := Value;
    Repaint;
  end;
end;

{=====================����ʱ�Ӽ�ʱ����==================}

procedure TLjbBmpClock.SetInterval(Value: Word);
begin
  if Value <> FInterval then begin
    FInterval := Value;
    FStepTime.Interval := FInterval;
    Repaint;
  end;
end;

{======================����ʱ�Ӽ�ʱ=====================}

procedure TLjbBmpClock.SetActive(Value: Boolean);
begin
  if Value <> Active then begin
    FInterActive := Value;
    FStepTime.Enabled := FInterActive;
    Repaint;
  end;
end;

{======================������������=====================}

procedure TLjbBmpClock.CmEnabledChanged(var message: TWMNoParams);
begin
  inherited;
  FStepTime.Enabled := Self.Enabled;
  FInterActive := Self.Enabled;
  Repaint;
end;

{=======================�汾��Ϣ��Ψ�����ԣ�============}

procedure TLjbBmpClock.VersionMark(Value: string);
var
  s: string;
begin
  s := 'LjbBmpClock V3.5 ��Ȩ����(C) 2003-2006 С��������';
  if Value <> FVerInfo then begin
    MessageBox(HANDLE, PChar(s),
      '���� LjbBmpClock V3.5', MB_OK + MB_ICONINFORMATION);
    FVerInfo := s;
  end;
end;

{===================�����Զ�����========================}

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

{========================ʹ�ô���ɫ����=================}

procedure TLjbBmpClock.SetBgStyle(Value: TBgStyle);
begin
  if Value <> FColorOrBmp then begin
    FColorOrBmp := Value;
    Repaint;
  end;
end;

{=====================���ñ�����ɫ======================}

procedure TLjbBmpClock.SetBgColor(Value: TColor);
begin
  if Value <> FBgUseColor then begin
    FBgUseColor := Value;
    Repaint;
  end;
end;

{======================�������ĵ�=======================}

procedure TLjbBmpClock.SetCenterPoint(Value: Boolean);
begin
  if Value <> FCenterPoint then begin
    FCenterPoint := Value;
    Repaint;
  end;
end;

{================ָ���㷨 �����Ĵ��� I )================}

procedure TLjbBmpClock.DrawHand(Radius, BackRadius, HandWidth: Integer; HandColor: TColor; Angle: Real);
var
  X, Y, Xh, Yh, Xb, Yb, FXCenter, FYCenter: Integer;
begin
  {---------��������-----------}
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

    Angle := FCurAngle; //ȡ�õ�ǰָ��Ƕ�

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
      LineTo(X, Y); //��ʱ��ָ��;
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

{====================�����ĵ����=======================}

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

{====================�Ƿ�����ʱ��=======================}

procedure TLjbBmpClock.SetHourHandEnabled(Value: Boolean);
begin
  if Value <> FHourHandEnabled then begin
    FHourHandEnabled := Value;
    Repaint;
  end;
end;

{=====================�Ƿ����÷���======================}

procedure TLjbBmpClock.SetMinuteHandEnabled(Value: Boolean);
begin
  if Value <> FMinuteHandEnabled then begin
    FMinuteHandEnabled := Value;
    Repaint;
  end;
end;

{====================�Ƿ���������=======================}

procedure TLjbBmpClock.SetSecondHandEnabled(Value: Boolean);
begin
  if Value <> FSecondHandEnabled then begin
    FSecondHandEnabled := Value;
    Repaint;
  end;
end;

{==================�Ƿ�����ƽ��/��������=================}

procedure TLjbBmpClock.SetSecJump(Value: Boolean);
begin
  if Value <> FSecJump then begin
    FSecJump := Value;
    Repaint;
  end;
end;

{===================== GMT ʱ��=========================}

procedure TLjbBmpClock.SetGMTTime(Value: ShortInt);
begin
  if Value <> FGMTTime then begin
    FGMTTime := Value;
    Repaint;
  end;
end;

{====================���ñ���ͼЧ��=====================}

procedure TLjbBmpClock.SetPictureStyle(Value: TPictureStyle);
begin
  if Value <> FPictureStyle then begin
    FPictureStyle := Value;
    Repaint;
  end;
end;

{====================���ÿؼ�����=======================}

procedure TLjbBmpClock.SetThemeStyle(Value: TThemeStyle);
begin
  if value <> FThemeStyle then
  begin
    FThemeStyle := Value;
    StyleChanged;
  end;
end;

{=================����Բ�� X============================}

procedure TLjbBmpClock.SetRoundX(Value: Integer);
begin
  if Value <> FRoundX then
  begin
    FRoundX := Value;
    StyleChanged;
  end;
end;

{===================����Բ�� Y==========================}

procedure TLjbBmpClock.SetRoundY(Value: Integer);
begin
  if Value <> FRoundY then
  begin
    FRoundY := Value;
    StyleChanged;
  end;
end;

{=================������״����==========================}

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

//***********************************��ʼ TCenter*******************************
{=======================���� ����=======================}

constructor TCenter.Create;
begin
  inherited Create;
  FX := 50;
  FY := 50;
end;

{===================�������ĵ� X ����===================}

procedure TCenter.SetX(Value: Integer);
begin
  if Value <> FX then
  begin
    FX := Value;
    UpdateParent;
  end;
end;

{===================�������ĵ� Y ����===================}

procedure TCenter.SetY(Value: Integer);
begin
  if Value <> FY then
  begin
    FY := Value;
    UpdateParent;
  end;
end;

{======================ˢ�¸��ؼ�=======================}

procedure TCenter.UpdateParent;
begin
  Parent.Repaint;
end;

//*******************************��ʼ THand ************************************

{======================����ָ��==========================}

constructor THand.Create;
begin
  inherited Create;
end;

{====================�������Ժ�ˢ�¸��ؼ�==============}

procedure THand.UpdateParent;
begin
  Parent.RePaint;
end;

{===================����ָ�����򳤶�=====================}

procedure THand.SetRadius(Value: integer);
begin
  if Value <> FRadius then
  begin
    FRadius := Value;
    UpdateParent;
  end;
end;

{===================����ָ�뷴�򳤶�=====================}

procedure THand.SetBackRadius(Value: integer);
begin
  if Value <> FBackRadius then
  begin
    FBackRadius := Value;
    UpdateParent;
  end;
end;

{===================����ָ����=========================}

procedure THand.SetWidth(Value: integer);
begin
  if Value <> FWidth then
  begin
    FWidth := Value;
    UpdateParent;
  end;
end;

{===================����ָ����ɫ=========================}

procedure THand.SetColor(Value: TColor);
begin
  if Value <> FColor then
  begin
    FColor := Value;
    UpdateParent;
  end;
end;

//*****************************��ʼ TCenterPoint *******************************
{======================�������ĵ�========================}

constructor TCenterPoint.Create;
begin
  inherited Create;
  FPointSize := 4;
  FPenSize := 1;
  FFillColor := clBlack;
  FPenColor := clWhite;
end;

{========================���ĵ��С======================}

procedure TCenterPoint.SetPonitSize(Value: Integer);
begin
  if Value <> FPointSize then
  begin
    FPointSize := Value;
    UpdateParent;
  end;
end;

{=======================��ԵԲȦ��С=====================}

procedure TCenterPoint.SetPenSize(Value: Integer);
begin
  if Value <> FPenSize then
  begin
    FPenSize := Value;
    UpdateParent;
  end;
end;

{=====================���ñ�ԵԲȦ��ɫ===================}

procedure TCenterPoint.SetPenColor(Value: TColor);
begin
  if Value <> FPenColor then
  begin
    FPenColor := Value;
    UpdateParent;
  end;
end;

{=======================���������ɫ=====================}

procedure TCenterPoint.SetFillColor(Value: TColor);
begin
  if Value <> FFillColor then
  begin
    FFillColor := Value;
    UpdateParent;
  end;
end;

{==================�����������Ժ�ˢ�¸��ؼ�==============}

procedure TCenterPoint.UpdateParent;
begin
  Parent.Repaint;
end;

{=====================ע�����===========================}

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbBmpClock]);
end;

end.

