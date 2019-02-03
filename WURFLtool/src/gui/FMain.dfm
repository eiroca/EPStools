object fmMain: TfmMain
  Left = 185
  Top = 159
  Caption = 'WURFL2PHP2006'
  ClientHeight = 318
  ClientWidth = 557
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
    Top = 299
    Width = 557
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
    ExplicitTop = 633
    ExplicitWidth = 650
  end
  object MainMenu1: TMainMenu
    Left = 67
    Top = 23
    object File1: TMenuItem
      Caption = '&File'
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
    object WURFL1: TMenuItem
      Caption = '&WURFL'
      object miWURFLLoad: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object miWURFLExport: TMenuItem
        Caption = 'Export'
        object miExportAsPHP: TMenuItem
          Caption = 'Export as PHP files'
          OnClick = miExportAsPHPClick
        end
        object miExportAsTXT: TMenuItem
          Caption = 'Export as TXT file'
          OnClick = miExportAsTXTClick
        end
        object miExportAsDB: TMenuItem
          Caption = 'Export in DB'
          OnClick = miExportAsDBClick
        end
        object miExportProperties: TMenuItem
          Caption = 'Export properties'
          OnClick = miExportPropertiesClick
        end
      end
      object miWURFLClose: TMenuItem
        Caption = 'Close'
        OnClick = miWURFLCloseClick
      end
    end
  end
end
