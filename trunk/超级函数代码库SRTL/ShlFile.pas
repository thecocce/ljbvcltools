{-------------------------------------------------------------------------------

   单元: ShlFile.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.12.06 

   版本: 1.00

   说明: 提供文件操作

-------------------------------------------------------------------------------}


unit ShlFile;


interface


uses

  Messages, Classes, Windows, SysUtils,

  Dialogs, Forms, Shellapi, ImgList,

  ShlObj, ActiveX;


const

  nvF_PgmMenu = #$82;  (*开始->程序*)

  nvf_Printer = #$84; (*打印机*)

  nvF_MyDoc   = #$85;  (*我的文档*)

  nvF_BookMrk = #$86;  (*收藏夹*)

  nvF_Startup = #$87;  (*开始->启动*)

  nvF_Recent  = #$88;  (*开始->文档*)

  nvF_SendTo  = #$89;  (*发送到 ...*)

  nvf_Recycle = #$8A;  (*回收站*)

  nvF_StrMenu = #$8B;  (*开始*)

  nvF_Desktop = #$90;  (*桌面目录*)

  nvF_Drives  = #$91;  (*我的电脑*)

  nvF_NETWORK = #$92;  (*网上邻居*)

  nvF_AppData = #$9A;  (*Application Data*)

  nvF_Windows = #$A0;  (*Windows*)

  nvF_System  = #$A1;  (*Windows\System*)

  nvF_PgmFile = #$A2;  (*Program Files*)

  nvF_Temp    = #$A3;  (*Temp Directory*)


type

  TFileTimes = record

    CreationTime,

    LastWriteTime,

    LastAccessTime : TDateTime;

  end;



// GetSystemFolder 取系统文件夹

function GetSystemFolder(nvFolder: Char; ShortPath: Boolean): string;



// GetShortName 取文件的短文件名

function GetShortName(const FileName : string) : string;

// GetLongName 取文件的长文件名

function GetLongName(const FileName : string) : string;

// GetTempFileName 返回临时文件名

function GetTempFileName(Path, Prefix: string): string;

// FileOpening 检查文件是否正在被使用

function FileOpening(const FileName : string) : boolean;

// GetFileSize 返回文件的大小

function GetFileSize(const FileName : string) : Longint;

// GetFileAttr 返回文件的属性

function GetFileAttr(const Filename : string): Word;

// GetFileTime 获取文件时间

function GetFileTime(const FileName : string) : TFileTimes;

// SetFileTime 改变文件时间

function SetFileTime(const FileName : string; Time : TFileTimes) : Boolean;



// ExtractFileName 从路径中返回不带或带扩展名的文件名

function ExtractFileName(

  const Filename: string; Extension : boolean = true): string;

// ExpandPathName 展开如 nvF_Desktop+'MyFolder\MySubFolder' 的路径名

function ExpandPathName(Path: string) : string;

//路径是否存在, 如果 ForceCreate,  那么如果路径不存在则自动创建

function PathExists(const xPath: String; ForceCreate: Boolean): Boolean;


// ExtractIcon 返回指定文件的图标

function ExtractIcon(const FileName : string; Index : Integer = 1) : HICON;

// GetSystemIcons 返回系统图像列表

function GetSystemIcons(SmallIcon : Boolean = True): THandle;

// GetSystemIconIndex 返回文件图标在系统图像列表的索引

function GetSystemIconIndex(const Path: string; Attrs: DWORD): Integer;

// GetAssociatedIcon 返回指定扩展名的图标

function GetAssociatedIcon(const Extension: string; SmallIcon: Boolean): HIcon;



// CreateFileShortCut 创建快捷方式, ShortCutName可描述为nvF_xxx+'...\...\YYY',如果ShortCutName=''那么加入到 开始->文档

function CreateFileShortCut(const FileName, ShortCutName: string): Boolean;

// GetShortcutTarget 返回快捷方式所指向的目标

function GetShortcutTarget(const ShortCutFileName: string):string;



// BrowseFolderDialog 浏览文件夹对话框, 可返回短文件名

function BrowseFolderDialog(

  HWND: Integer; const Title: string; ShortPath: Boolean): string;

// OpenSpecialFolder 打开由FolderID指定的特殊文件夹

procedure OpenSpecialFolder(FolderID: Integer; Handle: HWND = 0);

// ShowFileProperties 显示文件属性

function ShowFileProperties(FileName: string; Handle: HWND):Boolean;


implementation


var

  pxBrowse: PBrowseInfoA;

  pxItemID: PItemIDList;

  BrowseDlgTitle: String;

function StrReplace(const Src: String; var Tar: String; SrcId, TarId, Count: Integer): Integer;

begin

   if SrcId <= 0 then SrcId:= 0 else Dec(SrcId);

   if Count <= 0 then Count:= Length(Src) - SrcId;

   if TarId <= 0 then

   begin

      TarId:= Length(Tar);

      SetLength(Tar, TarId + Count);

   end else Dec(TarId);

   for Result:= 1 to Count do

      Tar[TarId + Result]:= Src[SrcId + Result];

   Result:= TarId + Count;

end;

procedure InitBrowseInfo(hWND: Integer);

begin

  if pxBrowse = nil then New(pxBrowse);

  with pxBrowse^ do begin

    hWndOwner:= hWND;

    pidlRoot:= nil;

    pszDisplayName:= nil;


    lpszTitle:= PChar(BrowseDlgTitle);

    ulFlags:= BIF_RETURNONLYFSDIRS or 64;

    lpfn:= nil;

  end;

end;

function GetShortName(const FileName : string) : string;

var

  X: Integer;

begin

  SetLength(Result, MAX_PATH);

  X := GetShortPathName(PChar(FileName), PChar(Result), MAX_PATH);

  SetLength(Result, X);

end;

function GetLongName(const FileName : string) : string;

var

  aInfo: TSHFileInfo;

begin

  if SHGetFileInfo(PChar(FileName), 0, aInfo, Sizeof(aInfo),

    SHGFI_DISPLAYNAME)<>0 then

    Result:= string(aInfo.szDisplayName)

    else Result:= FileName;

end;

function GetTempFileName(Path, Prefix: string): string;

var

  x : integer;

begin

  SetLength(Result, MAX_PATH);

  if Path = '' then

  begin

    SetLength(Path, MAX_PATH);

    GetTempPath(MAX_PATH, PChar(Path));

  end;

  Windows.GetTempFileName(PChar(Path), PChar(Prefix), 0, PChar(Result));

  X := Pos(#0, Result);

  if X > 0 then

    SetLength(Result, X-1);

end;

function FileOpening(const FileName : string) : boolean;

var

  HFileRes : HFILE;

begin

  Result := false;

  if not FileExists(FileName) then exit;

  HFileRes := CreateFile(pchar(FileName), GENERIC_READ or GENERIC_WRITE,0, nil,

    OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);

  Result := (HFileRes = INVALID_HANDLE_VALUE);

  if not Result then

    CloseHandle(HFileRes);

end;

function GetFileSize(const FileName : string) : Longint;

var

  F : Integer;

begin

  Result := 0;

  F := FileOpen(FileName, FmShareDenyWrite);

  If F <> -1 then

  begin

    Result := Windows.GetFileSize(F, Nil);

    FileClose(F);

  end;

end;

function GetFileAttr(const Filename : string): Word;

begin

  Result := 0;

  If FileExists(Filename) then Result := FileGetAttr(Filename);

end;

function CovFileDate(FD: _FileTime):TDateTime;

{ 转换文件的时间格式 }

var

  Tct:_SystemTime;

  Temp:_FileTime;

begin

  FileTimeToLocalFileTime(Fd,Temp);

  FileTimeToSystemTime(Temp,Tct);

  CovFileDate:=SystemTimeToDateTime(Tct);
  
end;

function GetFileTime(const FileName : string) : TFileTimes;

const

  Model='yyyy/mm/dd,hh:mm:ss'; { 设定时间格式 }

var

  Rec : TSearchRec; { 申明Rec为一个查找记录 }

begin

  FindFirst(Filename ,faAnyFile, Rec); { 查找目标文件 }

  { 返回文件的创建时间 }

  Result.CreationTime := CovFileDate(Rec.FindData.ftCreationTime);

  { 返回文件的修改时间 }

  Result.LastWriteTime := CovFileDate(Rec.FindData.ftLastWriteTime);

  { 返回文件的当前访问时间 }

  Result.LastAccessTime := CovFileDate(Rec.FindData.ftLastAccessTime);

  FindClose(Rec);

end;

function SetFileTime(const FileName : string; Time : TFileTimes) : Boolean;

var

  D1, D2, D3 :Integer;

  F1, F2, F3:TFileTime;

  Fs:TFileStream;

begin

  Result := False;

  D1 := DateTimeToFileDate(Trunc(Time.CreationTime));

  D2 := DateTimeToFileDate(Trunc(Time.LastAccessTime));

  D3 := DateTimeToFileDate(Trunc(Time.LastWriteTime));

  try

    FS := TFileStream.Create(Filename, fmOpenReadWrite);

    try

      if DosDateTimeToFileTime(LongRec(D1).Hi, LongRec(D1).Lo, F1) and

        LocalFileTimeToFileTime(F1, F1) and

        DosDateTimeToFileTime(LongRec(D2).Hi, LongRec(D2).Lo, F2) and

        LocalFileTimeToFileTime(F2, F2) and

        DosDateTimeToFileTime(LongRec(D3).Hi, LongRec(D2).Lo, F3) and

        LocalFileTimeToFileTime(F3, F3) then

        Windows.SetFileTime(FS.Handle, @F1, @F2, @F3);{ 设置文件时间属性 }

    finally

      FS.Free;

    end;

  except

    (* !~ 可能原因: 因为目标文件正在被使用等原因而导致失败 *)

    MessageDlg('日期修改操作失败！', mtError, [mbOk], 0);

  end;

end;

function ExtractIcon(const FileName : string; Index : Integer = 1) : HICON;

var

  iNumberOfIcons: Integer;

begin

  if FileExists(FileName) then

  begin

    iNumberOfIcons := Shellapi.ExtractIcon(HinsTance, PChar(FileName),

      Cardinal(-1));

    if (Index > 0) and (Index < iNumberOfIcons) and (iNumberOfIcons > 0) then

      Result := Shellapi.ExtractIcon(hInstance, PChar(FileName), Index);

  end;

end;

function GetSystemIcons(SmallIcon : Boolean = True): THandle;

var

  SFI: TSHFileInfo;

  aflat : Word;

begin

  IF SmallIcon Then

    aflat := SHGFI_SMALLICON

    else aFlat := SHGFI_LARGEICON;

  Result := SHGetFileInfo('', 0, SFI, SizeOf(SFI),

    SHGFI_SYSICONINDEX or aFlat);

end;

function GetSystemIconIndex(const Path: string; Attrs: DWORD): Integer;

var

  SFI: TSHFileInfo;

begin

  FillChar(SFI, SizeOf(SFI), 0);

  if FileExists(Path) or DirectoryExists(Path) then

    SHGetFileInfo(PChar(Path), 0, SFI, SizeOf(TSHFileInfo),

      SHGFI_SYSICONINDEX)

  else

    SHGetFileInfo(PChar(Path), Attrs, SFI, SizeOf(TSHFileInfo),

      SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);

  Result := SFI.iIcon;

end;

function GetAssociatedIcon(const Extension: string; SmallIcon: Boolean): HIcon;

var

  Info              : TSHFileInfo;

  Flags             : Cardinal;

begin

  if SmallIcon then

    Flags := SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES

  else

    Flags := SHGFI_ICON or SHGFI_LARGEICON or SHGFI_USEFILEATTRIBUTES;

  SHGetFileInfo(PChar(Extension), FILE_ATTRIBUTE_NORMAL, Info,

    SizeOf(TSHFileInfo), Flags);

  Result := Info.hIcon;

end;

function ExtractFileName(const Filename: string;

  Extension : boolean = true): string;

var

  i : integer;

begin

  Result := SysUtils.ExtractFileName(Filename);

  if not Extension then

  begin

    for I := Length(Result) downto 1 do

      If Result[I]='.' then Break;

    if I > 1 then

      Delete(Result, I, MaxInt);

  end;

end;

function GetSystemFolder(nvFolder: Char; ShortPath: Boolean): string;

var

  X: Integer;

begin

  SetLength(Result, MAX_PATH);

  Try

    X:= Ord(nvFolder);

    if X < $A0 then

    begin

      if SHGetSpecialFolderLocation(0, (X and $7F), pxItemID) <> NOERROR then

        exit;

      if pxItemID = nil then

        exit;

      if not SHGetPathFromIDList(pxItemID, PChar(Result)) then

        exit;

      X:= Pos(#0, Result) - 1;

    end

    else case nvFolder of

      nvF_Windows : X:= GetWindowsDirectory(PChar(Result), MAX_PATH);

      nvF_System : X:= GetSystemDirectory(PChar(Result), MAX_PATH);

      nvF_PgmFile : Exit;

      nvF_Temp : X:= GetTempPath(MAX_PATH, PChar(Result));

      else exit;

    end; (*case*)

    SetLength(Result, X);

    if ShortPath then Result:= GetShortName(Result);

    if Result[Length(Result)] <> '\' then

      Result := Result + '\';

  except

    SetLength(Result, 0);

  end;

end;

function ExpandPathName(Path: string) : string;

var

  X: Integer;

begin

  if Path[1] in [nvF_Temp, nvF_PgmMenu, nvf_Printer, nvF_MyDoc,

    nvF_BookMrk, nvF_Startup, nvF_Recent, nvF_SendTo, nvf_Recycle,

    nvF_PgmFile, nvF_System, nvF_Windows, nvF_AppData, nvF_NETWORK,

    nvF_Drives, nvF_Desktop, nvF_StrMenu] then

  begin

    result := GetSystemFolder(Path[1], False);

    Delete(Path, 1, 1);

    Insert(Result, Path, 1);

  end;

end;

function CreateFileShortCut(const FileName, ShortCutName: String): Boolean;

var

  S, V : string;

  X, Y: Integer;

begin

  Result:= False;

  try

    SHAddToRecentDocs(SHARD_PATH, PChar(FileName));

    if Length(ShortCutName) <> 0 then

    begin

      Y:= 0;

      for X:= Length(FileName) downto 1 do

        if FileName[X] = '\' then

        begin

          Y:= X;

          Break;

        end;

      SetLength(S, 255);

      SHGetSpecialFolderLocation(0, CSIDL_RECENT, pxItemID);

      SHGetPathFromIDList(pxItemID, @S[1]);

      X:= Pos(#0, S);

      if S[X-1] <> '\' then

      begin

        S[X]:= '\';

        Inc(X);

      end;

      X:= StrReplace(FileName, S, Y+1, X, 0);

      X:= StrReplace('.lnk'#0, S, 0, X+1, 0);

      V := ExpandPathName(ShortCutName);

      if not PathExists(V, True) then

        Exit;

      X:= StrReplace('.lnk'#0, V, 0, Pos(#0, V), 0);

      Result:= CopyFile(@S[1], @V[1], False);

      if Result then

        DeleteFile(S);

    end;

  except

  end;

end;

function GetShortcutTarget(const ShortCutFileName: string):string;

var

  Psl:IShellLink;

  Ppf:IPersistFile;

  WideName: array [0..MAX_PATH] of WideChar;

  pResult: array [0..MAX_PATH-1] Of Char;

  Data:TWin32FindData;

const

  IID_IPersistFile: TGUID = (

  D1:$0000010B; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

begin

  CoCreateInstance(CLSID_ShellLink,nil,CLSCTX_INPROC_SERVER, IID_IShellLinkA ,psl);

  psl.QueryInterface(IID_IPersistFile,ppf);

  MultiByteToWideChar(CP_ACP, 0, pChar(ShortcutFilename), -1, WideName, Max_Path);

  ppf.Load(WideName,STGM_READ);

  psl.Resolve(0,SLR_ANY_MATCH);

  psl.GetPath( @pResult,MAX_PATH,Data,SLGP_UNCPRIORITY);

  Result:=StrPas(@pResult);

end;

function BrowseFolderDialog(HWND: Integer; const Title: string;

  ShortPath: Boolean): string;

var

  s : string;

begin

  try

    if Length(Title) <> 0 then BrowseDlgTitle:= Title;

    InitBrowseInfo(hWND);

    pxItemID:= SHBrowseForFolder(pxBrowse^);

    Dispose(pxBrowse);

    pxBrowse:= nil;

    if pxItemID = nil then Exit;

    SetLength(s, 255);

    SHGetPathFromIDList(pxItemID, @s[1]);

    if ShortPath then Result:= GetShortName(s);

    if Result[Length(Result)] <> '\' then

       Result := Result + '\';

  except

    Result := '';

  end;

end;


procedure OpenSpecialFolder(FolderID: integer; Handle: HWND = 0);

  procedure FreePidl(pidl: PItemIDList);

  var

    allocator : IMalloc;

  begin

    if Succeeded(shlobj.SHGetMalloc(allocator)) then

    begin

      allocator.Free(pidl);

      {$IFDEF VER90}

      allocator.Release;

      {$ENDIF}

    end;

  end;

var

  exInfo : TShellExecuteInfo;

begin

  // initialize all fields to 0

  FillChar(exInfo, SizeOf(exInfo), 0);

  with exInfo do

  begin

    cbSize := SizeOf(exInfo); // required!

    fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_IDLIST;

    Wnd := Handle;

    nShow := SW_SHOWNORMAL;

    lpVerb := 'open';

    ShGetSpecialFolderLocation(Handle, FolderID, PItemIDLIst(lpIDList));

  end;

  ShellExecuteEx(@exInfo);

  FreePIDL(exinfo.lpIDList);

end;

function ShowFileProperties(FileName: string; Handle: HWND):Boolean;

var

  FileInfo: TSHELLEXECUTEINFO;

begin

  with FileInfo do

  begin

    cbSize := SizeOf(FileInfo);

    lpFile := PAnsiChar(FileName);

    Wnd := Handle;

    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_INVOKEIDLIST or SEE_MASK_FLAG_NO_UI;

    lpVerb := PAnsiChar('properties');

    lpIDList := nil;

    lpDirectory := nil;

    nShow := 0;

    hInstApp := 0;

    lpParameters := nil;

    dwHotKey := 0;

    hIcon := 0;

    hkeyClass := 0;

    hProcess := 0;

    lpClass := nil;

  end;

  Result := ShellExecuteEX(@FileInfo);

end;

function PathExists(const xPath: String; ForceCreate: Boolean): Boolean;

var

   X : Integer;

   S : string;

   procedure CreatePaths;

   var

      N: Integer; ch: Char;

   begin

      for N:= 1 to Length(S) do

      begin

         ch:= S[N];

         if ch = #0 then Break;

         if ch <> '\' then Continue;

         ch:= S[N+1];

         S[N+1]:= #0;

         X:= GetFileAttributes(@S[1]);

         S[N+1]:= ch;

         if (X <> -1) and (FILE_ATTRIBUTE_DIRECTORY and X <> 0) then Continue;

         S[N]:= #0;

         CreateDirectory(@S[1], nil);

         S[N]:= '\';

      end;

   end;


begin

   S := ExpandPathName(xPath);

   X:= GetFileAttributes(@S[1]);

   Result:= (X <> -1) and (FILE_ATTRIBUTE_DIRECTORY and X <> 0);

   if Result or (not ForceCreate) then Exit;

   try

      CreatePaths;

      Result:= True;

   except

   end;

end;

initialization

   BrowseDlgTitle:= ' 搜索文件夹 ';

   pxBrowse:= nil;

finalization

   if pxBrowse <> nil then Dispose(pxBrowse);


end.










