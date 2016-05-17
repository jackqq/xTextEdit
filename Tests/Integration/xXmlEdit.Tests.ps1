$resource_name = ($MyInvocation.MyCommand.Name -split '\.')[0]
$resource_path = $PSScriptRoot + "\..\..\DSCResources\${resource_name}"

if (! (Get-Module xDSCResourceDesigner)) {
    Import-Module -Name xDSCResourceDesigner
}

Describe -Tag 'DSCResource' "${resource_name}, the DSC resource" {
    It 'Passes Test-xDscResource' {
        Test-xDscResource $resource_path | Should Be $true
    }

    It 'Passes Test-xDscSchema' {
        Test-xDscSchema "${resource_path}\${resource_name}.schema.mof" | Should Be $true
    }
}

if (Get-Module $resource_name) {
    Remove-Module $resource_name
}

Import-Module "${resource_path}\${resource_name}.psm1"

Describe -Tag 'Integration' "${resource_name}, Integration Tests" {

}
