object desert: Tdesert
  Left = 269
  Top = 279
  Width = 675
  Height = 310
  Caption = 'Desert map settings'
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
    Left = 240
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 328
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 649
    Height = 233
    Caption = 'Desert biome settings'
    TabOrder = 2
    object Label4: TLabel
      Left = 140
      Top = 14
      Width = 143
      Height = 13
      Caption = 'Block material under the sand:'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 115
      Width = 105
      Height = 17
      Caption = 'Generate cactus'
      TabOrder = 0
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 14
      Width = 129
      Height = 83
      Caption = 'Oazis settings'
      TabOrder = 1
      object Label2: TLabel
        Left = 8
        Top = 38
        Width = 59
        Height = 13
        Caption = 'Oazis count:'
      end
      object CheckBox2: TCheckBox
        Left = 8
        Top = 17
        Width = 97
        Height = 17
        Caption = 'Generate oazis'
        TabOrder = 0
        OnClick = CheckBox2Click
      end
      object Edit2: TEdit
        Left = 8
        Top = 54
        Width = 113
        Height = 21
        TabOrder = 1
        Text = '5'
      end
    end
    object ComboBox1: TComboBox
      Left = 140
      Top = 28
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Stone'
        'Dirt'
        'Cobblestone'
        'Wooden Plank'
        'Sand'
        'Gravel'
        'Wood'
        'Leaves'
        'Sponge'
        'Glass'
        'Sandstone'
        'Cobweb'
        'Double Slabs'
        'Slabs'
        'Brick Block'
        'TNT'
        'Bookshelf'
        'Moss Stone'
        'Obsidian'
        'Ice'
        'Snow Block'
        'Clay Block'
        'Fence'
        'Pumpkin'
        'Netherrack'
        'Soul Sand'
        'Glowstone Block'
        'Jack-O-Lantern'
        'Stone Bricks'
        'Melon'
        'Nether Brick'
        'Nether Brick Fence')
    end
    object CheckBox4: TCheckBox
      Left = 141
      Top = 75
      Width = 105
      Height = 17
      Caption = 'Generate volcano'
      Enabled = False
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 99
      Width = 97
      Height = 17
      Caption = 'Generate shrubs'
      TabOrder = 4
    end
    object GroupBox1: TGroupBox
      Left = 288
      Top = 8
      Width = 353
      Height = 217
      Caption = 'Village settings'
      TabOrder = 5
      object Label6: TLabel
        Left = 8
        Top = 168
        Width = 64
        Height = 13
        Caption = 'Village count:'
      end
      object CheckBox7: TCheckBox
        Left = 8
        Top = 16
        Width = 105
        Height = 17
        Caption = 'Generate villages'
        TabOrder = 0
        OnClick = CheckBox7Click
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 32
        Width = 145
        Height = 105
        Caption = 'VIllage types'
        TabOrder = 1
        object CheckBox8: TCheckBox
          Left = 8
          Top = 16
          Width = 57
          Height = 17
          Caption = 'Ruined'
          TabOrder = 0
        end
        object CheckBox9: TCheckBox
          Left = 8
          Top = 32
          Width = 57
          Height = 17
          Caption = 'Normal'
          Enabled = False
          TabOrder = 1
        end
        object CheckBox10: TCheckBox
          Left = 8
          Top = 48
          Width = 129
          Height = 17
          Caption = 'Normal with vegetation'
          Enabled = False
          TabOrder = 2
        end
        object CheckBox11: TCheckBox
          Left = 8
          Top = 64
          Width = 97
          Height = 17
          Caption = 'Fortified village'
          Enabled = False
          TabOrder = 3
        end
        object CheckBox12: TCheckBox
          Left = 8
          Top = 80
          Width = 89
          Height = 17
          Caption = 'Hidden village'
          Enabled = False
          TabOrder = 4
        end
      end
      object GroupBox5: TGroupBox
        Left = 160
        Top = 8
        Width = 185
        Height = 201
        Caption = 'Village names'
        TabOrder = 2
        object Label5: TLabel
          Left = 8
          Top = 120
          Width = 31
          Height = 13
          Caption = 'Name:'
        end
        object ListBox1: TListBox
          Left = 8
          Top = 16
          Width = 169
          Height = 97
          Style = lbOwnerDrawFixed
          ItemHeight = 13
          TabOrder = 0
          OnDrawItem = ListBox1DrawItem
        end
        object Edit4: TEdit
          Left = 8
          Top = 136
          Width = 169
          Height = 21
          TabOrder = 1
          OnExit = Edit4Exit
          OnKeyPress = Edit4KeyPress
        end
        object Button3: TButton
          Left = 8
          Top = 168
          Width = 81
          Height = 25
          Caption = 'New'
          TabOrder = 2
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 104
          Top = 168
          Width = 75
          Height = 25
          Caption = 'Delete'
          TabOrder = 3
          OnClick = Button4Click
        end
      end
      object Edit5: TEdit
        Left = 8
        Top = 184
        Width = 145
        Height = 21
        Enabled = False
        TabOrder = 3
      end
    end
    object GroupBox6: TGroupBox
      Left = 8
      Top = 136
      Width = 273
      Height = 89
      Caption = 'Preview options'
      TabOrder = 6
      object CheckBox6: TCheckBox
        Left = 8
        Top = 16
        Width = 161
        Height = 17
        Caption = 'Generate heightmap preview'
        TabOrder = 0
        OnClick = CheckBox6Click
      end
      object CheckBox13: TCheckBox
        Left = 8
        Top = 32
        Width = 145
        Height = 17
        Caption = 'Generate oasises preview'
        TabOrder = 1
      end
      object CheckBox14: TCheckBox
        Left = 8
        Top = 48
        Width = 145
        Height = 17
        Caption = 'Generate villages preview'
        TabOrder = 2
      end
      object CheckBox15: TCheckBox
        Left = 8
        Top = 64
        Width = 137
        Height = 17
        Caption = 'Generate only previews'
        TabOrder = 3
      end
    end
  end
  object CheckBox3: TCheckBox
    Left = 149
    Top = 63
    Width = 108
    Height = 17
    Caption = 'Generate pyramids'
    Enabled = False
    TabOrder = 3
  end
end
