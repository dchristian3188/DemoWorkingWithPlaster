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
Invoke-Plaster -TemplatePath C:\temp\FirstDemo\ -DestinationPath C:\temp\Go


# Parameters

## Reading input

<parameter name="ModuleName" type="text" prompt="Name of your module" />
<parameter name="ModuleDesc" type="text" prompt="Brief description on this module" />


# Default values
<parameter name="ModuleVersion" type="text" prompt="Version number (0.0.0.1)"  default='0.0.0.1' />


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

