reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters" /v BasicAuthLevel /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Internet" /v BasicAuthLevel /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Internet" /v OpenDocumentsReadWriteWhileBrowsing /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\Trusted Locations\Location10" /v AllowSubFolders /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security\Trusted Locations\Location10" /v Path /t REG_SZ /d http://alfresco.shortlaw/alfresco/webdav/Sites /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Word\Security" /v MarkInternalAsUnsafe /t REG_DWORD /d 0 /f
