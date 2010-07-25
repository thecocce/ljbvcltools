unit LjbRound;

interface
uses
  StrUtils,Classes,SysUtils;

type
    TLjbRound = class(TComponent)
    private
        { Private declarations }
    protected
        { Protected declarations }
    public
        { Public declarations }
    published
        function LjbRound(const yuan:Extended; const pp:Integer):Extended; //��������
    end;

procedure Register;
  
implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbRound]);
end;
//--------------------------------------------------------------
function TLjbRound.LjbRound(const yuan:Extended; const pp:Integer):Extended; //��������
//yuan:ԭ��������PP���� С�����ڼ�λ
var
    p, l, m, l2:Longint;
    s:string; // ԭ������
    sq:string; // С����ǰ
    sh:string; //С�����
begin
    if yuan = 0 then exit; // ԭ������ 0
    if pp < 0 then exit; //�Ƿ�С�����ڼ�λ
    s := floattostr(yuan);
    p := pos('.', s); //С����λ��
    sq := midstr(s, 1, p - 1);
    sh := midstr(s, p + 1, length(s) - length(sq) - 1);
    l := length(sh); //С��λ��
    l2 := length(sq); //����λ��
    if pp >= l then
    begin //0
        result := strtofloat(s);
        exit; //���� 11��06 Ҫ������ С������3λ��Ȼ ������
    end; //
    { if pp=l then  //���� 11��06 Ҫ������ С������2λ���ô��� ֱ�ӷ���
       begin//1
         Result:=s;
         exit;
       end;//1 }
    if pp < l then //���� 11��06 Ҫ������ С������1λ ��������
    begin //2
        m := strtoint(sh[pp + 1]);
        if m >= 5 then
        begin
            if pp >= 1 then //������ С������1��2������λ
            begin //3
                sh := midstr(sh, 1, pp);
                sh := inttostr(strtoint(sh) + 1);
                if length(sh) > pp then
                begin
                    sh := midstr(sh, 2, pp);
                    sq := inttostr(strtoint(sq) + 1);
                end;
                Result := strtofloat(sq + '.' + sh);
                exit;
            end //3
            else //������ С������0λ
            begin //4
                sq[l2] := chr(ord(sq[l2]) + 1);
                Result := strtofloat(sq);
                exit;
            end; //4
        end
        else
        begin
            if pp >= 1 then //������ С������1��2������λ
            begin //3
                sh := midstr(sh, 1, pp);
                Result := strtofloat(sq + '.' + sh);
                exit;
            end //3
            else //������ С������0λ
            begin //4
                Result := strtofloat(sq);
                exit;
            end; //4
        end;
    end; //2
end;
end.
