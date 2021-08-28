object USBdm: TUSBdm
  OldCreateOrder = False
  Height = 150
  Width = 215
  object SQLConnection: TSQLConnection
    ConnectionName = 'SQLITECONNECTION'
    DriverName = 'Sqlite'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Sqlite'
      'Database=test.db'
      'FailIfMissing=false'
      'Host=localhost')
    Left = 24
    Top = 96
  end
  object SQLQuery: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection
    Left = 96
    Top = 96
  end
end
