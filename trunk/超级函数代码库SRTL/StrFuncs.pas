{-------------------------------------------------------------------------------

   ��Ԫ: StrFuncs.pas

   ����: Ҧ�Ƿ� - yaoqiaofeng@sohu.com

   ����: 2004.12.06

   �汾: 1.00

   ˵��: �ַ�������Ԫ

-------------------------------------------------------------------------------}


unit StrFuncs;


interface


uses

  Windows, SysUtils, Classes, Math, StrUtils, FastStrings, Streams, MessageDlg;


const

  { NumberSwitch }

  INT_CHINESE_NUMBER = 1; // ������������ ������д�뷱д

  INT_CHINESE_SIMPLE_NUMBER = 2; // ���м�д����������

  INT_CHINESE_TRADITION_NUMBER = 3; // ���з�д����������;

  INT_ARABIC_NUMERALS = 4; // ���а���������

  { TabulationSwitch }

  INT_CREWEL = 1; // ˫����ʽ���Ʊ��;

  INT_MONGLINE_WIDE = 2; // ��������ʽ���Ʊ��

  INT_MONGLINE_THIN = 3; // ��ϸ����ʽ���Ʊ��

  { CurrencySwitch }

  INT_CURRENCY_CHINESE_SIMPLE = 1; // ��ʽ��Ϊ���ļ�д������ʽ�ĸ�ʽ

  INT_CURRENCY_CHINESE_TRADITION = 2; // ��ʽ��Ϊ���ķ�д������ʽ�ĸ�ʽ

  INT_NUMERICAL_CHINESE_SIMPLE = 3; // ��ʽ��Ϊ���ļ�д��ֵ��ʽ�ĸ�ʽ

  INT_NUMERICAL_CHINESE_TRADITION = 4; // ��ʽ��Ϊ���ķ�д��ֵ��ʽ�ĸ�ʽ

  { WrapText }

  CHARS_UNALLOWED_EOL : TSysCharSet = ['(', '[', '{', '<'];

  CHARS_UNALLOWED_BOL : TSysCharSet = [')', ']', '}', '>', ';', ':', ',', '.', '?'];


type

  Strings = array of string;

  { Fast Replace Text }

  TFastTagReplaceProc = procedure (var Tag: string; const UserData: Integer);

  { TStrInfo �ļ�ͳ����Ϣ�ṹ }

  TStrInfo = record

    CharAmount : Integer;     // �����ַ�����

    LowerCase : Integer;      // Сд��ĸ����

    UpperCase : Integer;      // ��д��ĸ����

    Blank : Integer;          // Ӣ�Ŀո����

    Tabs : Integer;           // �Ʊ������

    Enter : Integer;          // �س����Ÿ���

    CtrlChar : Integer;       // �����ַ�����

    ArabicNumerals : Integer; // Ӣ�����ָ���

    UnicodeChar : Integer;    // ˫�ֽ��ַ�����

    AnsiChar : Integer;       // ���ֽ��ַ�����

  end;



// UpperCase ���ڽ��ַ���Сд��ĸ����ת��Ϊ���Ӧ�Ĵ�д��ĸ

function UpperCase(value : string): string;


// LowerCase ���ڽ��ַ�����д��ĸת��Ϊ���Ӧ��Сд��ĸ

function LowerCase(value : string): string;


// MutualCase ���ڽ��ַ���ԭ�ȵ���ĸ��Сд��ʽ����

function MutualCase(value : string): string;


// FirstUpperCase ���ڽ��ַ�����ÿһ���ʴ��׵���ĸת��Ϊ��д��ĸ

function FirstUpperCase(value : string): string;


// SBCCase ת���ַ����İ���ַ�Ϊȫ���ַ�

function SBCCase(value : widestring): string;


// DBCCase ת���ַ�����ȫ���ַ�Ϊ����ַ�

function DBCCase(value : widestring): string;


//  StrTrim ɾ����ǿո���ȫ�ǿո�

function StrTrim(value : widestring): string;


// StrTrimLeft ɾ�����ַ�����ߵ�һ���ǰ�ǻ�ȫ�ǿո���ַ�Ϊֹ

function StrTrimLeft(value : widestring): string;


// StrTrimRight ɾ�����ַ����ұߵ�һ���ǰ�ǻ�ȫ�ǿո���ַ�Ϊֹ

function StrTrimRight(value : widestring): string;


// StrTrimCtrlChar ɾ���ַ��������п����ַ�����ASCII��Ϊ#0 - #31���ַ�

function StrTrimCtrlChar(value : widestring): string;


// StrTrimLineBreak ɾ���ַ��������лس����з�, �������system��sLineBreak����

function StrTrimLineBreak(value : widestring): string;


// OemToAnsi ����OEM��ʽ������ַ���ת��ΪANSI���

function OemToAnsi(value : AnsiString): AnsiString;


// AnsiToOem ��ANSI���뷽ʽ���ַ���ת��Ϊ��OEM��ʽ������ַ���

function AnsiToOem(value : AnsiString): AnsiString;


// Utf8ToAnsi ����UTF8(һ��Unicode�ֱ��뷽ʽ)��ʽ������ַ���ת��ΪANSI����

function Utf8ToAnsi(value : UTF8String): AnsiString;


// AnsiToUtf8 ����ANSI���뷽ʽ���ַ���ת��Ϊ��UTF8��ʽ������ַ���

function AnsiToUtf8(value : AnsiString): UTF8String;


// Utf7ToAnsi ����UTF7(һ��Unicode�ֱ��뷽ʽ)��ʽ������ַ���ת��ΪANSI����

function Utf7ToAnsi(value : AnsiString): WideString;


// AnsiToUtf7 ����ANSI���뷽ʽ���ַ���ת��Ϊ��UTF7��ʽ������ַ���

function AnsiToUtf7(value : WideString): AnsiString;


// AnsiToUnicode ����ANSI���뷽ʽ���ַ���ת��Ϊ��UCS��ʽ������ַ���

function AnsiToUnicode(value : WideString): AnsiString;


// UnicodeToAnsi ����UCS���뷽ʽ���ַ���ת��Ϊ��ANSI��ʽ������ַ���

function UnicodeToAnsi(value : AnsiString): WideString;


// DosToUnix �˺����ǽ�DOS�ı�ת��ΪUNIX�ı�

function DosToUnix(value : string): string;


// UnixToDos �˺����ǽ�UNIX�ı�ת��ΪDOS�ı�

function UnixToDos(value : string): string;


// UnMimeCode ����MIME��ʽ������ַ������н���

function DecodeMime(value : string): string;


// UnQPCode ����QP��ʽ������ַ������н���

function DecodeQP(value : string): string;


// UnHZCode ����HZ��ʽ������ַ������н���

function DecodeHZ(value : string): string;


// StrSimilar���Ƚ��ַ��������ƶ� �� 'Jim' and 'James' = 40%

function StrSimilar(s1, s2: string): Integer;


// StrUpset ���ַ�����ת���� �˺��������˿��ֽ� ��˼���˫�ֽ���ʽ�ı���

function StrUpset(value : WideString): widestring;


// StrCompare �Ƚ��ַ��������ƶ� �� StrCompare('David Stidolph','*St*') = true

function StrCompare(Source, Pattern: String): Boolean;


// StrStatistic �ı�ͳ��

function StrStatistic(value : wideString): TStrInfo;


// NumberSwitch ���ַ����е������滻Ϊָ����ʽ����ʽ

function NumberSwitch(value : WideString; Source, Target : Integer): string;


// TabulationSwitch ��ʽ���ַ����е��Ʊ�������ı������

function TabulationSwitch(value : WideString; format : integer): string;


// CurrencySwitch ���ַ����еĻ�����ֵ�滻Ϊָ����ʽ����ʽ

function CurrencySwitch(value : string; Format : Integer): string; overload;

function CurrencySwitch(value : Real; Format : Integer): string; overload;


// ExtractHtml ��ȡHTML�ĵ�Դ������ı�

function ExtractHtml(value :string):string;


// ExtractURL ��ȡ�ַ����е�URL

function ExtractURL(value, Delimiter : string) : string;


// ExtractEmail ��ȡ�ַ�����EMail��ַ

function ExtractEmail(value, Delimiter : String): string;


// TabToSpace ��TAB�����ַ�ת��Ϊ��Ӧ��ȵĿո�

function TabToSpace(Value: string; TabWidth : Integer = 8): string;


// SpaceToTab ���ַ����Ŀո�ת��ΪTAB��

function SpaceToTab(value : string; TabWidth : Integer = 8): string;


// GetRandomStr ����������ַ���

function GetRandomStr(Source : string; StrLen : Integer) : string;


// Dec2Bin ��ʮ��������ת��Ϊ�����Ʒ�ʽ�������ַ���

function Dec2Bin(value : Integer; MinBit : Integer) : string;


// Bin2Dec �������Ʒ�ʽ�������ַ���ת��Ϊʮ���Ʒ�ʽ������

function Bin2Dec(const value : string) : Integer;


// Hex2Dec ��ʮ�����Ʒ�ʽ�������ַ���ת��ת��Ϊʮ��������ʽ������

function Hex2Dec(const value : string): Integer;


// Hex2Str ��ʮ�����Ʒ�ʽ�������ַ���ת��ת��Ϊ��ӦASCII����ַ���

function Hex2Str(const value : String) : String;


// Mem2Hex ���ַ���ת��Ϊʮ�����Ʒ�ʽ�������ַ���

function Mem2Hex(Buffer: PChar; Size : Longint): string;


// Str2Hex ���ں���MemToHex��һ������ ��Ҫ�Ƿ����ַ����������͵�ת��

function Str2Hex(value : string): string;



function StrAlignment(const value : string; PageWidth : Integer;

  Alignment : TAlignment): string;

// StrWrap ��һ���ı����л���

function StrWrap(const Text, LineBreak: string;  const Reorder : boolean;

  const Hanging, FirstLine, LeftSpace, PageWidth : Integer;

  const Break : String; const BreakMode : Integer  {0 ���ַ�ǰ���� 1 ���ַ�����}

  ): string; 



// IsBIG5���Ƿ���BIG5����ĺ���

function IsBIG5(value: string): Boolean;


{ IsGBK �Ƿ���GBK����ĺ���

  GBK���루�׳ƴ��ַ��������й���½�ƶ��ġ���ͬ��UCS���µ����ı�����չ���ұ�

  ׼��GBK����С����1995��10�£�ͬ��12�����GBK�淶���ñ����׼����GB2312����

  ��¼����21003��������883�������ṩ1894��������λ���򡢷���������һ�⡣

  Windows95/98�������İ���ֿ������Ͳ��õ���GBK��ͨ��GBK��UCS֮��һһ��

  Ӧ�������ײ��ֿ���ϵ�����һ�ֽڵ�ֵ�� 16 ���Ƶ� 81��FE ֮�䣬�ڶ��ֽ�

  �� 40��FE����ȥxx7Fһ�ߡ�}

function IsGBK(value: string): Boolean;


{ IsGB���Ƿ���GB����ĺ���

  GB2312-80 GB2312�����Լ����6000�຺�֣������������ַ���,���뷶ΧΪ��һλ

  b0-f7,�ڶ�λ���뷶ΧΪa1-fe(��һλΪcfʱ,�ڶ�λΪa1-d3),����һ�º��ָ���

  Ϊ6762�����֡���Ȼ�����������ַ����������Ƽ��������ַ���Լ7573���ַ����롣}

function IsGB(value: string): Boolean;


// GBToBIG5 ����GB����ĺ���ת��Ϊ��BIG5�ı�����ʽ

function GBToBIG5(value: String): string;


// BIG5ToGB ����BIG5����ĺ���ת��Ϊ��GB�ı�����ʽ

function BIG5ToGB(value: String): string;


// GBToTraditional ������ȫ��ת��Ϊ���ַ�д��ʽ

function GBKToTraditional(value : widestring): string;


// GBKToSimplified ������ȫ��ת��Ϊ���ּ�д��ʽ

function GBKToSimplified(value : widestring): string;


// GBKToSpell ������ת��Ϊ����ƴ��

function GBKToSpell(value : widestring): string;


// GBKToSpellIndex�����غ���ƴ�����׸���ĸ

function GBKToSpellIndex(value: widestring): string;


// ChinesePunctuation ��ʽ��Ϊ���ķ��� ���Զ����ɶԵ����Ż�˫����

function ChinesePunctuation(value : widestring): string;


// EnglishPunctuation ��ʽ��ΪӢ�ķ���

function EnglishPunctuation(value : widestring): string;


// ExpressionEval ���ʽ��ֵ

function ExpressionEval(Expression: string; var Error: Boolean): Extended;


// NumToStr ������Ƶ���ת��Ϊ�ַ���

function NumToStr (mNumber: Integer; mScale: Byte;

  mLength: Integer = 0): string;

// StrToNum ������Ƶ��ַ���ת��Ϊ��

function StrToNum (mDigit: string; mScale: Byte): Integer;

// RomanNumerals ����ʮ�������ֵ���������

function RomanNumerals(N: Integer): string;



implementation


{$R HZCodes.RES}

type

  { Fast Find&Replace Text }

  TBMJumpTable = array[0..255] of Integer;

  TFastPosProc = function (const aSource, aFind: Pointer; const aSourceLen,

    aFindLen: Integer; var JumpTable: TBMJumpTable): Pointer;

  TFastPosIndexProc = function (const aSourceString, aFindString: string;

    const aSourceLen, aFindLen, StartPos: Integer;

    var JumpTable: TBMJumpTable): Integer;


resourcestring

  SBufferOverflow = 'Buffer overflow';

  SInvalidUTF7 = 'Invalid UTF7';


const

  SBCCaseChars : widestring = '���������磥���������������������������������������������������������£ãģţƣǣȣɣʣˣ̣ͣΣϣУѣңӣԣգ֣ףأ٣ڣۣܣݣޣߣ�����������������������������������������';

  DBCCasePunctuations : WideString =  '\.,;:?!_-|()[]{}<>""''''';

  SBCCasePunctuations : WideString =  '���������������ߡ��������ۣݣ���������������';


  GBfirst  = $A1A1; // first code of GB */

  GBlast   = $FEFE; // last code of GB */

  GBsize   = $5E5E; // GBlast - GBfirst + 1 */

  BIGfirst = $A140; // first code of BIG

  BIGlast  = $F9FE; // last code of BIG

  BIGsize  = $58BF; // BIGlast - BIGfirst + 1


  cScaleChar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';


var

  sChineseSpell  : array of Widestring;

  sChineseTradition, sChineseSimple : widestring;



function UpperCase(value : string): string;

var

  I : Integer;

begin

  result := value;

  for I := 1 to Length(result) do

    If result[I] In ['a'..'z'] then

      result[I] := Char(Ord(result[I])-32)

end;

function LowerCase(value : string): string;

var

  I : Integer;

begin

  result := value;

  for I := 1 to Length(result) do

    If result[I] In ['A'..'Z'] then

      result[I] := Char(Ord(result[I])+32)

end;

function MutualCase(value : string): string;

var

  I : Integer;

begin

  result := value;

  for I := 1 To Length(result) Do

    case result[I] of

      'a'..'z': result[I] := char(ord(result[I])-32);

      'A'..'Z': result[I] := char(ord(result[I])+32);

    end;

end;

function FirstUpperCase(value : string): string;

var

  I : Integer;

begin

  result := value;

  for I := 1 To Length(result) do

    If ( result[I] in ['a'..'z', 'A'..'Z'] ) then

    begin

      IF ( I = 1 ) or ( ( I > 1 ) and not

        ( result[I-1] in ['a'..'z', '0'..'9', 'A'..'Z'] ) ) then

      begin

        If ( result[I] in ['a'..'z'] ) then

          result[i] := char(ord(result[i])-32)

      end

      else begin

        if ( result[I] in ['A'..'Z'] ) then

          result[i] := char(ord(result[i])+32);

      end;

    end;

end;

function SBCCase(value : widestring): string;

var

  I : integer;

begin

  for I := 1 To Length(value) Do

  begin

    If ord(value[i]) in [32 .. 126] then

      value[i] := SBCCaseChars[ord(value[i])-31];

  end;

  result := value;

end;

function DBCCase(value : widestring): string;

var

  I, P : integer;

begin

  for I := 1 To Length(value) Do

  begin

    P := Pos(value[I], SBCCaseChars);

    If (P <> 0) then value[i] := WideChar(p+31);;

  end;

  result := value;

end;

function StrTrim(value : widestring): string;

var

  I : Integer;

begin

  for I := Length(value) downto 1 do

  begin

    If (value[I] = #32) or (value[I] = #161#161) Then

      Delete(value, i, 1)

  end;

  result := value;

end;

function StrTrimLeft(value : widestring): string;

var

  I : Integer;

begin

  for I := 1 To Length(value) do

    If (value[I] <> #32) and (value[I] <> #161#161) Then

      break;

  delete(value, 1, I-1);

  result := value;

end;

function StrTrimRight(value : widestring): string;

var

  I : Integer;

begin

  for I := Length(value) downto 1 do

    If (value[I] <> #32) and (value[I] <> #161#161) Then

      break;

  delete(value, I + 1, Length(value)-I);

  result := value;

end;

function StrTrimCtrlChar(value : widestring): string;

var

  I : Integer;

begin

  for I := Length(value) downto 1 do

    If ((value[I] >= #0) and (value[I] <= #31)) then

       delete(value, I, 1);

  result := value;

end;

function StrTrimLineBreak(value : widestring): string;

var

  I : Integer;

begin

  for I := Length(value) downto 1 do

    If ((value[I] = #10) or (value[I] <= #13)) then

       delete(value, I, 1);

  result := value;

end;

function OemToAnsi(value : AnsiString): AnsiString;

begin

   SetLength(Result, Length(value));

   If Length(Result) > 0 Then

   {$IFDEF WIN32}

      OemToCharBuff(PChar(value), PChar(Result), Length(Result));

   {$ELSE}

      OemToAnsiBuff(@value[1], @Result[1], Length(Result));

   {$ENDIF}

end;

function AnsiToOem(value : AnsiString): AnsiString;

begin

   SetLength(Result, Length(value));

   If Length(Result) > 0 Then

   {$IFDEF WIN32}

      CharToOemBuff(PChar(value), PChar(Result), Length(Result));

   {$ELSE}

      AnsiToOemBuff(@value[1], @Result[1], Length(Result));

   {$ENDIF}

end;

function Utf8ToAnsi(value : UTF8String): AnsiString;

begin

   Result := System.Utf8ToAnsi(value);

end;

function AnsiToUtf8(value : AnsiString): UTF8String;

begin

   Result := System.AnsiToUtf8(value);

end;

type

  UCS2 = Word;

const

  _base64: AnsiString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  _direct: AnsiString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789''(),-./:?';

  _optional: AnsiString = '!"#$%&*;<=>@[]^_`{|}';

  _spaces: AnsiString = #9#13#10#32;

var

  base64: PAnsiChar;

  invbase64: array[0..127] of SmallInt;

  direct: PAnsiChar;

  optional: PAnsiChar;

  spaces: PAnsiChar;

  mustshiftsafe: array[0..127] of AnsiChar;

  mustshiftopt: array[0..127] of AnsiChar;

var

  needtables: Boolean = True;

procedure Initialize_UTF7_Data;

begin

  base64 := PAnsiChar(_base64);

  direct := PAnsiChar(_direct);

  optional := PAnsiChar(_optional);

  spaces := PAnsiChar(_spaces);

end;

procedure tabinit;

var

  i: Integer;

  limit: Integer;

begin

  i := 0;

  while (i < 128) do

  begin

    mustshiftopt[i] := #1;

    mustshiftsafe[i] := #1;

    invbase64[i] := -1;

    Inc(i);

  end { For };

  limit := Length(_Direct);

  i := 0;

  while (i < limit) do

  begin

    mustshiftopt[Integer(direct[i])] := #0;

    mustshiftsafe[Integer(direct[i])] := #0;

    Inc(i);

  end { For };

  limit := Length(_Spaces);

  i := 0;

  while (i < limit) do

  begin

    mustshiftopt[Integer(spaces[i])] := #0;

    mustshiftsafe[Integer(spaces[i])] := #0;

    Inc(i);

  end { For };

  limit := Length(_Optional);

  i := 0;

  while (i < limit) do

  begin

    mustshiftopt[Integer(optional[i])] := #0;

    Inc(i);

  end { For };

  limit := Length(_Base64);

  i := 0;

  while (i < limit) do

  begin

    invbase64[Integer(base64[i])] := i;

    Inc(i);

  end { For };

  needtables := False;

end; { tabinit }

function WRITE_N_BITS(x: UCS2; n: Integer; var BITbuffer: Cardinal; var bufferbits: Integer): Integer;

begin

  BITbuffer := BITbuffer or (x and (not (-1 shl n))) shl (32 - n - bufferbits);

  bufferbits := bufferbits + n;

  Result := bufferbits;

end; { WRITE_N_BITS }

function READ_N_BITS(n: Integer; var BITbuffer: Cardinal; var bufferbits: Integer): UCS2;

var

  buffertemp: Cardinal;

begin

  buffertemp := BITbuffer shr (32 - n);

  BITbuffer := BITbuffer shl n;

  bufferbits := bufferbits - n;

  Result := UCS2(buffertemp);

end; { READ_N_BITS }

function ConvertUCS2toUTF7(var sourceStart: PWideChar; sourceEnd: PWideChar;

  var targetStart: PAnsiChar; targetEnd: PAnsiChar; optional: Boolean;

    verbose: Boolean): Integer;

var

  r: UCS2;

  target: PAnsiChar;

  source: PWideChar;

  BITbuffer: Cardinal;

  bufferbits: Integer;

  shifted: Boolean;

  needshift: Boolean;

  done: Boolean;

  mustshift: PAnsiChar;

begin

  Initialize_UTF7_Data;

  Result := 0;

  BITbuffer := 0;

  bufferbits := 0;

  shifted := False;

  source := sourceStart;

  target := targetStart;

  r := 0;

  if needtables then

    tabinit;

  if optional then

    mustshift := @mustshiftopt[0]

  else

    mustshift := @mustshiftsafe[0];

  repeat

    done := source >= sourceEnd;

    if not Done then

    begin

      r := Word(source^);

      Inc(Source);

    end { If };

    needshift := (not done) and ((r > $7F) or (mustshift[r] <> #0));

    if needshift and (not shifted) then

    begin

      if (Target >= TargetEnd) then

      begin

        Result := 2;

        break;

      end { If };

      target^ := '+';

      Inc(target);

      { Special case handling of the SHIFT_IN character }

      if (r = UCS2('+')) then

      begin

        if (target >= targetEnd) then

        begin
          Result := 2;

          break;

        end;

        target^ := '-';

        Inc(target);

      end

      else

        shifted := True;

    end { If };

    if shifted then

    begin

      { Either write the character to the bit buffer, or pad }

      { the bit buffer out to a full base64 character. }

      { }

      if needshift then

        WRITE_N_BITS(r, 16, BITbuffer, bufferbits)

      else

        WRITE_N_BITS(0, (6 - (bufferbits mod 6)) mod 6, BITbuffer,

          bufferbits);

      { Flush out as many full base64 characters as possible }

      { from the bit buffer. }

      { }

      while (target < targetEnd) and (bufferbits >= 6) do

      begin

        Target^ := base64[READ_N_BITS(6, BITbuffer, bufferbits)];

        Inc(Target);

      end { While };

      if (bufferbits >= 6) then

      begin

        if (target >= targetEnd) then

        begin

          Result := 2;

          break;

        end { If };

      end { If };

      if (not needshift) then

      begin

        { Write the explicit shift out character if }

        { 1) The caller has requested we always do it, or }

        { 2) The directly encoded character is in the }

        { base64 set, or }

        { 3) The directly encoded character is SHIFT_OUT. }

        { }

        if verbose or ((not done) and ((invbase64[r] >= 0) or (r =

          Integer('-')))) then

        begin

          if (target >= targetEnd) then

          begin

            Result := 2;

            Break;

          end { If };

          Target^ := '-';

          Inc(Target);

        end { If };

        shifted := False;

      end { If };

      { The character can be directly encoded as ASCII. }

    end { If };

    if (not needshift) and (not done) then

    begin

      if (target >= targetEnd) then

      begin

        Result := 2;

        break;

      end { If };

      Target^ := AnsiChar(r);

      Inc(Target);

    end { If };

  until (done);

  sourceStart := source;

  targetStart := target;

end; { ConvertUCS2toUTF7 }

function ConvertUTF7toUCS2(var sourceStart: PAnsiChar; sourceEnd: PAnsiChar;

  var targetStart: PWideChar; targetEnd: PWideChar): Integer;

var

  target: PWideChar { Register };

  source: PAnsiChar { Register };

  BITbuffer: Cardinal { & "Address Of" Used };

  bufferbits: Integer { & "Address Of" Used };

  shifted: Boolean { Used In Boolean Context };

  first: Boolean { Used In Boolean Context };

  wroteone: Boolean;

  base64EOF: Boolean;

  base64value: Integer;

  done: Boolean;

  c: UCS2;

  prevc: UCS2;

  junk: UCS2 { Used In Boolean Context };

begin

  Initialize_UTF7_Data;

  Result := 0;

  BITbuffer := 0;

  bufferbits := 0;

  shifted := False;

  first := False;

  wroteone := False;

  source := sourceStart;

  target := targetStart;

  c := 0;

  if needtables then

    tabinit;

  repeat

    { read an ASCII character c }

    done := Source >= SourceEnd;

    if (not done) then

    begin

      c := Word(Source^);

      Inc(Source);

    end { If };

    if shifted then

    begin

      { We're done with a base64 string if we hit EOF, it's not a valid }

      { ASCII character, or it's not in the base64 set. }

      { }

      base64value := invbase64[c];

      base64EOF := (done or (c > $7F)) or (base64value < 0);

      if base64EOF then

      begin

        shifted := False;

        { If the character causing us to drop out was SHIFT_IN or }

        { SHIFT_OUT, it may be a special escape for SHIFT_IN. The }

        { test for SHIFT_IN is not necessary, but allows an alternate }

        { form of UTF-7 where SHIFT_IN is escaped by SHIFT_IN. This }

        { only works for some values of SHIFT_IN. }

        { }

        if ((not done) and ((c = Integer('+')) or (c = Integer('-')))) then

        begin

          { get another character c }

          prevc := c;

          Done := Source >= SourceEnd;

          if (not Done) then

          begin

            c := Word(Source^);

            Inc(Source);

            { If no base64 characters were encountered, and the }

            { character terminating the shift sequence was }

            { SHIFT_OUT, then it's a special escape for SHIFT_IN. }

            { }

          end;

          if first and (prevc = Integer('-')) then

          begin

            { write SHIFT_IN unicode }

            if (target >= targetEnd) then

            begin

              Result := 2;

              break;

            end { If };

            Target^ := WideChar('+');

            Inc(Target);

          end

          else begin

            if (not wroteone) then

            begin

              Result := 1;

            end { If };

          end { Else };

        end { If }

        else begin

          if (not wroteone) then

          begin

            Result := 1;

          end { If };

        end { Else };

      end { If }

      else begin

        { Add another 6 bits of base64 to the bit buffer. }

        WRITE_N_BITS(base64value, 6, BITbuffer, bufferbits);

        first := False;

      end { Else };

      { Extract as many full 16 bit characters as possible from the }

      { bit buffer. }

      { }

      while (bufferbits >= 16) and (target < targetEnd) do

      begin

        { write a unicode }

        Target^ := WideChar(READ_N_BITS(16, BITbuffer, bufferbits));

        Inc(Target);

        wroteone := True;

      end { While };

      if (bufferbits >= 16) then

      begin

        if (target >= targetEnd) then

        begin

          Result := 2;

          Break;

        end;

      end { If };

      if (base64EOF) then

      begin

        junk := READ_N_BITS(bufferbits, BITbuffer, bufferbits);

        if (junk <> 0) then

        begin

          Result := 1;

        end { If };

      end { If };

    end { If };

    if (not shifted) and (not done) then

    begin

      if (c = Integer('+')) then

      begin

        shifted := True;

        first := True;

        wroteone := False;

      end { If }

      else begin

        { It must be a directly encoded character. }

        if (c > $7F) then

        begin

          Result := 1;

        end { If };

        if (target >= targetEnd) then

        begin

          Result := 2;

          break;

        end { If };

        Target^ := WideChar(c);

        Inc(Target);

      end { Else };

    end { If };

  until (done);

  sourceStart := source;

  targetStart := target;

end; { ConvertUTF7toUCS2 }

function Utf7ToAnsi(value : AnsiString): WideString;

var

  SourceStart, SourceEnd: PAnsiChar;

  TargetStart, TargetEnd: PWideChar;

begin

  if (value = '') then

    Result := ''

  else begin

    SetLength(Result, Length(value)); // Assume Worst case

    SourceStart := PAnsiChar(@value[1]);

    SourceEnd := PAnsiChar(@value[Length(value)]) + 1;

    TargetStart := PWideChar(@Result[1]);

    TargetEnd := PWideChar(@Result[Length(Result)]) + 1;

    case ConvertUTF7toUCS2(SourceStart, SourceEnd, TargetStart,

      TargetEnd) of

      1: raise Exception.Create(SInvalidUTF7);

      2: raise Exception.Create(SBufferOverflow);

    end;

    SetLength(Result, TargetStart - PWideChar(@Result[1]));

  end;

end;

function AnsiToUtf7(value : WideString): AnsiString;

var

  SourceStart, SourceEnd: PWideChar;

  TargetStart, TargetEnd: PAnsiChar;

begin

  if value = '' then

    Result := ''

  else begin

    SetLength(Result, Length(value) * 7); // Assume worst case

    SourceStart := PWideChar(@value[1]);

    SourceEnd := PWideChar(@value[Length(value)]) + 1;

    TargetStart := PAnsiChar(@Result[1]);

    TargetEnd := PAnsiChar(@Result[Length(Result)]) + 1;

    if ConvertUCS2toUTF7(SourceStart, SourceEnd, TargetStart,

      TargetEnd, True, False) <> 0

    then

      raise Exception.Create(SBufferOverflow);

    SetLength(Result, TargetStart - PAnsiChar(@Result[1]));

  end;

end;

function AnsiToUnicode(value : WideString): AnsiString;

begin

  if Length(Value) = 0 then

    Result := ''

  else

    SetString(Result, PAnsiChar(@Value[1]), Length(Value) * SizeOf(WideChar))

end;

function UnicodeToAnsi(value : AnsiString): WideString;

begin

  if Length(Value) = 0 then

    Result := ''

  else

    SetString(Result, PWideChar(@Value[1]), Length(Value) div SizeOf(WideChar))

end;

function DosToUnix(value : string): string;

var

  ch : Char;

  I : Integer;

begin

  for I := 1  To Length(value) Do

  begin

    ch := value[i];

    case ch of

      #$D  : ;

      #$1A :

      begin

        result := result + #$04;

        break;

      End;

      else result := result + ch;

    end

   end;

end;

function UnixToDos(value : string): string;

var

  ch : Char;

  I : Integer;

begin

  for I := 1 To Length(value) Do

  begin

    ch := value[i];

    case ch of

      #$A   : result := result + #$D#$A;

      #$04  :

      begin

        result := result + #$1A;

        Break;

      end;

      else result := result + ch;

    end

  end;

end;

function DecodeMime(value : string): string;

const

  c_strBase64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

  //Base64�ַ���

var

  StrBin : String;

  nIndex : Integer;

  I : Integer;

Begin

  StrBin := '';

  {����Base64�ַ�����ת��Ϊ������}

  for nIndex := 1 To Length(value) Do

  begin

    I := Pos(value[nIndex], c_strBase64);

    If (I > 0) Then {����6λ������Base64����ԭ��}

      StrBin := strBin + Dec2Bin(i - 1, 6)

    {�������ַ�ʱ��ʹ�õȺ������������д��Ӧ���Ǵ���ģ���Ŀǰ�벻���õ�д����}

    else If (value[nIndex] = '=') Then

      StrBin := StrBin + '000000';

  end;

  {ת��Ϊ8λ�����ַ�}

  for nIndex := 1 To Trunc(Length(strBin) / 8) Do

    result := result + Chr(Bin2Dec(Copy(strBin, (nIndex - 1) * 8 + 1, 8)));

end;

function DecodeQP(value : string): string;

var

  nIndex, nLength : Integer;

Begin

  nIndex := 1;

  nLength := Length(value);

  while (nIndex <= nLength) Do

  begin

    If (value[nIndex] = '=') and (nIndex + 2 <= nLength) And

      (((value[nIndex + 1] >= 'A') and (value[nIndex + 1] <= 'F')) or

      ((value[nIndex + 1] >= '0') and (value[nIndex + 1] <= '9'))) and

      (((value[nIndex + 2] >= 'A') and (value[nIndex + 2] <= 'F')) or

      ((value[nIndex + 2] >= '0') and (value[nIndex + 2] <= '9'))) then

    begin

      result := result + Chr(Hex2Dec(Copy(value, nIndex + 1, 2)));

      Inc(nIndex, 3);

    end

    else Begin

      result := result + value[nIndex];

      Inc(nIndex);

    end;

  end;

end;

function DecodeHZ(value : string): string;

var

  nBeginIndex, nEndIndex : Integer;

  S, S1, StrBin : String;

  nIndex : Integer;

Begin

  result := value;

  {���ұ����ִ���־}

  nBeginIndex := Pos('~{', result);

  nEndIndex := Pos('~}', result);

  while ((nBeginIndex > 0) And (nBeginIndex < nEndIndex)) do

  begin

    s := copy(result, nBeginIndex + 2, nEndIndex - nBeginIndex - 2);

    S1 := '';

    for nIndex := 1 To Length(s) Do

    begin

      If (ord(S[nIndex]) <= 127) Then

      Begin

        {����8λ������HZ����ԭ��}

        StrBin := Dec2Bin(ord(S[nIndex]), 8);

        {���λ��1}

        StrBin[1] := '1';

        S1 := S1 + Chr(Bin2Dec(StrBin));

      end;

    end;


    {�滻ԭ���ı����ִ�}

    Delete(result, nBeginIndex, nEndIndex - nBeginIndex + 2);

    Insert(s1, result, nBeginIndex);

    {���ұ����ִ���־}

    nBeginIndex := Pos('~{', result);

    nEndIndex := Pos('~}', result);

  end;

end;

function StrSimilar(s1, s2: string): Integer;

var

  hit: Integer; // Number of identical chars

  p1, p2: Integer; // Position count

  l1, l2: Integer; // Length of strings

  pt: Integer; // for counter

  diff: Integer; // unsharp factor

  hstr: string; // help var for swapping strings

  test: array [1..255] of Boolean; // Array shows is position is already tested

begin


  // Test Length and swap, if s1 is smaller

  // we alway search along the longer string

  if Length(s1) < Length(s2) then begin

    hstr:= s2;

    s2:= s1;

    s1:= hstr;

  end;


  // store length of strings to speed up the function

  l1:= Length (s1);

  l2:= Length (s2);

  p1:= 1;  p2:= 1;  hit:= 0;


  // calc the unsharp factor depending on the length

  // of the strings.  Its about a third of the length


  diff:= Max (l1, l2) div 3 + ABS (l1 - l2);


  // init the test array

  for pt:= 1 to l1 do

    test[pt]:= False;


  // loop through the string

  repeat

    // position tested?

    if not test[p1] then begin

      // found a matching character?

      if (s1[p1] = s2[p2]) and (ABS(p1-p2) <= diff) then begin

        test[p1]:= True;

        // increment the hit count

        Inc (hit);

        // next positions

        Inc (p1);

        Inc (p2);

        if p1 > l1 then p1:= 1;

      end else begin

        // Set test array

        test[p1]:= False;

        Inc (p1);


        // Loop back to next test position if end of the string

        if p1 > l1 then begin

          while (p1 > 1) and not (test[p1]) do

            Dec (p1);

          Inc (p2)

        end;

      end;

    end else begin

      Inc (p1);


      // Loop back to next test position if end of string

      if p1 > l1 then begin

        repeat

          Dec (p1);

        until (p1 = 1) or test[p1];

        Inc (p2);

      end;

    end;

  until p2 > Length(s2);

  // calc procentual value

  Result:= 100 * hit DIV l1;

end;

function StrCompare(Source, Pattern: String): Boolean;

var

  pSource: Array [0..255] of Char;

  pPattern: Array [0..255] of Char;

  function MatchPattern(element, pattern: PChar): Boolean;

    function IsPatternWild(pattern: PChar): Boolean;

    var

      t: Integer;

    begin

      Result := StrScan(pattern,'*') <> nil;

      if not Result then Result := StrScan(pattern,'?') <> nil;

    end;

  begin

    if 0 = StrComp(pattern,'*') then

      Result := True

    else if (element^ = Chr(0)) and (pattern^ <> Chr(0)) then

      Result := False

    else if element^ = Chr(0) then

      Result := True

    else begin

      case pattern^ of

        '*': begin

          if MatchPattern(element,@pattern[1]) then

            Result := True else

            Result := MatchPattern(@element[1],pattern);

        end;

        '?': Result := MatchPattern(@element[1],@pattern[1]);

        else begin

          if element^ = pattern^ then

            Result := MatchPattern(@element[1],@pattern[1]) else

            Result := False;

        end;

      end;

    end;

  end;

begin

  StrPCopy(pSource,source);

  StrPCopy(pPattern,pattern);

  Result := MatchPattern(pSource,pPattern);

end;

function StrUpset(value : WideString): widestring;

var

  l, i : Integer;

  uR : WideString;

begin

  l := Length(value);

  uR := value;

  for I := 1 to L do

    uR[i] := value[l - i + 1];

  result := uR;

end;

function StrCorrect(value, Source, Target : widestring): string;

var

  I, P : integer;

begin

  for I := 1 To Length(value) Do

  begin

    P := Pos(value[I], Source);

    If (P <> 0) and (P <= Length(Target)) then value[i] := Target[P];

  end;

  result := value;

end;

function NumberSwitch(value : WideString; Source, Target : Integer): string;

var

  sSource, sTarget : widestring;

begin

  case Source of

    INT_CHINESE_NUMBER : sSource := '��һ�����������߰˾���Ҽ��������½��ƾ�';

    INT_CHINESE_SIMPLE_NUMBER : sSource := '��һ�����������߰˾�';

    INT_CHINESE_TRADITION_NUMBER : sSource := '��Ҽ��������½��ƾ�';

    INT_ARABIC_NUMERALS : sSource := '01234567890123456789';

  end;

  case Target of

    INT_CHINESE_NUMBER : sTarget := '��һ�����������߰˾���Ҽ��������½��ƾ�';

    INT_CHINESE_SIMPLE_NUMBER : sTarget := '��һ�����������߰˾�';

    INT_CHINESE_TRADITION_NUMBER : sTarget := '��Ҽ��������½��ƾ�';

    INT_ARABIC_NUMERALS : sTarget := '01234567890123456789';

  end;

  result := StrCorrect(value, sSource, sTarget);

end;

function TabulationSwitch(value : WideString; format : integer): string;

const

  TabulationChars : array[1..11] of WideString = (

    '������������',

    '������������',

    '��������',

    '��������',

    '��������',

    '��������',

    '�����©éĩũƩ�',

    '�ȩɩʩ˩̩ͩΩ�',

    '�Щѩҩөԩթ֩�',

    '�ة٩ک۩ܩݩީ�',

    '�����������������'

  );

  sDouble : widestring = '�T�U�X�[�^�a�d�g�j�m�p';

  sWide   : widestring = '�������������ǩϩשߩ�';

  sThin   : widestring = '���������������ȩЩة�';

var

  I : Integer;

  J : Integer;

  R : WideString;

Begin

  case format of

    INT_CREWEL : R := sDouble;

    INT_MONGLINE_WIDE : R := sWide;

    INT_MONGLINE_THIN : R := sThin;

  end;

  for I := 1 To Length(value) do

    for j := 1 to 11 do

      if Pos(value[I], TabulationChars[J]) <> 0 then begin

        value[I] := R[J];

        break;

      end;

  Result := value;

end;

function CurrencySwitch(value : string; Format : Integer): string;

var

  i : integer;

  cur : string;

begin

  for i := 1 to length(value) do

  begin

    if (value[i] = '.') and (cur <> '') then

      cur := cur + '.' else

    if value[i] in ['0'..'9'] then

      cur := cur+value[i] else

    if cur = '' then

      result := result + value[i]

    else begin

      value := value + CurrencySwitch(strtoFloat(cur), format);

      cur := '';

    end;

  end;

  if cur <> '' then

    result := result + CurrencySwitch(strtoFloat(cur), format);

end;

function CurrencySwitch(value : Real; Format : Integer): string;

var

  sCurrency : widestring;

  function GetCurrency(I : Integer): string;

  begin

    result := '';

    If I <= Length(sCurrency) then result := sCurrency[I]

  end;

  function RightStr(value : string): string;

  begin

    result := value[Length(value)-1]+value[Length(value)];

  end;

var

  s : string;

  i : integer;

  w : integer;

begin

  case format of

    INT_CURRENCY_CHINESE_SIMPLE : sCurrency := 'Ԫʮ��ǧ��ʮ��ǧ��ʮ��ǧ';

    INT_CURRENCY_CHINESE_TRADITION : sCurrency := 'Բʰ��Ǫ�fʰ��Ǫ�|ʰ��Ǫ';

    INT_NUMERICAL_CHINESE_SIMPLE : sCurrency := '��ʮ��ǧ��ʮ��ǧ��ʮ��ǧ';

    INT_NUMERICAL_CHINESE_TRADITION : sCurrency := '�cʰ��Ǫ�fʰ��Ǫ�|ʰ��Ǫ';

  end;

  s := FloatToStr(abs(value));

  w := pos('.', s);

  If w = 0 Then w := length(s) + 1;

  for i := 1 to w-1 do

  begin

    If s[i]<>'0' Then

      result := result + s[i] + GetCurrency(w - i);


    //��ֹ���ظ�����

    If (s[i] = '0') and (s[i-1] <> '0') then

      result := result + s[i];


    //��֤��λ

    If (w - i = 9) and (pos(GetCurrency(9), result) = 0) then

      result := result + GetCurrency(9);


    //��֤��λ

    If (w - i = 5) and (pos(GetCurrency(5), result) = 0)

      and (copy(s, w - 8, 4) <> '0000') then

      result := result + GetCurrency(5);

  end;


  //�����β����ʱ

  if result[length(result)]='0' then

    Delete(result,length(result),1);


  //����������������ֵ�Ե��β

  if (format in [INT_NUMERICAL_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_TRADITION])

     and (w = length(s) + 1) and (RightStr(result) = GetCurrency(1)) then

      Delete(Result, Length(Result)-1, 2);


  //��һ������֤��û����Ԫ����β

  If RightStr(result) <> GetCurrency(1) then

  begin

    // ���Ҫ�󷵻�ֵ��һ�����ʱ��ֱ�Ӽ���Ԫ

    // ���Ҫ�󷵻�ֵ��һ����ֵʱ������֤�Ƿ���һ������������������ϵ�

    If ((w <> length(s) + 1) and

      (format in [INT_NUMERICAL_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_TRADITION])) or

      (format in [INT_CURRENCY_CHINESE_SIMPLE, INT_CURRENCY_CHINESE_TRADITION]) then

      result := result + GetCurrency(1);

  end;


  //����һ������ʱ

  if (w = length(s) + 1) then

    result := result + '��';


  //��һ����ת��С��������ֵ

  for I := w+1 to length(s) do

  begin

    If (s[i] = '0') and (s[i-1] <> '0') then

      result := result + s[i];

    if s[i] <> '0' then

    begin

      result := result + s[i];


      //����ʽ��Ǯ��ʱ, ���봦��λ

      if (format in [1, 2]) then

        result := result + copy('�Ƿ�',(i-w)*2-1,2);

    end;

  end;


  //��һ���ǽ�ת�������ֵ��д��������}

  if (format in [INT_CURRENCY_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_SIMPLE]) then

    result := NumberSwitch(result, INT_ARABIC_NUMERALS, INT_CHINESE_SIMPLE_NUMBER)

    else result := NumberSwitch(result, INT_ARABIC_NUMERALS, INT_CHINESE_TRADITION_NUMBER);

  if value < 0 then result := '��' + result;

end;

function StrStatistic(value : wideString): TStrInfo;

var

  I : Integer;

begin

  with Result do

  begin

    CharAmount := Length(value);

    LowerCase := 0;

    UpperCase := 0;

    Blank := 0;

    Tabs := 0;

    Enter := 0;

    CtrlChar := 0;

    ArabicNumerals := 0;

    UnicodeChar := 0;

    AnsiChar := 0;

    for I := 1 to Length(value) do

    begin

      // �ж��Ƿ��ֽڻ���˫�ֽ�

      if (length(string(value[i])) = 1) then

        Inc(AnsiChar)

        else Inc(UnicodeChar);


      // �ж��Ƿ��Ǵ�д��ĸ

      If (value[i] >= 'A') and (value[i] <= 'Z') then

        Inc(UpperCase);


      // �ж��Ƿ���Сд��ĸ

      If (value[i] >= 'a') and (value[i] <= 'z') then

         Inc(LowerCase);


      // �ж��Ƿ�ո�

      If value[i] = #32 then

        Inc(Blank);


      // �ж��Ƿ�س����з�

      If (i > 1) and (value[i - 1] = #13) and (value[i] = #10) then

        Inc(Enter);


      // �ж��Ƿ����Ʊ��

      If value[i] = #9 then

        Inc(Tabs);


      // �ж��Ƿ��ǿ����ַ�

      If (value[i] >= #0) and (value[i] <= #31) then

        Inc(CtrlChar);


      // �ж��Ƿ�������

      If (value[i] >= #48 ) and (value[I] <= #57) then

         Inc(ArabicNumerals);

    end;

  end;

end;

function ExtractHtml(value :string):string;

const

  CR=#13#10;

var

  NextToken,s0 : string;

  i:integer;

  HelpIdx:integer;

  inQuot:boolean;        // ȥ��<script>��֮��

  InputLen:integer;

  InputIdx:integer;      // ָ�������ַ�����һ���������ַ�

  inPre:boolean;         // ��ʾ�Ƿ���<pre>...</pre>����

  CurrLink:string;


  function MakeStr(C: Char; N: Integer): string;

  begin

    if N < 1 then Result := ''

    else begin

      {$IFNDEF WIN32}

      if N > 255 then N := 255;

      {$ENDIF WIN32}

      SetLength(Result, N);

      FillChar(Result[1], Length(Result), C);

    end;

  end;

  function NPos(const C: string; S: string; N: Integer): Integer;

  var

    I, P, K: Integer;

  begin

    Result := 0;

    K := 0;

    for I := 1 to N do

    begin

      P := Pos(C, S);

      Inc(K, P);

      if (I = N) and (P > 0) then

      begin

        Result := K;

        Exit;

      end;

      if P > 0 then Delete(S, 1, P)

      else Exit;

    end;

  end;

  function ReplaceStr(const S, Srch, Replace: string): string;

  var

    I: Integer;

    Source: string;

  begin

    Source := S;

    Result := '';

    repeat

      I := Pos(Srch, Source);

      if I > 0 then

      begin

        Result := Result + Copy(Source, 1, I - 1) + Replace;

        Source := Copy(Source, I + Length(Srch), MaxInt);

      end

      else Result := Result + Source;

    until I <= 0;

  end;

  function UnixToDos(const s:string):string;

  begin

    result:=AdjustLineBreaks(s);

  end;

  // ȡ����һ���ַ���

  function GetNextToken(const s:string; const StartIdx:integer):string;

  var

    i:integer;

  begin

    if StartIdx>length(s) then

    begin

      result:='';

      exit;

    end;

    result:=s[StartIdx];

    if result='&' then

    begin

      for i:=StartIdx+1 to length(s) do

      begin

        if s[i] in ['&',' ',#13,'<'] then break;

        result:=result+s[i];

        if s[i]=';' then break;

      end;

    end

    else if result='<' then

    begin

      for i:=StartIdx+1 to length(s) do

      begin

        result:=result+s[i];

        if s[i]='>' then break;

      end;

    end

    else begin

      for i:=StartIdx+1 to length(s) do

       if s[i] in ['&','<'] then break

       else result:=result+s[i];

    end;

  end;

  // ���룺<a href="http://anjo.delphibbs.com">

  // �����http://anjo.delphibbs.com

  function GetLink(s:string):string;

  var

    LPos,RPos,LQuot,RQuot:integer;

  begin

    result:='';

    // ȥ��'....<'

    LPos:=pos('<',s);

    if LPos=0 then exit;

    delete(s,1,LPos);

    s:=Trim(s);

    // ȥ��'>....'

    RPos:=pos('>',s);

    if RPos=0 then exit;

    delete(s,RPos,MaxInt);

    if uppercase(copy(s,1,2))='A ' then

    begin

      LPos:=pos('HREF',uppercase(s));

      if LPos=0 then exit;

      LQuot:=NPos('"',s,1);

      RQuot:=NPos('"',s,2);

      if (LQuot<LPos) or (RQuot>RPos) then exit;

      // ��ͷ��'#'�ĳ����ӣ���Ϊ��Ч

      if s[LQuot+1]='#' then exit;

      // ��ͷ��'javascript:'�ĳ����ӣ�Ҳ��Ϊ��Ч

      // �磺<div align=right><a href="javascript:window.close()"><IMG SRC="button_close.gif"></a></div>

      if copy(s,LQuot+1,11)='javascript:' then exit;

      result:=copy(s,LQuot+1,RQuot-LQuot-1);

    end;

  end;

  // ������&xxx��ת�壻����<xxx>ȡ����������������

  function ConvertHTMLToken(const s:string;var inPre:boolean):string;

  var

    s0,s0_2,s0_3,s0_4:string;

  begin

    if s='' then

    begin

      result:='';

      exit;

    end;

    if s[1]='&' then

    begin

      s0:=lowerCase(s);

      result:='';

      if s0='&nbsp;' then result:=' '

      else if s0='&quot;' then result:='"'

      else if s0='&gt;' then result:='>'

      else if s0='&lt;' then result:='<'

      else if s0='&middot;' then result:='��'

      else if s0='&trade;' then result:=' TM '

      else if s0='&copy;' then result:='(c)'

      else if s0='&reg;' then result:='(R)'

      else if s0='&amp;' then result:='&';

    end

    else if s[1]='<' then

    begin

      s0:=lowerCase(s);

      s0_2:=copy(s0,1,2);

      s0_3:=copy(s0,1,3);

      s0_4:=copy(s0,1,4);

      result:='';

      // ������<hr>�滻��Ϊ'------'

      if s0='<br>' then result:=CR

      else if s0_4='<pre' then   // <pre һ��Ҫ�� <p ֮ǰ�жϣ�

      begin

        inPre:=true;

        result:=CR;

      end

      else if s0_2='<p' then result:=CR+CR

      else if s0_3='<hr' then result:=CR+MakeStr('-',40)+CR

      else if s0_3='<ol' then result:=CR

      else if s0_3='<ul' then result:=CR

      else if s0_3='<li' then result:='��'

      else if s0_4='</li' then result:=CR

      else if s0_4='</tr' then result:=CR

      else if s0='</td>' then result:=#9

      else if s0='<title>' then result:='��'

      else if s0='</title>' then result:='��'+CR+CR

      else if s0='</pre>' then inPre:=false

      else if copy(s0,1,6)='<table' then result:=CR

      else if (s0[2]='a') then

      begin

        CurrLink:=GetLink(s);

        if CurrLink<>'' then result:='[';

      end

      else if (s0='</a>') then

        if CurrLink<>'' then result:=format(' %s ]',[CurrLink]);

    end

    else if inPre then result:=s

    else // ����<pre>..</pre>�ڣ���ɾ������CR

      result:=ReplaceStr(s,CR,'');

  end;

begin

  s0:=UnixToDos(value);

  result:='';

  InputLen:=length(s0);

  InputIdx:=1;

  inPre:=false;

  CurrLink:='';

  while InputIdx<=InputLen do

  begin

    NextToken:=GetNextToken(s0,InputIdx);

    // ȥ��<style ...> -- </style>֮�������

    if lowercase(copy(NextToken,1,6))='<style' then begin

      while lowercase(NextToken)<>'</style>' do begin

        inc(InputIdx,length(NextToken));

        NextToken:=GetNextToken(s0,InputIdx);

      end;

      inc(InputIdx,length(NextToken));

      NextToken:=GetNextToken(s0,InputIdx);

    end;


    // ȥ��<Script ...> -- </Script>֮�������

    if lowercase(copy(NextToken,1,7))='<script' then

    begin

      inc(InputIdx,length(NextToken));

      inQuot:=false;

      i:=InputIdx-1;

      while I<InputLen do

      begin

        inc(i);

        if s0[i]='"' then

        begin

          inQuot:=not inQuot;

          continue;

        end;

        if not inQuot then

          // ȥ��<script>�����<!-- ... -->ע�Ͷ�, 99.8.2

          if copy(s0,i,4)='<!--' then

          begin

            HelpIdx:=pos('-->',copy(s0,i+4,MaxInt));

            if HelpIdx>0 then

            begin

              inc(i,4+HelpIdx+2);

            end

            else begin

              i:=InputLen;

              break;

            end;

          end;

        if lowercase(copy(s0,i,9))='</script>' then

        begin

          break;

        end;

      end;

      InputIdx:=i;

    end;

    NextToken:=GetNextToken(s0,InputIdx);

    inc(InputIdx,length(NextToken));

    result:=result+ConvertHTMLToken(NextToken,inPre);

  end;

end;

function ExtractURL(value, Delimiter : string) : string;

const

  URLHeads : array[1..6] of string =

    ('http://', 'ftp://', 'news:', 'mailto:', 'https://', 'telnet:');

  URLHeadChar : set of Char =

    ['h', 'f', 't', 'n', 'm'];

  URLChars : set of Char =

    ['0'..'9', 'A'..'Z', 'a'..'z', ':', '.', '/', '\', '@','?', '_'];

  //�ж��Ƿ������ӵ�ַ��ͷ

  function IsURL(var index : integer): integer;

  var

    i : integer;

  begin

    result := -1;

    If value[index] in URLHeadChar then

      for i := low(URLHeads) to High(URLHeads) do

        If copy(value, index, length(URLHeads[i])) = URLHeads[i] then

        begin

          result := i;

          inc(index, length(URLHeads[I]));

          exit;

        end;

  end;

var

  I, P : Integer;

  Head, url : string;

begin

  I := 1;

  while I <= Length(value) do

  begin

    P := IsUrl(I);

    If P > -1 then

    begin

      head := URLHeads[p];

      url := '';

      for I := i To Length(value)+1 do

      begin

        If (value[i] in URLChars) then

        begin

          //�����һ�������ӵ�ַͷ���������

          P := IsUrl(I);

          IF P > -1 then break;

          url := url + value[i];

        end else break;

      end;

      If Length(url)>0 then

      begin

        result := result + Head + url + Delimiter;

      end;

    end;

    Inc(i,1);

  end;

end;

function ExtractEmail(value, Delimiter : String): string;

var

  I, n : Integer;

  Eleft, Eright: String;

begin

  for I := 1 to Length(value) do

    If value[I] = '@' then

    begin

      ELeft  := '';

      Eright := '';

      for n := I-1 downto 1 do

        If not (value[n] in [',','{','}','@',';',':','[',']','(',')','"','?','*',#0..#32,#128..#255]) then

          Eleft := value[n]+Eleft

          else Break;

      for n := I+1 to Length(value) do

        If not (value[n] in [',','{','}','@',';',':','[',']','(',')','"','?','*',#0..#32,#128..#255]) Then

          Eright := Eright+value[n]

          else Break;

      If (length(Eleft)>0) and (length(Eright)>0) Then

        result := result + Eleft + '@' + Eright + Delimiter;

    end;

end;

function TabToSpace(value: string; TabWidth : Integer): string;

var

  s: string;

begin

  FillChar(s, TabWidth, ' ');

  FastAnsiReplace(value, #9, s, [rfReplaceAll, rfIgnoreCase]);

end;

function SpaceToTab(value : string; TabWidth : Integer): string;

var

  s: string;

begin

  FillChar(s, TabWidth, ' ');

  FastAnsiReplace(value, s, #9, [rfReplaceAll, rfIgnoreCase]);

end;

function GetRandomStr(Source : string; StrLen : Integer) : string;

var

  I: Byte;

begin

  Result := '';

  If Source <> '' then

  begin

    for I := 0 to StrLen do

      Result := Result + Source[Random(Length(Source)-1)+1];

  end;

end;

function Dec2Bin(value : Integer; MinBit : Integer) : string;

begin

  result := '';

  while (value > 0) do

  begin

    if (Trunc(value / 2) * 2 = value) then

      result := '0' + result

    else Result := '1' + Result;

    value := Trunc(value / 2);

  end;

  //����MaxBitλ

  while (Length(Result) < MinBit) Do Result := '0' + Result;

end;

function Bin2Dec(const value : string) : Integer;

var

  NIndex, NLength : Integer;

begin

  result := 0;

  nLength := Length(value);

  for nIndex := 0 to nLength - 1 do

    If (value[nLength - nIndex] = '1') then

      Inc(result, Trunc(Power(2, nIndex)));

end;

function Hex2Dec(const value : string): Integer;

var

  nIndex, nLength : Integer;

  C : char;

begin

  result := 0;

  nLength := Length(value);

  for nIndex := 0 To nLength - 1 do

  begin

    C := Value[nLength - nIndex];

    If ((c >= 'A') And (c <= 'F')) then

      Inc(Result, (ord(c) - 55) * Trunc(Power(16, nIndex)))

    else If ((c >= '0') And (c <= '9')) then

      Inc(Result, (ord(c) - 48) * Trunc(Power(16, nIndex)));

  end;

end;

function Hex2Str(const value : string) : string;

var

  I : integer;

  J : integer;

  T : String;

  S : String;

begin

  S := Trim(value);

  SetLength(result, Length(value) div 2 );

  SetLength(T, 3);

  I := 1;

  J := 1;

  T[1] := '$';

  while I < Length(S) do

  begin

    T[2] := S[I];

    T[3] := S[I+1];

    if (T[2] In ['0'..'9','A'..'F','a'..'f']) and

      (T[3] In ['0'..'9','A'..'F','a'..'f']) then

    begin

      result[J] := Char(StrTointDef(T, 0));

      Inc(J,1);

    end;

    Inc(I, 2);

  end;

  If J <> Length(Value) div 2 Then Setlength(Result, J);

end;

function Mem2Hex(Buffer: PChar; Size : Longint): string;

const

  CharHex : array[#0..#255] of string[2]=(

    '00','01','02','03','04','05','06','07','08','09','0A','0B','0C','0D','0E','0F',

    '10','11','12','13','14','15','16','17','18','19','1A','1B','1C','1D','1E','1F',

    '20','21','22','23','24','25','26','27','28','29','2A','2B','2C','2D','2E','2F',

    '30','31','32','33','34','35','36','37','38','39','3A','3B','3C','3D','3E','3F',

    '40','41','42','43','44','45','46','47','48','49','4A','4B','4C','4D','4E','4F',

    '50','51','52','53','54','55','56','57','58','59','5A','5B','5C','5D','5E','5F',

    '60','61','62','63','64','65','66','67','68','69','6A','6B','6C','6D','6E','6F',

    '70','71','72','73','74','75','76','77','78','79','7A','7B','7C','7D','7E','7F',

    '80','81','82','83','84','85','86','87','88','89','8A','8B','8C','8D','8E','8F',

    '90','91','92','93','94','95','96','97','98','99','99','9B','9C','9D','9E','9F',

    'A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','AA','AB','AC','AD','AE','AF',

    'B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','BA','BB','BC','BD','BE','BF',

    'C0','C1','C2','C3','C4','C5','C6','C7','C8','C9','CA','CB','CC','CD','CE','CF',

    'D0','D1','D2','D3','D4','D5','D6','D7','D8','D9','DA','DB','DC','DD','DE','DF',

    'E0','E1','E2','E3','E4','E5','E6','E7','E8','E9','EA','EB','EC','ED','EE','EF',

    'F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','FA','FB','FC','FD','FE','FF'

  );

var

  I, Len: Longint;

begin

  SetLength(result, Size*2+1);

  for I := 0 to size -1 do

  begin

    result[I*2+1] := CHarHex[Buffer[I]][1];

    result[I*2+2] := CHarHex[Buffer[I]][2];

  end;

end;

function Str2Hex(value : string): string;

begin

  result := Mem2Hex(PChar(value), length(value));

end;

function StrAlignment(const value : string; PageWidth : Integer;

  Alignment : TAlignment): string;

var

  StrList : TStrings;

  i : Integer;

  function GetSpace(Count : integer): string;

  var i : integer;

  begin

    SetLength(Result, Count);

    for i := 1 to Count do

      Result[i] := #32;

  end;

begin

  StrList := TStringList.Create;

  result := value;

  try

    StrList.Text := value;

    for i := 0 to StrList.Count - 1 do

    begin

       StrList[i] := StrTrimLeft(StrTrimRight(StrList[i]));

       if StrList[i] <> '' then

         case Alignment of

           taRightJustify :

             if (PageWidth - Length(StrList[i])) > 0 then

                StrList[i] := GetSpace(PageWidth - Length(StrList[i])) + StrList[i];

           taCenter :

             if ((PageWidth - Length(StrList[i])) div 2) > 0 then

                StrList[i] := GetSpace(((PageWidth - Length(StrList[i])) div 2)) + StrList[i];

         end;

    end;

    result := Strlist.text;

  finally

    StrList.Free;

  end;

end;

function StrWrap(const Text, LineBreak: string;  const Reorder : boolean;

  const Hanging, FirstLine, LeftSpace, PageWidth : Integer;

  const Break : string; const BreakMode : Integer  {0 ���ַ�ǰ���� 1 ���ַ�����}

  ): string;

var

  Col, Pos : integer;

  Line, Lines : string;

  procedure FillSpace(Count : integer);

  var i : integer;

  begin

    for i := 1 to Count do

      Line[i] := #32;

  end;

begin

  Pos := 1;

  SetLength(Line, PageWidth);

  FillSpace(LeftSpace + FirstLine);

  Col := LeftSpace + FirstLine + 1;

  while Pos < Length(Text) do

  begin

    if Copy(Text, Pos, length(LineBreak)) = LineBreak then

    begin

      Inc(Pos, length(LineBreak));

      if not Reorder then

      begin

        Lines := Lines + copy(Line, 1, Col - 1) + LineBreak;

        FillSpace(LeftSpace + FirstLine);

        Col := LeftSpace + FirstLine + 1;

      end;

      Continue;

    end;

    if (Break <> '') and (Copy(Text, Pos, length(Break)) = Break) then

    begin

      if (BreakMode = 0) then

      begin

        Lines := Lines + copy(Line, 1, Col - 1) + LineBreak;

        FillSpace(LeftSpace + FirstLine);

        Col := LeftSpace + FirstLine + 1;

        Inc(Pos);
        
      end

      else begin

        if ( (Length(Break) + Col - 1) > PageWidth) then

        begin

          Lines := Lines + copy(Line, 1, Col - 1) + LineBreak;

          if Hanging <= 0 then

          begin

            FillSpace(LeftSpace);

            Col := LeftSpace + 1;

          end

          else begin

            FillSpace(LeftSpace + FirstLine + Hanging);

            Col := LeftSpace + FirstLine + Hanging + 1;

          end;

        end;

        Lines := Lines + copy(Line, 1, Col - 1) + Break + LineBreak;

        inc(Pos, Length(Break));

        FillSpace(LeftSpace + FirstLine);

        Col := LeftSpace + FirstLine + 1;

      end;

      continue;

    end;

    Line[Col] := Text[Pos];

    Inc(Col);

    if (Col > PageWidth) then

    begin

      // ��֤˫�ֽ��ַ�

      if ByteType(Text, Pos) = mbLeadByte then

      begin

        Dec(Col, 2);

        Dec(Pos);

      end;

      Lines := Lines + copy(Line, 1, Col) + LineBreak;

      if Hanging <= 0 then

      begin

        FillSpace(LeftSpace);

        Col := LeftSpace + 1;


      end

      else begin

        FillSpace(LeftSpace + FirstLine + Hanging);

        Col := LeftSpace + FirstLine + Hanging + 1;

      end;

    end;

    Inc(Pos);

  end;

  Result := Lines + copy(Line, 1, Col-1);

end;

function GBToBIG5(value: string): string;

var

  GBTAB : TResourceStream;

  bak : string;

  C : array[0..1] of Byte;

  I : Integer;

  W : PWordArray;

  CA : array[0..2] of Char;

begin

  try

    GBTAB := TResourceStream.Create(HInstance, 'GBToBIG5', RT_RCDATA);

    bak := '';

    W := @(C[0]);

    I := 1;

    while I <= Length(value) do

    begin

      C[1] := Byte(value[I]);

      if C[1] > $A0 then

      begin

        inc(I, 1);

        C[0] := Byte(value[I]);

        inc(I, 1);

        W[0] := W[0] - GBfirst;

        GBTAB.Position := W[0] * 2;

        GBTAB.read (CA, 2);

        CA[2] := #0;

        bak := bak + StrPas(CA);

      end

      else begin

        bak := bak + value[I];

        inc(I, 1);

      end;

    end;

  finally

    Result := bak;

  end;

end;

function BIG5ToGB(value: string): string;

var

  BIGTAB : TResourceStream;

  bak : string;

  C : array[0..1] of Byte;

  I : Integer;

  W : PWordArray;

  CA : array[0..2] of Char;

begin

  BIGTAB := TResourceStream.Create(Hinstance, 'BIG5ToGB', RT_RCDATA);

  Try

    bak := '';

    I := 1;

    w:=@(C[0]);

    while I <= Length(Value) do

    begin

      C[1] := Byte(Value[I]);

      if C[1] > $A0 then

      begin

        inc(I, 1);

        C[0] := byte(Value[I]);

        inc(I, 1);

        W[0] := W[0] - BIGfirst;

        BigTAB.Position:= W[0]*2;

        BIGTAB.Read(CA,2);

        CA[2]:=#0;

        bak := bak + StrPas(CA);

      end

      else begin

        bak := bak + Value[I];

        inc(I, 1);

      end;

    end;

  finally

    BIGTAB.Free;

    Result := bak;

  end;

end;

function GetGBKOffset(value : string): integer;

begin

  result := -1;

  if length(value)>=2 then

     result := (ord(value[1])-$81)*190+(ord(value[2])-$40);

end;

procedure LoadGBKCodeRes;

var

  sSimple,

  sTradition : widestring;

  s : string;

  P, w, I : integer;

  function getWideChar(s : widestring): WideChar;

  begin

    result:=s[1];

  end;

begin

  If (Length(sChineseTradition)=0) or (Length(sChineseSimple)=0) then

  begin

    SetLength(sChineseTradition, 44780);

    SetLength(sChineseSimple, 44780);

    for I := $81 to $FE do

      for w := $40 to $FE do

        If (w <> $7F) then

        begin

          P := (I-$81)*190+(W-$3f);

          sChineseTradition[p] := getWideChar(char(I)+char(w));

          sChineseSimple[p] := sChineseTradition[p];

        end;

    SetLength(sChineseTradition, P);

    SetLength(sChineseSimple, P);

    sSimple :=  StringFromResource('GBKSimple', RT_RCDATA);

    sTradition := StringFromResource('GBKTradition', RT_RCDATA);

    for I := 1 to length(sSimple) do

    begin

      w := GetGBKOffset(sSimple[I]);

      If (w >= 0) and (W < P) then

        sChineseTradition[w+1] := sTradition[I];

      w := GetGBKOffset(sTradition[I]);

      If (w >= 0) and (W < P) then

        sChineseSimple[w+1] := sSimple[I];

    end;

  end;

end;

function GBKToTraditional(value : widestring): string;

var

  I : Integer;

  P : Integer;

begin

  LoadGBKCodeRes;

  for I := 1 To Length(value) do

  begin

    IF IsGBK(value[i]) then

    begin

      P := GetGBKOffset(value[i]);

      If (P >= 0) then  value[I] := sChineseTradition[P+1];

    end;

  end;

  Result := value;

end;

function GBKToSimplified(value : widestring): string;

var

  I : Integer;

  P : Integer;

begin

  LoadGBKCodeRes;

  for I := 1 To Length(value) do

  begin

    IF IsGBK(value[i]) then

    begin

      P := GetGBKOffset(value[i]);

      If (P >= 0) then value[I] := sChineseSimple[P+1];

    end;

  end;

  Result := value;

end;

function IsBIG5(value: string): Boolean;

begin

  Result := false;

  if (length(value)>=2) then

    Result := (value[1] in [#129..#254]) and

      (value[2] in [#64..#126, #161..#254]);

end;

function IsGB(value: string): Boolean;

begin

  Result := true;

  if (length(value)>=2) then

    result := (value[1] in [#176..#247]) and (value[2] in [#161..#254]);

end;

function IsGBK(value: string): Boolean;

begin

  Result := true;

  if (length(value)>=2) then

    result := (value[1] in [#129..#254]) and

      (value[2] in [#64..#126, #128..#254]);

end;

procedure LoadGBKSpellRes;

var

  sSpell : TStrings;

  sSpellStream: TResourceStream;

  s : widestring;

  P, w, I : integer;

begin

  If (Length(sChineseSpell)=0) then

  begin

    //������Դ

    sSpell := TStringList.Create;

    sSpellStream := TResourceStream.Create(Hinstance, 'GBKSpell', RT_RCDATA);

    sSpell.LoadFromStream(sSpellStream);

    sSpellStream.Free;

    //��ʼ������

    SetLength(sChineseSpell, 44780);

    for I := $81 to $FE do

      for w := $40 to $FE do

        If (w <> $7F) then

        begin

          P := (I-$81)*190+(W-$40);

          sChineseSpell[p] := char(I)+char(w);

        end;

    SetLength(sChineseSpell, P+1);

    //��������

    for I := 0 to sSpell.Count-1 do

    begin

      s := sSpell[I];

      w := getGBKOffset(s);

      If (w >= 0) and (W < P) then

      begin

        delete(s, 1, 1);

        sChineseSpell[W] := s;

      end;

    end;

  end;

end;

function GBKToSpell(value : widestring): string;

var

  I : Integer;

  w : Integer;

  s : String;

begin

  LoadGBKSpellRes;

  for I := 1 to length(value) do

  begin

    If IsGBK(value[I]) then

    begin

      S := value[I];

      w := GetGbkOffset(value[i]);

      If w >= 0 then result := result+' '+sChineseSpell[w];

    end

    else result := result+' '+value[I]

  end;

end;

function ChinesePunctuation(value : widestring): string;

var

  I , p  : integer;

  b1, b2 : Boolean;

begin

  result := '';

  b1 := False;

  b2 := False;

  for I := 1 To Length(value) Do

  begin

    P := Pos(value[I], DBCCasePunctuations);

    If P <> 0 Then

    begin

      If value[i] = '"' Then

      begin

        If b1 Then Inc(P);

        b1 := not b1;

      End;

      If value[i] = '''' Then

      begin

        If b2 Then Inc(P);

        B2 := Not B2;

      end;

      value[I] := SBCCasePunctuations[P];

    end;

  end;

  result := value;

end;

function EnglishPunctuation(value : widestring): string;

begin

  result := StrCorrect(value, SBCCasePunctuations, DBCCasePunctuations)

end;

function GBKToSpellIndex(value: widestring): string;

var

  I : integer;

  s : string;

begin

  for i := 1 to Length(value) do

  begin

    s := value[i];

    If (Length(s) > 1) then

      case word (s[1]) shl 8 + word(s[2]) of

        $B0A1..$B0C4 : Result := Result + 'A';

        $B0C5..$B2C0 : Result := Result + 'B';

        $B2C1..$B4ED : Result := Result + 'C';

        $B4EE..$B6E9 : Result := Result + 'D';

        $B6EA..$B7A1 : Result := Result + 'E';

        $B7A2..$B8C0 : Result := Result + 'F';

        $B8C1..$B9FD : Result := Result + 'G';

        $B9FE..$BBF6 : Result := Result + 'H';

        $BBF7..$BFA5 : Result := Result + 'J';

        $BFA6..$C0AB : Result := Result + 'K';

        $C0AC..$C2E7 : Result := Result + 'L';

        $C2E8..$C4C2 : Result := Result + 'M';

        $C4C3..$C5B5 : Result := Result + 'N';

        $C5B6..$C5BD : Result := Result + 'O';

        $C5BE..$C6D9 : Result := Result + 'P';

        $C6DA..$C8BA : Result := Result + 'Q';

        $C8BB..$C8F5 : Result := Result + 'R';

        $C8F6..$CBF9 : Result := Result + 'S';

        $CBFA..$CDD9 : Result := Result + 'T';

        $CDDA..$CEF3 : Result := Result + 'W';

        $CEF4..$D188 : Result := Result + 'X';

        $D1B9..$D4D0 : Result := Result + 'Y';

        $D4D1..$D7F9 : Result := Result + 'Z';

      end;

  end;

end;

function ExpressionEval(Expression: string; var Error: Boolean): Extended;

type

  PItem = ^TItem;

  TItem = record

    Ch : Char;

    Nu : Real;

    no : Boolean;

  end;

const

  Operator : Set of Char =

    ['!', '&', '|', '^', '<', '>', '*', '/', '$', '%', '+', '-'];

  OperChar  = '!&|^<>*/$%+-';

var

  APOS : Integer;

  function Fact(I: Integer): Real;

  begin

    if I > 0 then Fact:=I*Fact(I-1)

    else Fact:=1;

  end;

  function AParse : Extended;

  var

    I : Integer;

    J : Integer;

    P : PItem;

    L : TList;

    T : String;

    function AFunc : Extended;

    var

      I : Integer;

      S : String;

    begin

      Inc(APOS);

      for I := APOS downto 1 do

      begin

        if Not (Expression[I] In ['a'..'z', 'A'..'Z', '0'..'9']) then

          Break;

      end;

      S := Copy(Expression, I+1, APOS-I);

      Result := AParse;

      for I := 0 to Length(S) do

        if S[I] in ['A'..'Z'] then  S[I] := Char(Ord(S[I])+32);

      (*!~ �����ڴ�����Ҫ֧�ֵĺ��� *)

      (*!~ ��ʽ��if S = ������ then Result := ����(result) *)

      if S = 'abs' then Result := Abs(Result)

      else if S = 'sqrt' then Result := sqrt(Result)

      else if S = 'sqr' then  Result := sqr(Result)

      else if S = 'sin' then  Result := sin(Result)

      else if S = 'cos' then  Result := cos(Result)

      else if S = 'arctan' then Result := arctan(Result)

      else if S = 'ln' then Result := ln(Result)

      else if S = 'log' then Result := ln(Result)/ln(10)

      else if S = 'exp' then  Result := exp(Result)

      else if S = 'fact' then Result := fact(Trunc(Result))

      else if S = 'frac' then Result := frac(Result)

      else if S = 'int' then Result := int(Result)

      else if S = 'round' then Result := round(Result)

      else if S = 'trunc' then Result := trunc(Result)

    end;

    function GetValue(s : String): Real;

    begin

      Result := 0;

      Try

        Result := StrtoFloat(S);

      Except

        Error := True;

      end;

    end;

  begin

    Inc(APOS);

    Result := 0;

    New(P);

    L := TList.Create;

    L.Add(P);

    while  APOS <= Length(Expression) do

    begin

      (*!~ ����ȡ�����Ž��м�¼ *)

      if (Expression[APOS] = '!') then P.no := True

      (*!~ �������Ž��еݹ���� *)

      else if (Expression[APOS] = '(') then

      begin

        (*!~ ����Ǳ��ʽ *)

        if (APOS = 1) or (Expression[APOS-1] = '(') or

          (Expression[APOS-1] IN Operator ) then

          P.Nu := AParse

        (*!~ ����Ǻ��� *)

        else  P.Nu := AFunc;

      end

      (*!~ ���������� *)

      else if (Expression[APOS] IN Operator) And ((APOS = 1) or

        ((APOS > 1) And ((Expression[APOS-1] IN Operator) or

        (Expression[APOS-1] = '(')))) then

        T := T+ Expression[APOS]

      else if Expression[APOS] IN Operator then

      begin

        if T <> '' then

          P.Nu := GetValue(T);

        New(P);

        T := '';

        P.Ch := Expression[APOS];

        L.Add(P)

      end

      (*!~ �������������� *)

      else if Expression[APOS] = ')' then

        Break

      else

        T := T+ Expression[APOS];

      if Error then Exit;

      Inc(APOS);

    end;

    if T <> '' then

      P.Nu := GetValue(T);

    for I := 1 to Length(OperChar) do

    begin

      J := 1;

      while (J < L.Count) And (L.Count > 1) do

      begin

        P := PItem(L.Items[J]);

        case I of

          (*!~ ����� *)

          1 : begin

            if P.no then

              P.Nu := (not round(P.Nu));

          end;

          else begin

            if p.Ch = OperChar[I] then

            begin

              (*!~ �����ڴ���������� *)

              case P.Ch of

                '&': P.Nu := (round(PItem(L.Items[J-1]).Nu) And round(P.Nu));

                '|': P.Nu := (round(PItem(L.Items[J-1]).Nu) or round(P.Nu));

                '^': P.Nu := (round(PItem(L.Items[J-1]).Nu) XOR round(P.Nu));

                '<': P.Nu := round(PItem(L.Items[J-1]).Nu) Shl round(P.Nu);

                '>': P.Nu := round(PItem(L.Items[J-1]).Nu) Shr round(P.Nu);

                '*': P.Nu := PItem(L.Items[J-1]).Nu * P.Nu;

                '/': P.Nu := PItem(L.Items[J-1]).Nu / P.Nu;

                '$': P.Nu := round(PItem(L.Items[J-1]).Nu) div round(P.Nu);

                '%': P.Nu := round(PItem(L.Items[J-1]).Nu) mod round(P.Nu);

                '+': P.Nu := PItem(L.Items[J-1]).Nu + P.Nu;

                '-': P.Nu := PItem(L.Items[J-1]).Nu - P.Nu;

              end;

              L.Delete(J-1);

              continue;

            end;

          end;

        end;

        Inc(J);

      end;

    end;

    Result := P.Nu;

    L.Free;

  end;

begin

  Error := False;

  Expression := Trim(Expression);

  APOS := 0;

  Result := AParse;

end;


function IntPower(Base, Exponent: Integer): Integer; {  ���� Base �� Exponent �η�  }

var

  I: Integer;

begin

  Result := 1;

  for I := 1 to Exponent do

    Result := Result * Base;

end; { IntPower }

function NumToStr (mNumber: Integer; mScale: Byte;

  mLength: Integer = 0): string;

var

  I, J: Integer;

begin

  Result := '';

  I := mNumber;

  while (I >= mScale) and (mScale > 1) do begin

    J := I mod mScale;

    I := I div mScale;

    Result := cScaleChar[J + 1] + Result;

  end;

  Result := cScaleChar[I + 1] + Result

end;

function StrToNum (mDigit: string; mScale: Byte): Integer;

var

  I: Byte;

  L: Integer;

begin

  Result := 0;

  mDigit := UpperCase(mDigit);

  L := Length(mDigit);

  for I := 1 to L do

    Result := Result + (Pos(mDigit[L - I + 1], cScaleChar) - 1) *

      IntPower(mScale, I - 1);

end;

function RomanNumerals(N: Integer): string;

var

  arabic : array[0..12] of Integer;

  roman : array[0..12] of string;

  I: Integer;

begin

  arabic[0] := 1000;

  arabic[1] := 900;

  arabic[2] := 500;

  arabic[3] := 400;

  arabic[4] := 100;

  arabic[5] := 90;

  arabic[6] := 50;

  arabic[7] := 40;

  arabic[8] := 10;

  arabic[9] := 9;

  arabic[10] := 5;

  arabic[11] := 4;

  arabic[12] := 1;

  roman[0] := 'M';

  roman[1] := 'CM';

  roman[2] := 'D';

  roman[3] := 'CD';

  roman[4] := 'C';

  roman[5] := 'XC';

  roman[6] := 'L';

  roman[7] := 'XL';

  roman[8] := 'X';

  roman[9] := 'IX';

  roman[10] := 'V';

  roman[11] := 'IV';

  roman[12] := 'I';


  for I := 0 to 12 do

  begin

    while N >= arabic[i] do

    begin

      N := N - arabic[i];

      Result := Result + roman[i]

    end;

  end;

end;

initialization

  Randomize;

finalization

end.
