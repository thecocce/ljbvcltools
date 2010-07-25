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
        function LjbRound(const yuan:Extended; const pp:Integer):Extended; //四舍五入
    end;

procedure Register;
  
implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbRound]);
end;
//--------------------------------------------------------------
function TLjbRound.LjbRound(const yuan:Extended; const pp:Integer):Extended; //四舍五入
//yuan:原浮点数，PP保留 小数点后第几位
var
    p, l, m, l2:Longint;
    s:string; // 原浮点数
    sq:string; // 小数点前
    sh:string; //小数点后
begin
    if yuan = 0 then exit; // 原浮点数 0
    if pp < 0 then exit; //非法小数点后第几位
    s := floattostr(yuan);
    p := pos('.', s); //小数点位置
    sq := midstr(s, 1, p - 1);
    sh := midstr(s, p + 1, length(s) - length(sq) - 1);
    l := length(sh); //小数位数
    l2 := length(sq); //整数位数
    if pp >= l then
    begin //0
        result := strtofloat(s);
        exit; //比如 11。06 要保留到 小数点后第3位显然 不合理
    end; //
    { if pp=l then  //比如 11。06 要保留到 小数点后第2位不用处理 直接返回
       begin//1
         Result:=s;
         exit;
       end;//1 }
    if pp < l then //比如 11。06 要保留到 小数点后第1位 ，。。。
    begin //2
        m := strtoint(sh[pp + 1]);
        if m >= 5 then
        begin
            if pp >= 1 then //保留到 小数点后第1，2。。。位
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
            else //保留到 小数点后第0位
            begin //4
                sq[l2] := chr(ord(sq[l2]) + 1);
                Result := strtofloat(sq);
                exit;
            end; //4
        end
        else
        begin
            if pp >= 1 then //保留到 小数点后第1，2。。。位
            begin //3
                sh := midstr(sh, 1, pp);
                Result := strtofloat(sq + '.' + sh);
                exit;
            end //3
            else //保留到 小数点后第0位
            begin //4
                Result := strtofloat(sq);
                exit;
            end; //4
        end;
    end; //2
end;
end.
