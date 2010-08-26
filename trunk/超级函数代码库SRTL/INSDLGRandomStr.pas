
unit INSDLGRandomStr;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, StrFuncs, StdCtrls, CustomDialogs;


type

  TRandomStrDlg = class(TInsertTextDialog)

    Label2: TLabel;

    Edit1: TEdit;

    GroupBox1: TGroupBox;

    CheckBox4: TCheckBox;

    CheckBox1: TCheckBox;

    CheckBox2: TCheckBox;

    CheckBox5: TCheckBox;

    CheckBox3: TCheckBox;

    Label1: TLabel;

    Edit2: TEdit;

    Button1: TButton;

    Button2: TButton;

    Button3: TButton;

    procedure Button1Click(Sender: TObject);

    procedure Edit1KeyPress(Sender: TObject; var Key: Char);

    procedure Button3Click(Sender: TObject);

    procedure Button2Click(Sender: TObject);

    procedure CheckBox2Click(Sender: TObject);

  private

    FSource : string;

  end;


implementation

{$R *.dfm}

procedure TRandomStrDlg.Button1Click(Sender: TObject);

begin

  Close

end;


procedure TRandomStrDlg.Edit1KeyPress(Sender: TObject; var Key: Char);

begin

  if not (Key in [#0..#31,#127,'0'..'9']) then

    key := #0;

end;

procedure TRandomStrDlg.Button3Click(Sender: TObject);

var

  L : Integer;

begin

  try

    L := StrToInt(Edit1.Text);

    Edit2.Text := GetRandomStr(FSource, L);

  except

  end;

end;

procedure TRandomStrDlg.Button2Click(Sender: TObject);

begin

  if Edit2.Text <> '' then

    DoInsertText(edit2.Text);

end;

procedure TRandomStrDlg.CheckBox2Click(Sender: TObject);

var

  I : Integer;

begin

  FSource := '';

  if CheckBox5.Checked then

  begin

    for i := 0 to 255 do

      FSource := FSource + Char(I);

  end

  else begin

    if CheckBox1.Checked then

    begin

      for i := 97 to 122 do

        FSource := FSource + Char(I);

    end;

    if CheckBox2.Checked then

    begin

      for i := 65 to 90 do

        FSource := FSource + Char(I);

    end;

    if CheckBox3.Checked then

    begin

      for i := 48 to 57 do

        FSource := FSource + Char(I);

    end;

    if CheckBox4.Checked then

    begin

      for i := 33 to 47 do

        FSource := FSource + Char(I);

      for i := 58 to 64 do

        FSource := FSource + Char(I);

      for i := 91 to 96 do

        FSource := FSource + Char(I);

      for i := 123 to 126 do

        FSource := FSource + Char(I);

    end;

  end;

  Button3Click(nil);

end;

end.
