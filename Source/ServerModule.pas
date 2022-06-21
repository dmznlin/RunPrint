unit ServerModule;

interface

uses
  Classes, SysUtils, uniGUIServer, uniGUIMainModule, uniGUIApplication,
  uIdCustomHTTPServer, uniGUITypes, UManagerGroup, ULibFun;

type
  TUniServerModule = class(TUniGUIServerModule)
    procedure UniGUIServerModuleBeforeInit(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure FirstInit; override;
  public
    { Public declarations }
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

uses
  UniGUIVars, USysBusiness, USysConst;

function UniServerModule: TUniServerModule;
begin
  Result:=TUniServerModule(UniGUIServerInstance);
end;

procedure TUniServerModule.FirstInit;
begin
  InitServerModule(Self);
end;

procedure TUniServerModule.UniGUIServerModuleBeforeInit(Sender: TObject);
begin
  TWebSystem.InitSystemEnvironment;
  //��ʼ��ϵͳ����
  TWebSystem.LoadSysParameter();
  //����ϵͳ���ò���

  with gSystem.FMain do
  begin
    Title := FActive.FTitleApp;
    //�������

    if FActive.FExtRoot <> '' then
      ExtRoot := FActive.FExtRoot;
    //ǰ�˽ű�·��
    if FActive.FUniRoot <> '' then
      UniRoot := FActive.FUniRoot;
    if FActive.FUnimRoot <> '' then
      UniMobileRoot := FActive.FUnimroot;
    //��ܽű�·��

    Port := FActive.FPort;
    //����˿�
    if FileExists(FActive.FFavicon) then
      Favicon.LoadFromFile(FActive.FFavicon);
    //�ղؼ�ͼ��

    if FileExists(gPath + sLocalDir + 'userCSS.css') then
      CustomFiles.Add(TWebSystem.SwtichPathDelim(sLocalDir) + 'userCSS.css');
    //�Զ�����ʽ
  end;

  AutoCoInitialize := True;
  //�Զ���ʼ��COM����

  MainFormDisplayMode := mfPage;
  //ȫ��ҳ����ʾ

  gMG.FLogManager.StartService();
  //������־����

  try
    //gMG.FMenuManager.LoadLanguage();
    //����������б�
  except
    on nErr: Exception do
    begin
      gMG.FLogManager.AddLog(TUniServerModule, 'ServerModule', nErr.Message);
    end;
  end;
end;

initialization
  RegisterServerModuleClass(TUniServerModule);
end.
