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

