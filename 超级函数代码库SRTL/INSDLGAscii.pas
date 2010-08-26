{------------------------------------------------------------------------------}
{                                                                              }
{   单元: INSDLGAscii.pas                                                      }
{                                                                              }
{         属于程序扩展包, 来源于 AsciiTable 版本 1.00                          }
{                                                                              }
{   说明: 一个可以做公用的ASCII参照表窗口                                      }
{                                                                              }
{   作者: 姚乔锋                                                               }
{                                                                              }
{------------------------------------------------------------------------------}


unit INSDLGAscii;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, ExtCtrls, StdCtrls, Menus, Grids, CustomDialogs;


type

  TInsertAsciiEvent = procedure(Sender : TObject; Ascii : string) of object;

  TAsciiDlg = class(TInsertTextDialog)

    Label1: TLabel;

    Label2: TLabel;

    Label3: TLabel;

    Label4: TLabel;

    Label5: TLabel;

    isCancal: TButton;

    isFontSetting: TButton;

    FontDialog: TFontDialog;

    AsciiGrid: TStringGrid;

    Button1: TButton;

    Label6: TLabel;

    ishex: TRadioButton;

    isDec: TRadioButton;

    isChar: TRadioButton;

    procedure isFontSettingClick(Sender: TObject);

    procedure isKeyKeyDown(Sender: TObject; var Key: Word;

      Shift: TShiftState);

    procedure FormCreate(Sender: TObject);

    procedure Button1Click(Sender: TObject);

    procedure isCancalClick(Sender: TObject);

  end;


implementation


{$R *.dfm} //窗口资源文件


type

  TGridAccess = class(TCustomGrid);


const

  ASCIIName : Array[0..126] of String = (

   'NUL','SOH','STX','ETX','EOT','ENQ','ACK','BEL','BS','HT','LF',

   'VT','FF','CR','SO','SI','DLE','DC1','DC2','DC3','DC4','NAK','SYN',

   'ETB','CAN','EM','SUB','ESC','FS','GS','RS','US','SP','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','DEL');


  ASCIICtrl : Array[0..126] of String = (

   '^@','^A','^B','^C','^D','^E','^F','^G','^H','^I','^J','^K','^L',

   '^M','^N','^O','^P','^Q','^R','^S','^T','^U','^V','^W','^X','^Y',

   '^Z','^[','^\','^]','^^','^-','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','','','','','','',

   '','','','','','','','','','','','','','','','','^N');


function Min(X, Y : Integer): integer;

begin

  result := X;

  if Y < x Then result := Y;

end;

procedure TAsciiDlg.isFontSettingClick(Sender: TObject);

begin

  Fontdialog.Font := AsciiGrid.Font;

  IF Fontdialog.Execute then

    AsciiGrid.Font := Fontdialog.Font;

end;

procedure TAsciiDlg.isKeyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

begin

  if key in [0..255] then

    TGridAccess(AsciiGrid).FocusCell(0, Key, true)

  else Key := 0;

end;

procedure TAsciiDlg.FormCreate(Sender: TObject);

var

  I : integer;

begin

  For I := 0 to 255 do

  begin

    AsciiGrid.Cells[0, I] := Char(I);

    AsciiGrid.Cells[1, I] := Inttostr(I);

    AsciiGrid.Cells[2, I] := InttoHex(I, 2);

    If I < 127 then

    begin

      AsciiGrid.Cells[3, I] := AsciiName[I];

      AsciiGrid.Cells[4, I] := AsciiCtrl[I];

    end;

  end;

end;

procedure TAsciiDlg.Button1Click(Sender: TObject);

var

  s : string;

begin

  if ishex.Checked then

    s := IntToHex(AsciiGrid.Row, 2);

  if isChar.Checked then

    s := char(AsciiGrid.Row);

  if isDec.Checked then

    s := IntToStr(AsciiGrid.Row);

  DoInsertText(S);
  
end;

procedure TAsciiDlg.isCancalClick(Sender: TObject);

begin

  close;

end;

end.
