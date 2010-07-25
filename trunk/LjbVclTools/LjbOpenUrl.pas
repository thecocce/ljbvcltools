unit LjbOpenUrl;

interface
uses
   Classes,Forms,SysUtils,ComObj;

type
    TLjbOpenUrl =class(TComponent)
  private

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    procedure OpenUrl(url:string);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbOpenUrl]);
end;
//--------------------------------------------------------------
procedure TLjbOpenUrl.OpenUrl(url:string);
var 
 IEApp: Variant; 
begin
 IEApp := CreateOLEObject('InternetExplorer.Application'); 
 IEApp.visible := true;
 //IEApp.Top := 0;
 //IEApp.Left := 0;
 //IEApp.width := screen.width;
 //IEApp.height := screen.height;
 IEApp.Navigate(url);
end;
//--------------------------------------------------------------

end.
 