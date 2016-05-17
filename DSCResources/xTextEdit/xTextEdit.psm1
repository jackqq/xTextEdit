function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [parameter(Mandatory = $true)]
        [System.String]
        $SetScript,

        [parameter(Mandatory = $true)]
        [System.String]
        $TestScript
    )

    return @{
    }
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [System.String]
        $Encoding = "utf8",

        [parameter(Mandatory = $true)]
        [System.String]
        $SetScript,

        [parameter(Mandatory = $true)]
        [System.String]
        $TestScript
    )

    $ss = Get-Content $Path -Encoding $Encoding

    $script = [ScriptBlock]::Create($SetScript)

    & $script

    Set-Content $Path -Value $ss -Encoding $Encoding
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [System.String]
        $Encoding = "utf8",

        [parameter(Mandatory = $true)]
        [System.String]
        $SetScript,

        [parameter(Mandatory = $true)]
        [System.String]
        $TestScript
    )

    $ss = Get-Content $Path -Encoding $Encoding

    $script = [ScriptBlock]::Create($TestScript)

    return & $script
}


Export-ModuleMember -Function *-TargetResource
