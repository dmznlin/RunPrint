{*******************************************************************************
  作者: dmzn@163.com 2022-06-21
  描述: 主窗体
*******************************************************************************}
unit UFormMain;

interface

uses
  SysUtils, Classes,  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm,
  uniGUImJSForm, System.Actions, Vcl.ActnList, uniGUIBaseClasses,
  uniSegmentedButton, unimSegmentedButton;

type
  TfFormMain = class(TUnimForm)
    btn1: TUnimSegmentedButton;
    ActionList1: TActionList;
    Act_About: TAction;
    PanelWork: TUnimContainerPanel;
    Act_Order: TAction;
    procedure UnimFormCreate(Sender: TObject);
    procedure ActionList1Execute(Action: TBasicAction; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, USysModule, USysBusiness,
  USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

procedure TfFormMain.UnimFormCreate(Sender: TObject);
begin
  Caption := gSystem.FMain.FActive.FTitleMain;
  UniMainModule.FDialogCaller := Self;
  TWebSystem.ShowFrame('TfFrameStatus', PanelWork);
end;

procedure TfFormMain.ActionList1Execute(Action: TBasicAction;
  var Handled: Boolean);
var nStr: string;
begin
  if Action = Act_About then
  begin
    nStr := StringReplace(gSystem.FMain.FActive.FCopyRight, '\n', #13#10,
      [rfReplaceAll]);
    UniMainModule.ShowMsg(nStr, False, Act_About.Caption);
  end;
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
