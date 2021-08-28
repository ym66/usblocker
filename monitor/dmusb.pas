unit dmusb;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DBClient, Data.DbxSqlite, Data.SqlExpr,
  Data.FMTBcd, Data.DB, System.StrUtils;

type
  TUSBdm = class(TDataModule)
    SQLConnection: TSQLConnection;
    SQLQuery: TSQLQuery;
  private

  public
    procedure CreateTable;
    procedure Save(SL: TStringList);
  end;

var
  USBdm: TUSBdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TUSBdm }

procedure TUSBdm.CreateTable;
var
  SL: TStringList;
begin
  SL:= TStringList.Create;
  try
    try
      SQLConnection.GetTableNames(SL);
      if SL.IndexOf('data')=-1 then
      begin
        SQLQuery.SQL.Clear;
        SQLQuery.SQL.Add('CREATE TABLE data (Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,');
        SQLQuery.SQL.Add('Date NVARCHAR (50),');
        SQLQuery.SQL.Add('Ip NVARCHAR (50),');
        SQLQuery.SQL.Add('Host NVARCHAR (50),');
        SQLQuery.SQL.Add('Remark NVARCHAR (50))');
        SQLQuery.ExecSQL();
      end;
    except
    end;
  finally
    SL.Free;
  end;
end;

procedure TUSBdm.Save(SL: TStringList);
var
  Date, Ip, Host: string;
  SqlStr: string;
begin
  SL.Delimiter:=',';
  SL.StrictDelimiter:= true;
  Date:= SplitString(SL.DelimitedText, ',')[0];
  Host:= SplitString(SL.DelimitedText, ',')[1];
  Ip:= SplitString(SL.DelimitedText, ',')[2];
  SqlStr:= 'INSERT INTO data (Date, Ip, Host) VALUES(' + QuotedStr(Date)+','+ QuotedStr(Ip)+','+ QuotedStr(Host)+')';
  SQLConnection.ExecuteDirect(SqlStr);
end;

end.
