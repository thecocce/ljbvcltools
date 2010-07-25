object Form1: TForm1
  Left = 277
  Top = 120
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 140
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 393
    Height = 105
    Caption = #40736#26631
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 66
      Height = 12
      Caption = '['#31227#21160#20301#32622']:'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 66
      Height = 12
      Caption = '['#28857#20987#20301#32622']:'
    end
    object btStartMouse: TButton
      Left = 8
      Top = 72
      Width = 73
      Height = 25
      Caption = #24320#22987
      TabOrder = 0
      OnClick = btStartMouseClick
    end
  end
  object mhook: TMouseHook
    HookedExeName = 'notepad.exe'
    OnMouseLButtonUp = mhookMouseLButtonUp
    OnMouseMove = mhookMouseMove
    Left = 208
    Top = 48
  end
end
