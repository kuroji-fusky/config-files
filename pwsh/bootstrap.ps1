#Requires -RunAsAdministrator

# Stuff that requires admin privilages for screwing around with the registry
Write-Output "Writing stuff to registry"

# Enable verbose log for shutdown, restart, login, etc
$RD_VerboseLogging = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $RD_VerboseLogging -Name "verbosestatus" -Value 1 -Type Dword -Force

# Show file extensions
$RD_FileExt = "KHCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $RD_FileExt -Name "HideFileExt" -Value 0 -Type Dword -Force


$winget_programs = @(
  # The good stuff
  "Git.Git",
  "Mozilla.Firefox",
  "Mozilla.Thunderbird",
  "Brave.Brave",
  "GitHub.GitHubDesktop",
  "7zip.7zip",
  "CoreyButler.NVMforWindows",
  "Python.Python.3.11",
  "GoLang.Go.1.19",
  "Rustlang.Rustup",
  "IObit.IObitUnlocker",
  "AutoHotkey.AutoHotkey",

  # Video stuff
  "VideoLAN.VLC",
  "HandBrake.HandBrake",
  "OBSProject.OBSStudio",
  
  # Code editors/IDEs
  "Neovim.Neovim",
  "Microsoft.VisualStudioCode.Insiders",
  "Microsoft.VisualStudio.2022.Community",
  "JetBrains.PyCharm.Community",

  # Productivity and management
  "Notion.Notion",
  "Discord.Discord",
  "Telegram.TelegramDesktop",
  "Valve.Steam",
  "WinDirStat.WinDirStat",
  "voidtools.Everything",
  "Figma.Figma",
  "Google.Drive",
  
  # Miscellanous
  "Oracle.VirtualBox",
  "Glarysoft.GlaryUtilities",
  
  # Redistributables and runtimes
  "Microsoft.DotNet.DesktopRuntime.6",
  "Microsoft.VCRedist.2010.x86",
  "Microsoft.VCRedist.2010.x64",
  "Microsoft.VCRedist.2012.x86",
  "Microsoft.VCRedist.2012.x64",
  "Microsoft.VCRedist.2013.x86",
  "Microsoft.VCRedist.2013.x64",

  # Fancy terminal stuff
  "JanDeDobbeleer.OhMyPosh",
  "Microsoft.PowerShell.Preview",
  "Microsoft.WindowsTerminal"
)

function SetupWorkspace {
  Write-Output "Installing your crap right now"
  Write-Output "Installing stuff via winget"

  foreach ($program in $winget_programs) {
    Write-Output "Installing $program..."
    winget install -e --id $program
  }

  # Install latest node version using nvm
  nvm install lts
  npm install --global yarn typescript serve pnpm

  # Global python stuff
  python -m pip install -U autopep8 yapf poetry opencv-python

  # Setup git stuff
  Write-Output "Setup almost done!"

  $name = Read-Host "Enter username: "
  $email = Read-Host "Enter email: "

  git config --global user.name $name
  git config --global user.email $email
  git config --global core.ignorecase false
}

# Check if the winget command is available, just in case
# of a fresh install
if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Output "winget not detected on your system, installing..."
  Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
  SetupWorkspace
}
else {
  SetupWorkspace
}

# ———————————————————————————————————————
# Register custom command aliases
& $PSScriptRoot\powershell\aliases.ps1