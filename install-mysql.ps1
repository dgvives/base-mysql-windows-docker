$env:Path += ";C:\mysql\bin"
setx Path $env:Path /m

# Initial config
Add-Content "c:\mysql\my.ini" "[mysqld]"; 
Add-Content "c:\mysql\my.ini" "explicit_defaults_for_timestamp=1"; 
Add-Content "c:\mysql\my.ini" "basedir=C:\mysql" ; 
Add-Content "c:\mysql\my.ini" "datadir=C:\mysql\data"; 
Add-Content "c:\mysql\my.ini" "sql-mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'"; 
Add-Content "c:\mysql\my.ini" "character-set-server=utf8";     
Add-Content "c:\mysql\my.ini" "default-time-zone='utc'";     

# Init timezones
(New-Object System.Net.WebClient).DownloadFile('https://downloads.mysql.com/general/timezone_2020d_posix.zip','c:\timezone_2020d_posix.zip');
Expand-Archive 'c:\timezone_2020d_posix.zip' 'C:\'
Remove-Item 'c:\timezone_2020d_posix.zip' -Force; 
Copy-Item 'c:\timezone_2020d_posix\*' 'C:\mysql\data\mysql\.' -Force ; 
Remove-Item 'c:\timezone_2020d_posix' -Force -Recurse; 


mysqld --defaults-file=c:\mysql\my.ini --initialize-insecure
mysqld --install


start-service mysql
