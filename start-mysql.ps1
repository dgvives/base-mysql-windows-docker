Param(
[Parameter(Mandatory=$true)]
[String]$MYSQL_ROOT_PASSWORD
)

$env:Path += ";C:\mysql\bin"
setx Path $env:Path /m

$started=$false
For ($i=0; $i -le 180; $i++) {
    mysqladmin -u root status | Out-Null
    if ($LastExitCode -eq 0) {
        $started=$true
        break;
    }
    Start-Sleep 1
}
if (!$started) {
    Get-EventLog -LogName System -After (Get-Date).AddMinutes(-5) | Select -ExpandProperty Message
    Write-Error "mysql failed to start in 180 seconds"
    exit 1
}
Write-Output 'MySQL is up and running'

mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;"
Write-Output "Updated password for root to '$MYSQL_ROOT_PASSWORD'"


Get-EventLog -LogName System -After (Get-Date).AddMinutes(-5) | Select -ExpandProperty Message
$idx = (get-eventlog -LogName System -Newest 1).Index;
while ($true)
{
    start-sleep -Seconds 1
    $idx2  = (Get-EventLog -LogName System -newest 1).index
    get-eventlog -logname system -newest ($idx2 - $idx) |  sort index | Select -ExpandProperty Message
    $idx = $idx2
}
