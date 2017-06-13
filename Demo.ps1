$baseDir = 'C:\github\DemoWorkingWithPlaster'
$outPutDir = Join-Path -Path $baseDir -ChildPath Output

# Install Latest Version
Find-Module -Name Plaster -Repository PSGallery | 
    Install-Module -Verbose -Force

Function Reset-Workspace
{
    Remove-Item -Path $outPutDir -Recurse -Force -ErrorAction SilentlyContinue -Verbose
    New-Item -Path $outPutDir -ItemType Directory -ErrorAction SilentlyContinue -Verbose > $null
}
Reset-Workspace


# Plaster Built in Commands

Get-Command -Module Plaster 

# Run Default Template
Clear-Host
$defaultTemplate  = Get-PlasterTemplate | 
    Where-Object -FilterScript {$PSItem.TItle -eq 'New PowerShell Manifest Module'}

Invoke-Plaster -TemplatePath $defaultTemplate.TemplatePath -DestinationPath "$outPutDir\PlasterBuiltIn"

code "$outPutDir\PlasterBuiltIn"

#Look at New-PlasterManifest
Clear-Host
Get-Help -Name New-PlasterManifest

# Create a new manifest
Clear-Host
New-Item -Path "$outPutDir\FirstDemo" -ItemType Directory -ErrorAction SilentlyContinue > $null

$manifestProperties = @{
    Path = "$outPutDir\FirstDemo\PlasterManifest.xml"
    Title = "Working with Plaster Demo"
    TemplateName = 'DemoTemplate'
    TemplateVersion = '0.0.1'
    Author = 'David Christian'
    Description = 'Our first Plaster Template'
    Verbose = $true
}

New-PlasterManifest @manifestProperties

# Look at new manifest
code "$outPutDir\FirstDemo\PlasterManifest.xml"

# Run our New Manifest
Clear-Host
Invoke-Plaster -TemplatePath "$outPutDir\FirstDemo\" -DestinationPath "$outPutDir\FirstDemoOutput" 


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
    <choice label="&amp;Yes" help="Adds a pester folder" value="$true" />
    <choice label="&amp;No" help="Does not add a pester folder" value="$false" />
</parameter>

## Multie Choice
<parameter name="FunctionFolders" type="multichoice" prompt="Please select folders to include" default='0,1,2'>
    <choice label="&amp;Public" help="Adds a public folder to module root" value="Public" />
    <choice label="&amp;Internal" help="Adds a internal folder to module root" value="Internal" />
    <choice label="&amp;Classes" help="Adds a classes folder to module root" value="Classes" />
    <choice label="&amp;Binaries" help="Adds a binaries folder to module root" value="Binaries" />
    <choice label="&amp;Data" help="Adds a data folder to module root" value="Data" />
</parameter>

# Content

# Plaster built in variables
Start-Process 'https://github.com/PowerShell/Plaster/blob/master/docs/en-US/about_Plaster_CreatingAManifest.help.md#powershell-constrained-runspace'

# New Manifest command
<newModuleManifest destination='${PLASTER_PARAM_ModuleName}.psd1' 
        moduleVersion='$PLASTER_PARAM_ModuleVersion' 
        rootModule='${PLASTER_PARAM_ModuleName}.psm1' 
        author='$PLASTER_PARAM_ModuleAuthor' 
        description='$PLASTER_PARAM_ModuleDesc'/>


# file sources
code $baseDir\Module\template.psm1
Copy-Item -Path $baseDir\module\template.psm1 -Destination $outPutDir\FirstDemo -Verbose

# File Content
<file source='template.psm1' destination='${PLASTER_PARAM_ModuleName}.psm1'/>

# Using conditionals

<file condition='$PLASTER_PARAM_Pester -eq $true' destination='Tests\' source='' />
<file condition='$PLASTER_PARAM_Pester -eq $true' destination='Tests\${PLASTER_PARAM_ModuleName}.tests.ps1' source='basicTest.ps1' />

# basic tests file - Remember to copy
code $baseDir\module\basicTest.ps1
Copy-Item -Path $baseDir\module\basicTest.ps1 -Destination $outPutDir\FirstDemo -Verbose


<file condition='$PLASTER_PARAM_FunctionFolders -contains "Public"' destination='Public\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Internal"' destination='Internal\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Classes"' destination='Classes\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Binaries"' destination='Binaries\' source='' />
<file condition='$PLASTER_PARAM_FunctionFolders -contains "Data"' destination='Data' source='' />


# Messages

<message> Creating you folders for module: $PLASTER_PARAM_ModuleName </message>

<message condition='$PLASTER_PARAM_Pester -eq $true'>Creating a Tests folder </message>



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

# Cleanup Output
Remove-Item -Path $outPutDir\FirstDemoOutput\* -Recurse -Force -Verbose
Clear-Host


# Requires Module

<requireModule name="Pester"
               minimumVersion="3.4.0"
               message="Warning!!! You've included Pester Tests, but do not have Pester installed"
               condition='$PLASTER_PARAM_Pester -eq $true'
               />


# Run it!
Invoke-Plaster -TemplatePath "$outPutDir\FirstDemo\" -DestinationPath "$outPutDir\FirstDemoOutput"

Code $outPutDir\FirstDemoOutput


# Setup Function Template
if (Test-Path -Path "$outPutDir\functionDemoOutput")
{
    Remove-Item -Path "$outPutDir\functionDemoOutput" -Recurse -Force -Verbose
}
New-Item -Path "$outPutDir\functionDemoOutput" -ItemType Directory > $null

## Function Template
Copy-Item -Path "$baseDir\function\functionPlasterManifestBase.xml" -Destination "$baseDir\function\PlasterManifest.xml" -Force -Verbose
code "$baseDir\function\PlasterManifest.xml"

# Run function Demo

Invoke-Plaster -TemplatePath "$baseDir\function" -DestinationPath "$outPutDir\functionDemoOutput"

# Modify

## Need to still copy
code "$baseDir\Function\testsTemplate.ps1"

<file source='testsTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.tests.ps1' />

## Modfy syntax
<modify path='${PLASTER_PARAM_FunctionName}.tests.ps1'>
    <replace>
        <original>xxModuleNamexx</original>
        <substitute expand='true'>${PLASTER_PARAM_FunctionName}</substitute>
    </replace>
</modify>

# templateFile

code "$baseDir\Function\functionTemplate.ps1"

<templateFile source='functionTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.ps1'/>

Invoke-Plaster -TemplatePath "$baseDir\Function\" -DestinationPath "$outPutDir\functionDemoOutPut"


## Non Interactive
$verbs = @('New','Get','Set','Remove')

ForEach($verb in $verbs)
{
    $functionDetails = @{
        FunctionName = "$($verb)-DCWebServer"
        Help = 'Yes'
        PipeLineSupport = 'Yes'
        CmdletBinding = 'Advanced'
        ComputerName = 'Yes'
        TemplatePath =  "$baseDir\Function\"
        DestinationPath = "$outPutDir\functionDemoOutput"
        NoLogo = $true
    }
    Invoke-Plaster @functionDetails
}

# Files are created

Get-ChildItem -Path "$outPutDir\functionDemoOutput\*DCWebServer*"

## Run all Tests
Invoke-Pester -Path "$outPutDir\functionDemoOutput" -Verbose


## Taged Modules
Code C:\github\PlasterTemplates

Copy-Item -Path C:\github\PlasterTemplates -Destination 'C:\Program Files\WindowsPowerShell\Modules\PlasterTemplates' -Verbose -Force -Recurse


Get-PlasterTemplate -IncludeInstalledModules