unit INSDLGExpression;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, CustomDialogs, StrFuncs, StdCtrls;


type

  TExpressionDlg = class(TInsertTextDialog)

    Label1: TLabel;

    Edit1: TEdit;

    Label2: TLabel;

    Edit2: TEdit;

    Button2: TButton;

    Button1: TButton;

    Button3: TButton;

    procedure Edit1Change(Sender: TObject);

    procedure Button2Click(Sender: TObject);

    procedure FormShow(Sender: TObject);

    procedure Button3Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);

  private

    FError : Boolean;

    FValue : Extended;

  end;


implementation

{$R *.dfm}

procedure TExpressionDlg.Edit1Change(Sender: TObject);

begin

  try

     FValue := ExpressionEval(Edit1.Text, FError);

  finally

    if FError then

      Edit2.Text := '±Ì¥Ô Ω¥ÌŒÛ'

    else

      Edit2.Text := FloatToStr(FValue);

  end;

end;

procedure TExpressionDlg.Button2Click(Sender: TObject);

begin

  if not FError then

    DoInsertText(Edit1.Text + '=' + FloatToStr(Fvalue));

end;

procedure TExpressionDlg.FormShow(Sender: TObject);

begin

  FError := true;

end;

procedure TExpressionDlg.Button3Click(Sender: TObject);

begin

  if not FError then

    DoInsertText(FloatToStr(Fvalue));

end;

procedure TExpressionDlg.Button1Click(Sender: TObject);

begin

  close;

end;

end.
