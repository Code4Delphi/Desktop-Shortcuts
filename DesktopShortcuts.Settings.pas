unit DesktopShortcuts.Settings;

interface

uses
  System.Classes,
  System.IniFiles,
  System.IOUtils,
  System.SysUtils,
  Winapi.Windows,
  Vcl.Menus;

const
  CDesktopShortcutCount = 3;

type
  TDesktopShortcutItem = record
    DesktopName: string;
    Shortcut: TShortCut;
  end;

  TDesktopShortcutItems = array[0..2] of TDesktopShortcutItem;

  TDesktopShortcutSettings = class
  private const
    CFileName = 'DesktopShortcuts.ini';
    CSection = 'Shortcuts';
  public
    class procedure Defaults(out AItems: TDesktopShortcutItems); static;
    class function FileName: string; static;
    class procedure Load(out AItems: TDesktopShortcutItems); static;
    class procedure Save(const AItems: TDesktopShortcutItems); static;
  end;

implementation

class procedure TDesktopShortcutSettings.Defaults(out AItems: TDesktopShortcutItems);
begin
  AItems[0].DesktopName := 'Default Layout';
  AItems[0].Shortcut := Vcl.Menus.ShortCut(VK_F10, [ssCtrl, ssShift, ssAlt]);
  AItems[1].DesktopName := 'SHORTS';
  AItems[1].Shortcut := Vcl.Menus.ShortCut(VK_F11, [ssCtrl, ssShift, ssAlt]);
  AItems[2].DesktopName := 'Code only Layout';
  AItems[2].Shortcut := Vcl.Menus.ShortCut(VK_F12, [ssCtrl, ssShift, ssAlt]);
end;

class function TDesktopShortcutSettings.FileName: string;
begin
  var LBaseFolder := GetEnvironmentVariable('APPDATA');
  if LBaseFolder.IsEmpty then
    LBaseFolder := TPath.GetHomePath;

  Result := TPath.Combine(TPath.Combine(LBaseFolder, 'Code4D\DesktopShortcuts'), CFileName);
end;

class procedure TDesktopShortcutSettings.Load(out AItems: TDesktopShortcutItems);
begin
  TDesktopShortcutSettings.Defaults(AItems);

  if not FileExists(TDesktopShortcutSettings.FileName) then
    Exit;

  var LIniFile := TIniFile.Create(TDesktopShortcutSettings.FileName);
  try
    for var i := 0 to Pred(CDesktopShortcutCount) do
    begin
      var LKeySuffix := (i + 1).ToString;
      AItems[i].DesktopName := LIniFile.ReadString(CSection, 'Desktop' + LKeySuffix,
        AItems[i].DesktopName);
      AItems[i].Shortcut := TShortCut(LIniFile.ReadInteger(CSection, 'Shortcut' + LKeySuffix,
        AItems[i].Shortcut));
    end;
  finally
    LIniFile.Free;
  end;
end;

class procedure TDesktopShortcutSettings.Save(const AItems: TDesktopShortcutItems);
begin
  ForceDirectories(ExtractFilePath(TDesktopShortcutSettings.FileName));

  var LIniFile := TIniFile.Create(TDesktopShortcutSettings.FileName);
  try
    for var i := 0 to Pred(CDesktopShortcutCount) do
    begin
      var LKeySuffix := (i + 1).ToString;
      LIniFile.WriteString(CSection, 'Desktop' + LKeySuffix, AItems[i].DesktopName);
      LIniFile.WriteInteger(CSection, 'Shortcut' + LKeySuffix, AItems[i].Shortcut);
    end;
    LIniFile.UpdateFile;
  finally
    LIniFile.Free;
  end;
end;

end.
