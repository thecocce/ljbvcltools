object NumBaseConvDlg: TNumBaseConvDlg
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #36827#21046#36716#25442
  ClientHeight = 240
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 36
    Height = 13
    Caption = #36755#20837'(&I)'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 62
    Height = 13
    Caption = #36755#20837#36827#21046'(&B)'
  end
  object Label3: TLabel
    Left = 24
    Top = 99
    Width = 38
    Height = 13
    Caption = #36755#20986'(&E)'
  end
  object Label4: TLabel
    Left = 24
    Top = 131
    Width = 62
    Height = 13
    Caption = #36755#20986#36827#21046'(&T)'
  end
  object Label5: TLabel
    Left = 24
    Top = 163
    Width = 86
    Height = 13
    Caption = #36755#20986#32599#39532#25968#23383'(&T)'
  end
  object Edit1: TEdit
    Left = 123
    Top = 21
    Width = 258
    Height = 21
    TabOrder = 0
    OnChange = Edit2Change
  end
  object Edit2: TEdit
    Left = 123
    Top = 53
    Width = 109
    Height = 21
    TabOrder = 1
    Text = '10'
    OnChange = Edit2Change
    OnKeyPress = Edit4KeyPress
  end
  object Edit3: TEdit
    Left = 123
    Top = 96
    Width = 258
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 123
    Top = 128
    Width = 109
    Height = 21
    TabOrder = 3
    Text = '16'
    OnChange = Edit2Change
    OnKeyPress = Edit4KeyPress
  end
  object Edit5: TEdit
    Left = 123
    Top = 160
    Width = 109
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object Button1: TButton
    Left = 295
    Top = 195
    Width = 85
    Height = 25
    Caption = #20809#38381'(&C)'
    Default = True
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 195
    Width = 97
    Height = 25
    Caption = #31896#36148#32467#26524'(&P)'
    TabOrder = 6
    OnClick = Button2Click
  end
end
