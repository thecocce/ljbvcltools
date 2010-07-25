object Form1: TForm1
  Left = 346
  Top = 360
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 124
  ClientWidth = 200
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 177
    Height = 97
    Caption = #38190#30424
    TabOrder = 0
    object Label3: TLabel
      Left = 24
      Top = 24
      Width = 126
      Height = 12
      Caption = #25353#23383#31526'A'#26469#27979#35797#38190#30424#38057#23376
    end
    object btStartKeyboard: TButton
      Left = 48
      Top = 56
      Width = 73
      Height = 25
      Caption = #24320#22987
      TabOrder = 0
      OnClick = btStartKeyboardClick
    end
  end
  object khook: TKeyboardHook
    OnKeyDown = khookKeyDown
    OnKeyUp = khookKeyUp
    Left = 16
    Top = 64
  end
end
