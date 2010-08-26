object WrapDlg: TWrapDlg
  Left = 300
  Top = 142
  BorderStyle = bsToolWindow
  BorderWidth = 5
  Caption = #27573#33853#37325#25490
  ClientHeight = 382
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormCreate
  DesignSize = (
    454
    382)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 152
    Width = 330
    Height = 105
    Caption = #39029#36793#36317'('#21333#20301':'#23383#33410')'
    TabOrder = 2
    object Label5: TLabel
      Left = 32
      Top = 32
      Width = 73
      Height = 13
      Caption = #20351#29992#24038#36793#36317'(&L)'
      FocusControl = cLeftSpace
    end
    object Label6: TLabel
      Left = 32
      Top = 64
      Width = 155
      Height = 13
      Caption = #39029#38754#23485'('#22312#39029#38754#23485#22788#20250#25442#34892')(&R)'
      FocusControl = cPageWidth
    end
    object cLeftSpace: TEdit
      Left = 216
      Top = 28
      Width = 81
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = cLeftSpaceChange
      OnKeyPress = cLeftSpaceKeyPress
    end
    object cPageWidth: TEdit
      Left = 216
      Top = 64
      Width = 81
      Height = 21
      TabOrder = 1
      Text = '80'
      OnChange = cPageWidthChange
      OnKeyPress = cLeftSpaceKeyPress
    end
  end
  object Button2: TButton
    Left = 348
    Top = 343
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20851#38381'(&C)'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 40
    Width = 330
    Height = 105
    Caption = #32553#36827'('#21333#20301':'#23383#33410')'
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 32
      Width = 87
      Height = 13
      Caption = #20351#29992#24748#25346#32553#36827'(&H)'
      FocusControl = cHanging
    end
    object Label4: TLabel
      Left = 32
      Top = 64
      Width = 86
      Height = 13
      Caption = #20351#29992#39318#34892#32553#36827'(&P)'
      FocusControl = cFirstLine
    end
    object cHanging: TEdit
      Left = 224
      Top = 28
      Width = 81
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = cHangingChange
      OnKeyPress = cLeftSpaceKeyPress
    end
    object cFirstLine: TEdit
      Left = 224
      Top = 64
      Width = 81
      Height = 21
      TabOrder = 1
      Text = '4'
      OnChange = cFirstLineChange
      OnKeyPress = cLeftSpaceKeyPress
    end
  end
  object cReorder: TCheckBox
    Left = 8
    Top = 8
    Width = 153
    Height = 17
    Caption = #21024#38500#21407#26377#27573#33853#26684#24335'(&D)'
    TabOrder = 0
    OnClick = cReorderClick
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 264
    Width = 330
    Height = 105
    Caption = #25442#34892#23383#31526#20018
    TabOrder = 3
    object Label2: TLabel
      Left = 32
      Top = 32
      Width = 74
      Height = 13
      Caption = #25442#34892#23383#31526#20018'(&S)'
      FocusControl = cBreak
    end
    object Label3: TLabel
      Left = 32
      Top = 64
      Width = 63
      Height = 13
      Caption = #25442#34892#20301#32622'(&A)'
      FocusControl = cBreakMode
    end
    object cBreakMode: TComboBox
      Left = 137
      Top = 64
      Width = 160
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = #23383#31526#20018#20043#21069
      OnChange = cBreakModeChange
      Items.Strings = (
        #23383#31526#20018#20043#21069
        #23383#31526#20018#20043#21518)
    end
    object cBreak: TEdit
      Left = 136
      Top = 27
      Width = 161
      Height = 21
      TabOrder = 1
      OnChange = cBreakChange
    end
  end
  object Button3: TButton
    Left = 348
    Top = 8
    Width = 105
    Height = 25
    Caption = #27573#33853#37325#25490'(&F)'
    TabOrder = 5
    OnClick = Button3Click
  end
end
