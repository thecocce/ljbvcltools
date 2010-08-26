object EncryptionDlg: TEncryptionDlg
  Left = 362
  Top = 116
  BorderStyle = bsToolWindow
  Caption = #25991#20214#21152#23494#35299#23494
  ClientHeight = 304
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 62
    Height = 13
    Caption = #21152#23494#23494#30721'(&P)'
    FocusControl = Edit1
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 62
    Height = 13
    Caption = #21152#23494#26041#24335'(&E)'
    FocusControl = ComboBox1
  end
  object Edit1: TEdit
    Left = 96
    Top = 44
    Width = 297
    Height = 21
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 96
    Top = 72
    Width = 129
    Height = 17
    Caption = #26143#21495#26174#31034#23494#30721'(&M)'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object ComboBox1: TComboBox
    Left = 96
    Top = 12
    Width = 297
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'Advanced Encryption Standard(AES-'#23494#38053'128'#20301')'
    Items.Strings = (
      'Advanced Encryption Standard(AES-'#23494#38053'128'#20301')'
      'Advanced Encryption Standard(AES-'#23494#38053'192'#20301')'
      'Advanced Encryption Standard(AES-'#23494#38053'256'#20301')'
      'Data Encryption Standard(DES)')
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 96
    Width = 377
    Height = 161
    Caption = #26469#28304
    TabOrder = 3
    object Label3: TLabel
      Left = 40
      Top = 88
      Width = 36
      Height = 13
      Caption = #36755#20837'(&I)'
      FocusControl = Edit2
    end
    object Label4: TLabel
      Left = 40
      Top = 120
      Width = 38
      Height = 13
      Caption = #36755#20986'(&X)'
      FocusControl = Edit3
    end
    object RadioButton2: TRadioButton
      Left = 24
      Top = 56
      Width = 113
      Height = 17
      Caption = #22806#37096#25991#20214'(&F)'
      TabOrder = 0
      OnClick = RadioButton2Click
    end
    object RadioButton1: TRadioButton
      Left = 24
      Top = 24
      Width = 137
      Height = 17
      Caption = #24403#21069#32534#36753#25991#26412'(&T)'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RadioButton2Click
    end
    object Panel1: TPanel
      Left = 91
      Top = 85
      Width = 260
      Height = 20
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWindow
      TabOrder = 2
      object Edit2: TEdit
        Left = 0
        Top = 0
        Width = 236
        Height = 17
        AutoSize = False
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 0
      end
      object Button3: TButton
        Left = 235
        Top = 0
        Width = 21
        Height = 16
        Caption = '...'
        Enabled = False
        TabOrder = 1
        OnClick = Button3Click
      end
    end
    object Panel2: TPanel
      Left = 91
      Top = 117
      Width = 260
      Height = 20
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Color = clWindow
      TabOrder = 3
      object Edit3: TEdit
        Left = 0
        Top = 0
        Width = 236
        Height = 17
        AutoSize = False
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 0
      end
      object Button5: TButton
        Left = 235
        Top = 0
        Width = 21
        Height = 16
        Caption = '...'
        Enabled = False
        TabOrder = 1
        OnClick = Button5Click
      end
    end
  end
  object Button1: TButton
    Left = 309
    Top = 269
    Width = 83
    Height = 25
    Caption = #20851#38381'(&C)'
    Default = True
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 269
    Width = 89
    Height = 25
    Caption = #21152#23494'(&N)'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 109
    Top = 269
    Width = 89
    Height = 25
    Caption = #35299#23494'(&D)'
    TabOrder = 6
    OnClick = Button4Click
  end
end
