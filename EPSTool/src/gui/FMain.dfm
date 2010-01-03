object fmMain: TfmMain
  Left = 185
  Top = 159
  Caption = 'EPS Manager'
  ClientHeight = 552
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
    Top = 533
    Width = 650
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
  end
  object Button1: TButton
    Left = 168
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button2Click
  end
  object MainMenu1: TMainMenu
    Left = 67
    Top = 23
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
    object WURFL1: TMenuItem
      Caption = '&WURFL'
      object miWURFLLoad: TMenuItem
        Caption = 'Load'
        OnClick = miWURFLLoadClick
      end
      object miWURFLExport: TMenuItem
        Caption = 'Export'
        object miWURFL2PHP: TMenuItem
          Caption = 'Export as PHP files'
          OnClick = miWURFL2PHPClick
        end
        object miWURFL2TXT: TMenuItem
          Caption = 'Export as TXT file'
          OnClick = miWURFL2TXTClick
        end
        object miWURFL2DB: TMenuItem
          Caption = 'Export in DB'
          OnClick = miWURFL2DBClick
        end
      end
      object miWURFLClose: TMenuItem
        Caption = 'Close'
        OnClick = miWURFLCloseClick
      end
    end
    object Aforismi1: TMenuItem
      Caption = '&Aforismi'
      object BuildSearchKey1: TMenuItem
        Caption = 'Build SearchKey'
        OnClick = BuildSearchKey1Click
      end
      object GenerateConfig1: TMenuItem
        Caption = 'Generate INI'
        OnClick = GenerateConfig1Click
      end
      object GenerateRSS1: TMenuItem
        Caption = 'Generate RSS'
        OnClick = GenerateRSS1Click
      end
    end
  end
end
