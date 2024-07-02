#Requires AutoHotkey v2.0

taskName := "AiHKScriptStartup"
scriptPath := A_ScriptDir . "\aihk.ahk"
ahkPath := A_AhkPath
scriptDir := A_ScriptDir


; 检查是否需要管理员权限
if not A_IsAdmin
{
    Run("*RunAs " A_ScriptFullPath)
    ExitApp()
}

msgbox scriptPath

; 创建任务计划的命令
xml := "
(Join
<ScheduleTask xmlns=""http://schemas.microsoft.com/windows/2004/02/mit/task"">
  <RegistrationInfo>
    <Date>2021-01-01T00:00:00</Date>
    <Author>AiHK</Author>
  </RegistrationInfo>
  <Triggers>
    <LogonTrigger>
      <Enabled>true</Enabled>
    </LogonTrigger>
  </Triggers>
  <Principals>
    <Principal id=""Author"">
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>false</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>P3D</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context=""Author"">
    <Exec>
      <Command>""" ahkPath """</Command>
      <Arguments>""" scriptPath """</Arguments>
      <WorkingDirectory>""" scriptDir """</WorkingDirectory>
    </Exec>
  </Actions>
</ScheduleTask>
)"

; 保存XML到临时文件
xmlFile := A_Temp "\task.xml"
FileAppend(xml, xmlFile)

; 创建任务
RunWait('schtasks /create /tn "' taskName '" /xml "' xmlFile '" /f',, 'Hide')

; 删除临时文件
FileDelete(xmlFile)

MsgBox("任务已创建。请重新启动以验证是否成功。")
ExitApp()

