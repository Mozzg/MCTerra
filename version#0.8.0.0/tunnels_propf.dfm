object tunnels: Ttunnels
  Left = 298
  Top = 231
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Golden tunnels settings'
  ClientHeight = 336
  ClientWidth = 518
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
    Left = 48
    Top = 296
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 233
    Height = 153
    Caption = 'Tunnel settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 80
      Width = 102
      Height = 17
      Caption = 'Horizontal radius:'
    end
    object Label2: TLabel
      Left = 8
      Top = 104
      Width = 89
      Height = 17
      Caption = 'Vertical radius:'
    end
    object Label3: TLabel
      Left = 120
      Top = 64
      Width = 21
      Height = 17
      Caption = 'min'
    end
    object Label4: TLabel
      Left = 168
      Top = 64
      Width = 25
      Height = 17
      Caption = 'max'
    end
    object Label5: TLabel
      Left = 8
      Top = 128
      Width = 147
      Height = 17
      Caption = 'Percent of round tunnels:'
    end
    object Label8: TLabel
      Left = 8
      Top = 24
      Width = 119
      Height = 17
      Caption = 'Tunnel density (%): '
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Round tunnels'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object Edit1: TEdit
      Left = 112
      Top = 80
      Width = 49
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '10'
      OnChange = Edit1Change
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 112
      Top = 102
      Width = 49
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '10'
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 168
      Top = 80
      Width = 49
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '15'
      OnChange = Edit3Change
      OnKeyPress = Edit3KeyPress
    end
    object Edit4: TEdit
      Left = 168
      Top = 102
      Width = 49
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '15'
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TEdit
      Left = 168
      Top = 126
      Width = 49
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '80'
      OnKeyPress = Edit5KeyPress
    end
    object Edit7: TEdit
      Left = 128
      Top = 22
      Width = 89
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '90'
      OnKeyPress = Edit7KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 256
    Top = 16
    Width = 249
    Height = 305
    Caption = 'Lightning settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Label6: TLabel
      Left = 8
      Top = 48
      Width = 144
      Height = 17
      Caption = 'Lightsource density (%):'
    end
    object Label7: TLabel
      Left = 8
      Top = 72
      Width = 74
      Height = 17
      Caption = 'Light blocks:'
      Enabled = False
    end
    object Label9: TLabel
      Left = 8
      Top = 278
      Width = 127
      Height = 17
      Caption = 'Skyholes density (%):'
    end
    object Label10: TLabel
      Left = 8
      Top = 192
      Width = 165
      Height = 17
      Caption = 'Lightsource placement type:'
      Enabled = False
    end
    object Bevel1: TBevel
      Left = 0
      Top = 246
      Width = 249
      Height = 2
    end
    object Edit6: TEdit
      Left = 160
      Top = 47
      Width = 81
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '80'
      OnKeyPress = Edit6KeyPress
    end
    object ListBox1: TListBox
      Left = 88
      Top = 72
      Width = 153
      Height = 113
      Enabled = False
      ItemHeight = 17
      Items.Strings = (
        'Glowstone'
        'Lava'
        'Jack-O-Lantern'
        'Fire (with Netherrack)'
        'Torch'
        'Glowing redstone ore')
      MultiSelect = True
      TabOrder = 1
    end
    object CheckBox2: TCheckBox
      Left = 7
      Top = 255
      Width = 240
      Height = 17
      Caption = 'Generate holes for sunlight (skyholes)'
      TabOrder = 2
      OnClick = CheckBox2Click
    end
    object Edit8: TEdit
      Left = 144
      Top = 277
      Width = 97
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '80'
      OnKeyPress = Edit8KeyPress
    end
    object CheckBox6: TCheckBox
      Left = 8
      Top = 24
      Width = 161
      Height = 17
      Caption = 'Generate light sourses'
      TabOrder = 4
      OnClick = CheckBox6Click
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 216
      Width = 233
      Height = 25
      Style = csDropDownList
      Enabled = False
      ItemHeight = 17
      ItemIndex = 2
      TabOrder = 5
      Text = 'Inside Walls with glass'
      Items.Strings = (
        'Original'
        'Inside Walls'
        'Inside Walls with glass'
        'Floating')
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 177
    Width = 233
    Height = 104
    Caption = 'Other settings'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object CheckBox3: TCheckBox
      Left = 8
      Top = 40
      Width = 121
      Height = 17
      Caption = 'Generate HUBs'
      Enabled = False
      TabOrder = 0
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 58
      Width = 217
      Height = 17
      Caption = 'Generate seperate tunnel systems'
      TabOrder = 1
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 77
      Width = 169
      Height = 17
      Caption = 'Generate flooded tunnels'
      TabOrder = 2
    end
    object CheckBox7: TCheckBox
      Left = 8
      Top = 22
      Width = 161
      Height = 17
      Caption = 'Generate tall grass'
      TabOrder = 3
    end
  end
end
