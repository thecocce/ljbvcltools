unit LjbEdit;

interface
{$R ljbTools.dcr}
uses
    Clipbrd, SysUtils, Classes, Controls, ExtCtrls, Messages, StdCtrls, Windows,
    Dialogs;

type
    TNumType = (LjbInteger, LjbFloat, LjbNormal);

    TLjbEdit = class(TEdit)
    private
        FIsNumeric: TNumType;
        FMaxLength: Integer;
        procedure KeyPress(var Key: char); override;
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        constructor Create(Aowner: TComponent); override;
        procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean);
            override;
        procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
            Integer);
            override;
        property IsNumeric: TNumType read FIsNumeric write FIsNumeric default
            LjbNormal;
        property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbEdit]);
end;

constructor TLjbEdit.Create(Aowner: TComponent);
begin
    inherited;
    IsNumeric := LjbNormal;
end;

procedure TLjbEdit.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
    inherited;
    Handled := True;
end;

procedure TLjbEdit.KeyPress(var Key: char);
var
    MemoData: array[1..65535] of char;
    i: integer;
begin
    inherited;
    if IsNumeric = LjbFloat then
    begin
        if (Key <> #8) and (Key <> #3) and (Key <> #22) and (Key <> #24) then
        begin
            if (Key < '0') or (Key > '9') then
            begin
                if Key <> '.' then
                begin
                    Key := #0;
                end;
            end;
        end;
        if Key = ('.') then
        begin
            if Pos('.', Self.Text) > 0 then
                Key := #0;
        end;
        if Self.Text = '' then
        begin
            Self.Text := '0.0';
            Self.SelectAll;
            Key := #0;
        end;
    end;

    if IsNumeric = LjbInteger then
    begin
        if (Key <> #8) and (Key <> #3) and (Key <> #22) and (Key <> #24) then
        begin
            if (Key < '0') or (Key > '9') then
            begin
                Key := #0;
            end;
        end;
        if Self.Text = '' then
        begin
            Self.Text := '0';
            Self.SelectAll;
            Key := #0;
        end;
    end;

    if (MaxLength > 0) and (Key <> #8) and (Key <> #3) and (Key <> #24) then
    begin
        if StrLen(PChar(Self.Text)) >= MaxLength then
        begin
            Key := #0;
        end;
    end;

    if (Key = #22) and (MaxLength > 0) then // ctrl+v≈–∂œ
    begin
        if Clipboard.HasFormat(CF_TEXT) then
        begin
            Clipboard.GetTextBuf(@MemoData, SizeOf(MemoData));
            i := StrLen(@MemoData);
            if StrLen(PChar(Self.Text)) + i > MaxLength then
            begin
                Key := #0;
            end;
        end;
    end;
end;

procedure TLjbEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
    Integer);
begin
    inherited;
    //√ª”√
end;

end.

