{-------------------------------------------------------------------------------

   ��Ԫ: AccessCtrls.pas

   ����: Ҧ�Ƿ� - yaoqiaofeng@sohu.com

   ����: 2004.11.28 

   �汾: 1.00

   ˵��: ����һ���������ݿ�����ĺ�����

-------------------------------------------------------------------------------}


unit AccessCtrls;


interface


uses

  Windows, SysUtils, Classes, DB, ADODB, ComCtrls, ActiveX, ComObj;


// ConnectedDataBase �������ݿ�

function ConnectedDataBase(ADOConnection: TADOConnection;

  const DataBase, Password : string;

  const UserName : string = 'Admin';

  const UserPassword : string = '';

  const NewPassword : string = ''

  ): boolean;

// AccessCreateDatabase ����Access���ݿ⣬����ļ�������ʧ��

function AccessCreateDatabase(const DataBase, PassWord : string): boolean;

// AccessCompactDatabase ѹ�����޸�Access���ݿ⣬����Դ�ļ�

function AccessCompactDatabase(const DataBase, PassWord : string): boolean;


implementation


function ConnectedDataBase(ADOConnection: TADOConnection;

  const DataBase, Password : string;

  const UserName : string = 'Admin';

  const UserPassword : string = '';

  const NewPassword : string = ''

  ): boolean;

const

  {TADOConnection �������ݿ�Ĳ���}

  ADOLinkString = 'Provider=Microsoft.Jet.OLEDB.4.0;'

    + 'Password=%s;'                           // �û�������(*.mdw)����

    + 'User ID=%s;'                            // �û�������(*.mdw)�û���Admin

    + 'Data Source=%s;'                        // ���ݿ��ļ�(*.mdb)λ��

    + 'Persist Security Info=True;'

    + 'Mode=ReadWrite;'                         // ���ݿ�򿪷�ʽ

    + 'Extended Properties="";'                 // Ĭ��ֵΪ��

    + 'Jet OLEDB:System Database="";'           // �û��������ļ�

    + 'Jet OLEDB:Registry Path="";'             // ע��·��

    + 'Jet OLEDB:Database Password=%s;'         // ���ݿ�����

    + 'Jet OLEDB:Engine Type=1;'

    + 'Jet OLEDB:Database Locking Mode=1;'

    + 'Jet OLEDB:Global Partial Bulk Ops=2;'

    + 'Jet OLEDB:Global Bulk Transactions=1;'

    + 'Jet OLEDB:New Database Password=%s;'    // ����

    + 'Jet OLEDB:Create System Database=False;'

    + 'Jet OLEDB:Encrypt Database=False;'

    + 'Jet OLEDB:Don''t Copy Locale on Compact=False;'

    + 'Jet OLEDB:Compact Without Replica Repair=False;'

    + 'Jet OLEDB:SFP=False';

begin

  result := False;

  if FileExists(DataBase) then

  begin

    ADOConnection.ConnectionString := Format(ADOLinkString, [UserPassword,

      UserName, DataBase, PassWord, NewPassWord]);

    try

      ADOConnection.Connected := True;

    finally

      result := ADOConnection.Connected;

    end;

  end;

end;

function GetTempPathFileName: string;

var

  SPath,SFile:array [0..254] of char;

begin

  GetTempPath(254,SPath);

  GetTempFileName(SPath,'~SM',0,SFile);

  result:=SFile;

  DeleteFile(result);

end;

const

  SConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;'

    + 'Data Source=%s;'

    + 'Jet OLEDB:Database Password=%s;';

function AccessCompactDatabase(const DataBase, PassWord : string): boolean;

//ѹ�����޸����ݿ�,����Դ�ļ�

var

  STempFileName:string;

  vJE:OleVariant;

begin

  STempFileName:=GetTempPathFileName;

  try

    vJE:=CreateOleObject('JRO.JetEngine');

    vJE.CompactDatabase(format(SConnectionString,[DataBase,PassWord]),

      format(SConnectionString,[STempFileName,PassWord]));

    result:=CopyFile(PChar(STempFileName), PChar(DataBase), false);

    DeleteFile(STempFileName);

  except

    result:=false;

  end;

end;

function AccessCreateDatabase(const DataBase, PassWord : string): boolean;

//����Access�ļ�������ļ�������ʧ��

var

  STempFileName:string;

  vCatalog:OleVariant;

begin

  STempFileName:=GetTempPathFileName;

  try

    vCatalog:=CreateOleObject('ADOX.Catalog');

    vCatalog.Create(format(SConnectionString,[STempFileName,PassWord]));

    result:=CopyFile(PChar(STempFileName),PChar(DataBase),True);

    DeleteFile(STempFileName);

  except

    result:=false;

  end;

end;

procedure RenameField(ADOConnection: TADOConnection;

  const TableName, OldFieldName, NewFieldName: string);

var DB, Col: OleVariant;

begin

  DB := CreateOleObject('ADOX.Catalog');

  DB.ActiveConnection := ADOConnection.ConnectionObject;

  Col := CreateOleObject('ADOX.Column');

  Col := DB.Tables[TableName].Columns[OldFieldName];

  Col.Name := NewFieldName;

end;

procedure RenameTable(ADOConnection: TADOConnection;

  const OldTableName, NewTableName : string);

var

  DB: OleVariant;

begin

  DB := CreateOleObject('ADOX.Catalog');

  DB.ActiveConnection := ADOConnection.ConnectionObject;

  DB.Tables[OldTableName].Name := NewTableName;

end;


end.
