unit LjbGetAppPath;

interface
uses
   Classes,Forms,SysUtils;

type
    TLjbGetAppPath =class(TComponent)
  private

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    function GetAppPath():string;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbGetAppPath]);
end;
//--------------------------------------------------------------
function TLjbGetAppPath.GetAppPath():string;
begin
GetAppPath:= extractfilepath(application.exename);
end;
//--------------------------------------------------------------

end.
 