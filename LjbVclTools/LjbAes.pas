(**************************************************)
(*                                                *)
(*                                                *)
(*                                                *)
(*˵����                                          *)
(*                                                *)
(*   ���� ElASE.pas ��Ԫ��װ                      *)
(*                                                *)
(*   ����һ�� AES �����㷨�ı�׼�ӿڡ�            *)
(*                                                *)
(*                                                *)
(*                                                *)
               (*   ֧�� 128 / 192 / 256 λ���ܳ�                *)
(*   Ĭ������°��� 128 λ�ܳײ���                *)
(*                                                *)
(**************************************************)

unit LjbAes;

interface

uses
    SysUtils, Classes, Math, ElAES;

type
    TKeyBit = (kb128, kb192, kb256);
    TLjbAes = class(TComponent)
    private
        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function StrToHex(Value:string):string;
        function HexToStr(Value:string):string;
        function EncryptString(Value:string; Key:string;
            KeyBit:TKeyBit = kb128):string;
        function DecryptString(Value:string; Key:string;
            KeyBit:TKeyBit = kb128):string;
        function EncryptStream(Stream:TStream; Key:string;
            KeyBit:TKeyBit = kb128):TStream;
        function DecryptStream(Stream:TStream; Key:string;
            KeyBit:TKeyBit = kb128):TStream;
        procedure EncryptFile(SourceFile, DestFile:string;
            Key:string; KeyBit:TKeyBit = kb128);
        procedure DecryptFile(SourceFile, DestFile:string;
            Key:string; KeyBit:TKeyBit = kb128);
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbAes]);
end;

function TLjbAes.StrToHex(Value:string):string;
var
    I:Integer;
begin
    Result := '';
    for I := 1 to Length(Value) do
        Result := Result + IntToHex(Ord(Value[I]), 2);
end;

function TLjbAes.HexToStr(Value:string):string;
var
    I:Integer;
begin
    Result := '';
    for I := 1 to Length(Value) do
    begin
        if ((I mod 2) = 1) then
            Result := Result + Chr(StrToInt('0x' + Copy(Value, I, 2)));
    end;
end;

{  --  �ַ������ܺ��� Ĭ�ϰ��� 128 λ�ܳ׼��� --  }

function TLjbAes.EncryptString(Value:string; Key:string;
    KeyBit:TKeyBit = kb128):string;
var
    SS, DS:TStringStream;
    Size:Int64;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    Result := '';
    SS := TStringStream.Create(Value);
    DS := TStringStream.Create('');
    try
        Size := SS.Size;
        DS.WriteBuffer(Size, SizeOf(Size));
        {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
        if KeyBit = kb128 then
        begin
            FillChar(AESKey128, SizeOf(AESKey128), 0);
            Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
            EncryptAESStreamECB(SS, 0, AESKey128, DS);
        end;
        {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
        if KeyBit = kb192 then
        begin
            FillChar(AESKey192, SizeOf(AESKey192), 0);
            Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
            EncryptAESStreamECB(SS, 0, AESKey192, DS);
        end;
        {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
        if KeyBit = kb256 then
        begin
            FillChar(AESKey256, SizeOf(AESKey256), 0);
            Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
            EncryptAESStreamECB(SS, 0, AESKey256, DS);
        end;
        Result := StrToHex(DS.DataString);
    finally
        SS.Free;
        DS.Free;
    end;
end;

{  --  �ַ������ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }

function TLjbAes.DecryptString(Value:string; Key:string;
    KeyBit:TKeyBit = kb128):string;
var
    SS, DS:TStringStream;
    Size:Int64;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    Result := '';
    SS := TStringStream.Create(HexToStr(Value));
    DS := TStringStream.Create('');
    try
        Size := SS.Size;
        SS.ReadBuffer(Size, SizeOf(Size));
        {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
        if KeyBit = kb128 then
        begin
            FillChar(AESKey128, SizeOf(AESKey128), 0);
            Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
            DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey128, DS);
        end;
        {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
        if KeyBit = kb192 then
        begin
            FillChar(AESKey192, SizeOf(AESKey192), 0);
            Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
            DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey192, DS);
        end;
        {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
        if KeyBit = kb256 then
        begin
            FillChar(AESKey256, SizeOf(AESKey256), 0);
            Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
            DecryptAESStreamECB(SS, SS.Size - SS.Position, AESKey256, DS);
        end;
        Result := DS.DataString;
    finally
        SS.Free;
        DS.Free;
    end;
end;

{  --  �����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }

function TLjbAes.EncryptStream(Stream:TStream; Key:string;
    KeyBit:TKeyBit = kb128):TStream;
var
    Count:Int64;
    OutStrm:TStream;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    OutStrm := TStream.Create;
    Stream.Position := 0;
    Count := Stream.Size;
    OutStrm.Write(Count, SizeOf(Count));
    try
        {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
        if KeyBit = kb128 then
        begin
            FillChar(AESKey128, SizeOf(AESKey128), 0);
            Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
            EncryptAESStreamECB(Stream, 0, AESKey128, OutStrm);
        end;
        {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
        if KeyBit = kb192 then
        begin
            FillChar(AESKey192, SizeOf(AESKey192), 0);
            Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
            EncryptAESStreamECB(Stream, 0, AESKey192, OutStrm);
        end;
        {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
        if KeyBit = kb256 then
        begin
            FillChar(AESKey256, SizeOf(AESKey256), 0);
            Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
            EncryptAESStreamECB(Stream, 0, AESKey256, OutStrm);
        end;
        Result := OutStrm;
    finally
        OutStrm.Free;
    end;
end;

{  --  �����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }

function TLjbAes.DecryptStream(Stream:TStream; Key:string;
    KeyBit:TKeyBit = kb128):TStream;
var
    Count, OutPos:Int64;
    OutStrm:TStream;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    OutStrm := TStream.Create;
    Stream.Position := 0;
    OutPos := OutStrm.Position;
    Stream.ReadBuffer(Count, SizeOf(Count));
    try
        {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
        if KeyBit = kb128 then
        begin
            FillChar(AESKey128, SizeOf(AESKey128), 0);
            Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
            DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
                AESKey128, OutStrm);
        end;
        {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
        if KeyBit = kb192 then
        begin
            FillChar(AESKey192, SizeOf(AESKey192), 0);
            Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
            DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
                AESKey192, OutStrm);
        end;
        {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
        if KeyBit = kb256 then
        begin
            FillChar(AESKey256, SizeOf(AESKey256), 0);
            Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
            DecryptAESStreamECB(Stream, Stream.Size - Stream.Position,
                AESKey256, OutStrm);
        end;
        OutStrm.Size := OutPos + Count;
        OutStrm.Position := OutPos;
        Result := OutStrm;
    finally
        OutStrm.Free;
    end;
end;

{  --  �ļ����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }

procedure TLjbAes.EncryptFile(SourceFile, DestFile:string;
    Key:string; KeyBit:TKeyBit = kb128);
var
    SFS, DFS:TFileStream;
    Size:Int64;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    SFS := TFileStream.Create(SourceFile, fmOpenRead);
    try
        DFS := TFileStream.Create(DestFile, fmCreate);
        try
            Size := SFS.Size;
            DFS.WriteBuffer(Size, SizeOf(Size));
            {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
            if KeyBit = kb128 then
            begin
                FillChar(AESKey128, SizeOf(AESKey128), 0);
                Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
                EncryptAESStreamECB(SFS, 0, AESKey128, DFS);
            end;
            {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
            if KeyBit = kb192 then
            begin
                FillChar(AESKey192, SizeOf(AESKey192), 0);
                Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
                EncryptAESStreamECB(SFS, 0, AESKey192, DFS);
            end;
            {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
            if KeyBit = kb256 then
            begin
                FillChar(AESKey256, SizeOf(AESKey256), 0);
                Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
                EncryptAESStreamECB(SFS, 0, AESKey256, DFS);
            end;
        finally
            DFS.Free;
        end;
    finally
        SFS.Free;
    end;
end;

{  --  �ļ����ܺ��� Ĭ�ϰ��� 128 λ�ܳ׽��� --  }

procedure TLjbAes.DecryptFile(SourceFile, DestFile:string;
    Key:string; KeyBit:TKeyBit = kb128);
var
    SFS, DFS:TFileStream;
    Size:Int64;
    AESKey128:TAESKey128;
    AESKey192:TAESKey192;
    AESKey256:TAESKey256;
begin
    SFS := TFileStream.Create(SourceFile, fmOpenRead);
    try
        SFS.ReadBuffer(Size, SizeOf(Size));
        DFS := TFileStream.Create(DestFile, fmCreate);
        try
            {  --  128 λ�ܳ���󳤶�Ϊ 16 ���ַ� --  }
            if KeyBit = kb128 then
            begin
                FillChar(AESKey128, SizeOf(AESKey128), 0);
                Move(PChar(Key)^, AESKey128, Min(SizeOf(AESKey128), Length(Key)));
                DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey128, DFS);
            end;
            {  --  192 λ�ܳ���󳤶�Ϊ 24 ���ַ� --  }
            if KeyBit = kb192 then
            begin
                FillChar(AESKey192, SizeOf(AESKey192), 0);
                Move(PChar(Key)^, AESKey192, Min(SizeOf(AESKey192), Length(Key)));
                DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey192, DFS);
            end;
            {  --  256 λ�ܳ���󳤶�Ϊ 32 ���ַ� --  }
            if KeyBit = kb256 then
            begin
                FillChar(AESKey256, SizeOf(AESKey256), 0);
                Move(PChar(Key)^, AESKey256, Min(SizeOf(AESKey256), Length(Key)));
                DecryptAESStreamECB(SFS, SFS.Size - SFS.Position, AESKey256, DFS);
            end;
            DFS.Size := Size;
        finally
            DFS.Free;
        end;
    finally
        SFS.Free;
    end;
end;
end.

