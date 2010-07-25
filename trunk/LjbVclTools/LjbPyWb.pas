unit LjbPyWb;

interface
uses
  Windows,StrUtils,Classes,SysUtils;
{$R wbtext.res} //��Դ�ļ�������
type
    TLjbPyWb = class(TComponent)
    private
        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function LjbGetPyWb(hzstr:string; pytype:integer):string; //���ܣ��õ����ֵ���ʡ�ƴ������  ��֧�� 7500�����塢���庺�֣� ԭ��ͨ����ѯ��Դ�ļ� wbtext.rec �õ�����
// pytype 1: ƴ��  2�����  3: ƴ������  4����ʼ���
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
        //################### ���ֲ�ѯ��λ
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

        outstr := ''; //��ȡ����
        if tqtype = 1 then
        begin
            for i := pos('��', str) + 2 to pos('��', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 2 then
        begin
            for i := pos('��', str) + 2 to pos('��', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 3 then
        begin
            for i := pos('��', str) + 2 to pos('��', str) - 1 do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;

        if tqtype = 4 then
        begin
            for i := pos('��', str) + 2 to length(str) do
                if str[i] <> '' then if outstr = '' then outstr := str[i] else outstr := outstr + str[i];
        end;
        Result := trim(outstr);
    end;

begin
    //������Դ�ļ�,�����ݸ�ֵ�� s
    ss := TStringList.Create;
    hh := FindResource(hInstance, 'mywb', 'TXT');
    hh := LoadResource(hInstance, hh);
    pp := LockResource(hh);
    ss.Text := pchar(pp);
    UnLockResource(hh);
    FreeResource(hh);

    allstr := '';
    i := 0;
    while i <= length(hzstr) do //��ȡ�����ַ�
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
 