object fFrameBase: TfFrameBase
  Left = 0
  Top = 0
  Width = 230
  Height = 300
  OnCreate = UniFrameCreate
  OnDestroy = UniFrameDestroy
  ParentAlignmentControl = False
  TabOrder = 0
  object PanelWork: TUnimContainerPanel
    Left = 0
    Top = 0
    Width = 230
    Height = 300
    Hint = ''
    Align = alClient
    ParentAlignmentControl = False
    AlignmentControl = uniAlignmentClient
    LayoutAttribs.Align = 'center'
    LayoutAttribs.Pack = 'center'
    LayoutConfig.Cls = 'x-panel-pagesheet'
  end
end
