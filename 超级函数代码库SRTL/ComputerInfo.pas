{-------------------------------------------------------------------------------

   单元: ComputerInfo.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.12.06

   版本: 1.00

   说明: 这是一个关于检测系统信息的函数库

-------------------------------------------------------------------------------}


unit ComputerInfo;


Interface


uses

  SysUtils, Windows, Messages, Registry, Classes, ShlObj,

  ShellAPi, Graphics, Dialogs;



{---------------------------------------------------

 以下是关于获取硬盘信息的类型声明和函数

 ----------------------------------------------------}


const

  SysUNKNOWN = '未知';

  SysNOROOTDIR = '坏盘';

  SysREMOVABLE = '可移动(软盘)驱动器';

  SysFIXEDDRIVE = '固定驱动器';

  SysREMOTE = '网络驱动器';

  SysCDROM = '光盘驱动器';

  SysRAMDISK = 'RAM驱动器';



type

  TSysDriveType = (

    dtUnknown,             //未知的驱动器类型

    dtNoRootDir,           //损坏的驱动器类型

    dtRemovable,           //可移动驱动器类型 一般为软盘驱动器

    dtFixed,               //固定驱动器类型 一般为硬盘

    dtNetwork,             //网络驱动器

    dtCDROM,               //光盘驱动器

    dtRAM                  //RAM驱动器

  );


  TSysFileSystemOption = (

    fsCaseIsPreserved,     // The file system preserves the case of file names when it places a name on disk.

    fsCaseSensitive,       // The file system supports case-sensitive file names.

    fsSupportsUnicode,     // The file system supports Unicode in file names as they appear on disk.

    fsPersistentACLs,      // The file system preserves and enforces ACLs. For example, NTFS preserves and enforces ACLs, and FAT does not.

    fsSupportsCompression, // The file system supports file-based compression.

    fsIsCompressed,        // The specified volume is a compressed volume; for example, a DoubleSpace volume.

    fsSupportsQuotas       // The file system supports disk quotas.

  );

  TSysFileSystemOptions = set of TSysFileSystemOption;


  TDriveRec = record

    BytesPerSector: DWORD;             //每一扇区的大小

    DiskSize: Int64;                   //硬盘大小

    DiskFree: Int64;                   //硬盘可用空间

    Drive: Char;                       //硬盘盘符

    DriveType: TSysDriveType;          //硬盘类型

    DriveTypeString : String;          //硬盘类型字符串

    FileSystem: string;                //文件系统

    SectorsPerCluster: DWORD;          //

    MaximumLength: DWORD;              //

    SerialNumber: string;              //硬盘序列号

    Options: TSysFileSystemOptions;    //文件系统选项

    VolumeLabel: string;               //硬盘卷标

  end;


  TDriveInfo =  array of TDriveRec;


{ GetDriveRec 返回指定盘符的驱动器的信息 }

function GetDriveRec(Drive: Char): TDriveRec;

{ GetDriveInfo 返回系统所有可用驱动器的信息 }

function GetDriveInfo: TDriveInfo;




{---------------------------------------------------

 以下是关于获取内存信息的类型声明和函数

 ----------------------------------------------------}

type

  TMemoryInfo = record

    UsePercent    : Longint;   (*内存使用百分比*)

    MemoryTotal   : Longint;   (*实际内存总字节数*)

    MemoryUsable  : Longint;   (*可用的实际内存字节数*)

    PageTotal     : LongInt;   (*分页文件总字节数*)

    PageUsable    : LongInt;   (*分页文件可用字节数*)

    VirtualTotal  : LongInt;   (*虚拟内存的总字节数*)

    VirtualUsable : LongInt;   (*可用的虚拟内存字节数*)

    PageSize     : Cardinal;

    MinAppAddress : Cardinal;

    MaxAppAddress : Cardinal;

    AllocGranularity : Cardinal;

  end;

{ GetMemoryInfo 返回系统内存信息 }

function GetMemoryInfo : TMemoryInfo;




{---------------------------------------------------

 以下是关于获取CPU信息的类型声明和函数

 ----------------------------------------------------}

type

  TCPUVendor = (

    vn_None, vnIntel, vnAMD, vnCyrix, vnIDT, vnNexGen, vnUMC, vnRise);


  TCPUType   = (

    CPU_Primary, CPU_Overdrive, CPU_Secondary, CPU_Reserved);


  TCPUFeature = (

    fe00_FPU, fe01_VME, fe02_DE, fe03_PSE, fe04_TSC, fe05_MSR,

    fe06_PAE, fe07_MCE, fe08_CX8, fe09_APIC, fe10_resv, fe11_SEP,

    fe12_MTRR, fe13_PGE, fe14_MCA, fe15_CMOV, fe16_PAT, fe17_PSE36,

    fe18_PPN, fe19_CLFLSH, fe20_resv, fe21_DTES, fe22_ACPI, fe23_MMX,

    fe24_FXSR, fe25_XMM, fe26_ISSE2, fe27_SSNOOP, fe28_resv, fe29_ACC,

    fe30_JMPE, fe31_resv );

  TCPUFeatureSet = set of TCPUFeature;


  TCPURec = record

    Name : String;           //CPU名称

    Firm : String;           //厂商字符串

    ID   : String;           //标识符

    MHZ  : LongInt;          //CPU主频

    cType : TCPUType;

    Features : TCPUFeatureSet;

    FeatureStr : String;

    Vendor : TCPUVendor;

  end;


  TCPUInfo = packed record

    CPUCount  : Integer;        //CPU的数量

    CPUUsage  : Byte;           //CPU利用率

    CPUs      : array of TCPURec;

  end;


{ GetCPUVendor 返回CPU产家信息 }

function GetCPUVendor(nLevel : Integer): TCPUVendor;

{ GetCPUType 返回CPU的类型 }

function GetCPUType(nLevel : Integer): TCPUType;

{ GetCPUName 返回CPU的名称 }

function GetCPUName(nLevel : Integer): string;

{ GetCPUFeature 返回CPU的所有特征 }

function GetCPUFeature(nLevel : Integer): TCPUFeatureSet;

{ GetCPURec 返回单个CPU的所有信息 }

function GetCPURec(nLevel : Integer): TCPURec;

{ GetCPUInfo 返回所有CPU的所有信息 }

function GetCPUInfo: TCPUInfo;

{ CPUFeatureToStr 转换CPU特征到字符串 }

function CPUFeatureToStr(Features : TCPUFeatureSet): string;




{---------------------------------------------------

 以下是关于获取键盘和鼠标的信息的类型声明和函数

 ----------------------------------------------------}

type

  TKeyboardInfo = record

    Delay    : LongInt;

    Speed    : LongInt;

    NumLock  : Boolean;

    CapsLock : Boolean;

    Types    : Integer;

    SubType  : Integer;

    Layout   : string;

    TypeStr  : String;

    CaretBlinkTime : LongInt;

    ScrollLock     : Boolean;

    FunctionKeys   : Integer;

  end;

  TMouseInfo = record

    Btns: Word;

    DoubleClickTime: Word;

    SnapToDefault: Boolean;

    SwapBtns: Boolean;

    Exist: Boolean;

    Wheel: Boolean;

    Speed: Integer;

    DblClickWidth: Integer;

    DblClickHeight: Integer;

    CurSchemeFiles: TStrings;

    CursorSchemes: TStrings;

    CursorScheme: string;

    Comment : string;

  end;

  TKeyboardState = set of (

    ksNumLock,     // 数字锁定键 Num Lock 的状态

    ksCapsLock,    // 大写锁定键 Caps Lock 的状态

    ksLeftShift,   // 左边Shift是否按下

    ksLeftCtrl,    // 左边Ctrl是否按下

    ksLeftAlt,     // 左边Alt是否按下

    ksLeftWin,     // 左边windows键是否按下

    ksRightShift,  // 右边Shift是否按下

    ksRightCtrl,   // 右边Ctrl是否按下

    ksRightAlt,    // 右边Alt是否按下

    ksRightWin     // 右边windows键是否按下

  );

{ GetKeyboardInfo 返回键盘信息 }

function GetKeyboardInfo : TKeyboardInfo;

{ GetKeyBoardTypeName 返回键盘类型的字符串 }

function GetKeyBoardTypeName: String;

{ GetKeyboardState 返回键盘状态 }

function GetKeyboardState:TKeyboardState;

{ GetMouseInfo 返回鼠标信息 }

function GetMouseInfo : TMouseInfo;




{---------------------------------------------------

 以下是关于获取系统软件卸载的信息的类型声明和函数

 ----------------------------------------------------}

type

  TUninstallInfo = array of record

    RegProgramName: string;

    ProgramName   : string;

    UninstallPath : string;

    Publisher     : string;

    PublisherURL  : string;

    Version       : string;

    HelpLink      : string;

    UpdateInfoURL : string;

    RegCompany    : string;

    RegOwner      : string;

  end;


{ GetUninstallInfo 返回系统软件卸载的信息 }

function GetUninstallInfo : TUninstallInfo;




{---------------------------------------------------

 以下是关于获取系统基本信息的类型声明和函数

 ----------------------------------------------------}

const

  { function GetVersion return }

  OS_UNKNOW = $0000;

  OS_WINDOWS31 = $0001;

  OS_WINDOWS95 = $0002;

  OS_WINDOWS95OSR2 = $0003;

  OS_WINDOWS98 = $0004;

  OS_WINDOWS98SE = $0005;

  OS_WINDOWSME = $0006;

  OS_WINDOWSNT3 = $0007;

  OS_WINDOWSNT4 = $0008;

  OS_WINDOWSNT4SP4 = $0009;

  OS_WINDOWS2000 = $0010;

  OS_WINDOWSXP = $0011;


type

  TSysFolders = array of record

    Name : string;

    Path : string;

  end;


  TWindowInfo = record

    WindowVersion : Integer;       //系统版本

    WindowName : string;           //系统名称

    Folders :  TSysFolders;        //各个目录

    CSDVersion: string;            //补丁版本

    ProductID: string;             //产品序列号

    ProductName: string;           //产品名称

    Version: string;               //版本号

    RegisteredCompany: string;     //计算机名

    RegisteredOwner: string;       //用户名

    BuildNumber: Cardinal;

    PlatformID: Cardinal;         //平台标识号

    MajorVersion: Cardinal;       //主版本号

    MinorVersion: Cardinal;       //次版本号

    Language : string;            //语言版本

    CurrentUserName : string;     //当前用户名

  end;

{ GetWindowInfo 返回系统的基本信息}

function GetWindowInfo : TWindowInfo;

{ GetSystemFolders 返回所有可用的系统文件夹 }

function GetSystemFolders: TSysFolders;

{ GetVersion 返回系统版本常量 }

function GetVersion : Integer;

{ GetVersionName 返回系统名称 }

function GetVersionName(Version : Integer): string;

{ GetUserName 返回系统当前用户名 }

function GetUserName : string;

{ GetSystemDefaultLangName 返回系统当前默认的语言名称 }

function GetSystemDefaultLangName : string;




{---------------------------------------------------

 以下是关于获取系统时区信息的类型声明和函数

 ----------------------------------------------------}

type

  TTZStandardInfo = array of record

    Display : string;

    Dlt : string;

    Index : Longint;

    MapID : string;

    Std : string;

  end;


  TTimeZoneInfo = record

    Bias         : LongInt;

    DayLightBias : LongInt;

    StandardBias : LongInt;

    DayLightName : string;

    StandardName : string;

    DayLightDate : TDateTime;

    StandardDate : TDateTime;

    Standards : TTZStandardInfo;

  end;


{ GetTimeZoneinfo 返回系统时区的信息 }

function GetTimeZoneinfo : TTimeZoneInfo;




{---------------------------------------------------

 以下是关于获取屏幕保护的信息的类型声明和函数

 ----------------------------------------------------}

type

  TScreenSaverInfo = record

    Active: Boolean;         //是否启用了屏幕保护

    Delay: Cardinal;         //延时的时间，单位秒

    Secure: Boolean;

    UsePassword : Boolean;   //是否使用密码

    Running: Boolean;        //是否正在运行

    ScreenSaver: string;     //当前使用屏幕保护的名

    ScreenSavers: TStrings;  //所有屏幕保护的名

  end;


{ GetScreenSaverinfo 返回屏幕保护的信息 }

function GetScreenSaverInfo: TScreenSaverInfo;

{ StartupScreenSaver 启动一个屏幕瓮中保护 }

function StartScreenSaver(const ExeName, Paras : string): THandle;




{---------------------------------------------------

 以下是关于获取屏幕保护的信息的类型声明和函数

 ----------------------------------------------------}

type

  TACLineStatus = (lsOffline, lsOnline, lsUnknown);

  TBatteryFlag = (bfHigh, bfLow, bfCritical, bfCharging, bfNoSystemBat, bfUnkown);

  TBatteryFlags = set of TBatteryFlag;

  TPowerStatusInfo = record

    ACLineStatus: TACLineStatus;

    BatteryFlags: TBatteryFlags;

    BatterLifePercent: Byte;

    BatteryLifeTime: DWORD;

    BatteryFullLifeTime: DWORD;

  end;

{ GetPowerStatusInfo 返回电源状态和其它信息 }

function GetPowerStatusInfo : TPowerStatusInfo;




{---------------------------------------------------

 以下是关于获取IE浏览器的信息的类型声明和函数

 ----------------------------------------------------}

type

  TInetZoneInfo = record

    Name : string;

    Description : string;

    Sites : TStrings;

  end;


  TInetAdvPropInfo = record

    Name: string;

    Value: Boolean;

  end;


  TInternetInfo = record

    IEVersion : string;         //IE版本

    HomePage: string;           //默认主页

    HTMLEditor: string;         //默认HTML编辑器

    EMailClient: string;        //默认EMail软件

    NewsClient: string;         //默认新闻组软件

    Calendar: string;           //默认日历软件

    InetCall: string;           //默认联系软件

    Contacts: string;           //默认通迅录软件

    TempPath: String;           //临时文件目录

    TempSize: Longint;          //临时文件夹的大小

    InetZones : array of TInetZoneInfo;

    InerAdvProps: array of TInetAdvPropInfo;

  end;

{ GetInternetInfo 返回IE浏览器的基本信息 }

function GetInternetInfo : TInternetInfo;




{---------------------------------------------------

 以下是关于获取墙纸的信息的类型声明和函数

 ----------------------------------------------------}

type

  TWallpaperInfo = record

    Filename: string;

    Tile: Boolean;

    Stretch: Boolean;

    Patterns: TStrings;

    Pattern: string;

  end;


{ GetWallpaperInfo 返回系统的墙纸信息 }

function GetWallpaperInfo : TWallpaperInfo;




{---------------------------------------------------

 以下是关于获取显示器视频模式的信息的类型声明和函数

 ----------------------------------------------------}

type

  TVideoModeInfo = array of record

    Width: Cardinal;              //宽

    Height: Cardinal;             //高

    Frequency: Cardinal;          //频率

    BitsPerPixel: Cardinal;       //每像素颜色数

    Monochrome: Boolean;          //单色

    Interlaced: Boolean;          //交错

    Colors: Cardinal;             //颜色数

  end;


{ GetVideoModeInfo 返回显示器所有视频模式的信息 }

function GetVideoModeInfo: TVideoModeInfo;




{---------------------------------------------------

 以下是关于获取计算机网络的信息的类型声明和函数

 ----------------------------------------------------}

type

  TNetTreatises = (IPX, TCPIP, NetBEUI);

  TNetTreatisesSet = set of TNetTreatises;

  TNetRec = record

    Description: string;

    ServiceName: string;

    Treatises : TNetTreatisesSet;

    IPAddress: string;

    IPSubnetMask: string;

    DefaultGateway: string;

    NetworkNumber: string;

  end;

  TNetInfo = array of TNetRec;

  TNetworkInfo = record

    Nets : TNetInfo;

    ConnectedResources: TStrings;

    SharedResources: TStrings;

    UserName: string;

    ComputerName: string;

  end;


{ GetNetworkInfo 返回计算机网络的信息 }

function GetNetworkInfo: TNetworkInfo;




{---------------------------------------------------

 以下是关于获取系统字体的信息的类型声明和函数

 ----------------------------------------------------}

type

  TFontType = (ftDEVICE, ftRASTER, ftTRUETYPE);

  TFontTypes = set of TFontType;

  TtmFlag = (

    TM_ITALIC, TM_BOLD, TM_REGULAR,

    TM_NONNEGATIVE_AC, TM_PS_OPENTYPE,

    TM_TT_OPENTYPE, TM_MULTIPLEMASTER,

    TM_TYPE1, TM_DSIG);

  TtmFlags = set of TtmFlag;

  TFontInfo = array of record

    LogItalic: Boolean;

    LogStikeOut: Boolean;

    LogUnderline: Boolean;

    LogFamily: Byte;

    LogClipPrecision: Byte;

    LogQuality: Byte;

    LogOutPrecision: Byte;

    LogHeight: LongInt;

    LogOrientation: LongInt;

    LogEscapement: LongInt;

    LogWidth: LongInt;

    LogWeight: LongInt;

    Style: string;

    FullName: string;

    LogFaceName: string;

    Script: string;

    LogCharSet: TFontCharset;

    LogPitch: TFontPitch;

    FontType: TFontTypes;

    tmItalic: Boolean;

    tmUnderline: Boolean;

    tmStikeOut: Boolean;

    tmFamily: Byte;

    tmSizeEM: LongInt;

    tmExternalLeading: LongInt;

    tmMaxCharWidth: LongInt;

    tmCellHeight: LongInt;

    tmHeight: LongInt;

    tmAscent: LongInt;

    tmInternalLeading: LongInt;

    tmWeight: LongInt;

    tmDigitizedAspectY: LongInt;

    tmDigitizedAspectX: LongInt;

    tmDescent: LongInt;

    tmAveCharWidth: LongInt;

    tmFirstChar: string;

    tmCharSet: TFontCharset;

    tmPitch: TFontPitch;

    tmFlags: TtmFlags;

    tmDefaultChar: string;

    tmLastChar: string;

    tmBreakChar: string;

    tmOverhang: LongInt;

    tmAvgWidth: LongInt;

  end;


{ GetFontInfo 返回系统所有字体的信息 }

function GetFontInfo: TFontInfo;




{---------------------------------------------------

 以下是关于获取系统国家的信息的类型声明和函数

 ----------------------------------------------------}

type

  TLocaleInfo = record

    LanguageCode : string;              (* 语言代号 *)

    LanguageName : string;              (* 本地语言名称 *)

    LanguageEngName : string;           (* 语言的英语名 *)

    LanguageShortName : string;         (* 语言名称缩写 *)


    CountryName : string;               (* 国家名 *)

    CountryCode : string;               (* 国家代号 *)

    CountryEngName : string;            (* 国家的英语名称 *)

    CountryShortName : string;          (* 国家名缩写 *)


    DefaultLanguage : string;           (* 缺省语言代号 *)

    DefaultCountryCode : string;        (* 缺省国家代码 *)

    DefaultOemCodePage : string;        (* 缺省oem代码页 *)

    DefaultAnsiCodePage : string;       (* 缺省ansi代码页 *)

    DefaultMacCodePage : string;        (* 缺省mac页 *)


    ListSeparator : string;             (* 列表项分割符 *)

    Measurement : string;               (* 测量单位 米制, 英制 *)


    DecimalSeparator : string;          (* 小数点符号 *)

    ThousandSeparator : string;         (* 千位分割符 *)

    Grouping : string;                  (* digit grouping *)

    Digits : string;                    (* number of fractional digits *)


    CurrencySymbol : string;            (* 本地货币符号 *)

    IntCurrencySymbol : string;         (* 国际货币符号 *)

    CurrencyDecimalSeparator : string;  (* 货币小数点分割符 *)

    CurrencyThousandSeparator : string; (* 货币千位分割符 *)

    CurrencyGrouping : string;          (* monetary grouping *)

    CurrencyDigits : string;            (* # local monetary digits *)

    PositiveCurrencyFormat : string;    (* positive currency mode *)


    DateSeparator : string;             (* 日期分割符 *)

    TimeSeparator : string;             (* 时间分割符 *)

    ShortDateFormat : string;           (* 短日期字符串 *)

    LongDateFormat : string;            (* 长日期字符串 *)

    TimeFormat : string;                (* 时间格式 *)

    ShortDateOrder : string;            (*  short date format ordering *)

    LongDateOrder  : string;            (* long date format ordering *)

    ClockMode : string;                 (* 时间格式 *)

    YearDigits : string;                (* 世纪格式 (短日期) *)

    MorningSymbol : string;             (* AM designator *)

    AfternoonSymbol : string;           (* PM designator *)

    CalendarType : string;              (* 日历类型 *)

    FirstDayOfWeek : string;

    FirstWeekOfYear : string;

    ISOLangShortName : string;          (* ISO 缩写语言名称 *)

    ISOCtryShortName : string;          (* ISO 缩写国家名称 *)

  end;


{ GetLocaleInfo 返回系统默认的国家的信息 }

function GetLocaleInfo: TLocaleInfo;




{---------------------------------------------------

 以下是关于获取Modem的信息的类型声明和函数

 ----------------------------------------------------}

type

  TModemInfo = array of record

    SubKeyName: string;

    PortSpeed: LongInt;

    AttachedTo: string;

    Name: string;

    UserInit: string;

  end;


{ GetModemInfo 返回modem的信息 }

function GetModemInfo: TModemInfo;




{---------------------------------------------------

 以下是关于获取USB设备的信息的类型声明和函数

 ----------------------------------------------------}

type

  TUSBControlInfo = array of record

    DriverName : string;

    DriverVersion : string;

    ProviderName : string;

    DriverDate : string;

  end;


{ GetUSBControlInfo 返回所有USB设备的信息 }

function GetUSBControlInfo : TUSBControlInfo;


implementation


function GetDriveRec(Drive: Char): TDriveRec;

var

  Path : PChar;

  DByte : Byte;

  Serial, D1, D2 : DWORD;

  VolumeLabel, FileSystem: array[0..$FF] of Char;

begin

  Result.Drive := Drive;

  Path := PChar(Drive + ':\');

  DByte := Byte(Drive) - $40;

  Result.DriveType:= TSysDriveType(GetDriveType(Path));

  case Result.DriveType Of

    dtUnknown   : Result.DriveTypeString := SysUNKNOWN;

    dtNoRootDir : Result.DriveTypeString := SysNOROOTDIR;

    dtRemovable : Result.DriveTypeString := SysREMOVABLE;

    dtFixed     : Result.DriveTypeString := SysFIXEDDRIVE;

    dtNetwork   : Result.DriveTypeString := SysREMOTE;

    dtCDROM     : Result.DriveTypeString := SysCDROM;

    dtRAM       : Result.DriveTypeString := SysRAMDISK;

  end;

  Result.DiskSize := DiskSize(DByte);

  Result.DiskFree:= DiskFree(DByte);

  If (Result.DiskSize = -1) and (Result.DriveType <> dtNetwork) then

  begin

    Result.VolumeLabel       := '';

    Result.FileSystem        := '';

    Result.SerialNumber      := '';

    Result.SectorsPerCluster := 0;

    Result.BytesPerSector    := 0;

    Result.MaximumLength     := 0;

    Result.Options           := [];

  end

  else begin

    GetDiskFreeSpace(Path, Result.SectorsPerCluster, Result.BytesPerSector, D1, D2);

    GetVolumeInformation(Path, VolumeLabel, SizeOf(VolumeLabel),

      @Serial, Result.MaximumLength, D2, FileSystem, SizeOf(FileSystem));

    Result.SerialNumber:= IntToHex(Serial, 8);

    Insert('-', Result.SerialNumber, 5);

    Result.VolumeLabel:= VolumeLabel;

    Result.FileSystem:= FileSystem;

    If FS_CASE_IS_PRESERVED and d2 = FS_CASE_IS_PRESERVED then

      Result.Options:= [fsCaseIsPreserved];

    If FS_CASE_SENSITIVE and d2 = FS_CASE_SENSITIVE then

      Include(Result.Options, fsCaseIsPreserved);

    If FS_UNICODE_STORED_ON_DISK and d2 = FS_UNICODE_STORED_ON_DISK then

      Include(Result.Options, fsSupportsUnicode);

    If FS_PERSISTENT_ACLS and d2 = FS_PERSISTENT_ACLS then

      Include(Result.Options, fsPersistentACLs);

    If FS_FILE_COMPRESSION and d2 = FS_FILE_COMPRESSION then

      Include(Result.Options, fsSupportsCompression);

    If FS_VOL_IS_COMPRESSED and d2 = FS_VOL_IS_COMPRESSED then

      Include(Result.Options, fsIsCompressed);

    If Result.FileSystem = 'NTFS' then

      If FILE_ATTRIBUTE_COMPRESSED and GetFileAttributes(Path) = FILE_ATTRIBUTE_COMPRESSED then

        Include(Result.Options, fsIsCompressed);

    If $00000010 and d2 = $00000010 then

      Include(Result.Options, fsSupportsQuotas);

  end;

end;

function GetDriveInfo: TDriveInfo;

var

  Path : string;

  I, J : Integer;

begin

  SetLength(Result, 26);

  J := 0;

  for I := 0 to 25 do

  begin

    Path := Char(65+I)+':\';

    If (GetDriveType(PChar(Path)) In [2..6]) Then

    begin

      Result[J] := GetDriveRec(Char(65+I));

      Inc(J);

    end;

  end;

  SetLength(Result, J);

end;

function GetMemoryInfo : TMemoryInfo;

var

  Memory: MEMORYSTATUS;

  SysInfo : TSystemInfo;

begin

  memory.dwLength := sizeof(memory); //初始化

  GlobalMemoryStatus(memory);

  Result.UsePercent  := memory.dwMemoryLoad;

  Result.MemoryTotal := memory.dwTotalPhys;

  Result.MemoryUsable := memory.dwAvailPhys;

  Result.PageTotal := memory.dwTotalPageFile;

  Result.PageUsable := memory.dwAvailPageFile;

  Result.VirtualTotal := memory.dwTotalVirtual;

  Result.VirtualUsable := memory.dwAvailVirtual;

  GetSystemInfo(SysInfo);

  Result.PageSize := SysInfo.dwPageSize;

  Result.MinAppAddress := Cardinal(SysInfo.lpMinimumApplicationAddress);

  Result.MaxAppAddress := Cardinal(SysInfo.lpMaximumApplicationAddress);

  Result.AllocGranularity:= SysInfo.dwAllocationGranularity;

end;


type

  TCPUFeatureStr = array [TCPUFeature] of string;

const

  CPUVendorName: array[TCPUVendor] of pchar = (

    'Unknown',

    'Intel',

    'AMD',

    'IBM/VIA Cyrix',

    'Centaur/IDT',

    'NexGen',

    'UMC',

    'Rise');

  CPUVendorSigns: array[TCPUVendor] of pchar = (

    'Unidentified',

    'GenuineIntel',

    'AuthenticAMD',

    'CyrixInstead',

    'CentaurHauls',

    'NexGenDriven',

    'UMC UMC UMC ',

    'RiseRiseRise');

  CPUFeaturesAbbreviation: TCPUFeatureStr = (

    'FPU', 'VME', 'DE', 'PSE', 'TSC', 'MSR', 'PAE', 'MCE',

    'CX8', 'APIC', '---', 'SEP', 'MTRR', 'PGE', 'MCA', 'CMOV',

    'PAT', 'PSE-36', 'PSN', 'CLFlush', '---', 'DTES', 'ACPI', 'MMX',

    'FXSR', 'XMM', 'ISSE2', 'SNOOP', '---', 'ACC', 'JMPE', '---'
  );

  CPUFeaturesDescription: TCPUFeatureStr = (

    '内建浮点运算协处理器',

    '虚拟模式扩展',

    '调试模式扩展',

    '页面大小扩展',

    '时间标记记数器',

    '特殊信号寄存器',

    '物理地址扩展',

    '计算机异常检查',

    '比较并调换指令',

    '内建本地APIC',

    '保留',

    '快速系统访问',

    '支持内存范围寄存器',

    '整体页面启用',

    '处理器检查结构',

    '条件指令传送',

    '页面属性运算表',

    '36位虚拟内存扩展',

    '处理器序列号',

    'Cache Line Flush',

    '保留',

    'Debug Trace and EMON Store',

    'Processor Duty Cycle Control',

    'MMX',

    '快速浮点保存与恢复',

    '英特尔单指令多数据流扩展',

    '英特尔单指令多数据流扩展2',

    '自我检测',

    '保留',

    'Automatic Clock Control',

    'JMPE 64-bit Architecture',

    '保留'

  );

  SystemBasicInformation = 0;

  SystemPerformanceInformation = 2;

  SystemTimeInformation = 3;


type

  TSYSTEM_BASIC_INFORMATION = record

    dwUnknown1: DWORD;

    uKeMaximumIncrement: ULONG;

    uPageSize: ULONG;

    uMmNumberOfPhysicalPages: ULONG;

    uMmLowestPhysicalPage: ULONG;

    uMmHighestPhysicalPage: ULONG;

    uAllocationGranularity: ULONG;

    pLowestUserAddress: Pointer;

    pMmHighestUserAddress: Pointer;

    uKeActiveProcessors: ULONG;

    bKeNumberProcessors: Byte;

    bUnknown2: Byte;

    wUnknown3: WORD;

  end;

  TSYSTEM_PERFORMANCE_INFORMATION = record

    liIdleTime: LARGE_INTEGER;

    dwSpare: array[0..75] of DWORD;

  end;

  TSYSTEM_TIME_INFORMATION = record

    liKeBootTime: LARGE_INTEGER;

    liKeSystemTime: LARGE_INTEGER;

    liExpTimeZoneBias: LARGE_INTEGER;

    uCurrentTimeZoneId: ULONG;

    dwReserved: DWORD;

  end;

  PROCNTQSI = function(

    aSystemInformationClass: UINT;      // information type

    var SystemInformation;              // pointer to buffer

    SystemInformationLength: ULONG;     // buffer size in bytes

    var ReturnLength: ULONG): LongInt;  // pointer to a 32-bit

    stdcall;                            // variable that receives


var

  NtQuerySystemInformation: PROCNTQSI;

  _EAX,

  _EBX,

  _ECX,

  _EDX: Integer;

  aBulkData: Packed array[0..31] of byte;

  (*!~it had to be here, do not move after funct declaration*)

const

  _cpuType : Byte = 0;


function ExecuteCPUIDPtr(

  const nLevel:Integer;   //第几个CPU

  var eax, ebx, ecx, edx : pointer  //返回四个寄存器的值

  ):Integer; stdcall; //返回总有的CPU个数

const

  _cpuTypeBit = 12;

  _PSNBitMask = $200000;

asm

  @@Begin:

    cmp nLevel, 3            // Cyrix workaround:

    jnz @@CyrixPass          // PSN-bit mus be enabled

    pushfd                   // no way to turn it back (off) ;)

    pop EAX                  // if you want to do so

    or EAX, _PSNBitMask      // pushfd at begin and popfd at end

    push EAX                 // beware of lost of flow-control

    popfd

  @@CyrixPass:

    cmp nLevel, 2

    jnz @@Synchronized

  @@MPCheck:                 // Multi Processor Check Synchronicity

                            // Differentiate only primary & non-primary
    mov EAX,1

    dw $A20F                // execute service 1 call

    shr EAX, _cpuTypeBit     // extract cpuType

    and AL, 3                // validate bit-0 and bit-1

    cmp AL, _cpuType         // compare wih previous result

    mov _cpuType, AL         // save current value

    loopnz @@MPCheck

  @@Synchronized:

    mov EAX, nLevel

    dw $A20F

    push EAX

    mov EAX, [&ecx]          // var argument is REALLY a pointer-

    mov [EAX], ECX           // load it first to register & then

    mov EAX, [&edx]          // you can get the value it's refers to

    mov [EAX], EDX

    mov EAX, [&ebx]

    mov [EAX], EBX

    pop EAX

    push EBX

    mov EBX, [&eax]

    mov [EBX], EAX

    pop EBX

    cmp nLevel, 0             // is it a level 0 Query?

    jnz @@End

    push EAX                 // save eax result

    shr EAX, _cpuTypeBit     // extract cpuType

    and AL, 3                // validate bit-0 and bit-1

    mov _cpuType, AL

    pop EAX

  @@End:

    mov dword ptr aBulkData, EAX       // save all result

    mov dword ptr aBulkData[+4], EBX   // maybe used sometime

    mov dword ptr aBulkData[+8], ECX   //

    mov dword ptr aBulkData[+12], EDX  //

    mov @Result, EAX                   // done.

end;

function ExecuteCPUID(const nLevel:Integer;

  var eax, ebx, ecx, edx:Integer):Integer;

begin

  Result := ExecuteCPUIDPtr(nLevel, pointer(eax), pointer(ebx),

    pointer(ecx), pointer(edx));

end;

function GetCPUVendorStr(nLevel: Integer): String;

begin

  ExecuteCPUID(nLevel, _EAX, _EBX, _ECX, _EDX);

  SetLength(Result, 4);

  move(_EBX, Result[1], 4);

end;

function GetCPUVendor(nLevel: Integer): TCPUVendor;

var

  Str : string;

begin

  Str := GetCPUVendorStr(0);

  for Result := Low(TCPUVendor) To high(TCPUVendor) do

    if Pos(Str, CPUVendorSigns[Result]) = 1 then Break;

end;

function GetCPUType(nLevel: Integer): TCPUType;

begin

  ExecuteCPUID(nLevel, _EAX, _EBX, _ECX, _EDX);

  Result := TCPUType((_EAX shr 12) and $03);

end;

function GetCPUName(nLevel: Integer): String;

const

  I486=4;

  I586=5;

  I686=6;

  Itanium=$F;

  NOFAMILY='(unknown cpu-family)';

  NOMODEL='(unknown cpu-model)';

var

  cmodel, cfamily : Integer;

begin

  ExecuteCPUID(nLevel, _EAX, _EBX, _ECX, _EDX);

  cfamily := (_EAX shr 8) and $0F;

  cmodel  := (_EAX shr 4) and $0F;

  case GetCPUVendor(nLevel) of

    vnIntel:

    (*!~英特尔*)

      case cfamily of

        I486:

          case cmodel of

            0: Result :='i486 DX 25/33';

            1: Result :='i486 DX 50';

            2: Result :='i486 SX';

            3: Result :='i486 DX2 / i487';

            4: Result :='i486 SL';

            5: Result :='i486 SX2';

            7: Result :='i486 DX2-WB';

            8: Result :='i486 DX4';

            9: Result :='i486 DX4-WB';

            else Result :='i486 '+NOMODEL;

          end;

        I586:

          case cmodel of

            0: Result :='P5 A-Step';

            1: Result :='Pentium 60/66';

            2: Result :='Pentium 75-200';

            3: Result :='P24T OverDrive';

            4: Result :='Pentium MMX 166/200';

            5: Result :='P54C';

            7: Result :='P55C 0.25 micron';

            else Result :='Pentium '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='P6 A-Step';

            1: Result :='Pentium Pro';

            3: Result :='PII model 3 (0.28u)';

            5: Result :='PII model 5 (0.25u),';

            6: Result :='Celeron model 6';

            7: Result :='PIII model 7 (0.25u)';

            8: Result :='PIII/Xeon model 8 (0.18u) 256KB L2 Cache';

            11: Result :='Celeron III model 11 (0.13u) 256B L2 Cache';

            $A: Result :='PIII Xeon model A 1/2 MB L2 Cache';

            else Result :='Pentium Pro'+NOMODEL;

          end;

        Itanium: Result  :='Itanium IA-64';

        else Result  := NOMODEL;

      end;

    vnAMD:

    (*!~AMD*)

      case cfamily of

        I486:

          case cmodel of

            3: Result :='80486 DX2';

            7: Result :='80486 DX2 WB';

            8: Result :='80486 DX4';

            9: Result :='80486 DX4 WB';

            $E: Result :='5x86';

            $F: Result :='5x86 WB';

            else Result :='4x86 '+NOMODEL;

          end;

        I586:

          case cmodel of

            0: Result :='SSA5 PR-75/90/100)';

            1: Result :='5K86 PR-120/133';

            2: Result :='5K86 PR-166';

            3: Result :='5K86 PR-200';

            6: Result :='K6 0.3 micron';

            7: Result :='K6 0.25 micron';

            8: Result :='K6-II';

            9: Result :='K6-III';

            else Result :='K5/K6 '+NOMODEL;

          end;

        I686:

          case cmodel of

            1: Result :='K7 0.25u';

            2: Result :='K7 0.18u';

            3: Result :='K7 0.18u 64KB L2 Cache';

            4: Result :='K7 0.18u 256KB L2 Cache';

            else Result :='K7 '+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

    vnCyrix:

      case cfamily of

        I486:

          case cmodel of

            4: Result :='Media GX/GXm';

            9: Result :='5x86';

            else Result :='5x86 '+NOMODEL;

          end;

        I586:

          case cmodel of

            2: Result :='M1';

            4: Result :='Media GX/GXm';

            else Result :='M1 '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='M2';

            5: Result :='III';

            else Result :='M2 '+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

    vnIDT:

      case cfamily of

        I486:

          case cmodel of

            0: Result :='x486';

            else Result :='x486 '+NOMODEL;

          end;

        I586:

          case cmodel of

            4: Result :='C6';

            8: Result :='C2';

            9: Result :='C3';

            else Result :='C6 '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='C7';

            else Result :='C7 '+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

    vnNexGen:

      case cfamily of

        I486:

          case cmodel of

            0: Result :='nx486'

            else Result :='nx486 '+NOMODEL;

          end;

        I586:

          case cmodel of

            0: Result :='nx586 / nx586FPU';

            else Result :='nx586 '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='nx686';

            else Result :='nx686'+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

    vnUMC:

      case cfamily of

        I486:

          case cmodel of

            1: Result :='U5D';

            2: Result :='U5S';

            else Result :='U5-S/D '+NOMODEL;

          end;

        I586:

          case cmodel of

            0: Result :='x586';

            else Result :='x586 '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='x686';

            else Result :='x686'+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

    vnRise:

      case cfamily of

        I486:

          case cmodel of

            0: Result :='mP5'

            else Result :='mP5 '+NOMODEL;

          end;

        I586:

          case cmodel of

            0: Result :='mP6 0.25u';

            2: Result :='mP6 0.18u';

            else Result :='mP6 '+NOMODEL;

          end;

        I686:

          case cmodel of

            0: Result :='x686';

            else Result :='x686'+NOMODEL;

          end;

        else Result :=NOMODEL;

      end;

  end;

  Result := CPUVendorName[GetCPUVendor(nLevel)]+' '+Result;

end;

function GetCPUFeature(nLevel : Integer): TCPUFeatureSet;

var

  Feature: TCPUFeature;

begin

  Result := [];

  ExecuteCPUID(nLevel, _EAX, _EBX, _ECX, _EDX);

  for Feature := low(TCPUFeature) to high(TCPUFeature) do

    If _EDX and (1 shl ord(Feature)) <> 0 then

      Include(Result, Feature);

end;

function CPUFeatureToStr(Features : TCPUFeatureSet): String;

var

  Feature: TCPUFeature;

begin

  for Feature := low(TCPUFeature) to high(TCPUFeature) do

  begin

    Result := Result +

      CPUFeaturesDescription[feature]+'('+

      CPUFeaturesAbbreviation[feature]+')';

    If Feature in Features then

       Result := Result+':是'+#13#10

    else Result := Result+':否'+#13#10;

  end;

end;

function GetCPURec(nLevel : Integer): TCPURec;

const

  Key = '\HARDWARE\DESCRIPTION\System\CentralProcessor\';

begin

  with TRegistry.Create do

  begin

    try

      RootKey := HKEY_LOCAL_MACHINE;

      If OpenKey(Key+Inttostr(nLevel), False) then

      begin

        Result.ID   := ReadString('Identifier');

        Result.MHZ  := ReadInteger('~MHz');

        CloseKey;

        Result.Name := GetCPUName(nLevel);

        Result.cType := GetCPUType(nLevel);

        Result.Features := GetCPUFeature(nLevel);

        Result.Vendor := GetCPUVendor(nLevel);

        Result.FeatureStr := CPUFeatureToStr(Result.Features);

      end;

    finally

       Free

    end;

  end;

end;

function GetCPUInfo: TCPUInfo;

const

  Key = 'HARDWARE\DESCRIPTION\System\CentralProcessor\';

var

  hkey: Windows.hkey;

  dwDataSize: DWORD;

  dwType: DWORD;

  dwCpuUsage: DWORD;

  SysPerfInfo: TSYSTEM_PERFORMANCE_INFORMATION;

  SysTimeInfo: TSYSTEM_TIME_INFORMATION;

  SysBaseInfo: TSYSTEM_BASIC_INFORMATION;

  dbIdleTime: double;

  dbSystemTime: double;

  status: LongInt;

  liOldIdleTime: LARGE_INTEGER;         //= (*0,0*);

  liOldSystemTime: LARGE_INTEGER;       // = (*0,0*);

  ReturnLength: ULONG;

  I : LongInt;

  S : TStrings;

begin

  S := TStringList.Create;

  with TRegistry.Create do

  begin

    try

      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey(Key, False);

      (*检测注册表里有几个CPU记录*)

      GetKeyNames(S);

      SetLength(Result.CPUs, S.Count);

      for I := 0 to S.Count - 1 do

        Result.CPUs[I] := GetCPURec(I+1);

      CloseKey;

    finally

      S.Free;

      free;

    end;

  end;

  Result.CPUUsage := Byte(-1);

  If Win32Platform = VER_PLATFORM_WIN32_NT then

  begin

    liOldIdleTime.QuadPart:= 0;

    liOldSystemTime.QuadPart:= 0;

    IF not Assigned(NtQuerySystemInformation) then Exit;

    (*得到CPU的数量*)

    status := NtQuerySystemInformation(SystemBasicInformation,

      SysBaseInfo, SizeOf(SysBaseInfo), ReturnLength);

    If status <> NO_ERROR then Exit;

    Result.CPUCount:= SysBaseInfo.bKeNumberProcessors;

    for I:= 0 to 1 do

    begin

      (*返回新的系统时间*)

      status:= NtQuerySystemInformation(SystemTimeInformation, SysTimeInfo,

         SizeOf(SysTimeInfo), ReturnLength);

      If status <> NO_ERROR then Exit;

      (*返回新的CPU空闲时间*)

      status:= NtQuerySystemInformation(SystemPerformanceInformation,

        SysPerfInfo, SizeOf(SysPerfInfo), ReturnLength);


      If status <> NO_ERROR then Exit;

      // if it's a first call - skip it

      If liOldIdleTime.QuadPart <> 0 then

      begin

        // CurrentValue = NewValue - OldValue

        dbIdleTime:= SysPerfInfo.liIdleTime.QuadPart - liOldIdleTime.QuadPart;

        dbSystemTime:= SysTimeInfo.liKeSystemTime.QuadPart - liOldSystemTime.QuadPart;


        // CurrentCpuIdle = IdleTime / SystemTime

        dbIdleTime:= dbIdleTime / dbSystemTime;


        // CurrentCpuUsage% = 100 - (CurrentCpuIdle * 100) / NumberOfProcessors

        dbIdleTime:= 100.0 - dbIdleTime * 100.0 / SysBaseInfo.bKeNumberProcessors + 0.5;

        Result.CPUUsage:= Round(dbIdleTime);

      end;


      // store new CPU's idle and system time

      liOldIdleTime:= SysPerfInfo.liIdleTime;

      liOldSystemTime:= SysTimeInfo.liKeSystemTime;

      Sleep(500);

    end;

  end

  else begin

    Result.CPUCount := 1;

    If RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StartStat',

      0, KEY_ALL_ACCESS, hkey) <> ERROR_SUCCESS Then Exit;

    dwDataSize:= SizeOf(DWORD);

    RegQueryValueEx(hkey, 'KERNEL\CPUUsage', nil, @dwType,

      @dwCpuUsage, @dwDataSize);

    RegCloseKey(hkey);


    // geting current counter's value

    If RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StatData',

      0, KEY_READ, hkey) <> ERROR_SUCCESS then Exit;

    dwDataSize:= SizeOf(DWORD);

    RegQueryValueEx(hkey, 'KERNEL\CPUUsage', nil, @dwType,

      @dwCpuUsage, @dwDataSize);

    Result.CPUUsage:= dwCpuUsage;

    RegCloseKey(hkey);

    // stoping the counter

    If RegOpenKeyEx(HKEY_DYN_DATA, 'PerfStats\StopStat', 0, KEY_ALL_ACCESS,

      hkey) <> ERROR_SUCCESS then Exit;

    dwDataSize:= SizeOf(DWORD);

    RegQueryValueEx(hkey, 'KERNEL\CPUUsage', nil, @dwType,

      @dwCpuUsage, @dwDataSize);

    RegCloseKey(hkey);

  end;

end;

function GetKeyBoardTypeName: String;

begin

  {获取键盘类型}

  case getkeyboardtype(0) of

    1:  result := 'IBM PC/XT 或兼容类型(83键)';

    2:  result := 'Olivetti "ICO"(102键)';

    3:  result := 'IBM PC/AT(84键)';

    4:  result := 'IBM 增强型(101或102键)或Microsoft自然键盘';

    5:  result := 'Nokia 1050';

    6:  result := 'Nokia 9140';

    7:  result := 'Japanese';

  end;

end;

function GetKeyboardState:TKeyboardState;

begin

  result := [];

  if lo(GetKeyState(VK_NUMLOCK)) = 1 then

    Include(result, ksNumLock);

  if lo(GetKeyState(VK_CAPITAL)) = 1 then

    Include(result, ksCapsLock);

  if lo(GetKeyState(VK_LSHIFT)) = 1 then

    Include(result, ksLeftShift);

  if lo(GetKeyState(VK_RSHIFT)) = 1 then

    Include(result, ksRightShift);

  if lo(GetKeyState(VK_LCONTROL)) = 1 then

    Include(result, ksLeftCtrl);

  if lo(GetKeyState(VK_RCONTROL)) = 1 then

    Include(result, ksRightCtrl);

  if lo(GetKeyState(VK_LMENU)) = 1 then

    Include(result, ksLeftAlt);

  if lo(GetKeyState(VK_RMENU)) = 1 then

    Include(result, ksRightAlt);

  if lo(GetKeyState(VK_LWIN)) = 1 then

    Include(result, ksLeftWin);

  if lo(GetKeyState(VK_RWIN)) = 1 then

    Include(result, ksRightWin);

end;


function GetKeyboardInfo : TKeyboardInfo;

begin

  with Result do

  begin

    SystemParametersInfo(SPI_GETKEYBOARDDELAY, 0, @Delay, 0);

    SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @Speed, 0);

    NumLock := lo(GetKeyState(VK_NUMLOCK)) = 1;

    CapsLock:= lo(GetKeyState(VK_CAPITAL)) = 1;

    ScrollLock := lo(GetKeyState(VK_SCROLL)) = 1;

    Types := GetKeyboardType(0);

    SubType := GetKeyboardType(1);

    FunctionKeys := GetKeyboardType(2);

    SetLength(Layout, KL_NAMELENGTH);

    GetKeyboardLayoutName(Pchar(Layout));

    CaretBlinkTime:= GetCaretBlinkTime;

    Result.TypeStr := GetKeyBoardTypeName;

  end;

end;

function GetMouseInfo : TMouseInfo;

const

  Key1 = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\Cursors\Schemes';

  Key2 = '\SYSTEM\CurrentControlSet\Control\Class\(*4D36E96F-E325-11CE-BFC1-08002BE10318*)\0000';

  Key3 = '\Control Panel\Cursors';

var

  I: Integer;

begin

  with Result do

  begin

    Exist:= Boolean(GetSystemMetrics(SM_MOUSEPRESENT));

    Btns:= GetSystemMetrics(SM_CMOUSEBUTTONS);

    Wheel:= Boolean(GetSystemMetrics(SM_MOUSEWHEELPRESENT));

    SwapBtns:= Boolean(GetSystemMetrics(SM_SWAPBUTTON));

    DoubleClickTime:= GetDoubleClickTime;

    SystemParametersInfo(SPI_GETSNAPTODEFBUTTON, 0, @SnapToDefault, 0);

    SystemParametersInfo(SPI_GETMOUSESPEED, 0, @Speed, 0);

    DblClickWidth:= GetSystemMetrics(SM_CXDOUBLECLK);

    DblClickHeight:= GetSystemMetrics(SM_CYDOUBLECLK);

    with TRegistry.Create do

    begin

      CursorSchemes := TStringlist.Create;

      CurSchemeFiles := TStringlist.Create;

      RootKey := HKEY_LOCAL_MACHINE;

      If KeyExists(Key2) Then

      begin

        OpenKey(Key2,false);

        Result.Comment := ReadString('DriverDesc');

      end;

      If OpenKey(Key1, False) then

      begin

        GetValueNames(CursorSchemes);

        for i:= 0 to CursorSchemes.Count - 1 do

          CurSchemeFiles.Add(ReadString(CursorSchemes[i]));

        CloseKey;

      end;

      RootKey := HKEY_CURRENT_USER;

      If OpenKey(key3, False) then

      begin

        CursorScheme := ReadString('');

        CloseKey;

      end;

      Free;

    end;

  end;

end;

function GetUninstallInfo : TUninstallInfo;

const

  Key = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\';

var

  S : TStrings;

  I : Integer;

  J : Integer;

begin

  with TRegistry.Create do

  begin

    S := TStringlist.Create;

    J := 0;

    try

      RootKey:= HKEY_LOCAL_MACHINE;

      OpenKeyReadOnly(Key);

      GetKeyNames(S);

      Setlength(Result, S.Count);

      for I:= 0 to S.Count - 1 do

      begin

        If OpenKeyReadOnly(Key + S[I]) then

        If ValueExists('DisplayName') and ValueExists('UninstallString') then

        begin

          Result[J].RegProgramName:= S[I];

          Result[J].ProgramName:= ReadString('DisplayName');

          Result[J].UninstallPath:= ReadString('UninstallString');

          If ValueExists('Publisher') then

            Result[J].Publisher:= ReadString('Publisher');

          If ValueExists('URLInfoAbout') then

            Result[J].PublisherURL:= ReadString('URLInfoAbout');

          If ValueExists('DisplayVersion') then

            Result[J].Version:= ReadString('DisplayVersion');

          If ValueExists('HelpLink') then

            Result[J].HelpLink:= ReadString('HelpLink');

          If ValueExists('URLUpdateInfo') then

            Result[J].UpdateInfoURL:= ReadString('URLUpdateInfo');

          If ValueExists('RegCompany') then

            Result[J].RegCompany:= ReadString('RegCompany');

          If ValueExists('RegOwner') then

            Result[J].RegOwner:= ReadString('RegOwner');

          Inc(J);

        end;

      end;

    finally

      Free;

      S.Free;

      SetLength(Result, J);

    end;

  end;

end;


const

  // 用于描述系统文件夹的前缀常量

  SystemFolderNames : array[0..19] of string = (

    '程序',

    '我的文档',

    '收藏夹',

    '启动',

    '文档',

    '发送到...',

    '开始',

    '桌面',

    '网上邻居',

    '字体',

    'Templates',

    '开始(所有用户)',

    '程序(所有用户)',

    '启动(所有用户)',

    '桌面(所有用户)',

    'Application Data',

    'Windows目录',

    '系统目录',

    'Program Files目录',

    '临时文件夹'

  );

  SystemFolderPaths : array [0..15] of Integer = (

    02,  (*开始->程序*)

    05,  (*我的文档*)

    06,  (*收藏夹*)

    07,  (*开始->程序->启动*)

    08,  (*开始->文档*)

    09,  (*发送到...*)

    11,  (*开始菜单*)

    16,  (*桌面目录*)

    19,  (*网上邻居*)

    20,  (*字体*)

    21,  (*模板目录*)

    22,  (*所有用户的开始菜单*)

    23,  (*所有用户的开始->程序*)

    24,  (*所有用户的开始->程序-启动*)

    25,  (*所有用户的桌面*)

    26   (*Application Data*)

  );


function GetSystemFolders: TSysFolders;

var

  I : Integer;

  P : pItemIDList;

begin

  SetLength(Result, 20);

  try

    for I := 0 to 19 do

    begin

      Result[I].Name  := SystemFolderNames[I];

      SetLength(Result[I].Path, 255);

    end;

    for I := 0 to 15 do

    begin

      If SHGetSpecialFolderLocation(0, SystemFolderPaths[I], p) <> NOERROR then Continue;

      If p = nil then Continue;

      SHGetPathFromIDList(p, PChar(Result[I].Path));

    end;

    GetWindowsDirectory(PChar(Result[16].Path), 255);

    GetSystemDirectory(PChar(Result[17].Path), 255);

    with TRegistry.Create do

    begin

      RootKey := HKEY_LOCAL_MACHINE;

      If OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False) Then

        Result[18].Path := ReadString('ProgramFilesDir');

      CloseKey;

      Free;

    end;

    GetTempPath(255, PChar(Result[19].Path));

  except

    exit;

  end;

end;

function GetWindowInfo : TWindowInfo;

const

  Key9x = '\SOFTWARE\Microsoft\Windows\CurrentVersion';

  KeyNt = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion';

var

  osVerInfo : TOSVersionInfo;

  sys: TSystemTime;

begin

  with TRegistry.Create do

  begin

    RootKey := HKEY_LOCAL_MACHINE;

    If Win32PlatForm = VER_PLATFORM_WIN32_NT then

      OpenKey(KeyNt, False)

      else OpenKey(Key9x, False);

    Result.RegisteredOwner := ReadString('RegisteredOwner');

    Result.RegisteredCompany := ReadString('RegisteredOrganization');

    Result.ProductID := ReadString('ProductID');

    Result.ProductName := ReadString('ProductName');

    Result.Version := ReadString('CurrentVersion');

    CloseKey;

    Free;

  end;

  osVerInfo.dwOSVersionInfoSize:= SizeOf(osVerInfo);

  GetVersionEx(osVerInfo);

  with osVerInfo do

  begin

    Result.CSDVersion :=  szCSDVersion;

    Result.BuildNumber := dwBuildNumber;

    Result.PlatformID :=  dwPlatformId;

    Result.MajorVersion := dwMajorVersion;

    Result.MinorVersion := dwMinorVersion;

  end;

  Result.WindowVersion := GetVersion;

  Result.WindowName := GetVersionName(GetVersion);

  Result.CurrentUserName := GetUserName;

  Result.Language := GetSystemDefaultLangName;

  Result.Folders := GetSystemFolders;

end;

var

  OS : Integer = 0;

function GetVersion : Integer;

var

  VerInfo: TOSVersionInfo;

begin

  if OS = 0 then

  begin

    VerInfo.dwOSVersionInfoSize := SizeOf (TOSVersionInfo);

    GetVersionEx (VerInfo);

    case VerInfo.dwPlatformId of

      VER_PLATFORM_WIN32_NT :

      begin

        case VerInfo.dwMajorVersion of

          0..3 : OS := OS_WINDOWSNT3;

          4 :

            If string(VerInfo.szCSDVersion)='Service Pack 4' then

              OS := OS_WINDOWSNT4SP4

              else OS := OS_WINDOWSNT4;

          else

            if VerInfo.dwMajorVersion >= 5 then

               if VerInfo.dwMinorVersion > 0 then

                  OS := OS_WINDOWSXP

                  else OS := OS_WINDOWS2000;

        end;

      end;

      VER_PLATFORM_WIN32_WINDOWS :

      begin

        If (VerInfo.dwMajorVersion=4) and (VerInfo.dwMinorVersion=0) then

        begin

          If VerInfo.dwBuildNumber>1000 then

            OS := OS_WINDOWS95OSR2

            else OS := OS_WINDOWS95;

        end

        else if (VerInfo.dwMajorVersion=4) and (VerInfo.dwMinorVersion=10) then

        begin

          If (VerInfo.szCSDVersion[1] = 'A') then

            OS := OS_WINDOWS98SE

            else OS := OS_WINDOWS98;

        end

        else if (VerInfo.dwMajorVersion = 4) and (VerInfo.dwMinorVersion = 90) Then

          OS := OS_WINDOWSME

        else OS := OS_UNKNOW;

      end;

      VER_PLATFORM_WIN32s : OS := OS_WINDOWS31;

      else OS := OS_UNKNOW;

    end;

  end;

  result := OS;

end;

function GetVersionName(Version : Integer): string;

begin

  case Version of

    OS_UNKNOW : Result := 'Microsoft Windows';

    OS_WINDOWS31 : Result := 'Microsoft Windows 3.1';

    OS_WINDOWS95 : Result := 'Microsoft Windows 95';

    OS_WINDOWS95OSR2 : Result := 'Microsoft Windows 95 OSR2';

    OS_WINDOWS98 : Result := 'Microsoft Windows 98';

    OS_WINDOWS98SE : Result := 'Microsoft Windows 98 Second Edition';

    OS_WINDOWSME : Result := 'Microsoft Windows Millennium Edition';

    OS_WINDOWSNT3 : Result := 'Microsoft Windows NT 3';

    OS_WINDOWSNT4 : Result := 'Microsoft Windows NT 4';

    OS_WINDOWSNT4SP4 : Result := 'Microsoft Windows NT 4 + SP4';

    OS_WINDOWS2000 : Result := 'Microsoft Windows 2000 / NT 5';

    OS_WINDOWSXP : Result := 'Microsoft Windows XP';

   end;

end;

function GetUserName : string;

const

  cnMaxUserNameLen = 254;

var

  dwUserNameLen : DWord;

begin

  result := '';

  dwUserNameLen := cnMaxUserNameLen-1;

  SetLength( Result, cnMaxUserNameLen );

  Windows.GetUserName( PChar( Result ), dwUserNameLen );

  SetLength( result, dwUserNameLen );

end;

function GetSystemDefaultLangName : string;

var

  IdiomaID:LangID;

  Idioma: array [0..100] of char;

begin

  IdiomaID:= GetSystemDefaultLangID;

  VerLanguageName(IdiomaID,Idioma,100);

  Result:=String(Idioma);

end;

function GetTimeZoneinfo : TTimeZoneInfo;

const

  KeyNt = '\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones';

  Key9x = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Time Zones';

var

  Tzi: TTimeZoneInformation;

  S : TStrings;

  I : Integer;

  Key : string;

begin

  GetTimeZoneInformation(Tzi);

  with Tzi do

  begin

    Result.Bias := Bias;

    Result.StandardName := WideCharToString(StandardName);

    Result.DayLightName := WideCharToString(DayLightName);

    StandardDate.wYear  := 2000;

    //day = 5 => last Sunday in wMonth, otherwise wDay = Sunday in wMonth for change!

    Result.StandardDate := SystemTimeToDateTime(StandardDate);

    DayLightDate.wYear  := 2000;

    //day = 5 => last Sunday in wMonth, otherwise wDay = Sunday in wMonth for change!

    Result.DayLightDate := SystemTimeToDateTime(DayLightDate);

    Result.StandardBias := StandardBias;

    Result.DayLightBias := DayLightBias;

  end;

  S := TStringList.Create;

  with TRegistry.Create do

    try

      RootKey := HKEY_LOCAL_MACHINE;

      If Win32PlatForm = VER_PLATFORM_WIN32_NT then

        Key := KeyNt

        else Key := Key9x;

      If OpenKey(Key, False) Then

      begin

        GetKeyNames(S);

        SetLength(Result.Standards, S.Count);

        for I := 0 to S.Count-1 do

          If OpenKey(Key+'\'+S[I], False) Then

          begin

            Result.Standards[I].Display := ReadString('Display');

            Result.Standards[I].Dlt := ReadString('dlt');

            Result.Standards[I].Index := ReadInteger('Index');

            Result.Standards[I].MapID := Readstring('MapID');

            Result.Standards[I].Std := ReadString('Std');

            CloseKey;

          end;

        CloseKey;

      end;

    finally

       S.Free;

       Free;

    end;

end;

function GetScreenSaverInfo: TScreenSaverInfo;

const

  sz = 1023;

var

  Time : Integer;

  Bool : Boolean;

  Path : array[0..sz] of char;

  procedure Enumeration(var List: TStrings);

  var

    R : TSearchRec;

    S : string;

    T : Integer;

  begin

    S := Path;

    If S[Length(S)] <> '\' then S := S + '\';

    T := FindFirst(s + '*.scr', faAnyFile + faArchive + faSysFile + faHidden, R);

    while T = 0 do

    begin

      List.Add(S + R.Name);

      T := FindNext(R);

    end;

    SysUtils.FindClose(R);

  end;

begin

  SystemParametersInfo(SPI_GETSCREENSAVETIMEOUT, 0, @time, 0);

  Result.Delay  := time;

  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE, 0, @bool, 0);

  Result.Active := bool;

  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, @bool, 0);

  Result.Running := bool;

  with TRegistry.Create do

  begin

    RootKey := HKEY_CURRENT_USER;

    If OpenKey('\Control Panel\Desktop', False) then

    begin

      Result.Secure := ReadString('ScreenSaverSecure') = '';

      Result.ScreenSaver := ReadString('SCRNSAVE.EXE');

      Result.UsePassword := ReadString('ScreenSaveUsePassword') = '1';

      CloseKey;

    end;

    Free;

  end;

  Result.ScreenSavers := TStringList.Create;

  GetWindowsDirectory(Path, sz);

  Enumeration(Result.ScreenSavers);

  GetSystemDirectory(Path, sz);

  Enumeration(Result.ScreenSavers);

end;

function StartScreenSaver(const ExeName, Paras : String): THandle;

var

  PI  : PROCESS_INFORMATION;

  SIA : _STARTUPINFOA;

begin

  PI.hProcess:= 0;

  with SIA do

  begin

    cb:= SizeOf(SIA);

    lpReserved:= nil;

    lpDesktop:= nil;

    lpTitle:= nil;

    dwFlags:= STARTF_USESHOWWINDOW or STARTF_FORCEOFFFEEDBACK;

    wShowWindow:= SW_SHOW;

    cbReserved2:= 0;

    lpReserved2:= nil;

  end;

  Windows.CreateProcess(PChar(exeName), PChar(paras), nil, nil, false,

    NORMAL_PRIORITY_CLASS, nil, nil, SIA, PI);

  CloseHandle(PI.hThread);

  Result:= PI.hProcess;

end;

function GetPowerStatusInfo : TPowerStatusInfo;

var

  Sps: _SYSTEM_POWER_STATUS;

begin

  GetSystemPowerStatus(Sps);

  with Sps do

  begin

    case ACLineStatus of

      0: Result.ACLineStatus := lsOffline;

      1: Result.ACLineStatus := lsOnline;

      else  Result.ACLineStatus := lsUnknown;

    end;

    Result.BatteryFlags:= [];

    If BatteryFlag and 1 = 1 then Include(Result.BatteryFlags, bfHigh);

    If BatteryFlag and 2 = 2 then Include(Result.BatteryFlags, bfLow);

    If BatteryFlag and 4 = 4 then Include(Result.BatteryFlags, bfCritical);

    If BatteryFlag and 8 = 8 then Include(Result.BatteryFlags, bfCharging);

    If BatteryFlag and 128 = 128 then Include(Result.BatteryFlags, bfNoSystemBat);

    If BatteryFlag and 256 = 256 then Include(Result.BatteryFlags, bfUnkown);

    Result.BatterLifePercent := BatteryLifePercent;

    Result.BatteryLifeTime:= BatteryLifeTime;

    Result.BatteryFullLifeTime:= BatteryFullLifeTime;

  end;

end;

function GetInternetInfo : TInternetInfo;

var

  Reg : TRegistry;

  procedure GetAdvOpt(aPath, aN: string; var Info : TInternetInfo);

  var

    S : TStrings;

    I : LongInt;

    J : LongInt;

    CheckedValueS: string;

    CheckedValueI: LongInt;

  begin

    S := TStringlist.Create;

    with Reg do

      try

        RootKey := HKEY_LOCAL_MACHINE;

        OpenKey('\SOFTWARE\Microsoft\Internet Explorer\AdvancedOptions' + aPath, false);

        GetKeyNames(S);

        J := High(Info.InerAdvProps)+1;

        SetLength(Info.InerAdvProps, S.Count+J);

        for I:= 0 to S.Count - 1 do

        begin

          If OpenKey('\SOFTWARE\Microsoft\Internet Explorer\AdvancedOptions' + aPath + '\' + S[I], false) then

          begin

            If AnsiCompareText(ReadString('Type'), 'group') = 0 then

              GetAdvOpt(aPath + '\' + S[I], aN + ReadString('Text') + ':', Info)

            else begin

              Info.InerAdvProps[I+J].Name := ReadString('Text');

              case GetDataType('CheckedValue') of

                rdUnknown,

                rdBinary: ;

                rdString,

                rdExpandString: CheckedValueS := ReadString('CheckedValue');

                rdInteger: CheckedValueI := ReadInteger('CheckedValue');

              end;

              RootKey:= HKEY_CURRENT_USER; //R.ReadInteger('HKeyRoot');

              OpenKey(ReadString('RegPath'), false);

              If ValueExists(ReadString('ValueName')) then

              begin

                case Reg.GetDataType(ReadString('ValueName')) of

                  rdUnknown,

                  rdBinary: ;

                  rdString,

                  rdExpandString:

                  Info.InerAdvProps[I+J].Value:= AnsiSameText(CheckedValueS, ReadString(ReadString('ValueName')));

                  rdInteger: Info.InerAdvProps[I+J].Value:= CheckedValueI = ReadInteger(ReadString('ValueName'));

                end;

              end

              else Info.InerAdvProps[I+J].Value:= false;

              CloseKey;

            end;

          end;

          CloseKey;

        end;

      finally

        S.Free;

      end;

  end;

  procedure GetZoneSites(aZoneIndex: string; aZoneDomain: string; aURL: string; aSites: TStrings);

  var

    S: TStrings;

    I: LongInt;

  begin

    S:= TStringList.Create;

    try

      with Reg do

      begin

        OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains' + aZoneDomain, false);

        GetValueNames(S);

        for I:= 0 to S.Count - 1 do

          If (S[I] <> '') and (AnsiCompareText(IntToStr(ReadInteger(S[I])), aZoneIndex) = 0) then

            aSites.Add(S[I] + '://' + aURL);

        S.Clear;

        GetKeyNames(S);

        CloseKey;

        for I:= 0 to S.Count - 1 do

          GetZoneSites(aZoneIndex, aZoneDomain + '\' + S[I], S[I] + '.' + aURL, aSites);

      end;

    finally

      S.Free;

    end;

  end;

var

  S : TStrings;

  I : LongInt;

  D : PItemIDList;

  P : array[0..MAX_PATH] of Char;

begin

  S := TStringList.Create;

  Reg := TRegistry.Create;

  try

    with Reg do

    begin

      (*-------------------------------------*)

      RootKey := HKEY_CURRENT_USER;

      OpenKey('\Software\Microsoft\Internet Explorer\Main\', False);

      Result.HomePage := ReadString('Start Page');

      CloseKey;

      (*-------------------------------------*)

      RootKey := HKEY_LOCAL_MACHINE;

      OpenKey('\SOFTWARE\Clients\Calendar', False);

      OpenKey(ReadString(''), False);

      Result.Calendar := ReadString('');

      CloseKey;

      CloseKey;

      (*-------------------------------------*)

      OpenKey('\SOFTWARE\Microsoft\Internet Explorer', False);

      Result.IEVersion := ReadString('Version');

      CloseKey;

      (*-------------------------------------*)

      OpenKey('\SOFTWARE\Clients\Contacts', False);

      OpenKey(ReadString(''), False);

      Result.Contacts := ReadString('');

      CloseKey;

      CloseKey;

      (*-------------------------------------*)

      OpenKey('\SOFTWARE\Clients\Mail', False);

      OpenKey(ReadString(''), False);

      Result.EMailClient := ReadString('');

      CloseKey;

      CloseKey;

      (*-------------------------------------*)

      OpenKey('\SOFTWARE\Clients\News', False);

      OpenKey(ReadString(''), False);

      Result.NewsClient := ReadString('');

      CloseKey;

      CloseKey;

      (*-------------------------------------*)

      OpenKey('\SOFTWARE\Clients\Internet Call', False);

      OpenKey(ReadString(''), False);

      Result.InetCall := ReadString('');

      CloseKey;

      CloseKey;

      (*-------------------------------------*)

      RootKey := HKEY_CURRENT_USER;

      OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Content\', False);

      Result.TempSize := ReadInteger('CacheLimit');

      CloseKey;

      If SHGetSpecialFolderLocation(0, CSIDL_INTERNET_CACHE, D) = NOERROR then

      begin

        SHGetSpecialFolderPath(0, P, CSIDL_INTERNET_CACHE, false);

        SetLength(Result.TempPath, 255);

        SHGetPathFromIDList(D, PChar(Result.TempPath));

      end;

      (*-------------------------------------*)

      RootKey:= HKEY_CURRENT_USER;

      If OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones', false) then

      begin

        GetKeyNames(S);

        SetLength(Result.InetZones, S.Count);

        for I := 0 to S.Count - 1 do

        begin

          If OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\' + S[I], false) then

          begin

            Result.InetZones[I].Name := ReadString('DisplayName');

            Result.InetZones[I].Description := ReadString('Description');

            Result.InetZones[I].Sites := TStringList.Create;

            GetZoneSites(S[I], '', '', Result.InetZones[I].Sites);

          end;

          CloseKey;

        end;

      end;

      (*-------------------------------------*)

      GetAdvOpt('', '', Result);

    end;

  finally

    s.Free;

    Reg.Free;

  end;

end;

function GetWallpaperInfo : TWallpaperInfo;

var

  I : Integer;

  PatternMasks : TStrings;

  PatternMask : string;

begin

  PatternMasks := TStringList.Create;

  with TRegistry.Create do

    try

      RootKey := HKEY_CURRENT_USER;

      If OpenKey('\Control Panel\Desktop', False) then

      begin

        Result.Filename:= ReadString('Wallpaper');

        PatternMask:= ReadString('Pattern');

        Result.Tile:= ReadString('TileWallpaper') = '1';

        Result.Stretch:= ReadString('WallpaperStyle') = '2';

        CloseKey;

      end;

      If Result.Filename = '' Then

        If OpenKey('Software\Microsoft\Internet Explorer\Desktop\General', False) then

        begin

          Result.Filename:= ReadString('Wallpaper');

          CloseKey;

        end;

      Result.Patterns := TStringList.Create;

      If OpenKey('\Control Panel\Patterns', False) then

      begin

        GetValueNames(Result.Patterns);

        for I := 0 to Result.Patterns.Count - 1 do

          PatternMasks.Add(ReadString(Result.Patterns[i]));

        CloseKey;

      end;

      Result.Pattern:= '';

      for I := 0 to Result.Patterns.Count - 1 do

        If PatternMasks[i] = PatternMask then

          Result.Pattern:= Result.Patterns[I];

    finally

      PatternMasks.Free;

      Free;

    end;

end;

function GetVideoModeInfo: TVideoModeInfo;

var

  I : Integer;

  PDev : PDEVMODE;

  List : TList;

  function xy(val: Cardinal): Cardinal;

  var I: Integer;

  begin

    If val = 32 then val:= 24;

    Result:= 2;

    for i:= val downto 2 do Result:= Result * 2;

  end;

  function GetDev(Index: Integer) : PDEVMODE;

  var Dev : TDEVMODE;

  begin

    Result := nil;

    If EnumDisplaySettings(nil, Index, Dev) then

      Result := @Dev;

  end;

begin

  I := 0;

  List := TList.Create;

  PDev := GetDev(I);

  while PDEV <> nil do

  begin

    List.Add(PDev);

    PDev := GetDev(I);

  end;

  SetLength(Result, List.Count);

  for I := 0 to List.Count do

  begin

    PDev := PDevMode(List.Items[I]);

    Result[I].Width  := PDev.dmPelsWidth;

    Result[I].Height := PDev.dmPelsHeight;

    Result[I].Frequency := PDev.dmDisplayFrequency;

    Result[I].BitsPerPixel := PDev.dmBitsPerPel;

    Result[I].Monochrome := PDev.dmDisplayFlags and DM_GRAYSCALE = DM_GRAYSCALE;

    Result[I].Interlaced := PDev.dmDisplayFlags and DM_INTERLACED = DM_INTERLACED;

    Result[I].Colors:= xy(Result[I].BitsPerPixel);

  end;

end;

procedure FillNetRec(var Item: TNetRec);

  function GetValue( R: TRegistry; aKey: string): string;

  var

    Len, I: Integer;

    DataType: Integer;

  begin

    Len:= R.GetDataSize( aKey);

    If len > 0 then

    begin

      SetString(Result, nil, Len);

      DataType := REG_NONE;

      RegQueryValueEx(R.CurrentKey, PChar(aKey), nil, @DataType, PByte(Result), @Len);

    end;

  end;

  function ValueHere( R: TRegistry; aKey, aValue: string): Boolean;

  var

    Len, I: Integer;

    DataType: Integer;

    S: string;

  begin

    result:=false;

    Len:= R.GetDataSize( aKey);

    If len > 0 then

    begin

      SetString(S, nil, Len);

      DataType := REG_NONE;

      RegQueryValueEx(R.CurrentKey, PChar(aKey), nil, @DataType, PByte(S), @Len);

      for I:= 1 to Len - 2 do

        If S[i] = #0 then S[i]:= ' ';

      Result:= Pos( aValue, S) > 0;

    end;

  end;

var

  Reg : TRegistry;

begin

  Reg := TRegistry.Create;

  with Reg do

    try

      RootKey:= HKEY_LOCAL_MACHINE;

      OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\' + Item.ServiceName + '\Parameters');

      If KeyExists('TCPIP') then

      begin

        Item.Treatises := Item.Treatises+[TCPIP];

        OpenKeyReadOnly('TCPIP');

        Item.IPSubnetMask := GetValue( Reg, 'SubnetMask');

        Item.IPAddress:= GetValue( Reg, 'IPAddress');

        Item.DefaultGateway:= GetValue( Reg, 'DefaultGateway');

        CloseKey;

      end;

      CloseKey;

      OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\Nbf\Linkage');

      If ValueHere(Reg, 'Bind', Item.ServiceName) Then

        Item.Treatises := Item.Treatises+[NetBEUI];

      CloseKey;

      OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\NwlnkIpx\Linkage');

      CloseKey;

      If ValueHere(Reg, 'Bind', Item.ServiceName) Then

      begin

        Item.Treatises := Item.Treatises+[IPX];

        OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\NwlnkIpx\Parameters\Adapters\' + Item.ServiceName);

        Item.NetworkNumber:= GetValue(Reg, 'NetworkNumber');

        CloseKey;

      end;

    finally

      Free;

    end;

end;

function GetNetworkInfo: TNetworkInfo;

var

  Buffer: array[0..255] of Char;

  Len: DWORD;

  S: TStringList;

  hEnum: THandle;

  Count: DWORD;

  NR: TNETRESOURCE;

  I : Integer;

begin

  Len:= SizeOf(Buffer);

  WNetGetUser( nil, Buffer, Len);

  Result.UserName := Buffer;

  Result.ConnectedResources := TStringList.Create;

  Result.SharedResources := TStringList.Create;

  If WNetOpenEnum( RESOURCE_CONNECTED, RESOURCETYPE_ANY, 0, nil, hEnum) = NO_ERROR then

  begin

    Count:= 1;

    Len:= SizeOf(NR);

    while WNetEnumResource(hEnum, Count, @NR, Len) = NO_ERROR do

      Result.ConnectedResources.Add( NR.lpRemoteName);

    WNetCloseEnum(hEnum);

  end;

  If WNetOpenEnum( RESOURCE_CONTEXT, RESOURCETYPE_ANY, 0, nil, hEnum) = NO_ERROR then

  begin

    Count:= 1;

    Len:= SizeOf(NR);

    while WNetEnumResource(hEnum, Count, @NR, Len) = NO_ERROR do

      Result.SharedResources.Add( NR.lpRemoteName);

    WNetCloseEnum(hEnum);

  end;

  S := TStringList.Create;

  with TRegistry.Create do

    try

      RootKey:= HKEY_LOCAL_MACHINE;

      OpenKeyReadOnly('\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName');

      Result.ComputerName := ReadString( 'ComputerName');

      CloseKey;

      OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards');

      GetKeyNames(S);

      SetLength(Result.Nets, S.Count);

      for I := 0 to S.Count - 1 do

      begin

        OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\' + S[i]);

        If not (ValueExists( 'Hidden') and (ReadInteger('Hidden') = 1)) then

        begin

          Result.Nets[I].Description := ReadString( 'Description');

          Result.Nets[I].ServiceName := ReadString( 'ServiceName');

          FillNetRec(Result.Nets[I]);

        end;

        CloseKey;

      end;

      CloseKey;

    finally

      S.Free;

      Free;

    end;

end;

var

  FontEnuming : Boolean;

const

  NTMNONNEGATIVEAC=16;

  NTMPSOPENTYPE=17;

  NTMTTOPENTYPE=18;

  NTMMULTIPLEMASTER=19;

  NTMTYPE1=20;

  NTMDSIG=21;

function EnumFontFamExProc(

  var lpelfe: TENUMLOGFONTEX;           // logical-font data

  var lpntme: TNEWTEXTMETRICEXA;        // physical-font data

  dwFontType: DWORD;                    // type of font

  lParam: Longint                       // application-defined data

  ): LongInt; stdcall;

var

  info : ^TFontInfo;

begin

  Result:= 1;

  Info := pointer(lparam);

  SetLength(Info^, Length(info^)+1);

  With Info^[Length(info^)-1] Do

  Begin

    FontType:= [];

    If dwFontType and DEVICE_FONTTYPE <> 0 then

      FontType := FontType + [ftDEVICE];

    If dwFontType and RASTER_FONTTYPE <> 0 then

      FontType:= FontType + [ftRASTER];

    If dwFontType and TRUETYPE_FONTTYPE <> 0 then

      FontType:= FontType + [ftTRUETYPE];

    FullName:= lpelfe.elfFullName;

    Style:= lpelfe.elfStyle;

    Script:= lpelfe.elfScript;

    LogHeight:= lpelfe.elfLogFont.lfHeight;

    LogWidth:= lpelfe.elfLogFont.lfWidth;

    LogEscapement:= lpelfe.elfLogFont.lfEscapement;

    LogOrientation:= lpelfe.elfLogFont.lfOrientation;

    LogWeight:= lpelfe.elfLogFont.lfWeight;

    LogItalic:= LongBool(lpelfe.elfLogFont.lfItalic);

    LogUnderline:= LongBool(lpelfe.elfLogFont.lfUnderline);

    LogStikeOut:= LongBool(lpelfe.elfLogFont.lfStrikeOut);

    LogCharSet:= lpelfe.elfLogFont.lfCharSet;

    LogOutPrecision:= lpelfe.elfLogFont.lfOutPrecision;

    LogClipPrecision:= lpelfe.elfLogFont.lfClipPrecision;

    LogQuality:= lpelfe.elfLogFont.lfQuality;

    LogPitch:= TFontPitch(lpelfe.elfLogFont.lfPitchAndFamily and 3);

    If lpelfe.elfLogFont.lfPitchAndFamily and 3 = FIXED_PITCH then

       LogPitch:= fpFixed

    ELSE IF lpelfe.elfLogFont.lfPitchAndFamily and 3 = VARIABLE_PITCH then

       LogPitch:= fpVariable

    ELSE IF lpelfe.elfLogFont.lfPitchAndFamily and 3 = DEFAULT_PITCH then

       LogPitch:= fpDefault;

    LogFaceName:= lpelfe.elfLogFont.lfFaceName;

    tmHeight:= lpntme.ntmTm.tmHeight;

    tmAscent:= lpntme.ntmTm.tmAscent;

    tmDescent:= lpntme.ntmTm.tmDescent;

    tmInternalLeading:= lpntme.ntmTm.tmInternalLeading;

    tmExternalLeading:= lpntme.ntmTm.tmExternalLeading;

    tmAveCharWidth:= lpntme.ntmTm.tmAveCharWidth;

    tmMaxCharWidth:= lpntme.ntmTm.tmMaxCharWidth;

    tmWeight:= lpntme.ntmTm.tmWeight;

    tmWeight:= lpntme.ntmTm.tmOverhang;

    tmDigitizedAspectX:= lpntme.ntmTm.tmDigitizedAspectX;

    tmDigitizedAspectY:= lpntme.ntmTm.tmDigitizedAspectY;

    tmFirstChar:= lpntme.ntmTm.tmFirstChar;

    tmLastChar:= lpntme.ntmTm.tmLastChar;

    tmDefaultChar:= lpntme.ntmTm.tmDefaultChar;

    tmBreakChar:= lpntme.ntmTm.tmBreakChar;

    tmItalic:= LongBool(lpntme.ntmTm.tmItalic);

    tmUnderline:= LongBool(lpntme.ntmTm.tmUnderlined);

    tmStikeOut:= LongBool(lpntme.ntmTm.tmStruckOut);

    If lpntme.ntmTm.tmPitchAndFamily and 3 = FIXED_PITCH then

       tmPitch := fpFixed

    else if lpntme.ntmTm.tmPitchAndFamily and 3 = VARIABLE_PITCH then

       tmPitch:= fpVariable

    else if lpntme.ntmTm.tmPitchAndFamily and 3 = DEFAULT_PITCH then

       tmPitch:= fpDefault;

    tmCharSet:= lpntme.ntmTm.tmCharSet;

    tmFlags:= [];

    IF lpntme.ntmTm.ntmFlags and NTM_ITALIC <> 0 then

       tmFlags:= tmFlags + [TM_ITALIC];

    If lpntme.ntmTm.ntmFlags and NTM_BOLD <> 0 then

       tmFlags:= tmFlags + [TM_BOLD];

    If lpntme.ntmTm.ntmFlags and NTM_REGULAR <> 0 then

       tmFlags:= tmFlags + [TM_REGULAR];

    If lpntme.ntmTm.ntmFlags and NTMNONNEGATIVEAC <> 0 then

       tmFlags:= tmFlags + [TM_NONNEGATIVE_AC];

    If lpntme.ntmTm.ntmFlags and NTMPSOPENTYPE <> 0 then

       tmFlags:= tmFlags + [TM_PS_OPENTYPE];

    If lpntme.ntmTm.ntmFlags and NTMMULTIPLEMASTER <> 0 then

       tmFlags:= tmFlags + [TM_MULTIPLEMASTER];

    If lpntme.ntmTm.ntmFlags and NTMTYPE1 <> 0 then

       tmFlags:= tmFlags + [TM_TYPE1];

    If lpntme.ntmTm.ntmFlags and NTMDSIG <> 0 then

       tmFlags:= tmFlags + [TM_DSIG];

    tmSizeEM:= lpntme.ntmTm.ntmSizeEM;

    tmCellHeight:= lpntme.ntmTm.ntmCellHeight;

    tmAvgWidth:= lpntme.ntmTm.ntmAvgWidth;

  end;

end;

function GetFontInfo: TFontInfo;

var

  dc : HDC;

  lf : TLogFont;

begin

  dc:= GetDC(0);

  If FontEnuming Then Exit;

  FontEnuming := True;

  Try

    lf.lfCharSet:= DEFAULT_CHARSET;

    lf.lfFaceName:= #0;

    EnumFontFamiliesEx(dc, lf, @EnumFontFamExProc, LongInt(@Result), 0);

  finally

    ReleaseDC(0, dc);

    FontEnuming := False;

  end;

end;


function GetLocaleInfoEx(Flag: Integer): string;

var

  pcLCA: Array[0..20] of Char;

begin

  if (Windows.GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 ) then

    pcLCA[0] := #0;

  Result := pcLCA;

end;

function GetLocaleInfo: TLocaleInfo;

const

  CM : Array [0..1] of String = ('米制', '英制');

  DF : Array [0..2] of String = ('月日年', '日月年',  '年月日');

  TM : Array [0..1] of String = ('12', '24');

begin

  with Result Do

  begin

    LanguageCode := GetLocaleInfoEx(LOCALE_ILANGUAGE);

    LanguageName := GetLocaleInfoEx(LOCALE_SLANGUAGE);

    LanguageEngName := GetLocaleInfoEx(LOCALE_SENGLANGUAGE);

    LanguageShortName := GetLocaleInfoEx(LOCALE_SABBREVLANGNAME);



    CountryCode := GetLocaleInfoEx(LOCALE_ICOUNTRY);

    CountryName := GetLocaleInfoEx(LOCALE_SCOUNTRY);

    CountryEngName := GetLocaleInfoEx(LOCALE_SENGCOUNTRY);

    CountryShortName := GetLocaleInfoEx(LOCALE_SABBREVCTRYNAME);


    DefaultLanguage := GetLocaleInfoEx(LOCALE_IDEFAULTLANGUAGE);

    DefaultCountryCode := GetLocaleInfoEx(LOCALE_IDEFAULTCOUNTRY);

    DefaultOemCodePage := GetLocaleInfoEx(LOCALE_IDEFAULTCODEPAGE);

    DefaultAnsiCodePage := GetLocaleInfoEx(LOCALE_IDEFAULTANSICODEPAGE);

    DefaultMacCodePage := GetLocaleInfoEx(LOCALE_IDEFAULTMACCODEPAGE);



    ListSeparator :=  GetLocaleInfoEx(LOCALE_SLIST);

    Measurement := CM[StrToint(GetLocaleInfoEx(LOCALE_IMEASURE))];


    DecimalSeparator := GetLocaleInfoEx(LOCALE_SDECIMAL);

    ThousandSeparator := GetLocaleInfoEx(LOCALE_STHOUSAND);

    Grouping := GetLocaleInfoEx(LOCALE_SGROUPING);

    Digits := GetLocaleInfoEx(LOCALE_IDIGITS);


    CurrencySymbol := GetLocaleInfoEx(LOCALE_SCURRENCY);

    IntCurrencySymbol := GetLocaleInfoEx(LOCALE_SINTLSYMBOL);

    CurrencyDecimalSeparator := GetLocaleInfoEx(LOCALE_SMONDECIMALSEP);

    CurrencyThousandSeparator := GetLocaleInfoEx(LOCALE_SMONTHOUSANDSEP);

    CurrencyGrouping := GetLocaleInfoEx(LOCALE_SMONGROUPING);

    CurrencyDigits := GetLocaleInfoEx(LOCALE_ICURRDIGITS);

    PositiveCurrencyFormat := GetLocaleInfoEx(LOCALE_ICURRENCY);


    DateSeparator := GetLocaleInfoEx(LOCALE_SDATE);

    TimeSeparator := GetLocaleInfoEx(LOCALE_STIME);

    ShortDateFormat := GetLocaleInfoEx(LOCALE_SSHORTDATE);

    LongDateFormat := GetLocaleInfoEx(LOCALE_SLONGDATE);

    TimeFormat := GetLocaleInfoEx(LOCALE_STIMEFORMAT);

    ShortDateOrder := DF[StrToInt(GetLocaleInfoEx(LOCALE_IDATE))];

    LongDateOrder  := DF[StrToInt(GetLocaleInfoEx(LOCALE_ILDATE))];

    ClockMode := TM[StrToInt(GetLocaleInfoEx(LOCALE_ITIME))];

    YearDigits := GetLocaleInfoEx(LOCALE_ICENTURY);

    MorningSymbol := GetLocaleInfoEx(LOCALE_S1159);

    AfternoonSymbol := GetLocaleInfoEx(LOCALE_S2359);

    CalendarType := GetLocaleInfoEx(LOCALE_ICALENDARTYPE);

    FirstDayOfWeek := GetLocaleInfoEx(LOCALE_IFIRSTDAYOFWEEK );

    FirstWeekOfYear := GetLocaleInfoEx(LOCALE_IFIRSTWEEKOFYEAR);

    ISOLangShortName := GetLocaleInfoEx(LOCALE_SISO639LANGNAME);

    ISOCtryShortName := GetLocaleInfoEx(LOCALE_SISO3166CTRYNAME);

  end;

end;

function GetModemInfo: TModemInfo;

const

  mdmSubKey = '\SYSTEM\CurrentControlSet\Control\Class\{4D36E96D-E325-11CE-BFC1-08002BE10318}';

var

  S: TStrings;

  I: LongInt;

begin

  S:= TStringList.Create;

  With TRegistry.Create Do

    Try

      RootKey:= HKEY_LOCAL_MACHINE;

      OpenKeyReadOnly(mdmSubKey);

      GetKeyNames(S);

      SetLength(Result, S.Count);

      For I := 0 to S.Count - 1 do

      begin

        OpenKeyReadOnly(mdmSubKey + '\' + S[I]);

        Result[I].SubKeyName := S[I];

        Result[I].Name := ReadString('FriendlyName');

        Result[I].AttachedTo := ReadString('AttachedTo');

        Result[I].UserInit := ReadString('UserInit');

        If ValueExists('MaximumPortSpeed') then

           Result[I].PortSpeed := ReadInteger('MaximumPortSpeed');

      end;

      CloseKey;

    finally

      S.Free;

      Free;

    end;

end;

function GetUSBControlInfo : TUSBControlInfo;

const

  Key = '\SYSTEM\CurrentControlSet\Control\Class\{36FC9E60-C465-11CF-8056-444553540000}';

var

  S : TStrings;

  I: LongInt;

begin

  S:= TStringList.Create;

  With TRegistry.Create Do

    Try

      RootKey:= HKEY_LOCAL_MACHINE;

      OpenKeyReadOnly(Key);

      GetKeyNames(S);

      SetLength(Result, S.Count);

      For I := 0 to S.Count - 1 do

      begin

        OpenKeyReadOnly(Key + '\' + S[I]);

        Result[I].DriverName := ReadString('DriverDesc');

        Result[I].DriverVersion := ReadString('DriverVersion');

        Result[I].ProviderName := ReadString('ProviderName');

        Result[I].DriverDate := ReadString('DriverDate');

      end;

      CloseKey;

    finally

      S.Free;

      Free;

    end;

end;

Initialization

  IF Win32Platform = VER_PLATFORM_WIN32_NT then

  begin

    NtQuerySystemInformation:= GetProcAddress(

      GetModuleHandle('ntdll'), 'NtQuerySystemInformation');

  end;

  Fillchar(aBulkdata, sizeof(aBulkData),0);

end.
