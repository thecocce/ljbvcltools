unit MySum;

interface
uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Messages;

const
  // User-defined message
  WM_SUMFINISH = WM_USER + 1025;

type
  TMySum = class(TComponent)
    procedure SendIt;
  private
    FOnSumFinish: TNotifyEvent;
    procedure SumFinish(var Message: TMessage); message WM_SUMFINISH;
  published
    property OnSumFinish: TNotifyEvent read FOnSumFinish write FOnSumFinish;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TMySum]);
end;

procedure TMySum.SendIt;
begin

  SendMessage(Parent.Handle, WM_SUMFINISH, 0, 0);

end;

procedure TMySum.SumFinish(var Message: TMessage);
begin
  inherited;
  // TODO -cMM: TMySum.SumFinish default body inserted
end;

end.

