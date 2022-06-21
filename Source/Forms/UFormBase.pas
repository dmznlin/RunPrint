{*******************************************************************************
  作者: dmzn@163.com 2022-06-21
  描述: 标准窗体
*******************************************************************************}
unit UFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, System.IniFiles, ULibFun, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIForm, uniGUImForm, uniGUImJSForm;

type
  TfFormBase = class;
  TfFormClass = class of TfFormBase;

  TfFormConfig = record
    FName          : string;                         //类名
    FDesc          : string;                         //描述
    FVerifyAdmin   : Boolean;                        //验证管理员
    FUserConfig    : Boolean;                        //用户自定义配置
  end;

  TFormOnEnumCtrl = reference to procedure (Sender: TObject);
  //枚举父容器中的所有子控件
  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PCommandParam = nil);
  //模式窗体结果回调

  TfFormBase = class(TUnimForm)
    procedure UnimFormCreate(Sender: TObject);
    procedure UnimFormDestroy(Sender: TObject);
  private
    FParam: TCommandParam;
    {*命令参数*}
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*基类函数*}
    procedure EnumSubControl(const nParent: TWinControl;
      const nOnEnum: TFormOnEnumCtrl);
    {*枚举子控件*}
    function IsDataValid: Boolean; virtual;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    {*验证数据*}
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; virtual;
    {*窗体描述*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(): PCommandParam; virtual;
    {*读写参数*}
    class function CallMe(const nData: PCommandParam): Boolean; virtual;
    {*执行业务*}
  end;

implementation

{$R *.dfm}

uses
  MainModule, UManagerGroup, USysBusiness;

procedure TfFormBase.UnimFormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FParam.Init;
  OnCreateForm(Sender);
  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFormConfig(nIni, True);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBase.UnimFormDestroy(Sender: TObject);
var nIni: TIniFile;
begin
  OnDestroyForm(Sender);
  nIni := nil;
  try
    if ConfigMe.FUserConfig then
      nIni := TWebSystem.UserConfigFile;
    DoFormConfig(nIni, False);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBase.OnCreateForm(Sender: TObject);
begin
  //null
end;

procedure TfFormBase.OnDestroyForm(Sender: TObject);
begin
  //null
end;

procedure TfFormBase.DoFormConfig(nIni: TIniFile; const nLoad: Boolean);
begin
  //null
end;

//Date: 2021-10-27
//Parm: 参数
//Desc: 执行无需窗体的操作
class function TfFormBase.CallMe(const nData: PCommandParam): Boolean;
begin
  Result := True;
end;

//Date: 2021-05-06
//Desc: 描述窗体信息
class function TfFormBase.ConfigMe: TfFormConfig;
var nInit: TfFormConfig;
begin
  FillChar(nInit, SizeOf(TfFormConfig), #0);
  Result := nInit;
  //fill default

  Result.FName := ClassName;
  Result.FVerifyAdmin := False;
end;

//Date: 2021-04-27
//Parm: 参数
//Desc: 设置窗体的参数
function TfFormBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-04-27
//Desc: 读取窗体的数据,存入nData中
function TfFormBase.GetData(): PCommandParam;
begin
  Result := @FParam;
end;

//Desc: 验证Sender的数据是否正确,返回提示内容
function TfFormBase.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  nHint := '';
  Result := True;
end;

function TfFormBase.IsDataValid: Boolean;
var nStr: string;
    nList: TList;
    nObj: TObject;
    i,nLen: integer;
begin
  nList := nil;
  try
    Result := True;
    nList := gMG.FObjectPool.Lock(TList) as TList;
    TApplicationHelper.EnumSubCtrlList(Self, nList);

    nLen := nList.Count - 1;
    for i:=0 to nLen do
    begin
      nObj := TObject(nList[i]);
      if not OnVerifyCtrl(nObj, nStr) then
      begin
        if nObj is TWinControl then
          TWinControl(nObj).SetFocus;
        //xxxxx

        if nStr <> '' then
          UniMainModule.ShowMsg(nStr, True);
        //xxxxx

        Result := False;
        Exit;
      end;
    end;
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2021-07-16
//Parm: 父容器;回调函数
//Desc: 枚举nParent下的所有子控件,对其执行nOnEnum操作
procedure TfFormBase.EnumSubControl(const nParent: TWinControl;
  const nOnEnum: TFormOnEnumCtrl);
var nList: TList;
    nIdx: integer;
begin
  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TList) as TList;
    TApplicationHelper.EnumSubCtrlList(nParent, nList);

    for nIdx:=nList.Count - 1 downto 0 do
      nOnEnum(nList[nIdx]);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

end.
