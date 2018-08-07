object biomes: Tbiomes
  Left = 360
  Top = 300
  Width = 462
  Height = 309
  Caption = 'Seperate biomes settings'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 136
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 161
    Height = 49
    Caption = 'Biome type'
    TabOrder = 2
    object ComboBox1: TComboBox
      Left = 8
      Top = 20
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Desert'
      Items.Strings = (
        'Desert'
        'Forest'
        'Plains'
        'Taiga'
        'Tundra'
        'Swamp'
        'Mushroom'
        'Nether'
        'Sky')
    end
  end
  object GroupBox2: TGroupBox
    Left = 184
    Top = 16
    Width = 253
    Height = 193
    Caption = 'Desert biome settings'
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 144
      Width = 97
      Height = 13
      Caption = 'Flaterned koefficent:'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 105
      Height = 17
      Caption = 'Generate cactus'
      TabOrder = 0
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 35
      Width = 236
      Height = 102
      Caption = 'Oazis settings'
      TabOrder = 1
      object Label1: TLabel
        Left = 128
        Top = 16
        Width = 82
        Height = 13
        Caption = 'Oazis density (%):'
      end
      object Label2: TLabel
        Left = 128
        Top = 56
        Width = 59
        Height = 13
        Caption = 'Oazis count:'
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Generate oazis'
        TabOrder = 0
      end
      object RadioGroup1: TRadioGroup
        Left = 8
        Top = 36
        Width = 105
        Height = 57
        Caption = 'Oasiz density type'
        ItemIndex = 0
        Items.Strings = (
          'Percentage'
          'Count')
        TabOrder = 1
        OnClick = RadioGroup1Click
      end
      object Edit1: TEdit
        Left = 128
        Top = 32
        Width = 97
        Height = 21
        TabOrder = 2
        Text = '10'
      end
      object Edit2: TEdit
        Left = 128
        Top = 72
        Width = 97
        Height = 21
        TabOrder = 3
        Text = '5'
      end
    end
    object Edit3: TEdit
      Left = 8
      Top = 160
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0.5'
    end
  end
end
