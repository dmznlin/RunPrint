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
  //初始化系统环境
  TWebSystem.LoadSysParameter();
  //载入系统配置参数

  with gSystem.FMain do
  begin
    Title := FActive.FTitleApp;
    //程序标题

    if FActive.FExtRoot <> '' then
      ExtRoot := FActive.FExtRoot;
    //前端脚本路径
    if FActive.FUniRoot <> '' then
      UniRoot := FActive.FUniRoot;
    if FActive.FUnimRoot <> '' then
      UniMobileRoot := FActive.FUnimroot;
    //框架脚本路径

    Port := FActive.FPort;
    //服务端口
    if FileExists(FActive.FFavicon) then
      Favicon.LoadFromFile(FActive.FFavicon);
    //收藏夹图标

    if FileExists(gPath + sLocalDir + 'userCSS.css') then
      CustomFiles.Add(TWebSystem.SwtichPathDelim(sLocalDir) + 'userCSS.css');
    //自定义样式
  end;

  AutoCoInitialize := True;
  //自动初始化COM对象

  MainFormDisplayMode := mfPage;
  //全屏页面显示

  gMG.FLogManager.StartService();
  //启动日志服务

  try
    //gMG.FMenuManager.LoadLanguage();
    //载入多语言列表
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
