{-------------------------------------------------------------------------------

   单元: AccessCtrls.pas

   作者: 姚乔锋 - yaoqiaofeng@sohu.com

   日期: 2004.11.28 

   版本: 1.00

   说明: 这是一个关于数据库操作的函数库

-------------------------------------------------------------------------------}


unit AccessCtrls;


interface


uses

  Windows, SysUtils, Classes, DB, ADODB, ComCtrls, ActiveX, ComObj;


// ConnectedDataBase 连接数据库

function ConnectedDataBase(ADOConnection: TADOConnection;

  const DataBase, Password : string;

  const UserName : string = 'Admin';

  const UserPassword : string = '';

  const NewPassword : string = ''

  ): boolean;

// AccessCreateDatabase 建立Access数据库，如果文件存在则失败

function AccessCreateDatabase(const DataBase, PassWord : string): boolean;

// AccessCompactDatabase 压缩与修复Access数据库，覆盖源文件

function AccessCompactDatabase(const DataBase, PassWord : string): boolean;


implementation


function ConnectedDataBase(ADOConnection: TADOConnection;

  const DataBase, Password : string;

  const UserName : string = 'Admin';

  const UserPassword : string = '';

  const NewPassword : string = ''

  ): boolean;

const

  {TADOConnection 连接数据库的参数}

  ADOLinkString = 'Provider=Microsoft.Jet.OLEDB.4.0;'

    + 'Password=%s;'                           // 用户工作组(*.mdw)密码

    + 'User ID=%s;'                            // 用户工作组(*.mdw)用户名Admin

    + 'Data Source=%s;'                        // 数据库文件(*.mdb)位置

    + 'Persist Security Info=True;'

    + 'Mode=ReadWrite;'                         // 数据库打开方式

    + 'Extended Properties="";'                 // 默认值为空

    + 'Jet OLEDB:System Database="";'           // 用户工作组文件

    + 'Jet OLEDB:Registry Path="";'             // 注册路径

    + 'Jet OLEDB:Database Password=%s;'         // 数据库密码

    + 'Jet OLEDB:Engine Type=1;'

    + 'Jet OLEDB:Database Locking Mode=1;'

    + 'Jet OLEDB:Global Partial Bulk Ops=2;'

    + 'Jet OLEDB:Global Bulk Transactions=1;'

    + 'Jet OLEDB:New Database Password=%s;'    // 密码

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

//压缩与修复数据库,覆盖源文件

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

//建立Access文件，如果文件存在则失败

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
