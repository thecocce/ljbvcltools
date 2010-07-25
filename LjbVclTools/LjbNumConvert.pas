unit LjbNumConvert;

interface

uses
    SysUtils, Classes;

type
    TLjbNumConvert = class(TComponent)
    private
    { Private declarations }
    protected
    { Protected declarations }
    public
    { Public declarations }
    published
        function HexToInt2(Hex: string): Cardinal;
        function IntToBin2(Value: integer; NumBits: byte): string;
        function BinToInt2(Bin: string): integer;
        function BinToHex2(Bin: string; Digits: integer): string;
        function HexToBin2(Hex: string; NumBits: byte): string;
        function IsStrDec2(Value: string): boolean;
        function IsStrHex2(Value: string): boolean;
        function IsStrBin2(Value: string): boolean;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbNumConvert]);
end;



function TLjbNumConvert.HexToInt2(Hex: string): Cardinal;
const cHex = '0123456789ABCDEF';
var mult, i, loop: integer;
begin
    result := 0;
    mult := 1;
    for loop := length(Hex) downto 1 do begin
        i := pos(Hex[loop], cHex) - 1;
        if (i < 0) then i := 0;
        inc(result, (i * mult));
        mult := mult * 16;
    end;
end;

function TLjbNumConvert.IntToBin2(Value: integer; NumBits: byte): string;
var lp0: integer;
begin
    result := '';
    for lp0 := 0 to NumBits - 1 do begin
        if ((Value and (1 shl (lp0))) <> 0) then begin
            result := #$31 + result;
        end else result := #$30 + result;
    end;
end;

function TLjbNumConvert.BinToInt2(Bin: string): integer;
var mult, lp0: integer;
begin
    result := 0;
    mult := 0;
    for lp0 := length(Bin) downto 1 do begin
        if Bin[lp0] = #$31 then begin
            inc(result, (1 shl mult));
        end;
        inc(mult);
    end;
end;

function TLjbNumConvert.BinToHex2(Bin: string; Digits: integer): string;
begin
    result := IntToHex(BinToInt2(Bin), Digits);
end;

function TLjbNumConvert.HexToBin2(Hex: string; NumBits: byte): string;
begin
    result := IntToBin2(HexToInt2(Hex), NumBits);
end;


function TLjbNumConvert.IsStrDec2(Value: string): boolean;
var lp0: integer;
begin
    result := true;
    for lp0 := 1 to length(Value) do begin
        result := result and ((Ord(Value[lp0]) >= $30) and (Ord(Value[lp0]) <= $39));
    end;
end;

function TLjbNumConvert.IsStrHex2(Value: string): boolean;
var lp0: integer;
begin
    result := true;
    for lp0 := 1 to length(Value) do begin
        case Ord(Upcase(Value[lp0])) of
            $30..$39, $41..$46: result := result and true;
        else
            result := false;
        end;
    end;
end;

function TLjbNumConvert.IsStrBin2(Value: string): boolean;
var lp0: integer;
begin
    result := true;
    for lp0 := 1 to length(Value) do begin
        case Ord(Upcase(Value[lp0])) of
            $30..$31: result := result and true;
        else
            result := false;
        end;
    end;
end;



end.

 