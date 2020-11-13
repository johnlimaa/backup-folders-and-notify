
# Backup e notifica��o

### Meu objetivo

Criar uma automatiza��o para realizar o backup de um diret�rio em rede.

### O problema 

Um diret�rio em rede era usado para transfer�ncia de arquivos entre colaboradores, por�m era necess�rio fazer o backup dos arquivos a cada semana e deixar apenas os arquivos criados no dia da limpeza.


### Minha solu��o

Um script que acessa este diret�rio, compara a data de cria��o das pastas e arquivos e realiza o backup armazenando em outro local. Os arquivos que est�o com a data de cria��o anterior ao dia de execu��o da tarefa s�o removidos ap�s o backup. 

Esta tarefa gera um arquivo de log e notifica o executor sobre a conclus�o via e-mail.

Para utilizar de forma autom�tica, utilizei o Agendador de Tarefas do Windows.

1. Inicie uma sess�o do Powershell

`C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`

2. Importe o script como Argumento

`-ExecutionPolicy ByPass . \\[PATH]\Backup-FoldersAndFilesNotCreatedToday.ps1; Backup-FoldersAndFilesNotCreatedToday -OriginFolder '\\[ORIGIN]\' -DestinationFolder '\\[DESTINATION]\' -EmailSubject ['Backup Script'] -SendTo ['mail@mail']`

3. Agende ou execute a tarefa

> **Observa��o**
> Os scripts contidos nesta pasta devem ser armazenados juntos.

