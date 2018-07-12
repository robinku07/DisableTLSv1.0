param([switch]$Elevated)
function Check-Admin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Check-Admin) -eq $false)  {
if ($elevated)
{
# could not elevate, quit
}
 
else {
 
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}
If ($(Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption) -Like 'Microsoft Windows Server 2012*')
{
$Process=(Start-Process reg -ArgumentList ('import 2012-Crypto.reg') -PassThru -Wait)
	if ($Process.ExitCode -eq 0)
	{
		Write-Host "Registry Settings Applied Successfully for Windows 2012. Restart Your Machine."
		Sleep 5
	}
	Else
	{
		Write-Host "Your Process Exited with a Error Code:$" $Process.ExitCode
	}
}
ElseIf ($(Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption) -Like 'Microsoft Windows Server 2016*')
{
$Process=(Start-Process reg -ArgumentList ('import 2016-Crypto.reg') -PassThru -Wait)
	if ($Process.ExitCode -eq 0)
	{
		Write-Host "Registry Settings Applied Successfully for Windows 2016. Restart Your Machine."
		Sleep 5
	}
	Else
	{
		Write-Host "Your Process Exited with a Error Code:$" $Process.ExitCode
	}
}
Else
{
Write-Host "Operating System Not supported."
}