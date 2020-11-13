
# Backup e notificação

### Meu objetivo

Criar uma automatização para realizar o backup de um diretório em rede.

### O problema 

Um diretório em rede era usado para transferência de arquivos entre colaboradores, porém era necessário fazer o backup dos arquivos a cada semana e deixar apenas os arquivos criados no dia da limpeza.


### Minha solução

Um script que acessa este diretório, compara a data de criação das pastas e arquivos e realiza o backup armazenando em outro local. Os arquivos que estão com a data de criação anterior ao dia de execução da tarefa são removidos após o backup. 

Esta tarefa gera um arquivo de log e notifica o executor sobre a conclusão via e-mail.

![Exemplo do email](https://github.com/johnlimaa/powershell-utilities/blob/master/backup-and-notify/img/mail.png?raw=true)

Para utilizar de forma automática, utilizei o Agendador de Tarefas do Windows.

![Campos agendador de tarefas](https://github.com/johnlimaa/powershell-utilities/blob/master/backup-and-notify/img/windows-task.png?raw=true)

1. Inicie uma sessão do Powershell

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`

2. Importe o script como Argumento

`-ExecutionPolicy ByPass . \\[PATH]\Backup-FoldersAndFilesNotCreatedToday.ps1; Backup-FoldersAndFilesNotCreatedToday -OriginFolder '\\[ORIGIN]\' -DestinationFolder '\\[DESTINATION]\' -EmailSubject ['Backup Script'] -SendTo ['mail@mail']`

3. Agende ou execute a tarefa

> **Observação**
> Os scripts contidos nesta pasta devem ser armazenados juntos.

