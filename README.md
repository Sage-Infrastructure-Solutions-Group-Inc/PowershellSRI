# PowerShell SRI (Subresource Integrity) Module
This is a very simple powershell module that enables easy
generation of SRI signatures.

## Basic Usage
The following is the basic workflow of using this module. 

```powershell
Import-Module powershell-sri.psm1
Get-SRI -sourceUri  https://wcpstatic.microsoft.com/mscc/lib/v2/wcp-consent.js -hashAlgo sha384
```
Which should provide similar output to the following:
```text
Hash                                                                    HTML
----                                                                    ----
sha384-AW6ZbRXHPnLr9wK5eggGggy74yuRfvR1LjcpHwahLA5cBh196cGU69hzONl3ThbX <script src="https://wcpstatic.microsoft.com...
```

### Why use SRI?
When utilizing third-parties for content delivery it is possible
that their systems will be compromised. This _supply chain attack_ could
result in the compromise of your users and their data if a signature is not
provided in the HTML code.