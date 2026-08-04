unit DesktopShortcuts.Wizard;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  Vcl.ActnList,
  Vcl.Menus,
  ToolsAPI;

type
  TDesktopShortcutsWizard = class(TNotifierObject, IOTAWizard)
  private const
    CCodeOnlyDesktop = 'Code only Layout';
    CCodeOnlyDesktopAlias = 'Code Only';
    CShortsDesktop = 'SHORTS';
  private
    FCodeOnlyAction: TAction;
    FShortsAction: TAction;
    procedure CodeOnlyActionExecute(ASender: TObject);
    function FindDesktopItem(AParent: TMenuItem; const ADesktopName: string): TMenuItem;
    function FindMenuItemByName(AParent: TMenuItem; const AName: string): TMenuItem;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure RegisterActions;
    procedure ShortsActionExecute(ASender: TObject);
    procedure SwitchDesktop(const ADesktopName: string; const ADesktopAlias: string = '');
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
end;

destructor TDesktopShortcutsWizard.Destroy;
begin
  FCodeOnlyAction.Free;
  FShortsAction.Free;
  inherited Destroy;
end;

procedure TDesktopShortcutsWizard.CodeOnlyActionExecute(ASender: TObject);
begin
  Self.SwitchDesktop(CCodeOnlyDesktop, CCodeOnlyDesktopAlias);
end;

procedure TDesktopShortcutsWizard.Execute;
begin
  Self.SwitchDesktop(CShortsDesktop);
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

procedure TDesktopShortcutsWizard.RegisterActions;
var
  LNTAServices: INTAServices;
begin
  if not Supports(BorlandIDEServices, INTAServices, LNTAServices) then
    raise Exception.Create('Nao foi possivel acessar os servicos de menu do RAD Studio.');

  FShortsAction := TAction.Create(nil);
  FShortsAction.Name := 'DesktopShortcutsShortsAction';
  FShortsAction.Caption := 'Desktop: SHORTS';
  FShortsAction.Category := 'Desktop Shortcuts';
  FShortsAction.Hint := 'Ativar o Desktop SHORTS';
  FShortsAction.ShortCut := Vcl.Menus.ShortCut(VK_F11, [ssCtrl, ssShift, ssAlt]);
  FShortsAction.OnExecute := Self.ShortsActionExecute;
  FShortsAction.ActionList := LNTAServices.ActionList;

  FCodeOnlyAction := TAction.Create(nil);
  FCodeOnlyAction.Name := 'DesktopShortcutsCodeOnlyAction';
  FCodeOnlyAction.Caption := 'Desktop: Code Only';
  FCodeOnlyAction.Category := 'Desktop Shortcuts';
  FCodeOnlyAction.Hint := 'Ativar o Desktop Code Only';
  FCodeOnlyAction.ShortCut := Vcl.Menus.ShortCut(VK_F12, [ssCtrl, ssShift, ssAlt]);
  FCodeOnlyAction.OnExecute := Self.CodeOnlyActionExecute;
  FCodeOnlyAction.ActionList := LNTAServices.ActionList;
end;

procedure TDesktopShortcutsWizard.ShortsActionExecute(ASender: TObject);
begin
  Self.SwitchDesktop(CShortsDesktop);
end;

procedure TDesktopShortcutsWizard.SwitchDesktop(const ADesktopName: string;
  const ADesktopAlias: string);
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
  if not Assigned(LDesktopItem) and not ADesktopAlias.IsEmpty then
    LDesktopItem := Self.FindDesktopItem(LDesktopMenu, ADesktopAlias);

  if not Assigned(LDesktopItem) then
    raise Exception.CreateFmt('O Desktop "%s" nao foi localizado.', [ADesktopName]);

  LDesktopItem.Click;
end;

procedure Register;
begin
  RegisterPackageWizard(TDesktopShortcutsWizard.Create);
end;

end.
