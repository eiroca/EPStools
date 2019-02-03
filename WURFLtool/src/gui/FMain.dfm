object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'WURFL tool'
  ClientHeight = 269
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 250
    Width = 554
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
  end
  object MainMenu1: TMainMenu
    Left = 75
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
        OnClick = miWURFLLoadClick
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
      end
      object miWURFLClose: TMenuItem
        Caption = 'Close'
        OnClick = miWURFLCloseClick
      end
      object miExportProperties: TMenuItem
        Caption = 'Export properties'
        OnClick = miExportPropertiesClick
      end
    end
  end
  object odWURL: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'wurfl.xml'
    FileTypes = <
      item
        DisplayName = 'XML'
        FileMask = '*.xml'
      end>
    Options = []
    Left = 280
    Top = 24
  end
  object odDB: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'wurfl.mdb'
    FileTypes = <
      item
        DisplayName = 'DB'
        FileMask = '*.mdb'
      end>
    Options = []
    Left = 204
    Top = 24
  end
  object odProperties: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'wurfl_export.txt'
    FileTypes = <
      item
        DisplayName = 'TXT'
        FileMask = '*.txt'
      end>
    Options = []
    Left = 280
    Top = 80
  end
  object MainMenu2: TMainMenu
    Left = 264
    Top = 184
  end
end
