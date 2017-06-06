# Install Latest Version
Find-Module -Name Plaster -Repository PSGallery | 
    Install-Module -Verbose -Force

# CleanUp Temp
Remove-Item -Path C:\temp -Recurse -Force 
New-Item -Path C:\temp -ItemType Directory -ErrorAction SilentlyContinue > $null

# Run Default Template
$defaultTemplate = Get-PlasterTemplate
Invoke-Plaster -TemplatePath $defaultTemplate.TemplatePath -DestinationPath C:\temp\PlasterBuiltIn 

Code C:\temp\PlasterBuiltIn

# Create a new manifest
New-Item -Path C:\temp\FirstDemo -ItemType Directory -ErrorAction SilentlyContinue > $null

$manifestProperties = @{
    Path = "C:\Temp\FirstDemo\PlasterManifest.xml"
    Title = "Working with Plaster Demo"
    TemplateName = 'DemoTemplate'
    TemplateVersion = '0.0.1'
    Author = 'David Christian'
    Description = 'Our first Plaster Template'
}

New-PlasterManifest @manifestProperties

# Look at new manifest
code "C:\Temp\PlasterManifest.xml"

Invoke-Plaster -TemplatePath C:\temp\FirstDemo\PlasterManifest.xml -DestinationPath C:\temp\Go