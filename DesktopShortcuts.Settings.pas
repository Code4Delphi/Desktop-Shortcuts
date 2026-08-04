unit DesktopShortcuts.Settings;

interface

uses
  System.Classes,
  System.IniFiles,
  System.IOUtils,
  System.SysUtils,
  Vcl.Menus;

type
  TDesktopShortcutItem = record
    DesktopName: string;
    Shortcut: TShortCut;
  end;

  TDesktopShortcutItems = array of TDesktopShortcutItem;

  TDesktopShortcutSettings = class
  private const
    CFileName = 'DesktopShortcuts.ini';
    CSection = 'Shortcuts';
  private
    class function SameDesktopName(const AFirstName: string;
      const ASecondName: string): Boolean; static;
  public
    class function FileName: string; static;
    class procedure Load(out AItems: TDesktopShortcutItems); static;
    class procedure Save(const AItems: TDesktopShortcutItems); static;
    class procedure Synchronize(ADesktopNames: TStrings;
      var AItems: TDesktopShortcutItems); static;
  end;

implementation

class function TDesktopShortcutSettings.FileName: string;
begin
  var LBaseFolder := GetEnvironmentVariable('APPDATA');
  if LBaseFolder.IsEmpty then
    LBaseFolder := TPath.GetHomePath;

  Result := TPath.Combine(TPath.Combine(LBaseFolder, 'Code4D\DesktopShortcuts'), CFileName);
end;

class procedure TDesktopShortcutSettings.Load(out AItems: TDesktopShortcutItems);
begin
  SetLength(AItems, 0);

  if not FileExists(TDesktopShortcutSettings.FileName) then
    Exit;

  var LIniFile := TIniFile.Create(TDesktopShortcutSettings.FileName);
  try
    var LCount := LIniFile.ReadInteger(CSection, 'Count', 0);
    if LCount < 0 then
      LCount := 0;
    SetLength(AItems, LCount);

    for var i := 0 to Pred(LCount) do
    begin
      var LKeySuffix := Succ(i).ToString;
      AItems[i].DesktopName := LIniFile.ReadString(CSection, 'Desktop' + LKeySuffix,
        AItems[i].DesktopName);
      AItems[i].Shortcut := TShortCut(LIniFile.ReadInteger(CSection, 'Shortcut' + LKeySuffix,
        AItems[i].Shortcut));
    end;
  finally
    LIniFile.Free;
  end;
end;

class function TDesktopShortcutSettings.SameDesktopName(const AFirstName: string;
  const ASecondName: string): Boolean;
begin
  Result := AFirstName.ToUpper = ASecondName.ToUpper;
end;

class procedure TDesktopShortcutSettings.Save(const AItems: TDesktopShortcutItems);
begin
  ForceDirectories(ExtractFilePath(TDesktopShortcutSettings.FileName));

  var LIniFile := TIniFile.Create(TDesktopShortcutSettings.FileName);
  try
    LIniFile.EraseSection(CSection);
    LIniFile.WriteInteger(CSection, 'Count', Length(AItems));
    for var i := 0 to High(AItems) do
    begin
      var LKeySuffix := Succ(i).ToString;
      LIniFile.WriteString(CSection, 'Desktop' + LKeySuffix, AItems[i].DesktopName);
      LIniFile.WriteInteger(CSection, 'Shortcut' + LKeySuffix, AItems[i].Shortcut);
    end;
    LIniFile.UpdateFile;
  finally
    LIniFile.Free;
  end;
end;

class procedure TDesktopShortcutSettings.Synchronize(ADesktopNames: TStrings;
  var AItems: TDesktopShortcutItems);
begin
  if not Assigned(ADesktopNames) or (ADesktopNames.Count = 0) then
    Exit;

  var LSavedItems: TDesktopShortcutItems;
  SetLength(LSavedItems, Length(AItems));
  for var i := 0 to High(AItems) do
    LSavedItems[i] := AItems[i];

  SetLength(AItems, ADesktopNames.Count);

  for var i := 0 to Pred(ADesktopNames.Count) do
  begin
    AItems[i].DesktopName := ADesktopNames[i];
    AItems[i].Shortcut := 0;

    for var j := 0 to High(LSavedItems) do
      if TDesktopShortcutSettings.SameDesktopName(ADesktopNames[i],
        LSavedItems[j].DesktopName) then
      begin
        AItems[i].Shortcut := LSavedItems[j].Shortcut;
        Break;
      end;
  end;
end;

end.
