object fmMain: TfmMain
  Left = 185
  Top = 159
  Caption = 'EPS Tool'
  ClientHeight = 184
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 165
    Width = 419
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
    ExplicitTop = 533
    ExplicitWidth = 650
  end
  object MainMenu1: TMainMenu
    Left = 107
    Top = 47
    object File1: TMenuItem
      Caption = '&File'
      object Portal1: TMenuItem
        Caption = 'Portal'
        OnClick = Portal1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
  end
end
