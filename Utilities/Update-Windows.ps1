Set-ExecutionPolicy unrestricted -Force;                   # Allow script execution
Install-Module PSWindowsUpdate -Force | Out-Null;    # Install update module silently
Import-Module PSWindowsUpdate;                       # Load the module
Get-WindowsUpdate -Install -AcceptAll -MicrosoftUpdate; # Install all available updates
