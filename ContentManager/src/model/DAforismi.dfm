object dmAforismi: TdmAforismi
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 201
  Width = 425
  object qryCateg: TADOQuery
    Connection = dbAforismi
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT tbCategorie.CodCat, tbCategorie.Desc, tbCategorie.LongDes' +
        'c, tbGeneri.Genere, Count(tbAforismi.CodAfo) AS Conteggio'
      
        'FROM tbGeneri INNER JOIN (tbCategorie LEFT JOIN tbAforismi ON tb' +
        'Categorie.CodCat = tbAforismi.CodCat) ON tbGeneri.CodGen = tbCat' +
        'egorie.CodGen'
      
        'GROUP BY tbCategorie.CodCat, tbCategorie.Desc, tbCategorie.LongD' +
        'esc, tbGeneri.Genere'
      'ORDER BY tbCategorie.CodCat;'
      '')
    Left = 13
    Top = 119
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
    object qryCategGenere: TWideStringField
      FieldName = 'Genere'
      Size = 1
    end
    object qryCategConteggio: TIntegerField
      FieldName = 'Conteggio'
    end
  end
  object dbAforismi: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=S:\data\database\af' +
      'orismi\aforismi.mdb;Mode=Share Deny None;Persist Security Info=F' +
      'alse;Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet' +
      ' OLEDB:Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Da' +
      'tabase Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OL' +
      'EDB:Global Bulk Transactions=1;Jet OLEDB:New Database Password="' +
      '";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Datab' +
      'ase=False;Jet OLEDB:Don'#39't Copy Locale on Compact=False;Jet OLEDB' +
      ':Compact Without Replica Repair=False;Jet OLEDB:SFP=False;'
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 24
    Top = 8
  end
  object tbAforismi: TADOTable
    Connection = dbAforismi
    CursorType = ctStatic
    TableName = 'tbAforismi'
    Left = 16
    Top = 64
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
    object tbAforismiEtico: TWideStringField
      FieldName = 'Etico'
      Size = 255
    end
    object tbAforismilocale: TWideStringField
      FieldName = 'locale'
      Size = 8
    end
    object tbAforismiAforisma: TWideMemoField
      FieldName = 'Aforisma'
      BlobType = ftWideMemo
    end
    object tbAforismiTraduzione: TWideMemoField
      FieldName = 'Traduzione'
      BlobType = ftWideMemo
    end
    object tbAforismiNote: TWideMemoField
      FieldName = 'Note'
      BlobType = ftWideMemo
    end
    object tbAforismiSignificato: TWideMemoField
      FieldName = 'Significato'
      BlobType = ftWideMemo
    end
    object tbAforismiCommenti: TWideMemoField
      FieldName = 'Commenti'
      BlobType = ftWideMemo
    end
    object tbAforismiSearchKey: TWideStringField
      FieldName = 'SearchKey'
      Size = 50
    end
    object tbAforismiOrder: TIntegerField
      FieldName = 'Order'
    end
  end
  object tbGeneri: TADOTable
    Connection = dbAforismi
    CursorType = ctStatic
    TableName = 'tbGeneri'
    Left = 80
    Top = 64
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
    object tbGeneriGenere: TWideStringField
      FieldName = 'Genere'
      Size = 1
    end
  end
  object qryCatInGen: TADOQuery
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
      
        'SELECT tbGeneri.CodGen, tbCategorie.CodCat, tbCategorie.Desc, tb' +
        'Categorie.LongDesc, tbGeneri.Genere'
      
        'FROM tbGeneri INNER JOIN tbCategorie ON tbGeneri.CodGen = tbCate' +
        'gorie.CodGen'
      'WHERE (((tbGeneri.CodGen)=:CodGen))'
      'ORDER BY tbCategorie.Desc;')
    Left = 182
    Top = 63
    object qryCatInGenCodGen: TIntegerField
      FieldName = 'CodGen'
    end
    object qryCatInGenCodCat: TIntegerField
      FieldName = 'CodCat'
    end
    object qryCatInGenDesc: TWideStringField
      FieldName = 'Desc'
      Size = 255
    end
    object qryCatInGenLongDesc: TWideStringField
      FieldName = 'LongDesc'
      Size = 255
    end
    object qryCatInGenGenere: TWideStringField
      FieldName = 'Genere'
      Size = 1
    end
  end
  object qryAfoInCat: TADOQuery
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
      
        'SELECT tbAforismi.CodAfo, tbAforismi.CodCat, tbAforismi.Etico, t' +
        'bAforismi.locale, tbAforismi.Aforisma, tbAforismi.Traduzione, tb' +
        'Aforismi.Note, tbAforismi.Significato, tbAforismi.Commenti, tbAf' +
        'orismi.SearchKey, tbAforismi.Order, tbAutori.CodAut, tbAutori.Co' +
        'gnome, tbAutori.Nome'
      
        'FROM tbAforismi LEFT JOIN tbAutori ON tbAforismi.CodAut = tbAuto' +
        'ri.CodAut'
      'WHERE tbAforismi.CodCat = :CodCat'
      'ORDER BY tbAforismi.Order;')
    Left = 254
    Top = 63
    object qryAfoInCatCodAfo: TAutoIncField
      FieldName = 'CodAfo'
      ReadOnly = True
    end
    object qryAfoInCatCodCat: TIntegerField
      FieldName = 'CodCat'
    end
    object qryAfoInCatEtico: TWideStringField
      FieldName = 'Etico'
      Size = 255
    end
    object qryAfoInCatlocale: TWideStringField
      FieldName = 'locale'
      Size = 8
    end
    object qryAfoInCatAforisma: TWideMemoField
      FieldName = 'Aforisma'
      BlobType = ftWideMemo
    end
    object qryAfoInCatTraduzione: TWideMemoField
      FieldName = 'Traduzione'
      BlobType = ftWideMemo
    end
    object qryAfoInCatNote: TWideMemoField
      FieldName = 'Note'
      BlobType = ftWideMemo
    end
    object qryAfoInCatSignificato: TWideMemoField
      FieldName = 'Significato'
      BlobType = ftWideMemo
    end
    object qryAfoInCatCommenti: TWideMemoField
      FieldName = 'Commenti'
      BlobType = ftWideMemo
    end
    object qryAfoInCatSearchKey: TWideStringField
      FieldName = 'SearchKey'
      Size = 50
    end
    object qryAfoInCatOrder: TIntegerField
      FieldName = 'Order'
    end
    object qryAfoInCatCodAut: TAutoIncField
      FieldName = 'CodAut'
      ReadOnly = True
    end
    object qryAfoInCatCognome: TWideStringField
      FieldName = 'Cognome'
      Size = 100
    end
    object qryAfoInCatNome: TWideStringField
      FieldName = 'Nome'
      Size = 100
    end
  end
end
