{------------------------------------------------------------------------------}
{                       List object unit
{       Copyright xxxxxxxxxxxxxxxxxxxxxxxx 2003. All right resvered.
{-------------------------------------------------------------------------------
{  Date: 2003.01.16
{  Last update: 2003.01.17
{  Author: Clark.Dong , Green.Wang , Kingron
{  Platform: Delphi 6 ,Wintel
{------------------------------------------------------------------------------}
{  Histroy & function:
{    1) TValueList: Support record,integer and other user define data type
{                   Auto memory manager
{    2) TObjectList: Support Object List,Auto memory manager
{    3) You can use DefaultSort method to sort List.
{       If the LowToHigh = True,The Method Compare Item By Low Bit to High Bit,
{       Asc : Sort Order? True = Asc order, False = Desc Order
{       LowToHigh:
{           False: use for MultiByte Data Type like Word,Integer,Int64 .....
{           True: use for SingleByte Data Type like array of char,string[N]
{------------------------------------------------------------------------------}
{  Warnning:
{    NOT use string in record when use TValueList to store record.
{        When use record,the record must be fixed size.
{    The DefaultSort Only use for x86 arch,
{        not use for Motorola and other cpu Architive
{------------------------------------------------------------------------------}
unit Lists;

interface

uses
  Classes, SysUtils, Windows;

resourcestring
  SRead = 'read';
  SWrite = 'write';
  SErrSetItemSize = 'Can''t resize ItemSize when count > 0, Current Count:%d.';
  SErrStream = 'Stream %s error. Expect Size: %d,actual size: %d.';
  SErrOutBounds = 'Out of bounds,The value %d not between 0 and %d.';
  SErrClassType = 'Class type mismatch. Expect: %s , actual: %s';

type
  EValueList = class(Exception);
  EObjectList = class(Exception);

  { Value List Class,Can use for Integer,Int64,Float,Record... }
  { Auto memory manager,Auto Free memory                       }
  TValueList = class(TList)
  private
    FItemSize: Integer;
    FTag: Integer;
    FData: Pointer;
    FName: string;

    function MakePointerFromValue(const Value): Pointer;
    procedure SetItemSize(const Value: Integer);
  protected
    procedure DoSetItems(Index: integer; const Value);
    procedure DoAssign(Dest: TValueList); virtual;
  public
    function Add(const Value): Integer; { Add Item By Value }
    function AddPointer(Item: Pointer): Integer; { Add Item By Pointer }
    procedure Insert(Index: Integer; const Value); { Insert Item By Value }
    procedure InsertPointer(Index: integer; Value: Pointer);
    procedure Delete(Index: Integer); { Delete Item By Position }
    function Remove(const Value): integer; { Delete Item By Value }
    procedure RemoveAll(const Item); { Delete All Item By Value }
    procedure Clear; override; { Clear All Item,Auto Free }
    function IndexOf(const Value): Integer;
    procedure FreeItem(Index: integer); { Free Item and Set nil }
    procedure Assign(Source: TValueList);
    function Duplicate: TValueList;
    function Equal(Item: TValueList): Boolean;
    { DefaultSort Only use for integer,word,int64.....not for record }
    { Asc: Order of Asc | Desc ? True = Asc order , False = Desc Order }
    procedure DefaultSort(const Asc: Boolean = True;
      const LowToHigh: Boolean = True);
    function BinSearch(const Value; CompareProc: TListSortCompare = nil): integer;
    function Item(Index: integer): Pointer;

    procedure ReadFromStream(Stream: TStream);
    procedure WriteToStream(Stream: TStream);
    constructor Create(Size: Integer);
    destructor Destroy; override;
    property Data: Pointer read FData write FData;
  published
    property Name: string read FName write FName;
    property ItemSize: Integer read FItemSize write SetItemSize;
    property Tag: Integer read FTag write FTag;
  end;

  TOrderValueList = class(TValueList) { Order value List ,Like integer,int64...}
  public
    procedure Sort(const AscOrder: Boolean = True);
  end;

  TIntegerList = class(TOrderValueList)
  private
    function GetItems(Index: integer): integer;
    procedure SetItems(Index: integer; const Value: integer);
  public
    constructor Create;
    procedure Add(Value: integer);
    function ValueExist(Value: integer): Boolean;
    property Items[Index: integer]: integer read GetItems write SetItems; default;
  end;

  TInt64List = class(TOrderValueList)
  private
    function GetItems(Index: integer): Int64;
    procedure SetItems(Index: integer; const Value: Int64);
  public
    constructor Create;
    property Items[Index: integer]: Int64 read GetItems write SetItems; default;
  end;

  TObjectList = class(TList) { TObjectList,Auto Memeroy Manager,Auto Free }
  private
    FClassType: TClass;
    FData: Pointer;
    FName: string;
    FTag: integer;
    function GetItems(Index: Integer): TObject;
    procedure SetItems(Index: Integer; const Value: TObject);
  protected
    procedure ClassTypeError(Message: string);
  public
    function Expand: TObjectList;
    function Add(AObject: TObject): Integer;
    function IndexOf(AObject: TObject): Integer; overload;
    procedure Delete(Index: Integer); overload;
    function Remove(AObject: TObject): Integer;
    procedure Clear; override;
    procedure Insert(Index: Integer; Item: TObject);
    procedure FreeItem(Index: integer);
    function First: TObject;
    function Last: TObject;
    property ItemClassType: TClass read FClassType;
    property Items[Index: Integer]: TObject read GetItems write SetItems; default;

    constructor Create; overload;
    constructor Create(AClassType: TClass); overload;
    destructor Destroy; override;
    property Data: Pointer read FData write FData;
  published
    property Tag: integer read FTag write FTag;
    property Name: string read FName write FName;
  end;

implementation

var
  ByteToCompare: integer;
  SortOrderAsc: Boolean;

  { TValueList }

constructor TValueList.Create(Size: Integer);
begin
  inherited Create;
  FItemSize := Size;
  FData := nil;
  FTag := 0;
end;

destructor TValueList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{ Get memory and Make Pointer from the value }

function TValueList.MakePointerFromValue(const Value): Pointer;
var
  pNewItem: Pointer;
begin
  GetMem(pNewItem, FItemSize);
  if Assigned(@Value) then
    System.Move(Value, pNewItem^, FItemSize)
  else
    FillChar(pNewItem^, FItemSize, 0);
  Result := pNewItem;
end;

function TValueList.Add(const Value): Integer;
begin
  Result := AddPointer(MakePointerFromValue(Value));
end;

function TValueList.AddPointer(Item: Pointer): Integer;
begin
  Result := inherited Add(Item);
end;

procedure TValueList.Assign(Source: TValueList);
begin
  if Assigned(Source) then
    Source.DoAssign(Self);
end;

procedure TValueList.DoAssign(Dest: TValueList);
var
  iCount: Integer;
begin
  Dest.Clear;
  Dest.FItemSize := FItemSize;
  Dest.FName := FName;
  Dest.FTag := FTag;
  Dest.FData := FData;
  for iCount := 0 to Count - 1 do
    Dest.Add(Items[iCount]^);
end;

procedure TValueList.Clear;
begin
  while Count > 0 do
    Delete(Count - 1);
  inherited Clear;
end;

procedure TValueList.RemoveAll(const Item);
begin
  repeat until Remove(Item) < 0;
end;

procedure TValueList.Delete(Index: Integer);
begin
  FreeItem(Index);
  inherited Delete(Index);
end;

function TValueList.Remove(const Value): integer;
begin
  Result := IndexOf(Value);
  if Result >= 0 then Delete(Result);
end;

function TValueList.Duplicate: TValueList;
var
  iCount: Integer;
begin
  Result := TValueList.Create(FItemSize);
  for iCount := 0 to Count - 1 do
    Result.Add(Items[iCount]^);
end;

function TValueList.Equal(Item: TValueList): Boolean;
var
  iCount: Integer;
begin
  Result := (FItemSize = Item.FItemSize) and (Count = Item.Count);
  if Result then
    for iCount := 0 to Count - 1 do
    begin
      if Items[iCount] = Item.Items[iCount] then Continue;
      if Assigned(Items[iCount]) and Assigned(Item.Items[iCount]) then
        Result := Result and CompareMem(Items[iCount], Item.Items[iCount],
          FItemSize)
      else
        Result := False;
    end;
end;

function TValueList.IndexOf(const Value): Integer;
var
  pItem: Pointer;
begin
  pItem := @Value;
  if Assigned(pItem) then
    for Result := 0 to Count - 1 do
      if CompareMem(pItem, Items[Result], ItemSize) then Exit;
  Result := -1;
end;

procedure TValueList.Insert(Index: Integer; const Value);
var
  Temp: Pointer;
begin
  Temp := MakePointerFromValue(Value);
  try
    InsertPointer(Index, Temp);
  except
    FreeMem(Temp, FItemSize);
    raise;
  end;
end;

procedure TValueList.ReadFromStream(Stream: TStream);
var
  i, C, R: Integer;
  Temp: Pointer;
begin
  Clear;
  C := 0;
  FItemSize := 0;

  with Stream do
  begin
    R := Read(C, SizeOf(C));
    if R <> SizeOf(C) then
      raise EValueList.CreateFmt(SErrStream, [SRead, SizeOf(C), R]);

    R := Read(FItemSize, Sizeof(FItemSize));
    if R <> SizeOf(C) then
      raise EValueList.CreateFmt(SErrStream, [SRead, SizeOf(FItemSize), R]);

    GetMem(Temp, FItemSize);
    try
      for i := 1 to C do
      begin
        R := Read(Temp^, FItemSize);
        if R <> SizeOf(C) then
          raise EValueList.CreateFmt(SErrStream, [SRead, FItemSize, R]);
        Add(Temp^);
      end;
    finally
      FreeMem(Temp, FItemSize);
    end;
  end;
end;

procedure TValueList.WriteToStream(Stream: TStream);
var
  C, i, R: Integer;
begin
  C := Count;
  with Stream do
  begin
    R := Write(C, SizeOf(C));
    if R <> Sizeof(C) then
      raise EValueList.CreateFmt(SErrStream, [SWrite, SizeOf(C), R]);

    R := Write(FItemSize, SizeOf(FItemSize));
    if R <> Sizeof(C) then
      raise EValueList.CreateFmt(SErrStream, [SWrite, SizeOf(FItemSize), R]);

    for i := 0 to C - 1 do
    begin
      R := Write(Items[i]^, FItemSize);
      if R <> Sizeof(C) then
        raise EValueList.CreateFmt(SErrStream, [SWrite, FItemSize, R]);
    end;
  end;
end;

procedure TValueList.SetItemSize(const Value: Integer);
begin
  if Count = 0 then
    FItemSize := Value
  else
    raise EValueList.CreateFmt(SErrSetItemSize, [Count]);
end;

procedure TValueList.DoSetItems(Index: integer; const Value);
begin
  if (Index < 0) or (Index >= Count) then
    raise EObjectList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
  System.Move(Value, Items[Index]^, FItemSize);
end;

function CompareHighToLow(Item1, Item2: Pointer): integer;
var
  P1: PByte;
  P2: PByte;
  Size: integer;
begin
  Size := ByteToCompare;
  if SortOrderAsc then
  begin
    P1 := Item1;
    P2 := Item2;
  end
  else
  begin
    P1 := Item2;
    P2 := Item1;
  end;
  Inc(P1, Size);
  Inc(P2, Size);
  Result := 0;
  while Size > 0 do
  begin
    Dec(Size);
    Dec(P1);
    Dec(P2);
    if P1^ < P2^ then
    begin
      Result := -1;
      Break;
    end
    else if P1^ > P2^ then
    begin
      Result := 1;
      Break;
    end;
  end;
end;

function CompareLowToHigh(Item1, Item2: Pointer): integer;
var
  P1: PByte;
  P2: PByte;
  i: integer;
begin
  Result := 0;

  if SortOrderAsc then
  begin
    P1 := Item1;
    P2 := Item2;
  end
  else
  begin
    P1 := Item2;
    P2 := Item1;
  end;

  i := 1;
  while i <= ByteToCompare do
  begin
    if P1^ < P2^ then
    begin
      Result := -1;
      Break;
    end
    else if P1^ > P2^ then
    begin
      Result := 1;
      Break;
    end;
    Inc(P1);
    Inc(P2);
    Inc(i);
  end;
end;

procedure TValueList.DefaultSort(const Asc: Boolean = True; const LowToHigh: Boolean
  = True);
begin
  ByteToCompare := FItemSize;
  SortOrderAsc := Asc;
  if LowToHigh then
    Sort(@CompareLowToHigh)
  else
    Sort(@CompareHighToLow);
end;

procedure TValueList.FreeItem(Index: integer);
begin
  if (Index < 0) or (Index >= Count) then
    raise EValueList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
  if Assigned(inherited Items[Index]) then
    FreeMem(inherited Items[Index], FItemSize);
  inherited Items[Index] := nil;
end;

function TValueList.Item(Index: integer): Pointer;
begin
  Result := inherited Items[Index];
end;

procedure TValueList.InsertPointer(Index: integer; Value: Pointer);
begin
  inherited Insert(Index, Value);
end;

function TValueList.BinSearch(const Value; CompareProc: TListSortCompare = nil):
  integer;
var
  L, H, M: integer;
begin
  Result := -1;
  if Count = 0 then exit;
  if @CompareProc = nil then
  begin
    ByteToCompare := FItemSize;
    CompareProc := CompareHighToLow;
  end;
  L := 0;
  H := Count - 1;
  if (CompareProc(@Value, Items[L]) < 0) or (CompareProc(@Value, Items[H]) > 0) then
    exit;
  while L <= H do
  begin
    M := (L + H) div 2;
    if CompareProc(Items[M], @Value) = 0 then
    begin
      Result := M;
      Break;
    end;
    if CompareProc(Items[M], @Value) > 0 then
      H := M - 1
    else
      L := M + 1;
  end;
end;

{ TObjectList }

function TObjectList.Add(AObject: TObject): Integer;
begin
  Result := -1;
  if (AObject = nil) or (AObject is FClassType) then
    Result := inherited Add(AObject)
  else
    ClassTypeError(AObject.ClassName);
end;

procedure TObjectList.Clear;
begin
  while Count > 0 do
    Delete(Count - 1);
  inherited Clear;
end;

constructor TObjectList.Create;
begin
  Create(TObject);
end;

constructor TObjectList.Create(AClassType: TClass);
begin
  inherited Create;
  FClassType := AClassType;
end;

procedure TObjectList.Delete(Index: Integer);
begin
  FreeItem(Index);
  inherited Delete(Index);
end;

procedure TObjectList.ClassTypeError(Message: string);
begin
  raise EObjectList.CreateFmt(SErrClassType, [FClassType.ClassName, Message]);
end;

function TObjectList.Expand: TObjectList;
begin
  Result := (inherited Expand) as TObjectList;
end;

function TObjectList.First: TObject;
begin
  Result := TObject(inherited First);
end;

function TObjectList.GetItems(Index: Integer): TObject;
begin
  Result := TObject(inherited Items[Index]);
end;

function TObjectList.IndexOf(AObject: TObject): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TObjectList.Insert(Index: Integer; Item: TObject);
begin
  if (Item = nil) or (Item is FClassType) then
    inherited Insert(Index, Pointer(Item))
  else
    ClassTypeError(Item.ClassName);
end;

function TObjectList.Last: TObject;
begin
  Result := TObject(inherited Last);
end;

function TObjectList.Remove(AObject: TObject): Integer;
begin
  Result := IndexOf(AObject);
  if Result >= 0 then Delete(Result);
end;

procedure TObjectList.SetItems(Index: Integer; const Value: TObject);
begin
  if Value = nil then
    FreeItem(Index)
  else if Value is FClassType then
    inherited Items[Index] := Value
  else
    ClassTypeError(Value.ClassName);
end;

destructor TObjectList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TObjectList.FreeItem(Index: integer);
begin
  if (Index < 0) or (Index >= Count) then
    raise EObjectList.CreateFmt(SErrOutBounds, [Index, Count - 1]);
  if Assigned(inherited Items[Index]) then Items[Index].Free;
  inherited Items[Index] := nil;
end;

{ TIntegerList }

procedure TIntegerList.Add(Value: integer);
begin
  inherited Add(Value);
end;

constructor TIntegerList.Create;
begin
  inherited Create(SizeOf(integer));
end;

function TIntegerList.GetItems(Index: integer): integer;
begin
  Result := integer(inherited Items[Index]^);
end;

procedure TIntegerList.SetItems(Index: integer; const Value: integer);
begin
  DoSetItems(Index, Value);
end;

function TIntegerList.ValueExist(Value: integer): Boolean;
begin
  Result := IndexOf(Value) <> -1;
end;

{ TInt64List }

constructor TInt64List.Create;
begin
  inherited Create(SizeOf(Int64));
end;

function TInt64List.GetItems(Index: integer): Int64;
begin
  Result := int64(inherited Items[index]^);
end;

procedure TInt64List.SetItems(Index: integer; const Value: Int64);
begin
  DoSetItems(Index, Value);
end;

{ TOrderValueList }

procedure TOrderValueList.Sort(const AscOrder: Boolean);
begin
  DefaultSort(AscOrder, False);
end;

end.

