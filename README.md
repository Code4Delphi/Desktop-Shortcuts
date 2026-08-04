# Desktop Shortcuts

Plugin para alternar entre os Desktops da IDE do Delphi por meio de atalhos globais.

O package de design-time para o Delphi 12 identifica automaticamente todos os Desktops exibidos em **View > Desktops** e cria uma acao de atalho para cada um deles.

Estas sao as configuracoes iniciais, quando os respectivos Desktops existem:

- `Ctrl+Shift+Alt+F10`: ativa `Default Layout`.
- `Ctrl+Shift+Alt+F11`: ativa `SHORTS`.
- `Ctrl+Shift+Alt+F12`: ativa `Code only Layout` ou `Code Only`.

Os demais Desktops aparecem inicialmente sem atalho.

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
