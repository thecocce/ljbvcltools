unit MyShell;

interface

uses
  Windows, Messages , SysUtils, ShellAPI;//shellexecute�Ͷ�����ShellApi��Ԫ��
Type
    TShellException = class (Exception)
end;

Type
  TShellExecute = class
  private
    FExeName : string ;
    FHandle  : HWND;
    FOHandle : HWND;
    procedure SetExeName(Value : string);
    procedure SetHandle (Value : HWND);
  public
   constructor Create(h : HWND;PrgName : string );
   property  ExeName : string read FExeName write SetExeName;
   property  Handle  : HWND   read FHandle  write SetHandle;
   procedure Execute ;
   procedure FindExe;
   procedure PrintExe;
   procedure ClosePrg;
End;

implementation

Constructor TShellExecute.Create(h : HWND;PrgName : string );
begin
    if (h>0) and (PrgName<>'') then
    begin
     self.ExeName:=PrgName;
     self.Handle :=h;
    end
    else
    raise TShellException.Create('Handle or PrgName is Null');
end;

//ִ����ҳ��Email����ͨ����
procedure TShellExecute.Execute ;
begin
FOHandle := ShellExecute(self.FHandle,'open',PChar(self.FExeName),nil,nil, SW_HIDE);
end;

//����ָ���ļ�
procedure TShellExecute.FindExe;
begin
ShellExecute(self.FHandle,'find',PChar(self.FExeName),nil,nil, SW_SHOW);
end;

//��ӡ�ļ�
procedure TShellExecute.PrintExe;
begin
ShellExecute(self.FHandle,'print',PChar(self.FExeName),nil,nil, SW_HIDE);
end;

//�رճ���
procedure TShellExecute.ClosePrg;
begin
  if FOHandle<>0 then
    SendMessage(self.FOHandle,WM_ClOSE,0,0)
  Else
    raise TShellException.Create('The Programm is null')
end;

procedure TShellExecute.SetExeName(Value : string);
begin
 if value <> '' then
    self.FExeName:=Value
 else
    raise TShellException.Create('The Name should not Null');
end;

procedure TShellExecute.SetHandle (Value : HWND);
begin
  if Value > 0 then
     self.FHandle:=value
  else
     raise TShellException.Create('The Handle should not Null');
end;

end.

