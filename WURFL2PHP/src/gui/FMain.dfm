object fmMain: TfmMain
  Left = 185
  Top = 159
  Caption = 'WURFL2PHP2006'
  ClientHeight = 612
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 593
    Width = 650
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
  end
  object MainMenu1: TMainMenu
    Left = 67
    Top = 23
    object File1: TMenuItem
      Caption = '&File'
      object miWURFLLoad: TMenuItem
        Caption = '&Load WURFL'
        OnClick = miWURFLLoadClick
      end
      object miWURFL2PHP: TMenuItem
        Caption = '&Export as PHP files'
        OnClick = miWURFL2PHPClick
      end
      object miWURFLClose: TMenuItem
        Caption = '&Close'
        OnClick = miWURFLCloseClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object About1: TMenuItem
        Caption = '&About'
        OnClick = About1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
  end
end
