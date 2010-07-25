{*******************************************************}
{                                                       }
{  设置服务的启用和禁用                                 }
{  禁用服务(设置或取消 服务为手动启动)

设置的动作 0=禁用 1=手动 2=自动
ConfigService('服务名', 0, '服务描述');

启用服务：

ConfigService('服务名', 2, '服务描述');
{                                                       }
{*******************************************************}
unit LjbConfigService;
interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, WinSvc;

type
    TLjbConfigService = class(TComponent)
    private
    { Private declarations }
    protected
    { Protected declarations }
    public
    { Public declarations }
    published
        procedure ConfigService(ServiceName: string; iflag: integer; lpDesc: string);
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbConfigService]);
end;

procedure TLjbConfigService.ConfigService(ServiceName: string; iflag: integer; lpDesc: string);
type
    PQueryServiceLockStatus = ^TQueryServiceLockStatus;
const
    SERVICE_CONFIG_DESCRIPTION: DWord = 1;
var
    DynChangeServiceConfig2: function(
        hService: SC_HANDLE;
        dwInfoLevel: DWORD;
        lpInfo: Pointer): Bool; StdCall;

    sclLock: SC_LOCK;
    lpqslsBuf: PQueryServiceLockStatus;
    dwBytesNeeded, dwStartType: DWORD;
    schSCManager, schService: SC_Handle;
    aLibHndl: THandle;
    TempP: PChar;
    ret: boolean;
begin
    schSCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
    if schSCManager = 0 then
        raise Exception.Create(SysErrorMessage(GetLastError));
    sclLock := LockServiceDatabase(schSCManager);
    try
        if (sclLock = nil) then
        begin
            if (GetLastError() <> ERROR_SERVICE_DATABASE_LOCKED) then
                raise Exception.Create(SysErrorMessage(GetLastError));
            lpqslsBuf := PQueryServiceLockStatus(LocalAlloc(LPTR, sizeof(QUERY_SERVICE_LOCK_STATUS) + 256));
            if (lpqslsBuf = nil) then
                raise Exception.Create(SysErrorMessage(GetLastError));
            if not (QueryServiceLockStatus(
                schSCManager,
                lpqslsBuf^,
                sizeof(QUERY_SERVICE_LOCK_STATUS) + 256,
                dwBytesNeeded)) then
                raise Exception.Create(SysErrorMessage(GetLastError));

            if (lpqslsBuf^.fIsLocked > 0) then
            begin
                OutputDebugString(pchar('Locked by: ' + lpqslsBuf^.lpLockOwner +
                    ' duration: ' + IntToStr(lpqslsBuf^.dwLockDuration) + ' seconds'));
            end
            else
                OutputDebugString(pchar('No longer locked'));

            LocalFree(cardinal(lpqslsBuf));
            raise Exception.Create(SysErrorMessage(GetLastError));
        end;
        schService := OpenService(
            schSCManager,
            pchar(ServiceName),
            SERVICE_CHANGE_CONFIG);
        if (schService = 0) then
            raise Exception.Create(SysErrorMessage(GetLastError));

        try
            if iflag=0  then
                dwStartType := SERVICE_DISABLED;
            if iflag=1  then
                dwStartType := SERVICE_DEMAND_START;
            if iflag=2  then
                dwStartType := SERVICE_AUTO_START;                
            if not (ChangeServiceConfig(
                schService,
                SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS,
                dwStartType, SERVICE_NO_CHANGE, nil, nil, nil, nil, nil, nil, nil)) then
            begin
                raise Exception.Create(SysErrorMessage(GetLastError));
            end
            else
                OutputDebugString('ChangeServiceConfig SUCCESS');
            aLibHndl := GetModuleHandle(advapi32);
            ret := aLibHndl <> 0;
            if not ret then
                Exit;
            try
                DynChangeServiceConfig2 := GetProcAddress(aLibHndl, 'ChangeServiceConfig2A');
                ret := @DynChangeServiceConfig2 <> nil;
                if not ret then
                    Exit;
                TempP := PChar(lpDesc);
                ret := DynChangeServiceConfig2(schService, SERVICE_CONFIG_DESCRIPTION, @TempP);
                if not ret then
                    raise Exception.Create(SysErrorMessage(GetLastError))
                else
                    OutputDebugString('ChangeServiceConfig2 SUCCESS');
            finally
                FreeLibrary(aLibHndl);
            end;
        finally
            CloseServiceHandle(schService);
        end;
    finally
        UnlockServiceDatabase(sclLock);
        CloseServiceHandle(schService);
    end;
end;


end.

