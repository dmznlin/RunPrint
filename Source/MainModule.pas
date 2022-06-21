{*******************************************************************************
  ����: dmzn@163.com 2022-06-21
  ����: �û�ȫ����ģ��
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
    {*����Ա����¼*}
  public
    FUser: TDBCommand.TUserData;
    {*�û�����*}
    FDialogCaller: TUniBaseForm;
    {*��Ϣ�����*}
    FGridColumnAdjust: Boolean;
    {*����������*}
    procedure AddExternalImages(nDir: string);
    {*����ͼ����Դ*}
    procedure VerifyAdministrator(const nPwd: string;
      const nCall: TButtonClickInputEvent;
      const nButton: TButtonClickType = ctYes); overload;
    procedure VerifyAdministrator(const nEvent: TButtonClickInputEvent;
      const nCaller: TUniBaseForm = nil); overload;
    {*��֤���*}
    procedure ShowMsg(const nHint: string; const nError: Boolean = False;
      nTitle: string = '');
    {*��Ϣ��ʾ��*}
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
    {*��Ϣ��ʾ��*}
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
    FUserID   := 'default';        //�û����
    FUserName := 'sys_dmzn';       //�û�����
    FAccount  := 'dmzn@163.com';   //�û��ʻ�(��¼��)
  end;

  AddExternalImages(gPath + sImageDir);
  //�����ⲿͼ����Դ
end;

//Date: 2021-09-24
//Parm: ��Դ·��
//Desc: ��nDir�µ�ͼ�갴��С��ʶ��ӵ���Ӧ���б�
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
//Parm: ��̬����;��֤ͨ�����¼�;��ť����
//Desc: ��֤nPwd�Ƿ�Ϊ��Ч�Ĺ���Ա��̬����
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
//Parm: �ص�;���ô���
//Desc: ��֤��ǰ�Ƿ����Ա
procedure TUniMainModule.VerifyAdministrator(const nEvent: TButtonClickInputEvent;
  const nCaller: TUniBaseForm);
begin
  if (FAdminLastLogin > 0) and
     (TDateTimeHelper.GetTickCountDiff(FAdminLastLogin) < 10 * 60 * 1000) then
  begin
    nEvent(ctYes, '');
    Exit;
  end; //10 min valid

  InputDlg('���������Ա��̬����:', '',
    procedure(const nType: TButtonClickType; const nText: string)
    begin
      VerifyAdministrator(nText, nEvent, nType);
    end, nCaller);
end;

//Date: 2021-04-20
//Parm: ��Ϣ����;����
//Desc: ������Ϣ��
procedure TUniMainModule.ShowMsg(const nHint: string; const nError: Boolean;
  nTitle: string);
begin
  ShowDlg(nHint, nError, FDialogCaller, nil, nTitle);
end;

//Date: 2021-04-20
//Parm: ��Ϣ;���ô���
//Desc: ��ʾ�Ի���
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
//Parm: ��Ϣ;����;���ô���
//Desc: ѯ�ʶԻ���
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
//Parm: ��Ϣ;����;�¼�;���ô���;������д;��С;�Ƿ�����
//Desc: ��ʾ�����
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
