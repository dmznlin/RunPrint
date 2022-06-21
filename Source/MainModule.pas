{*******************************************************************************
  作者: dmzn@163.com 2022-06-21
  描述: 用户全局主模块
*******************************************************************************}
unit MainModule;

interface

uses
  SysUtils, Classes, Vcl.Controls, System.ImageList, Vcl.ImgList, UDBFun,
  uniGUIMainModule, uniGUITypes, uniGUIForm, uniImageList, uniGUIBaseClasses,
  uniGUIClasses;

type
  TButtonClickType = (ctYes, ctNo, ctCancel);
  TButtonClickEvent = reference to procedure(const nType: TButtonClickType);
  TButtonClickInputEvent = reference to procedure(const nType: TButtonClickType;
    const nText: string);
  //xxxxx

  TUniMainModule = class(TUniGUIMainModule)
    SmallImages: TUniNativeImageList;
    ImagesAdapter1: TUniImageListAdapter;
    MidImage: TUniNativeImageList;
    BigImages: TUniNativeImageList;
    procedure UniGUIMainModuleCreate(Sender: TObject);
  private
    FAdminLastLogin: Cardinal;
    {*管理员最后登录*}
  public
    FUser: TDBCommand.TUserData;
    {*用户数据*}
    FDialogCaller: TUniBaseForm;
    {*消息框对象*}
    FGridColumnAdjust: Boolean;
    {*表格调整开关*}
    procedure AddExternalImages(nDir: string);
    {*增加图标资源*}
    procedure VerifyAdministrator(const nPwd: string;
      const nCall: TButtonClickInputEvent;
      const nButton: TButtonClickType = ctYes); overload;
    procedure VerifyAdministrator(const nEvent: TButtonClickInputEvent;
      const nCaller: TUniBaseForm = nil); overload;
    {*验证身份*}
    procedure ShowMsg(const nHint: string; const nError: Boolean = False;
      nTitle: string = '');
    {*消息提示条*}
    procedure ShowDlg(const nMsg: string; const nError: Boolean = False;
      nCaller: TUniBaseForm = nil;
      const nEvent: TButtonClickEvent = nil; nTitle: string = '');
    procedure QueryDlg(const nMsg: string;
      const nEvent: TButtonClickEvent = nil;
      nCaller: TUniBaseForm = nil;
      const nMask: string = ''; nTitle: string = '');
    procedure InputDlg(const nMsg,nTitle: string;
      const nEvent: TButtonClickInputEvent;
      nCaller: TUniBaseForm = nil; const nBlank: string = '';
      const nSize: Integer = 0; const nPwd: Boolean = False);
    {*消息提示框*}
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication, USysConst, ULibFun,
  UGoogleOTP;

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

procedure TUniMainModule.UniGUIMainModuleCreate(Sender: TObject);
begin
  FAdminLastLogin := 0;
  FGridColumnAdjust := False;
  Background.Url := gSystem.FImages.FBgMain.FFile;
  LoginBackground.Url := gSystem.FImages.FBgLogin.FFile;

  with FUser do
  begin
    FUserID   := 'default';        //用户编号
    FUserName := 'sys_dmzn';       //用户名称
    FAccount  := 'dmzn@163.com';   //用户帐户(登录名)
  end;

  AddExternalImages(gPath + sImageDir);
  //加载外部图标资源
end;

//Date: 2021-09-24
//Parm: 资源路径
//Desc: 将nDir下的图标按大小标识添加到对应的列表
procedure TUniMainModule.AddExternalImages(nDir: string);
var nInt: Integer;
    nRes: TSearchRec;
begin
  nDir := TApplicationHelper.RegularPath(nDir);
  nInt := FindFirst(nDir + 'ico_*.*', faAnyFile, nRes);
  try
    while nInt = 0 do
    begin
      if Pos('ico_16_', nRes.Name) = 1 then
        SmallImages.AddImageFile(nDir + nRes.Name);
      //16 x 16

      if Pos('ico_24_', nRes.Name) = 1 then
        MidImage.AddImageFile(nDir + nRes.Name);
      //24 x 24

      if Pos('ico_32_', nRes.Name) = 1 then
        BigImages.AddImageFile(nDir + nRes.Name);
      //32 x 32

      nInt := FindNext(nRes);
    end;
  finally
    FindClose(nRes);
  end;
end;

//Date: 2021-04-30
//Parm: 动态密码;验证通过后事件;按钮类型
//Desc: 验证nPwd是否为有效的管理员动态口令
procedure TUniMainModule.VerifyAdministrator(const nPwd: string;
  const nCall: TButtonClickInputEvent; const nButton: TButtonClickType);
begin
  if (nButton = ctYes) and TStringHelper.IsNumber(nPwd, False) then
   with TGoogleOTP, TApplicationHelper do
    if Validate(EncodeBase32(gSystem.FMain.FAdminKey), StrToInt(nPwd)) then
    begin
      FAdminLastLogin := TDateTimeHelper.GetTickCount();
      nCall(ctYes, nPwd);
      Exit;
    end;

  nCall(ctNo, nPwd);
  //verify failure
end;

//Date: 2021-04-28
//Parm: 回调;调用窗体
//Desc: 验证当前是否管理员
procedure TUniMainModule.VerifyAdministrator(const nEvent: TButtonClickInputEvent;
  const nCaller: TUniBaseForm);
begin
  if (FAdminLastLogin > 0) and
     (TDateTimeHelper.GetTickCountDiff(FAdminLastLogin) < 10 * 60 * 1000) then
  begin
    nEvent(ctYes, '');
    Exit;
  end; //10 min valid

  InputDlg('请输入管理员动态口令:', '',
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      VerifyAdministrator(nText, nEvent, nType);
    end, nCaller);
end;

//Date: 2021-04-20
//Parm: 消息内容;标题
//Desc: 弹出消息框
procedure TUniMainModule.ShowMsg(const nHint: string; const nError: Boolean;
  nTitle: string);
begin
  ShowDlg(nHint, nError, FDialogCaller, nil, nTitle);
end;

//Date: 2021-04-20
//Parm: 消息;调用窗体
//Desc: 提示对话框
procedure TUniMainModule.ShowDlg(const nMsg: string; const nError: Boolean;
  nCaller: TUniBaseForm; const nEvent: TButtonClickEvent; nTitle: string);
var nDType: TMsgDlgType;
begin
  if not Assigned(nCaller) then
    nCaller := FDialogCaller;
  //xxxxx

  if nError then
       nDType := mtError
  else nDType := mtInformation;

  nCaller.MessageDlg(nMsg, nDType, [mbOK],
    procedure(Sender: TComponent; nButton: Integer)
    begin
      if Assigned(nEvent) then
      begin
        if nButton = mrOk then
             nEvent(ctYes)
        else nEvent(ctNo);
      end;
    end);
end;

//Date: 2021-04-20
//Parm: 消息;标题;调用窗体
//Desc: 询问对话框
procedure TUniMainModule.QueryDlg(const nMsg: string;
  const nEvent: TButtonClickEvent; nCaller: TUniBaseForm;
  const nMask: string; nTitle: string);
begin
  if not Assigned(nCaller) then
    nCaller := FDialogCaller;
  //xxxxx

  nCaller.MessageDlg(nMsg, mtConfirmation, mbYesNo,
    procedure(Sender: TComponent; nButton: Integer)
    begin
      if Assigned(nEvent) then
      begin
        case nButton of
         mrYes: nEvent(ctYes);
         mrNo:  nEvent(ctNo);
        end;
      end;
    end);
end;

//Date: 2021-04-20
//Parm: 消息;标题;事件;调用窗体;允许不填写;大小;是否密码
//Desc: 显示输入框
procedure TUniMainModule.InputDlg(const nMsg,nTitle: string;
  const nEvent: TButtonClickInputEvent; nCaller: TUniBaseForm;
  const nBlank: string; const nSize: Integer; const nPwd: Boolean);
begin
  if not Assigned(nCaller) then
    nCaller := FDialogCaller;
  //xxxxx

  nCaller.Prompt(TStringHelper.MS(['@*', ''], nPwd) + nMsg,
    nTitle, mtConfirmation, mbOKCancel,
    procedure (Sender: TComponent; nButton:Integer; nText: string)
    begin
      if Assigned(nEvent) then
      begin
        if (nSize > 0) and (Length(nText) > nSize) then
            nText := Copy(nText, 1, nSize);
          //xxxxx

        if nButton = mrOK then
             nEvent(ctYes, nText)
        else nEvent(ctNo, nText);
      end;
    end);
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
