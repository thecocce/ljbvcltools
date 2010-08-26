{-------------------------------------------------------------------------------

   单元: Calendar.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.11.27 
                                                                              
   版本: 1.00
                                                                              
   说明: 关于公历与农历换算和时间处理的单元
 
-------------------------------------------------------------------------------}


unit Calendar;


interface


uses  SysUtils, Windows;



{ WeekDay 计算iYear,iMonth,iDay对应是星期几 1年1月1日 --- 65535年12月31日 }

function WeekDay(iYear,iMonth,iDay:Word):Integer;


{ WeekNum 计算指定日期的周数，周0为新年开始后第一个星期天开始的周 }

function WeekNum(const TDT:TDateTime):Word;overload;

function WeekNum(const iYear,iMonth,iDay:Word):Word;overload;


{ MonthDays 返回iYear年iMonth月的天数 1年1月 --- 65535年12月 }

function MonthDays(iYear,iMonth:Word):Word;


{ LunarMonthDays

  返回阴历iLunarYer年阴历iLunarMonth月的天数，如果iLunarMonth为闰月，

  高字为第二个iLunarMonth月的天数，否则高字为0

  1901年1月---2050年12月 }

function LunarMonthDays(iLunarYear,iLunarMonth:Word):Longword;


{ LunarYearDays 返回阴历iLunarYear年的总天数 , 1901年1月---2050年12月 }

function LunarYearDays(iLunarYear:Word):Word;


{ GetLeapMonth 返回阴历iLunarYear年的闰月月份，如没有返回0, 1901年1月---2050年12月 }

function GetLeapMonth(iLunarYear:Word):Word;


{ FormatLunarYear 把iYear年格式化成天干记年法表示的字符串 }

procedure FormatLunarYear(iYear:Word;var pBuffer:string);overload;

function FormatLunarYear(iYear:Word):string;overload;


{ FormatMonth 把iMonth格式化成中文字符串 }

procedure FormatMonth(iMonth:Word;var pBuffer:string;bLunar:Boolean=True);overload;

function FormatMonth(iMonth:Word;bLunar:Boolean=True):string;overload;


{ FormatLunarDay 把iDay格式化成中文字符串 }

procedure FormatLunarDay(iDay:Word;var pBuffer:string);overload;

function FormatLunarDay(iDay:Word):string;overload;


{ CalcDateDiff 计算公历两个日期间相差的天数 1年1月1日 --- 65535年12月31日 }

function CalcDateDiff(iEndYear,iEndMonth,iEndDay:Word;iStartYear:Word=1;

  iStartMonth:Word=1;iStartDay:Word=1):Longword;overload;

function CalcDateDiff(EndDate,StartDate:TDateTime):Longword;overload;


{ GetLunarDate

  计算公历iYear年iMonth月iDay日对应的阴历日期,返回对应的阴历节气0-24

  1901年1月1日---2050年12月31日 }

function GetLunarDate(iYear,iMonth,iDay:Word;var

  iLunarYear,iLunarMonth,iLunarDay:Word):Word;overload;

procedure GetLunarDate(InDate:TDateTime;var

  iLunarYear,iLunarMonth,iLunarDay:Word);overload;

function GetLunarHolDay(InDate:TDateTime):string;overload;

function GetLunarHolDay(iYear,iMonth,iDay:Word):string;overload;


{ l_CalcLunarDate 计算从1901年1月1日过iSpanDays天后的阴历日期 }

procedure l_CalcLunarDate(var iYear,iMonth,iDay:Word;iSpanDays:Longword);


{ l_GetLunarHolDay 计算公历iYear年iMonth月iDay日对应的节气 0-24，0表不是节气 }

function l_GetLunarHolDay(iYear,iMonth,iDay:Word):Word;


{ FormatWeek

  返回指定的日期的星期字符串，

  格式为1是“星期..”，

  格式为2是“礼拜..”,

  格式为3是“周..”,

  格式为4是英文表示法 }

function FormatWeek(Date : TDatetime; Format : Integer = 1): string;


{ FormatTime

  返回指定的时间的字符串，

  格式为1是  阴历时，

  格式为2是“XX时XX分XX秒”，

  格式为3是“上(下)午XX时XX分”,

  格式为4是“XX:XX:XX”

  格式为5是“XX:XX” }

function FormatTime(Time : TDatetime; Format : Integer = 2): string;


{ FormatDate

  返回指定的日期的字符串，

  格式为1是  阴历年，

  格式为2是“XXXX-XX-XX”，

  格式为3是“XXXX/XX/XX”，

  格式为4是“XXXX年XX月XX日”,

  格式为5是“XXXX年XX月XX日”(简写),

  格式为6是“XXXX年XX月XX日”(繁写) }

function FormatDate(Date : TDatetime; Format : Integer = 4): string;


implementation


const

  { 数组gLunarDay存入阴历1901年到2100年每年中的月天数信息，

    阴历每月只能是29或30天，一年用12（或13）个二进制位表示，对应位为1表

    30天，否则为29天 测试数据只有1901.1.1 --2050.12.31 }

  gLunarMonthDay: Array[0..149] of Word=(

    $4ae0, $a570, $5268, $d260, $d950, $6aa8, $56a0, $9ad0, $4ae8, $4ae0,

    {1910}

    $a4d8, $a4d0, $d250, $d548, $b550, $56a0, $96d0, $95b0, $49b8, $49b0,

    {1920}

    $a4b0, $b258, $6a50, $6d40, $ada8, $2b60, $9570, $4978, $4970, $64b0,

    {1930}

    $d4a0, $ea50, $6d48, $5ad0, $2b60, $9370, $92e0, $c968, $c950, $d4a0,

    {1940}

    $da50, $b550, $56a0, $aad8, $25d0, $92d0, $c958, $a950, $b4a8, $6ca0,

    {1950}

    $b550, $55a8, $4da0, $a5b0, $52b8, $52b0, $a950, $e950, $6aa0, $ad50,

    {1960}

    $ab50, $4b60, $a570, $a570, $5260, $e930, $d950, $5aa8, $56a0, $96d0,

    {1970}

    $4ae8, $4ad0, $a4d0, $d268, $d250, $d528, $b540, $b6a0, $96d0, $95b0,

    {1980}

    $49b0, $a4b8, $a4b0, $b258, $6a50, $6d40, $ada0, $ab60, $9370, $4978,

    {1990}

    $4970, $64b0, $6a50, $ea50, $6b28, $5ac0, $ab60, $9368, $92e0, $c960,

    {2000}

    $d4a8, $d4a0, $da50, $5aa8, $56a0, $aad8, $25d0, $92d0, $c958, $a950,

    {2010}

    $b4a0, $b550, $b550, $55a8, $4ba0, $a5b0, $52b8, $52b0, $a930, $74a8,

    {2020}

    $6aa0, $ad50, $4da8, $4b60, $9570, $a4e0, $d260, $e930, $d530, $5aa0,

    {2030}

    $6b50, $96d0, $4ae8, $4ad0, $a4d0, $d258, $d250, $d520, $daa0, $b5a0,

    {2040}

    $56d0, $4ad8, $49b0, $a4b8, $a4b0, $aa50, $b528, $6d20, $ada0, $55b0);

    {2050}


  { 数组gLanarMonth存放阴历1901年到2050年闰月的月份，如没有则为0，每字节存两年 }

  gLunarMonth: Array[0..74] of Byte=(

    $00, $50, $04, $00, $20, ///1910

    $60, $05, $00, $20, $70, ///1920

    $05, $00, $40, $02, $06, ///1930

    $00, $50, $03, $07, $00, ///1940

    $60, $04, $00, $20, $70, ///1950

    $05, $00, $30, $80, $06, ///1960

    $00, $40, $03, $07, $00, ///1970

    $50, $04, $08, $00, $60, ///1980

    $04, $0a, $00, $60, $05, ///1990

    $00, $30, $80, $05, $00, ///2000

    $40, $02, $07, $00, $50, ///2010

    $04, $09, $00, $60, $04, ///2020

    $00, $20, $60, $05, $00, ///2030

    $30, $b0, $06, $00, $50, ///2040

    $02, $07, $00, $50, $03); ///2050


  { 数组gLanarHoliDay存放每年的二十四节气对应的阳历日期

    每年的二十四节气对应的阳历日期几乎固定，平均分布于十二个月中

    1月 2月 3月 4月 5月 6月

    小寒 大寒 立春 雨水 惊蛰 春分 清明 谷雨 立夏 小满 芒种 夏至

    7月 8月 9月 10月 11月 12月

    小暑 大暑 立秋 处暑 白露 秋分 寒露 霜降 立冬 小雪 大雪 冬至

    节气无任何确定规律,所以只好存表,要节省空间,所以....

    数据格式说明:

    如1901年的节气为

      1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月

      6, 21, 4, 19, 6, 21, 5, 21, 6,22, 6,22, 8, 23, 8, 24, 8,

      24, 8, 24, 8, 23, 8, 22

      9, 6, 11,4, 9, 6, 10,6, 9,7, 9,7, 7, 8, 7, 9, 7, 9, 7, 9,

      7, 8, 7, 15

    上面第一行数据为每月节气对应日期,15减去每月第一个节气,每月第

    二个节气减去15得第二行

    这样每月两个节气对应数据都小于16,每月用一个字节存放,高位存放

    第一个节气数据,低位存放第二个节气的数据,可得下表 }


  gLunarHolDay: Array[0..1799] of Byte=(

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1901

    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78, ///1902

    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78, ///1903

    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87, ///1904

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1905

    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78, ///1906

    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78, ///1907

    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1908

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1909

    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78, ///1910

    $96, $A5, $87, $96, $87, $87, $79, $69, $69, $69, $78, $78, ///1911

    $86, $A5, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1912

    $95, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1913

    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78, ///1914

    $96, $A5, $97, $96, $97, $87, $79, $79, $69, $69, $78, $78, ///1915

    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1916

    $95, $B4, $96, $A6, $96, $97, $78, $79, $78, $69, $78, $87, ///1917

    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $77, ///1918

    $96, $A5, $97, $96, $97, $87, $79, $79, $69, $69, $78, $78, ///1919

    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1920

    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $87, ///1921

    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $77, ///1922

    $96, $A4, $96, $96, $97, $87, $79, $79, $69, $69, $78, $78, ///1923

    $96, $A5, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1924

    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $87, ///1925

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1926

    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78, ///1927

    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1928

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1929

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1930

    $96, $A4, $96, $96, $97, $87, $79, $79, $79, $69, $78, $78, ///1931

    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1932

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1933

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1934

    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78, ///1935

    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1936

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1937

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1938

    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78, ///1939

    $96, $A5, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1940

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1941

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1942

    $96, $A4, $96, $96, $97, $97, $79, $79, $79, $69, $78, $78, ///1943

    $96, $A5, $96, $A5, $A6, $96, $88, $78, $78, $78, $87, $87, ///1944

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1945

    $95, $B4, $96, $A6, $97, $97, $78, $79, $78, $69, $78, $77, ///1946

    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78, ///1947

    $96, $A5, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///1948

    $A5, $B4, $96, $A5, $96, $97, $88, $79, $78, $79, $77, $87, ///1949

    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $77, ///1950

    $96, $B4, $96, $A6, $97, $97, $79, $79, $79, $69, $78, $78, ///1951

    $96, $A5, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///1952

    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1953

    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $68, $78, $87, ///1954

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1955

    $96, $A5, $A5, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///1956

    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1957

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1958

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1959

    $96, $A4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87, ///1960

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1961

    $96, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1962

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1963

    $96, $A4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87, ///1964

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1965

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1966

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1967

    $96, $A4, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///1968

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1969

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1970

    $96, $B4, $96, $A6, $97, $97, $78, $79, $79, $69, $78, $77, ///1971

    $96, $A4, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///1972

    $A5, $B5, $96, $A5, $A6, $96, $88, $78, $78, $78, $87, $87, ///1973

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1974

    $96, $B4, $96, $A6, $97, $97, $78, $79, $78, $69, $78, $77, ///1975

    $96, $A4, $A5, $B5, $A6, $A6, $88, $89, $88, $78, $87, $87, ///1976

    $A5, $B4, $96, $A5, $96, $96, $88, $88, $78, $78, $87, $87, ///1977

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87, ///1978

    $96, $B4, $96, $A6, $96, $97, $78, $79, $78, $69, $78, $77, ///1979

    $96, $A4, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///1980

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $77, $87, ///1981

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1982

    $95, $B4, $96, $A5, $96, $97, $78, $79, $78, $69, $78, $77, ///1983

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87, ///1984

    $A5, $B4, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///1985

    $A5, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///1986

    $95, $B4, $96, $A5, $96, $97, $88, $79, $78, $69, $78, $87, ///1987

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///1988

    $A5, $B4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87, ///1989

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87, ///1990

    $95, $B4, $96, $A5, $86, $97, $88, $78, $78, $69, $78, $87, ///1991

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///1992

    $A5, $B3, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87, ///1993

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1994

    $95, $B4, $96, $A5, $96, $97, $88, $76, $78, $69, $78, $87, ///1995

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///1996

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///1997

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///1998

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///1999

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2000

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2001

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///2002

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///2003

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2004

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2005

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2006

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $69, $78, $87, ///2007

    $96, $B4, $A5, $B5, $A6, $A6, $87, $88, $87, $78, $87, $86, ///2008

    $A5, $B3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2009

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2010

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $78, $87, ///2011

    $96, $B4, $A5, $B5, $A5, $A6, $87, $88, $87, $78, $87, $86, ///2012

    $A5, $B3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87, ///2013

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2014

    $95, $B4, $96, $A5, $96, $97, $88, $78, $78, $79, $77, $87, ///2015

    $95, $B4, $A5, $B4, $A5, $A6, $87, $88, $87, $78, $87, $86, ///2016

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87, ///2017

    $A5, $B4, $A6, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2018

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87, ///2019

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $86, ///2020

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2021

    $A5, $B4, $A5, $A5, $A6, $96, $88, $88, $88, $78, $87, $87, ///2022

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $79, $77, $87, ///2023

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96, ///2024

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2025

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2026

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///2027

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96, ///2028

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2029

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2030

    $A5, $B4, $96, $A5, $96, $96, $88, $78, $78, $78, $87, $87, ///2031

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96, ///2032

    $A5, $C3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $86, ///2033

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $78, $88, $78, $87, $87, ///2034

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2035

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96, ///2036

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $86, ///2037

    $A5, $B3, $A5, $A5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2038

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2039

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $78, $87, $96, ///2040

    $A5, $C3, $A5, $B5, $A5, $A6, $87, $88, $87, $78, $87, $86, ///2041

    $A5, $B3, $A5, $B5, $A6, $A6, $88, $88, $88, $78, $87, $87, ///2042

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2043

    $95, $B4, $A5, $B4, $A5, $A6, $97, $87, $87, $88, $87, $96, ///2044

    $A5, $C3, $A5, $B4, $A5, $A6, $87, $88, $87, $78, $87, $86, ///2045

    $A5, $B3, $A5, $B5, $A6, $A6, $87, $88, $88, $78, $87, $87, ///2046

    $A5, $B4, $96, $A5, $A6, $96, $88, $88, $78, $78, $87, $87, ///2047

    $95, $B4, $A5, $B4, $A5, $A5, $97, $87, $87, $88, $86, $96, ///2048

    $A4, $C3, $A5, $A5, $A5, $A6, $97, $87, $87, $78, $87, $86, ///2049

    $A5, $C3, $A5, $B5, $A6, $A6, $87, $88, $78, $78, $87, $87); ///2050

  START_YEAR=1901;

  END_YEAR=2050;


function WeekDay(iYear,iMonth,iDay:Word):Integer;

begin

  Result:=DayOfWeek(EncodeDate(iYear,iMonth,iDay));

end;

function WeekNum(const TDT:TDateTime):Word;

var

  Y,M,D:Word;

  dtTmp:TDateTime;

begin

  DecodeDate(TDT,Y,M,D);

  dtTmp:=EnCodeDate(Y,1,1);

  Result:=(Trunc(TDT-dtTmp)+(DayOfWeek(dtTmp)-1)) div 7;

  if Result=0 then Result:=51

  else Result:=Result-1;

end;

function WeekNum(const iYear,iMonth,iDay:Word):Word;

begin

  Result:=WeekNum(EncodeDate(iYear,iMonth,iDay));

end;

function MonthDays(iYear,iMonth:Word):Word;

begin

  case iMonth of

    1,3,5,7,8,10,12: Result:=31;

    4,6,9,11: Result:=30;

    2:{如果是闰年} If IsLeapYear(iYear) then Result:=29  Else Result:=28

    Else Result:=0;

  end;

end;

function GetLeapMonth(iLunarYear:Word):Word;

var

  Flag:Byte;

begin

  Flag:=gLunarMonth[(iLunarYear-START_YEAR) div 2];

  if (iLunarYear-START_YEAR) mod 2=0 then

    Result:=Flag shr 4

  else Result:=Flag and $0F;

end;

function LunarMonthDays(iLunarYear,iLunarMonth:Word):Longword;

var

  Height,Low:Word;

  iBit:Integer;

begin

  if iLunarYear<START_YEAR then

  begin

    Result:=30;

    Exit;

  end;

  Height:=0;

  Low:=29;

  iBit:=16-iLunarMonth;

  if (iLunarMonth>GetLeapMonth(iLunarYear)) and (GetLeapMonth(iLunarYear)>0) then

    Dec(iBit);

  if (gLunarMonthDay[iLunarYear-START_YEAR] and (1 shl iBit))>0 then

    Inc(Low);

  if iLunarMonth=GetLeapMonth(iLunarYear) then

    if (gLunarMonthDay[iLunarYear-START_YEAR] and (1 shl (iBit-1)))>0 then

      Height:=30

    else Height:=29;

  Result:=MakeLong(Low,Height);

end;

function LunarYearDays(iLunarYear:Word):Word;

var

  Days,i:Word;

  tmp:Longword;

begin

  Days:=0;

  for i:=1 to 12 do

  begin

    tmp:=LunarMonthDays(iLunarYear,i);

    Days:=Days+HiWord(tmp);

    Days:=Days+LoWord(tmp);

  end;

  Result:=Days;

end;

procedure FormatLunarYear(iYear:Word;var pBuffer:string);

var

  szText1,szText2,szText3:string;

begin

  szText1:='甲乙丙丁戊己庚辛壬癸';

  szText2:='子丑寅卯辰巳午未申酉戌亥';

  szText3:='鼠牛虎免龙蛇马羊猴鸡狗猪';

  pBuffer:=Copy(szText1,((iYear-4) mod 10)*2+1,2);

  pBuffer:=pBuffer+Copy(szText2,((iYear-4) mod 12)*2+1,2);

  //pBuffer:=pBuffer+' ';

  pBuffer:=pBuffer+Copy(szText3,((iYear-4) mod 12)*2+1,2);

  pBuffer:=pBuffer+'年';

end;

function FormatLunarYear(iYear:Word):string;

var

  pBuffer:string;

begin

  FormatLunarYear(iYear,pBuffer);

  Result:=pBuffer;

end;

procedure FormatMonth(iMonth:Word;var pBuffer:string;bLunar:Boolean);

var

  szText:string;

begin

  if (not bLunar) and (iMonth=1) then

  begin

    pBuffer:=' 一月';

    Exit;

  end;

  szText:='正二三四五六七八九十';

  if iMonth<=10 then

  begin

    pBuffer:=' ';

    pBuffer:=pBuffer+Copy(szText,(iMonth-1)*2+1,2);

    pBuffer:=pBuffer+'月';

    Exit;

  end;

  if iMonth=11 then

    pBuffer:='十一'

  else

    pBuffer:='十二';

  pBuffer:=pBuffer+'月';

end;

function FormatMonth(iMonth:Word;bLunar:Boolean):string;

var

  pBuffer:string;

begin

  FormatMonth(iMonth,pBuffer,bLunar);

  Result:=pBuffer;

end;

procedure FormatLunarDay(iDay:Word;var pBuffer:string);

var

  szText1,szText2:string;

begin

  szText1:='初十廿三';

  szText2:='一二三四五六七八九十';

  if (iDay<>20) and (iDay<>30) then

  begin

    pBuffer:=Copy(szText1,((iDay-1) div 10)*2+1,2);

    pBuffer:=pBuffer+Copy(szText2,((iDay-1) mod 10)*2+1,2);

  end

  else begin

    pBuffer:=Copy(szText1,(iDay div 10)*2+1,2);

    pBuffer:=pBuffer+'十';

  end;

end;

function FormatLunarDay(iDay:Word):string;

var

  pBuffer:string;

begin

  FormatLunarDay(iDay,pBuffer);

  Result:=pBuffer;

end;

function CalcDateDiff(iEndYear,iEndMonth,iEndDay:Word;iStartYear:Word;

   iStartMonth:Word;iStartDay:Word):Longword;

begin

  Result:=Trunc(EncodeDate(iEndYear,iEndMonth,iEndDay)-EncodeDate(iStartYear,

  iStartMonth,iStartDay));

end;

function CalcDateDiff(EndDate,StartDate:TDateTime):Longword;

begin

  Result:=Trunc(EndDate-StartDate);

end;

function GetLunarDate(iYear,iMonth,iDay:Word;var

  iLunarYear,iLunarMonth,iLunarDay:Word):Word;

begin

  l_CalcLunarDate(iLunarYear,iLunarMonth,iLunarDay,CalcDateDiff(iYear,iMonth,

    iDay));

  Result:=l_GetLunarHolDay(iYear,iMonth,iDay);

end;

procedure GetLunarDate(InDate:TDateTime;var

  iLunarYear,iLunarMonth,iLunarDay:Word);

begin

  l_CalcLunarDate(iLunarYear,iLunarMonth,iLunarDay,CalcDateDiff(InDate,

    EncodeDate(START_YEAR,1,1)));

end;

procedure l_CalcLunarDate(var iYear,iMonth,iDay:Word;iSpanDays:Longword);

var

  tmp:Longword;

begin

  {阳历1901年2月19日为阴历1901年正月初一, 阳历1901年1月1日到2月19日共有49天}

  If iSpanDays<49 then

  begin

    iYear:=START_YEAR-1;

    if iSpanDays<19 then

    begin

      iMonth:=11;

      iDay:=11+Word(iSpanDays);

    end

    else begin

      iMonth:=12;

      iDay:=Word(iSpanDays)-18;

    end;

    Exit;

  end;


  {下面从阴历1901年正月初一算起}

  iSpanDays:=iSpanDays-49;

  iYear:=START_YEAR;

  iMonth:=1;

  iDay:=1;



  {计算年}

  tmp:=LunarYearDays(iYear);

  while iSpanDays>=tmp do

  begin

    iSpanDays:=iSpanDays-tmp;

    Inc(iYear);

    tmp:=LunarYearDays(iYear);

  end;



  {计算月}

  tmp:=LoWord(LunarMonthDays(iYear,iMonth));

  while iSpanDays>=tmp do

  begin

    iSpanDays:=iSpanDays-tmp;

    if iMonth=GetLeapMonth(iYear) then

    begin

      tmp:=HiWord(LunarMonthDays(iYear,iMonth));

      if iSpanDays<tmp then

        Break;

      iSpanDays:=iSpanDays-tmp;

    end;

    Inc(iMonth);

    tmp:=LoWord(LunarMonthDays(iYear,iMonth));

  end;



  {计算日}

  iDay:=iDay+Word(iSpanDays);

end;

function l_GetLunarHolDay(iYear,iMonth,iDay:Word):Word;

var

  Flag:Byte;

  Day:Word;

begin

  Flag:=gLunarHolDay[(iYear-START_YEAR)*12+iMonth-1];

  If iDay<15 then Day:=15-((Flag shr 4) and $0f)

  else Day:=(Flag and $0f)+15;

  If iDay=Day then

    If iDay>15 then Result:=(iMonth-1)*2+2

    else Result:=(iMonth-1)*2+1

  else Result:=0;

end;

function GetLunarHolDay(InDate:TDateTime):string;

var

  i,iYear,iMonth,iDay:Word;

begin

  DecodeDate(InDate,iYear,iMonth,iDay);

  i:=l_GetLunarHolDay(iYear,iMonth,iDay);

  case i of

    1:Result:='小寒';

    2:Result:='大寒';

    3:Result:='立春';

    4:Result:='雨水';

    5:Result:='惊蛰';

    6:Result:='春分';

    7:Result:='清明';

    8:Result:='谷雨';

    9:Result:='立夏';

    10:Result:='小满';

    11:Result:='芒种';

    12:Result:='夏至';

    13:Result:='小暑';

    14:Result:='大暑';

    15:Result:='立秋';

    16:Result:='处暑';

    17:Result:='白露';

    18:Result:='秋分';

    19:Result:='寒露';

    20:Result:='霜降';

    21:Result:='立冬';

    22:Result:='小雪';

    23:Result:='大雪';

    24:Result:='冬至';

    else Result:='';

  end;

end;

function GetLunarHolDay(iYear,iMonth,iDay:Word):string;

begin

  Result:=GetLunarHolDay(EncodeDate(iYear,iMonth,iDay));

end;

function FormatWeek(Date : TDatetime; Format : Integer): string;

const

  weeks : array[1..4, 1..7] of string = (

    ('星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'),

    ('礼拜天', '礼拜一', '礼拜二', '礼拜三', '礼拜四', '礼拜五', '礼拜六'),

    ('周日', '周一', '周二', '周三', '周四', '周五', '周六'),

    ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')

  );

begin

  result := weeks[Format][DayOfWeek(Date)];

end;

function FormatTime(Time : TDatetime; Format : Integer): string;

const

  Hours : widestring = '子丑寅卯辰巳午未申酉戌亥';

  Mins : widestring = '一二三四五六七八';

var

  H, M, S, V : Word;

begin

  case Format of

    1 : begin

      DecodeTime(Time, H, M, S, V);

      M := M + abs( (H mod 2) -1 ) * 60;

      M := (M div 15) + 1;

      H := (H div 2) + (H mod 2);

      If H = 0 then H := 1;

      result := Hours[H] + '时' + Mins[M] + '刻' ;

    end;

    2 : result := formatDatetime('h"时"mm"分"ss"秒"', Time);

    3 : result := formatDatetime('ampmh"时"mm"分', Time);

    4 : result := formatDatetime('hh":"mm":"ss', Time);

    5 : result := formatDatetime('hh":"mm', Time);

  end;

end;

function FormatDate(Date : TDatetime; Format : Integer = 4): string;

const

  DateNums : array[1..2] of widestring = (

    '○一二三四五六七八九', '零壹贰叁肆伍陆柒捌玖' );

var

  DateStr : widestring;

  I : integer;

  LY, LM, LD:Word;

begin

  case Format of

    1 : begin

      GetLunarDate(Date, LY, LM, LD);

      result := FormatLunarYear(LY) + FormatMonth(LM) + FormatLunarDay(LD);

    end;

    2 : result := FormatDatetime('yyyy"-"mm"-"d', date);

    3 : result := FormatDatetime('yyyy"/"mm"/"d', date);

    4..6 : result := FormatDatetime('yyyy"年"mm"月"d"日"', date);

  end;

  If format in [5..6] then

  begin

    DateStr := result;

    for I := 1 to Length(DateStr) do

      If ord(DateStr[I]) in [48..57] then

        DateStr[I] := dateNums[format-4][ord(DateStr[I])-47];

    result := DateStr;

  end;

end;

end.
