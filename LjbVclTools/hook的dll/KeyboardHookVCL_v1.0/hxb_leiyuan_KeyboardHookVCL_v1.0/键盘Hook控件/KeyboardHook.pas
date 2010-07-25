{

 KeyboardHook DLL Load & KeyboardHook Class Unit
 
 2005-03-27

 Copyright ? 黄晓斌 长沙国防科技大学 Email: hxb_leiyuan2000@163.net QQ: 478522325 

}

unit KeyboardHook;

interface

uses
  Windows, Messages, Classes, TlHelp32;

const
  DEFDLLNAME = 'keyboardhook.dll';
  MappingFileName = 'keybord_hook_46772A5A-1905-455F-AB55-E8D1E706E7D0';

type
  TMappingMem = record
    Handle: DWORD;
    MsgID: DWORD;
    KeyCode: DWORD;
    Blocked: Boolean;    
  end;
  PMappingMem = ^TMappingMem;

  // 函数原型
  TEnableKeyboardHook = function(hWindow: HWND; Blocked: BOOL; TID: Longword; otherKeys:pchar): BOOL; stdcall; 
  TDisableKeyboardHook = function: BOOL; stdcall;

  // 事件对象
  TKeyDownNotify = procedure(const KeyCode: Integer) of object;
  TKeyUpNotify = procedure(const KeyCode: Integer) of object;

  TKeyboardHookBase = class(TComponent)
  private
    FDLLName: string;
    FHookedExeName: string;
    FHookedExe_TID: Longword;
    FDLLLoaded: BOOL;
    FListenerHandle: HWND;
    FActive: BOOL;
    hMappingFile: THandle;
    pMapMem: PMappingMem;
    FBlocked: BOOL;
    FSysKey: string;
    procedure WndProc(var Message: TMessage);
    procedure SetDLLName(const Value: string);
    procedure SetHookedExeName(const Value: string);
    procedure SetBlocked(const Value: BOOL);
    procedure SetSysKey(const Value: string);
  protected
    procedure ProcessMessage(var Message: TMessage); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Start: BOOL; virtual;
    procedure Stop; virtual;
    property DLLLoaded: BOOL read FDLLLoaded;
    property Active: BOOL read FActive;
    property DLLName: string read FDLLName;// write SetDLLName;
    property HookedExeName: string read FHookedExeName write SetHookedExeName;
    property Blocked: BOOL read FBlocked write SetBlocked default False;
    property SysKey: string read FSysKey write SetSysKey;
  end;

  TKeyboardHook = class(TKeyboardHookBase)
  private
    FOnKeyDown: TKeyDownNotify;
    FOnKeyUp: TKeyUpNotify;
    procedure DoKeyDown(const KeyCode: Integer);
    procedure DoKeyUp(const KeyCode: Integer);
  protected
    procedure ProcessMessage(var Message: TMessage); override;
  public

  published
    //property DLLName;
    property Blocked;
    property SysKey;
    property HookedExeName;
    property OnKeyDown: TKeyDownNotify read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TKeyUpNotify read FOnKeyUp write FOnKeyUp;
  end;

var
  DLLLoaded: BOOL = False;

  StartKeyboardHook: TEnableKeyboardHook;
  StopKeyboardHook: TDisableKeyboardHook;


procedure Register;

implementation

var
  DLLHandle: HMODULE;

procedure UnloadDLL;
begin
  DLLLoaded := False;

  if DLLHandle <> 0 then
  begin
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
    @StartKeyboardHook := nil;
    @StopKeyboardHook := nil;
  end;
end;

function LoadDLL(const FileName: string): Integer;
begin
  Result := 0;

  if DLLLoaded then
    Exit;

  DLLHandle := LoadLibraryEx(PChar(FileName), 0, 0);
  if DLLHandle <> 0 then
  begin
    DLLLoaded := True;

    @StartKeyboardHook := GetProcAddress(DLLHandle, 'EnableKeyboardHook');
    @StopKeyboardHook := GetProcAddress(DLLHandle, 'DisableKeyboardHook');

    if (@StartKeyboardHook = nil) or (@StopKeyboardHook = nil) then
    begin
      Result := 0;
      UnloadDLL;
      Exit;
    end;

    Result := 1;
  end
  else
    MessageBox(0, PChar(DEFDLLNAME + ' 不能被加载！'#13#10'请将该文件拷贝到应用程序目录下或system32目录下'),
      'Error', MB_ICONERROR);
end;


     //寻找指定进程,返回其ID.
function FindThread(ExeName: string): Longword;
       //(子函数)尾串是否匹配,不分大小写
  function AnsiEndsText(const ASubText, AText: string): Boolean;
  var
    P: PChar;
    L, L2: Integer;
  begin
    P := PChar(AText);
    L := Length(ASubText);
    L2 := Length(AText);
    Inc(P, L2 - L);
    if L > L2 then
      Result := False
    else
      Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE,P, L, PChar(ASubText), L) = 2;
  end;
var
  sphandle, sthandle: DWORD;
  Found: Bool;
  PStruct: TProcessEntry32;
  TStruct: TThreadEntry32;
begin
  Result := 0;
  sphandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    PStruct.dwSize := Sizeof(PStruct);
    TStruct.dwSize := Sizeof(TStruct);    
    Found := Process32First(sphandle, PStruct);
    while Found do begin
      if AnsiEndsText(ExeName, PStruct.szExefile) then begin
         sthandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
         try
           Found := Thread32First(sthandle, TStruct);
           while Found do begin
             if TStruct.th32OwnerProcessID = PStruct.th32ProcessID then begin
                Result := TStruct.th32ThreadID;
                Exit;
             end;
             Found := Thread32Next(sthandle, TStruct);
           end;
         finally
           CloseHandle(sthandle);
         end;
      end;
      Found := Process32Next(sphandle, PStruct);
    end;
  finally
    CloseHandle(sphandle);
  end;  
end;


{ TInputHook }

constructor TKeyboardHookBase.Create;
begin
  inherited Create(AOwner);

  pMapMem := nil;
  hMappingFile := 0;
  FHookedExe_TID := 0;
  FHookedExeName := '';  
  FBlocked := False;
  FDLLName := DEFDLLNAME;
end;

destructor TKeyboardHookBase.Destroy;
begin
  Stop;
  inherited;
end;

procedure TKeyboardHookBase.WndProc(var Message: TMessage);
begin
  if pMapMem = nil then
  begin
    hMappingFile := OpenFileMapping(FILE_MAP_WRITE, False, MappingFileName);
    if hMappingFile = 0 then
      MessageBox(0, '不能创建共享内存！', 'Error', MB_OK or MB_ICONERROR);
    pMapMem := MapViewOfFile(hMappingFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if pMapMem = nil then
    begin
      CloseHandle(hMappingFile);
      MessageBox(0, '不能映射共享内存！', 'Error', MB_OK or MB_ICONERROR);
    end;
  end;
  if pMapMem = nil then
    Exit;

  if (Message.Msg = WM_KEYDOWN) or (Message.Msg = WM_KEYUP) then
  begin
    Message.WParam := pMapMem.KeyCode;
    ProcessMessage(Message);
  end
  else
    Message.Result := DefWindowProc(FListenerHandle, Message.Msg, Message.wParam,
      Message.lParam);
end;

function TKeyboardHookBase.Start: BOOL;
var
  hookRes: Integer;
begin
  Result := False;
  
  if FHookedExe_TID = 0 then
     if FHookedExeName<>'' then begin
        FHookedExe_TID := FindThread(FHookedExeName);
        if FHookedExe_TID=0 then begin
           MessageBox(0, '指定的进程没有启动！', 'Info', MB_OK + MB_ICONERROR);
           Result := False;
           Exit;
        end;
    end;

  if (not FActive) and (not FDLLLoaded) then
  begin
    if FDLLName = '' then
    begin
      Result := False;
      Exit;
    end
    else
    begin
      hookRes := LoadDLL(FDLLName);
      if hookRes = 0 then
      begin
        Result := False;
        Exit;
      end
      else
      begin
        FListenerHandle := AllocateHWnd(WndProc);
        if FListenerHandle = 0 then
        begin
          Result := False;
          Exit;
        end
        else
        begin
          if StartKeyboardHook(FListenerHandle, FBlocked, FHookedExe_TID,PChar(FSysKey)) then
          begin
            Result := True;
            FDLLLoaded := True;
            FActive := True;
          end
          else
          begin
            Result := False;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TKeyboardHookBase.Stop;
begin
  if FActive then
  begin
    if FListenerHandle <> 0 then
    begin
      pMapMem := nil;
      if hMappingFile <> 0 then
      begin
        CloseHandle(hMappingFile);
        hMappingFile := 0;
      end;
      DeallocateHWnd(FListenerHandle);
      StopKeyboardHook;
      FListenerHandle := 0;
    end;
    UnloadDLL;
    FActive := False;
    FDLLLoaded := False;
  end;
end;

procedure TKeyboardHookBase.SetDLLName(const Value: string);
begin
  if FActive then
    MessageBox(0, 'HOOK状态下不能修改DLL文件名称！',
      'Info', MB_OK + MB_ICONERROR)
  else
    FDLLName := Value;
end;

procedure TKeyboardHookBase.SetHookedExeName(const Value: string);
begin
  if FActive then
    MessageBox(0, '请卸载钩子后再设置！', 'Info', MB_OK + MB_ICONERROR)
  else
    FHookedExeName := Value;
end;

procedure TKeyboardHookBase.SetBlocked(const Value: BOOL);
begin
  if FActive then
    MessageBox(0, 'HOOK状态下不能设置阻塞属性！',
      'Info', MB_OK + MB_ICONERROR)
  else
    FBlocked := Value;
end;

procedure TKeyboardHookBase.SetSyskey(const Value: string);
begin
    FSyskey := Value;
end;


{ TKeyboardHook }

procedure TKeyboardHook.DoKeyDown(const KeyCode: Integer);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(KeyCode);
end;

procedure TKeyboardHook.DoKeyUp(const KeyCode: Integer);
begin
  if Assigned(FOnKeyUp) then
    FOnKeyUp(KeyCode);
end;

procedure TKeyboardHook.ProcessMessage(var Message: TMessage);
begin
  if Message.Msg = WM_KEYDOWN then
  begin
    DoKeyDown(Message.WParam);
  end
  else if Message.Msg = WM_KEYUP then
  begin
    DoKeyUp(Message.WParam);
  end;
end;

procedure Register;
begin
  RegisterComponents('System', [TKeyboardHook])
end;


end.

