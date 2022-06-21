{*******************************************************************************
  ����: dmzn@163.com 2022-06-21
  ����: ��׼����
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
    FName          : string;                         //����
    FDesc          : string;                         //����
    FVerifyAdmin   : Boolean;                        //��֤����Ա
    FUserConfig    : Boolean;                        //�û��Զ�������
  end;

  TFormOnEnumCtrl = reference to procedure (Sender: TObject);
  //ö�ٸ������е������ӿؼ�
  TFormModalResult = reference to  procedure(const nResult: Integer;
    const nParam: PCommandParam = nil);
  //ģʽ�������ص�

  TfFormBase = class(TUnimForm)
    procedure UnimFormCreate(Sender: TObject);
    procedure UnimFormDestroy(Sender: TObject);
  private
    FParam: TCommandParam;
    {*�������*}
    procedure OnCreateForm(Sender: TObject); virtual;
    procedure OnDestroyForm(Sender: TObject); virtual;
    procedure DoFormConfig(nIni: TIniFile; const nLoad: Boolean); virtual;
    {*���ຯ��*}
    procedure EnumSubControl(const nParent: TWinControl;
      const nOnEnum: TFormOnEnumCtrl);
    {*ö���ӿؼ�*}
    function IsDataValid: Boolean; virtual;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    {*��֤����*}
  public
    { Public declarations }
    class function ConfigMe: TfFormConfig; virtual;
    {*��������*}
    function SetData(const nData: PCommandParam): Boolean; virtual;
    function GetData(): PCommandParam; virtual;
    {*��д����*}
    class function CallMe(const nData: PCommandParam): Boolean; virtual;
    {*ִ��ҵ��*}
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
//Parm: ����
//Desc: ִ�����贰��Ĳ���
class function TfFormBase.CallMe(const nData: PCommandParam): Boolean;
begin
  Result := True;
end;

//Date: 2021-05-06
//Desc: ����������Ϣ
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
//Parm: ����
//Desc: ���ô���Ĳ���
function TfFormBase.SetData(const nData: PCommandParam): Boolean;
begin
  if Assigned(nData) then
    FParam := nData^;
  Result := True;
end;

//Date: 2021-04-27
//Desc: ��ȡ���������,����nData��
function TfFormBase.GetData(): PCommandParam;
begin
  Result := @FParam;
end;

//Desc: ��֤Sender�������Ƿ���ȷ,������ʾ����
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
//Parm: ������;�ص�����
//Desc: ö��nParent�µ������ӿؼ�,����ִ��nOnEnum����
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