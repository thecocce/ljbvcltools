
unit REPDLGWrap;


interface


uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs, StdCtrls, StrFuncs, CustomDialogs;


type

  TWrapDlg = class(TReplaceTextDialog)

    GroupBox1: TGroupBox;

    Button2: TButton;

    GroupBox2: TGroupBox;

    cHanging: TEdit;

    cFirstLine: TEdit;

    cLeftSpace: TEdit;

    cPageWidth: TEdit;

    cReorder: TCheckBox;

    GroupBox3: TGroupBox;

    Label2: TLabel;

    cBreakMode: TComboBox;

    Label3: TLabel;

    cBreak: TEdit;

    Button3: TButton;

    Label1: TLabel;

    Label4: TLabel;

    Label5: TLabel;

    Label6: TLabel;

    procedure cLeftSpaceKeyPress(Sender: TObject; var Key: Char);

    procedure Button2Click(Sender: TObject);

    procedure Button3Click(Sender: TObject);

    procedure cReorderClick(Sender: TObject);

    procedure cHangingChange(Sender: TObject);

    procedure cFirstLineChange(Sender: TObject);

    procedure cLeftSpaceChange(Sender: TObject);

    procedure cPageWidthChange(Sender: TObject);

    procedure cBreakChange(Sender: TObject);

    procedure cBreakModeChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);

  end;


function StrWrap(value : string): string;

var

  Reorder : Boolean = False;

  Hanging : Integer = 0;

  FirstLIne : Integer = 4 ;

  LeftSpace : Integer = 0;

  PageWidth : Integer = 80;

  Break : string = '';

  BreakMode : Integer = 0;

implementation

{$R *.dfm}

function StrWrap(value : string): string;

begin

  Result := StrFuncs.StrWrap(value, sLineBreak, Reorder, Hanging, FirstLine,

    LeftSpace, PageWidth, Break, BreakMode);

end;

procedure TWrapDlg.cLeftSpaceKeyPress(Sender: TObject; var Key: Char);

begin

  if not (Key in [#0..#31,#127,'0'..'9']) then

    key := #0;

end;

procedure TWrapDlg.Button2Click(Sender: TObject);

begin

  close;

end;

procedure TWrapDlg.Button3Click(Sender: TObject);

var

  s : string;

begin

  DoGetText(s, False);

  s := StrWrap(s);

  DoSetText(s, False);

end;

procedure TWrapDlg.cReorderClick(Sender: TObject);

begin

  Reorder := cReorder.Checked

end;

procedure TWrapDlg.cHangingChange(Sender: TObject);

var

  value : integer;

begin

  try

    value := StrToInt(cHanging.Text);

    Hanging := value;

  finally

  end;

end;

procedure TWrapDlg.cFirstLineChange(Sender: TObject);

var

  value : integer;

begin

  try

    value := StrToInt(cFirstLine.Text);

    FirstLine := value;

  finally

  end;

end;

procedure TWrapDlg.cLeftSpaceChange(Sender: TObject);

var

  value : integer;

begin

  try

    value := StrToInt(cLeftSpace.Text);

    LeftSpace := value;

  finally

  end;

end;

procedure TWrapDlg.cPageWidthChange(Sender: TObject);

var

  value : integer;

begin

  try

    value := StrToInt(cPageWidth.Text);

    PageWidth := value;

  finally

  end;

end;

procedure TWrapDlg.cBreakChange(Sender: TObject);

begin

  Break := cBreak.Text;

end;

procedure TWrapDlg.cBreakModeChange(Sender: TObject);

begin

  BreakMode := cBreakMode.ItemIndex;

end;

procedure TWrapDlg.FormCreate(Sender: TObject);

begin

  cReorder.Checked := Reorder;

  cHanging.Text := IntToStr(Hanging);

  cFirstLine.text := IntToStr(FirstLIne);

  cLeftSpace.Text := IntToStr(LeftSpace);

  cPageWidth.Text := IntToStr(PageWidth);

  cBreak.Text := Break;

  cBreakMode.ItemIndex := BreakMode;

end;

end.
