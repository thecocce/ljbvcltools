unit LjbGetSysPath;

interface
uses
   Classes,Forms,SysUtils,Windows;

type
    TLjbGetSysPath =class(TComponent)
  private

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    function GetWindowsPath():string;
    function GetSystemPath():string;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbGetSysPath]);
end;
//--------------------------------------------------------------
function TLjbGetSysPath.GetWindowsPath():string;
var
    WinPath: pchar;
begin
    WinPath := stralloc(200);
    GetWindowsDirectory(WinPath, 255);
    GetWindowsPath := Winpath;
end;
//--------------------------------------------------------------
function TLjbGetSysPath.GetSystemPath():string;
var
    WinPath: pchar;
begin
    WinPath := stralloc(200);
    GetSystemDirectory(WinPath, 255);
    GetSystemPath := Winpath;
end;
//--------------------------------------------------------------
end.
 