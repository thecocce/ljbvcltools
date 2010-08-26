unit Streams;

interface

uses SysUtils, Windows, TypInfo, Classes, Graphics, RTLConsts;


{ BoolFromStream �����е�ǰλ�ö�ȡһ����������ֵ }

function BoolFromStream(Stream: TStream): Boolean;


{ ByteFromStream �����е�ǰλ�ö�ȡһ��Byte����ֵ }

function ByteFromStream(Stream: TStream): Byte;


{ IntFromStream �����е�ǰλ�ö�ȡһ����������ֵ }

function IntFromStream(Stream: TStream): Integer;


{ LongIntFromStream �����е�ǰλ�ö�ȡһ������������ֵ }

function LongIntFromStream(Stream: TStream): LongInt;


{ FloatFromStream �����е�ǰλ�ö�ȡһ��ʵ����ֵ }

function FloatFromStream(Stream: TStream): Extended;


{ FloatFromStream �����е�ǰλ�ö�ȡһ��TSize����ֵ }

function SizeFromStream(Stream: TStream): TSize;


{ RectFromStream �����е�ǰλ�ö�ȡһ��Trect����ֵ }

function RectFromStream(Stream: TStream): TRect;


{ ColorFromStream �����е�ǰλ�ö�ȡһ����ɫֵ }

function ColorFromStream(Stream: TStream): COLORREF;


{ PointFromStream �����е�ǰλ�ö�ȡһ������ֵ }

function PointFromStream(Stream: TStream): TPoint;


{ StringFromStream �����е�ǰλ�ö�ȡһ��ָ����С���ַ��� }

function StringFromStream(Stream: TStream; Size : Integer): string;


{ DateTimeFromStream �����е�ǰλ�ö�ȡһ��ʱ�����ֵ }

function DateTimeFromStream(Stream : TStream) : TDateTime;


{ StreamFromStream �����ж�ȡ���ݵ���һ���� }

procedure StreamFromStream(Source, SubStream: TStream; Size: Integer);


{ ObjectFromStream �����ж�ȡһ����������� }

function ObjectFromStream(Stream : TStream; Source: TPersistent) : Boolean;


{ ComponentFromStream �����ж�ȡһ���ؼ������� }

function ComponentFromStream(Stream : TStream; Source: TComponent) : Boolean;


{ BoolToStream ��һ������������ֵд��һ������ }

procedure BoolToStream(Stream: TStream; Value: Boolean);


{ ByteToStream ��һ��byte������ֵд��һ������ }

procedure ByteToStream(Stream: TStream; Value: Byte);


{ IntToStream ��һ������������ֵд��һ������ }

procedure IntToStream(Stream: TStream; Value: Integer);


{ LongIntToStream ��һ��������������ֵд��һ������ }

procedure LongIntToStream(Stream: TStream; Value: LongInt);


{ FloatToStream ��һ��ʵ��������ֵд��һ������ }

procedure FloatToStream(Stream: TStream; Value: Extended);


{ SizeToStream ��һ��TSize�ṹд��һ������ }

procedure SizeToStream(Stream: TStream; Value: TSize);


{ RectToStream ��һ��TRect�ṹд��һ������ }

procedure RectToStream(Stream: TStream; Value: TRect);


{ ColorToStream ��һ����ɫ������ֵд��һ������ }

procedure ColorToStream(Stream: TStream; Value: COLORREF);


{ ColorToStream ��һ������ṹд��һ������ }

procedure PointToStream(Stream: TStream; Value: TPoint);


{ StringToStream ��һ���ַ���������ֵд��һ������ }

procedure StringToStream(Stream: TStream; Value: string);


{ DateTimeToStram ��һ��ʱ�������ֵд��һ������ }

procedure DateTimeToStram(Stream : TStream; Value : TDateTime);


{ StreamToStream ���������ݿ�����һ������ }

procedure StreamToStream(Stream, SubStream: TStream; Size : Integer);


{ ObjectToStream ��һ����������Կ�����һ������ }

function ObjectToStream(Stream : TStream; Source: TPersistent) : Boolean;


{ ComponentToStream ��һ���ؼ������Կ�����һ������ }

function ComponentToStream(Stream : TStream; Source: TComponent) : Boolean;


{ BitmapFromResource ����Դ�ж�ȡһ��TBITMAP������ }

procedure BitmapFromResource(ResName : string; Bitmap : TBitmap);


{ StringFromResource ����Դ�ж�ȡһ���ַ��������� }

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
