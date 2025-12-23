# Configuração de Log
$LogFile = Join-Path $PSScriptRoot "TLS_Config_Log_$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
Start-Transcript -Path $LogFile

# Verifica se está rodando como Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script precisa ser executado como Administrador!"
    Stop-Transcript
    break
}

# Função para configurar chaves de registro de forma segura e logar
function Set-RegistryKey {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [string]$PropertyType = 'DWord'
    )

    try {
        # Cria o caminho se não existir
        if (-not (Test-Path $Path)) {
            New-Item $Path -Force | Out-Null
            Write-Output "Caminho criado: $Path"
        }

        # Define a propriedade
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType -Force | Out-Null
        Write-Output "Chave configurada com sucesso: $Path\$Name = $Value"
    }
    catch {
        Write-Error "Falha ao configurar chave $Path\$Name. Erro: $_"
    }
}

# Configurações do .NET Framework (32 e 64 bits)
$NetFrameworkPaths = @(
    'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319',
    'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319'
)

foreach ($Path in $NetFrameworkPaths) {
    Set-RegistryKey -Path $Path -Name 'SystemDefaultTlsVersions' -Value '1'
    Set-RegistryKey -Path $Path -Name 'SchUseStrongCrypto' -Value '1'
}

# Configurações do SCHANNEL (TLS 1.2 Server e Client)
$SchannelPaths = @(
    'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server',
    'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
)

foreach ($Path in $SchannelPaths) {
    Set-RegistryKey -Path $Path -Name 'Enabled' -Value '1'
    Set-RegistryKey -Path $Path -Name 'DisabledByDefault' -Value '0'
}

Write-Host 'TLS 1.2 foi habilitado com sucesso. Verifique o arquivo de log para detalhes.' -ForegroundColor Green
Stop-Transcript
