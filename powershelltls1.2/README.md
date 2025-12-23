# Habilitar TLS 1.2 (PowerShell Script)

Este script automatiza a configuração do Windows para habilitar e forçar o uso do protocolo de segurança **TLS 1.2**. Ele realiza alterações no Registro do Windows para garantir que tanto o .NET Framework quanto o SCHANNEL (Secure Channel) utilizem padrões modernos de criptografia.

## 📋 Funcionalidades

O script executa as seguintes ações de configuração:

### 1. Configuração do .NET Framework (v4.0.30319)
Ajusta as configurações para aplicações .NET, garantindo que elas usem os protocolos mais seguros disponíveis no sistema.
*   **SystemDefaultTlsVersions = 1**: Instrui o .NET a usar a versão de TLS configurada no sistema operacional, em vez de usar padrões hardcoded antigos.
*   **SchUseStrongCrypto = 1**: Força o .NET a usar criptografia forte.
*   *Nota*: As alterações são aplicadas tanto para o ambiente de 64 bits quanto para 32 bits (`WOW6432Node`).

### 2. Configuração do SCHANNEL
Configura a biblioteca de segurança padrão do Windows para suportar explicitamente o TLS 1.2.
*   **Server**: Habilita o TLS 1.2 para conexões de entrada (quando o Windows atua como servidor).
*   **Client**: Habilita o TLS 1.2 para conexões de saída (quando o Windows atua como cliente).
*   Define `Enabled = 1` e `DisabledByDefault = 0`.

## ⚠️ Pré-requisitos

*   **Privilégios de Administrador**: O script modifica chaves na `HKEY_LOCAL_MACHINE` (HKLM), portanto, o PowerShell deve ser executado como Administrador.
*   **Reinicialização**: Para que as alterações no SCHANNEL entrem em vigor completamente em todos os serviços, uma reinicialização do sistema é recomendada após a execução.

## 🚀 Como usar

1.  Abra o terminal do PowerShell como **Administrador**.
2.  Navegue até o diretório onde o script está salvo.
3.  Execute o comando:

    ```powershell
    .\Powershelltls1.2.ps1
    ```

4.  O script exibirá a mensagem: `TLS 1.2 has been enabled.`

## 🔍 Chaves de Registro Modificadas

*   `HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319`
*   `HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319`
*   `HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client`
*   `HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server`