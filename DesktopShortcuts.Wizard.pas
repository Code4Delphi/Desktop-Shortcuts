unit DesktopShortcuts.Wizard;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.ActnList,
  Vcl.Menus,
  ToolsAPI,
  DesktopShortcuts.Form,
  DesktopShortcuts.Settings;

type
  TDesktopShortcutsWizard = class(TNotifierObject, IOTAWizard)
  private
    FConfigureMenuItem: TMenuItem;
    FDesktopActions: array of TAction;
    FItems: TDesktopShortcutItems;
    procedure ApplySettings;
    procedure ClearActions;
    procedure ConfigureMenuClick(ASender: TObject);
    procedure DesktopActionExecute(ASender: TObject);
    function FindDesktopItem(AParent: TMenuItem; const ADesktopName: string): TMenuItem;
    function FindMenuItemByName(AParent: TMenuItem; const AName: string): TMenuItem;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure GetDesktopNames(AItems: TStrings);
    procedure RegisterActions;
    procedure RegisterConfigureMenu;
    procedure SwitchDesktop(const ADesktopName: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
  end;

procedure Register;

implementation

constructor TDesktopShortcutsWizard.Create;
begin
  inherited Create;
  Self.RegisterActions;
  Self.RegisterConfigureMenu;
end;

destructor TDesktopShortcutsWizard.Destroy;
begin
  FConfigureMenuItem.Free;
  Self.ClearActions;
  inherited Destroy;
end;

procedure TDesktopShortcutsWizard.ApplySettings;
begin
  Self.RegisterActions;
end;

procedure TDesktopShortcutsWizard.ClearActions;
begin
  for var i := 0 to High(FDesktopActions) do
    FDesktopActions[i].Free;
  SetLength(FDesktopActions, 0);
end;

procedure TDesktopShortcutsWizard.ConfigureMenuClick(ASender: TObject);
begin
  var LDesktopNames := TStringList.Create;
  try
    Self.GetDesktopNames(LDesktopNames);
    if TDesktopShortcutsForm.Execute(LDesktopNames) then
      Self.ApplySettings;
  finally
    LDesktopNames.Free;
  end;
end;

procedure TDesktopShortcutsWizard.DesktopActionExecute(ASender: TObject);
begin
  if not (ASender is TAction) then
    Exit;

  var LIndex := TAction(ASender).Tag;
  if (LIndex < 0) or (LIndex > High(FItems)) then
    Exit;

  Self.SwitchDesktop(FItems[LIndex].DesktopName);
end;

procedure TDesktopShortcutsWizard.Execute;
begin
  Self.ConfigureMenuClick(nil);
end;

function TDesktopShortcutsWizard.FindDesktopItem(AParent: TMenuItem;
  const ADesktopName: string): TMenuItem;
begin
  Result := nil;

  for var i := 0 to Pred(AParent.Count) do
  begin
    var LCaption := StringReplace(AParent.Items[i].Caption, '&', '', [rfReplaceAll]).Trim;
    if LCaption.ToUpper = ADesktopName.ToUpper then
      Exit(AParent.Items[i]);
  end;
end;

function TDesktopShortcutsWizard.FindMenuItemByName(AParent: TMenuItem;
  const AName: string): TMenuItem;
begin
  if AParent.Name = AName then
    Exit(AParent);

  for var i := 0 to Pred(AParent.Count) do
  begin
    Result := Self.FindMenuItemByName(AParent.Items[i], AName);
    if Assigned(Result) then
      Exit;
  end;

  Result := nil;
end;

function TDesktopShortcutsWizard.GetIDString: string;
begin
  Result := 'Code4D.DesktopShortcuts';
end;

function TDesktopShortcutsWizard.GetName: string;
begin
  Result := 'Desktop Shortcuts';
end;

function TDesktopShortcutsWizard.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TDesktopShortcutsWizard.GetDesktopNames(AItems: TStrings);
var
  LNTAServices: INTAServices;
begin
  AItems.Clear;

  if not Supports(BorlandIDEServices, INTAServices, LNTAServices) then
    raise Exception.Create('Nao foi possivel acessar os servicos de menu do RAD Studio.');

  var LDesktopMenu := Self.FindMenuItemByName(LNTAServices.MainMenu.Items, 'ViewDesktopsMenu');
  if not Assigned(LDesktopMenu) then
    raise Exception.Create('O menu View > Desktops nao foi localizado.');

  LDesktopMenu.Click;
  for var i := 0 to Pred(LDesktopMenu.Count) do
  begin
    var LMenuItem := LDesktopMenu.Items[i];
    if LMenuItem.Name = 'SaveDesktop1' then
      Break;

    var LCaption := StringReplace(LMenuItem.Caption, '&', '', [rfReplaceAll]).Trim;
    if not LCaption.IsEmpty and (LCaption <> '-') and (LCaption.ToUpper <> '<NONE>') and
      (AItems.IndexOf(LCaption) < 0) then
      AItems.Add(LCaption);
  end;
end;

procedure TDesktopShortcutsWizard.RegisterActions;
var
  LNTAServices: INTAServices;
begin
  if not Supports(BorlandIDEServices, INTAServices, LNTAServices) then
    raise Exception.Create('Nao foi possivel acessar os servicos de menu do RAD Studio.');

  Self.ClearActions;

  var LDesktopNames := TStringList.Create;
  try
    Self.GetDesktopNames(LDesktopNames);
    TDesktopShortcutSettings.Load(FItems);
    TDesktopShortcutSettings.Synchronize(LDesktopNames, FItems);
    SetLength(FDesktopActions, Length(FItems));

    for var i := 0 to High(FItems) do
    begin
      FDesktopActions[i] := TAction.Create(nil);
      FDesktopActions[i].Name := 'DesktopShortcutsAction' + Succ(i).ToString;
      FDesktopActions[i].Caption := 'Desktop: ' + FItems[i].DesktopName;
      FDesktopActions[i].Category := 'Desktop Shortcuts';
      FDesktopActions[i].Hint := 'Ativar o Desktop ' + FItems[i].DesktopName;
      FDesktopActions[i].ShortCut := FItems[i].Shortcut;
      FDesktopActions[i].Tag := i;
      FDesktopActions[i].OnExecute := Self.DesktopActionExecute;
      FDesktopActions[i].ActionList := LNTAServices.ActionList;
    end;
  finally
    LDesktopNames.Free;
  end;
end;

procedure TDesktopShortcutsWizard.RegisterConfigureMenu;
var
  LNTAServices: INTAServices;
begin
  if not Supports(BorlandIDEServices, INTAServices, LNTAServices) then
    raise Exception.Create('Nao foi possivel acessar os servicos de menu do RAD Studio.');

  var LHelpMenu := Self.FindMenuItemByName(LNTAServices.MainMenu.Items, 'HelpMenu');
  if not Assigned(LHelpMenu) then
    raise Exception.Create('O menu Help nao foi localizado.');

  FConfigureMenuItem := TMenuItem.Create(LNTAServices.MainMenu);
  FConfigureMenuItem.Name := 'DesktopShortcutsConfigureMenuItem';
  FConfigureMenuItem.Caption := '&Desktop Shortcuts...';
  FConfigureMenuItem.Hint := 'Configurar atalhos dos Desktops';
  FConfigureMenuItem.OnClick := Self.ConfigureMenuClick;
  LHelpMenu.Add(FConfigureMenuItem);
end;

procedure TDesktopShortcutsWizard.SwitchDesktop(const ADesktopName: string);
var
  LNTAServices: INTAServices;
begin
  if not Supports(BorlandIDEServices, INTAServices, LNTAServices) then
    raise Exception.Create('Nao foi possivel acessar os servicos de menu do RAD Studio.');

  var LDesktopMenu := Self.FindMenuItemByName(LNTAServices.MainMenu.Items, 'ViewDesktopsMenu');
  if not Assigned(LDesktopMenu) then
    raise Exception.Create('O menu View > Desktops nao foi localizado.');

  LDesktopMenu.Click;

  var LDesktopItem := Self.FindDesktopItem(LDesktopMenu, ADesktopName);
  if not Assigned(LDesktopItem) and (ADesktopName.ToUpper = 'CODE ONLY') then
    LDesktopItem := Self.FindDesktopItem(LDesktopMenu, 'Code only Layout');

  if not Assigned(LDesktopItem) and (ADesktopName.ToUpper = 'CODE ONLY LAYOUT') then
    LDesktopItem := Self.FindDesktopItem(LDesktopMenu, 'Code Only');

  if not Assigned(LDesktopItem) then
    raise Exception.CreateFmt('O Desktop "%s" nao foi localizado.', [ADesktopName]);

  LDesktopItem.Click;
end;

procedure Register;
begin
  RegisterPackageWizard(TDesktopShortcutsWizard.Create);
end;

end.
