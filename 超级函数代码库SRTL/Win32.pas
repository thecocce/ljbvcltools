{-------------------------------------------------------------------------------

   ��Ԫ: Win32.pas

   ����: Ҧ�Ƿ� - yaoqiaofeng@sohu.com

   ����: 2004.12.06

   �汾: 1.00

   ˵��: һЩ������ĺ���

-------------------------------------------------------------------------------}


unit Win32;


interface


uses

  SysUtils, Windows, TypInfo, Classes, Graphics, RTLConsts;


{ CreateFileMapping �����ļ�ӳ���ҳ���ļ� ���ӳ���Ѵ��� �򷵻ؾ��

    FileName ָ��Ҫӳ����ļ� Ϊ��ʱ����ҳ�潻���ļ�

    MappingName ӳ������

    AccessMode ����ģʽ ȡֵΪ1Ϊ�ɶ�д ����ֵΪֻ��

    MappingSize ӳ��Ĵ�С ����Ǵ����ļ�ӳ�� sizeΪ0 ��Ĭ��Ϊ�ļ���С

    MappingData ��󷵻�ӳ���һ���ڴ�ָ��

    Result ����ֵ��ӳ��ľ�� }

function CreateFileMapping(FileName, MappingName: string;

  AccessMode, MappingSize : Integer;

  var MappingData : Pointer) : THandle;


{ CloseFileMapping �ر�ҳ��ӳ���ļ� ע�� �ر��˺�ӳ��Ͳ�������

    Handle ����ҳ��ӳ��ʱ���صľ��

    MappingData ӳ���һ���ڴ�ָ�� }

procedure CloseFileMapping(Handle : THandle; MappingData : Pointer);


{ CreateThread �����߳�

    ThreadFunc �߳̽�����Ŀ�ʼ����

    Parameter ���ݸ��߳̿�ʼ������һ��ֵ

    ThreadId �̱߳�ʶ��

    Result �����߳̾�� }

function CreateThread(ThreadFunc: TThreadFunc; Parameter: Pointer;

  var ThreadId : LongWord) : THandle;


{ ExitThread �Զ���ȡ�߳̽������벢�����߳�

    Thread Ҫ�������̵߳ľ��

    result ���ؽ������� }

function ExitThread(Thread : THandle) : Integer;


{ CreateProcess ��������

    Command ������

    InheritHandles �����Ƿ�̳��丸�����еľ��

    CreationFlag �������̵Ĳ��� ��ϸ��ο�windows һ��ȡֵΪ HIGH_PRIORITY_CLASS

    WorkDirectory ���̵ĳ�ʼ������Ŀ¼

    StartupInfo ���̵�������Ϣ

    ProcessInfo ������Ϣ

    Result ִ���Ƿ�ɹ� }

function CreateProcess(command : string; InheritHandles: Boolean;

  CreationFlag: Longint; WorkDirectory: string; StartupInfo: TStartupInfo;

  var ProcessInformation: TProcessInformation): Boolean;


{ ExitProcess �Զ���ȡ���̽������벢��������

    Process Ҫ�����Ľ��̵ľ��

    result ���ؽ������� }

function ExitProcess(Process : THandle) : Integer;


{ CreatePipe �����ܵ�

    ReadPipe ����ܵ� ����API readFile ����ȡ����

    WritePipe ����ܵ� ����API writeFile ��д������

    result �Ƿ����ɹ� }

function CreatePipe(var ReadPipe, WritePipe: THandle): boolean;


{ ReadPipe ��ȡ�ܵ�����

    hPipe ָ��Ҫ��ȡ�Ĺܵ����

    Buffer ���ض�ȡ������

    result �Ƿ��ȡ�ɹ� }

function ReadPipe(hPipe: THandle; var Buffer: string): boolean;


{ WritePipe д��ܵ�����

    hPipe ָ��Ҫд��Ĺܵ����

    Buffer Ҫд�������

    result �Ƿ�ɹ�д�� }

function WritePipe(hPipe: THandle; Buffer : string): boolean;


{ ShowFullScreen ȫ��Ļ��������ʾ����

    Handle Ҫ��ʾ�Ĵ���

    FullScreen �л�ȫ��Ļ��ʾ��״̬ }

procedure ShowFullScreen(Handle : HWND; FullScreen : Boolean);


{ GetFocus ���ص�ǰ��ý���ľ��

  ����������ܻ���������̵Ļ�ý���ľ�� }

function GetFocus : HWND;


{ Delay ��ʱָ��ʱ��, ������λΪ���� }

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


  // �ȳ���ȥ�� ���ӳ�䲻������ȥ����

  FileMappingHandle := OpenFileMapping(m2, False, LPCTSTR(MappingName));


  // ���ӳ�䲻���� ������Ĳ����Ǵ���ӳ��

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
