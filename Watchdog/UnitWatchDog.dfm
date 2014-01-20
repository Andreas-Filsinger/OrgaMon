object ServiceWatchDog: TServiceWatchDog
  OldCreateOrder = False
  DisplayName = 'OrgaMon WatchDog'
  StartType = stBoot
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  Height = 150
  Width = 215
  object Timer1: TTimer
    Interval = 30000
    OnTimer = Timer1Timer
    Left = 32
    Top = 24
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    Host = '127.0.0.1'
    IPVersion = Id_IPv4
    Port = 3049
    ReadTimeout = -1
    Left = 40
    Top = 72
  end
end
