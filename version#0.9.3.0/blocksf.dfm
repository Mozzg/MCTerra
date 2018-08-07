object blocks: Tblocks
  Left = 288
  Top = 173
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Blocks ID settings'
  ClientHeight = 491
  ClientWidth = 557
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
    Left = 184
    Top = 456
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 537
    Height = 238
    Caption = 'Blocks ID settings'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 164
      Width = 59
      Height = 13
      Caption = 'Block name:'
    end
    object Label2: TLabel
      Left = 8
      Top = 212
      Width = 61
      Height = 13
      Caption = 'Diffuse level:'
    end
    object Label3: TLabel
      Left = 8
      Top = 188
      Width = 51
      Height = 13
      Caption = 'Light level:'
    end
    object Label8: TLabel
      Left = 8
      Top = 140
      Width = 49
      Height = 13
      Caption = 'Blocks ID:'
    end
    object ListBox1: TListBox
      Left = 232
      Top = 16
      Width = 297
      Height = 214
      Style = lbOwnerDrawFixed
      ItemHeight = 13
      TabOrder = 11
      OnDrawItem = ListBox1DrawItem
    end
    object Edit1: TEdit
      Left = 72
      Top = 160
      Width = 153
      Height = 21
      TabOrder = 4
      OnChange = Edit1Change
      OnEnter = Edit1Enter
      OnKeyPress = Edit1KeyPress
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Solid block'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 88
      Width = 113
      Height = 17
      Caption = 'Transparent block'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 120
      Width = 89
      Height = 17
      Caption = 'Diffuse block'
      Enabled = False
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object Edit2: TEdit
      Left = 72
      Top = 184
      Width = 153
      Height = 21
      TabOrder = 5
      OnExit = Edit2Exit
      OnKeyPress = Edit2KeyPress
    end
    object Edit3: TEdit
      Left = 72
      Top = 208
      Width = 153
      Height = 21
      TabOrder = 6
      OnExit = Edit3Exit
      OnKeyPress = Edit3KeyPress
    end
    object Button3: TButton
      Left = 16
      Top = 24
      Width = 97
      Height = 25
      Caption = 'Add new block'
      TabOrder = 7
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 16
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Delete block'
      TabOrder = 8
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 120
      Top = 24
      Width = 97
      Height = 25
      Caption = 'Reset blocks'
      TabOrder = 9
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 120
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Clear blocks'
      TabOrder = 10
      OnClick = Button6Click
    end
    object Edit6: TEdit
      Left = 72
      Top = 136
      Width = 153
      Height = 21
      TabOrder = 3
      OnEnter = Edit6Enter
      OnExit = Edit6Exit
      OnKeyPress = Edit6KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 248
    Width = 537
    Height = 201
    Caption = 'Blocks change settings'
    TabOrder = 3
    object Label4: TLabel
      Left = 8
      Top = 84
      Width = 69
      Height = 13
      Caption = 'From block ID:'
    end
    object Label5: TLabel
      Left = 8
      Top = 108
      Width = 79
      Height = 13
      Caption = 'From data value:'
    end
    object Label6: TLabel
      Left = 8
      Top = 148
      Width = 59
      Height = 13
      Caption = 'To block ID:'
    end
    object Label7: TLabel
      Left = 8
      Top = 172
      Width = 69
      Height = 13
      Caption = 'To data value:'
    end
    object ListBox2: TListBox
      Left = 248
      Top = 16
      Width = 281
      Height = 177
      Style = lbOwnerDrawFixed
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 7
      OnDrawItem = ListBox2DrawItem
    end
    object Edit4: TEdit
      Left = 80
      Top = 80
      Width = 160
      Height = 21
      TabOrder = 0
      OnEnter = Edit4Enter
      OnExit = Edit4Exit
      OnKeyPress = Edit4KeyPress
    end
    object Button7: TButton
      Left = 8
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Add new change'
      TabOrder = 4
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 112
      Top = 16
      Width = 97
      Height = 25
      Caption = 'Delete change'
      TabOrder = 5
      OnClick = Button8Click
    end
    object ComboBox1: TComboBox
      Left = 88
      Top = 106
      Width = 153
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Any'
      OnChange = ComboBox1Change
      OnKeyPress = ComboBox1KeyPress
      Items.Strings = (
        'Any'
        '0 (0000)'
        '1 (0001)'
        '2 (0010)'
        '3 (0011)'
        '4 (0100)'
        '5 (0101)'
        '6 (0110)'
        '7 (0111)'
        '8 (1000)'
        '9 (1001)'
        '10 (1010)'
        '11 (1011)'
        '12 (1100)'
        '13 (1101)'
        '14 (1110)'
        '15 (1111)')
    end
    object Edit5: TEdit
      Left = 80
      Top = 144
      Width = 160
      Height = 21
      TabOrder = 2
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
      OnKeyPress = Edit5KeyPress
    end
    object ComboBox2: TComboBox
      Left = 88
      Top = 170
      Width = 153
      Height = 19
      Style = csOwnerDrawFixed
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'Same data value'
      OnChange = ComboBox2Change
      OnKeyPress = ComboBox2KeyPress
      Items.Strings = (
        'Same data value'
        '0 (0000)'
        '1 (0001)'
        '2 (0010)'
        '3 (0011)'
        '4 (0100)'
        '5 (0101)'
        '6 (0110)'
        '7 (0111)'
        '8 (1000)'
        '9 (1001)'
        '10 (1010)'
        '11 (1011)'
        '12 (1100)'
        '13 (1101)'
        '14 (1110)'
        '15 (1111)')
    end
    object Button9: TButton
      Left = 112
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Clear change'
      TabOrder = 6
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 8
      Top = 48
      Width = 97
      Height = 25
      Caption = 'Incert new change'
      TabOrder = 8
      OnClick = Button10Click
    end
    object BitBtn1: TBitBtn
      Left = 216
      Top = 16
      Width = 25
      Height = 25
      TabOrder = 9
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
      Left = 216
      Top = 48
      Width = 25
      Height = 25
      TabOrder = 10
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
  end
end
