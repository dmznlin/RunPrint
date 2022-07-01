{*******************************************************************************
  ����: dmzn@163.com 2022-06-22
  ����: Frame����
*******************************************************************************}
unit UFrameBase;

interface

uses
  SysUtils, Classes, Graphics, Controls, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Vcl.Forms, System.IniFiles, uniGUIBaseClasses,
  uniPanel, ULibFun, uniTimer, uniGUImJSForm;

type
  TfFrameBase = class;
  TfFrameClass = class of TfFrameBase;

  TfFrameConfig = record
    FName          : string;                         //����
    FDesc          : string;                         //����
    FDBConn        : string;                         //���ݿ��ʶ
    FVerifyAdmin   : Boolean;                        //��֤����Ա
    FUserConfig    : Boolean;                        //�û��Զ�������
  end;

  TfFrameBase = class(TUniFrame)
    PanelWork: TUnimContainerPanel;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniFrameDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    FParam: TCommandParam;
    {*�������*}
    procedure OnCreateFrame(Sender: TObject); virtual;
    procedure OnShowFrame(Sender: TObject); virtual;
    procedure OnDestroyFrame(Sender: TObject); virtual;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*���ຯ��*}
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; virtual;
    {*��������*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*��д����*}
  end;

implementation

{$R *.dfm}
uses
  UManagerGroup, USysBusiness;

procedure TfFrameBase.UniFrameCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FParam.Init;
  OnCreateFrame(Sender);

  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFrameConfig(nIni, True);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.UniFrameDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  OnDestroyFrame(Sender);
  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFrameConfig(nIni, False);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameBase.OnCreateFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.OnShowFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.OnDestroyFrame(Sender: TObject);
begin
  //null
end;

procedure TfFrameBase.DoFrameConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  //null
end;

//Date: 2021-06-03
//Desc: ����frame��Ϣ
class function TfFrameBase.ConfigMe: TfFrameConfig;
var nInit: TfFrameConfig;
begin
  FillChar(nInit, SizeOf(TfFrameConfig), #0);
  Result := nInit;
  //fill default

  with Result do
  begin
    FVerifyAdmin  := False;
    FUserConfig   := False;
    FName         := ClassName;
    FDBConn       := gMG.FDBManager.DefaultDB;
  end;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ����Frame�Ĳ���
function TfFrameBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: ����
//Desc: ��ȡFrame������,����nData��
function TfFrameBase.GetData(var nData: TCommandParam): Boolean;
begin
  Result := True;
end;

end.
