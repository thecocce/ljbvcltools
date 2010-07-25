unit LjbReg;

interface

uses
    SysUtils, Classes, Registry, Windows;

type
    TLjbReg = class(TComponent)
    private
    { Private declarations }
    protected
    { Protected declarations }
    public
    { Public declarations }
    published
        procedure RegWrite(Rkey: HKEY; strOpenKey: string; strNameKey: string; strValue: string);
        procedure RegDelete(Rkey: HKEY; strOpenKey: string; strDeleteKey: string);
        procedure RegCreate(Rkey: HKEY; strOpenKey: string; strCreateKey: string);
        function RegRead(Rkey: HKEY; strOpenKey: string; strReadKey: string):string;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbReg]);
end;
//---------------------------------------------------------

procedure TLjbReg.RegWrite(Rkey: HKEY; strOpenKey: string; strNameKey: string; strValue: string);
var
    Reg: TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := Rkey;
    Reg.OpenKey(strOpenKey, true);
    Reg.WriteString(strNameKey, strValue);
    Reg.CloseKey;
    Reg.free;
end;
//---------------------------------------------------------

procedure TLjbReg.RegDelete(Rkey: HKEY; strOpenKey: string; strDeleteKey: string);
var
    Reg: TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := Rkey;
    Reg.OpenKey(strOpenKey, true);
    Reg.DeleteValue(strDeleteKey);
    Reg.DeleteKey(strDeleteKey);
    Reg.CloseKey;
    Reg.free;
end;
//---------------------------------------------------------

procedure TLjbReg.RegCreate(Rkey: HKEY; strOpenKey: string; strCreateKey: string);
var
    Reg: TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := Rkey;
    Reg.OpenKey(strOpenKey, true);
    reg.CreateKey(strCreateKey);
    Reg.CloseKey;
    Reg.free;
end;
//---------------------------------------------------------

function TLjbReg.RegRead(Rkey: HKEY; strOpenKey: string; strReadKey: string):string;
var
    Reg: TRegistry;
begin
    Reg := TRegistry.Create;
    Reg.RootKey := Rkey;
    Reg.OpenKey(strOpenKey, true);
    RegRead:=Reg.ReadString(strReadKey);
    Reg.CloseKey;
    Reg.free;
end;
//----------------------------------------------------------
end.

 