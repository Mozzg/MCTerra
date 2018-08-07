object player: Tplayer
  Left = 343
  Top = 301
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Player settings'
  ClientHeight = 278
  ClientWidth = 396
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
    Left = 176
    Top = 240
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 121
    Height = 100
    Caption = 'Experience settings'
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 29
      Height = 13
      Caption = 'Level:'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 73
      Height = 13
      Caption = 'Experience (%):'
    end
    object Edit1: TEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = Edit1Change
      OnExit = Edit1Exit
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 8
      Top = 72
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = Edit2Change
      OnExit = Edit2Exit
      OnKeyPress = Edit2KeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 136
    Top = 8
    Width = 121
    Height = 60
    Caption = 'Score settings'
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 56
      Height = 13
      Caption = 'Total score:'
    end
    object Edit3: TEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = Edit3Exit
      OnKeyPress = Edit3KeyPress
    end
  end
  object Button3: TButton
    Left = 264
    Top = 188
    Width = 121
    Height = 36
    Caption = 'Inventory settings'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = Button3Click
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 112
    Width = 121
    Height = 157
    Caption = 'Hunger settings'
    TabOrder = 5
    object Label7: TLabel
      Left = 8
      Top = 19
      Width = 52
      Height = 13
      Caption = 'Food level:'
    end
    object Label8: TLabel
      Left = 8
      Top = 63
      Width = 101
      Height = 13
      Caption = 'Food saturation level:'
    end
    object Label9: TLabel
      Left = 8
      Top = 107
      Width = 106
      Height = 13
      Caption = 'Food exhaustion level:'
    end
    object Edit7: TEdit
      Left = 8
      Top = 34
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = Edit7Exit
      OnKeyPress = Edit7KeyPress
    end
    object Edit8: TEdit
      Left = 8
      Top = 79
      Width = 105
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0'
      OnExit = Edit8Exit
      OnKeyPress = Edit8KeyPress
    end
    object Edit9: TEdit
      Left = 8
      Top = 124
      Width = 105
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '0'
    end
  end
  object GroupBox4: TGroupBox
    Left = 136
    Top = 72
    Width = 121
    Height = 157
    Caption = 'Position settings'
    TabOrder = 6
    object Label4: TLabel
      Left = 8
      Top = 32
      Width = 10
      Height = 13
      Caption = 'X:'
    end
    object Label5: TLabel
      Left = 8
      Top = 72
      Width = 10
      Height = 13
      Caption = 'Y:'
    end
    object Label6: TLabel
      Left = 8
      Top = 112
      Width = 10
      Height = 13
      Caption = 'Z:'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Change position'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object Edit4: TEdit
      Left = 8
      Top = 48
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = Edit4Change
      OnExit = Edit4Exit
      OnKeyPress = Edit4KeyPress
    end
    object Edit5: TEdit
      Left = 8
      Top = 88
      Width = 105
      Height = 21
      TabOrder = 2
      Text = '0'
      OnExit = Edit5Exit
      OnKeyPress = Edit5KeyPress
    end
    object Edit6: TEdit
      Left = 8
      Top = 128
      Width = 105
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = Edit6Change
      OnExit = Edit6Exit
      OnKeyPress = Edit6KeyPress
    end
  end
  object GroupBox5: TGroupBox
    Left = 264
    Top = 8
    Width = 121
    Height = 60
    Caption = 'Health settings'
    TabOrder = 7
    object Label10: TLabel
      Left = 8
      Top = 16
      Width = 34
      Height = 13
      Caption = 'Health:'
    end
    object Edit10: TEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = Edit10Exit
      OnKeyPress = Edit10KeyPress
    end
  end
  object GroupBox6: TGroupBox
    Left = 264
    Top = 72
    Width = 121
    Height = 105
    Caption = 'Line of sight settings'
    TabOrder = 8
    object Label11: TLabel
      Left = 8
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Yaw:'
    end
    object Label12: TLabel
      Left = 8
      Top = 56
      Width = 27
      Height = 13
      Caption = 'Pitch:'
    end
    object Edit11: TEdit
      Left = 8
      Top = 32
      Width = 105
      Height = 21
      TabOrder = 0
      Text = '0'
      OnExit = Edit11Exit
      OnKeyPress = Edit11KeyPress
    end
    object Edit12: TEdit
      Left = 8
      Top = 72
      Width = 105
      Height = 21
      TabOrder = 1
      Text = '0'
      OnExit = Edit12Exit
      OnKeyPress = Edit12KeyPress
    end
  end
end
