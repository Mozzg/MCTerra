object planet: Tplanet
  Left = 339
  Top = 216
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Planetoids settings'
  ClientHeight = 283
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 128
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 216
    Top = 8
    Width = 201
    Height = 228
    Caption = 'Planets settings'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 97
      Width = 136
      Height = 17
      Caption = 'Minimum planet radius:'
    end
    object Label4: TLabel
      Left = 8
      Top = 138
      Width = 140
      Height = 17
      Caption = 'Maximum planet radius:'
    end
    object Label2: TLabel
      Left = 8
      Top = 178
      Width = 184
      Height = 17
      Caption = 'Min. distance, between planets:'
    end
    object Label5: TLabel
      Left = 8
      Top = 58
      Width = 135
      Height = 17
      Caption = 'Planetoids density (%):'
    end
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 75
      Height = 17
      Caption = 'Planets type:'
    end
    object Edit2: TEdit
      Left = 8
      Top = 113
      Width = 185
      Height = 25
      TabOrder = 0
      Text = '5'
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 8
      Top = 154
      Width = 185
      Height = 25
      TabOrder = 1
      Text = '15'
      OnKeyPress = Edit3KeyPress
    end
    object Edit1: TEdit
      Left = 8
      Top = 194
      Width = 185
      Height = 25
      TabOrder = 2
      Text = '4'
      OnKeyPress = Edit1KeyPress
    end
    object Edit4: TEdit
      Left = 8
      Top = 73
      Width = 185
      Height = 25
      TabOrder = 3
      Text = '10'
      OnKeyPress = Edit4KeyPress
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 32
      Width = 185
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      ItemIndex = 0
      TabOrder = 4
      Text = 'Sphere'
      Items.Strings = (
        'Sphere'
        'Cube')
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 195
    Height = 113
    Caption = 'Map settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label6: TLabel
      Left = 8
      Top = 61
      Width = 77
      Height = 17
      Caption = 'Ground level:'
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 59
      Height = 17
      Caption = 'Map type:'
    end
    object Edit5: TEdit
      Left = 9
      Top = 77
      Width = 177
      Height = 25
      TabOrder = 0
      Text = '0'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 32
      Width = 178
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      ItemIndex = 0
      TabOrder = 1
      Text = 'Open sky'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Open sky'
        'Water below'
        'Lava below')
    end
  end
end
