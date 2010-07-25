unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  KeyboardHook,dialogs;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    Label3: TLabel;
    khook: TKeyboardHook;
    btStartKeyboard: TButton;
    procedure btStartKeyboardClick(Sender: TObject);
    procedure khookKeyDown(const KeyCode: Integer);
    procedure khookKeyUp(const KeyCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
                                
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btStartKeyboardClick(Sender: TObject);
begin
  if btStartKeyboard.Caption = '��ʼ' then
  begin
    if khook.Start then
      btStartKeyboard.Caption := '����';
  end
  else begin
    khook.Stop;  
    btStartKeyboard.Caption := '��ʼ';
  end;
end;

procedure TForm1.khookKeyDown(const KeyCode: Integer);
begin
  // ������Ϣ����
  if KeyCode = Byte(Ord('A')) then
  begin
    //MessageBox(Handle, '���� ��ü�����Ϣ: A', 'Info', MB_OK);
  end;

   //showmessage(IntToStr(GetAsyncKeyState(VK_CONTROL)));
  //if ((GetAsyncKeyState(VK_CONTROL) <0)) then
  //begin
      MessageBox(Handle, PChar('���� ��ü�����Ϣ: ' + chr(KeyCode)), 'Info', MB_OK);
  //end;

end;

procedure TForm1.khookKeyUp(const KeyCode: Integer);
begin
  // ������Ϣ����
  if KeyCode = Byte(Ord('A')) then
  begin
    //MessageBox(Handle, '���� ��ü�����Ϣ: A', 'Info', MB_OK);
  end;
end;

end.

