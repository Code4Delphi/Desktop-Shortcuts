object DesktopShortcutsForm: TDesktopShortcutsForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeable
  Caption = 'Desktop Shortcuts'
  ClientHeight = 420
  ClientWidth = 620
  Color = clBtnFace
  Constraints.MinHeight = 340
  Constraints.MinWidth = 520
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OnShortCut = FormShortCut
  Position = poScreenCenter
  TextHeight = 15
  object lbInstrucao: TLabel
    Left = 16
    Top = 16
    Width = 484
    Height = 15
    Caption = 'Selecione uma linha e pressione o atalho desejado. Use Delete para limpar.'
  end
  object strGridAtalhos: TStringGrid
    Left = 16
    Top = 48
    Width = 588
    Height = 306
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 2
    DefaultRowHeight = 24
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 0
    OnKeyDown = strGridAtalhosKeyDown
  end
  object pnBotoes: TPanel
    Left = 0
    Top = 370
    Width = 620
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnGravar: TButton
      Left = 428
      Top = 10
      Width = 84
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Gravar'
      Default = True
      TabOrder = 0
      OnClick = btnGravarClick
    end
    object btnCancelar: TButton
      Left = 520
      Top = 10
      Width = 84
      Height = 28
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
