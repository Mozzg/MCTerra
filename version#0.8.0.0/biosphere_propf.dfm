object biosf: Tbiosf
  Left = 357
  Top = 196
  BorderStyle = bsSingle
  Caption = 'Biospheres settings'
  ClientHeight = 357
  ClientWidth = 453
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
    Left = 136
    Top = 320
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 120
    Width = 185
    Height = 185
    Caption = 'Bridge settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 93
      Height = 17
      Caption = 'Bridge material:'
    end
    object Label2: TLabel
      Left = 8
      Top = 88
      Width = 115
      Height = 17
      Caption = 'Bridge rail material:'
    end
    object Label5: TLabel
      Left = 8
      Top = 136
      Width = 78
      Height = 17
      Caption = 'Bridge width:'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 56
      Width = 169
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      TabOrder = 0
      Items.Strings = (
        'Stone'
        'Dirt'
        'Grass'
        'Cobblestone'
        'Wooden Plank'
        'Bedrock'
        'Sand'
        'Gravel'
        'Wood'
        'Leaves'
        'Sponge'
        'Glass'
        'Sandstone'
        'Double Slabs'
        'Brick Block'
        'TNT'
        'Moss Stone'
        'Obsidian'
        'Snow Block'
        'Ice'
        'Fence'
        'Pumpkin'
        'Netherrack'
        'Soul Sand'
        'Glowstone Block'
        'Jack-O-Lantern'
        'Stone Bricks'
        'Melon'
        'Mycelium'
        'Nether Brick'
        'Nether Brick Fence')
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 104
      Width = 169
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      TabOrder = 1
      Items.Strings = (
        'Stone'
        'Grass'
        'Dirt'
        'Cobblestone'
        'Wooden Plank'
        'Sapling'
        'Bedrock'
        'Sand'
        'Gravel'
        'Wood'
        'Leaves'
        'Sponge'
        'Glass'
        'Sandstone'
        'Cobweb'
        'Dandelion'
        'Rose'
        'Brown Mushroom'
        'Red Mushroom'
        'Double Slabs'
        'Slabs'
        'Brick Block'
        'TNT'
        'Moss Stone'
        'Obsidian'
        'Ice'
        'Snow Block'
        'Sugar Cane'
        'Fence'
        'Pumpkin'
        'Netherrack'
        'Soul Sand'
        'Glowstone Block'
        'Jack-O-Lantern'
        'Iron Bars'
        'Glass Pane'
        'Melon'
        'Vines'
        'Mycelium'
        'Nether Brick'
        'Nether Brick Fence')
    end
    object Edit1: TEdit
      Left = 8
      Top = 152
      Width = 169
      Height = 25
      TabOrder = 2
      Text = '3'
      OnKeyPress = Edit1KeyPress
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 20
      Width = 121
      Height = 17
      Caption = 'Generate bridges'
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 105
    Caption = 'Map settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 129
      Height = 17
      Caption = 'Original generator'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 40
      Width = 121
      Height = 17
      Caption = 'Underwater map'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 80
      Width = 137
      Height = 17
      Caption = 'Generate land noise'
      TabOrder = 2
    end
    object CheckBox14: TCheckBox
      Left = 8
      Top = 56
      Width = 137
      Height = 17
      Caption = 'Generate skyholes'
      TabOrder = 3
    end
  end
  object GroupBox3: TGroupBox
    Left = 200
    Top = 8
    Width = 241
    Height = 297
    Caption = 'Spheres settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 162
      Height = 17
      Caption = 'Sphere outer layer material:'
    end
    object Label4: TLabel
      Left = 8
      Top = 64
      Width = 215
      Height = 17
      Caption = 'Minimum distanse, between spheres:'
    end
    object ComboBox3: TComboBox
      Left = 8
      Top = 32
      Width = 225
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      TabOrder = 0
      Items.Strings = (
        'Dirt'
        'Cobblestone'
        'Wooden Plank'
        'Glass'
        'Sandstone'
        'Cobweb'
        'Moss Stone'
        'Obsidian'
        'Ice'
        'Snow Block'
        'Fence'
        'Glowstone Block')
    end
    object Edit2: TEdit
      Left = 8
      Top = 80
      Width = 225
      Height = 25
      TabOrder = 1
      Text = '50'
      OnKeyPress = Edit2KeyPress
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 136
      Width = 225
      Height = 152
      Caption = 'Sphere biomes:'
      TabOrder = 2
      object CheckBox5: TCheckBox
        Left = 8
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Forest'
        TabOrder = 0
      end
      object CheckBox6: TCheckBox
        Left = 8
        Top = 32
        Width = 89
        Height = 17
        Caption = 'Rainforest'
        TabOrder = 1
      end
      object CheckBox7: TCheckBox
        Left = 8
        Top = 48
        Width = 73
        Height = 17
        Caption = 'Desert'
        TabOrder = 2
      end
      object CheckBox8: TCheckBox
        Left = 8
        Top = 64
        Width = 73
        Height = 17
        Caption = 'Plains'
        TabOrder = 3
      end
      object CheckBox9: TCheckBox
        Left = 8
        Top = 80
        Width = 73
        Height = 17
        Caption = 'Taiga'
        TabOrder = 4
      end
      object CheckBox10: TCheckBox
        Left = 8
        Top = 96
        Width = 89
        Height = 17
        Caption = 'Ice Desert'
        TabOrder = 5
      end
      object CheckBox11: TCheckBox
        Left = 8
        Top = 112
        Width = 73
        Height = 17
        Caption = 'Tundra'
        TabOrder = 6
      end
      object CheckBox12: TCheckBox
        Left = 8
        Top = 128
        Width = 73
        Height = 17
        Caption = 'Nether'
        TabOrder = 7
      end
    end
    object CheckBox13: TCheckBox
      Left = 8
      Top = 112
      Width = 121
      Height = 17
      Caption = 'Ellipsoid spheres'
      TabOrder = 3
    end
  end
end
