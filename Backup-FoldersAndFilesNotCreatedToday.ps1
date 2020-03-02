. .\Send-StatusEmail.ps1

function Backup-FoldersAndFilesNotCreatedToday {
    [CmdletBinding()]
    
    Param (  
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$OriginFolder,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DestinationFolder,            

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$LogFileDestination,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $EmailSubject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $SendTo
    )

    Begin {               

        $BackupDay = Get-Date -Format "dd/MM/yyyy"
        $Erro = @{
            Status  = $false
            Message = $null
            LogFile = "\\path" + 
            $BackupDay.Replace("/", "-") + ".log"
        }        
        
        if (-Not (Test-Path $OriginFolder) -and -Not $Erro.Status) {
            Start-Transcript -Path $Erro.LogFile -Force
            Write-Host `n "Origin folder is unavaible or invalid." 
            Write-Host `n $OriginFolder
            Stop-Transcript
            
            $Erro.Message = "Origin folder is unavaible or invalid."
            $Erro.Status = $true
                        
        }
        elseif (-Not $Erro.Status) {
            $FilesAndFoldersToCopy = $OriginFolder + "*"
        }

        if (-Not (Test-Path $DestinationFolder) -and -Not $Erro.Status) {
            Start-Transcript -Path $Erro.LogFile -Force
            Write-Host `n "Destination folder is unavaible or invalid."
            Write-Host `n $DestinationFolder
            Stop-Transcript 
            
            $Erro.Message = "Destination folder is unavaible or invalid."
            $Erro.Status = $true
                    
        }
        elseif (-Not $Erro.Status) {
            $BackupDayFolder = $DestinationFolder +
            $BackupDay.Replace("/", "-") + "\"
        }
        
        if (-Not [string]::IsNullOrEmpty($LogFileDestination)) {
            if (-Not (Test-Path $LogFileDestination) -and -Not $Erro.Status) {
                Start-Transcript -Path $Erro.LogFile -Force
                Write-Host `n "Log file destination is unavaible or invalid."
                Write-Host `n $LogFileDestination
                Stop-Transcript
                
                $Erro.Message = "Log file destination is unavaible or invalid."
                $Erro.Status = $true
                
            }
        }
        elseif (-Not $Erro.Status) {
            $LogFileDestination = $DestinationFolder + "log\" +
            $BackupDay.Replace("/", "-") + ".log"      
        }
    
    }

    Process {
        if (-Not $Erro.Status) {
            Start-Transcript -Path $LogFileDestination -Force
        
            Write-Host `n "Connected to $OriginFolder"
            Write-Host `n "Connected to $DestinationFolder"        
            Write-Host `n "Starting backup."

            If (Test-Path $BackupDayFolder) {
                Write-Host `n "Directory already created."
            }
            Else {
                Write-Host `n "Directory being created..."
                New-Item -ItemType "directory" -Path $BackupDayFolder -Verbose
            }

            Write-Host `n "Running files and folders backup..."
            Copy-Item -Path $FilesAndFoldersToCopy -Destination $BackupDayFolder -Recurse -Force -Verbose

            Write-Host `n "Removing files not created today..."
            Get-ChildItem -Path $OriginFolder -File |
            Where-Object {
                (Get-Date -Date $_.LastWriteTime -Format "dd/MM/yyyy") -ne $BackupDay
            } |
            Remove-Item -Recurse -Force -Verbose

            Write-Host `n "Removing folders not created today..."
            Get-ChildItem -Path $OriginFolder -Directory |
            Where-Object {
                (Get-Date -Date $_.LastWriteTime -Format "dd/MM/yyyy") -ne $BackupDay
            } |
            Remove-Item -Recurse -Force -Verbose

            Write-Host `n "Backup ended."

            Stop-Transcript
        }
    }

    End {
        if ($Erro.Status) {
            Send-StatusEmail -Subject $EmailSubject -To $SendTo -Body $Erro.Message -Status "ERROR"        
        }
        else {
            Send-StatusEmail -Subject $EmailSubject -To $SendTo -Body "Backup done." -Status "OK"
        }
    }
}