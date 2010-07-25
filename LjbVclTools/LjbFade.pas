unit LjbFade;

interface
uses
   Classes,Forms,SysUtils,ComObj,Controls,Windows;

type
    TLjbFade =class(TComponent)
  private

    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    procedure FadeIn(handle:HWnd;time:Integer);
    procedure FadeOut(handle:HWnd;time:Integer);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbFade]);
end;
//--------------------------------------------------------------
procedure TLjbFade.FadeIn(handle:HWnd;time:Integer);
begin
    AnimateWindow(handle,time,AW_BLEND);
end;
//--------------------------------------------------------------
procedure TLjbFade.FadeOut(handle:HWnd;time:Integer);
begin
    AnimateWindow(handle,time,AW_HIDE or AW_BLEND);
end;

end.
 