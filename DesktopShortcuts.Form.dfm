object DesktopShortcutsForm: TDesktopShortcutsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Desktop Shortcuts'
  ClientHeight = 264
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  TextHeight = 15
  object lbInstrucao: TLabel
    Left = 16
    Top = 16
    Width = 489
    Height = 15
    Caption = 'Selecione o Desktop e pressione a combina'#231#227'o desejada no campo Atalho.'
  end
  object lbDesktop: TLabel
    Left = 16
    Top = 48
    Width = 44
    Height = 15
    Caption = 'Desktop'
  end
  object lbAtalho: TLabel
    Left = 360
    Top = 48
    Width = 36
    Height = 15
    Caption = 'Atalho'
  end
  object cBoxDesktop1: TComboBox
    Left = 16
    Top = 68
    Width = 328
    Height = 23
    Style = csDropDownList
    TabOrder = 0
  end
  object edtAtalho1: THotKey
    Left = 360
    Top = 68
    Width = 184
    Height = 23
    HotKey = 0
    Modifiers = []
    TabOrder = 1
  end
  object cBoxDesktop2: TComboBox
    Left = 16
    Top = 108
    Width = 328
    Height = 23
    Style = csDropDownList
    TabOrder = 2
  end
  object edtAtalho2: THotKey
    Left = 360
    Top = 108
    Width = 184
    Height = 23
    HotKey = 0
    Modifiers = []
    TabOrder = 3
  end
  object cBoxDesktop3: TComboBox
    Left = 16
    Top = 148
    Width = 328
    Height = 23
    Style = csDropDownList
    TabOrder = 4
  end
  object edtAtalho3: THotKey
    Left = 360
    Top = 148
    Width = 184
    Height = 23
    HotKey = 0
    Modifiers = []
    TabOrder = 5
  end
  object pnBotoes: TPanel
    Left = 0
    Top = 214
    Width = 560
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object btnGravar: TButton
      Left = 368
      Top = 10
      Width = 84
      Height = 28
      Caption = 'Gravar'
      Default = True
      TabOrder = 0
      OnClick = btnGravarClick
    end
    object btnCancelar: TButton
      Left = 460
      Top = 10
      Width = 84
      Height = 28
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
