object dmWURFL2DB: TdmWURFL2DB
  OldCreateOrder = False
  Height = 184
  Width = 387
  object DBDevice: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=S:\develop\projects' +
      '\public\delphi\EPStools\WURFLtool\data\wurfl.mdb;Persist Securit' +
      'y Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 21
    Top = 5
  end
  object tbDevice: TADOTable
    Connection = DBDevice
    CursorType = ctStatic
    TableName = 'wurflDevice'
    Left = 43
    Top = 77
    object tbDeviceCodDev: TAutoIncField
      FieldName = 'CodDev'
      ReadOnly = True
    end
    object tbDeviceCodParent: TIntegerField
      FieldName = 'CodParent'
    end
    object tbDeviceID: TWideStringField
      FieldName = 'ID'
      Size = 255
    end
    object tbDeviceUserAgent: TWideStringField
      FieldName = 'UserAgent'
      Size = 255
    end
  end
  object tbGroup: TADOTable
    Connection = DBDevice
    CursorType = ctStatic
    TableName = 'wurflGroup'
    Left = 107
    Top = 77
    object tbGroupCodGrp: TAutoIncField
      FieldName = 'CodGrp'
      ReadOnly = True
    end
    object tbGroupName: TWideStringField
      FieldName = 'Name'
      Size = 50
    end
  end
  object tbProperties: TADOTable
    Connection = DBDevice
    CursorType = ctStatic
    TableName = 'wurflProperties'
    Left = 190
    Top = 77
    object tbPropertiesCodPro: TAutoIncField
      FieldName = 'CodPro'
      ReadOnly = True
    end
    object tbPropertiesCodGrp: TIntegerField
      FieldName = 'CodGrp'
    end
    object tbPropertiesName: TWideStringField
      FieldName = 'Name'
      Size = 50
    end
  end
  object tbDefinition: TADOTable
    Connection = DBDevice
    CursorType = ctStatic
    TableName = 'wurflDefinition'
    Left = 273
    Top = 77
    object tbDefinitionCodDev: TIntegerField
      FieldName = 'CodDev'
    end
    object tbDefinitionCodPro: TIntegerField
      FieldName = 'CodPro'
    end
    object tbDefinitionValue: TWideStringField
      FieldName = 'Value'
      Size = 50
    end
  end
end
