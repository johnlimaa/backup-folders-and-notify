. .\Send-StatusEmail.ps1

function Clear-RemoteLogFiles {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$RemoteHost,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$LogFolder,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$PassedDays,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $EmailSubject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $SendTo
    )

    Begin {
        $Server = New-PSSession -ComputerName $RemoteHost

        [bool]$ConnectedToHost = $false
        [bool]$FolderLocated = $false
        [bool]$NotifyError = $false
        [string]$EmailMessage

        if ($Server) {
            $ConnectedToHost = $true            
            if (Invoke-Command -Session $Server { Test-Path $using:LogFolder }) {
                $FolderLocated = $true
            }
        }
    }

    Process {
        if ($ConnectedToHost -and $FolderLocated) {
            $ScriptRunningDay = (Get-Date).addDays(-($PassedDays))
            Write-Host $ScriptRunningDay
            try {
                Invoke-Command -Session $Server { 
                    Get-ChildItem -Path $using:LogFolder -File | 
                    Where-Object {
                        (Get-Date -Date $_.CreationTime) -lt $using:ScriptRunningDay
                    } | Remove-Item -Force -Verbose
                }
            }
            catch {
                $NotifyError = $true
                $EmailMessage = "Files couldn't be acessed or deleted"
            }
            
            $EmailMessage = "Logs and backup files were deleted, on " + $LogFolder + "."
            Disconnect-PSSession -Session $Server            
        }
        else {
            $NotifyError = $true
            $EmailMessage = "Folders couldn't be accessed or connection between server and requester failed."
        }
    }

    End {
        if ($NotifyError) {
            Send-StatusEmail -Subject $EmailSubject -To $SendTo -Body  $EmailMessage -Status "ERROR"
        } else {
            Send-StatusEmail -Subject $EmailSubject -To $SendTo -Body $EmailMessage -Status "OK"
        }        
    }
}