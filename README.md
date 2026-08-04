# Desktop Shortcuts - Plugin Delphi

Plugin para alternar entre os Desktops da IDE do Delphi por meio de atalhos globais.

O package de design-time para o Delphi 12 identifica automaticamente todos os Desktops exibidos em **View > Desktops** e cria uma acao de atalho para cada um deles.

Todos os Desktops aparecem inicialmente sem atalho. As configuracoes sao definidas pelo usuario.

## Compilacao e instalacao

1. Abra `DesktopShortcuts.dproj` no Delphi 12.
2. Selecione `Release | Win32` e compile o projeto.
3. Acesse **Component > Install Packages**.
4. Adicione `Win32\Release\DesktopShortcuts.bpl`.

## Configuracao

Acesse **Help > Desktop Shortcuts...**. A grade apresenta uma linha para cada Desktop existente em **View > Desktops**.

Selecione uma linha e pressione a combinacao que deseja usar. Pressione **Delete** ou **Backspace** para remover o atalho da linha. O botao **Gravar** salva e aplica as alteracoes imediatamente; **Cancelar** fecha a tela sem alterar a configuracao.

As preferencias ficam armazenadas em:

`%APPDATA%\Code4D\DesktopShortcuts\DesktopShortcuts.ini`
