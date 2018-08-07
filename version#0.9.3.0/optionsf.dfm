object options: Toptions
  Left = 464
  Top = 350
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'MCTerra options'
  ClientHeight = 232
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 32
    Top = 192
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 217
    Height = 169
    Caption = 'Save options'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 63
      Height = 13
      Caption = 'Save method'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 145
      Height = 17
      Caption = 'Enable option load/save'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object ComboBox1: TComboBox
      Left = 79
      Top = 36
      Width = 113
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'INI file'
      Items.Strings = (
        'INI file')
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 64
      Width = 89
      Height = 17
      Caption = 'Fast loading'
      TabOrder = 2
    end
    object Button3: TButton
      Left = 16
      Top = 104
      Width = 89
      Height = 25
      Caption = 'Save now'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 120
      Top = 104
      Width = 89
      Height = 25
      Caption = 'Reset settings'
      TabOrder = 4
      OnClick = Button4Click
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 80
      Width = 161
      Height = 17
      Caption = 'Don'#39't change saved options'
      TabOrder = 5
    end
    object Button5: TButton
      Left = 16
      Top = 136
      Width = 193
      Height = 25
      Caption = 'Erase all saved options'
      TabOrder = 6
      OnClick = Button5Click
    end
  end
end
