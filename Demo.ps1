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

## Function Template
<?xml version="1.0" encoding="UTF-8"?>
<plasterManifest 
  xmlns="http://www.microsoft.com/schemas/PowerShell/Plaster/v1" schemaVersion="1.0">
  <metadata>
    <name>FunctionTemplate</name>
    <id>c0b57946d-f52f-4168-b152-4fdb334b9fca</id>
    <version>0.0.1</version>
    <title>DC Custom Function Template</title>
    <description />
    <author>David Christian</author>
    <tags />
  </metadata>
  <parameters>
    <parameter name="FunctionName" type="text" prompt="Name of your Function" />
    <parameter name="Help" type="choice" prompt="Include Comment Based Help?" default='0'>
      <choice label="&amp;Yes" help="Adds comment based help" value="Yes" />
      <choice label="&amp;No" help="Does not add comment based help" value="No" />
    </parameter>
    <parameter name="PipelineSupport" type="choice" prompt="Include Begin Process End blocks?" default='0'>
      <choice label="&amp;Yes" help="Adds a pester folder" value="Yes" />
      <choice label="&amp;No" help="Does not add a pester folder" value="No" />
    </parameter>
    <parameter name="CmdletBinding" type="choice" prompt="Simple cmdlet binding or Advanced?" default='0'>
      <choice label="&amp;simple" help="Adds an empty cmdlet binding block" value="Simple" />
      <choice label="&amp;Advanced" help="Adds all options to cmdlet binding" value="Advanced" />
    </parameter>
    <parameter name="ComputerName" type="choice" prompt="Add a paramater for computername" default='0'>
      <choice label="&amp;Yes" help="Adds a default parameter for computername" value="Yes" />
      <choice label="&amp;No" help="Does not include computername parameter" value="No" />
    </parameter>
  </parameters>
  <content>
  </content>
</plasterManifest>

# templateFile

<templateFile source='functionTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.ps1'/>


    <templateFile source='testsTemplate.ps1' destination='${PLASTER_PARAM_FunctionName}.tests.ps1'/>