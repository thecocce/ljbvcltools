//����������Ԫ
unit LjbFun;

interface
uses
   Classes,Forms,SysUtils,WinSock,Windows;

type
    TLjbFun =class(TComponent)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
  	//��Ҫ����JS���ַ�ת��	
    function EncodeJsStr(jsstr:WideString):WideString;
    //���ĳ���˿��Ƿ�ռ��
    function PortOccupied(const APort: Integer): Boolean;
    //���ݴ��ڱ��������Ӧ���ڲ����ؾ��
    function FindHwnd(title:string): hwnd;
  end;

procedure Register;
var
    win_title:string;
    RHWND:HWND;
    function EnumWindowsProc(Wnd: HWND; Param: Integer): Boolean; stdcall;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbFun]);
end;

//--------------------------------------------------------------��Ҫ����JS���ַ�ת��
function TLjbFun.EncodeJsStr(jsstr:WideString):WideString;
var
    jslst:TStringList;
    tmp:WideString;
    i:integer;
begin
    jslst:=TStringList.Create;
    jslst.Text:=StringReplace(jsstr,'"','\"',[rfReplaceAll]);
    i:=0;
    while i<jslst.Count do
    begin
        tmp:=jslst[i];
        tmp:=tmp+'\n\';
        jslst[i]:=tmp;
        i:=i+1;
    end;
    Result:=jslst.Text;
    FreeAndNil(jslst);
end;

//--------------------------------------------------------------���ĳ���˿��Ƿ�ռ��
function TLjbFun.PortOccupied(const APort: Integer): Boolean;
var
    S: TSocket;
    WSD: TWSAData;
    SockAddrIn: TSockAddrIn;
begin
    Result := False;
    if (WSAStartup(MAKEWORD(2, 2), WSD) = 0) then
    begin
        S := Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        try
            if (S <> SOCKET_ERROR) then
            begin
                SockAddrIn.sin_family := AF_INET;
                SockAddrIn.sin_addr.S_addr := htonl(INADDR_ANY);
                SockAddrIn.sin_port := htons(APort);
                if (Bind(S, SockAddrIn, SizeOf(SockAddrIn)) <> 0) then
                    if (WSAGetLastError = WSAEADDRINUSE) then
                        Result := True;
            end;
        finally
            CloseSocket(S);
            WSACleanup();
        end;
    end;
end;

//--------------------------------------------------------------���ݴ��ڱ��������Ӧ���ڲ����ؾ��
//title:���ڱ���(��ģ��ƥ��һ����)
function TLjbFun.FindHwnd(title:string): hwnd;
begin
    win_title:=title;
    RHWND:=0;
    EnumWindows(@EnumWindowsProc, 0);
    Result:=RHWND;
end;

//Щ����ΪFindHwnd��Ȩ���Ӻ���
function EnumWindowsProc(Wnd: HWND; Param: Integer): Boolean; stdcall;
var
cn : Array[0..255] of char;
tab : HWND;
tId : DWORD;
title_tmp:pchar;
begin
    Result := TRUE;
    GetWindowText(Wnd,cn,SizeOf(cn));
    title_tmp:=cn;
    if ((pos(win_title,title_tmp)>0) and (RHWND=0)) then
    begin
        RHWND:=Wnd;
    end;
    {if GetClassName(wnd, cn, 255) > 0 then
        if cn = '#32770' then
        begin
            if (FindWindowEx(wnd, 0, 'Button','�½�����') <> 0) and
            (FindWindowEx(wnd, 0, 'Button','����绰') <> 0) and
            (FindWindowEx(wnd, 0, 'Button','����(Enter)') <> 0) then
            begin
                tID := GetWindowThreadProcessID(wnd, nil);
                //Form1.Memo1.Lines.Add('�Ի�������'+IntToStr(Wnd));
                //Form1.Memo1.Lines.Add('�Ի����߳�ID��' + IntToSTr(tID));
            end;
        end; }
end;

end.
 