//公共函数单元
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
  	//将要传给JS的字符转义	
    function EncodeJsStr(jsstr:WideString):WideString;
    //检测某个端口是否被占用
    function PortOccupied(const APort: Integer): Boolean;    
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbFun]);
end;

//--------------------------------------------------------------将要传给JS的字符转义
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

//--------------------------------------------------------------检测某个端口是否被占用
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

end.
 