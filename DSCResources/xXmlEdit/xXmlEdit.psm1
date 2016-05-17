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

        [parameter(Mandatory = $true)]
        [System.String]
        $SetScript,

        [parameter(Mandatory = $true)]
        [System.String]
        $TestScript
    )

    [xml] $x = Get-Content $Path

    $script = [ScriptBlock]::Create($SetScript)

    & $script

    $x.Save($Path)
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

        [parameter(Mandatory = $true)]
        [System.String]
        $SetScript,

        [parameter(Mandatory = $true)]
        [System.String]
        $TestScript
    )

    [xml] $x = Get-Content $Path

    $script = [ScriptBlock]::Create($TestScript)

    return & $script
}


Export-ModuleMember -Function *-TargetResource
