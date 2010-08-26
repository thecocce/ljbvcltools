object AsciiDlg: TAsciiDlg
  Left = 276
  Top = 128
  Width = 464
  Height = 421
  ActiveControl = AsciiGrid
  BorderStyle = bsSizeToolWin
  Caption = 'ASCII'#21442#29031#34920
  Color = clBtnFace
  Constraints.MaxWidth = 464
  Constraints.MinWidth = 464
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnKeyDown = isKeyKeyDown
  DesignSize = (
    456
    394)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 24
    Height = 13
    Caption = #23383#31526
  end
  object Label2: TLabel
    Left = 77
    Top = 48
    Width = 26
    Height = 13
    Caption = 'Dec#'
  end
  object Label3: TLabel
    Left = 138
    Top = 48
    Width = 27
    Height = 13
    Caption = 'Hex#'
  end
  object Label4: TLabel
    Left = 198
    Top = 48
    Width = 24
    Height = 13
    Caption = #21517#31216
  end
  object Label5: TLabel
    Left = 259
    Top = 48
    Width = 48
    Height = 13
    Caption = #25511#21046#23383#31526
  end
  object Label6: TLabel
    Left = 16
    Top = 16
    Width = 256
    Height = 13
    Caption = #25353#19979#38190#30424#19978#30340#38190#21487#20197#36339#36716#21040#36825#20010#38190#25152#23545#24212#30340'ASCII'
  end
  object isCancal: TButton
    Left = 342
    Top = 360
    Width = 108
    Height = 24
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #20851#38381'(&C)'
    Default = True
    ModalResult = 2
    TabOrder = 3
    OnClick = isCancalClick
  end
  object isFontSetting: TButton
    Left = 342
    Top = 13
    Width = 109
    Height = 24
    Caption = #26356#25913#23383#20307'(&F)...'
    TabOrder = 1
    OnClick = isFontSettingClick
  end
  object AsciiGrid: TStringGrid
    Left = 15
    Top = 64
    Width = 320
    Height = 283
    Anchors = [akLeft, akTop, akBottom]
    DefaultColWidth = 60
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 256
    FixedRows = 0
    GridLineWidth = 0
    Options = [goVertLine, goHorzLine, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = Button1Click
  end
  object Button1: TButton
    Left = 14
    Top = 360
    Width = 97
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = #25554#20837#23383#31526'(&I)'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ishex: TRadioButton
    Left = 128
    Top = 363
    Width = 41
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Hex'
    TabOrder = 4
  end
  object isDec: TRadioButton
    Left = 188
    Top = 363
    Width = 41
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Dec'
    TabOrder = 5
  end
  object isChar: TRadioButton
    Left = 248
    Top = 363
    Width = 41
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #23383#31526
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 48
    Top = 380
  end
end
