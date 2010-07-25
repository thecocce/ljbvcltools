unit LjbGetDnsIP;

interface
uses
      SysUtils,Classes, Windows;

type
    TLjbGetDnsIP = class(TComponent)
    private
        function BackSlashStr (const s : string) : string;
        function GetWindowsPath : string;
        function GetSystemPath : string;
        function LooksLikeIP(StrIn: string): boolean;
        function GetIpCfgExePath : string;
        procedure GetConsoleOutput (const CommandLine : string; var Output : TStringList);
        function GetBasicOsType : LongWord;
        function GetIpCfg9xOutPath : string;
        function GetDnsIpFromReg : string;
        function GetDnsIpFromIpCfgOut (const Output : TStringList;var DnsIp : string) : boolean;
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
    	function GetDnsIp : string;	
    end;

procedure Register;

implementation
const
  IPCFG_DUMMY_FILE = '_dd87mytj3mpdns.tmp';
  IPCFG_WIN9X = 'winipcfg.exe /all /batch ';
  IPCFG_WINNT = 'ipconfig.exe /all';

  IPCFG_DNS_SERVER_LINE = 'DNS Servers';

  REG_NT_NAMESERVER_PATH =
    'System\CurrentControlSet\Services\Tcpip\Parameters';
  REG_NT_NAMESERVER = 'DhcpNameServer';

  REG_9X_NAMESERVER_PATH = 'System\CurrentControlSet\Services\MSTCP';
  REG_9X_NAMESERVER = 'NameServer';

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbGetDnsIP]);
end;
//--------------------------------------------------------------

function TLjbGetDnsIP.BackSlashStr (const s : string) : string;
begin
  Result := s;
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

function TLjbGetDnsIP.GetWindowsPath : string;
var
  Temp : array [0..MAX_PATH] of char;
begin
  GetWindowsDirectory (Temp, SizeOf(Temp));
  Result := BackSlashStr (Temp);
end;

function TLjbGetDnsIP.GetSystemPath : string;
var
  Temp : array [0..MAX_PATH] of char;
begin
  GetSystemDirectory (Temp, SizeOf(Temp));
end;

function TLjbGetDnsIP.LooksLikeIP(StrIn: string): boolean;
var
  IPAddr : string;
  period, octet, i : Integer;
begin
  result := false; 
  IPAddr := StrIn;
  for i := 1 to 4 do begin
    if i = 4 then period := 255 else period := pos('.',IPAddr);
    if period = 0 then exit;
    try
      octet := StrToInt(copy(IPAddr,1,period - 1));
    except
      exit;
    end; 
    if (octet < (1 div i)) or (octet > 254) then exit;
    if i = 4 then result := true else IPAddr := copy(IPAddr,period+1,255);
  end;
end;

procedure TLjbGetDnsIP.GetConsoleOutput (const CommandLine : string;
  var Output : TStringList);
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutFile, AppProcess, AppThread : THandle;
  RootDir, WorkDir, StdOutFileName:string;
const
  FUNC_NAME = 'GetConsoleOuput';
begin
  try
    StdOutFile:=0;
    AppProcess:=0;
    AppThread:=0;
    RootDir:=ExtractFilePath(ParamStr(0));
    WorkDir:=ExtractFilePath(CommandLine);
    if not (FileSearch(ExtractFileName(CommandLine),WorkDir)<>'') then
      WorkDir:=RootDir;
    FillChar(SA,SizeOf(SA),#0);
    SA.nLength:=SizeOf(SA);
    SA.lpSecurityDescriptor:=nil;
    SA.bInheritHandle:=True;
    StdOutFileName:=RootDir+'output.tmp';
    StdOutFile:=CreateFile(PChar(StdOutFileName),
                   GENERIC_READ or GENERIC_WRITE,
                   FILE_SHARE_READ or FILE_SHARE_WRITE,
                   @SA,
                   Create_ALWAYS, 
                   FILE_ATTRIBUTE_TEMPORARY or 
                   FILE_FLAG_WRITE_THROUGH,
                   0);
    if StdOutFile = INVALID_HANDLE_VALUE then
      raise Exception.CreateFmt('Function %s() failed!' + #10#13 +
        'Command line = %s',[FUNC_NAME,CommandLine]);
    FillChar(SI,SizeOf(SI),#0);
    with SI do begin
      cb:=SizeOf(SI);
      dwFlags:=STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow:=SW_HIDE;
      hStdInput:=GetStdHandle(STD_INPUT_HANDLE);
      hStdError:=StdOutFile;
      hStdOutput:=StdOutFile;
    end;
    if CreateProcess(nil, PChar(CommandLine), nil, nil,
                     True, 0, nil,
                     PChar(WorkDir), SI, PI) then begin
      WaitForSingleObject(PI.hProcess,INFINITE);
      AppProcess:=PI.hProcess;
      AppThread:=PI.hThread;
      end
    else
      raise Exception.CreateFmt('CreateProcess() in function %s() failed!'
                   + #10#13 + 'Command line = %s',[FUNC_NAME,CommandLine]);

    CloseHandle(StdOutFile);
    StdOutFile:=0;

    Output.Clear;
    Output.LoadFromFile (StdOutFileName);

  finally
    if StdOutFile <> 0 then CloseHandle(StdOutFile);
    if AppProcess <> 0 then CloseHandle(AppProcess);
    if AppThread <> 0 then CloseHandle(AppThread);
    if FileExists(StdOutFileName) then
      SysUtils.DeleteFile(StdOutFileName);
  end;
end;

function TLjbGetDnsIP.GetBasicOsType : LongWord;
var
  VerInfo : TOsVersionInfo;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  GetVersionEx (VerInfo);
  Result := VerInfo.dwPlatformId;
end;

function TLjbGetDnsIP.GetIpCfg9xOutPath : string;
begin
  Result := GetWindowsPath + IPCFG_DUMMY_FILE;
end;

function TLjbGetDnsIP.GetIpCfgExePath : string;
begin
  Result := '';
  Case GetBasicOsType of
    VER_PLATFORM_WIN32_WINDOWS : Result := GetWindowsPath + IPCFG_WIN9X +
      GetIpCfg9xOutPath;
    VER_PLATFORM_WIN32_NT : Result := GetSystemPath + IPCFG_WINNT;
  end;
end;

function TLjbGetDnsIP.GetDnsIpFromReg : string;
var
  OpenKey : HKEY;
  Vn,
  SubKey : PChar;
  DataType,
  DataSize : integer;
  Temp : array [0..2048] of char;
begin
  Result := '';
  SubKey := '';
  Vn := '';
  case GetBasicOsType of
    VER_PLATFORM_WIN32_WINDOWS :
    begin
      SubKey := REG_9X_NAMESERVER_PATH;
      Vn := REG_9X_NAMESERVER;
    end;
    VER_PLATFORM_WIN32_NT :
    begin
      SubKey := REG_NT_NAMESERVER_PATH;
      Vn := REG_NT_NAMESERVER;
    end;
  end;
  if RegOpenKeyEx (HKEY_LOCAL_MACHINE, SubKey, REG_OPTION_NON_VOLATILE,
    KEY_READ, OpenKey) = ERROR_SUCCESS then
  begin
    DataType := REG_SZ;
    DataSize := SizeOf(Temp);
    if RegQueryValueEx (OpenKey, Vn, nil, @DataType, @Temp,
      @DataSize) = ERROR_SUCCESS then
      Result := string(Temp);
    RegCloseKey (OpenKey);
  end;
end;

function TLjbGetDnsIP.GetDnsIpFromIpCfgOut (const Output : TStringList;
  var DnsIp : string) : boolean;
var
  i : integer;
begin
  Result := FALSE;
  if Output.Count >= 1 then
    for i := 0 to Output.Count - 1 do
    begin
      if Pos(IPCFG_DNS_SERVER_LINE, Output[i]) > 0 then
      begin
        DnsIp := Trim(Copy (Output[i], Pos(':', Output[i])+1,
          Length(Output[i])));
        Result := LooksLikeIp (DnsIp);
      end;
    end;
end;

function TLjbGetDnsIP.GetDnsIp : string;
var
  Output : TStringList;
  DnsIp,
  CmdLine : string;
begin
  CmdLine := GetIpCfgExePath;
  if CmdLine <> '' then
  begin
    Output := TStringList.Create;
    try
      case GetBasicOsType of
        VER_PLATFORM_WIN32_WINDOWS :
        begin
          GetConsoleOutput (CmdLine, Output);
          Output.LoadFromFile (GetIpCfg9xOutPath);
        end;
        else
          GetConsoleOutput (CmdLine, Output);
      end;
      if GetDnsIpFromIpCfgOut (Output, DnsIp) then
        Result := DnsIp
      else
      begin
        Result := GetDnsIpFromReg;
      end;
    finally
      Output.Free;
    end;
  end;
end;
//--------------------------------------------------------------

end.

