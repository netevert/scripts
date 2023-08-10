# Making sure all names are resolved
Resolve-DnsName github.com
Resolve-DnsName raw.githubusercontent.com
Resolve-DnsName live.sysinternals.com

# Purpose: Installs a handful of SysInternals tools on the host into c:\Tools\Sysinternals
$sysinternalsDir = "C:\Tools\Sysinternals"
$sysmonDir = "C:\ProgramData\Sysmon"
If(!(test-path $sysinternalsDir)) {
  New-Item -ItemType Directory -Force -Path $sysinternalsDir
} Else {
  Continue
}
If(!(test-path $sysmonDir)) {
  New-Item -ItemType Directory -Force -Path $sysmonDir
} Else {
  Continue
}
$autorunsPath = "C:\Tools\Sysinternals\Autoruns64.exe"
$sysmonPath = "C:\Tools\Sysinternals\Sysmon.exe"
$sysmonConfigPath = "$sysmonDir\sysmonConfig.xml"

# Microsoft likes TLSv1.2 as well
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Autoruns64.exe', $autorunsPath)
(New-Object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon.exe', $sysmonPath)

# Download Sentinel ATT&CK Sysmon config
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml', "$sysmonConfigPath")

# Start Sysmon
Start-Process -FilePath "$sysmonPath" -ArgumentList "-accepteula -i $sysmonConfigPath"
Start-Sleep 5 # Give the service time to start
