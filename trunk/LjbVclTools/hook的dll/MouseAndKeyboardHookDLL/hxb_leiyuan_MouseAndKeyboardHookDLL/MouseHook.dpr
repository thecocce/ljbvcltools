library MouseHook;

uses
  Windows, Messages;

const
  MappingFileName      = '57D6A971_MouseHookDLL_442C0DB1';
  MSGMOUSEMOVE: PChar  = 'MSGMOUSEMOVE57D6A971-049B-45AF-A8CD-37E0B706E036';
  MSGMOUSECLICK: PChar = 'MSGMOUSECLICK442C0DB1-3198-4C2B-A718-143F6E2D1760';

type
  TMappingMem = record
    Handle: DWORD;
    MsgID: DWORD;
    MouseStruct: TMOUSEHOOKSTRUCT;
    Blocked: Boolean;
  end;
  PMappingMem = ^TMappingMem;

var
  hMappingFile: THandle;
  pMapMem: PMappingMem;
  mhook: HHook;
  //CriticalSection: TRTLCriticalSection;

function MouseHookProc(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall
begin
  pMapMem^.MsgID := wParam;
  pMapMem^.MouseStruct := pMOUSEHOOKSTRUCT(lparam)^;
  SendMessage(pMapMem^.Handle, pMapMem^.MsgID, 0, 0);
  
  if pMapMem^.Blocked then begin
     Result := 1;
  end
  else begin
     Result := CallNextHookEx(mhook, iCode, wParam, lParam);
  end;
end;

function EnableMouseHook(hWindow: HWND; Blocked: BOOL; TID: Longword): BOOL; stdcall;
var
  PID: Longword;
begin
  Result := False;
  if mhook <> 0 then Exit;

  pMapMem^.Handle := hWindow;
  pMapMem^.Blocked := Blocked;

  mhook := SetWindowsHookEx(WH_MOUSE, MouseHookProc, HInstance,  TID);
  Result := mhook <> 0;
end;

function DisableMouseHook: BOOL; stdcall;
begin
  if mhook <> 0 then begin
    UnhookWindowshookEx(mhook);
    mhook := 0;
  end;
  Result := mhook = 0;
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
          MessageBox(0, '¥¥Ω®π≤œÌƒ⁄¥Ê ß∞‹£°', 'Error', MB_OK or MB_ICONERROR);

        pMapMem := MapViewOfFile(hMappingFile, FILE_MAP_WRITE or FILE_MAP_READ,
          0, 0, 0);
        if pMapMem = nil then
        begin
          CloseHandle(hMappingFile);
          MessageBox(0, '”≥…‰π≤œÌƒ⁄¥Ê ß∞‹£°', 'Error', MB_OK or MB_ICONERROR);
        end;
        mhook := 0;
      end;

    DLL_PROCESS_DETACH:
      begin
        UnMapViewOfFile(pMapMem);
        CloseHandle(hMappingFile);
        if mhook <> 0 then
          DisableMouseHook;
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
  EnableMouseHook,
  DisableMouseHook;

begin
  DisableThreadLibraryCalls(HInstance);
  DLLProc := @DLLMain;
  DLLMain(DLL_PROCESS_ATTACH);
end.

