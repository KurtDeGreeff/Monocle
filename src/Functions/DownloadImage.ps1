function DownloadImage
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $ElementName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $OutFile,

        [Parameter(Mandatory=$false)]
        [string] $TagName,

        [Parameter(Mandatory=$false)]
        [string] $AttributeName,

        [switch] $FindByValue,
        [switch] $MPath
    )

    # attemp to retrieve this session
    Test-MonocleSession

    Write-MonocleHost "Downloading image from $ElementName" $MonocleIESession

    $control = Get-Control $MonocleIESession $ElementName -tagName $TagName -attributeName $AttributeName -findByValue:$FindByValue -mpath:$MPath

    $tag = $control.tagName
    if ($tag -ine 'img' -and $tag -ine 'image')
    {
        throw "Element $ElementName is not an image element: $tag"
    }

    if ([string]::IsNullOrWhiteSpace($control.src))
    {
        throw "Element $ElementName has no src attribute"
    }

    Invoke-DownloadImage $MonocleIESession $control.src $OutFile
}