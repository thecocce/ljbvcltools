unit LjbSql;

interface
uses
    Windows, SysUtils, Classes,
    Dialogs, ZConnection, DB, ZAbstractRODataset, ZAbstractDataset,
    ZDataset;

type
    TLjbQuery = class(TZQuery)
    private
        FRequestLive: Boolean;
        function LjbSplitString(const Source, ch: string): TStringList;
    public
        constructor Create(AOwner: TComponent); override;
        procedure LjbInsertSql(table_name, fields_name, values_name: string);
        procedure LjbUpdateSql(table_name, fields_name, values_name: string;
            where_name: string = '');
    published
        property RequestLive: Boolean read FRequestLive write FRequestLive;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('LjbTools', [TLjbQuery]);
end;

constructor TLjbQuery.Create(AOwner: TComponent);
begin
    inherited;
    FRequestLive := True;
end;

function TLjbQuery.LjbSplitString(const Source, ch: string): TStringList;
//根据字符串，拆分字符串，相当于vb中的split函数
var
    temp: string;
    i: Integer;
begin
    Result := TStringList.Create;
    //如果是空自符串则返回空列表
    if Source = '' then
        exit;
    temp := Source;
    i := pos(ch, Source);
    while i <> 0 do
    begin
        Result.add(copy(temp, 0, i - 1));
        System.Delete(temp, 1, i);
        i := pos(ch, temp);
    end;
    Result.add(temp);
end;

procedure TLjbQuery.LjbInsertSql(table_name, fields_name, values_name: string);
var
    ljbqry: TLjbQuery;
    sql: string;
begin
    sql := 'INSERT INTO ' + table_name + ' (' + fields_name + ') ' + 'VALUES ('
        + values_name + ')';
    try
        ljbqry := TLjbQuery.Create(nil);
        ljbqry.Connection := Self.Connection;
        ljbqry.SQL.Text := sql;
        ljbqry.ExecSQL;
    finally
        ljbqry.Free;
    end;

end;

procedure TLjbQuery.LjbUpdateSql(table_name, fields_name, values_name: string;
    where_name: string = '');
var
    ljbqry: TLjbQuery;
    sql: string;
    strLst1, strLst2: TStringList;
    str: string;
    i: integer;
begin
    strLst1 := TStringList.Create;
    strLst2 := TStringList.Create;
    strLst1 := LjbSplitString(fields_name, ',');
    strLst2 := LjbSplitString(values_name, ',');
    if strLst1.Count <> strLst2.Count then
    begin
        ShowMessage('fields_name和values_name的参数个数不一至');
        exit;
    end;
    for i := 1 to strLst1.Count do
    begin
        if i < strLst1.Count then
            str := str + strLst1[i - 1] + ' = ' + strLst2[i - 1] + ','
        else
            str := str + strLst1[i - 1] + ' = ' + strLst2[i - 1]
    end;
    if where_name <> '' then
        sql := 'UPDATE ' + table_name + ' SET ' + str + ' WHERE ' + where_name
    else
        sql := 'UPDATE ' + table_name + ' SET ' + str;
    try
        ljbqry := TLjbQuery.Create(nil);
        ljbqry.Connection := Self.Connection;
        ljbqry.SQL.Text := sql;
        ljbqry.ExecSQL;
    finally
        ljbqry.Free;
        strLst1.Free;
        strLst2.Free;
    end;

end;

end.

