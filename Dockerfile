FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell"]

USER ContainerAdministrator

RUN (New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe','vc_redist.x64.exe'); 

RUN "/vc_redist.x64.exe /install /quiet /norestart"; 

RUN Remove-Item 'vc_redist.x64.exe';

RUN (New-Object System.Net.WebClient).DownloadFile('https://downloads.mysql.com/archives/get/p/23/file/mysql-5.6.10-winx64.zip', 'mysql.zip'); \
    Expand-Archive 'mysql.zip' 'C:\.' ; \
    Remove-Item 'mysql.zip' -Force; \ 
    REN c:\mysql-5.6.10-winx64 mysql ;

EXPOSE 3306

COPY install-mysql.ps1 /

RUN .\install-mysql.ps1

COPY start-mysql.ps1 /

CMD .\start-mysql.ps1 $env:MYSQL_ROOT_PASSWORD


