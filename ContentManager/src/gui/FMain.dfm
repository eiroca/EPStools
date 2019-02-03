object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Content Manager'
  ClientHeight = 322
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object sbStatus: TStatusBar
    Left = 0
    Top = 303
    Width = 439
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = 'Status'
  end
  object odDB: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'aforismi.mdb'
    FileTypes = <
      item
        DisplayName = 'DB'
        FileMask = '*.mdb'
      end>
    Options = []
    Left = 96
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 35
    Top = 15
    object File1: TMenuItem
      Caption = '&File'
      object About1: TMenuItem
        Action = aAbout
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = aExit
      end
    end
    object Aforismi1: TMenuItem
      Caption = '&Aforismi'
      object OpenDB1: TMenuItem
        Action = aOpenAforismi
      end
      object ExportasDokuWiki1: TMenuItem
        Action = aExportAforismiAsDokuWiki
      end
      object exportasINI1: TMenuItem
        Action = aExportAforismiAsINI
      end
      object ExportasRSS1: TMenuItem
        Action = aExportAforismiAsRSS
      end
      object Randomizeorder1: TMenuItem
        Action = aGenerateOrderAforimi
      end
    end
  end
  object ActionManager1: TActionManager
    Left = 152
    Top = 16
    StyleName = 'Platform Default'
    object aOpenAforismi: TAction
      Caption = '&Open DB'
      OnExecute = aOpenAforismiExecute
    end
    object aExportAforismiAsINI: TAction
      Caption = 'Export as &INI'
      Enabled = False
      OnExecute = aExportAforismiAsINIExecute
    end
    object aExportAforismiAsDokuWiki: TAction
      Caption = 'Export as &DokuWiki'
      Enabled = False
      OnExecute = aExportAforismiAsDokuWikiExecute
    end
    object aExportAforismiAsRSS: TAction
      Caption = 'Export as &RSS'
      Enabled = False
      OnExecute = aExportAforismiAsRSSExecute
    end
    object aGenerateOrderAforimi: TAction
      Caption = 'Randomize order'
      Enabled = False
      OnExecute = aGenerateOrderAforimiExecute
    end
    object aAbout: TAction
      Caption = 'About...'
      OnExecute = aAboutExecute
    end
    object aExit: TAction
      Caption = 'E&xit'
      OnExecute = aExitExecute
    end
  end
end
