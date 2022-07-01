{*******************************************************************************
  作者: dmzn@163.com 2022-06-22
  描述: Frame基类
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
    FName          : string;                         //类名
    FDesc          : string;                         //描述
    FDBConn        : string;                         //数据库标识
    FVerifyAdmin   : Boolean;                        //验证管理员
    FUserConfig    : Boolean;                        //用户自定义配置
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
    {*命令参数*}
    procedure OnCreateFrame(Sender: TObject); virtual;
    procedure OnShowFrame(Sender: TObject); virtual;
    procedure OnDestroyFrame(Sender: TObject); virtual;
    procedure DoFrameConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*基类函数*}
  public
    { Public declarations }
    class function ConfigMe: TfFrameConfig; virtual;
    {*窗体描述*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(var nData: TCommandParam): Boolean; virtual;
    {*读写参数*}
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
//Desc: 描述frame信息
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
//Parm: 参数
//Desc: 设置Frame的参数
function TfFrameBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-06-03
//Parm: 参数
//Desc: 读取Frame的数据,存入nData中
function TfFrameBase.GetData(var nData: TCommandParam): Boolean;
begin
  Result := True;
end;

end.
