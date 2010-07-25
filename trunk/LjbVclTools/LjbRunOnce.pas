{*******************************************************}
{                                                       }
{  �ó���ֻ����һ��ʵ��,�� active ����Ϊ true����       }
{   ע��:��Ҫ�����ʱ����Ϊtrue�������ֹر�delphi���� }
{                                                       }
{*******************************************************}
unit LjbRunOnce;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TLjbRunOnce = class(TComponent)
  private
    { Private declarations }
    SActive: boolean;
    hmutex: Thandle;

procedure SetSActive(Value: boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }
    //constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Active: boolean read SActive write SetSActive default False;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LjbTools', [TLjbRunOnce]);
end;

procedure TLjbRunOnce.SetSActive(Value: boolean);
begin
  SActive := Value;
  if Value then
  begin
    try
      hmutex := openmutex(MUTEX_ALL_ACCESS, False, pchar(Application.title));
      if hmutex = 0 then
      begin
        inherited;
        hmutex := CreateMutex(nil, False, pchar(Application.title));
        ReleaseMutex(hmutex);
      end
      else
      begin
        Application.MessageBox('Sorry,�����Ѿ���������Ӵ!�����ٴ�������!!!',
          '��ʾ', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
        Application.Terminate;
      end;
    finally
    end;
  end;
end;

end.

