unit usbsvc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  System.Win.Registry, IdIPWatch,
  System.IniFiles;

const
  IniFileName:string='usblock.ini';


type
  TUSBService = class(TService)
    Client: TIdTCPClient;
    IdIPWatch: TIdIPWatch;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    FHWnd: HWND; // дескриптор невидимого окна
    ConfigFile:TIniFile;
    ConfigFileName:string;
    Host: string;
    Port: word;
  public
    function GetServiceController: TServiceController; override;
    procedure WndMethod(var Msg : TMessage);
  end;

var
  USBService: TUSBService;

const
  DBT_DEVICEARRIVAL          = $8000;          // Система обнаружила новое устройство
  DBT_DEVICEREMOVECOMPLETE   = $8004;          // Отключили устройство
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;      // class
  DBT_DEVTYP_VOLUME = $00000002;


implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  USBService.Controller(CtrlCode);
end;

function TUSBService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure UsbOff;
var
  Reg:TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\USBSTOR', false);
    Reg.WriteInteger('Start',4);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure UsbOn;
var
  Reg:TRegistry;
begin
  Exit;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\USBSTOR', false);
    Reg.WriteInteger('Start',3);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;

end;

procedure TUSBService.ServiceAfterInstall(Sender: TService);
begin
// Исправление реестра
//Компьютер\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR
   UsbOff;
end;


procedure TUSBService.ServiceCreate(Sender: TObject);
begin
  ConfigFileName:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+IniFileName;
  ConfigFile:=TIniFile.Create(ConfigFileName);
  Port:=ConfigFile.ReadInteger('client','port',2023);
  ConfigFile.WriteInteger('client','port',Port);
  Host:=ConfigFile.ReadString('client','host','127.0.0.1');
  ConfigFile.WriteString('client','host',Host);
  Client.Port:= Port;
  Client.Host:= Host;

  FHWnd := AllocateHWnd(WndMethod);
end;

procedure TUSBService.ServiceDestroy(Sender: TObject);
begin
  DeAllocateHWnd(FHWnd);
end;

procedure TUSBService.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    try
      try
        Sleep(1000);
        ServiceThread.ProcessRequests(false);
      except
         Sleep(10000);
         Continue;
// Сервер исчез
      end;
    finally
      if Client.Connected then
      begin
        Client.IOHandler.InputBuffer.Clear; //!
        Client.IOHandler.CloseGracefully;
        Client.Disconnect;
      end;
    end;
  end;

end;

function ReadComputerName: string;
var
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, Size);
  GetComputerName(PChar(Result), Size);
  // Урезаем строку до действительной длины имени компьютера
  SetLength(Result, Size);
end;

procedure TUSBService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  UsbOff();
end;

procedure TUSBService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
//  UsbOn();
end;

procedure TUSBService.WndMethod(var Msg: TMessage);
begin
  if Msg.Msg=WM_DEVICECHANGE then
  begin
    UsbOff();
    if (Msg.wParam = 7) then
    begin
      try
        try
          Client.Connect;
          Client.Socket.Writeln(DateTimeToStr(Now())+ ','+ReadComputerName+','+IdIpWatch.LocalIP+','+'USB_flash_operation');
        except

        end;
      finally
        if Client.Connected then
        begin
          Client.IOHandler.InputBuffer.Clear; //!
          Client.IOHandler.CloseGracefully;
          Client.Disconnect;
        end;
      end;
    end;
  end;
end;

end.
