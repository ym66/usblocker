object USBService: TUSBService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'USBLock'
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
  object Client: TIdTCPClient
    ConnectTimeout = 0
    Host = '127.0.0.1'
    Port = 2023
    ReadTimeout = -1
    Left = 56
    Top = 48
  end
  object IdIPWatch: TIdIPWatch
    Active = True
    HistoryEnabled = False
    HistoryFilename = 'iphist.dat'
    Left = 112
    Top = 48
  end
end
