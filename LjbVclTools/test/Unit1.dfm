object Form1: TForm1
  Left = 334
  Top = 212
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Button1: TButton
    Left = 70
    Top = 240
    Width = 100
    Height = 51
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 256
    Top = 72
    Width = 369
    Height = 217
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 104
    Top = 344
    Width = 73
    Height = 33
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ZConnection1: TZConnection
    Protocol = 'postgresql-7.3'
    HostName = '192.168.0.2'
    Port = 0
    Database = 'itgcs'
    User = 'issence'
    Password = 'wel==110'
    AutoCommit = True
    ReadOnly = True
    TransactIsolationLevel = tiNone
    Connected = True
    SQLHourGlass = False
    Left = 42
    Top = 16
  end
  object DataSource1: TDataSource
    Left = 152
    Top = 72
  end
  object LjbQuery1: TLjbQuery
    Connection = ZConnection1
    RequestLive = True
    CachedUpdates = False
    ParamCheck = True
    Params = <>
    ShowRecordTypes = [utUnmodified, utModified, utInserted]
    UpdateMode = umUpdateChanged
    WhereMode = wmWhereKeyOnly
    Options = [doCalcDefaults]
    Left = 72
    Top = 144
  end
end
