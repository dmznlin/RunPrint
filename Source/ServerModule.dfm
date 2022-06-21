object UniServerModule: TUniServerModule
  OldCreateOrder = False
  TempFolder = 'temp\'
  Title = 'New Application'
  SuppressErrors = []
  Bindings = <>
  ServerMessages.UnavailableErrMsg = #36890#35759#38169#35823': '#25968#25454#26080#27861#27491#30830#20256#36755
  ServerMessages.LoadingMessage = #27491#22312#35835#21462
  ServerMessages.ExceptionTemplate.Strings = (
    '<html>'
    '<body bgcolor="#dfe8f6">'
    '<p style="text-align:center;color:#A05050">'#31995#32479#21457#29983#38169#35823','#25551#36848#22914#19979':</p>'
    '<p style="text-align:center;color:#0000A0">[###message###]</p>'
    
      '<p style="text-align:center;color:#A05050"><a href="[###url###]"' +
      '>'#37325#26032#30331#24405#31995#32479'</a></p>'
    '</body>'
    '</html>')
  ServerMessages.InvalidSessionTemplate.Strings = (
    '<html>'
    '<body bgcolor="#dfe8f6">'
    '<p style="text-align:center;color:#0000A0">[###message###]</p>'
    
      '<p style="text-align:center;color:#A05050"><a href="[###url###]"' +
      '>'#37325#26032#30331#24405#31995#32479'</a></p>'
    '</body>'
    '</html>')
  ServerMessages.TerminateTemplate.Strings = (
    '<html>'
    '<body bgcolor="#dfe8f6">'
    '<p style="text-align:center;color:#0000A0">[###message###]</p>'
    
      '<p style="text-align:center;color:#A05050"><a href="[###url###]"' +
      '>'#37325#26032#30331#24405#31995#32479'</a></p>'
    '</body>'
    '</html>')
  ServerMessages.InvalidSessionMessage = #27809#26377#30331#24405' '#25110' '#30331#24405#36229#26102
  ServerMessages.TerminateMessage = #24744#24050#36864#20986#31995#32479
  SSL.SSLOptions.RootCertFile = 'root.pem'
  SSL.SSLOptions.CertFile = 'cert.pem'
  SSL.SSLOptions.KeyFile = 'key.pem'
  SSL.SSLOptions.Method = sslvTLSv1_1
  SSL.SSLOptions.SSLVersions = [sslvTLSv1_1]
  SSL.SSLOptions.Mode = sslmUnassigned
  SSL.SSLOptions.VerifyMode = []
  SSL.SSLOptions.VerifyDepth = 0
  Options = [soAutoPlatformSwitch, soWipeShadowSessions, soDontCompressDownloads]
  ConnectionFailureRecovery.ErrorMessage = #26381#21153#24050#26029#24320
  ConnectionFailureRecovery.RetryMessage = #33258#21160#36830#25509'...'
  OnBeforeInit = UniGUIServerModuleBeforeInit
  Height = 252
  Width = 424
end
