object fFormMain: TfFormMain
  Left = 0
  Top = 0
  ClientHeight = 499
  ClientWidth = 320
  Caption = 'fFormMain'
  CloseButton.Visible = False
  TitleButtons = <
    item
      Action = Act_About
      ButtonId = 0
      IconCls = 'info'
      UI = 'plain'
    end>
  OnCreate = UnimFormCreate
  PixelsPerInch = 96
  TextHeight = 13
  ScrollPosition = 0
  ScrollHeight = 47
  PlatformData = {}
  object PanelWork: TUnimContainerPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 452
    Hint = ''
    Align = alClient
    LayoutConfig.Cls = 'x-panel-pagesheet'
  end
  object btn1: TUnimSegmentedButton
    Left = 0
    Top = 452
    Width = 320
    Height = 47
    Hint = ''
    Items = <
      item
        Action = Act_Order
        ImageIndex = 10
        Caption = #26032#35746#21333
        ButtonId = 0
      end
      item
        ImageIndex = 4
        Caption = #35746#21333#21015#34920
        ButtonId = 1
      end
      item
        ImageIndex = 13
        Caption = #20010#20154#20013#24515
        ButtonId = 2
      end>
    Images = UniMainModule.SmallImages
    Align = alBottom
  end
  object ActionList1: TActionList
    Images = UniMainModule.ImagesAdapter1
    OnExecute = ActionList1Execute
    Left = 32
    Top = 32
    object Act_About: TAction
    end
    object Act_Order: TAction
      Caption = #26032#35746#21333
      ImageIndex = 10
    end
  end
end
