object fmAbout: TfmAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 242
  ClientWidth = 364
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 364
    Height = 209
    Align = alTop
    Alignment = taCenter
    Lines.Strings = (
      ''
      'Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio'
      ''
      
        'This program is free software: you can redistribute it and/or mo' +
        'dify it '
      
        'under the terms of the GNU General Public License as published b' +
        'y the '
      
        'Free Software Foundation, either version 3 of the License, or (a' +
        't your '
      'option) any later version.'
      ''
      
        'This program is distributed in the hope that it will be useful, ' +
        'but '
      'WITHOUT ANY WARRANTY; without even the implied warranty of '
      'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the '
      'GNU General Public License for more details.'
      ''
      
        'You should have received a copy of the GNU General Public Licens' +
        'e along '
      'with this program.  If not, see <http://www.gnu.org/licenses/>.')
    TabOrder = 0
    ExplicitWidth = 362
  end
  object BitBtn1: TBitBtn
    Left = 150
    Top = 215
    Width = 70
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
