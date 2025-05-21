# Run this script as Administrator

Write-Host "`nStopping Dell services, killing stubborn processes, and disabling tasks..." -ForegroundColor Cyan

# Services to stop/disable
$services = @(
    "DellClientManagementService",
    "DellTechHub",
    "DDVDataCollector",
    "DDVCollectorSvcApi",
    "DDVRulesProcessor",
    "DellUpdate",
    "DellSupportAssistAgent"
)

foreach ($service in $services) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        try {
            if ($svc.Status -eq "Running") {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Write-Host "Stopped service: $service"
            }
            Set-Service -Name $service -StartupType Disabled
            Write-Host "Disabled service: $service"
        } catch {
            Write-Host "Failed to disable service: $service" -ForegroundColor Yellow
        }
    }
}

# SubAgent EXEs to force-kill using WMI and taskkill
$dellSubAgentEXEs = @(
    "Dell.TechHub.Instrumentation.SubAgent.exe",
    "Dell.TechHub.DataManager.SubAgent.exe",
    "Dell.TechHub.Analytics.SubAgent.exe",
    "Dell.TechHub.exe",
    "Dell.Update.SubAgent.exe"
)

foreach ($exe in $dellSubAgentEXEs) {
    # WMI kill attempt
    $procs = Get-WmiObject Win32_Process -Filter "Name = '$exe'" -ErrorAction SilentlyContinue
    foreach ($proc in $procs) {
        try {
            $proc.Terminate() | Out-Null
            Write-Host "WMI Force-killed: $exe (PID: $($proc.ProcessId))"
        } catch {
            Write-Host "WMI failed to kill $exe" -ForegroundColor Yellow
        }
    }

    # Taskkill fallback
    try {
        taskkill /F /IM $exe /T > $null 2>&1
        Write-Host "Taskkill terminated: $exe"
    } catch {
        Write-Host "Taskkill failed for: $exe" -ForegroundColor Yellow
    }
}

# Disable scheduled Dell tasks
$taskPaths = @(
    "\Dell\CommandUpdate",
    "\Dell\SupportAssistAgent",
    "\Dell\TechHub"
)

foreach ($taskPath in $taskPaths) {
    try {
        $tasks = Get-ScheduledTask -TaskPath $taskPath -ErrorAction SilentlyContinue
        foreach ($task in $tasks) {
            Disable-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath
            Write-Host "Disabled scheduled task: $($task.TaskName)"
        }
    } catch {
        Write-Host "No scheduled tasks found under: $taskPath"
    }
}

Write-Host "`nAll Dell services and protected processes have been terminated and disabled." -ForegroundColor Green
