unit LjbPyWb;

interface
uses
  Windows,StrUtils,Classes,SysUtils;
{$R wbtext.res} //资源文件，必须
type
    TLjbPyWb = class(TComponent)
    private
        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function LjbGetPyWb(hzstr:string; pytype:integer):string; //功能：得到汉字的五笔、拼音编码  （支持 7500个简体、繁体汉字） 原理：通过查询资源文件 wbtext.rec 得到编码
// pytype 1: 拼音  2：五笔  3: 拼音简码  4：五笔简码
    end;

procedure Register;
  
implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbPyWb]);
end;
//--------------------------------------------------------------

function TLjbPyWb.LjbGetPyWb(hzstr:string; pytype:integer):string;
var
    I:Integer;
    allstr:string;
    hh:THandle;
    pp:pointer;
    ss:TStringList;

    function retturn_wbpy(tempstr:string; tqtype:integer):string;
    var
        outstr, str:string;
        i:integer;
    begin
        //################### 汉字查询电位
        i := 0;
        while i <= ss.Count - 1 do
        begin
            str := ss.Strings[i];
            if (tempstr = trim(str[1] + str[2])) or (tempstr = trim(str[3] + str[4])) then
            begin
                str := ss.Strings[i];
                Break;
            end;
            i := i + 1;
        end;
        //###################

        outstr := ''; //提取编码
        if tqtype = 1 then
        begin
            for i := pos('①', str) + 2 to pos('②', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 2 then
        begin
            for i := pos('②', str) + 2 to pos('③', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 3 then
        begin
            for i := pos('③', str) + 2 to pos('④', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 4 then
        begin
            for i := pos('④', str) + 2 to length(str) do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;
        Result := trim(outstr);
    end;

begin
    //加载资源文件,将内容赋值给 s
    ss := TStringList.Create;
    hh := FindResource(hInstance, 'mywb', 'TXT');
    hh := LoadResource(hInstance, hh);
    pp := LockResource(hh);
    ss.Text := pchar(pp);
    UnLockResource(hh);
    FreeResource(hh);

    allstr := '';
    i := 0;
    while i <= length(hzstr) do //提取汉字字符
    begin
        if (Ord(hzstr[I]) > 127) then
        begin
            if allstr = '' then allstr := retturn_wbpy(hzstr[I] + hzstr[I + 1], pytype) else allstr := allstr + retturn_wbpy(hzstr[I] + hzstr[I + 1], pytype);
            i := i + 2;
        end
        else
        begin
            if allstr = '' then allstr := hzstr[I] else allstr := allstr + hzstr[I];
            i := i + 1;
        end;
    end;

    ss.Free;

    Result := trim(allstr);
end;
//--------------------------------------------------------------

end.
 