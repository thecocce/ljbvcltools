object DatetimeDlg: TDatetimeDlg
  Left = 276
  Top = 116
  BorderStyle = bsToolWindow
  BorderWidth = 10
  Caption = #26085#26399#26102#38388
  ClientHeight = 284
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = UpdateDatetime
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = -1
    Width = 87
    Height = 13
    Caption = #26085#26399#26102#38388#26684#24335'(&D)'
    FocusControl = sfDatetimes
  end
  object Label3: TLabel
    Left = 225
    Top = 19
    Width = 38
    Height = 13
    Caption = #26085#26399'(&E)'
    FocusControl = sfDatePicker
  end
  object Bevel1: TBevel
    Left = 48
    Top = 415
    Width = 361
    Height = 11
    Shape = bsTopLine
  end
  object Label4: TLabel
    Left = 225
    Top = 67
    Width = 38
    Height = 13
    Caption = #26102#38388'(&T)'
    FocusControl = sfTimePicker
  end
  object sfOk: TButton
    Left = 271
    Top = 258
    Width = 100
    Height = 25
    Caption = #20851#38381'(&C)'
    Default = True
    TabOrder = 4
    OnClick = sfOkClick
  end
  object sfCancel: TButton
    Left = 0
    Top = 258
    Width = 100
    Height = 25
    Cancel = True
    Caption = #25554#20837'(&I)'
    TabOrder = 5
    OnClick = sfCancelClick
  end
  object sfUpdate: TButton
    Left = 225
    Top = 120
    Width = 100
    Height = 25
    Caption = #21047#26032'(&U)'
    TabOrder = 3
    OnClick = UpdateDatetime
  end
  object sfDatePicker: TDateTimePicker
    Left = 224
    Top = 39
    Width = 145
    Height = 21
    CalAlignment = dtaLeft
    Date = 38140.6427468634
    Time = 38140.6427468634
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
    OnChange = UpdateDatetime
  end
  object sfTimePicker: TDateTimePicker
    Left = 224
    Top = 87
    Width = 145
    Height = 21
    CalAlignment = dtaLeft
    Date = 38140.6427468634
    Format = 'hh'#26102'mm'#20998'ss'#31186
    Time = 38140.6427468634
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 1
    OnChange = UpdateDatetime
  end
  object sfDatetimes: TListBox
    Left = 0
    Top = 21
    Width = 217
    Height = 228
    Style = lbOwnerDrawVariable
    ItemHeight = 18
    TabOrder = 2
    OnClick = sfDatetimesClick
    OnDblClick = sfCancelClick
    OnDrawItem = sfDatetimesDrawItem
  end
  object CheckBox1: TCheckBox
    Left = 104
    Top = 264
    Width = 97
    Height = 17
    Caption = #20840#35282#23383#31526'(&W)'
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 224
    Top = 174
    Width = 113
    Height = 17
    Caption = #20026#40664#35748#30340#26684#24335'(&D)'
    TabOrder = 7
    OnClick = CheckBox2Click
  end
end
