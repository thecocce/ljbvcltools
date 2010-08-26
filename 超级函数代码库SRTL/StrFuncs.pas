{-------------------------------------------------------------------------------

   单元: StrFuncs.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.12.06

   版本: 1.00

   说明: 字符串处理单元

-------------------------------------------------------------------------------}


unit StrFuncs;


interface


uses

  Windows, SysUtils, Classes, Math, StrUtils, FastStrings, Streams, MessageDlg;


const

  { NumberSwitch }

  INT_CHINESE_NUMBER = 1; // 所有中文数字 包括简写与繁写

  INT_CHINESE_SIMPLE_NUMBER = 2; // 所有简写的中文数字

  INT_CHINESE_TRADITION_NUMBER = 3; // 所有繁写的中文数字;

  INT_ARABIC_NUMERALS = 4; // 所有阿拉伯数字

  { TabulationSwitch }

  INT_CREWEL = 1; // 双线形式的制表符;

  INT_MONGLINE_WIDE = 2; // 单粗线形式的制表符

  INT_MONGLINE_THIN = 3; // 单细线形式的制表符

  { CurrencySwitch }

  INT_CURRENCY_CHINESE_SIMPLE = 1; // 格式化为中文简写货币形式的格式

  INT_CURRENCY_CHINESE_TRADITION = 2; // 格式化为中文繁写货币形式的格式

  INT_NUMERICAL_CHINESE_SIMPLE = 3; // 格式化为中文简写数值形式的格式

  INT_NUMERICAL_CHINESE_TRADITION = 4; // 格式化为中文繁写数值形式的格式

  { WrapText }

  CHARS_UNALLOWED_EOL : TSysCharSet = ['(', '[', '{', '<'];

  CHARS_UNALLOWED_BOL : TSysCharSet = [')', ']', '}', '>', ';', ':', ',', '.', '?'];


type

  Strings = array of string;

  { Fast Replace Text }

  TFastTagReplaceProc = procedure (var Tag: string; const UserData: Integer);

  { TStrInfo 文件统计信息结构 }

  TStrInfo = record

    CharAmount : Integer;     // 共有字符个数

    LowerCase : Integer;      // 小写字母个数

    UpperCase : Integer;      // 大写字母个数

    Blank : Integer;          // 英文空格个数

    Tabs : Integer;           // 制表符个数

    Enter : Integer;          // 回车符号个数

    CtrlChar : Integer;       // 控制字符个数

    ArabicNumerals : Integer; // 英文数字个数

    UnicodeChar : Integer;    // 双字节字符个数

    AnsiChar : Integer;       // 单字节字符个数

  end;



// UpperCase 用于将字符串小写字母即是转换为相对应的大写字母

function UpperCase(value : string): string;


// LowerCase 用于将字符串大写字母转换为相对应的小写字母

function LowerCase(value : string): string;


// MutualCase 用于将字符串原先的字母大小写形式互换

function MutualCase(value : string): string;


// FirstUpperCase 用于将字符串中每一个词词首的字母转换为大写字母

function FirstUpperCase(value : string): string;


// SBCCase 转换字符串的半角字符为全角字符

function SBCCase(value : widestring): string;


// DBCCase 转换字符串的全角字符为半角字符

function DBCCase(value : widestring): string;


//  StrTrim 删除半角空格与全角空格

function StrTrim(value : widestring): string;


// StrTrimLeft 删除至字符串左边第一个非半角或全角空格的字符为止

function StrTrimLeft(value : widestring): string;


// StrTrimRight 删除至字符串右边第一个非半角或全角空格的字符为止

function StrTrimRight(value : widestring): string;


// StrTrimCtrlChar 删除字符串的所有控制字符即是ASCII码为#0 - #31的字符

function StrTrimCtrlChar(value : widestring): string;


// StrTrimLineBreak 删除字符串的所有回车换行符, 具体参照system的sLineBreak常量

function StrTrimLineBreak(value : widestring): string;


// OemToAnsi 将以OEM方式编码的字符串转换为ANSI编号

function OemToAnsi(value : AnsiString): AnsiString;


// AnsiToOem 将ANSI编码方式的字符串转换为以OEM方式编码的字符串

function AnsiToOem(value : AnsiString): AnsiString;


// Utf8ToAnsi 将以UTF8(一种Unicode种编码方式)方式编码的字符串转换为ANSI编码

function Utf8ToAnsi(value : UTF8String): AnsiString;


// AnsiToUtf8 将以ANSI编码方式的字符串转换为以UTF8方式编码的字符串

function AnsiToUtf8(value : AnsiString): UTF8String;


// Utf7ToAnsi 将以UTF7(一种Unicode种编码方式)方式编码的字符串转换为ANSI编码

function Utf7ToAnsi(value : AnsiString): WideString;


// AnsiToUtf7 将以ANSI编码方式的字符串转换为以UTF7方式编码的字符串

function AnsiToUtf7(value : WideString): AnsiString;


// AnsiToUnicode 将以ANSI编码方式的字符串转换为以UCS方式编码的字符串

function AnsiToUnicode(value : WideString): AnsiString;


// UnicodeToAnsi 将以UCS编码方式的字符串转换为以ANSI方式编码的字符串

function UnicodeToAnsi(value : AnsiString): WideString;


// DosToUnix 此函数是将DOS文本转换为UNIX文本

function DosToUnix(value : string): string;


// UnixToDos 此函数是将UNIX文本转换为DOS文本

function UnixToDos(value : string): string;


// UnMimeCode 将以MIME方式编码的字符串进行解码

function DecodeMime(value : string): string;


// UnQPCode 将以QP方式编码的字符串进行解码

function DecodeQP(value : string): string;


// UnHZCode 将以HZ方式编码的字符串进行解码

function DecodeHZ(value : string): string;


// StrSimilar　比较字符串的相似度 如 'Jim' and 'James' = 40%

function StrSimilar(s1, s2: string): Integer;


// StrUpset 将字符串倒转过来 此函数采用了宽字节 因此兼容双字节形式的编码

function StrUpset(value : WideString): widestring;


// StrCompare 比较字符串的相似度 如 StrCompare('David Stidolph','*St*') = true

function StrCompare(Source, Pattern: String): Boolean;


// StrStatistic 文本统计

function StrStatistic(value : wideString): TStrInfo;


// NumberSwitch 将字符串中的数字替换为指定格式的形式

function NumberSwitch(value : WideString; Source, Target : Integer): string;


// TabulationSwitch 格式化字符串中的制表符即是文本表格线

function TabulationSwitch(value : WideString; format : integer): string;


// CurrencySwitch 将字符串中的货币数值替换为指定格式的形式

function CurrencySwitch(value : string; Format : Integer): string; overload;

function CurrencySwitch(value : Real; Format : Integer): string; overload;


// ExtractHtml 提取HTML文档源代码的文本

function ExtractHtml(value :string):string;


// ExtractURL 提取字符串中的URL

function ExtractURL(value, Delimiter : string) : string;


// ExtractEmail 提取字符串的EMail地址

function ExtractEmail(value, Delimiter : String): string;


// TabToSpace 将TAB键的字符转换为相应宽度的空格

function TabToSpace(Value: string; TabWidth : Integer = 8): string;


// SpaceToTab 将字符串的空格转换为TAB键

function SpaceToTab(value : string; TabWidth : Integer = 8): string;


// GetRandomStr 生成随机的字符串

function GetRandomStr(Source : string; StrLen : Integer) : string;


// Dec2Bin 将十进制数字转换为二进制方式的数字字符串

function Dec2Bin(value : Integer; MinBit : Integer) : string;


// Bin2Dec 将二进制方式的数字字符串转换为十进制方式的数字

function Bin2Dec(const value : string) : Integer;


// Hex2Dec 将十六进制方式的数字字符串转换转换为十进制数方式的数字

function Hex2Dec(const value : string): Integer;


// Hex2Str 将十六进制方式的数字字符串转换转换为相应ASCII码的字符串

function Hex2Str(const value : String) : String;


// Mem2Hex 将字符串转换为十六进制方式的数字字符串

function Mem2Hex(Buffer: PChar; Size : Longint): string;


// Str2Hex 对于函数MemToHex的一个调用 主要是方便字符串变量类型的转换

function Str2Hex(value : string): string;



function StrAlignment(const value : string; PageWidth : Integer;

  Alignment : TAlignment): string;

// StrWrap 对一段文本进行换行

function StrWrap(const Text, LineBreak: string;  const Reorder : boolean;

  const Hanging, FirstLine, LeftSpace, PageWidth : Integer;

  const Break : String; const BreakMode : Integer  {0 在字符前换行 1 在字符后换行}

  ): string; 



// IsBIG5　是否是BIG5编码的汉字

function IsBIG5(value: string): Boolean;


{ IsGBK 是否是GBK编码的汉字

  GBK编码（俗称大字符集）是中国大陆制订的、等同于UCS的新的中文编码扩展国家标

  准。GBK工作小组于1995年10月，同年12月完成GBK规范。该编码标准兼容GB2312，共

  收录汉字21003个、符号883个，并提供1894个造字码位，简、繁体字融于一库。

  Windows95/98简体中文版的字库表层编码就采用的是GBK，通过GBK与UCS之间一一对

  应的码表与底层字库联系。其第一字节的值在 16 进制的 81～FE 之间，第二字节

  在 40～FE，除去xx7F一线。}

function IsGBK(value: string): Boolean;


{ IsGB　是否是GB编码的汉字

  GB2312-80 GB2312编码大约包含6000多汉字（不包括特殊字符）,编码范围为第一位

  b0-f7,第二位编码范围为a1-fe(第一位为cf时,第二位为a1-d3),计算一下汉字个数

  为6762个汉字。当然还有其他的字符。包括控制键和其他字符大约7573个字符编码。}

function IsGB(value: string): Boolean;


// GBToBIG5 将以GB编码的汉字转换为以BIG5的编码形式

function GBToBIG5(value: String): string;


// BIG5ToGB 将以BIG5编码的汉字转换为以GB的编码形式

function BIG5ToGB(value: String): string;


// GBToTraditional 将汉字全部转换为汉字繁写形式

function GBKToTraditional(value : widestring): string;


// GBKToSimplified 将汉字全部转换为汉字简写形式

function GBKToSimplified(value : widestring): string;


// GBKToSpell 将汉字转换为汉字拼音

function GBKToSpell(value : widestring): string;


// GBKToSpellIndex　返回汉字拼音的首个字母

function GBKToSpellIndex(value: widestring): string;


// ChinesePunctuation 格式化为中文符号 会自动检测成对单引号或双引号

function ChinesePunctuation(value : widestring): string;


// EnglishPunctuation 格式化为英文符号

function EnglishPunctuation(value : widestring): string;


// ExpressionEval 表达式求值

function ExpressionEval(Expression: string; var Error: Boolean): Extended;


// NumToStr 任意进制的数转换为字符串

function NumToStr (mNumber: Integer; mScale: Byte;

  mLength: Integer = 0): string;

// StrToNum 任意进制的字符串转换为数

function StrToNum (mDigit: string; mScale: Byte): Integer;

// RomanNumerals 返回十进制数字的罗马数字

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

  SBCCaseChars : widestring = '　！＂＃＄％＆＇（）＊＋，－。／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～';

  DBCCasePunctuations : WideString =  '\.,;:?!_-|()[]{}<>""''''';

  SBCCasePunctuations : WideString =  '、。，；：？！＿—｜〔〕［］｛｝《》“”‘’';


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

  //Base64字符集

var

  StrBin : String;

  nIndex : Integer;

  I : Integer;

Begin

  StrBin := '';

  {查找Base64字符，并转换为二进制}

  for nIndex := 1 To Length(value) Do

  begin

    I := Pos(value[nIndex], c_strBase64);

    If (I > 0) Then {填满6位，满足Base64编码原则}

      StrBin := strBin + Dec2Bin(i - 1, 6)

    {无输入字符时候，使用等号输出（这样的写法应该是错误的，但目前想不出好的写法）}

    else If (value[nIndex] = '=') Then

      StrBin := StrBin + '000000';

  end;

  {转换为8位长的字符}

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

  {查找编码字串标志}

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

        {填满8位，满足HZ编码原则}

        StrBin := Dec2Bin(ord(S[nIndex]), 8);

        {最高位置1}

        StrBin[1] := '1';

        S1 := S1 + Chr(Bin2Dec(StrBin));

      end;

    end;


    {替换原来的编码字串}

    Delete(result, nBeginIndex, nEndIndex - nBeginIndex + 2);

    Insert(s1, result, nBeginIndex);

    {查找编码字串标志}

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

    INT_CHINESE_NUMBER : sSource := '○一二三四五六七八九零壹贰叁肆伍陆柒捌玖';

    INT_CHINESE_SIMPLE_NUMBER : sSource := '○一二三四五六七八九';

    INT_CHINESE_TRADITION_NUMBER : sSource := '零壹贰叁肆伍陆柒捌玖';

    INT_ARABIC_NUMERALS : sSource := '01234567890123456789';

  end;

  case Target of

    INT_CHINESE_NUMBER : sTarget := '○一二三四五六七八九零壹贰叁肆伍陆柒捌玖';

    INT_CHINESE_SIMPLE_NUMBER : sTarget := '○一二三四五六七八九';

    INT_CHINESE_TRADITION_NUMBER : sTarget := '零壹贰叁肆伍陆柒捌玖';

    INT_ARABIC_NUMERALS : sTarget := '01234567890123456789';

  end;

  result := StrCorrect(value, sSource, sTarget);

end;

function TabulationSwitch(value : WideString; format : integer): string;

const

  TabulationChars : array[1..11] of WideString = (

    '─━┄┅┈┉',

    '│┃┆┇┊┋',

    '┌┍┎┏',

    '┐┑┒┓',

    '└┕┖┗',

    '┘┘┚┛',

    '├┝┞┟┠┡┢┣',

    '┤┥┦┧┨┩┪┫',

    '┬┭┮┯┰┱┲┳',

    '┴┵┶┷┸┹┺┻',

    '┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋'

  );

  sDouble : widestring = '═║╔╗╚╝╠╣╦╩╬';

  sWide   : widestring = '━┃┏┓┗┛┣┫┳┻╋';

  sThin   : widestring = '─│┌┐└┘├┤┬┴┼';

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

    INT_CURRENCY_CHINESE_SIMPLE : sCurrency := '元十百千万十百千亿十百千';

    INT_CURRENCY_CHINESE_TRADITION : sCurrency := '圆拾佰仟萬拾佰仟億拾佰仟';

    INT_NUMERICAL_CHINESE_SIMPLE : sCurrency := '点十百千万十百千亿十百千';

    INT_NUMERICAL_CHINESE_TRADITION : sCurrency := '點拾佰仟萬拾佰仟億拾佰仟';

  end;

  s := FloatToStr(abs(value));

  w := pos('.', s);

  If w = 0 Then w := length(s) + 1;

  for i := 1 to w-1 do

  begin

    If s[i]<>'0' Then

      result := result + s[i] + GetCurrency(w - i);


    //防止零重复出现

    If (s[i] = '0') and (s[i-1] <> '0') then

      result := result + s[i];


    //验证亿位

    If (w - i = 9) and (pos(GetCurrency(9), result) = 0) then

      result := result + GetCurrency(9);


    //验证万位

    If (w - i = 5) and (pos(GetCurrency(5), result) = 0)

      and (copy(s, w - 8, 4) <> '0000') then

      result := result + GetCurrency(5);

  end;


  //假如结尾是零时

  if result[length(result)]='0' then

    Delete(result,length(result),1);


  //假如是整数当返回值以点结尾

  if (format in [INT_NUMERICAL_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_TRADITION])

     and (w = length(s) + 1) and (RightStr(result) = GetCurrency(1)) then

      Delete(Result, Length(Result)-1, 2);


  //这一步是验证有没有以元或点结尾

  If RightStr(result) <> GetCurrency(1) then

  begin

    // 如果要求返回值是一个金额时，直接加上元

    // 如果要求返回值是一个数值时，先验证是否是一个整数，整数无须加上点

    If ((w <> length(s) + 1) and

      (format in [INT_NUMERICAL_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_TRADITION])) or

      (format in [INT_CURRENCY_CHINESE_SIMPLE, INT_CURRENCY_CHINESE_TRADITION]) then

      result := result + GetCurrency(1);

  end;


  //当是一个整数时

  if (w = length(s) + 1) then

    result := result + '整';


  //这一步是转换小数点后的数值

  for I := w+1 to length(s) do

  begin

    If (s[i] = '0') and (s[i-1] <> '0') then

      result := result + s[i];

    if s[i] <> '0' then

    begin

      result := result + s[i];


      //当格式是钱币时, 必须处理单位

      if (format in [1, 2]) then

        result := result + copy('角分',(i-w)*2-1,2);

    end;

  end;


  //这一步是将转换后的数值大写化并返回}

  if (format in [INT_CURRENCY_CHINESE_SIMPLE, INT_NUMERICAL_CHINESE_SIMPLE]) then

    result := NumberSwitch(result, INT_ARABIC_NUMERALS, INT_CHINESE_SIMPLE_NUMBER)

    else result := NumberSwitch(result, INT_ARABIC_NUMERALS, INT_CHINESE_TRADITION_NUMBER);

  if value < 0 then result := '负' + result;

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

      // 判断是否单字节还是双字节

      if (length(string(value[i])) = 1) then

        Inc(AnsiChar)

        else Inc(UnicodeChar);


      // 判断是否是大写字母

      If (value[i] >= 'A') and (value[i] <= 'Z') then

        Inc(UpperCase);


      // 判断是否是小写字母

      If (value[i] >= 'a') and (value[i] <= 'z') then

         Inc(LowerCase);


      // 判断是否空格

      If value[i] = #32 then

        Inc(Blank);


      // 判断是否回车换行符

      If (i > 1) and (value[i - 1] = #13) and (value[i] = #10) then

        Inc(Enter);


      // 判断是否是制表符

      If value[i] = #9 then

        Inc(Tabs);


      // 判断是否是控制字符

      If (value[i] >= #0) and (value[i] <= #31) then

        Inc(CtrlChar);


      // 判断是否是数字

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

  inQuot:boolean;        // 去除<script>段之用

  InputLen:integer;

  InputIdx:integer;      // 指向输入字符的下一个待处理字符

  inPre:boolean;         // 表示是否在<pre>...</pre>段内

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

  // 取得下一段字符串

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

  // 输入：<a href="http://anjo.delphibbs.com">

  // 输出：http://anjo.delphibbs.com

  function GetLink(s:string):string;

  var

    LPos,RPos,LQuot,RQuot:integer;

  begin

    result:='';

    // 去掉'....<'

    LPos:=pos('<',s);

    if LPos=0 then exit;

    delete(s,1,LPos);

    s:=Trim(s);

    // 去掉'>....'

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

      // 开头带'#'的超链接，视为无效

      if s[LQuot+1]='#' then exit;

      // 开头带'javascript:'的超链接，也视为无效

      // 如：<div align=right><a href="javascript:window.close()"><IMG SRC="button_close.gif"></a></div>

      if copy(s,LQuot+1,11)='javascript:' then exit;

      result:=copy(s,LQuot+1,RQuot-LQuot-1);

    end;

  end;

  // 把所有&xxx的转义；所有<xxx>取消；其它照样返回

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

      else if s0='&middot;' then result:='·'

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

      // 将所有<hr>替换成为'------'

      if s0='<br>' then result:=CR

      else if s0_4='<pre' then   // <pre 一定要在 <p 之前判断！

      begin

        inPre:=true;

        result:=CR;

      end

      else if s0_2='<p' then result:=CR+CR

      else if s0_3='<hr' then result:=CR+MakeStr('-',40)+CR

      else if s0_3='<ol' then result:=CR

      else if s0_3='<ul' then result:=CR

      else if s0_3='<li' then result:='·'

      else if s0_4='</li' then result:=CR

      else if s0_4='</tr' then result:=CR

      else if s0='</td>' then result:=#9

      else if s0='<title>' then result:='《'

      else if s0='</title>' then result:='》'+CR+CR

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

    else // 不在<pre>..</pre>内，则删除所有CR

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

    // 去除<style ...> -- </style>之间的内容

    if lowercase(copy(NextToken,1,6))='<style' then begin

      while lowercase(NextToken)<>'</style>' do begin

        inc(InputIdx,length(NextToken));

        NextToken:=GetNextToken(s0,InputIdx);

      end;

      inc(InputIdx,length(NextToken));

      NextToken:=GetNextToken(s0,InputIdx);

    end;


    // 去除<Script ...> -- </Script>之间的内容

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

          // 去除<script>段里的<!-- ... -->注释段, 99.8.2

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

  //判断是否是链接地址的头

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

          //如果另一个超链接地址头出现则结束

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

  //填满MaxBit位

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

  const Break : string; const BreakMode : Integer  {0 在字符前换行 1 在字符后换行}

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

      // 验证双字节字符

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

    //加载资源

    sSpell := TStringList.Create;

    sSpellStream := TResourceStream.Create(Hinstance, 'GBKSpell', RT_RCDATA);

    sSpell.LoadFromStream(sSpellStream);

    sSpellStream.Free;

    //初始化数组

    SetLength(sChineseSpell, 44780);

    for I := $81 to $FE do

      for w := $40 to $FE do

        If (w <> $7F) then

        begin

          P := (I-$81)*190+(W-$40);

          sChineseSpell[p] := char(I)+char(w);

        end;

    SetLength(sChineseSpell, P+1);

    //处理数组

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

      (*!~ 可以在此增加要支持的函数 *)

      (*!~ 格式：if S = 函数名 then Result := 函数(result) *)

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

      (*!~ 出现取反符号进行记录 *)

      if (Expression[APOS] = '!') then P.no := True

      (*!~ 出现括号进行递归调用 *)

      else if (Expression[APOS] = '(') then

      begin

        (*!~ 如果是表达式 *)

        if (APOS = 1) or (Expression[APOS-1] = '(') or

          (Expression[APOS-1] IN Operator ) then

          P.Nu := AParse

        (*!~ 如果是函数 *)

        else  P.Nu := AFunc;

      end

      (*!~ 如果是运算符 *)

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

      (*!~ 如果是括号则结束 *)

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

          (*!~ 计算非 *)

          1 : begin

            if P.no then

              P.Nu := (not round(P.Nu));

          end;

          else begin

            if p.Ch = OperChar[I] then

            begin

              (*!~ 可以在此增加运算符 *)

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


function IntPower(Base, Exponent: Integer): Integer; {  返回 Base 的 Exponent 次方  }

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
