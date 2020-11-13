function Send-StatusEmail {
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $To,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String] $Subject,

        [Parameter()]        
        [String] $Body = "This is an email template and you recived as development test.",

        [Parameter()]
        [String] $Status
    )

    Begin {
        $StatusMessage = $null

        if (-Not [string]::IsNullOrEmpty($Status)) {
            if ($Status -eq "OK") {
                $StatusMessage = @"
                <div style="
                margin: 0 auto;
                background-color: #00e673;
                color: #ffffff;
                ">
                OKAY
                </div>
"@
            } elseif ($Status -eq "ERROR") {
                $StatusMessage = @"
                <div style="
                margin: 0 auto;
                background-color: #ff6666;
                color: #ffffff;
                ">
                ERROR
                </div>
"@
            }
        } else {
            $StatusMessage = @"
            <div style="
        	margin: 0 auto;
            ">            
            </div>
"@
        }

        $Body = @"
        <!DOCTYPE html>
<html>
<head>
<title>Email sent via Powershell's Script</title>
</head>
<body>

<div style="
	display: block;
    border: 1px solid #4d4d4d; 
    margin: 0 auto;
    text-align: center;
   	">
	<h2>Automated Email System</h2>
    
    <div>
    	<p>$Body</p>
        $StatusMessage
    </div>
    <span style="
    margin-top: 40px;
    ">
    IT Departament</span>
</div>

</body>
</html>
"@
        $CreatingEmail = @{
	    # Altere o e-mail utilizado para enviar a notificacao
            From = "mail@mail.com"
            To = $To
            Body = $Body                 
            Subject = $Subject
	    # Altere o SMTP Server
            SmtpServer = "mail-server"
            Encoding = "UTF8"
        }

    }

    Process {
        Send-MailMessage @CreatingEmail -BodyAsHtml
    }

    End {
        Write-Host `n "Email sent."
    }
}
