unit Unit1;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ZConnection, DB, ZAbstractRODataset, ZAbstractDataset,
    ZDataset, LjbSql, Grids, DBGrids;

type
    TForm1 = class(TForm)
        ZConnection1: TZConnection;
        Button1: TButton;
        DataSource1: TDataSource;
        DBGrid1: TDBGrid;
        LjbQuery1: TLjbQuery;
        Button2: TButton;
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    LjbQuery1.LjbInsertSql('tb_user', 'user_uid', QuotedStr('gogogo'));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    LjbQuery1.LjbUpdateSql('tb_user', 'user_uid,user_password',
        QuotedStr('Jack2006') + ',' + QuotedStr('Œ“µƒ√‹¬Î'));
end;

end.

