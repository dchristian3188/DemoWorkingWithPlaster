function Remove-DCWebServer
{
  <#
    .Synopsis
      Short description
    .DESCRIPTION
      Long description
    .EXAMPLE
      Example of how to use this cmdlet
  #>
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                SupportsShouldProcess=$true, 
                PositionalBinding=$false,
                HelpUri = 'http://www.microsoft.com/',
                ConfirmImpact='Medium')]
    Param
    (
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true, 
            Position=0)]
        [string[]]
        $ComputerName
    )
    begin
    {

    }
    process
    {
        forEach ($computer in $ComputerName)
        {

        }
    }
    end
    {

    }
}
