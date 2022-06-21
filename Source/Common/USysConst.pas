{*******************************************************************************
  作者: dmzn@ylsoft.com 2018-03-15
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, Data.DB, uniPageControl, ULibFun;

const
  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_DeleteData       = $1004;                     //删除数据
  cCmd_ViewData         = $1006;                     //查看数据
  cCmd_GetData          = $1007;                     //选择数据
  cCmd_EditFile         = $1008;                     //编辑文件
  cCmd_ViewFile         = $1009;                     //查看文件

type
  TImagePosition = (ipDefault, ipTL, ipTM, ipTR,
                               ipML, ipMM, ipMR,
                               ipBL, ipBM, ipBR);
  //图片位置: Top,Left,Middle,Right,Bottom

  PImageData = ^TImageData;
  TImageData = record
    FFile       : string;                            //图片路径
    FWidth      : Integer;                           //图片宽度
    FHeight     : Integer;                           //图片高度
    FPosition   : TImagePosition;                    //图片位置
  end;

  TSystemImage = record
    FBgLogin    : TImageData;                        //背景:登录窗口
    FBgMain     : TImageData;                        //背景:主窗口
    FImgLogo    : TImageData;                        //图片:登录窗口Logo
    FImgKey     : TImageData;                        //图片:登录窗口密码装饰
    FImgMainTL  : TImageData;                        //图片:主窗口Top-Left
    FImgMainTR  : TImageData;                        //图片:主窗口Top-Right
    FImgWelcome : TImageData;                        //图片:主窗口欢迎
  end;

  PSystemParam = ^TSystemParam;
  TSystemParam = record
    FMain       : TApplicationHelper.TAppParam;      //主配置参数
    FImages     : TSystemImage;                      //图片资源配置
  end;
  //系统参数

  TUserParam = record
    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员

    FOSUser     : string;                            //操作系统
    FUserAgent  : string;                            //浏览器类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSystem: TSystemParam;                             //程序环境参数

ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '错误';                      //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sLocalDir           = 'Local\';                    //区域语言
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sCameraDir          = 'Camera\';                   //抓拍目录

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记
  sFormConfig         = 'FormInfo.ini';              //窗体配置

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

initialization

finalization

end.


