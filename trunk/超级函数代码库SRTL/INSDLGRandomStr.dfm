object RandomStrDlg: TRandomStrDlg
  Left = 221
  Top = 203
  BorderStyle = bsToolWindow
  Caption = #29983#25104#38543#26426#23383#31526#20018
  ClientHeight = 262
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = CheckBox2Click
  DesignSize = (
    337
    262)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 73
    Height = 13
    Caption = #23383#31526#20018#38271#24230'(&L)'
    FocusControl = Edit1
  end
  object Label1: TLabel
    Left = 16
    Top = 181
    Width = 39
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #32467#26524'(&R)'
    FocusControl = Edit2
  end
  object Edit1: TEdit
    Left = 136
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '9'
    OnChange = Button3Click
    OnKeyPress = Edit1KeyPress
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 48
    Width = 305
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Caption = #21253#21547#23383#31526
    TabOrder = 1
    object CheckBox4: TCheckBox
      Left = 160
      Top = 24
      Width = 97
      Height = 17
      Caption = #31526#21495'(&S)'
      TabOrder = 0
      OnClick = CheckBox2Click
    end
    object CheckBox1: TCheckBox
      Left = 32
      Top = 24
      Width = 97
      Height = 17
      Caption = #23567#20889#23383#27597'(&L)'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox2: TCheckBox
      Left = 32
      Top = 56
      Width = 97
      Height = 17
      Caption = #22823#20889#23383#27597'(&U)'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox2Click
    end
    object CheckBox5: TCheckBox
      Left = 160
      Top = 56
      Width = 97
      Height = 17
      Caption = #20219#20309#23383#31526'(&A)'
      TabOrder = 3
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 32
      Top = 88
      Width = 65
      Height = 17
      Caption = #25968#23383'(&N)'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox2Click
    end
  end
  object Edit2: TEdit
    Left = 16
    Top = 200
    Width = 303
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ReadOnly = True
    TabOrder = 2
  end
  object Button1: TButton
    Left = 237
    Top = 231
    Width = 83
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20851#38381'(&C)'
    Default = True
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 231
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #31896#36148'(&P)'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 100
    Top = 231
    Width = 81
    Height = 25
    Caption = #29983#25104'(&R)'
    TabOrder = 5
    OnClick = Button3Click
  end
end
