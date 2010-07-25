library KeyboardHook;

uses
    Windows, Messages, Classes, SysUtils;

const
    MappingFileName = 'keybord_hook_46772A5A-1905-455F-AB55-E8D1E706E7D0';
    MSGKEYDOWN: PChar = 'MSGKEYDOWN57D6A971-049B-45AF-A8CD-37E0B706E036';
    MSGKEYUP: PChar = 'MSGKEYUP442C0DB1-3198-4C2B-A718-143F6E2D1760';

type
    TMappingMem = record
        Handle: DWORD;
        MsgID: DWORD;
        KeyCode: DWORD;
        Blocked: Boolean;
    end;
    PMappingMem = ^TMappingMem;

    tagKBDLLHOOKSTRUCT = packed record
        vkCode: DWORD; //虚拟键值
        scanCode: DWORD; //扫描码值
    {一些扩展标志，这个值比较麻烦，MSDN上说得也不太明白，但是
    根据这个程序，这个标志值的第六位数（二进制）为1时ALT键按下为0相反。}
        flags: DWORD;
        time: DWORD; //消息时间戳
        dwExtraInfo: DWORD; //和消息相关的扩展信息
    end;

    KBDLLHOOKSTRUCT = tagKBDLLHOOKSTRUCT;
    PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

var
  //MSG_KEYDOWN: UINT;
  //MSG_KEYUP: UINT;
    hMappingFile: THandle;
    pMapMem: PMappingMem;
    khook: HHook;
  //CriticalSection: TRTLCriticalSection;
    keyList: TStringList;

const
    WH_KEYBOARD_LL = 13;

function SplitString(const source, ch: string): TStringList; //从分隔符中分离出字符串 比如 a,bcad,c 中分离出
var
    temp: string;
    i: integer;
begin
    result := TStringList.Create;
    temp := source;
    i := pos(ch, source);
    while i <> 0 do
    begin
        result.Add(copy(temp, 0, i - 1));
        delete(temp, 1, i);
        i := pos(ch, temp);
    end;
    result.Add(temp);
end;

function KeyboardHookProc(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall
const
    _keypressmask = $80000000;
var
    p: PKBDLLHOOKSTRUCT;
    isKey: Boolean; //是否是需要的按键
    i: integer;
    keyList_num: TStringList;
begin
  {pMapMem^.MsgID := wParam;
  pMapMem^.KeyCode := wParam;
  SendMessage(pMapMem^.Handle, pMapMem^.MsgID, 0, 0);
  }
{$I .\include\VMProtectBegin.inc}
    isKey := True;
    p := PKBDLLHOOKSTRUCT(lParam);
    if iCode = HC_ACTION then
    begin
        pMapMem^.KeyCode := p.vkCode;

        keyList_num := TStringList.Create;

        for i := 0 to keyList.count - 1 do // 将字符弄键值映射成具体的ascII码
        begin
            if Trim(keyList[0]) <> '' then
            begin
                if keyList[i] = 'VK_CONTROL' then keyList_num.Add(IntToStr(17)); //ctrl
                if keyList[i] = 'VK_MENU' then keyList_num.Add(IntToStr(18)); //alt
                if keyList[i] = 'VK_SHIFT' then keyList_num.Add(IntToStr($10)); //shift
                if keyList[i] = 'VK_LWIN' then keyList_num.Add(IntToStr(91)); //Left win
            end;
        end;

        for i := 0 to keyList.count - 1 do
        begin
            if Trim(keyList[0]) <> '' then
            begin
                if (GetAsyncKeyState(StrToInt(keyList_num[i])) < 0) then //如果需要的按键在已经按下的按键当中
                    isKey := True
                else
                begin
                    isKey := False;
                    Break;
                end;
            end;
        end;

        if isKey and ((lparam and _keypressmask) = 0) then
        begin
            case wParam of
                WM_KEYDOWN,
                    WM_SYSKEYDOWN:
                    begin
                        pMapMem^.MsgID := WM_KEYDOWN; //MSG_KEYDOWN;
                        SendMessage(pMapMem^.Handle, pMapMem^.MsgID, 0, 0);
                    end;
            end;

            case wParam of
                WM_KEYUP,
                    WM_SYSKEYUP:
                    begin
                        pMapMem^.MsgID := WM_KEYUP; //MSG_KEYUP;
                        SendMessage(pMapMem^.Handle, pMapMem^.MsgID, 0, 0);
                    end;
            end;
        end;
    end;

    if pMapMem^.Blocked then begin
        Result := 1;
    end
    else begin
        Result := CallNextHookEx(khook, iCode, wParam, lParam);
    end;
{$I .\include\VMProtectEnd.inc}

end;

function EnableKeyboardHook(hWindow: HWND; Blocked: BOOL; TID: Longword; OtherKeys: PChar): BOOL; stdcall;
begin
    Result := False;
    if khook <> 0 then Exit;

    pMapMem^.Handle := hWindow;
    pMapMem^.Blocked := Blocked;

    keyList := TStringList.Create;
    keyList.Assign(SplitString(OtherKeys, ','));


  //khook := SetWindowsHookEx(WH_KEYBOARD, KeyboardHookProc, HInstance,  TID); //设置高级钩子这个不爽
    khook := SetWindowsHookExW(WH_KEYBOARD_LL, KeyboardHookProc, Hinstance, TID); //设置底级钩子
    Result := khook <> 0;
end;

function DisableKeyboardHook: BOOL; stdcall;
begin
    if khook <> 0 then
    begin
        UnhookWindowshookEx(khook);
        khook := 0;
    end;
    Result := khook = 0;
end;

procedure DllMain(dwReason: DWORD);
begin
    case dwReason of
        DLL_PROCESS_ATTACH:
            begin
        //InitializeCriticalSection(CriticalSection);
                hMappingFile := OpenFileMapping(FILE_MAP_WRITE, False, MappingFileName);
                if hMappingFile = 0 then
                begin
                    hMappingFile := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE,
                        0, SizeOf(TMappingMem), MappingFileName);
                end;
                if hMappingFile = 0 then
                    MessageBox(0, '创建共享内存失败！', 'Error', MB_OK or MB_ICONERROR);

                pMapMem := MapViewOfFile(hMappingFile, FILE_MAP_WRITE or FILE_MAP_READ,
                    0, 0, 0);
                if pMapMem = nil then
                begin
                    CloseHandle(hMappingFile);
                    MessageBox(0, '映射共享内存失败！', 'Error', MB_OK or MB_ICONERROR);
                end;
                khook := 0;
            end;
        DLL_PROCESS_DETACH:
            begin
                UnMapViewOfFile(pMapMem);
                CloseHandle(hMappingFile);
                if khook <> 0 then
                    DisableKeyboardHook;
        //DeleteCriticalSection(CriticalSection);
            end;
        DLL_THREAD_ATTACH:
            begin
            end;
        DLL_THREAD_DETACH:
            begin
            end;
    end;
end;

exports
    EnableKeyboardHook,
    DisableKeyboardHook;

begin
    DisableThreadLibraryCalls(HInstance);
    DLLProc := @DLLMain;
    DLLMain(DLL_PROCESS_ATTACH);
end.

