{*******************************************************}
{                                                       }
{  É±µô½ø³Ì       }
{    }
{                                                       }
{*******************************************************}
unit LjbKill;
interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,tlhelp32;

type
    TLjbKill = class(TComponent)
    private
    { Private declarations }
    protected
    { Protected declarations }
    public
    { Public declarations }
        function KillTask(ExeFileName: string): integer;
    published
    { Published declarations }
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbKill]);
end;

function TLjbKill.KillTask(ExeFileName: string): integer;
const
    PROCESS_TERMINATE = $0001;
var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
begin
    result := 0;
    FSnapshotHandle := CreateToolhelp32Snapshot
        (TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle,
        FProcessEntry32);
    while integer(ContinueLoop) <> 0 do
    begin
        if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
            = UpperCase(ExeFileName))
            or (UpperCase(FProcessEntry32.szExeFile)
            = UpperCase(ExeFileName))) then
            Result := Integer(TerminateProcess(OpenProcess(
                PROCESS_TERMINATE, BOOL(0),
                FProcessEntry32.th32ProcessID), 0));
        ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
end;

end.

