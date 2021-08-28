object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1052#1086#1085#1080#1090#1086#1088
  ClientHeight = 382
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 185
    Top = 0
    Height = 320
    ExplicitLeft = 320
    ExplicitTop = 128
    ExplicitHeight = 100
  end
  object PnlButtons: TPanel
    Left = 0
    Top = 320
    Width = 600
    Height = 40
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      600
      40)
    object Button1: TButton
      Left = 503
      Top = 6
      Width = 75
      Height = 25
      Action = ActExit
      Anchors = [akRight, akBottom]
      TabOrder = 0
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 360
    Width = 600
    Height = 22
    Panels = <
      item
        Width = 50
      end>
  end
  object PnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 320
    Align = alLeft
    BorderWidth = 10
    Constraints.MaxWidth = 500
    TabOrder = 2
    object lblMessages: TLabel
      Left = 11
      Top = 11
      Width = 163
      Height = 13
      Align = alTop
      Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1103
      ExplicitWidth = 58
    end
    object lbReceive: TListBox
      Left = 11
      Top = 24
      Width = 163
      Height = 285
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object PnlRight: TPanel
    Left = 188
    Top = 0
    Width = 412
    Height = 320
    Align = alClient
    TabOrder = 3
    DesignSize = (
      412
      320)
    object btnClear: TButton
      Left = 16
      Top = 289
      Width = 75
      Height = 25
      Action = ActClear
      Anchors = [akLeft, akBottom]
      TabOrder = 0
    end
  end
  object MainMenu: TMainMenu
    Left = 372
    Top = 24
    object A1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N1: TMenuItem
        Action = ActExit
      end
    end
  end
  object ActionList: TActionList
    Left = 420
    Top = 24
    object ActExit: TAction
      Caption = #1042#1099#1093#1086#1076
      OnExecute = ActExitExecute
    end
    object ActClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnExecute = ActClearExecute
    end
  end
  object Server: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = ServerConnect
    OnExecute = ServerExecute
    Left = 324
    Top = 24
  end
end
