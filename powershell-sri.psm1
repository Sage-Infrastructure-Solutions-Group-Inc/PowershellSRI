
function Get-SRI {
param(
    [Parameter(Mandatory=$true)]
    [string]
    $sourceUri,

    [Parameter(Mandatory=$true)]
    [string] 
    $hashAlgo,

    [bool]
    $printValues
)


function Get-Hasher($algo) {
    $algo = $algo.ToUpper()
    switch ($algo) {
        "SHA265" { return [System.Security.Cryptography.SHA256]::Create()}
        "SHA384" { return [System.Security.Cryptography.SHA384]::Create()}
        "SHA512" { return [System.Security.Cryptography.SHA512]::Create()}
        default { 
            Write-Host "Invalid hash selection. Defaulting to SHA256"
            return [System.Security.Cryptography.SHA256]::Create()
            }
    }
}

function Get-HashPrefix($algo) {
    $algo = $algo.ToUpper()
    switch ($algo) {
        "SHA265" { return "sha256-"}
        "SHA384" { return "sha384-"}
        "SHA512" { return "sha512-"}
        default { 
            return "sha256-"
            }
    }
}


function Get-Data-Bytes ($uri) {
    if ($uri.StartsWith("http")) {
        $resp = Invoke-WebRequest -Uri $uri
        return [System.Text.Encoding]::UTF8.GetBytes($resp.Content)
    }
    return Get-Content $uri -Raw 
}
$inputData = Get-Data-Bytes($sourceUri)
$hash = Get-Hasher($hashAlgo)
$computedHash = $hash.ComputeHash($inputData)
$hash_str = (Get-HashPrefix($hashAlgo)) + [System.Convert]::ToBase64String($computedHash)
$html = "<script src=""{0}"" integrity=""{1}"" crossorigin=""anonymous""></script>" -f $sourceUri, $hash_str
if ($printValues) {
    Write-Host ("Hash: " + $hash_str)
    Write-Host ("HTML: " + $html)
    }
 $obj = New-Object PSObject -Property @{
    Hash = $hash_str
    HTML = $html
    }
    return $obj
}



Export-ModuleMember Get-SRI