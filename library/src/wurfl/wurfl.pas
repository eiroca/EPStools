{ ********************************************************* }
{ }
{ XML Data Binding }
{ }
{ Generated on: 03/02/2019 14:30:48 }
{ Generated from: S:\data\dataset\wurfl\wurfl.xml }
{ Settings stored in: S:\data\dataset\wurfl\wurfl.xdb }
{ }
{ ********************************************************* }

unit wurfl;

interface

uses
  Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

  { Forward Decls }

  IXMLWurflType = interface;
  IXMLVersionType = interface;
  IXMLMaintainersType = interface;
  IXMLMaintainerType = interface;
  IXMLAuthorsType = interface;
  IXMLAuthorType = interface;
  IXMLDevicesType = interface;
  IXMLDeviceType = interface;
  IXMLGroupType = interface;
  IXMLCapabilityType = interface;
  IXMLDeviceType2 = interface;

  { IXMLWurflType }

  IXMLWurflType = interface(IXMLNode)
    ['{647D1953-C420-4775-B316-58ABE5380B4D}']
    { Property Accessors }
    function Get_Version: IXMLVersionType;
    function Get_Devices: IXMLDevicesType;
    { Methods & Properties }
    property Version: IXMLVersionType read Get_Version;
    property Devices: IXMLDevicesType read Get_Devices;
  end;

  { IXMLVersionType }

  IXMLVersionType = interface(IXMLNode)
    ['{45EA3C3D-E9CA-4746-ABB0-C6DE2A1E1CDE}']
    { Property Accessors }
    function Get_Ver: UnicodeString;
    function Get_Last_updated: UnicodeString;
    function Get_Official_url: UnicodeString;
    function Get_Maintainers: IXMLMaintainersType;
    function Get_Authors: IXMLAuthorsType;
    function Get_Statement: UnicodeString;
    procedure Set_Ver(Value: UnicodeString);
    procedure Set_Last_updated(Value: UnicodeString);
    procedure Set_Official_url(Value: UnicodeString);
    procedure Set_Statement(Value: UnicodeString);
    { Methods & Properties }
    property Ver: UnicodeString read Get_Ver write Set_Ver;
    property Last_updated: UnicodeString read Get_Last_updated write Set_Last_updated;
    property Official_url: UnicodeString read Get_Official_url write Set_Official_url;
    property Maintainers: IXMLMaintainersType read Get_Maintainers;
    property Authors: IXMLAuthorsType read Get_Authors;
    property Statement: UnicodeString read Get_Statement write Set_Statement;
  end;

  { IXMLMaintainersType }

  IXMLMaintainersType = interface(IXMLNode)
    ['{784A3BC0-900D-4E08-97A7-1A8BDF742EBE}']
    { Property Accessors }
    function Get_Maintainer: IXMLMaintainerType;
    { Methods & Properties }
    property Maintainer: IXMLMaintainerType read Get_Maintainer;
  end;

  { IXMLMaintainerType }

  IXMLMaintainerType = interface(IXMLNode)
    ['{E597D426-70EB-41C0-B645-05DEA7C06A4F}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Email: UnicodeString;
    function Get_Home_page: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Email(Value: UnicodeString);
    procedure Set_Home_page(Value: UnicodeString);
    { Methods & Properties }
    property name: UnicodeString read Get_Name write Set_Name;
    property Email: UnicodeString read Get_Email write Set_Email;
    property Home_page: UnicodeString read Get_Home_page write Set_Home_page;
  end;

  { IXMLAuthorsType }

  IXMLAuthorsType = interface(IXMLNode)
    ['{A81A23CD-3089-4664-81DD-FDE88DE6A50F}']
    { Property Accessors }
    function Get_Author: IXMLAuthorType;
    { Methods & Properties }
    property Author: IXMLAuthorType read Get_Author;
  end;

  { IXMLAuthorType }

  IXMLAuthorType = interface(IXMLNode)
    ['{D56B551B-FB85-48FD-9D7C-9646A644AF9C}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Email: UnicodeString;
    function Get_Home_page: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Email(Value: UnicodeString);
    procedure Set_Home_page(Value: UnicodeString);
    { Methods & Properties }
    property name: UnicodeString read Get_Name write Set_Name;
    property Email: UnicodeString read Get_Email write Set_Email;
    property Home_page: UnicodeString read Get_Home_page write Set_Home_page;
  end;

  { IXMLDevicesType }

  IXMLDevicesType = interface(IXMLNodeCollection)
    ['{EA44C6D2-5AEE-4F66-AE5B-A5C6FC434363}']
    { Property Accessors }
    function Get_Device(Index: Integer): IXMLDeviceType;
    { Methods & Properties }
    function Add: IXMLDeviceType;
    function Insert(const Index: Integer): IXMLDeviceType;
    property Device[index: Integer]: IXMLDeviceType read Get_Device; default;
  end;

  { IXMLDeviceType }

  IXMLDeviceType = interface(IXMLNodeCollection)
    ['{1D9B5224-6B65-482E-A06D-AB1BA2E02664}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_User_agent: UnicodeString;
    function Get_Fall_back: UnicodeString;
    function Get_Actual_device_root: UnicodeString;
    function Get_Group(Index: Integer): IXMLGroupType;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_User_agent(Value: UnicodeString);
    procedure Set_Fall_back(Value: UnicodeString);
    procedure Set_Actual_device_root(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;
    property Id: UnicodeString read Get_Id write Set_Id;
    property User_agent: UnicodeString read Get_User_agent write Set_User_agent;
    property Fall_back: UnicodeString read Get_Fall_back write Set_Fall_back;
    property Actual_device_root: UnicodeString read Get_Actual_device_root
      write Set_Actual_device_root;
    property Group[index: Integer]: IXMLGroupType read Get_Group; default;
  end;

  { IXMLGroupType }

  IXMLGroupType = interface(IXMLNodeCollection)
    ['{E34521BC-9B52-4E7C-BC4B-18D017EF4659}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_Capability(Index: Integer): IXMLCapabilityType;
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    function Add: IXMLCapabilityType;
    function Insert(const Index: Integer): IXMLCapabilityType;
    property Id: UnicodeString read Get_Id write Set_Id;
    property Capability[index: Integer]: IXMLCapabilityType read Get_Capability; default;
  end;

  { IXMLCapabilityType }

  IXMLCapabilityType = interface(IXMLNode)
    ['{6303A6ED-2C04-4FAC-AC40-674C357B0C4C}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
    { Methods & Properties }
    property name: UnicodeString read Get_Name write Set_Name;
    property Value: UnicodeString read Get_Value write Set_Value;
  end;

  { IXMLDeviceType2 }

  IXMLDeviceType2 = interface(IXMLNode)
    ['{BA92D92E-C731-4D2E-A2CB-85EA1ABDB49A}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_User_agent: UnicodeString;
    function Get_Fall_back: UnicodeString;
    function Get_Actual_device_root: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_User_agent(Value: UnicodeString);
    procedure Set_Fall_back(Value: UnicodeString);
    procedure Set_Actual_device_root(Value: UnicodeString);
    { Methods & Properties }
    property Id: UnicodeString read Get_Id write Set_Id;
    property User_agent: UnicodeString read Get_User_agent write Set_User_agent;
    property Fall_back: UnicodeString read Get_Fall_back write Set_Fall_back;
    property Actual_device_root: UnicodeString read Get_Actual_device_root
      write Set_Actual_device_root;
  end;

  { Forward Decls }

  TXMLWurflType = class;
  TXMLVersionType = class;
  TXMLMaintainersType = class;
  TXMLMaintainerType = class;
  TXMLAuthorsType = class;
  TXMLAuthorType = class;
  TXMLDevicesType = class;
  TXMLDeviceType = class;
  TXMLGroupType = class;
  TXMLCapabilityType = class;
  TXMLDeviceType2 = class;

  { TXMLWurflType }

  TXMLWurflType = class(TXMLNode, IXMLWurflType)
  protected
    { IXMLWurflType }
    function Get_Version: IXMLVersionType;
    function Get_Devices: IXMLDevicesType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLVersionType }

  TXMLVersionType = class(TXMLNode, IXMLVersionType)
  protected
    { IXMLVersionType }
    function Get_Ver: UnicodeString;
    function Get_Last_updated: UnicodeString;
    function Get_Official_url: UnicodeString;
    function Get_Maintainers: IXMLMaintainersType;
    function Get_Authors: IXMLAuthorsType;
    function Get_Statement: UnicodeString;
    procedure Set_Ver(Value: UnicodeString);
    procedure Set_Last_updated(Value: UnicodeString);
    procedure Set_Official_url(Value: UnicodeString);
    procedure Set_Statement(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

  { TXMLMaintainersType }

  TXMLMaintainersType = class(TXMLNode, IXMLMaintainersType)
  protected
    { IXMLMaintainersType }
    function Get_Maintainer: IXMLMaintainerType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLMaintainerType }

  TXMLMaintainerType = class(TXMLNode, IXMLMaintainerType)
  protected
    { IXMLMaintainerType }
    function Get_Name: UnicodeString;
    function Get_Email: UnicodeString;
    function Get_Home_page: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Email(Value: UnicodeString);
    procedure Set_Home_page(Value: UnicodeString);
  end;

  { TXMLAuthorsType }

  TXMLAuthorsType = class(TXMLNode, IXMLAuthorsType)
  protected
    { IXMLAuthorsType }
    function Get_Author: IXMLAuthorType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLAuthorType }

  TXMLAuthorType = class(TXMLNode, IXMLAuthorType)
  protected
    { IXMLAuthorType }
    function Get_Name: UnicodeString;
    function Get_Email: UnicodeString;
    function Get_Home_page: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Email(Value: UnicodeString);
    procedure Set_Home_page(Value: UnicodeString);
  end;

  { TXMLDevicesType }

  TXMLDevicesType = class(TXMLNodeCollection, IXMLDevicesType)
  protected
    { IXMLDevicesType }
    function Get_Device(Index: Integer): IXMLDeviceType;
    function Add: IXMLDeviceType;
    function Insert(const Index: Integer): IXMLDeviceType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLDeviceType }

  TXMLDeviceType = class(TXMLNodeCollection, IXMLDeviceType)
  protected
    { IXMLDeviceType }
    function Get_Id: UnicodeString;
    function Get_User_agent: UnicodeString;
    function Get_Fall_back: UnicodeString;
    function Get_Actual_device_root: UnicodeString;
    function Get_Group(Index: Integer): IXMLGroupType;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_User_agent(Value: UnicodeString);
    procedure Set_Fall_back(Value: UnicodeString);
    procedure Set_Actual_device_root(Value: UnicodeString);
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLGroupType }

  TXMLGroupType = class(TXMLNodeCollection, IXMLGroupType)
  protected
    { IXMLGroupType }
    function Get_Id: UnicodeString;
    function Get_Capability(Index: Integer): IXMLCapabilityType;
    procedure Set_Id(Value: UnicodeString);
    function Add: IXMLCapabilityType;
    function Insert(const Index: Integer): IXMLCapabilityType;
  public
    procedure AfterConstruction; override;
  end;

  { TXMLCapabilityType }

  TXMLCapabilityType = class(TXMLNode, IXMLCapabilityType)
  protected
    { IXMLCapabilityType }
    function Get_Name: UnicodeString;
    function Get_Value: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Value(Value: UnicodeString);
  end;

  { TXMLDeviceType2 }

  TXMLDeviceType2 = class(TXMLNode, IXMLDeviceType2)
  protected
    { IXMLDeviceType2 }
    function Get_Id: UnicodeString;
    function Get_User_agent: UnicodeString;
    function Get_Fall_back: UnicodeString;
    function Get_Actual_device_root: UnicodeString;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_User_agent(Value: UnicodeString);
    procedure Set_Fall_back(Value: UnicodeString);
    procedure Set_Actual_device_root(Value: UnicodeString);
  end;

  { Global Functions }

function GetWURFL(Doc: IXMLDocument): IXMLWurflType;
function LoadWURFL(const FileName: string): IXMLWurflType;
function NewWURFL: IXMLWurflType;

const
  TargetNamespace = '';

implementation

uses
  Xml.xmlutil;

{ Global Functions }

function GetWURFL(Doc: IXMLDocument): IXMLWurflType;
begin
  Result:= Doc.GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
end;

function LoadWURFL(const FileName: string): IXMLWurflType;
begin
  Result:= LoadXMLDocument(FileName).GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
end;

function NewWURFL: IXMLWurflType;
begin
  Result:= NewXMLDocument.GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
end;

{ TXMLWurflType }

procedure TXMLWurflType.AfterConstruction;
begin
  RegisterChildNode('version', TXMLVersionType);
  RegisterChildNode('devices', TXMLDevicesType);
  inherited;
end;

function TXMLWurflType.Get_Version: IXMLVersionType;
begin
  Result:= ChildNodes['version'] as IXMLVersionType;
end;

function TXMLWurflType.Get_Devices: IXMLDevicesType;
begin
  Result:= ChildNodes['devices'] as IXMLDevicesType;
end;

{ TXMLVersionType }

procedure TXMLVersionType.AfterConstruction;
begin
  RegisterChildNode('maintainers', TXMLMaintainersType);
  RegisterChildNode('authors', TXMLAuthorsType);
  inherited;
end;

function TXMLVersionType.Get_Ver: UnicodeString;
begin
  Result:= ChildNodes['ver'].Text;
end;

procedure TXMLVersionType.Set_Ver(Value: UnicodeString);
begin
  ChildNodes['ver'].NodeValue:= Value;
end;

function TXMLVersionType.Get_Last_updated: UnicodeString;
begin
  Result:= ChildNodes['last_updated'].Text;
end;

procedure TXMLVersionType.Set_Last_updated(Value: UnicodeString);
begin
  ChildNodes['last_updated'].NodeValue:= Value;
end;

function TXMLVersionType.Get_Official_url: UnicodeString;
begin
  Result:= ChildNodes['official_url'].Text;
end;

procedure TXMLVersionType.Set_Official_url(Value: UnicodeString);
begin
  ChildNodes['official_url'].NodeValue:= Value;
end;

function TXMLVersionType.Get_Maintainers: IXMLMaintainersType;
begin
  Result:= ChildNodes['maintainers'] as IXMLMaintainersType;
end;

function TXMLVersionType.Get_Authors: IXMLAuthorsType;
begin
  Result:= ChildNodes['authors'] as IXMLAuthorsType;
end;

function TXMLVersionType.Get_Statement: UnicodeString;
begin
  Result:= ChildNodes['statement'].Text;
end;

procedure TXMLVersionType.Set_Statement(Value: UnicodeString);
begin
  ChildNodes['statement'].NodeValue:= Value;
end;

{ TXMLMaintainersType }

procedure TXMLMaintainersType.AfterConstruction;
begin
  RegisterChildNode('maintainer', TXMLMaintainerType);
  inherited;
end;

function TXMLMaintainersType.Get_Maintainer: IXMLMaintainerType;
begin
  Result:= ChildNodes['maintainer'] as IXMLMaintainerType;
end;

{ TXMLMaintainerType }

function TXMLMaintainerType.Get_Name: UnicodeString;
begin
  Result:= AttributeNodes['name'].Text;
end;

procedure TXMLMaintainerType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLMaintainerType.Get_Email: UnicodeString;
begin
  Result:= AttributeNodes['email'].Text;
end;

procedure TXMLMaintainerType.Set_Email(Value: UnicodeString);
begin
  SetAttribute('email', Value);
end;

function TXMLMaintainerType.Get_Home_page: UnicodeString;
begin
  Result:= AttributeNodes['home_page'].Text;
end;

procedure TXMLMaintainerType.Set_Home_page(Value: UnicodeString);
begin
  SetAttribute('home_page', Value);
end;

{ TXMLAuthorsType }

procedure TXMLAuthorsType.AfterConstruction;
begin
  RegisterChildNode('author', TXMLAuthorType);
  inherited;
end;

function TXMLAuthorsType.Get_Author: IXMLAuthorType;
begin
  Result:= ChildNodes['author'] as IXMLAuthorType;
end;

{ TXMLAuthorType }

function TXMLAuthorType.Get_Name: UnicodeString;
begin
  Result:= AttributeNodes['name'].Text;
end;

procedure TXMLAuthorType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLAuthorType.Get_Email: UnicodeString;
begin
  Result:= AttributeNodes['email'].Text;
end;

procedure TXMLAuthorType.Set_Email(Value: UnicodeString);
begin
  SetAttribute('email', Value);
end;

function TXMLAuthorType.Get_Home_page: UnicodeString;
begin
  Result:= AttributeNodes['home_page'].Text;
end;

procedure TXMLAuthorType.Set_Home_page(Value: UnicodeString);
begin
  SetAttribute('home_page', Value);
end;

{ TXMLDevicesType }

procedure TXMLDevicesType.AfterConstruction;
begin
  RegisterChildNode('device', TXMLDeviceType);
  ItemTag:= 'device';
  ItemInterface:= IXMLDeviceType;
  inherited;
end;

function TXMLDevicesType.Get_Device(Index: Integer): IXMLDeviceType;
begin
  Result:= List[index] as IXMLDeviceType;
end;

function TXMLDevicesType.Add: IXMLDeviceType;
begin
  Result:= AddItem(-1) as IXMLDeviceType;
end;

function TXMLDevicesType.Insert(const Index: Integer): IXMLDeviceType;
begin
  Result:= AddItem(index) as IXMLDeviceType;
end;

{ TXMLDeviceType }

procedure TXMLDeviceType.AfterConstruction;
begin
  RegisterChildNode('group', TXMLGroupType);
  ItemTag:= 'group';
  ItemInterface:= IXMLGroupType;
  inherited;
end;

function TXMLDeviceType.Get_Id: UnicodeString;
begin
  Result:= AttributeNodes['id'].Text;
end;

procedure TXMLDeviceType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLDeviceType.Get_User_agent: UnicodeString;
begin
  Result:= AttributeNodes['user_agent'].Text;
end;

procedure TXMLDeviceType.Set_User_agent(Value: UnicodeString);
begin
  SetAttribute('user_agent', Value);
end;

function TXMLDeviceType.Get_Fall_back: UnicodeString;
begin
  Result:= AttributeNodes['fall_back'].Text;
end;

procedure TXMLDeviceType.Set_Fall_back(Value: UnicodeString);
begin
  SetAttribute('fall_back', Value);
end;

function TXMLDeviceType.Get_Actual_device_root: UnicodeString;
begin
  Result:= AttributeNodes['actual_device_root'].Text;
end;

procedure TXMLDeviceType.Set_Actual_device_root(Value: UnicodeString);
begin
  SetAttribute('actual_device_root', Value);
end;

function TXMLDeviceType.Get_Group(Index: Integer): IXMLGroupType;
begin
  Result:= List[index] as IXMLGroupType;
end;

function TXMLDeviceType.Add: IXMLGroupType;
begin
  Result:= AddItem(-1) as IXMLGroupType;
end;

function TXMLDeviceType.Insert(const Index: Integer): IXMLGroupType;
begin
  Result:= AddItem(index) as IXMLGroupType;
end;

{ TXMLGroupType }

procedure TXMLGroupType.AfterConstruction;
begin
  RegisterChildNode('capability', TXMLCapabilityType);
  ItemTag:= 'capability';
  ItemInterface:= IXMLCapabilityType;
  inherited;
end;

function TXMLGroupType.Get_Id: UnicodeString;
begin
  Result:= AttributeNodes['id'].Text;
end;

procedure TXMLGroupType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLGroupType.Get_Capability(Index: Integer): IXMLCapabilityType;
begin
  Result:= List[index] as IXMLCapabilityType;
end;

function TXMLGroupType.Add: IXMLCapabilityType;
begin
  Result:= AddItem(-1) as IXMLCapabilityType;
end;

function TXMLGroupType.Insert(const Index: Integer): IXMLCapabilityType;
begin
  Result:= AddItem(index) as IXMLCapabilityType;
end;

{ TXMLCapabilityType }

function TXMLCapabilityType.Get_Name: UnicodeString;
begin
  Result:= AttributeNodes['name'].Text;
end;

procedure TXMLCapabilityType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLCapabilityType.Get_Value: UnicodeString;
begin
  Result:= AttributeNodes['value'].Text;
end;

procedure TXMLCapabilityType.Set_Value(Value: UnicodeString);
begin
  SetAttribute('value', Value);
end;

{ TXMLDeviceType2 }

function TXMLDeviceType2.Get_Id: UnicodeString;
begin
  Result:= AttributeNodes['id'].Text;
end;

procedure TXMLDeviceType2.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLDeviceType2.Get_User_agent: UnicodeString;
begin
  Result:= AttributeNodes['user_agent'].Text;
end;

procedure TXMLDeviceType2.Set_User_agent(Value: UnicodeString);
begin
  SetAttribute('user_agent', Value);
end;

function TXMLDeviceType2.Get_Fall_back: UnicodeString;
begin
  Result:= AttributeNodes['fall_back'].Text;
end;

procedure TXMLDeviceType2.Set_Fall_back(Value: UnicodeString);
begin
  SetAttribute('fall_back', Value);
end;

function TXMLDeviceType2.Get_Actual_device_root: UnicodeString;
begin
  Result:= AttributeNodes['actual_device_root'].Text;
end;

procedure TXMLDeviceType2.Set_Actual_device_root(Value: UnicodeString);
begin
  SetAttribute('actual_device_root', Value);
end;

end.
