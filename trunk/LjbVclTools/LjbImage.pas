unit LjbImage;

interface
{$R ljbTools.dcr}
uses
    SysUtils, Classes, Controls, ExtCtrls, Messages;

type
    TLjbImage = class(TImage)
    private
        FOnMouseLeave:TNotifyEvent;
        FOnMouseEnter:TNotifyEvent;
        procedure MouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
        procedure MouseEnter(var Msg:TMessage); message CM_MOUSEEnter;
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        property OnMouseLeave:TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
        property OnMouseEnter:TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbImage]);
end;

procedure TLjbImage.MouseEnter(var Msg:TMessage);
begin
    inherited; //ºÃ≥–∏∏¿‡
    if csLButtonDown in ControlState then
    begin
        Self.MouseUp(mbLeft, [ssLeft], 0, 0);
    end;
    if Assigned(FonMouseEnter) then FOnMouseEnter(Self);
end;

procedure TLjbImage.MouseLeave(var Msg:TMessage);
begin
    inherited; //ºÃ≥–∏∏¿‡
    if csLButtonDown in ControlState then
    begin
        Self.MouseUp(mbLeft, [ssLeft], 0, 0);
    end;
    if Assigned(FonMouseLeave) then FOnMouseLeave(Self);
end;

end.

