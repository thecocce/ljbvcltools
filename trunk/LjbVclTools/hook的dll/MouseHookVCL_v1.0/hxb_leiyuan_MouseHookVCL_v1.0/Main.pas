unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls,
  MouseHook;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    btStartMouse: TButton;
    Label2: TLabel;
    mhook: TMouseHook;
    procedure btStartMouseClick(Sender: TObject);
    procedure mhookMouseMove(const Handle: HWND; const X, Y: Integer);
    procedure mhookMouseLButtonUp(const Handle: HWND; const X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btStartMouseClick(Sender: TObject);
begin
  if btStartMouse.Caption = '��ʼ' then
  begin
    if mhook.Start then
      btStartMouse.Caption := '����';
  end
  else
  begin
    mhook.Stop;
    btStartMouse.Caption := '��ʼ';
  end;
end;

procedure TForm1.mhookMouseMove(const Handle: HWND; const X, Y: Integer);
begin
  // �����Ϣ���� OnMove
  Label1.Caption := Format('[�ƶ�λ��]: ���ھ��: %d - X: %d - Y: %d', [Handle, X, Y])
end;

procedure TForm1.mhookMouseLButtonUp(const Handle: HWND; const X,
  Y: Integer);
begin
  // �����Ϣ���� OnClick
  Label2.Caption := Format('[���λ��]: ���ھ��: %d - X: %d - Y: %d', [Handle, x, y]);
end;

end.

