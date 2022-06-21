{*******************************************************************************
  作者: dmzn@163.com 2022-06-21
  描述: 主窗体
*******************************************************************************}
unit UFormMain;

interface

uses
  SysUtils, Classes,  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm,
  uniEdit, unimEdit, uniGUIBaseClasses, uniButton, unimButton;

type
  TfFormMain = class(TUnimForm)
    procedure UnimFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, ULibFun, USysConst;

function fFormMain: TfFormMain;
begin
  Result := TfFormMain(UniMainModule.GetFormInstance(TfFormMain));
end;

procedure TfFormMain.UnimFormCreate(Sender: TObject);
begin
  Caption := gSystem.FMain.FActive.FTitleMain;
  UniMainModule.FDialogCaller := Self;
end;

initialization
  RegisterAppFormClass(TfFormMain);

end.
