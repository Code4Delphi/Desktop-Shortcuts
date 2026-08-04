unit DesktopShortcuts.Form;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Messages,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Grids,
  Vcl.Menus,
  Vcl.StdCtrls,
  DesktopShortcuts.Settings;

type
  TDesktopShortcutsForm = class(TForm)
    btnCancelar: TButton;
    btnGravar: TButton;
    lbInstrucao: TLabel;
    pnBotoes: TPanel;
    strGridAtalhos: TStringGrid;
    procedure btnGravarClick(ASender: TObject);
    procedure FormShortCut(var AMessage: TWMKey; var AHandled: Boolean);
    procedure strGridAtalhosKeyDown(ASender: TObject; var AKey: Word;
      AShift: TShiftState);
  private
    FItems: TDesktopShortcutItems;
    function ApplyShortcut(AKey: Word; AShift: TShiftState): Boolean;
    procedure LoadConfiguration(ADesktopNames: TStrings);
    function ValidateConfiguration: Boolean;
  public
    class function Execute(ADesktopNames: TStrings): Boolean; static;
  end;

implementation

{$R *.dfm}

function TDesktopShortcutsForm.ApplyShortcut(AKey: Word;
  AShift: TShiftState): Boolean;
begin
  Result := False;

  if not strGridAtalhos.Focused or (strGridAtalhos.Row <= 0) or
    (strGridAtalhos.Row > Length(FItems)) then
    Exit;

  if AKey in [VK_SHIFT, VK_CONTROL, VK_MENU, VK_TAB, VK_RETURN, VK_ESCAPE] then
    Exit;

  var LIndex := Pred(strGridAtalhos.Row);
  if AKey in [VK_DELETE, VK_BACK] then
    FItems[LIndex].Shortcut := 0
  else
  begin
    var LModifiers := AShift * [ssShift, ssCtrl, ssAlt];
    if (LModifiers = []) and ((AKey < VK_F1) or (AKey > VK_F24)) then
      Exit;
    FItems[LIndex].Shortcut := Vcl.Menus.ShortCut(AKey, LModifiers);
  end;

  strGridAtalhos.Cells[1, strGridAtalhos.Row] := ShortCutToText(FItems[LIndex].Shortcut);
  Result := True;
end;

procedure TDesktopShortcutsForm.btnGravarClick(ASender: TObject);
begin
  if not Self.ValidateConfiguration then
    Exit;

  TDesktopShortcutSettings.Save(FItems);
  ModalResult := mrOk;
end;

procedure TDesktopShortcutsForm.FormShortCut(var AMessage: TWMKey;
  var AHandled: Boolean);
begin
  AHandled := Self.ApplyShortcut(AMessage.CharCode, KeyboardStateToShiftState);
end;

class function TDesktopShortcutsForm.Execute(ADesktopNames: TStrings): Boolean;
begin
  var LForm := TDesktopShortcutsForm.Create(nil);
  try
    LForm.LoadConfiguration(ADesktopNames);
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

procedure TDesktopShortcutsForm.LoadConfiguration(ADesktopNames: TStrings);
begin
  TDesktopShortcutSettings.Load(FItems);
  TDesktopShortcutSettings.Synchronize(ADesktopNames, FItems);

  strGridAtalhos.Cells[0, 0] := 'Desktop';
  strGridAtalhos.Cells[1, 0] := 'Atalho';
  strGridAtalhos.ColWidths[0] := 370;
  strGridAtalhos.ColWidths[1] := 180;

  if Length(FItems) > 0 then
    strGridAtalhos.RowCount := Succ(Length(FItems))
  else
    strGridAtalhos.RowCount := 2;

  for var i := 0 to High(FItems) do
  begin
    var LRow := Succ(i);
    strGridAtalhos.Cells[0, LRow] := FItems[i].DesktopName;
    strGridAtalhos.Cells[1, LRow] := ShortCutToText(FItems[i].Shortcut);
  end;
end;

procedure TDesktopShortcutsForm.strGridAtalhosKeyDown(ASender: TObject;
  var AKey: Word; AShift: TShiftState);
begin
  if Self.ApplyShortcut(AKey, AShift) then
    AKey := 0;
end;

function TDesktopShortcutsForm.ValidateConfiguration: Boolean;
begin
  Result := False;

  for var i := 0 to High(FItems) do
  begin
    if FItems[i].Shortcut = 0 then
      Continue;

    for var j := Succ(i) to High(FItems) do
      if FItems[i].Shortcut = FItems[j].Shortcut then
      begin
        MessageDlg(Format('O atalho %s esta associado aos Desktops "%s" e "%s".',
          [ShortCutToText(FItems[i].Shortcut), FItems[i].DesktopName,
          FItems[j].DesktopName]), mtWarning, [mbOK], 0);
        strGridAtalhos.Row := Succ(j);
        strGridAtalhos.SetFocus;
        Exit;
      end;
  end;

  Result := True;
end;

end.
