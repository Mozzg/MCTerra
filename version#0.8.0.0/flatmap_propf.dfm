object flatmap: Tflatmap
  Left = 363
  Top = 203
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Flatmap settings'
  ClientHeight = 332
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 195
    Top = 95
    Width = 58
    Height = 13
    Caption = 'Layer name:'
  end
  object Label6: TLabel
    Left = 195
    Top = 215
    Width = 76
    Height = 13
    Caption = 'Starting altitude:'
  end
  object Label7: TLabel
    Left = 195
    Top = 255
    Width = 57
    Height = 13
    Caption = 'Layer width:'
  end
  object Label8: TLabel
    Left = 195
    Top = 135
    Width = 68
    Height = 13
    Caption = 'Layer material:'
  end
  object Label1: TLabel
    Left = 13
    Top = 8
    Width = 44
    Height = 17
    Caption = 'Layers:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 195
    Top = 176
    Width = 64
    Height = 13
    Caption = 'Material data:'
  end
  object Button1: TButton
    Left = 104
    Top = 298
    Width = 75
    Height = 25
    Caption = 'OK'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 194
    Top = 298
    Width = 75
    Height = 25
    Caption = 'Cancel'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 11
    Top = 28
    Width = 169
    Height = 261
    Style = lbOwnerDrawFixed
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
    OnDrawItem = ListBox1DrawItem
  end
  object Button3: TButton
    Left = 229
    Top = 29
    Width = 67
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button5: TButton
    Left = 301
    Top = 29
    Width = 67
    Height = 25
    Caption = 'Delete'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Edit3: TEdit
    Left = 195
    Top = 111
    Width = 173
    Height = 21
    TabOrder = 7
    OnExit = Edit3Exit
    OnKeyPress = Edit3KeyPress
  end
  object Edit4: TEdit
    Left = 195
    Top = 231
    Width = 173
    Height = 21
    Enabled = False
    TabOrder = 9
  end
  object Edit5: TEdit
    Left = 195
    Top = 271
    Width = 173
    Height = 21
    TabOrder = 10
    OnExit = Edit5Exit
    OnKeyPress = Edit5KeyPress
  end
  object Button9: TButton
    Left = 229
    Top = 61
    Width = 67
    Height = 25
    Caption = 'Insert'
    TabOrder = 4
    OnClick = Button9Click
  end
  object Button4: TButton
    Left = 301
    Top = 61
    Width = 67
    Height = 25
    Caption = 'Clear'
    TabOrder = 6
    OnClick = Button4Click
  end
  object ComboBox3: TComboBox
    Left = 195
    Top = 151
    Width = 173
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    OnChange = ComboBox3Change
    OnExit = ComboBox3Exit
    Items.Strings = (
      'Air'
      'Stone'
      'Grass'
      'Dirt'
      'Cobblestone'
      'Wooden Plank'
      'Bedrock'
      'Stationary water'
      'Stationary lava'
      'Sand'
      'Gravel'
      'Gold Ore'
      'Iron Ore'
      'Coal Ore'
      'Wood'
      'Leaves'
      'Sponge'
      'Glass'
      'Lapis Lazuli Ore'
      'Lapis Lazuli Block'
      'Sandstone'
      'Sticky Piston'
      'Cobweb'
      'Piston'
      'Wool'
      'Gold Block'
      'Iron Block'
      'Double Slabs'
      'Slabs'
      'Brick Block'
      'TNT'
      'Bookshelf'
      'Moss Stone'
      'Obsidian'
      'Diamond Ore'
      'Diamond Block'
      'Crafting Table'
      'Redstone Ore'
      'Glowing Redstone Ore'
      'Ice'
      'Snow Block'
      'Cactus'
      'Clay Block'
      'Fence'
      'Pumpkin'
      'Netherrack'
      'Soul Sand'
      'Glowstone Block'
      'Jack-O-Lantern'
      'Hidden Silverfish'
      'Stone Bricks'
      'Huge Brown Mushroom'
      'Huge Red Mushroom'
      'Melon'
      'Mycelium'
      'Nether Brick'
      'Nether Brick Fence')
  end
  object BitBtn1: TBitBtn
    Left = 189
    Top = 29
    Width = 25
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Glyph.Data = {
      16010000424D160100000000000076000000280000000F000000140000000100
      040000000000A0000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFF00000FFFFF0FFFFF0EEE0FF
      FFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FF
      FFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0F00000EEE00000F0FF0EEEEEEEEE
      0FF0FFF0EEEEEEE0FFF0FFFF0EEEEE0FFFF0FFFFF0EEE0FFFFF0FFFFFF0E0FFF
      FFF0FFFFFFF0FFFFFFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
  end
  object BitBtn2: TBitBtn
    Left = 189
    Top = 61
    Width = 25
    Height = 25
    TabOrder = 2
    OnClick = BitBtn2Click
    Glyph.Data = {
      16010000424D160100000000000076000000280000000F000000140000000100
      040000000000A0000000C40E0000C40E00001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFF0FFFFFFFFFFFFFFF0FFFFFFF0FFFFFFF0FFFFFF0E0FFFFFF0FFFFF0EEE0FF
      FFF0FFFF0EEEEE0FFFF0FFF0EEEEEEE0FFF0FF0EEEEEEEEE0FF0F00000EEE000
      00F0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FF
      FFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF0EEE0FFFFF0FFFFF00000FF
      FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
  end
  object ComboBox1: TComboBox
    Left = 195
    Top = 192
    Width = 174
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 13
    OnExit = ComboBox1Exit
  end
end
