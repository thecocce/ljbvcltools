unit CustomDialogs;


interface


uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,

  Dialogs;


type

  TInsertTextEvent = procedure(Sender : TObject; Text: string) of object;

  TInsertTextDialog = class(TForm)

  private

    FOnInsertText : TInsertTextEvent;

  protected

    procedure DoInsertText(Text : string);

  end;

  TInsertTextDialogClass = class of TInsertTextDialog;


  TGetTextEvent = procedure(Sender : TObject; var Text: string; Selection : Boolean) of object;

  TSetTextEvent = procedure(Sender : TObject; const Text: string; Selection : Boolean) of object;

  TReplaceTextDialog = class(TForm)

  private

    FOnGetText : TGetTextEvent;

    FOnSetText : TSetTextEvent;

  protected

    procedure DoGetText(var Text : string; Selection : Boolean);

    procedure DoSetText(const Text : string; Selection : Boolean);

  end;

  TReplaceTextDialogClass = class of TReplaceTextDialog;


procedure ExecuteInsTextDialog(DialogClass: TInsertTextDialogClass;

  OnInsertText : TInsertTextEvent);

procedure ExecuteRepTextDialog(DialogClass: TReplaceTextDialogClass;

  OnGetText : TGetTextEvent; OnSetText : TSetTextEvent);


implementation


procedure ExecuteRepTextDialog(DialogClass: TReplaceTextDialogClass;

  OnGetText : TGetTextEvent; OnSetText : TSetTextEvent);

var

  i : integer;

  Form : TReplaceTextDialog;

begin

  Form := nil;

  for i := 0 to Screen.FormCount-1 do

  begin

    if Screen.Forms[i] is DialogClass then

    begin

      Form := TReplaceTextDialog(Screen.Forms[i]);

      break;

    end;

  end;

  if Form = nil then

    Form := DialogClass.Create(Application.MainForm);

  Form.FOnGetText := OnGetText;

  Form.FOnSetText := OnSetText;

  Form.Show;

end;

procedure ExecuteInsTextDialog(DialogClass: TInsertTextDialogClass;

  OnInsertText: TInsertTextEvent);

var

  i : integer;

  Form : TInsertTextDialog;

begin

  Form := nil;

  for i := 0 to Screen.FormCount-1 do

  begin

    if Screen.Forms[i] is DialogClass then

    begin

      Form := TInsertTextDialog(Screen.Forms[i]);

      break;

    end;

  end;

  if Form = nil then

    Form := DialogClass.Create(Application.MainForm);

  Form.FOnInsertText := OnInsertText;

  Form.Show;

end;

{ TCustomInsertTextDialog }

procedure TInsertTextDialog.DoInsertText(Text: string);

begin

  if Assigned(FOnInsertText) then

    FOnInsertText(Self, Text);

end;

{ TCustomReplaceText }

procedure TReplaceTextDialog.DoGetText(var Text: string;

  Selection: Boolean);

begin

  if Assigned(FOnGetText) then

    FOnGetText(Self, Text, Selection);

end;

procedure TReplaceTextDialog.DoSetText(const Text: string;

  Selection: Boolean);

begin

  if Assigned(FOnSetText) then

    FOnSetText(Self, Text, Selection);

end;

end.
