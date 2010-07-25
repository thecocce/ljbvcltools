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
  if btStartKeyboard.Caption = '开始' then
  begin
    if khook.Start then
      btStartKeyboard.Caption := '结束';
  end
  else begin
    khook.Stop;  
    btStartKeyboard.Caption := '开始';
  end;
end;

procedure TForm1.khookKeyDown(const KeyCode: Integer);
begin
  // 键盘消息测试
  if KeyCode = Byte(Ord('A')) then
  begin
    //MessageBox(Handle, '按下 获得键盘消息: A', 'Info', MB_OK);
  end;

   //showmessage(IntToStr(GetAsyncKeyState(VK_CONTROL)));
  //if ((GetAsyncKeyState(VK_CONTROL) <0)) then
  //begin
      MessageBox(Handle, PChar('按下 获得键盘消息: ' + chr(KeyCode)), 'Info', MB_OK);
  //end;

end;

procedure TForm1.khookKeyUp(const KeyCode: Integer);
begin
  // 键盘消息测试
  if KeyCode = Byte(Ord('A')) then
  begin
    //MessageBox(Handle, '弹起 获得键盘消息: A', 'Info', MB_OK);
  end;
end;

end.

