unit LjbIniFiles;

interface
uses
    Classes, Inifiles;

type
    TLjbIniFiles = class(TComponent)
    private
    { Private declarations }
    protected
    { Protected declarations }
    public
    { Public declarations }
    published
        function IniRead(AppFilePath, str1, str2: string): string;
        procedure IniWrite(AppFilePath, str1, str2, str3: string);
        function IniReadSectionValues(AppFilePath, str1: string; var ValueList: TStrings): TStrings;
        function IniReadSection(AppFilePath, str1: string; var ValueList: TStrings): TStrings;
        function IniReadSections(AppFilePath:string; var ValueList: TStrings): TStrings;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbIniFiles]);
end;
//--------------------------------------------------------------

function TLjbIniFiles.IniRead(AppFilePath, str1, str2: string): string;
var MyIni: Tinifile;
    S: Pchar;
begin
    S := nil;
    MyIni := Tinifile.Create(AppFilePath);
    IniRead := MyIni.ReadString(str1, str2, S);
    Myini.Destroy;
end;
//--------------------------------------------------------------

procedure TLjbIniFiles.IniWrite(AppFilePath, str1, str2, str3: string);
var MyIni: Tinifile;
begin
    MyIni := Tinifile.Create(AppFilePath);
    MyIni.writestring(str1, str2, str3);
    Myini.Destroy;
end;
//--------------------------------------------------------------

function TLjbIniFiles.IniReadSectionValues(AppFilePath, str1: string; var ValueList: TStrings): TStrings;
var MyIni: Tinifile;

begin
    ValueList:=TStringList.Create;
    MyIni := Tinifile.Create(AppFilePath);
    MyIni.ReadSectionValues(str1, ValueList);
    Myini.Destroy;
end;
//--------------------------------------------------------------
//--------------------------------------------------------------

function TLjbIniFiles.IniReadSection(AppFilePath, str1: string; var ValueList: TStrings): TStrings;
var MyIni: Tinifile;

begin
    ValueList:=TStringList.Create;
    MyIni := Tinifile.Create(AppFilePath);
    MyIni.ReadSection(str1, ValueList);
    Myini.Destroy;
end;
//--------------------------------------------------------------

function TLjbIniFiles.IniReadSections(AppFilePath:string; var ValueList: TStrings): TStrings;
var MyIni: Tinifile;

begin
    ValueList:=TStringList.Create;
    MyIni := Tinifile.Create(AppFilePath);
    MyIni.ReadSections(ValueList);
    Myini.Destroy;
end;
//--------------------------------------------------------------
end.

 