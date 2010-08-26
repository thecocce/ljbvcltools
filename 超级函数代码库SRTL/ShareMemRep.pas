(*
  ShareMemRep Version: 1.51
  =========================
   - Aimingoo (aim@263.net)
   - 2003.10.09
   - Free and OpenSource
*)

unit ShareMemRep;

interface

uses
  Windows;

{ define for D4-D5 only }
type
  TDLLProc = procedure (Reason: Integer);
  TDLLProcEx = procedure (Reason: Integer; Reserved: Integer);
  HModule = DWORD;

{ Same define in ShareMem.pas for Delphi }
var
  GetHeapStatus: function: THeapStatus;
  GetAllocMemCount: function: Integer;
  GetAllocMemSize: function: Integer;

{ Same define in SysInit.pas for Delphi }
var
  DllProc: TDLLProc;
  DllProcEx: TDLLProcEx absolute DllProc;

var
  IsStaticLib : Boolean;

function GetMemMgrModule : HModule;

implementation

const
  Info_ShareMemRep = 'ShareMemRep 1.51';

  Err_ReplaceFailed = 'Shared Memory Replace failed!'#$0D#$0A#$0D#$0A +
                      '  - in dynamic Dll, don''t install Third MemMgr!'#$0D#$0A +
                      '  - Host App must uses ShareMemRep.pas!'#$0D#$0A +
                      '  - ShareMemRep.pas nust is first of uses list!';

  Err_ThirdMemMgr   = 'Find third MemMgr in Mutil module!'#$0D#$0A#$0D#$0A +
                      ' - pls add third MemMgr into Host or a dll.'#$0D#$0A +
                      ' - don''t alloc memory before this module.';

  Err_MemMgrInvalid = 'MemMgr Invalid!'#$0D#$0A#$0D#$0A +
                      '  - Have LoadLibrary(), but none FreeLibrary()!'#$0D#$0A +
                      '  - Have some memory leak!';

type
  PSharedModule = ^TSharedModule;
  TSharedModule = Record
    Next           : PSharedModule;
    MemMgrModule   : HModule;
    SetThirdMemMgr : procedure(hMod: HModule);
    case byte of
      0 : (StaticModules : DWORD); // Can Get Static module number in Exe's InitUnits()
      1 : (Module : HModule);
  end;

const
  CHostInitialized = $80000000;
  CInvalidModuleID = $FFFFFFFF;

var
  SharedModules : TSharedModule;
  ThirdMemMgrUsed : Boolean;
  OldMemMgr : TMemoryManager;

  // for Lib only
  hExe: HModule;

  // for Exe only, else alwarys 0.
  StaticLibNum: DWORD;

  // value from HOST
  _IsMultiThread: ^Boolean;

{ implementation ShareMem.pas's interface }

function _GetAllocMemCount: Integer;
begin
  Result := System.AllocMemCount;
end;

function _GetAllocMemSize: Integer;
begin
  Result := System.AllocMemSize;
end;

{ Replace SysInit.DllProc, Support MultiThread in Dll Module }

procedure _DllProc(Reason: Integer);
begin
  // if Current Module call BeginThread(), then System.IsMultiThread = True;
  if (Reason = DLL_THREAD_ATTACH) or    // New Thread Created
     (Reason = DLL_PROCESS_ATTACH) then // Create Thread or Set IsMultiThread in Units's initialization
    _IsMultiThread^ := _IsMultiThread^ or System.IsMultiThread;

  // Call ShareMemRep.DllProc
  if assigned(DllProc) then
    DllProc(Reason);
end;

{ Shared Modules List Mangement }

function IsLoadedHostModule(hMod: HModule) : Boolean;
begin
  Result := hMod and CHostInitialized <> 0;
end;

function GetMemMgrModule : HModule;
begin
  Result := SharedModules.MemMgrModule;
end;

function HostInitialized(hExe: HModule) : Boolean;
var
  pModuleList : PSharedModule;
begin
  pModuleList := GetProcAddress(hExe, 'SharedModuleList');
  Result := pModuleList^.Module and CHostInitialized <> 0;
end;

function GetStaticLibNum(hExe: HModule) : Integer;
var
  pModuleList : PSharedModule;
begin
  pModuleList := GetProcAddress(hExe, 'SharedModuleList');
  if IsLoadedHostModule(pModuleList^.Module) then
    Result := (pModuleList^.Module xor CHostInitialized) xor hExe
  else
    Result := pModuleList^.StaticModules;
end;

// Search First Static Module (or .exe) Handle
function GetFirstModule : HMODULE;
var
  pModuleList : PSharedModule;
begin
  pModuleList := @SharedModules;
  while pModuleList^.Next <> nil do
    pModuleList := pModuleList^.Next;
  Result := pModuleList^.Module;

  // if first module is host, then StaticLibNum = 0, and loaded
  if IsLoadedHostModule(Result) then
    Result := Result xor CHostInitialized;
end;

// Register self to HOST's SharedModules
// if Library is Static, return true
function RegisterLibraryToHost(hExe: HModule) : Boolean;
var
  pModuleList : PSharedModule;
begin
  pModuleList := GetProcAddress(hExe, 'SharedModuleList');
  Result := not HostInitialized(hExe);
  if Result then
    inc(pModuleList^.StaticModules);
  SharedModules.Next := pModuleList^.Next;
  pModuleList^.Next := @SharedModules;
end;

// Remove dynamic Module from HOST's SharedModules
procedure UnRegisterLibraryFromHost(hExe: HModule);
var
  pModuleList : PSharedModule;
begin
  pModuleList := GetProcAddress(hExe, 'SharedModuleList');
  while pModuleList^.Next <> nil do
    if pModuleList^.Next^.Module <> HInstance then
      pModuleList := pModuleList^.Next
    else
    begin
      pModuleList^.Next := pModuleList^.Next^.Next;
      Break;
    end;
end;

{ MemMgr Install/UnInstall }
function NullMemMgrFun: Pointer;
begin
  {$IFOPT D+}
  MessageBox(0, Err_MemMgrInvalid, Info_ShareMemRep, 0);
  {$ENDIF}
  TerminateProcess(GetCurrentProcess, 0);
  Result := nil;
end;

procedure SetMemMgrModule(hMod: HModule);
var
  NewMemMgr : TMemoryManager;
  GetMemMgr : procedure (var MemMgr: TMemoryManager);
begin
  if hMod = CInvalidModuleID then
  begin
    NewMemMgr.GetMem := @NullMemMgrFun;
    NewMemMgr.FreeMem := @NullMemMgrFun;
    NewMemMgr.ReallocMem := @NullMemMgrFun;

    GetHeapStatus := System.GetHeapStatus;
    GetAllocMemCount := _GetAllocMemCount;
    GetAllocMemSize := _GetAllocMemSize;
    _IsMultiThread := @System.IsMultiThread;
  end
  else
  begin
    GetMemMgr := GetProcAddress(hMod, 'GetMemoryManager');
    GetMemMgr(NewMemMgr);

    GetHeapStatus := GetProcAddress(hMod, 'GetHeapStatus');
    GetAllocMemCount := GetProcAddress(hMod, 'GetAllocMemCount');
    GetAllocMemSize := GetProcAddress(hMod, 'GetAllocMemSize');
    _IsMultiThread := GetProcAddress(hMod, 'IsMultiThread')
  end;

  SharedModules.MemMgrModule := hMod;
  SetMemoryManager(NewMemMgr);
end;

procedure InheritPrevMemMgr;
begin
  SetMemMgrModule(SharedModules.Next^.MemMgrModule);
end;

{ Third MemMgr Support }

procedure ResetMemMgrTo(hMod: HModule);
var
  pModuleList : PSharedModule;
begin
  pModuleList := SharedModules.Next;
  while pModuleList <> nil do
  begin
    pModuleList^.SetThirdMemMgr(hMod);
    pModuleList := pModuleList^.Next;
  end;
end;

 { Test Global's MemMgr in Here }
function ExistThirdMemMgr : Boolean;
var
  MemMgr : TMemoryManager;
begin
  GetMemoryManager(MemMgr);
  Result := (@MemMgr.GetMem = @OldMemMgr.GetMem) and
            (@MemMgr.FreeMem = @OldMemMgr.FreeMem) and
            (@MemMgr.ReallocMem = @OldMemMgr.ReallocMem);
end;

function InstallThirdMemMgr : Boolean;
var
  AllocMemSize : function : Integer;
begin
  with SharedModules.Next^ do
  begin
    AllocMemSize := GetProcAddress(MemMgrModule, 'GetAllocMemSize');
    Result := (MemMgrModule = GetFirstModule) and  // none install other MemMgr
              (AllocMemSize = 0);                  // none alloc memory
  end;

  if Result then
    ResetMemMgrTo(HInstance)
  {$IFOPT D+}
  else
    MessageBox(0, Err_ThirdMemMgr, Info_ShareMemRep, 0);
  {$ENDIF}
end;

procedure SwitchToNullMemMgr;
begin
  ResetMemMgrTo(CInvalidModuleID);
end;

{ Dll Module's Init }

procedure InitMemoryManager;
var
  ExeName: array [0..255] of char;
begin
  GetModuleFileName(0, @ExeName, 255);
  hExe := GetModuleHandle(@ExeName);
  if (System.AllocMemSize<>0) or (hExe = 0) or
     (GetProcAddress(hExe, 'SharedModuleList') = nil) then // try find a export item
  begin
    MessageBox(0, Err_ReplaceFailed, Info_ShareMemRep, 0);
    TerminateProcess(GetCurrentProcess, 0);
  end;

  // Register self
  IsStaticLib := RegisterLibraryToHost(hExe);
  if not IsStaticLib then
    if SharedModules.Next = nil then  // first module is dynamic
      SetMemMgrModule(hExe)
    else
      InheritPrevMemMgr
  else
  begin
    if (SharedModules.Next <> nil) and                   // Is not first module
       not (ThirdMemMgrUsed and InstallThirdMemMgr) then // None third MemMgr or invaild
      InheritPrevMemMgr;
  end;

  // if this unit isn't first, and none alloc memory in other unit under of this,
  // dllproc can assigned by other unit.
  DllProc := SysInit.DllProc;
  SysInit.DllProc := @_DllProc;
end;

{ Exe Module's Init }

procedure InstallMemoryManager;
begin
  // Static module can init HOST's SharedModules
  if (SharedModules.Next <> nil) and
     not (ThirdMemMgrUsed and InstallThirdMemMgr) then
    InheritPrevMemMgr;

  // Set Initialized Flag
  SharedModules.Module := StaticLibNum xor HInstance or CHostInitialized;
end;

exports
  System.IsMultiThread,
  System.GetHeapStatus,                          { From system.pas or Third MemMgr Unit! }
  System.GetMemoryManager,
  SharedModules name 'SharedModuleList',
  _GetAllocMemCount name 'GetAllocMemCount',     { Number of allocated memory blocks }
  _GetAllocMemSize name 'GetAllocMemSize';       { Total size of allocated memory blocks }

initialization
  StaticLibNum := SharedModules.StaticModules;
  SharedModules.Module := HInstance;
  SharedModules.MemMgrModule := HInstance;
  SharedModules.SetThirdMemMgr := SetMemMgrModule;
  _IsMultiThread := @System.IsMultiThread;

  // set to default MemMgr
  GetHeapStatus := System.GetHeapStatus;
  GetAllocMemCount := _GetAllocMemCount;
  GetAllocMemSize := _GetAllocMemSize;

  GetMemoryManager(OldMemMgr);
  ThirdMemMgrUsed := IsMemoryManagerSet;
  if IsLibrary then
    InitMemoryManager
  else
    InstallMemoryManager;

finalization
  if IsLibrary and not IsStaticLib then              // only for dynamic module
    UnRegisterLibraryFromHost(hExe)
  else
    if (SharedModules.MemMgrModule = HInstance) and  // current module include MemMgr, but, 
       (SharedModules.Next <> nil) then              // some module no unload
    begin
      if not IsLibrary then
        if (StaticLibNum = 0) then                   // none Static module, so MemMgr in this .exe
          SwitchToNullMemMgr
        else
        begin
          if ThirdMemMgrUsed then                    // .exe include Third MemMgr 
            SwitchToNullMemMgr
        end
      else
        if ThirdMemMgrUsed then                      // the (Staticb) module include Third MemMgr 
          SwitchToNullMemMgr
    end;
  SetMemoryManager(OldMemMgr);

end.
