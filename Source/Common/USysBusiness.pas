{*******************************************************************************
  作者: dmzn@163.com 2020-06-23
  描述: 业务定义单元
*******************************************************************************}
unit USysBusiness;

{$I Link.Inc}
interface

uses
  System.Classes, System.SysUtils, System.SyncObjs, System.IniFiles,
  System.Variants, Data.DB, Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.Menus,
  //----------------------------------------------------------------------------
  uniGUIAbstractClasses, uniGUITypes, uniGUIClasses, uniGUIBaseClasses,
  uniTreeView, uniGUImForm, unimImage, MainModule, UFormBase, UFrameBase,
  uniPageControl,
  //----------------------------------------------------------------------------
  UBaseObject, UManagerGroup, ULibFun, USysConst;

type
  ///<summary>System Function: 系统级别的通用函数</summary>
  TWebSystem = class
  private
    class var
      FSyncLock: TCriticalSection;
      {*全局同步锁*}
  public
    type
      TUserFileType = (ufOPTCode, ufExportXLS);
      {*用户文件*}
    class var
      Forms: array of TfFormClass;
      {*窗体列表*}
      Frames: array of TfFrameClass;
      {*框架列表*}
  public
    class procedure Init(const nForce: Boolean = False); static;
    {*初始化*}
    class procedure Release; static;
    {*释放资源*}
    class procedure SyncLock; static;
    class procedure SyncUnlock; static;
    {*全局同步*}
    class procedure InitSystemEnvironment; static;
    {*初始化系统运行环境的变量*}
    class procedure LoadSysParameter(nIni: TIniFile = nil); static;
    {*载入系统配置参数*}
    class function SwtichPathDelim(const nPath: string;
      const nFrom: string = '\'; const nTo: string = '/'): string; static;
    {*切换路径分隔符*}
    class procedure AddForm(const nForm: TfFormClass); static;
    class procedure AddFrame(const nFrame: TfFrameClass); static;
    {*注册窗体类*}
    class function GetForm(const nClass: string;
      const nException: Boolean = False): TUnimForm; static;
    {*获取窗体*}
    class procedure ShowModalForm(const nClass: string;
      const nParams: PCommandParam = nil;
      const nResult: TFormModalResult = nil;
      const nDisplayForm: Boolean = True); static;
    {*显示模式窗体*}
    class procedure ShowFrame(const nClass: string;const nParent: TUniContainer;
      const nParams: PCommandParam = nil); static;
    {*显示Frame框架*}
    class function UserFile(const nType: TUserFileType;
      const nRelative: Boolean = True;
      const nForceRefresh: Boolean = False): string; static;
    class function UserConfigFile: TIniFile; static;
    {*用户私有文件*}
    class procedure SetImageData(const nParent: TUniContainer;
      const nImage: TUnimImage; const nData: PImageData); static;
    {*设置图片数据*}
    class procedure InitDateRange(const nForm,nCtrl: string; var nS,nE: TDateTime;
      nIni: TIniFile = nil); static;
    class procedure SaveDateRange(const nForm,nCtrl: string; const nS,nE: TDateTime;
      nIni: TIniFile = nil); static;
    {**}
  end;

implementation

class procedure TWebSystem.Init(const nForce: Boolean);
begin
  if nForce or (not Assigned(FSyncLock)) then
    FSyncLock := TCriticalSection.Create;
  //xxxxx
end;

class procedure TWebSystem.Release;
begin
  FreeAndNil(FSyncLock);
end;

//Date: 2020-06-23
//Desc: 全局同步锁定
class procedure TWebSystem.SyncLock;
begin
  FSyncLock.Enter;
end;

//Date: 2020-06-23
//Desc: 全局同步锁定解除
class procedure TWebSystem.SyncUnlock;
begin
  FSyncLock.Leave;
end;

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2020-06-23
//Desc: 初始化运行环境
class procedure TWebSystem.InitSystemEnvironment;
begin
  Randomize;
  gPath := TApplicationHelper.gPath;

  with FormatSettings do
  begin
    DateSeparator := '-';
    ShortDateFormat := 'yyyy-MM-dd';
  end;

  with TObjectStatusHelper do
  begin
    shData := 50;
    shTitle := 100;
  end;
end;

//Date: 2020-06-23
//Desc: 载入系统配置参数
class procedure TWebSystem.LoadSysParameter(nIni: TIniFile = nil);
const sMain = 'Config';
var nStr,nDir: string;
    nBool: Boolean;
    nSA,nSB: TStringHelper.TStringArray;

    //Desc: 解析nData中的图片数据
    procedure GetImage(var nImg: TImageData; nData: string);
    var nInt: Integer;
    begin
      nData := Trim(nData);
      if nData = '' then Exit;

      if not TStringHelper.SplitArray(nData, nSA, ',', tpTrim) then Exit;
      //img,w x h,positon
      nInt := Length(nSA);

      if nInt > 0 then
        nImg.FFile := nDir + nSA[0];
      //xxxxx

      if (nInt > 1) and TStringHelper.SplitArray(nSA[1],nSB,'x',tpTrim,2) then
      begin
        nImg.FWidth := StrToInt(nSB[0]);
        nImg.FHeight := StrToInt(nSB[1]);
      end;

      if nInt > 2 then
        nImg.FPosition := TStringHelper.Str2Enum<TImagePosition>(nSA[2]);
      //xxxxx
    end;
begin
  nBool := Assigned(nIni);
  if not nBool then
    nIni := TIniFile.Create(TApplicationHelper.gSysConfig);
  //xxxxx

  with gSystem, nIni do
  try
    FillChar(gSystem, SizeOf(TSystemParam), #0);
    TApplicationHelper.LoadParameters(gSystem.FMain, nIni, True);
    //load main config
  finally
    if not nBool then nIni.Free;
  end;

  nStr := gPath + sImageDir + 'images.ini';
  if FileExists(nStr) then
  begin
    nIni := TIniFile.Create(nStr);
    with gSystem.FImages, nIni do
    try
      nDir := SwtichPathDelim(sImageDir);
      FillChar(gSystem.FImages, SizeOf(TSystemImage), #0);

      GetImage(FBgLogin,    ReadString(sMain, 'BgLogin', ''));
      GetImage(FBgMain,     ReadString(sMain, 'BgMain', ''));
      GetImage(FImgLogo,    ReadString(sMain, 'ImgLogo', ''));
      GetImage(FImgKey,     ReadString(sMain, 'ImgKey', ''));
      GetImage(FImgMainTL,  ReadString(sMain, 'ImgMainTL', ''));
      GetImage(FImgMainTR,  ReadString(sMain, 'ImgMainTR', ''));
      GetImage(FImgWelcome, ReadString(sMain, 'ImgWelcome', ''));
    finally
      nIni.Free;
    end;
  end;
end;

//Date: 2021-04-16
//Parm: 文件路径;原、目标
//Desc: 将nPatn中的路径分隔符转为特定风格
class function TWebSystem.SwtichPathDelim(const nPath,nFrom,nTo: string): string;
begin
  Result := StringReplace(nPath, nFrom, nTo, [rfReplaceAll]);
end;

//Date: 2021-06-06
//Parm: 类型;相对路径;强制刷新
//Desc: 返回当前用户的nType文件路径
class function TWebSystem.UserFile(const nType: TUserFileType;
  const nRelative: Boolean; const nForceRefresh: Boolean): string;
begin
  with UniMainModule do
  begin
    case nType of
     ufOPTCode: //启用动态口令时生成的二维码
      Result := Format('%s_opt.bmp', [FUser.FUserID]);
     ufExportXLS: //导出表格数据
      Result := Format('%s_ept.xls', [FUser.FUserID]);
     else
      begin
        Result := '';
        Exit;
      end;
    end;

    if nRelative then //前端相对路径
    begin
      Result := 'users/' + Result;
      if nForceRefresh then
        Result := Result + '?t=' + TDateTimeHelper.DateTimeSerial;
      //添加序列号改变图片链接,使前端刷新
    end else
    begin
      Result := gPath + 'users\' + Result;
    end;
  end;
end;

//Date: 2021-05-25
//Desc: 用户自定义配置文件
class function TWebSystem.UserConfigFile: TIniFile;
var nStr: string;
begin
  Result := nil;
  try
    nStr := gPath + 'users\';
    if not DirectoryExists(nStr) then
      ForceDirectories(nStr);
    //new folder

    nStr := nStr + UniMainModule.FUser.FUserID + '.ini';
    Result := TIniFile.Create(nStr);

    if not FileExists(nStr) then
    begin
      Result.WriteString('Config', 'Account', UniMainModule.FUser.FAccount);
      Result.WriteString('Config', 'UserName', UniMainModule.FUser.FUserName);
    end;
  except
    Result.Free;
  end;
end;

//Date: 2021-05-27
//Parm: 父容器;图片;数据
//Desc: 依据nData设置nImage属性
class procedure TWebSystem.SetImageData(const nParent: TUniContainer;
  const nImage: TUnimImage; const nData: PImageData);
begin
  with nImage do
  begin
    Visible := FileExists(gPath + SwtichPathDelim(nData.FFile, '/', '\'));
    if not Visible then Exit; //file invalid
    
    Url := nData.FFile;
    if nData.FWidth > 0 then Width := nData.FWidth;
    if nData.FHeight > 0 then Height := nData.FHeight;

    case nData.FPosition of
     ipTL, ipTM, ipTR: nParent.LayoutAttribs.Align := 'top';
     ipML, ipMM, ipMR: nParent.LayoutAttribs.Align := 'middle';
     ipBL, ipBM, ipBR: nParent.LayoutAttribs.Align := 'bottom';
    end;

    case gSystem.FImages.FImgWelcome.FPosition of
     ipTL, ipML, ipBL: nParent.LayoutAttribs.Pack := 'start';
     ipTM, ipMM, ipBM: nParent.LayoutAttribs.Pack := 'center';
     ipTR, ipMR, ipBR: nParent.LayoutAttribs.Pack := 'end';
    end;
  end;
end;

//Date: 2021-08-07
//Parm: 窗体;组件;开始结束日期
//Desc: 依据nForm.nCtrl初始化nS,nE日期
class procedure TWebSystem.InitDateRange(const nForm, nCtrl: string;
  var nS, nE: TDateTime; nIni: TIniFile);
var nStr: string;
    nBool: Boolean;
begin
  nBool := Assigned(nIni);
  if not nBool then
    nIni := UserConfigFile();
  //xxxxx

  with TDateTimeHelper do
  try
    nStr := nIni.ReadString(nForm, nCtrl + '_DateRange_Last', '');
    if nStr = Date2Str(Now) then
    begin
      nStr := nIni.ReadString(nForm, nCtrl + '_DateRange_S', Date2Str(Now));
      nS := Str2Date(nStr);

      nStr := nIni.ReadString(nForm, nCtrl + '_DateRange_E', Date2Str(Now));
      nE := Str2Date(nStr);

      if nE = nS then
        nE := nS + 1;
      //xxxxx
    end else
    begin
      nS := Date();
      nE := nS + 1;
    end;
  finally
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//Date: 2021-08-07
//Parm: 窗体;组件;开始结束日期
//Desc: 保存nForm.nCtrl的日期区间
class procedure TWebSystem.SaveDateRange(const nForm, nCtrl: string;
  const nS,nE: TDateTime; nIni: TIniFile);
var nBool: Boolean;
begin
  nBool := Assigned(nIni);
  if not nBool then
    nIni := UserConfigFile();
  //xxxxx

  with TDateTimeHelper do
  try
    nIni.WriteString(nForm, nCtrl + '_DateRange_S', Date2Str(nS));
    nIni.WriteString(nForm, nCtrl + '_DateRange_E', Date2Str(nE));
    nIni.WriteString(nForm, nCtrl + '_DateRange_Last', Date2Str(Now));
  finally
    if not nBool then
      nIni.Free;
    //xxxxx
  end;
end;

//---------------------------------- 窗体调用 ----------------------------------
//Date: 2021-05-06
//Parm: 窗体类
//Desc: 注册窗体类
class procedure TWebSystem.AddForm(const nForm: TfFormClass);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := Low(Forms) to High(Forms) do
  if Forms[nIdx] = nForm then
  begin
    nStr := Format('TSysFun.AddForm: %s Has Exists.', [nForm.ClassName]);
    gMG.WriteLog(TWebSystem, 'Web系统对象', nStr);
    raise Exception.Create(nStr);
  end;

  nIdx := Length(Forms);
  SetLength(Forms, nIdx + 1);
  Forms[nIdx] := nForm;

  RegisterClass(nForm);
  //new class
end;

//Date: 2021-06-28
//Parm: 框架类
//Desc: 注册框架类
class procedure TWebSystem.AddFrame(const nFrame: TfFrameClass);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := Low(Frames) to High(Frames) do
  if Frames[nIdx] = nFrame then
  begin
    nStr := Format('TSysFun.AddFrame: %s Has Exists.', [nFrame.ClassName]);
    gMG.WriteLog(TWebSystem, 'Web系统对象', nStr);
    raise Exception.Create(nStr);
  end;

  nIdx := Length(Frames);
  SetLength(Frames, nIdx + 1);
  Frames[nIdx] := nFrame;

  RegisterClass(nFrame);
  //new class
end;

//Date: 2021-04-26
//Parm: 窗体类名
//Desc: 获取nClass类的对象
class function TWebSystem.GetForm(const nClass: string;
  const nException: Boolean): TUnimForm;
var nCls: TClass;
begin
  nCls := GetClass(nClass);
  if Assigned(nCls) then
       Result := TUnimForm(UniMainModule.GetFormInstance(nCls))
  else Result := nil;

  if (not Assigned(Result)) and nException then
    UniMainModule.ShowMsg(Format('窗体类[ %s ]无效.', [nClass]), True);
  //xxxxx
end;

//Date: 2021-04-27
//Parm: 窗体类;输入参数;输出参数
//Desc: 显示类名为nClass的模式窗体
class procedure TWebSystem.ShowModalForm(const nClass: string;
  const nParams: PCommandParam; const nResult: TFormModalResult;
  const nDisplayForm: Boolean);
var nCls: TClass;
    nBool: Boolean;
    nForm: TUnimForm;
begin
  if not nDisplayForm then //执行业务,不显示窗体
  begin
    if Assigned(nParams) then
    begin
      nCls := GetClass(nClass);
      if Assigned(nCls) and (nCls.InheritsFrom(TfFormBase)) then
      begin
        nBool := TfFormClass(nCls).CallMe(nParams);
        if Assigned(nResult) then
        begin
          if nBool then
               nResult(mrOk, nParams)
          else nResult(mrNo, nParams);
        end;
      end;
    end;

    Exit;
  end;

  nForm := TWebSystem.GetForm(nClass);
  if not Assigned(nForm) then Exit;
  //invalid class

  with nForm as TfFormBase do
  begin
    if Assigned(nParams) then
      SetData(nParams);
    //xxxxx

    ShowModal(
      procedure(Sender: TComponent; nModalResult:Integer)
      begin
        if Assigned(nResult) then
          nResult(nModalResult, GetData());
        //xxxxx
      end);
  end;
end;

//Date: 2022-07-01
//Parm:Frame类;父容器;输入参数
//Desc:在nParent上创建Frame框架
class procedure TWebSystem.ShowFrame(const nClass: string;
  const nParent: TUniContainer; const nParams: PCommandParam);
var nIdx: Integer;
    nNew: TfFrameBase;
    nFrame: TfFrameClass;
begin
  nFrame := TfFrameClass(GetClass(nClass));
  for nIdx := nParent.ControlCount-1 downto 0 do
   if nParent.Controls[nIdx] is nFrame then
   begin
     nParent.Controls[nIdx].BringToFront;
     Exit;
   end;

  nNew := nFrame.Create(nParent);
  nNew.Parent := nParent;
  nNew.Align := alClient;
end;

initialization
  TWebSystem.Init(True);
finalization
  TWebSystem.Release;
end.


