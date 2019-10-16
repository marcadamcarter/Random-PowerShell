<#
    .SYNOPSIS
        Displays a list of hyperlinks from a web page.
	
    .DESCRIPTION
        Useful for identifying absolute hyperlinks when preparing for content migration

    .EXAMPLE
        Get-PageLinks -URL https://www.nist.gov/about-nist
        Get-PageLinks -URL https://www.army.mil | sort protocol | where protocol -notlike "javascript*"
        "https://www.nist.gov/about-nist" | Get-PageLinks | where protocol -like "http*"
#>
function Get-PageLinks{
    [CmdletBinding()]
    Param( 
        # URL of the web page to query
        [Parameter(Mandatory=$true, Position=0,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$URL
    )
    Begin { }
    Process { 
        foreach ($address in  $URL){
            $array = @()
            $wr = Invoke-WebRequest -Uri $address -Method Get -UseDefaultCredentials
            $links = $wr.ParsedHtml.links
            Write-Host "Found ($($links.length) total) links on the following page...`n'$($wr.ParsedHtml.nameProp)' - ($address)" -ForegroundColor Yellow
            foreach($link in $links){
                $props = @{
                    WebPage=$wr.ParsedHtml.nameProp
                    protocol=$link.protocol
                    textContent=$link.textContent
                    href=$link.href
                }
                $array += New-Object PSObject -Property $props
            }
            $array | Select-Object WebPage, protocol, textContent, href
        }
    }
}


