object dmWURFL2DB: TdmWURFL2DB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object DBDevice: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=G:\develop\shared\d' +
      'elphi\ServerApps\tools\EPSTool\bin\wurfl\db\wurfl.mdb;Persist Se' +
      'curity Info=False'
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
    Left = 51
    Top = 5
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
    Left = 91
    Top = 5
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
    Left = 126
    Top = 5
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
    Left = 161
    Top = 5
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
