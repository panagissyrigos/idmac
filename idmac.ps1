<#
   Use the api from maclookup.app to retrieve information regarding a specific MAC/NIC address.

   Written by Panagis Syrigos

#>

Param (
    [string] $mac = "", # the mac address. It accepts xxxxxxxxxxxx xx-xx-xx-xx-xx-xx
    [switch] $raw   # if set, display the raw data as received from the API
)


if ($mac.Length -gt 0) {
    try {
        $res = Invoke-RestMethod "https://api.maclookup.app/v2/macs/$mac"
        if ($res.success) {
            if ($res.found) {
                if ($raw) {
                    $res
                }
                else {
                    # to do: build a function to accept colors inline.
                    write-host "The MAC address belongs to " -NoNewline
                    write-host "$($res.company)" -Foregroundcolor yellow -NoNewline 
                    write-host " and is part of the range" -NoNewline 
                    write-host " $($res.blockstart)" -Foregroundcolor green -NoNewline
                    write-host "-" -NoNewline
                    write-host "$($res.blockend)" -Foregroundcolor green -NoNewline
                    write-host "." 
                    write-host "It was last updated on " -NoNewline
                    write-host "$($res.updated)" -Foregroundcolor green
                }
            }
            else {
                write-warning "The API couldn't find the mac address '$mac'"
            }
        }
        else {
            write-warning "The API call returned a fail."
        }
    }
    catch {
        write-warning "The api returned an error. Sorry!"
    }
}
else {
    write-host "Usage: idmac.ps1 <mac address> [-raw]"
}