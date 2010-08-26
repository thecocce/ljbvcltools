unit INSDLGNumBaseConv;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, StrFuncs, CustomDialogs, StdCtrls;


type

  TNumBaseConvDlg = class(TInsertTextDialog)

    Edit1: TEdit;

    Label1: TLabel;

    Label2: TLabel;

    Edit2: TEdit;

    Edit3: TEdit;

    Label3: TLabel;

    Label4: TLabel;

    Edit4: TEdit;

    Label5: TLabel;

    Edit5: TEdit;

    Button1: TButton;

    Button2: TButton;

    procedure Edit2Change(Sender: TObject);

    procedure Button2Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);

    procedure Edit4KeyPress(Sender: TObject; var Key: Char);

  end;


implementation

{$R *.dfm}

procedure TNumBaseConvDlg.Button1Click(Sender: TObject);

begin

  close;

end;

procedure TNumBaseConvDlg.Button2Click(Sender: TObject);

begin

  DoInsertText(Edit3.Text);

end;

procedure TNumBaseConvDlg.Edit2Change(Sender: TObject);

var

  InValue, InBase, OutBase : Integer;

begin

  try

    InBase := StrToInt(Edit2.Text);

    OutBase := StrToInt(Edit4.Text);

    if InBase = 10 then

      InValue := StrToInt(Edit1.Text)

    else

      InValue := StrToNum(Edit1.Text, InBase);

    Edit5.Text := RomanNumerals(InValue);

    Edit3.Text := NumToStr(InValue, OutBase);

  except

    Edit3.Text := 'Error';

    Edit5.Text := '';

  end;

end;

procedure TNumBaseConvDlg.Edit4KeyPress(Sender: TObject; var Key: Char);

begin

  if not (Key in [#0..#31,#127,'0'..'9']) then

    key := #0;

end;

end.
