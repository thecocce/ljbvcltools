{-------------------------------------------------------------------------------

   ��Ԫ: ShlFile.pas

   ����: Ҧ�Ƿ� - yaoqiaofeng@sohu.com

   ����: 2004.12.06 

   �汾: 1.00

   ˵��: �ṩ�ļ�����

-------------------------------------------------------------------------------}


unit ShlFile;


interface


uses

  Messages, Classes, Windows, SysUtils,

  Dialogs, Forms, Shellapi, ImgList,

  ShlObj, ActiveX;


const

  nvF_PgmMenu = #$82;  (*��ʼ->����*)

  nvf_Printer = #$84; (*��ӡ��*)

  nvF_MyDoc   = #$85;  (*�ҵ��ĵ�*)

  nvF_BookMrk = #$86;  (*�ղؼ�*)

  nvF_Startup = #$87;  (*��ʼ->����*)

  nvF_Recent  = #$88;  (*��ʼ->�ĵ�*)

  nvF_SendTo  = #$89;  (*���͵� ...*)

  nvf_Recycle = #$8A;  (*����վ*)

  nvF_StrMenu = #$8B;  (*��ʼ*)

  nvF_Desktop = #$90;  (*����Ŀ¼*)

  nvF_Drives  = #$91;  (*�ҵĵ���*)

  nvF_NETWORK = #$92;  (*�����ھ�*)

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



// GetSystemFolder ȡϵͳ�ļ���

function GetSystemFolder(nvFolder: Char; ShortPath: Boolean): string;



// GetShortName ȡ�ļ��Ķ��ļ���

function GetShortName(const FileName : string) : string;

// GetLongName ȡ�ļ��ĳ��ļ���

function GetLongName(const FileName : string) : string;

// GetTempFileName ������ʱ�ļ���

function GetTempFileName(Path, Prefix: string): string;

// FileOpening ����ļ��Ƿ����ڱ�ʹ��

function FileOpening(const FileName : string) : boolean;

// GetFileSize �����ļ��Ĵ�С

function GetFileSize(const FileName : string) : Longint;

// GetFileAttr �����ļ�������

function GetFileAttr(const Filename : string): Word;

// GetFileTime ��ȡ�ļ�ʱ��

function GetFileTime(const FileName : string) : TFileTimes;

// SetFileTime �ı��ļ�ʱ��

function SetFileTime(const FileName : string; Time : TFileTimes) : Boolean;



// ExtractFileName ��·���з��ز��������չ�����ļ���

function ExtractFileName(

  const Filename: string; Extension : boolean = true): string;

// ExpandPathName չ���� nvF_Desktop+'MyFolder\MySubFolder' ��·����

function ExpandPathName(Path: string) : string;

//·���Ƿ����, ��� ForceCreate,  ��ô���·�����������Զ�����

function PathExists(const xPath: String; ForceCreate: Boolean): Boolean;


// ExtractIcon ����ָ���ļ���ͼ��

function ExtractIcon(const FileName : string; Index : Integer = 1) : HICON;

// GetSystemIcons ����ϵͳͼ���б�

function GetSystemIcons(SmallIcon : Boolean = True): THandle;

// GetSystemIconIndex �����ļ�ͼ����ϵͳͼ���б������

function GetSystemIconIndex(const Path: string; Attrs: DWORD): Integer;

// GetAssociatedIcon ����ָ����չ����ͼ��

function GetAssociatedIcon(const Extension: string; SmallIcon: Boolean): HIcon;



// CreateFileShortCut ������ݷ�ʽ, ShortCutName������ΪnvF_xxx+'...\...\YYY',���ShortCutName=''��ô���뵽 ��ʼ->�ĵ�

function CreateFileShortCut(const FileName, ShortCutName: string): Boolean;

// GetShortcutTarget ���ؿ�ݷ�ʽ��ָ���Ŀ��

function GetShortcutTarget(const ShortCutFileName: string):string;



// BrowseFolderDialog ����ļ��жԻ���, �ɷ��ض��ļ���

function BrowseFolderDialog(

  HWND: Integer; const Title: string; ShortPath: Boolean): string;

// OpenSpecialFolder ����FolderIDָ���������ļ���

procedure OpenSpecialFolder(FolderID: Integer; Handle: HWND = 0);

// ShowFileProperties ��ʾ�ļ�����

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

{ ת���ļ���ʱ���ʽ }

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

  Model='yyyy/mm/dd,hh:mm:ss'; { �趨ʱ���ʽ }

var

  Rec : TSearchRec; { ����RecΪһ�����Ҽ�¼ }

begin

  FindFirst(Filename ,faAnyFile, Rec); { ����Ŀ���ļ� }

  { �����ļ��Ĵ���ʱ�� }

  Result.CreationTime := CovFileDate(Rec.FindData.ftCreationTime);

  { �����ļ����޸�ʱ�� }

  Result.LastWriteTime := CovFileDate(Rec.FindData.ftLastWriteTime);

  { �����ļ��ĵ�ǰ����ʱ�� }

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

        Windows.SetFileTime(FS.Handle, @F1, @F2, @F3);{ �����ļ�ʱ������ }

    finally

      FS.Free;

    end;

  except

    (* !~ ����ԭ��: ��ΪĿ���ļ����ڱ�ʹ�õ�ԭ�������ʧ�� *)

    MessageDlg('�����޸Ĳ���ʧ�ܣ�', mtError, [mbOk], 0);

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

   BrowseDlgTitle:= ' �����ļ��� ';

   pxBrowse:= nil;

finalization

   if pxBrowse <> nil then Dispose(pxBrowse);


end.










