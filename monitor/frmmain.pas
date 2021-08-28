unit frmmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.SyncObjs,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, System.Win.ScktComp,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdContext,IdGlobal,
  System.IniFiles, dmUsb, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Data.SqlExpr, Data.DbxSqlite;

const
  IniFileName:string='monitor.ini';


type
  TMainForm = class(TForm)
    PnlButtons: TPanel;
    StatusBar: TStatusBar;
    Button1: TButton;
    PnlLeft: TPanel;
    Splitter: TSplitter;
    PnlRight: TPanel;
    MainMenu: TMainMenu;
    A1: TMenuItem;
    N1: TMenuItem;
    ActionList: TActionList;
    ActExit: TAction;
    lbReceive: TListBox;
    Server: TIdTCPServer;
    lblMessages: TLabel;
    btnClear: TButton;
    ActClear: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ActExitExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ServerConnect(AContext: TIdContext);
    procedure ServerExecute(AContext: TIdContext);
    procedure ActClearExecute(Sender: TObject);
  private
    Section : TCriticalSection;

    ConfigFile:TIniFile;
    ConfigFileName:string;
    Port:word;

    procedure StartServer;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ActClearExecute(Sender: TObject);
begin
  LbReceive.Items.Clear;
end;

procedure TMainForm.ActExitExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//  dm.PrepareDataSet;
  StatusBar.Panels[0].Text:= 'Сервер отключен';
  USBdm.CreateTable;
  Section := TCriticalSection.Create;

  ConfigFileName:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+IniFileName;
  ConfigFile:=TIniFile.Create(ConfigFileName);
  Port:=ConfigFile.ReadInteger('server','port',2023);
  ConfigFile.WriteInteger('server','port',Port);
  StartServer;
  StatusBar.Panels[0].Text:= 'Сервер работает';
end;



procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Section.Free;
end;

procedure TMainForm.ServerConnect(AContext: TIdContext);
begin
   btnClear.Enabled:=false;
   Section.Enter;
//   lbReceive.Items.Add(AContext.Connection.Socket.Binding.PeerIP);
 //  lbReceive.Items.Add('Новое собщение');
   Section.Leave;
   btnClear.Enabled:=true;
end;

procedure TMainForm.ServerExecute(AContext: TIdContext);
var
  S: String;
  SL: TStringList;
begin
  SL:= TStringList.Create;
  SL.Delimiter:=',';
  SL.StrictDelimiter := true;
  try
    S:= AContext.Connection.Socket.Readln(IndyTextEncoding_UTF8());
    AContext.Connection.Socket.WriteLn('OK'); //ответ
    Section.Enter;
    SL.DelimitedText:=S;
    USBdm.Save(SL);
    lbReceive.Items.DelimitedText:=lbReceive.Items.DelimitedText+SL.DelimitedText;
    lbReceive.Items.Add('-----------------');
    lbReceive.Items.Add('');
    Section.Leave;
    AContext.Connection.Disconnect;
  finally
    SL.Free;
  end;
end;

procedure TMainForm.StartServer;
begin
  Server.DefaultPort:=Port;//2023;//указываем порт сервера
  Server.Active:=True;//активируем его
end;

end.
