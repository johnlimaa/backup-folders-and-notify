# Scripts em Powershell
Essa dupla de scripts foi criada para executar o backup de diretórios em rede e notificar via e-mail o setor responsável. 
Para utilizar de forma automática, utilizei o Agendador de Tarefas do Windows.

Inicie uma sessão do Powershell, importe o script e chame sua função:

. \\path\Backup-FoldersAndFilesNotCreatedToday.ps1; Backup-FoldersAndFilesNotCreatedToday -OriginFolder '\\Origin\' -DestinationFolder '\\Destination\' -EmailSubject 'Backup Script' -SendTo 'mail@mail'
