object dmAforismi: TdmAforismi
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 188
  Width = 252
  object dbAforismi: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Password="";Data Source=G:\deve' +
      'lop\shared\delphi\ServerApps\tools\EPSTool\bin\aforismi\db\afori' +
      'smi.mdb;Mode=Share Deny None;Extended Properties="";Persist Secu' +
      'rity Info=True;Jet OLEDB:System database="";Jet OLEDB:Registry P' +
      'ath="";Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Je' +
      't OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Op' +
      's=2;Jet OLEDB:Global Bulk Transactions=1;Jet OLEDB:New Database ' +
      'Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Enc' +
      'rypt Database=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False' +
      ';Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=Fa' +
      'lse'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 10
    Top = 5
  end
  object tbGeneri: TADOTable
    Connection = dbAforismi
    CursorType = ctStatic
    TableName = 'tbGeneri'
    Left = 70
    Top = 5
    object tbGeneriCodGen: TIntegerField
      FieldName = 'CodGen'
    end
    object tbGeneriDesc: TWideStringField
      FieldName = 'Desc'
      Size = 50
    end
    object tbGeneriLongDesc: TWideStringField
      FieldName = 'LongDesc'
      Size = 50
    end
  end
  object qryAforismi: TADOQuery
    Connection = dbAforismi
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CodCat'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = '101'
      end>
    SQL.Strings = (
      
        'SELECT tbAforismi.CodCat, tbAforismi.Aforisma, tbAutori.Cognome,' +
        ' tbAutori.Nome, tbAforismi.Note,  tbAforismi.Traduzione, tbAfori' +
        'smi.Order, tbAforismi.Significato, tbAforismi.Commenti  '
      
        'FROM tbAutori RIGHT JOIN tbAforismi ON tbAutori.CodAut = tbAfori' +
        'smi.CodAut'
      'WHERE (((tbAforismi.CodCat)=:CodCat))'
      'ORDER BY tbAforismi.Order;')
    Left = 10
    Top = 55
    object qryAforismiCodCat: TIntegerField
      FieldName = 'CodCat'
    end
    object qryAforismiAforisma: TMemoField
      FieldName = 'Aforisma'
      BlobType = ftMemo
    end
    object qryAforismiCognome: TWideStringField
      FieldName = 'Cognome'
      Size = 100
    end
    object qryAforismiNome: TWideStringField
      FieldName = 'Nome'
      Size = 100
    end
    object qryAforismiNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
    object qryAforismiTraduzione: TMemoField
      FieldName = 'Traduzione'
      BlobType = ftMemo
    end
    object qryAforismiOrder: TIntegerField
      FieldName = 'Order'
    end
    object qryAforismiSignificato: TMemoField
      FieldName = 'Significato'
      BlobType = ftMemo
    end
    object qryAforismiCommenti: TMemoField
      FieldName = 'Commenti'
      BlobType = ftMemo
    end
  end
  object qryCategorie: TADOQuery
    Connection = dbAforismi
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'CodGen'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 510
        Value = Null
      end>
    SQL.Strings = (
      'SELECT tbGeneri.CodGen, tbCategorie.CodCat, tbCategorie.Desc'
      
        'FROM tbGeneri INNER JOIN tbCategorie ON tbGeneri.CodGen = tbCate' +
        'gorie.CodGen'
      'WHERE (((tbGeneri.CodGen)=:CodGen))'
      'ORDER BY tbCategorie.Desc;')
    Left = 70
    Top = 55
    object qryCategorieCodGen: TIntegerField
      FieldName = 'CodGen'
    end
    object qryCategorieCodCat: TIntegerField
      FieldName = 'CodCat'
    end
  end
  object qryCateg: TADOQuery
    Connection = dbAforismi
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT tbCategorie.CodCat, tbCategorie.Desc, tbCategorie.LongDes' +
        'c, tbCategorie.Desc1, Count(tbAforismi.CodAfo) AS Conteggio'
      
        'FROM tbCategorie LEFT JOIN tbAforismi ON tbCategorie.CodCat = tb' +
        'Aforismi.CodCat'
      
        'GROUP BY tbCategorie.CodCat, tbCategorie.Desc, tbCategorie.LongD' +
        'esc, tbCategorie.Desc1'
      'ORDER BY tbCategorie.CodCat;')
    Left = 125
    Top = 55
    object qryCategCodCat: TIntegerField
      FieldName = 'CodCat'
    end
    object qryCategDesc: TWideStringField
      FieldName = 'Desc'
      Size = 255
    end
    object qryCategLongDesc: TWideStringField
      FieldName = 'LongDesc'
      Size = 255
    end
    object qryCategDesc1: TWideStringField
      FieldName = 'Desc1'
      Size = 50
    end
    object qryCategConteggio: TIntegerField
      FieldName = 'Conteggio'
    end
  end
  object tbAforismi: TADOTable
    Connection = dbAforismi
    CursorType = ctStatic
    TableName = 'tbAforismi'
    Left = 125
    Top = 5
    object tbAforismiCodAfo: TAutoIncField
      FieldName = 'CodAfo'
      ReadOnly = True
    end
    object tbAforismiCodAut: TIntegerField
      FieldName = 'CodAut'
    end
    object tbAforismiCodCat: TIntegerField
      FieldName = 'CodCat'
    end
    object tbAforismilocale: TWideStringField
      FieldName = 'locale'
      Size = 8
    end
    object tbAforismiAforisma: TMemoField
      FieldName = 'Aforisma'
      BlobType = ftMemo
    end
    object tbAforismiTraduzione: TMemoField
      FieldName = 'Traduzione'
      BlobType = ftMemo
    end
    object tbAforismiNote: TMemoField
      FieldName = 'Note'
      BlobType = ftMemo
    end
    object tbAforismiSignificato: TMemoField
      FieldName = 'Significato'
      BlobType = ftMemo
    end
    object tbAforismiCommenti: TMemoField
      FieldName = 'Commenti'
      BlobType = ftMemo
    end
    object tbAforismiSearchKey: TWideStringField
      FieldName = 'SearchKey'
      Size = 50
    end
    object tbAforismiOrder: TIntegerField
      FieldName = 'Order'
    end
  end
end
