object ExpressionDlg: TExpressionDlg
  Left = 256
  Top = 142
  BorderStyle = bsToolWindow
  Caption = #34920#36798#24335#27714#20540
  ClientHeight = 169
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Caption = #34920#36798#24335'(&E)'
    FocusControl = Edit1
  end
  object Label2: TLabel
    Left = 16
    Top = 80
    Width = 39
    Height = 13
    Caption = #32467#26524'(&R)'
    FocusControl = Edit2
  end
  object Edit1: TEdit
    Left = 16
    Top = 36
    Width = 401
    Height = 21
    TabOrder = 0
    OnChange = Edit1Change
  end
  object Edit2: TEdit
    Left = 16
    Top = 100
    Width = 401
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object Button2: TButton
    Left = 16
    Top = 136
    Width = 75
    Height = 25
    Caption = #31896#36148'(&P)'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 344
    Top = 136
    Width = 75
    Height = 25
    Caption = #20851#38381'(&C)'
    Default = True
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 96
    Top = 136
    Width = 89
    Height = 25
    Caption = #31896#36148#32467#26524'(&A)'
    TabOrder = 4
    OnClick = Button3Click
  end
end
