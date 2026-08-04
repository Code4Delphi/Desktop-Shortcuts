# Desktop Shortcuts
Plugin para atalhos para alternar entre Desktops da IDE do Delphi

Package de design-time para o Delphi 12 que ativa dois Desktops salvos por meio de atalhos globais:

- `Ctrl+Shift+Alt+F11`: ativa `SHORTS`.
- `Ctrl+Shift+Alt+F12`: ativa `Code only Layout` ou `Code Only`.

## Compilacao e instalacao

1. Abra `DesktopShortcuts.dproj` no Delphi 12.
2. Selecione `Release | Win32` e compile o projeto.
3. Acesse **Component > Install Packages**.
4. Adicione `Win32\Release\DesktopShortcuts.bpl`.

O package localiza os Desktops pelo texto exibido em **View > Desktops**. Portanto, o Desktop precisa estar salvo com um dos nomes indicados acima.
