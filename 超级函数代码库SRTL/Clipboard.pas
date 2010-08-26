{-------------------------------------------------------------------------------

   单元: Clipboards.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.11.27

   版本: 1.00

   说明: 剪贴板增强类，可支持保存和载入剪贴板，支持多重剪贴板

-------------------------------------------------------------------------------}

unit Clipboard;


interface


uses

  SysUtils, windows, messages, Clipbrd, Classes;


type

  TBaseClipboard = class(TClipboard)

  private

    FNextClipHwnd : HWND;

    FClipHwnd : HWND;

    FViewClipboard: Boolean;

    FOnClipboardChanged: TNotifyEvent;

    procedure ClipBoardViewerProc(var Msg:TMessage);

    procedure SetViewClipboard(const Value: Boolean);

  public

    procedure AfterConstruction; override;

    procedure BeforeDestruction; override;

    property ViewClipboard : Boolean read FViewClipboard write SetViewClipboard;

    property OnClipboardChanged : TNotifyEvent read fOnClipboardChanged write FOnClipboardChanged;

  end;


  PClippedData = ^TClippedData;

  TClippedData = record

    Format : Word;

    Buffer  : Pointer;

    Size : Cardinal;

  end;


  TManyClipboard = Class(TBaseClipboard)

  private

    FList : TList;

    FIndex : Integer;

    function GetCount: Integer;

    procedure SetIndex(const Value: Integer);

    procedure SetCount(const Value: Integer);

  protected

    Procedure SaveDatas(List : TList);

    Procedure LoadDatas(List : TList);

    function GetData(Format : Cardinal; var Buffer : Pointer): Cardinal;

    function SetData(Format : Cardinal; Buffer : Pointer; Size: Cardinal): Boolean;

  public

    procedure AfterConstruction; override;

    procedure BeforeDestruction; override;

    function  Add : Integer; virtual;

    procedure Delete(Index : Integer); virtual;

    procedure Clear; override;

    property Index : Integer Read FIndex   Write SetIndex;

    property Count : Integer Read GetCount write SetCount;

  end;


var

  ManyClipboard : TManyClipboard;


implementation

{ TManyClipboard }

function TManyClipboard.Add: Integer;

var

  AList : TList;

begin

  AList := TList.Create;

  Result := FList.Add(AList);

  if FIndex < 0 then FIndex := 0;

end;

procedure TManyClipboard.AfterConstruction;

begin

  inherited;

  FList := TList.Create;

  FIndex := -1;

end;

procedure TManyClipboard.BeforeDestruction;

begin

  inherited;

  Clear;

  FList.Free;

end;

procedure TManyClipboard.Clear;

var

  I : Integer;

begin

  inherited;

  for I := 0 To  Count - 1 do

    Delete(I);

  FList.Clear;

end;

procedure TManyClipboard.Delete(Index: Integer);

var

  I : Integer;

  Blk : PClippedData;

  AList : TList;

begin

  IF Index in [0..count-1] then

    AList := TList(FList[Index])

  else Exit;

  for I := 0 To AList.Count-1 do

  begin

    Blk := AList.Items[I];

    Dispose(blk);

  end;

  AList.Free;

  FList.Delete(Index);

end;

function TManyClipboard.GetCount: Integer;

begin

  Result := FList.Count;

end;

function TManyClipboard.GetData(Format: Cardinal;

  var Buffer: Pointer): Cardinal;

var

  hmem: Cardinal;

  lock: Pointer;

begin

  Result := 0;

  If OpenClipboard(0) then

  begin

    hmem := GetClipboardData(Format);

    If hmem = 0 then buffer := nil

    else begin

      Result := GlobalSize(hmem);

      buffer := AllocMem(Result);

      lock := GlobalLock(hmem);

      CopyMemory(buffer, lock, Result);

      GlobalUnlock(hmem);

    end;

    CloseClipboard;

  end

  else buffer := nil;

end;

procedure TManyClipboard.LoadDatas(List: TList);

var

  I : Integer;

  Blk : PClippedData;

begin

  Clear;

  For I := 0 To List.Count-1 Do

  begin

    Blk := List.Items[I];

    SetData(blk.Format, blk.buffer, blk.size);

  end;

end;

procedure TManyClipboard.SaveDatas(List: TList);

var

  I : Integer;

  Blk : PClippedData;

begin

  List.Clear;

  for I := 0 To FormatCount-1 Do

  Begin

    New(blk);

    Blk.Format := Formats[i];

    blk.size := GetData(blk.Format, blk.buffer);

    List.Add(Blk);

  end;

end;

procedure TManyClipboard.SetCount(const Value: Integer);

var

  I : Integer;

begin

  for i := 1 to Value do

  begin

     Add;

  end;

end;

function TManyClipboard.SetData(Format: Cardinal; Buffer: Pointer;

  Size: Cardinal): Boolean;

var

  hmem, sd: Cardinal;

  lock: Pointer;

begin

  // Allocate memory in the global heap

  // Do not free it in this app. It will be freed when the clipboard is cleared

  hmem := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, size);

  lock := GlobalLock(hmem);

  CopyMemory(lock, buffer, size);

  FreeMem(buffer);

  GlobalUnlock(hmem);

  If OpenClipboard(0) then

  begin

    sd := SetClipboardData(format, hmem);

    CloseClipboard;

    Result := (sd <> 0);

  end

  else Result := false;

end;

procedure TManyClipboard.SetIndex(const Value: Integer);

begin

  IF (Value <> FIndex) and (Value In [0..count - 1]) Then

  begin

    If FIndex In [0..count - 1] Then

      SaveDatas(TList(FList[FIndex]));

    FIndex := Value;

    If FIndex In [0..count - 1] Then

      LoadDatas(TList(FList[FIndex]));

  end;

end;

{ TBaseClipboard }

procedure TBaseClipboard.ClipBoardViewerProc(var Msg: TMessage);

begin

  with Msg do

    case Msg of

      WM_DRAWCLIPBOARD :

      begin

        SendMessage(FNextClipHwnd, Msg, WParam, LParam);

        If Assigned(fOnClipboardChanged) then fOnClipboardChanged(Self);

      end;

    end;

end;

procedure TBaseClipboard.AfterConstruction;

begin

  inherited;

  FClipHwnd := AllocateHWnd(ClipBoardViewerProc);

end;

procedure TBaseClipboard.SetViewClipboard(const Value: Boolean);

begin

  FViewClipboard := Value;

  if FViewClipboard then

  begin

    FNextClipHwnd := SetClipBoardViewer(FClipHwnd);

  end

  else

  begin

    ChangeClipboardChain(Handle, FNextClipHwnd);

    SendMessage(FNextClipHwnd, WM_CHANGECBCHAIN, FClipHwnd, FNextClipHwnd);

  end;

end;

procedure TBaseClipboard.BeforeDestruction;

begin

  inherited;

  ViewClipboard := False;

  DeallocateHWnd(FClipHwnd);

end;


initialization

  ManyClipboard := TManyClipboard.Create;

finalization

  ManyClipboard.Free;

end.
