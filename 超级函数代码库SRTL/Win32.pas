{-------------------------------------------------------------------------------

   单元: Win32.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.12.06

   版本: 1.00

   说明: 一些最基本的函数

-------------------------------------------------------------------------------}


unit Win32;


interface


uses

  SysUtils, Windows, TypInfo, Classes, Graphics, RTLConsts;


{ CreateFileMapping 建立文件映射或页面文件 如果映射已存在 则返回句柄

    FileName 指定要映射的文件 为空时创建页面交换文件

    MappingName 映射名称

    AccessMode 访问模式 取值为1为可读写 其它值为只读

    MappingSize 映射的大小 如果是创建文件映射 size为0 则默认为文件大小

    MappingData 最后返回映射的一个内存指针

    Result 返回值是映射的句柄 }

function CreateFileMapping(FileName, MappingName: string;

  AccessMode, MappingSize : Integer;

  var MappingData : Pointer) : THandle;


{ CloseFileMapping 关闭页面映射文件 注意 关闭了后映射就不存在了

    Handle 创建页面映射时返回的句柄

    MappingData 映射的一个内存指针 }

procedure CloseFileMapping(Handle : THandle; MappingData : Pointer);


{ CreateThread 建立线程

    ThreadFunc 线程建立后的开始函数

    Parameter 传递给线程开始函数的一个值

    ThreadId 线程标识符

    Result 返回线程句柄 }

function CreateThread(ThreadFunc: TThreadFunc; Parameter: Pointer;

  var ThreadId : LongWord) : THandle;


{ ExitThread 自动获取线程结束代码并结束线程

    Thread 要结束的线程的句柄

    result 返回结束代码 }

function ExitThread(Thread : THandle) : Integer;


{ CreateProcess 建立进程

    Command 命令行

    InheritHandles 进程是否继承其父进程中的句柄

    CreationFlag 建立进程的参数 详细请参考windows 一般取值为 HIGH_PRIORITY_CLASS

    WorkDirectory 进程的初始化工作目录

    StartupInfo 进程的启动信息

    ProcessInfo 进程信息

    Result 执行是否成功 }

function CreateProcess(command : string; InheritHandles: Boolean;

  CreationFlag: Longint; WorkDirectory: string; StartupInfo: TStartupInfo;

  var ProcessInformation: TProcessInformation): Boolean;


{ ExitProcess 自动获取进程结束代码并结束进程

    Process 要结束的进程的句柄

    result 返回结束代码 }

function ExitProcess(Process : THandle) : Integer;


{ CreatePipe 建立管道

    ReadPipe 输出管道 可用API readFile 来读取内容

    WritePipe 输入管道 可用API writeFile 来写入内容

    result 是否建立成功 }

function CreatePipe(var ReadPipe, WritePipe: THandle): boolean;


{ ReadPipe 读取管道内容

    hPipe 指定要读取的管道句柄

    Buffer 返回读取的内容

    result 是否读取成功 }

function ReadPipe(hPipe: THandle; var Buffer: string): boolean;


{ WritePipe 写入管道内容

    hPipe 指定要写入的管道句柄

    Buffer 要写入的内容

    result 是否成功写入 }

function WritePipe(hPipe: THandle; Buffer : string): boolean;


{ ShowFullScreen 全屏幕或正常显示窗口

    Handle 要显示的窗口

    FullScreen 切换全屏幕显示的状态 }

procedure ShowFullScreen(Handle : HWND; FullScreen : Boolean);


{ GetFocus 返回当前获得焦点的句柄

  这个函数是能获得其它进程的获得焦点的句柄 }

function GetFocus : HWND;


{ Delay 延时指定时间, 参数单位为毫秒 }

procedure Delay(msecs: Longint);


implementation


function CreateThread(ThreadFunc: TThreadFunc; Parameter: Pointer;

  var ThreadId : LongWord) : THandle;

begin

  result := BeginThread(nil, 0, ThreadFunc, Parameter, 0, ThreadId);

end;

function ExitThread(Thread : THandle) : Integer;

begin

  if GetExitCodeThread(Thread, DWORD(result)) then

    TerminateThread(Thread, Result);

end;

function CreateProcess(command : string; InheritHandles: Boolean;

  CreationFlag: Longint; WorkDirectory: string; StartupInfo: TStartupInfo;

  var ProcessInformation: TProcessInformation): Boolean;

begin

  result := false;

  if command <> '' then

  begin

    if WorkDirectory = '' then

      WorkDirectory := GetCurrentDir;

    Result := Windows.CreateProcess(nil, PChar(command), nil, nil,

      InheritHandles, CreationFlag, nil, PChar(WorkDirectory),

      StartupInfo, ProcessInformation);

  end;

end;

function ExitProcess(Process : THandle) : Integer;

begin

  if GetExitCodeProcess(Process, DWORD(Result)) then

    Windows.ExitProcess(Result);

end;

function CreatePipe(var ReadPipe, WritePipe: THandle): boolean;

var

  SA : SECURITY_ATTRIBUTES;

begin

  SA.nLength := sizeof(SECURITY_ATTRIBUTES);

  SA.lpSecurityDescriptor := nil;

  SA.bInheritHandle := True;

  result := Windows.CreatePipe(ReadPipe, WritePipe, @SA, 0);

end;

function ReadPipe(hPipe: THandle; var Buffer: string): boolean;

var

  cchSize : DWORD;

  cchBuffer : PChar;

begin

  result := false;

  cchSize := GetFileSize(hPipe, nil);

  cchBuffer := AllocMem(cchSize + 1);

  try

    if cchSize > 0 then

    begin

      if ReadFile(hPipe, cchBuffer^, cchSize, cchSize, nil) then

      begin

         cchBuffer[cchSize] := chr(0);

         Buffer := StrPas(cchBuffer);

         Result := true;

       end

     end

  finally

    FreeMem(cchBuffer);

  end;

end;

function WritePipe(hPipe: THandle; Buffer : string): boolean;

var

  cchSize : DWORD;

begin

  result := false;

  cchSize := Length(Buffer);

  if cchSize > 0 then

    if WriteFile(hPipe, PChar(Buffer)^, cchSize, cchSize, nil) then

       Result := cchSize = Length(Buffer);

end;

type

  PFormRec = ^TFormRec;

  TFormRec = record

    Handle : Integer;

    ShowMode : integer;

    Style : Integer;

    Rect : TRect;

  end;

var

  FullScreenForms : TList;

procedure ShowFullScreen(Handle : HWND; FullScreen : Boolean);

var

  FormRec : PFormRec;

  Index : integer;

  function FindForm(NotToAdd: Boolean): Boolean;

  begin

    result := False;

    index := 0;

    while index < FullScreenForms.Count do

    begin

      if PFormRec(FullScreenForms.Items[index]).Handle = Handle then

      begin

        FormRec := PFormRec(FullScreenForms.Items[index]);

        result := True;

        Exit;

      end;

    end;

    if NotToAdd then

    begin

      new(FormRec);

      FormRec.Handle := Handle;

      if IsZoomed(Handle) then

        FormRec.ShowMode := SW_SHOWMAXIMIZED

      else if IsIconic(Handle) then

        FormRec.ShowMode := SW_SHOWMINIMIZED

      else

        FormRec.ShowMode := SW_SHOWNORMAL;

      FormRec.Style := GetWindowLong(Handle, GWL_STYLE);

      GetWindowRect(Handle, FormRec.Rect);

      FullScreenForms.Add(FormRec);

    end;

  end;

var

  dRect : TRect;

begin

  if FullScreen then

  begin

    FindForm(True);

    SetWindowLong(Handle, GWL_STYLE, (FormRec.Style and not (WS_CAPTION or WS_SYSMENU or WS_SIZEBOX)));

    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOACTIVATE or

      SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);

    ShowWindow(Handle, SW_SHOWMAXIMIZED);

    if GetWindowRect(GetDesktopWindow, dRect) then

      with dRect do

        SetWindowPos(Handle, HWND_TOP, Left-2, Top-2, Right - Left + 4, Bottom - Top + 4,

          SWP_FRAMECHANGED);

  end

  else begin

    if FindForm(False) then

    begin

      with FormRec^, FormRec.Rect do

      begin

        SetWindowLong(Handle, GWL_STYLE, Style);

        ShowWindow(Handle, ShowMode);

        SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, Bottom - Top, SWP_FRAMECHANGED);

      end;

      FullScreenForms.Delete(Index);

      FreeMem(FormRec);

    end;

  end;

end;


function GetFocus : HWND;

var

  Thread  : DWORD;

  Thread2 : DWORD;

Begin

  Result  := GetForegroundwindow;

  Thread  := GetWindowThreadProcessid(Result, Nil);

  Thread2 :=  GetCurrentThreadId;

  if Thread = Thread2 then

    Result := GetFocus

  else begin

    AttachThreadInput(Thread2, Thread, True);

    Result := Windows.GetFocus;

    AttachThreadInput(Thread2, Thread, False);

  end;

end;

procedure Delay(msecs: Longint);

var

  targettime: Longint;

  Msg: TMsg;

begin

  targettime := GetTickCount + msecs;

  while targettime < GetTickCount do

    If PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then

    begin

      TranslateMessage(Msg);

      DispatchMessage(Msg);

    end;

end;


function CreateFileMapping(FileName, MappingName: string;

  AccessMode, MappingSize : Integer;

  var MappingData : Pointer) : THandle;

var

  m1, m2, m3: cardinal;

  FileMappingHandle : THandle;

  FileHandle : THandle;

begin

  Result := INVALID_HANDLE_VALUE;


  case AccessMode of

    1 :

    begin

      m1:= GENERIC_READ + GENERIC_WRITE;

      m2:= PAGE_READWRITE;

      m3:= FILE_MAP_WRITE;

    end;

    else begin

      m1:= GENERIC_READ;

      m2:= PAGE_READONLY;

      m3:= FILE_MAP_READ;

    end;

  end;


  // 先尝试去打开 如果映射不存在再去创建

  FileMappingHandle := OpenFileMapping(m2, False, LPCTSTR(MappingName));


  // 如果映射不存在 这下面的部分是创建映射

  if FileMappingHandle = 0 then

  begin

    FileHandle := $FFFFFFFF;

    if FileName <> '' then

    begin

      FileHandle := CreateFile(PCHAR(FileName), m1, FILE_SHARE_READ, nil,

        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

      IF FileHandle = INVALID_HANDLE_VALUE then

        exit;

      if MappingSize <= 0 then

        MappingSize := GetFileSize (FileHandle, nil);

    end;

    if MappingSize <= 0 then

      exit;

    FileMappingHandle := Windows.CreateFileMapping(FileHandle, nil,

      m2, 0, MappingSize, PChar(MappingName));

    IF FileMappingHandle = 0 then

      exit;

    if FileHandle <> $FFFFFFFF then

      CloseHandle(FileHandle);

  end;

  MappingData := MapViewOfFile (FileMappingHandle, m3, 0, 0, MappingSize);

  Result := FileMappingHandle;

end;

procedure CloseFileMapping(Handle : THandle; MappingData : Pointer);

begin

  CloseHandle(Handle);

  UnmapViewOfFile(MappingData);

end;

initialization

  FullScreenForms := TList.Create;

finalization

  FullScreenForms.Free;


end.
