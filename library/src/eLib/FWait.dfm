object fmWait: TfmWait
  Left = 325
  Top = 153
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Wait....'
  ClientHeight = 78
  ClientWidth = 219
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 75
    Top = 40
    Width = 75
    Height = 25
    Kind = bkAbort
    NumGlyphs = 2
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object PB: TProgressBar
    Left = 8
    Top = 8
    Width = 200
    Height = 17
    Smooth = True
    TabOrder = 1
  end
end