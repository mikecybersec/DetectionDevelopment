# Disable Windows Defender
# Open Powershell.exe as administrator
# Set your Execution-Policy to Unrestricted before running this!
# DO NOT USE THIS IN A PRODUCTION ENVIRONMENT

function Set-Wallpaper {
    param (
        [string]$Path,
        [ValidateSet('Tile', 'Center', 'Stretch', 'Fill', 'Fit', 'Span')]
        [string]$Style = 'Fill'
    )

    begin {
        try {
            Add-Type @"
                using System;
                using System.Runtime.InteropServices;
                using Microsoft.Win32;
                namespace Wallpaper
                {
                    public enum Style : int
                    {
	                    Tile, Center, Stretch, Fill, Fit, Span, NoChange
                    }

                    public class Setter
                    {
	                    public const int SetDesktopWallpaper = 20;
	                    public const int UpdateIniFile = 0x01;
	                    public const int SendWinIniChange = 0x02;
	                    [DllImport( "user32.dll", SetLastError = true, CharSet = CharSet.Auto )]
	                    private static extern int SystemParametersInfo ( int uAction, int uParam, string lpvParam, int fuWinIni );
	                    public static void SetWallpaper ( string path, Wallpaper.Style style )
                        {
		                    SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
		                    RegistryKey key = Registry.CurrentUser.OpenSubKey( "Control Panel\\Desktop", true );
		                    switch( style )
		                    {
			                    case Style.Tile :
			                    key.SetValue( @"WallpaperStyle", "0" ) ;
			                    key.SetValue( @"TileWallpaper", "1" ) ;
			                    break;
			                    case Style.Center :
			                    key.SetValue( @"WallpaperStyle", "0" ) ;
			                    key.SetValue( @"TileWallpaper", "0" ) ;
			                    break;
			                    case Style.Stretch :
			                    key.SetValue( @"WallpaperStyle", "2" ) ;
			                    key.SetValue( @"TileWallpaper", "0" ) ;
			                    break;
			                    case Style.Fill :
			                    key.SetValue( @"WallpaperStyle", "10" ) ;
			                    key.SetValue( @"TileWallpaper", "0" ) ;
			                    break;
			                    case Style.Fit :
			                    key.SetValue( @"WallpaperStyle", "6" ) ;
			                    key.SetValue( @"TileWallpaper", "0" ) ;
			                    break;
			                    case Style.Span :
			                    key.SetValue( @"WallpaperStyle", "22" ) ;
			                    key.SetValue( @"TileWallpaper", "0" ) ;
			                    break;
			                    case Style.NoChange :
			                    break;
		                    }
		                    key.Close();
	                    }
                    }
                }
"@
        } catch {}

        $StyleNum = @{
            Tile = 0
            Center = 1
            Stretch = 2
            Fill = 3
            Fit = 4
            Span = 5
        }
    }

    process {
        [Wallpaper.Setter]::SetWallpaper($Path, $StyleNum[$Style])

        # sometimes the wallpaper only changes after the second run, so I'll run it twice!
        
        [Wallpaper.Setter]::SetWallpaper($Path, $StyleNum[$Style])
    }
}

wget "https://raw.githubusercontent.com/mikecybersec/DetectionDevelopment/main/bg.jpg" -OutFile "$pwd\bg.jpg"

$path=$args[0]
Set-WallPaper -Path $pwd\bg.jpg -Style Fill


#Get Sysmon
wget "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "$pwd\Sysmon.zip"

#Get SwiftOnSecurity Sysmon Config
wget "https://github.com/SwiftOnSecurity/sysmon-config/archive/master.zip" -OutFile "$pwd\SwiftSysmon_master.zip"

#Get WinlogBeat
wget "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.10.1-windows-x86.zip" -OutFile "$pwd\winlogbeat-7.10.1.zip"

#Get AtomicRedTeam Repository
wget "https://github.com/redcanaryco/atomic-red-team/archive/master.zip" -OutFile "$pwd\AtomicRedTeam.zip"

#Get AtomicRedTeam Execution Framework
wget "https://github.com/redcanaryco/invoke-atomicredteam/archive/master.zip" -OutFile "$pwd\invoke-atomicredteam.zip"

Expand-Archive Sysmon.zip
Expand-Archive SwiftSysmon_master.zip
Expand-Archive winlogbeat-7.10.1.zip 
Move-Item -Path $pwd\winlogbeat-7.10.1 -Destination 'C:\Program Files\'
Expand-Archive AtomicRedTeam.zip
Expand-Archive invoke-atomicredteam.zip

Remove-Item Sysmon.zip
Remove-Item SwiftSysmon_master.zip
Remove-Item AtomicRedTeam.zip
Remove-Item invoke-atomicredteam.zip
Remove-Item winlogbeat-7.10.1.zip
Remove-Item background.jpg

& 'C:\Program Files\winlogbeat-7.10.1\winlogbeat-7.10.1-windows-x86\install-service-winlogbeat.ps1'
& $pwd\Sysmon\Sysmon.exe -accepteula -i $pwd\SwiftSysmon_master\sysmon-config-master\sysmonconfig-export.xml

Start-Service "sysmon"
Start-Service "winlogbeat"
Get-Service "sysmon"
Get-Service "winlogbeat"

Remove-Item .\SwiftSysmon_master -Recurse
Remove-Item .\Sysmon -Recurse

wget "https://raw.githubusercontent.com/logzio/public-certificates/master/AAACertificateServices.crt" -OutFile "C:\ProgramData\Winlogbeat\COMODORSADomainValidationSecureServerCA.crt"

Write-Host "Logzio Public Cert installed, all you need to do is log into Logz.io and grab your config from Send Your Data > Security > Sysmon, follow their instructions. :) "
