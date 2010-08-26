unit INSDLGHash;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, ExtCtrls, StdCtrls, CustomDialogs, Clipboard, CryptoApi;


type

  THashDlg = class(TInsertTextDialog)

    ComboBox1: TComboBox;

    RadioButton1: TRadioButton;

    Edit1: TEdit;

    RadioButton2: TRadioButton;

    Label2: TLabel;

    Edit3: TEdit;

    Button2: TButton;

    Button3: TButton;

    Panel1: TPanel;

    Edit2: TEdit;

    Label1: TLabel;

    Label3: TLabel;

    Panel2: TPanel;

    Edit4: TEdit;

    Image1: TImage;

    Image2: TImage;

    Button4: TButton;
    Button1: TButton;

    procedure Edit4Change(Sender: TObject);

    procedure Edit1Change(Sender: TObject);

    procedure RadioButton2Click(Sender: TObject);

    procedure Edit2Change(Sender: TObject);

    procedure Button3Click(Sender: TObject);

    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);

  end;


implementation

{$R *.dfm}

procedure THashDlg.Edit4Change(Sender: TObject);

begin

  if LowerCase(Edit4.Text) = LowerCase(Edit3.Text) then

    Image2.BringToFront

  else

    image1.BringToFront;

end;

procedure THashDlg.Edit1Change(Sender: TObject);

var

  s : string;

begin

  if RadioButton1.Checked then

  begin

    if HashStr(HASH_INITIAL + ComboBox1.ItemIndex + 1, Edit1.Text, s) = HASH_NOERROR then

       Edit3.Text := s;

  end;

end;

procedure THashDlg.RadioButton2Click(Sender: TObject);

begin

  Edit1.Enabled := RadioButton1.Checked;

  if Edit1.Enabled then

    Edit1.Color := clWindow

  else edit1.Color := clBtnFace;

  Edit2.Enabled := RadioButton2.Checked;

  Button1.Enabled := RadioButton2.Checked;

  if Edit2.Enabled then

    Edit2.Color := clWindow

  else Edit2.Color := clBtnFace;

end;

procedure THashDlg.Edit2Change(Sender: TObject);

var

  s : string;

begin

  if RadioButton2.Checked then

  begin

    if FileExists(Edit2.Text) then

      if HashFile(HASH_INITIAL + ComboBox1.ItemIndex + 1, Edit3.Text, s) = HASH_NOERROR then

         Edit3.Text := s;

  end;

end;

procedure THashDlg.Button3Click(Sender: TObject);

begin

  ManyClipboard.AsText := Edit3.Text;

end;

procedure THashDlg.Button4Click(Sender: TObject);

begin

  DoInsertText(Edit3.Text);
  
end;

procedure THashDlg.Button2Click(Sender: TObject);

begin

  CLOSE;

end;

procedure THashDlg.Button1Click(Sender: TObject);

begin

  with TOpenDialog.Create(Self) do

  begin

    if Execute then

      Edit2.Text := FileName;

    free;

  end;
  
end;

procedure THashDlg.ComboBox1Change(Sender: TObject);

begin

  if RadioButton1.Checked then

    Edit1Change(nil);

  if RadioButton2.Checked then

    Edit2Change(nil);

end;

end.
