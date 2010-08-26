unit Streams;

interface

uses SysUtils, Windows, TypInfo, Classes, Graphics, RTLConsts;


{ BoolFromStream 从流中当前位置读取一个布尔变量值 }

function BoolFromStream(Stream: TStream): Boolean;


{ ByteFromStream 从流中当前位置读取一个Byte变量值 }

function ByteFromStream(Stream: TStream): Byte;


{ IntFromStream 从流中当前位置读取一个整数变量值 }

function IntFromStream(Stream: TStream): Integer;


{ LongIntFromStream 从流中当前位置读取一个长整数变量值 }

function LongIntFromStream(Stream: TStream): LongInt;


{ FloatFromStream 从流中当前位置读取一个实变量值 }

function FloatFromStream(Stream: TStream): Extended;


{ FloatFromStream 从流中当前位置读取一个TSize变量值 }

function SizeFromStream(Stream: TStream): TSize;


{ RectFromStream 从流中当前位置读取一个Trect变量值 }

function RectFromStream(Stream: TStream): TRect;


{ ColorFromStream 从流中当前位置读取一个颜色值 }

function ColorFromStream(Stream: TStream): COLORREF;


{ PointFromStream 从流中当前位置读取一个坐标值 }

function PointFromStream(Stream: TStream): TPoint;


{ StringFromStream 从流中当前位置读取一串指定大小的字符串 }

function StringFromStream(Stream: TStream; Size : Integer): string;


{ DateTimeFromStream 从流中当前位置读取一个时间变量值 }

function DateTimeFromStream(Stream : TStream) : TDateTime;


{ StreamFromStream 从流中读取内容到另一个流 }

procedure StreamFromStream(Source, SubStream: TStream; Size: Integer);


{ ObjectFromStream 从流中读取一个对象的属性 }

function ObjectFromStream(Stream : TStream; Source: TPersistent) : Boolean;


{ ComponentFromStream 从流中读取一个控件的属性 }

function ComponentFromStream(Stream : TStream; Source: TComponent) : Boolean;


{ BoolToStream 把一个布尔变量的值写到一个流中 }

procedure BoolToStream(Stream: TStream; Value: Boolean);


{ ByteToStream 把一个byte变量的值写到一个流中 }

procedure ByteToStream(Stream: TStream; Value: Byte);


{ IntToStream 把一个整数变量的值写到一个流中 }

procedure IntToStream(Stream: TStream; Value: Integer);


{ LongIntToStream 把一个长整数变量的值写到一个流中 }

procedure LongIntToStream(Stream: TStream; Value: LongInt);


{ FloatToStream 把一个实数变量的值写到一个流中 }

procedure FloatToStream(Stream: TStream; Value: Extended);


{ SizeToStream 把一个TSize结构写到一个流中 }

procedure SizeToStream(Stream: TStream; Value: TSize);


{ RectToStream 把一个TRect结构写到一个流中 }

procedure RectToStream(Stream: TStream; Value: TRect);


{ ColorToStream 把一个颜色变量的值写到一个流中 }

procedure ColorToStream(Stream: TStream; Value: COLORREF);


{ ColorToStream 把一个坐标结构写到一个流中 }

procedure PointToStream(Stream: TStream; Value: TPoint);


{ StringToStream 把一个字符串变量的值写到一个流中 }

procedure StringToStream(Stream: TStream; Value: string);


{ DateTimeToStram 把一个时间变量的值写到一个流中 }

procedure DateTimeToStram(Stream : TStream; Value : TDateTime);


{ StreamToStream 把流的内容拷贝到一个流中 }

procedure StreamToStream(Stream, SubStream: TStream; Size : Integer);


{ ObjectToStream 把一个对象的属性拷贝到一个流中 }

function ObjectToStream(Stream : TStream; Source: TPersistent) : Boolean;


{ ComponentToStream 把一个控件的属性拷贝到一个流中 }

function ComponentToStream(Stream : TStream; Source: TComponent) : Boolean;


{ BitmapFromResource 从资源中读取一个TBITMAP的内容 }

procedure BitmapFromResource(ResName : string; Bitmap : TBitmap);


{ StringFromResource 从资源中读取一个字符串的内容 }

function StringFromResource(ResName : string; ResType: PChar) : string;


implementation


type

  TWriterAccess = class(TWriter);

  TReaderAccess = class(TReader);

function BoolFromStream(Stream: TStream): Boolean;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function ByteFromStream(Stream: TStream): Byte;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function ColorFromStream(Stream: TStream): COLORREF;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function DateTimeFromStream(Stream: TStream): TDateTime;

begin

   Stream.ReadBuffer(result, SizeOf(result));

end;

function FloatFromStream(Stream: TStream): Extended;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function IntFromStream(Stream: TStream): Integer;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function LongIntFromStream(Stream: TStream): LongInt;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function PointFromStream(Stream: TStream): TPoint;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function RectFromStream(Stream: TStream): TRect;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function SizeFromStream(Stream: TStream): TSize;

begin

   Stream.ReadBuffer(Result, SizeOf(Result));

end;

function StringFromStream(Stream: TStream; Size : Integer): string;

begin

   Result := '';

   if Size > 0 then

   begin

      SetLength(Result, Size);

      Stream.ReadBuffer(Result[1], Size);

   end;

end;

procedure BoolToStream(Stream: TStream; Value: Boolean);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;


procedure ByteToStream(Stream: TStream; Value: Byte);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure ColorToStream(Stream: TStream; Value: COLORREF);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure DateTimeToStram(Stream: TStream; Value: TDateTime);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure FloatToStream(Stream: TStream; Value: Extended);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure IntToStream(Stream: TStream; Value: Integer);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure LongIntToStream(Stream: TStream; Value: Integer);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure PointToStream(Stream: TStream; Value: TPoint);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure RectToStream(Stream: TStream; Value: TRect);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure SizeToStream(Stream: TStream; Value: TSize);

begin

   Stream.WriteBuffer(Value, SizeOf(Value));

end;

procedure StreamFromStream(Source, SubStream: TStream; Size: Integer);

begin

  if Size > 0 then

    SubStream.CopyFrom(Source, Size);

end;

procedure StreamToStream(Stream, SubStream: TStream; Size : Integer);

begin

   if Size > 0 then

   begin

      SubStream.Seek(0, soFromBeginning);

      Stream.CopyFrom(SubStream, Size);

   end;

end;

procedure StringToStream(Stream: TStream; Value: string);

begin

   Stream.WriteBuffer(Value[1], Length(Value));

end;

function ObjectFromStream(Stream : TStream; Source: TPersistent) : Boolean;

var

   Reader: TReaderAccess;

   M: TMemoryStream;

begin

   Result := False;

   M:= TMemoryStream.Create;

   Try

      ObjectTextToBinary(Stream, M);

      M.Seek(soFromBeginning, 0);

      Reader:= TReaderAccess.Create(M, 4096);

      Try

         Reader.ReadSignature;

         Reader.ReadStr; {ClassName}

         Reader.ReadStr; {NAME}

         while not Reader.EndOfList do

            Reader.ReadProperty(Source);

         Reader.ReadListEnd;

         Reader.ReadListEnd;

         Result := True;

      finally

         Reader.Free;

      end;

   finally

      M.Free;

   end;

end;

function ObjectToStream(Stream : TStream; Source: TPersistent) : Boolean;

var

   Writer: TWriterAccess;

   M: TMemoryStream;

begin

   Result := False;

   M:= TMemoryStream.Create;

   Try

      Writer:= TWriterAccess.Create(M, 4096);

      Try

         Writer.WriteSignature;

         Writer.WriteStr(Source.ClassName);

         Writer.WriteStr(''); {NAME}

         Writer.WriteProperties(Source);

         Writer.WriteListEnd;

         Writer.WriteListEnd;

         Result := True;

      finally

         Writer.Free;

      end;

      M.Seek(soFromBeginning, 0);

      ObjectBinaryToText(M, Stream);

   finally

      M.Free;

   end;

end;

function ComponentFromStream(Stream : TStream; Source: TComponent) : Boolean;

begin

   Result := True;

   try

     Stream.ReadComponentRes(Source);

   except

     Result := False;

   end;

end;

function ComponentToStream(Stream : TStream; Source: TComponent) : Boolean;

begin

   Result := True;

   TRY

     Stream.WriteComponentRes(Source.ClassName, Source);

   Except

     Result := False;

   end;

end;

procedure BitmapFromResource(ResName : string; Bitmap : TBitmap);

var

  HResInfo: THandle;

  BMF: TBitmapFileHeader;

  MemHandle: THandle;

  Stream: TMemoryStream;

  ResPtr: PByte;

  ResSize: Longint;

begin

  HResInfo := FindResource(HInstance, PChar(ResName), RT_Bitmap);

  ResSize := SizeofResource(HInstance, HResInfo);

  MemHandle := LoadResource(HInstance, HResInfo);

  ResPtr := LockResource(MemHandle);

  Stream := TMemoryStream.Create;

  try

    Stream.SetSize(ResSize + SizeOf(BMF));

    BMF.bfType := $4D42;

    Stream.Write(BMF, SizeOf(BMF));

    Stream.Write(ResPtr^, ResSize);

    Stream.Seek(0, 0);

    Bitmap.LoadFromStream(Stream);

  finally

    Stream.Free;

  end;

  FreeResource(MemHandle);

end;

function StringFromResource(ResName : string; ResType: PChar) : string;

var

  Buffer: Pointer;

begin

  with TResourceStream.Create(Hinstance, ResName, ResType) do

  begin

    Position := 0;

    getMem(Buffer, size+1);

    ReadBuffer(buffer^, Size);

    result := StrPas(Pchar(Buffer));

    freeMem(Buffer);

    Free;

  end;

end;

end.
