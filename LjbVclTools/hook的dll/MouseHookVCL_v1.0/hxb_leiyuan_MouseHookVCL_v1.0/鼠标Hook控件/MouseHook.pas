{

 MouseHook DLL Load & TMouseHook Class Unit
 
 2005-03-27

 Copyright ? ������ ��ɳ�����Ƽ���ѧ Email: hxb_leiyuan2000@163.net QQ: 478522325 

}

unit MouseHook;

interface

uses
  Windows, Messages, Classes, TlHelp32, SysUtils;

const
  DEFDLLNAME = 'mousehook.dll';
  MappingFileName = '57D6A971_MouseHookDLL_442C0DB1';

type
  // ȫ��ӳ���ļ�, ���û��TMappingMem, hook��ֻ�Ա�����������
  TMappingMem = record
    Handle: DWORD;
    MsgID: DWORD;
    MouseStruct: TMOUSEHOOKSTRUCT;
    Blocked: Boolean;
  end;
  PMappingMem = ^TMappingMem;

  // ����ԭ��
  TEnableMouseHook = function(hWindow: HWND; Blocked: BOOL; TID: Longword): BOOL; stdcall;
  TDisableMouseHook = function: BOOL; stdcall;

  // �¼�����
  TMouseCaptureChangedNotify   = procedure(const Handle: HWND) of object;
  TMouseLButtonDBClickNotify   = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseLButtonDownNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseLButtonUpNotify        = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseRButtonDBClickNotify   = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseRButtonDownNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseRButtonUpNotify        = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseMButtonDBClickNotify   = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseMButtonDownNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseMButtonUpNotify        = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCLButtonDBClickNotify = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCLButtonDownNotify    = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCLButtonUpNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCRButtonDBClickNotify = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCRButtonDownNotify    = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCRButtonUpNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCMButtonDBClickNotify = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCMButtonDownNotify    = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCMButtonUpNotify      = procedure(const Handle: HWND; const X, Y: Integer) of object;

  TMouseMoveNotify             = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseWheelNotify            = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCMoveNotify           = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseActivateNotify         = procedure(const Handle: HWND; const X, Y: Integer) of object;
  TMouseNCHitTestNotify        = procedure(const Handle: HWND; const X, Y: Integer) of object;

  // ����
  TMouseHookBase = class(TComponent)
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
    procedure WndProc(var Message: TMessage);     
    procedure SetDLLName(const Value: string);
    procedure SetHookedExeName(const Value: string);
    procedure SetBlocked(const Value: BOOL);
  protected
    // ��Ϣ���¼�
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
  end;

  // ����TMouseHook, ֻ�ṩ�¼��ӿ�ʵ��
  TMouseHook = class(TMouseHookBase)
  private
    FOnMouseCaptureChanged   : TMouseCaptureChangedNotify;
    FOnMouseLButtonDBClick   : TMouseLButtonDBClickNotify;
    FOnMouseLButtonDown      : TMouseLButtonDownNotify;
    FOnMouseLButtonUp        : TMouseLButtonUpNotify;
    FOnMouseRButtonDBClick   : TMouseRButtonDBClickNotify;
    FOnMouseRButtonDown      : TMouseRButtonDownNotify;
    FOnMouseRButtonUp        : TMouseRButtonUpNotify;
    FOnMouseMButtonDBClick   : TMouseMButtonDBClickNotify;
    FOnMouseMButtonDown      : TMouseMButtonDownNotify;
    FOnMouseMButtonUp        : TMouseMButtonUpNotify;
    FOnMouseNCLButtonDBClick : TMouseNCLButtonDBClickNotify;
    FOnMouseNCLButtonDown    : TMouseNCLButtonDownNotify;
    FOnMouseNCLButtonUp      : TMouseNCLButtonUpNotify;
    FOnMouseNCRButtonDBClick : TMouseNCRButtonDBClickNotify;
    FOnMouseNCRButtonDown    : TMouseNCRButtonDownNotify;
    FOnMouseNCRButtonUp      : TMouseNCRButtonUpNotify;
    FOnMouseNCMButtonDBClick : TMouseNCMButtonDBClickNotify;
    FOnMouseNCMButtonDown    : TMouseNCMButtonDownNotify;
    FOnMouseNCMButtonUp      : TMouseNCMButtonUpNotify;

    FOnMouseMove             : TMouseMoveNotify;
    FOnMouseWheel            : TMouseWheelNotify;
    FOnMouseNCMove           : TMouseNCMoveNotify;
    FOnMouseActivate         : TMouseActivateNotify;
    FOnMouseNCHitTest        : TMouseNCHitTestNotify;

    procedure DoMouseCaptureChanged(const Handle: HWND);
    procedure DoMouseLButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseLButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseLButtonUp(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseRButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseRButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseRButtonUp(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseMButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseMButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseMButtonUp(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCLButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCLButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCLButtonUp(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCRButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCRButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCRButtonUp(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCMButtonDBClick(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCMButtonDown(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCMButtonUp(const Handle: HWND; const X, Y: Integer);

    procedure DoMouseMove(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseWheel(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCMove(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseActivate(const Handle: HWND; const X, Y: Integer);
    procedure DoMouseNCHitTest(const Handle: HWND; const X, Y: Integer);

  protected
    procedure ProcessMessage(var Message: TMessage); override;
  public

  published
    //property DLLName;
    property Blocked;
    property HookedExeName;
    property OnMouseCaptureChange    : TMouseCaptureChangedNotify read FOnMouseCaptureChanged write FOnMouseCaptureChanged;
    property OnMouseLButtonDBClick   : TMouseLButtonDBClickNotify read FOnMouseLButtonDBClick write FOnMouseLButtonDBClick;
    property OnMouseLButtonDown      : TMouseLButtonDownNotify read FOnMouseLButtonDown write FOnMouseLButtonDown;
    property OnMouseLButtonUp        : TMouseLButtonUpNotify read FOnMouseLButtonUp write FOnMouseLButtonUp;
    property OnMouseRButtonDBClick   : TMouseRButtonDBClickNotify read FOnMouseRButtonDBClick write FOnMouseRButtonDBClick;
    property OnMouseRButtonDown      : TMouseRButtonDownNotify read FOnMouseRButtonDown write FOnMouseRButtonDown;
    property OnMouseRButtonUp        : TMouseRButtonUpNotify read FOnMouseRButtonUp write FOnMouseRButtonUp;
    property OnMouseMButtonDBClick   : TMouseMButtonDBClickNotify read FOnMouseMButtonDBClick write FOnMouseMButtonDBClick;
    property OnMouseMButtonDown      : TMouseMButtonDownNotify read FOnMouseMButtonDown write FOnMouseMButtonDown;
    property OnMouseMButtonUp        : TMouseMButtonUpNotify read FOnMouseMButtonUp write FOnMouseMButtonUp;
    property OnMouseNCLButtonDBClick : TMouseNCLButtonDBClickNotify read FOnMouseNCLButtonDBClick write FOnMouseNCLButtonDBClick;
    property OnMouseNCLButtonDown    : TMouseNCLButtonDownNotify read FOnMouseNCLButtonDown write FOnMouseNCLButtonDown;
    property OnMouseNCLButtonUp      : TMouseNCLButtonUpNotify read FOnMouseNCLButtonUp write FOnMouseNCLButtonUp;
    property OnMouseNCRButtonDBClick : TMouseNCRButtonDBClickNotify read FOnMouseNCRButtonDBClick write FOnMouseNCRButtonDBClick;
    property OnMouseNCRButtonDown    : TMouseNCRButtonDownNotify read FOnMouseNCRButtonDown write FOnMouseNCRButtonDown;
    property OnMouseNCRButtonUp      : TMouseNCRButtonUpNotify read FOnMouseNCRButtonUp write FOnMouseNCRButtonUp;
    property OnMouseNCMButtonDBClick : TMouseNCMButtonDBClickNotify read FOnMouseNCMButtonDBClick write FOnMouseNCMButtonDBClick;
    property OnMouseNCMButtonDown    : TMouseNCMButtonDownNotify read FOnMouseNCMButtonDown write FOnMouseNCMButtonDown;
    property OnMouseNCMButtonUp      : TMouseNCMButtonUpNotify read FOnMouseNCMButtonUp write FOnMouseNCMButtonUp;

    property OnMouseMove             : TMouseMoveNotify read FOnMouseMove write FOnMouseMove;
    property OnMouseWheel            : TMouseWheelNotify read FOnMouseWheel write FOnMouseWheel;
    property OnMouseNCMove           : TMouseNCMoveNotify read FOnMouseNCMove write FOnMouseNCMove;
    property OnMouseActivate         : TMouseActivateNotify read FOnMouseActivate write FOnMouseActivate;
    property OnMouseNCHitTest        : TMouseNCHitTestNotify read FOnMouseNCHitTest write FOnMouseNCHitTest;

  end;

var
  // ȫ�ֱ���
  DLLLoaded: BOOL = False;

  StartMouseHook: TEnableMouseHook;
  StopMouseHook: TDisableMouseHook;

procedure Register;

implementation

var
  DLLHandle: HMODULE;

procedure UnloadDLL;                    // ж��dll
begin
  DLLLoaded := False;

  if DLLHandle <> 0 then begin
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
    // �ͷź���ָ��
    @StartMouseHook := nil;
    @StopMouseHook := nil;
  end;
end;

function LoadDLL(const FileName: string): Integer; // ����dll
begin
  Result := 0;

  if DLLLoaded then
    Exit;

  DLLHandle := LoadLibraryEx(PChar(FileName), 0, 0);
  if DLLHandle <> 0 then begin
    DLLLoaded := True;

    // ���ݺ���ָ��
    @StartMouseHook := GetProcAddress(DLLHandle, 'EnableMouseHook');
    @StopMouseHook := GetProcAddress(DLLHandle, 'DisableMouseHook');

    if (@StartMouseHook = nil) or (@StopMouseHook = nil) then begin
      Result := 0;
      UnloadDLL;
      Exit;
    end;

    Result := 1;
  end
  else
    MessageBox(0, PChar(DEFDLLNAME + ' ���ܱ����أ�'#13#10'�뽫���ļ�������Ӧ�ó���Ŀ¼�»�system32Ŀ¼��'),
      'Error', MB_ICONERROR);
end;

     //Ѱ��ָ������,������ID.
function FindThread(ExeName: string): Longword;
       //(�Ӻ���)β���Ƿ�ƥ��,���ִ�Сд
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

constructor TMouseHookBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  pMapMem := nil;
  hMappingFile := 0;
  FHookedExe_TID := 0;
  FHookedExeName := '';  
  FBlocked := False;
  FDLLName := DEFDLLNAME;
end;

destructor TMouseHookBase.Destroy;
begin
  Stop;
  inherited;
end;

procedure TMouseHookBase.WndProc(var Message: TMessage);
begin
  if pMapMem = nil then begin
    hMappingFile := OpenFileMapping(FILE_MAP_WRITE, False, MappingFileName);
    if hMappingFile = 0 then
      MessageBox(0, '���ܴ��������ڴ棡', 'Error', MB_OK or MB_ICONERROR);
    pMapMem := MapViewOfFile(hMappingFile, FILE_MAP_WRITE or FILE_MAP_READ, 0, 0, 0);
    if pMapMem = nil then begin
      CloseHandle(hMappingFile);
      MessageBox(0, '����ӳ�乲���ڴ棡', 'Error', MB_OK or MB_ICONERROR);
    end;
  end;
  if pMapMem = nil then
    Exit;

  // ��Ϣ����
  case Message.Msg of
        WM_LBUTTONDBLCLK,   WM_LBUTTONDOWN,   WM_LBUTTONUP,
        WM_RBUTTONDBLCLK,   WM_RBUTTONDOWN,   WM_RBUTTONUP,
        WM_MBUTTONDBLCLK,   WM_MBUTTONDOWN,   WM_MBUTTONUP,
        WM_NCLBUTTONDBLCLK, WM_NCLBUTTONDOWN, WM_NCLBUTTONUP,
        WM_NCRBUTTONDBLCLK, WM_NCRBUTTONDOWN, WM_NCRBUTTONUP,
        WM_NCMBUTTONDBLCLK, WM_NCMBUTTONDOWN, WM_NCMBUTTONUP,
        WM_MOUSEMOVE,       WM_MOUSEWHEEL,    WM_NCMOUSEMOVE,
        WM_MOUSEACTIVATE,   WM_NCHITTEST,     WM_CAPTURECHANGED:
            begin
              Message.WParam := pMapMem.MouseStruct.hwnd;
              Message.LParam := (pMapMem.MouseStruct.pt.X and $FFFF) or (pMapMem.MouseStruct.pt.Y shl 16);
              ProcessMessage(Message);              
            end;
        {WM_MOUSEMOVE, WM_NCMouseMove,
        WM_LBUTTONDOWN, WM_LBUTTONUP, WM_LBUTTONDBLCLK,
        WM_NCLBUTTONDOWN,
        WM_RBUTTONDOWN, WM_RBUTTONUP, WM_RBUTTONDBLCLK,
        WM_MBUTTONDOWN, WM_MBUTTONUP, WM_MBUTTONDBLCLK:
       begin
         Message.WParam := pMapMem.MouseStruct.hwnd;
         Message.LParam := (pMapMem.MouseStruct.pt.X and $FFFF) or (pMapMem.MouseStruct.pt.Y shl 16);
         ProcessMessage(Message);
       end;}
  else
    // ����Ҫ�������Ϣ����OSĬ�ϴ�����
    Message.Result := DefWindowProc(FListenerHandle, Message.Msg, Message.wParam,
      Message.lParam);
  end;    
end;

function TMouseHookBase.Start: BOOL;
var
  hookRes: Integer;
begin
  Result := False;
  
  if FHookedExe_TID = 0 then
     if FHookedExeName<>'' then begin
        FHookedExe_TID := FindThread(FHookedExeName);
        if FHookedExe_TID=0 then begin
           MessageBox(0, 'ָ���Ľ���û��������', 'Info', MB_OK + MB_ICONERROR);
           Result := False;
           Exit;
        end;
    end;


  if (not FActive) and (not FDLLLoaded) then begin
    if FDLLName = '' then begin
      Result := False;
      Exit;
    end
    else begin
      hookRes := LoadDLL(FDLLName);
      if hookRes = 0 then begin
        Result := False;
        Exit;
      end
      else begin
        // ���ǹؼ�����, ͨ��AllocateHWnd����һ�����ɼ��Ĵ���, ��ʵ��������Ϣ����ת
        // ͨ��TMouseHookBase��WndProc��ʵ�ֶ���Ϣ����Ӧ
        FListenerHandle := AllocateHWnd(WndProc);
        if FListenerHandle = 0 then begin
          Result := False;
          Exit;
        end
        else begin
          if StartMouseHook(FListenerHandle, FBlocked, FHookedExe_TID) then begin
            Result := True;
            FDLLLoaded := True;
            FActive := True;
          end
          else begin
            Result := False;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMouseHookBase.Stop;
begin
  if FActive then begin
    if FListenerHandle <> 0 then begin
      pMapMem := nil;
      if hMappingFile <> 0 then begin
        CloseHandle(hMappingFile);
        hMappingFile := 0;
      end;
      DeallocateHWnd(FListenerHandle);
      StopMouseHook;
      FListenerHandle := 0;
    end;
    UnloadDLL;
    FActive := False;
    FDLLLoaded := False;
    FHookedExe_TID := 0;
  end;
end;

procedure TMouseHookBase.SetDLLName(const Value: string);
begin
  if FActive then
    MessageBox(0, 'HOOK״̬�²����޸�DLL�ļ����ƣ�',
      'Info', MB_OK + MB_ICONERROR)
  else
    FDLLName := Value;
end;

procedure TMouseHookBase.SetHookedExeName(const Value: string);
begin
  if FActive then
    MessageBox(0, '��ж�ع��Ӻ������ã�', 'Info', MB_OK + MB_ICONERROR)
  else
    FHookedExeName := Value;
end;

procedure TMouseHookBase.SetBlocked(const Value: BOOL);
begin
  if FActive then
    MessageBox(0, 'HOOK״̬�²��������������ԣ�',
      'Info', MB_OK + MB_ICONERROR)
  else
    FBlocked := Value;
end;

{ TMouseHook }

procedure TMouseHook.DoMouseCaptureChanged(const Handle: HWND);
begin
  if Assigned(FOnMouseCaptureChanged) then
    FOnMouseCaptureChanged(Handle);
end;

procedure TMouseHook.DoMouseLButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseLButtonDBClick) then
    FOnMouseLButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseLButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseLButtonDown) then
    FOnMouseLButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseLButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseLButtonUp) then
    FOnMouseLButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseRButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseRButtonDBClick) then
    FOnMouseRButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseRButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseRButtonDown) then
    FOnMouseRButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseRButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseRButtonUp) then
    FOnMouseRButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseMButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseMButtonDBClick) then
    FOnMouseMButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseMButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseMButtonDown) then
    FOnMouseMButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseMButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseMButtonUp) then
    FOnMouseMButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCLButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCLButtonDBClick) then
    FOnMouseNCLButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCLButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCLButtonDown) then
    FOnMouseNCLButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCLButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCLButtonUp) then
    FOnMouseNCLButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCRButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCRButtonDBClick) then
    FOnMouseNCRButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCRButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCRButtonDown) then
    FOnMouseNCRButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCRButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCRButtonUp) then
    FOnMouseNCRButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCMButtonDBClick(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCMButtonDBClick) then
    FOnMouseNCMButtonDBClick(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCMButtonDown(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCMButtonDown) then
    FOnMouseNCMButtonDown(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCMButtonUp(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCMButtonUp) then
    FOnMouseNCMButtonUp(Handle, X, Y);
end;

procedure TMouseHook.DoMouseMove(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Handle, X, Y);
end;

procedure TMouseHook.DoMouseWheel(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseWheel) then
    FOnMouseWheel(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCMove(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCMove) then
    FOnMouseNCMove(Handle, X, Y);
end;

procedure TMouseHook.DoMouseActivate(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseActivate) then
    FOnMouseActivate(Handle, X, Y);
end;

procedure TMouseHook.DoMouseNCHitTest(const Handle: HWND; const X, Y: Integer);
begin
  if Assigned(FOnMouseNCHitTest) then
    FOnMouseNCHitTest(Handle, X, Y);
end;


procedure TMouseHook.ProcessMessage(var Message: TMessage);
begin

  case Message.Msg of
     WM_CAPTURECHANGED : DoMouseCaptureChanged(Message.WParam);
     WM_LBUTTONDBLCLK  : DoMouseLButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_LBUTTONDOWN    : DoMouseLButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_LBUTTONUP      : DoMouseLButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_RBUTTONDBLCLK  : DoMouseRButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_RBUTTONDOWN    : DoMouseRButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_RBUTTONUP      : DoMouseRButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_MBUTTONDBLCLK  : DoMouseMButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_MBUTTONDOWN    : DoMouseMButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_MBUTTONUP      : DoMouseMButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCLBUTTONDBLCLK: DoMouseNCLButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCLBUTTONDOWN  : DoMouseNCLButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCLBUTTONUP    : DoMouseNCLButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCRBUTTONDBLCLK: DoMouseNCRButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCRBUTTONDOWN  : DoMouseNCRButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCRBUTTONUP    : DoMouseNCRButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCMBUTTONDBLCLK: DoMouseNCMButtonDBClick(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCMBUTTONDOWN  : DoMouseNCMButtonDown(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCMBUTTONUP    : DoMouseNCMButtonUp(Message.WParam, Message.LParamLo, Message.LParamHi);

     WM_MOUSEMOVE      : DoMouseMove(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_MOUSEWHEEL     : DoMouseWheel(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCMOUSEMOVE    : DoMouseNCMove(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_MOUSEACTIVATE  : DoMouseActivate(Message.WParam, Message.LParamLo, Message.LParamHi);
     WM_NCHITTEST      : DoMouseNCHitTest(Message.WParam, Message.LParamLo, Message.LParamHi);

  end;
end;


procedure Register;
begin
  RegisterComponents('System', [TMouseHook])
end;

end.


