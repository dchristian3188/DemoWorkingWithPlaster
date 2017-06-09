# Install Latest Version
Find-Module -Name Plaster -Repository PSGallery | 
    Install-Module -Verbose -Force

Function Reset-Workspace
{
    Remove-Item -Path C:\temp -Recurse -Force 
    New-Item -Path C:\temp -ItemType Directory -ErrorAction SilentlyContinue > $null
}
Reset-Workspace


# Run Default Template
Clear-Host
$defaultTemplate = Get-PlasterTemplate
Invoke-Plaster -TemplatePath $defaultTemplate.TemplatePath -DestinationPath C:\temp\PlasterBuiltIn 

code C:\temp\PlasterBuiltIn\

#Look at New-PlasterManifest
Clear-Host
Get-Help -Name New-PlasterManifest

# Create a new manifest
Clear-Host
New-Item -Path C:\temp\FirstDemo -ItemType Directory -ErrorAction SilentlyContinue > $null

$manifestProperties = @{
    Path = "C:\Temp\FirstDemo\PlasterManifest.xml"
    Title = "Working with Plaster Demo"
    TemplateName = 'DemoTemplate'
    TemplateVersion = '0.0.1'
    Author = 'David Christian'
    Description = 'Our first Plaster Template'
    Verbose = $true
}


New-PlasterManifest @manifestProperties

# Look at new manifest
ise "C:\Temp\FirstDemo\PlasterManifest.xml"

# Run our New Manifest
Clear-Host
Invoke-Plaster -TemplatePath C:\temp\FirstDemo\ -DestinationPath C:\temp\Go -Verbose


# Parameters

## Reading input

<parameter name="ModuleName" type="text" prompt="Name of your module" />
<parameter name="ModuleDesc" type="text" prompt="Brief description on this module" />


# Default values
<parameter name="ModuleVersion" type="text" prompt="Version number"  default='0.0.0.1' />

# Special Types
<parameter name="ModuleAuthor" type="user-fullname" prompt="Author"/>

## choice - Validateset

<parameter name="Pester" type="choice" prompt="Include Pester Tests?" default='0'>
    <choice label="&amp;Yes" help="Adds a pester folder" value="Yes" />
    <choice label="&amp;No" help="Does not add a pester folder" value="No" />
</parameter>

## Multie Choice
<parameter name="FunctionFolders" type="multichoice" prompt="Please select folders to include" default='0,1,2'>
    <choice label="&amp;Public" help="Adds a public folder to module root" value="Public" />
    <choice label="&amp;Internal" help="Adds a internal folder to module root" value="Internal" />
    <choice label="&amp;Classes" help="Adds a classes folder to module root" value="Classes" />
    <choice label="&amp;Binaries" help="Adds a binaries folder to module root" value="Binaries" />
    <choice label="&amp;Data" help="Adds a data folder to module root" value="Data" />
</parameter>

# Plaster built in variables
Start-Process 'https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md#powershell-constrained-runspace'

# New Manifest command
<newModuleManifest destination='${PLASTER_PARAM_ModuleName}.psd1' 
        moduleVersion='$PLASTER_PARAM_ModuleVersion' 
        rootModule='${PLASTER_PARAM_ModuleName}.psm1' 
        author='$PLASTER_PARAM_ModuleAuthor' 
        description='$PLASTER_PARAM_ModuleDesc'/>

# File Content
<file source='template.psm1' destination='${PLASTER_PARAM_ModuleName}.psm1'/>

# file sources
$functionFolders = @('Public', 'Internal', 'Classes')
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions)
        {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }    
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions

# Using conditionals

<file condition='$PLASTER_PARAM_FunctionFolders -contains "Public"' destination='Public\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Internal"' destination='Internal\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Classes"' destination='Classes\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Binaries"' destination='Binaries\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Data"' destination='Data' source='' />

<file condition='$PLASTER_PARAM_Pester -eq "Yes"' destination='Tests\' source='' />
<file condition='$PLASTER_PARAM_Pester -eq "Yes"' destination='Tests\${PLASTER_PARAM_ModuleName}.tests.ps1' source='basicTest.ps1' />


# basic tests file
$moduleRoot = Resolve-Path "$PSScriptRoot\.."
$moduleName = Split-Path $moduleRoot -Leaf

Describe "General project validation: $moduleName" {

    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {@{file = $_}}         
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
    }
}

# Messages

<message> Creating you folders for module: $PLASTER_PARAM_ModuleName </message>

<message condition='$PLASTER_PARAM_Pester -eq "Yes"'>Creating a Tests folder </message>



<message>


                    Exterminate!
                   /
              ___
      D>=G==='   '.
            |======|
            |======|
        )--/]IIIIII]
           |_______|
           C O O O D
          C O  O  O D
         C  O  O  O  D
         C__O__O__O__D
        [_____________]


</message>


# Requires Module

<requireModule name="Pester" condition='$PLASTER_PARAM_Pester -eq "Yes"'
               minimumVersion="3.4.0"
               message="Warning!!! You've included Pester Tests, but do not have Pester installed"/>
# Setup Function Template

if(Test-Path -Path C:\temp\functionDemo)
{
    Remove-Item -Path C:\temp\functionDemo -Recurse -Force
    Remove-Item -Path C:\temp\functionOutput -Recurse -Force
}

New-Item -Path C:\temp\functionDemo -ItemType Directory > $null    
New-Item -Path C:\temp\functionOutput -ItemType Directory > $null
Copy-Item -Path C:\github\DemoWorkingWithPlaster\Function\testsTemplate.ps1 -Destination C:\temp\functionDemo\ -Verbose 
Copy-Item -Path C:\github\DemoWorkingWithPlaster\Function\functionTemplate.ps1 -Destination C:\temp\functionDemo\ -Verbose
Copy-Item -Path C:\github\DemoWorkingWithPlaster\Function\functionPlasterManifestBase.xml -Destination C:\temp\functionDemo\PlasterManifest.xml -Verbose




## Function Template

code C:\temp\functionDemo

# Run function Demo

Invoke-Plaster -TemplatePath C:\temp\functionDemo -DestinationPath C:\temp\functionOutput

# Modify

## Need to still copy

<file source='testsTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.tests.ps1' />

## Modfy syntax
<modify path='${PLASTER_PARAM_FunctionName}.tests.ps1'>
    <replace>
        <original>xxModuleNamexx</original>
        <substitute expand='true'>${PLASTER_PARAM_FunctionName}</substitute>
    </replace>
</modify>


Code C:\temp\functionOutput


# templateFile

<templateFile source='functionTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.ps1'/>

