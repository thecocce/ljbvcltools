
unit REPDLGEncryption;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, ExtCtrls, StdCtrls, AES, DES, CustomDialogs;


type

  TEncryptionDlg = class(TReplaceTextDialog)

    Label1: TLabel;

    Edit1: TEdit;

    CheckBox1: TCheckBox;

    Label2: TLabel;

    ComboBox1: TComboBox;

    GroupBox1: TGroupBox;

    RadioButton2: TRadioButton;

    RadioButton1: TRadioButton;

    Button1: TButton;

    Button2: TButton;

    Panel1: TPanel;

    Edit2: TEdit;

    Button3: TButton;

    Button4: TButton;

    Label3: TLabel;

    Panel2: TPanel;

    Edit3: TEdit;

    Button5: TButton;

    Label4: TLabel;

    procedure CheckBox1Click(Sender: TObject);

    procedure RadioButton2Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);

    procedure Button3Click(Sender: TObject);

    procedure Button2Click(Sender: TObject);

    procedure Button5Click(Sender: TObject);

    procedure Button4Click(Sender: TObject);

  private

    { Private declarations }

  public

    { Public declarations }

  end;



implementation

{$R *.dfm}

procedure TEncryptionDlg.CheckBox1Click(Sender: TObject);

begin

  if CheckBox1.Checked then

    Edit1.PasswordChar := '*'

  else

    Edit1.PasswordChar := #0;

end;

procedure TEncryptionDlg.RadioButton2Click(Sender: TObject);

begin

  Edit2.Enabled := RadioButton2.Checked;

  Edit3.Enabled := RadioButton2.Checked;

  Button3.Enabled := RadioButton2.Checked;

  Button5.Enabled := RadioButton2.Checked;

///  Button1.Enabled := RadioButton2.Checked;

  if Edit2.Enabled then

  begin

    Edit2.Color := clWindow;

    Edit3.Color := clWindow;

  end

  else begin

    Edit2.Color := clBtnFace;

    Edit3.Color := clBtnFace;

  end;

end;

procedure TEncryptionDlg.Button1Click(Sender: TObject);

begin

  Close;

end;

procedure TEncryptionDlg.Button3Click(Sender: TObject);

begin

  with TOpenDialog.Create(Self) do

  begin

    if Execute then

    begin

      Edit2.Text := FileName;

      Edit3.Text := FileName;

    end;

    free;

  end;

end;

procedure TEncryptionDlg.Button2Click(Sender: TObject);

var

  S : string;

  StrList : TStrings;

begin

  case ComboBox1.ItemIndex of

    0..2 : //AES

    begin

      if RadioButton1.Checked then

      begin

        doGetText(S, False);

        s := AES.EncryptString(s, Edit1.Text, TKeyBit(ComboBox1.ItemIndex));

        DoSetText(s, False);

      end

      else begin

        if FileExists(Edit2.Text) then

           AES.EncryptFile(Edit2.Text, Edit3.Text, Edit1.Text, TKeyBit(ComboBox1.ItemIndex));

      end;

    end;

    3 : //DES

    begin

      if RadioButton1.Checked then

      begin

        doGetText(s, False);

        s := DES.EncryStrHex(S, Edit1.Text);

        DoSetText(s, False);

      end

      else begin

        if FileExists(Edit2.Text) then

        begin

          StrList := TStringList.Create;

          try

            StrList.LoadFromFile(Edit2.Text);

            StrList.Text := DES.EncryStrHex(StrList.Text, Edit1.Text);

            StrList.SaveToFile(Edit3.Text);

          finally

            StrList.Free;

          end;

        end;

      end;

    end;

  end;

end;

procedure TEncryptionDlg.Button5Click(Sender: TObject);

begin

  with TSaveDialog.Create(Self) do

  begin

    if Execute then

      Edit3.Text := FileName;

    free;

  end;

end;

procedure TEncryptionDlg.Button4Click(Sender: TObject);

var

  S : string;

  StrList : TStrings;

begin

  case ComboBox1.ItemIndex of

    0..2 : //AES

    begin

      if RadioButton1.Checked then

      begin

        doGetText(s, False);

        s := AES.DecryptString(s, Edit1.Text, TKeyBit(ComboBox1.ItemIndex));

        DoSetText(s, False);

      end

      else begin

        if FileExists(Edit2.Text) then

           AES.DecryptFile(Edit2.Text, Edit3.Text, Edit1.Text, TKeyBit(ComboBox1.ItemIndex));

      end;

    end;

    3 : //DES

    begin

      if RadioButton1.Checked then

      begin

        doGetText(s, False);

        s := DES.DecryStrHex(S, Edit1.Text);

        DoSetText(s, False);

      end

      else begin

        if FileExists(Edit2.Text) then

        begin

          StrList := TStringList.Create;

          try

            StrList.LoadFromFile(Edit2.Text);

            StrList.Text := DES.DecryStrHex(StrList.Text, Edit1.Text);

            StrList.SaveToFile(Edit3.Text);

          finally

            StrList.Free;

          end;

        end;

      end;

    end;

  end;

end;

end.
