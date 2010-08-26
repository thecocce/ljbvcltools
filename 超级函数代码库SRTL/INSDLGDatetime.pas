{------------------------------------------------------------------------------}
{                                                                              }
{   单元: INSDLGDatetime.pas                                                   }
{                                                                              }
{         属于程序扩展包, 来源于 InsertDateTimes 版本 1.00                     }
{                                                                              }
{   说明: 一个可以做公用的插入时间对话框                                       }
{                                                                              }
{   作者: 姚乔锋                                                               }
{                                                                              }
{------------------------------------------------------------------------------}


unit INSDLGDatetime;


interface


uses Windows, Messages, SysUtils, Forms, Controls,  Classes, Graphics, Dialogs,

  StdCtrls, Variants,  Buttons, Calendar, ComCtrls,  ExtCtrls, StrFuncs,

  CustomDialogs;


type

  TDatetimeDlg = class(TInsertTextDialog)

    Label3: TLabel;

    Bevel1: TBevel;

    Label4: TLabel;

    Label1: TLabel;

    sfUpdate: TButton;

    sfOk: TButton;

    sfCancel: TButton;

    sfDatePicker: TDateTimePicker;

    sfTimePicker: TDateTimePicker;

    sfDatetimes: TListBox;

    CheckBox1: TCheckBox;

    CheckBox2: TCheckBox;

    procedure UpdateDatetime(Sender: TObject);

    procedure sfDatetimesDblClick(Sender: TObject);

    procedure sfDatetimesDrawItem(Control: TWinControl; Index: Integer;

      Rect: TRect; State: TOwnerDrawState);

    procedure sfDatetimesClick(Sender: TObject);

    procedure CheckBox2Click(Sender: TObject);
    
    procedure sfCancelClick(Sender: TObject);

    procedure sfOkClick(Sender: TObject);

  end;

  //插入默认格式的星期

  function GetDefaultWeek : string;

  //插入默认格式的时间

  function GetDefaultTime : string;

  //插入默认格式的日期

  function GetDefaultDate : string;


var

  DefTimeFormat,

  DefDateFormat,

  DefWeekFormat : Integer;

implementation

{$R *.dfm}

function GetDefaultWeek : string;

begin

  IF DefWeekFormat <= 0 then

    DefWeekFormat := 1;

  result := FormatWeek(now, DefWeekFormat);

end;

function GetDefaultTime : string;

begin

  IF DeftimeFormat <= 0 then

    DeftimeFormat := 4;

  result := Formattime(now, DeftimeFormat);

end;

function GetDefaultDate : string;

begin

  IF DefDateFormat <= 0 then

    DefDateFormat := 2;

  result := FormatDate(now, DefDateFormat);

end;

procedure TDatetimeDlg.UpdateDatetime(Sender: TObject);

var nows : TDatetime;

begin

  sfTimePicker.Date := sfDatePicker.Date;

  if (sender = sfTimePicker) or (sender = sfDatePicker) then

    nows := sfTimePicker.DateTime

  else nows := now;

  sfDatetimes.Clear;

  sfDatetimes.Items.AddObject('星期格式', self);

  sfDatetimes.Items.Add(FormatWeek(nows, 1));

  sfDatetimes.Items.Add(FormatWeek(nows, 2));

  sfDatetimes.Items.Add(FormatWeek(nows, 3));

  sfDatetimes.Items.Add(FormatWeek(nows, 4));

  sfDatetimes.Items.AddObject('时间格式', self);

  sfDatetimes.Items.Add(FormatTime(nows, 1));

  sfDatetimes.Items.Add(FormatTime(nows, 2));

  sfDatetimes.Items.Add(FormatTime(nows, 3));

  sfDatetimes.Items.Add(FormatTime(nows, 4));

  sfDatetimes.Items.Add(FormatTime(nows, 5));

  sfDatetimes.Items.AddObject('日期格式', self);

  sfDatetimes.Items.Add(FormatDate(nows, 1));

  sfDatetimes.Items.Add(FormatDate(nows, 2));

  sfDatetimes.Items.Add(FormatDate(nows, 3));

  sfDatetimes.Items.Add(FormatDate(nows, 4));

  sfDatetimes.Items.Add(FormatDate(nows, 5));

  sfDatetimes.Items.Add(FormatDate(nows, 6));

end;

procedure TDatetimeDlg.sfDatetimesDblClick(Sender: TObject);

begin

  ModalResult := mrok;

end;

procedure TDatetimeDlg.sfDatetimesDrawItem(Control: TWinControl;

  Index: Integer; Rect: TRect; State: TOwnerDrawState);

var Flags: Longint;

begin

  if Index < sfDatetimes.Count then

    with sfDatetimes do

    begin

      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);

      If Items.Objects[index] = self then

      begin

        Canvas.Brush.Color := clBtnFace;

        Canvas.Font.Color :=  clwindowText;//clBtnHighlight;

        Flags := Flags or DT_CENTER;

      end;

      canvas.FillRect(rect);

      if not UseRightToLeftAlignment then

        Inc(Rect.Left, 2) else

        Dec(Rect.Right, 2);

      DrawText(Canvas.Handle, PChar(Items[Index]), Length(Items[Index]), Rect, Flags);

    end;

end;

procedure TDatetimeDlg.sfDatetimesClick(Sender: TObject);

begin

  with sfDatetimes do

  begin

    if (itemindex in [0..count-1]) and (Items.Objects[itemindex] = self) then

      itemindex := ItemIndex + 1;

    If Itemindex in [1..4] then

      CheckBox2.Checked := itemindex = DefWeekFormat

    else IF Itemindex in [6..10] then

      CheckBox2.Checked := itemindex = DefTimeFormat + 5

    else If Itemindex in [12..17] then

      CheckBox2.Checked := itemindex = DefDateFormat + 11;

  end;

end;

procedure TDatetimeDlg.CheckBox2Click(Sender: TObject);

begin

  IF checkbox2.Checked then

  begin

    If sfDatetimes.Itemindex in [1..4] then

      DefWeekFormat := sfDatetimes.itemindex

    else If sfDatetimes.Itemindex in [6..10] then

      DefTimeFormat := sfDatetimes.itemindex - 5

    else If sfDatetimes.Itemindex in [12..17] then

      DefDateFormat := sfDatetimes.itemindex - 11;

  end

  else begin

    If DefWeekFormat = sfDatetimes.itemindex then

      DefWeekFormat := 1

    else If DefTimeFormat = sfDatetimes.itemindex -5 then

      DefTimeFormat := 4

    else If DefTimeFormat = sfDatetimes.itemindex -11 then

      DefDateFormat := 2;

  end;

end;


procedure TDatetimeDlg.sfCancelClick(Sender: TObject);

var

  S : string;

begin

  s := sfDateTimes.items[sfDateTimes.itemindex];

  if checkbox1.Checked then

     s := SBCCase(S);

  DoInsertText(S);

end;

procedure TDatetimeDlg.sfOkClick(Sender: TObject);

begin

  close;
  
end;

initialization

  DefTimeFormat := 4;

  DefDateFormat := 2;

  DefWeekFormat := 1;

end.

