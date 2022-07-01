unit UFrameStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, UFrameBase, uniLabel, unimLabel,
  uniGUIBaseClasses, uniGUImJSForm, uniImage, unimImage, uniPanel, unimFieldSet;

type
  TfFrameStatus = class(TfFrameBase)
    Image1: TUnimImage;
    Label1: TUnimLabel;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  USysBusiness, USysConst;

procedure TfFrameStatus.UniFrameCreate(Sender: TObject);
begin
  inherited;
  TWebSystem.SetImageData(PanelWork, Image1, @gSystem.FImages.FImgWelcome);
end;

initialization
  TWebSystem.AddFrame(TfFrameStatus);
end.
