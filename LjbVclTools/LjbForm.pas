unit LjbForm;

interface

uses
  SysUtils, Classes, Controls, Forms,Dialogs;

type
  TLjbForm = class(TForm)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }

  end;

procedure Register;

implementation
procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbForm]);
end;



end.
