💻 Dell Service & SubAgent Disabler (PowerShell Script)

This PowerShell script is designed to stop, disable, and force-kill background services and processes associated with Dell Command | Update, Dell TechHub, and related SubAgent executables that often consume excessive CPU and memory.

⚙️ What It Does
Stops and disables Dell-related Windows services

Force-kills persistent processes such as:

Dell.TechHub.Instrumentation.SubAgent.exe

Dell.TechHub.DataManager.SubAgent.exe

Dell.TechHub.Analytics.SubAgent.exe

Dell.TechHub.exe

Dell.Update.SubAgent.exe

Disables Dell-related scheduled tasks to prevent relaunch after reboot

🚨 Warning
This script does not uninstall any Dell software, but it will disable the functionality of Dell Command | Update and associated components. Use this at your own risk, especially in enterprise environments where Dell utilities may be managed centrally.

✅ Supported OS

Windows 10

Windows 11

Tested on Dell systems running Dell Command | Update 5.5.0 and higher

📦 Services Targeted

DellClientManagementService

DellTechHub

DDVDataCollector

DDVCollectorSvcApi

DDVRulesProcessor

DellUpdate

DellSupportAssistAgent

🔫 Processes Force-Killed

This script uses WMI-based termination and taskkill to ensure all related executables are forcefully stopped:

Dell.TechHub.Instrumentation.SubAgent.exe

Dell.TechHub.DataManager.SubAgent.exe

Dell.TechHub.Analytics.SubAgent.exe

Dell.TechHub.exe

Dell.Update.SubAgent.exe

🛠 How to Use

Right-click PowerShell > Run as Administrator

Clone or download this repo

Run the script:

powershell

Copy

Edit

Set-ExecutionPolicy Bypass -Scope Process -Force
.\disable-dell-subagents.ps1

✅ That's it! No reboot required.

📁 Optional

If you're looking to block the executables from ever launching again, you can:

Use icacls to deny execution permissions on the .exe files.

Deploy this via GPO or your RMM for multiple machines.

📜 License

This project is open-source and provided as-is under the MIT License.

