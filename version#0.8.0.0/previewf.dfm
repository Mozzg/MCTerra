object preview: Tpreview
  Left = 186
  Top = 115
  Width = 576
  Height = 559
  HorzScrollBar.Smooth = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Map preview'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCanResize = FormCanResize
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 40
    Width = 529
    Height = 457
  end
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Save to file'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Close window'
    TabOrder = 1
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.bmp'
    Filter = 'Bitmap files (*.bmp)|*.bmp'
    Left = 264
    Top = 72
  end
end
