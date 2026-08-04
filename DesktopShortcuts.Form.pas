unit DesktopShortcuts.Form;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  DesktopShortcuts.Settings;

type
  TDesktopShortcutsForm = class(TForm)
    btnCancelar: TButton;
    btnGravar: TButton;
    cBoxDesktop1: TComboBox;
    cBoxDesktop2: TComboBox;
    cBoxDesktop3: TComboBox;
    edtAtalho1: THotKey;
    edtAtalho2: THotKey;
    edtAtalho3: THotKey;
    lbAtalho: TLabel;
    lbDesktop: TLabel;
    lbInstrucao: TLabel;
    pnBotoes: TPanel;
    procedure btnGravarClick(ASender: TObject);
  private
    procedure ConfigureCombo(AComboBox: TComboBox; const ADesktopName: string);
    procedure LoadConfiguration;
    procedure LoadDesktops(ADesktopNames: TStrings);
    function ValidateConfiguration: Boolean;
  public
    class function Execute(ADesktopNames: TStrings): Boolean; static;
  end;

implementation

{$R *.dfm}

procedure TDesktopShortcutsForm.btnGravarClick(ASender: TObject);
begin
  if not Self.ValidateConfiguration then
    Exit;

  var LItems: TDesktopShortcutItems;
  LItems[0].DesktopName := cBoxDesktop1.Text;
  LItems[0].Shortcut := edtAtalho1.HotKey;
  LItems[1].DesktopName := cBoxDesktop2.Text;
  LItems[1].Shortcut := edtAtalho2.HotKey;
  LItems[2].DesktopName := cBoxDesktop3.Text;
  LItems[2].Shortcut := edtAtalho3.HotKey;
  TDesktopShortcutSettings.Save(LItems);
  ModalResult := mrOk;
end;

procedure TDesktopShortcutsForm.ConfigureCombo(AComboBox: TComboBox;
  const ADesktopName: string);
begin
  if AComboBox.Items.IndexOf(ADesktopName) < 0 then
    AComboBox.Items.Add(ADesktopName);

  AComboBox.ItemIndex := AComboBox.Items.IndexOf(ADesktopName);
end;

class function TDesktopShortcutsForm.Execute(ADesktopNames: TStrings): Boolean;
begin
  var LForm := TDesktopShortcutsForm.Create(nil);
  try
    LForm.LoadDesktops(ADesktopNames);
    LForm.LoadConfiguration;
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

procedure TDesktopShortcutsForm.LoadConfiguration;
begin
  var LItems: TDesktopShortcutItems;
  TDesktopShortcutSettings.Load(LItems);
  Self.ConfigureCombo(cBoxDesktop1, LItems[0].DesktopName);
  Self.ConfigureCombo(cBoxDesktop2, LItems[1].DesktopName);
  Self.ConfigureCombo(cBoxDesktop3, LItems[2].DesktopName);
  edtAtalho1.HotKey := LItems[0].Shortcut;
  edtAtalho2.HotKey := LItems[1].Shortcut;
  edtAtalho3.HotKey := LItems[2].Shortcut;
end;

procedure TDesktopShortcutsForm.LoadDesktops(ADesktopNames: TStrings);
begin
  cBoxDesktop1.Items.Assign(ADesktopNames);
  cBoxDesktop2.Items.Assign(ADesktopNames);
  cBoxDesktop3.Items.Assign(ADesktopNames);
end;

function TDesktopShortcutsForm.ValidateConfiguration: Boolean;
begin
  Result := False;

  if cBoxDesktop1.ItemIndex < 0 then
  begin
    MessageDlg('Selecione o primeiro Desktop.', mtWarning, [mbOK], 0);
    cBoxDesktop1.SetFocus;
    Exit;
  end;

  if cBoxDesktop2.ItemIndex < 0 then
  begin
    MessageDlg('Selecione o segundo Desktop.', mtWarning, [mbOK], 0);
    cBoxDesktop2.SetFocus;
    Exit;
  end;

  if cBoxDesktop3.ItemIndex < 0 then
  begin
    MessageDlg('Selecione o terceiro Desktop.', mtWarning, [mbOK], 0);
    cBoxDesktop3.SetFocus;
    Exit;
  end;

  if edtAtalho1.HotKey = 0 then
  begin
    MessageDlg('Informe o primeiro atalho.', mtWarning, [mbOK], 0);
    edtAtalho1.SetFocus;
    Exit;
  end;

  if edtAtalho2.HotKey = 0 then
  begin
    MessageDlg('Informe o segundo atalho.', mtWarning, [mbOK], 0);
    edtAtalho2.SetFocus;
    Exit;
  end;

  if edtAtalho3.HotKey = 0 then
  begin
    MessageDlg('Informe o terceiro atalho.', mtWarning, [mbOK], 0);
    edtAtalho3.SetFocus;
    Exit;
  end;

  if (edtAtalho1.HotKey = edtAtalho2.HotKey) or
    (edtAtalho1.HotKey = edtAtalho3.HotKey) or
    (edtAtalho2.HotKey = edtAtalho3.HotKey) then
  begin
    MessageDlg('Os atalhos devem ser diferentes.', mtWarning, [mbOK], 0);
    Exit;
  end;

  Result := True;
end;

end.
