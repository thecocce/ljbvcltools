unit LjbGetGuID;

interface
uses
    Classes, Forms, SysUtils, ActiveX, StdCtrls,Dialogs;

type
    TLjbGetGuID = class(TComponent)
    private

        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function GetGuID(): string;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbGetGuID]);
end;
//--------------------------------------------------------------

function TLjbGetGuID.GetGuID(): string;
var
    I: Integer;
    sGUID: string;
    TmpGUID: TGUID;
begin
    if CoCreateGUID(TmpGUID) = S_OK then
        sGUID := GUIDToString(TmpGUID)
    else
        ShowMessage('Create GUID error!');
    GetGuID := sGUID;
end;
//--------------------------------------------------------------

end.

