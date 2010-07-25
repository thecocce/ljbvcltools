
///////////////////////////////////////////////////////////////////////////////
//欢迎使用Base64加密算法演示程序，此算法为标准的Base64算法,下面是调用演示。
///////////////////////////////////////////////////////////////////////////////

//unit Unit1;
//
//interface
//
//uses
//    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//    Dialogs, StdCtrls, ExtCtrls,Jpeg;
//
//type
//    TForm1 = class(TForm)
//        Label1:TLabel;
//        Label2:TLabel;
//        Edit1:TEdit;
//        Edit2:TEdit;
//        Button1:TButton;
//        Button2:TButton;
//        Button3:TButton;
//        Button4:TButton;
//    Image1: TImage;
//        procedure Button1Click(Sender:TObject);
//        procedure Button2Click(Sender:TObject);
//        procedure Button3Click(Sender:TObject);
//        procedure Button4Click(Sender:TObject);
//        procedure Button5Click(Sender: TObject);
//    private
//        { Private declarations }
//    public
//        { Public declarations }
//    end;
//var
//    Form1:TForm;
//    
//implementation
//uses base64d;
//
//{$R *.dfm}
//procedure TForm1.Button1Click(Sender:TObject);
//begin
//    //function MimeEncodeString (const s: AnsiString): AnsiString;//加密字符串函数；
//    //function MimeDecodeString (const s: AnsiString): AnsiString;//解密字符串函数；
//    if MimeEncodeString(Edit1.Text) = Edit2.Text then
//        ShowMessage('注册成功！')
//    else
//        ShowMessage('注册失败！');
//
//end;
//
//procedure TForm1.Button2Click(Sender:TObject);
//begin
//    Close;
//end;
//
//procedure TForm1.Button3Click(Sender:TObject);
//begin
//    Base64Encode('C:\test\20060109燃气收费系统.EXE', 'C:\test\20060109燃气收费系统.b64');
//end;
//
//procedure TForm1.Button4Click(Sender:TObject);
//begin
//    Base64Decode('C:\test\20060109燃气收费系统.b64', 'C:\test\20060109燃气收费系统.exe');
//end;
//
//procedure TForm1.Button5Click(Sender: TObject);
//var
//  mStream,mStream2:TMemoryStream;
//  sStream ,sStream2 : TStringStream;
//  sList:TStringList;
//  Str:string;
//  jpg:TJPEGImage;
//begin
//  mStream := TMemoryStream.Create;
//  mStream.LoadFromFile('c:\test\ab.jpg');
//  sStream := TStringStream.Create(Str);
//  MimeEncodeStream(mStream,sStream);
//  sList:=TStringList.Create;
//  sList.Text:=sStream.DataString;
//
//
//  mStream2 := TMemoryStream.Create;
//  sStream2 := TStringStream.Create(sList.Text);
//  MimeDecodeStream(sStream2, mStream2);
//
//  jpg:=TJPEGImage.Create;
//  jpg.LoadFromFile('c:\test\ab.jpg');
//  Image1.Picture.Graphic:=jpg;
//
//end;
//
//end.



//procedure TForm1.Button1Click(Sender: TObject);
//var
//    mstr,mstr2:TMemoryStream;
//    sstr,sstr2:TStringStream;
//    str:string;
//begin
//    mstr := TMemoryStream.Create();      //文件转换为BASE64编码(内存中完成)
//    mstr.LoadFromFile('C:\GetWindow.exe');
//    sstr := TStringStream.Create(Str);
//    LjbBase641.MimeEncodeStream(mstr, sstr);
//    str := sstr.DataString;
//
//    Showmessage(str);
//
//    sstr2:=TStringStream.Create(str);  //从BASE64编码还原文件(内存中完成)
//    mstr2 := TMemoryStream.Create();
//    LjbBase641.MimeDecodeStream(sstr2,mstr2);
//    mstr.SaveToFile('C:\GetWindow2.exe');
//
//    sstr.Free;
//    mstr.Free;
//    sstr2.Free;
//    mstr2.Free;
//end;


//--------------------------------------------------程序开始
unit Ljbbase64d;

interface
uses
    Classes;

type
    TLjbBase64 = class(TComponent)
    private
        { Private declarations }
        function MimeEncodedSize(const i:Cardinal):Cardinal;
        function MimeEncodedSizeNoCRLF(const i:Cardinal):Cardinal;
        function MimeDecodedSize(const i:Cardinal):Cardinal;
        procedure DecodeHttpBasicAuthentication(const BasicCredentials:AnsiString;
            out UserId, PassWord:AnsiString);
        procedure MimeEncode(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
        procedure MimeEncodeNoCRLF(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
        procedure MimeEncodeFullLines(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
        function MimeDecodePartial(const InputBuffer; const InputBytesCount:Cardinal;
            out OutputBuffer; var ByteBuffer:Cardinal; var ByteBufferSpace:Cardinal):Cardinal;
        function MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer:Cardinal;
            const ByteBufferSpace:Cardinal):Cardinal;
        function MimeDecode(const InputBuffer; const InputBytesCount:Cardinal; out OutputBuffer):Cardinal;
        procedure MimeEncodeStreamNoCRLF(const InputStream:TStream; const OutputStream:TStream);
        function MimeEncodeStringNoCRLF(const s:AnsiString):AnsiString;

    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function MimeEncodeString(const s:AnsiString):AnsiString;
        function MimeDecodeString(const s:AnsiString):AnsiString;
        procedure MimeEncodeStream(const InputStream:TStream; const OutputStream:TStream);
        procedure MimeDecodeStream(const InputStream:TStream; const OutputStream:TStream);
        procedure Base64EncodeFile(InputFile, OutputFile:string);
        procedure Base64DecodeFile(InputFile, OutputFile:string);
    end;
const
    MIME_ENCODED_LINE_BREAK = 76;
    MIME_DECODED_LINE_BREAK = MIME_ENCODED_LINE_BREAK div 4 * 3;
    BUFFER_SIZE = MIME_DECODED_LINE_BREAK * 3 * 4 * 16;
    MIME_ENCODE_TABLE:array[0..63] of Byte = (
        065, 066, 067, 068, 069, 070, 071, 072, // 00 - 07
        073, 074, 075, 076, 077, 078, 079, 080, // 08 - 15
        081, 082, 083, 084, 085, 086, 087, 088, // 16 - 23
        089, 090, 097, 098, 099, 100, 101, 102, // 24 - 31
        103, 104, 105, 106, 107, 108, 109, 110, // 32 - 39
        111, 112, 113, 114, 115, 116, 117, 118, // 40 - 47
        119, 120, 121, 122, 048, 049, 050, 051, // 48 - 55
        052, 053, 054, 055, 056, 057, 043, 047); // 56 - 63

    MIME_PAD_CHAR = Byte('=');

    MIME_DECODE_TABLE:array[Byte] of Cardinal = (
        255, 255, 255, 255, 255, 255, 255, 255, //  00 -  07
        255, 255, 255, 255, 255, 255, 255, 255, //  08 -  15
        255, 255, 255, 255, 255, 255, 255, 255, //  16 -  23
        255, 255, 255, 255, 255, 255, 255, 255, //  24 -  31
        255, 255, 255, 255, 255, 255, 255, 255, //  32 -  39
        255, 255, 255, 062, 255, 255, 255, 063, //  40 -  47
        052, 053, 054, 055, 056, 057, 058, 059, //  48 -  55
        060, 061, 255, 255, 255, 255, 255, 255, //  56 -  63
        255, 000, 001, 002, 003, 004, 005, 006, //  64 -  71
        007, 008, 009, 010, 011, 012, 013, 014, //  72 -  79
        015, 016, 017, 018, 019, 020, 021, 022, //  80 -  87
        023, 024, 025, 255, 255, 255, 255, 255, //  88 -  95
        255, 026, 027, 028, 029, 030, 031, 032, //  96 - 103
        033, 034, 035, 036, 037, 038, 039, 040, // 104 - 111
        041, 042, 043, 044, 045, 046, 047, 048, // 112 - 119
        049, 050, 051, 255, 255, 255, 255, 255, // 120 - 127
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255);

type
    PByte4 = ^TByte4;
    TByte4 = packed record
        b1:Byte;
        b2:Byte;
        b3:Byte;
        b4:Byte;
    end;

    PByte3 = ^TByte3;
    TByte3 = packed record
        b1:Byte;
        b2:Byte;
        b3:Byte;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbBase64]);
end;
//--------------------------------------------------------------

function TLjbBase64.MimeEncodeString(const s:AnsiString):AnsiString;
var
    l:Cardinal;
begin
    if Pointer(s) <> nil then
    begin
        l := Cardinal(Pointer(Cardinal(s) - 4)^);
        SetLength(Result, MimeEncodedSize(l));
        MimeEncode(Pointer(s)^, l, Pointer(Result)^);
    end
    else
        Result := '';
end;
//--------------------------------------------------------------

function TLjbBase64.MimeEncodeStringNoCRLF(const s:AnsiString):AnsiString;
var
    l:Cardinal;
begin
    if Pointer(s) <> nil then
    begin
        l := Cardinal(Pointer(Cardinal(s) - 4)^);
        SetLength(Result, MimeEncodedSizeNoCRLF(l));
        MimeEncodeNoCRLF(Pointer(s)^, l, Pointer(Result)^);
    end
    else
        Result := '';
end;
//--------------------------------------------------------------

function TLjbBase64.MimeDecodeString(const s:AnsiString):AnsiString;
var
    ByteBuffer, ByteBufferSpace:Cardinal;
    l:Cardinal;
begin
    if Pointer(s) <> nil then
    begin
        l := Cardinal(Pointer(Cardinal(s) - 4)^);
        SetLength(Result, (l + 3) div 4 * 3);
        ByteBuffer := 0;
        ByteBufferSpace := 4;
        l := MimeDecodePartial(Pointer(s)^, l, Pointer(Result)^, ByteBuffer, ByteBufferSpace);
        Inc(l, MimeDecodePartialEnd(Pointer(Cardinal(Result) + l)^,
            ByteBuffer, ByteBufferSpace));
        SetLength(Result, l);
    end
    else
        Result := '';
end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeEncodeStream(const InputStream:TStream; const OutputStream:TStream);
var
    InputBuffer:array[0..BUFFER_SIZE - 1] of Byte;
    OutputBuffer:array[0..(BUFFER_SIZE + 2) div 3 * 4 + BUFFER_SIZE div
    MIME_DECODED_LINE_BREAK * 2 - 1] of Byte;
    BytesRead:Cardinal;
    IDelta, ODelta:Cardinal;
begin
    BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));

    while BytesRead = SizeOf(InputBuffer) do
    begin
        MimeEncodeFullLines(InputBuffer, SizeOf(InputBuffer), OutputBuffer);
        OutputStream.Write(OutputBuffer, SizeOf(OutputBuffer));
        BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));
    end;

    MimeEncodeFullLines(InputBuffer, BytesRead, OutputBuffer);

    IDelta := BytesRead div MIME_DECODED_LINE_BREAK; // Number of lines processed.
    ODelta := IDelta * (MIME_ENCODED_LINE_BREAK + 2);
    IDelta := IDelta * MIME_DECODED_LINE_BREAK;
    MimeEncodeNoCRLF(Pointer(Cardinal(@InputBuffer) + IDelta)^, BytesRead - IDelta,
        Pointer(Cardinal(@OutputBuffer) + ODelta)^);

    OutputStream.Write(OutputBuffer, MimeEncodedSize(BytesRead));
end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeEncodeStreamNoCRLF(const InputStream:TStream; const OutputStream:TStream);
var
    InputBuffer:array[0..BUFFER_SIZE - 1] of Byte;
    OutputBuffer:array[0..((BUFFER_SIZE + 2) div 3) * 4 - 1] of Byte;
    BytesRead:Cardinal;
begin
    BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));
    while BytesRead = SizeOf(InputBuffer) do
    begin
        MimeEncodeNoCRLF(InputBuffer, SizeOf(InputBuffer), OutputBuffer);
        OutputStream.Write(OutputBuffer, SizeOf(OutputBuffer));
        BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));
    end;

    MimeEncodeNoCRLF(InputBuffer, BytesRead, OutputBuffer);
    OutputStream.Write(OutputBuffer, (BytesRead + 2) div 3 * 4);
end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeDecodeStream(const InputStream:TStream; const OutputStream:TStream);
var
    ByteBuffer, ByteBufferSpace:Cardinal;
    InputBuffer:array[0..BUFFER_SIZE - 1] of Byte;
    OutputBuffer:array[0..(BUFFER_SIZE + 3) div 4 * 3 - 1] of Byte;
    BytesRead:Cardinal;
begin
    ByteBuffer := 0;
    ByteBufferSpace := 4;
    BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));
    while BytesRead > 0 do
    begin
        OutputStream.Write(OutputBuffer, MimeDecodePartial(InputBuffer, BytesRead,
            OutputBuffer, ByteBuffer, ByteBufferSpace));
        BytesRead := InputStream.Read(InputBuffer, SizeOf(InputBuffer));
    end;
    OutputStream.Write(OutputBuffer, MimeDecodePartialEnd(OutputBuffer, ByteBuffer,
        ByteBufferSpace));
end;
//--------------------------------------------------------------

procedure TLjbBase64.DecodeHttpBasicAuthentication(const BasicCredentials:AnsiString; out UserId, PassWord:AnsiString);
label
    Fail;
const
    LBasic = 6; { Length ('Basic ') }
var
    DecodedPtr, p:PAnsiChar;
    i, l:Cardinal;
begin
    p := Pointer(BasicCredentials);
    if p = nil then goto Fail;

    l := Cardinal(Pointer(p - 4)^);
    if l <= LBasic then goto Fail;

    Dec(l, LBasic);
    Inc(p, LBasic);

    GetMem(DecodedPtr, (l + 3) div 4 * 3 { MimeDecodedSize (l) });
    l := MimeDecode(p^, l, DecodedPtr^);
    i := 0;
    p := DecodedPtr;
    while (l > 0) and (p[i] <> ':') do
    begin
        Inc(i);
        Dec(l);
    end;
    SetString(UserId, DecodedPtr, i);
    if l > 1 then
        SetString(PassWord, DecodedPtr + i + 1, l - 1)
    else
        PassWord := '';

    FreeMem(DecodedPtr);
    Exit;

    Fail:
    UserId := '';
    PassWord := '';
end;
//--------------------------------------------------------------

function TLjbBase64.MimeEncodedSize(const i:Cardinal):Cardinal;
begin
    Result := (i + 2) div 3 * 4 + (i - 1) div MIME_DECODED_LINE_BREAK * 2;
end;
//--------------------------------------------------------------

function TLjbBase64.MimeEncodedSizeNoCRLF(const i:Cardinal):Cardinal;
begin
    Result := (i + 2) div 3 * 4;
end;
//--------------------------------------------------------------

function TLjbBase64.MimeDecodedSize(const i:Cardinal):Cardinal;
begin
    Result := (i + 3) div 4 * 3;
end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeEncode(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
var
    IDelta, ODelta:Cardinal;
begin
    MimeEncodeFullLines(InputBuffer, InputByteCount, OutputBuffer);
    IDelta := InputByteCount div MIME_DECODED_LINE_BREAK;
    ODelta := IDelta * (MIME_ENCODED_LINE_BREAK + 2);
    IDelta := IDelta * MIME_DECODED_LINE_BREAK;
    MimeEncodeNoCRLF(Pointer(Cardinal(@InputBuffer) + IDelta)^,
        InputByteCount - IDelta, Pointer(Cardinal(@OutputBuffer) + ODelta)^);
end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeEncodeFullLines(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
var
    b, OuterLimit:Cardinal;
    InPtr, InnerLimit:^Byte;
    OutPtr:PByte4;
begin
    if InputByteCount = 0 then Exit;
    InPtr := @InputBuffer;
    OutPtr := @OutputBuffer;

    InnerLimit := InPtr;
    Inc(Cardinal(InnerLimit), MIME_DECODED_LINE_BREAK);

    OuterLimit := Cardinal(InPtr);
    Inc(OuterLimit, InputByteCount);

    while Cardinal(InnerLimit) <= OuterLimit do
    begin

        while InPtr <> InnerLimit do
        begin
            b := InPtr^;
            b := b shl 8;
            Inc(InPtr);
            b := b or InPtr^;
            b := b shl 8;
            Inc(InPtr);
            b := b or InPtr^;
            Inc(InPtr);
            OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
            b := b shr 6;
            OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
            b := b shr 6;
            OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
            b := b shr 6;
            OutPtr^.b1 := MIME_ENCODE_TABLE[b];
            Inc(OutPtr);
        end;
        OutPtr^.b1 := 13;
        OutPtr^.b2 := 10;
        Inc(Cardinal(OutPtr), 2);

        Inc(InnerLimit, MIME_DECODED_LINE_BREAK);
    end;

end;
//--------------------------------------------------------------

procedure TLjbBase64.MimeEncodeNoCRLF(const InputBuffer; const InputByteCount:Cardinal; out OutputBuffer);
var
    b, OuterLimit:Cardinal;
    InPtr, InnerLimit:^Byte;
    OutPtr:PByte4;
begin
    if InputByteCount = 0 then Exit;
    InPtr := @InputBuffer;
    OutPtr := @OutputBuffer;

    OuterLimit := InputByteCount div 3 * 3;

    InnerLimit := @InputBuffer;
    Inc(Cardinal(InnerLimit), OuterLimit);
    while InPtr <> InnerLimit do
    begin
        b := InPtr^;
        b := b shl 8;
        Inc(InPtr);
        b := b or InPtr^;
        b := b shl 8;
        Inc(InPtr);
        b := b or InPtr^;
        Inc(InPtr);
        OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr^.b1 := MIME_ENCODE_TABLE[b];
        Inc(OutPtr);
    end;
    case InputByteCount - OuterLimit of
        1:
            begin
                b := InPtr^;
                b := b shl 4;
                OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
                b := b shr 6;
                OutPtr.b1 := MIME_ENCODE_TABLE[b];
                OutPtr.b3 := MIME_PAD_CHAR;
                OutPtr.b4 := MIME_PAD_CHAR;
            end;
        2:
            begin
                b := InPtr^;
                Inc(InPtr);
                b := b shl 8;
                b := b or InPtr^;
                b := b shl 2;
                OutPtr.b3 := MIME_ENCODE_TABLE[b and $3F];
                b := b shr 6;
                OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
                b := b shr 6;
                OutPtr.b1 := MIME_ENCODE_TABLE[b];
                OutPtr.b4 := MIME_PAD_CHAR; { Pad remaining byte. }
            end;
    end;
end;
//--------------------------------------------------------------

function TLjbBase64.MimeDecode(const InputBuffer; const InputBytesCount:Cardinal;
    out OutputBuffer):Cardinal;
var
    ByteBuffer, ByteBufferSpace:Cardinal;
begin
    ByteBuffer := 0;
    ByteBufferSpace := 4;
    Result := MimeDecodePartial(InputBuffer, InputBytesCount,
        OutputBuffer, ByteBuffer, ByteBufferSpace);
    Inc(Result, MimeDecodePartialEnd(Pointer(Cardinal(@OutputBuffer) + Result)^,
        ByteBuffer, ByteBufferSpace));
end;
//--------------------------------------------------------------

function TLjbBase64.MimeDecodePartial(const InputBuffer; const InputBytesCount:Cardinal;
    out OutputBuffer; var ByteBuffer:Cardinal; var ByteBufferSpace:Cardinal):Cardinal;
var
    lByteBuffer, lByteBufferSpace, c:Cardinal;
    InPtr, OuterLimit:^Byte;
    OutPtr:PByte3;
begin
    if InputBytesCount > 0 then
    begin
        InPtr := @InputBuffer;
        Cardinal(OuterLimit) := Cardinal(InPtr) + InputBytesCount;
        OutPtr := @OutputBuffer;
        lByteBuffer := ByteBuffer;
        lByteBufferSpace := ByteBufferSpace;
        while InPtr <> OuterLimit do
        begin
            c := MIME_DECODE_TABLE[InPtr^];
            Inc(InPtr);
            if c = $FF then Continue;
            lByteBuffer := lByteBuffer shl 6;
            lByteBuffer := lByteBuffer or c;
            Dec(lByteBufferSpace);
            if lByteBufferSpace <> 0 then Continue;
            OutPtr^.b3 := Byte(lByteBuffer);
            lByteBuffer := lByteBuffer shr 8;
            OutPtr^.b2 := Byte(lByteBuffer);
            lByteBuffer := lByteBuffer shr 8;
            OutPtr^.b1 := Byte(lByteBuffer);
            lByteBuffer := 0;
            Inc(OutPtr);
            lByteBufferSpace := 4;
        end;
        ByteBuffer := lByteBuffer;
        ByteBufferSpace := lByteBufferSpace;
        Result := Cardinal(OutPtr) - Cardinal(@OutputBuffer);
    end
    else
        Result := 0;
end;
//--------------------------------------------------------------

function TLjbBase64.MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer:Cardinal;
    const ByteBufferSpace:Cardinal):Cardinal;
var
    lByteBuffer:Cardinal;
begin
    case ByteBufferSpace of
        1:
            begin
                lByteBuffer := ByteBuffer shr 2;
                PByte3(@OutputBuffer)^.b2 := Byte(lByteBuffer);
                lByteBuffer := lByteBuffer shr 8;
                PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
                Result := 2;
            end;
        2:
            begin
                lByteBuffer := ByteBuffer shr 4;
                PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
                Result := 1;
            end;
    else
        Result := 0;
    end;
end;
//--------------------------------------------------------------

procedure TLjbBase64.Base64EncodeFile(InputFile, OutputFile:string);
var
    Ms:TMemoryStream;
    Ss:TStringStream;
    Str:string;
    List:TStringList;
begin {Base64 encode}
    Ms := TMemoryStream.Create;
    try
        Ms.LoadFromFile(InputFile);
        Ss := TStringStream.Create(Str);
        try
            MimeEncodeStream(Ms, Ss);
            List := TStringList.Create;
            try
                List.Text := Ss.DataString;
                List.SaveToFile(OutputFile);
            finally
                List.Free;
            end;
        finally
            Ss.Free;
        end;
    finally
        Ms.Free;
    end;
end;
//--------------------------------------------------------------

procedure TLjbBase64.Base64DecodeFile(InputFile, OutputFile:string);
var
    Ms:TMemoryStream;
    Ss:TStringStream;
    List:TStringList;
begin {Base64 decode}
    List := TStringList.Create;
    try
        List.LoadFromFile(InputFile);
        Ss := TStringStream.Create(List.Text);
        try
            Ms := TMemoryStream.Create;
            try
                MimeDecodeStream(Ss, Ms);
                Ms.SaveToFile(OutputFile);
            finally
                Ms.Free;
            end;
        finally
            Ss.Free;
        end;
    finally
        List.Free;
    end;
end;
//--------------------------------------------------------------
end.

