{***************************************************************************}
{                                                                           }
{                             XML Data Binding                              }
{                                                                           }
{         Generated on: 24/11/2003 13.39.50                                 }
{                                                                           }
{***************************************************************************}

unit wurfl;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLWurflType = interface;
  IXMLVersionType = interface;
  IXMLMaintainersType = interface;
  IXMLMaintainerType = interface;
  IXMLAuthorsType = interface;
  IXMLAuthorType = interface;
  IXMLContributorsType = interface;
  IXMLContributorType = interface;
  IXMLDevicesType = interface;
  IXMLDeviceType = interface;
  IXMLGroupType = interface;
  IXMLCapabilityType = interface;

{ IXMLWurflType }

  IXMLWurflType = interface(IXMLNode)
    ['{BFA2CA7A-CF62-4D84-9F2D-B820BC2E6C16}']
    { Property Accessors }
    function Get_Version: IXMLVersionType;
    function Get_Devices: IXMLDevicesType;
    { Methods & Properties }
    property Version: IXMLVersionType read Get_Version;
    property Devices: IXMLDevicesType read Get_Devices;
  end;

{ IXMLVersionType }

  IXMLVersionType = interface(IXMLNode)
    ['{E8288F10-7C36-43B4-8186-BAFA3A6A56AD}']
    { Property Accessors }
    function Get_Ver: WideString;
    function Get_Last_updated: WideString;
    function Get_Official_url: WideString;
    function Get_Maintainers: IXMLMaintainersType;
    function Get_Authors: IXMLAuthorsType;
    function Get_Contributors: IXMLContributorsType;
    function Get_Statement: WideString;
    procedure Set_Ver(Value: WideString);
    procedure Set_Last_updated(Value: WideString);
    procedure Set_Official_url(Value: WideString);
    procedure Set_Statement(Value: WideString);
    { Methods & Properties }
    property Ver: WideString read Get_Ver write Set_Ver;
    property Last_updated: WideString read Get_Last_updated write Set_Last_updated;
    property Official_url: WideString read Get_Official_url write Set_Official_url;
    property Maintainers: IXMLMaintainersType read Get_Maintainers;
    property Authors: IXMLAuthorsType read Get_Authors;
    property Contributors: IXMLContributorsType read Get_Contributors;
    property Statement: WideString read Get_Statement write Set_Statement;
  end;

{ IXMLMaintainersType }

  IXMLMaintainersType = interface(IXMLNode)
    ['{7144E889-84A5-4610-9568-35C8F62948EB}']
    { Property Accessors }
    function Get_Maintainer: IXMLMaintainerType;
    { Methods & Properties }
    property Maintainer: IXMLMaintainerType read Get_Maintainer;
  end;

{ IXMLMaintainerType }

  IXMLMaintainerType = interface(IXMLNode)
    ['{9B323DCE-DBC3-4FB3-B084-962FD205756B}']
    { Property Accessors }
    function Get_Email: WideString;
    function Get_Home_page: WideString;
    function Get_Name: WideString;
    procedure Set_Email(Value: WideString);
    procedure Set_Home_page(Value: WideString);
    procedure Set_Name(Value: WideString);
    { Methods & Properties }
    property Email: WideString read Get_Email write Set_Email;
    property Home_page: WideString read Get_Home_page write Set_Home_page;
    property Name: WideString read Get_Name write Set_Name;
  end;

{ IXMLAuthorsType }

  IXMLAuthorsType = interface(IXMLNodeCollection)
    ['{ED7DDCC0-9504-48E8-8A89-7DBDD6F1D55E}']
    { Property Accessors }
    function Get_Author(Index: Integer): IXMLAuthorType;
    { Methods & Properties }
    function Add: IXMLAuthorType;
    function Insert(const Index: Integer): IXMLAuthorType;
    property Author[Index: Integer]: IXMLAuthorType read Get_Author; default;
  end;

{ IXMLAuthorType }

  IXMLAuthorType = interface(IXMLNode)
    ['{320F7E1F-1AA3-4AC3-92B5-2CE68E4E4787}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Email: WideString;
    function Get_Home_page: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Email(Value: WideString);
    procedure Set_Home_page(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Email: WideString read Get_Email write Set_Email;
    property Home_page: WideString read Get_Home_page write Set_Home_page;
  end;

{ IXMLContributorsType }

  IXMLContributorsType = interface(IXMLNodeCollection)
    ['{64D3B7E4-1E3F-4ACF-B4C0-0F1EA83EB5F8}']
    { Property Accessors }
    function Get_Contributor(Index: Integer): IXMLContributorType;
    { Methods & Properties }
    function Add: IXMLContributorType;
    function Insert(const Index: Integer): IXMLContributorType;
    property Contributor[Index: Integer]: IXMLContributorType read Get_Contributor; default;
  end;

{ IXMLContributorType }

  IXMLContributorType = interface(IXMLNode)
    ['{108B724E-EEB2-43F4-A4F1-9EC1300EBE05}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Email: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Email(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Email: WideString read Get_Email write Set_Email;
  end;

{ IXMLDevicesType }

  IXMLDevicesType = interface(IXMLNodeCollection)
    ['{9D679B00-2BC1-4564-9D18-0C15D85567DD}']
    { Property Accessors }
    function Get_Device(Index: Integer): IXMLDeviceType;
    { Methods & Properties }
    function Add: IXMLDeviceType;
    function Insert(const Index: Integer): IXMLDeviceType;
    property Device[Index: Integer]: IXMLDeviceType read Get_Device; default;
  end;

{ IXMLDeviceType }

  IXMLDeviceType = interface(IXMLNodeCollection)
    ['{30ADB7FD-EBC8-4578-AFF7-80C74F2A47C6}']
    { Property Accessors }
    function Get_Id: WideString;
    function Get_Fall_back: WideString;
    function Get_User_agent: WideString;
    function Get_Group(Index: Integer): IXMLGroupType;
    procedure Set_Id(Value: WideString);
    procedure Set_Fall_back(Value: WideString);
    procedure Set_User_agent(Value: WideString);
    function Get_Actual_device_root: WideString;
    procedure Set_Actual_device_root(Value: WideString);
    { Methods & Properties }
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;
    property Id: WideString read Get_Id write Set_Id;
    property Fall_back: WideString read Get_Fall_back write Set_Fall_back;
    property User_agent: WideString read Get_User_agent write Set_User_agent;
    property Actual_device_root: WideString read Get_Actual_device_root write Set_Actual_device_root;

    property Group[Index: Integer]: IXMLGroupType read Get_Group; default;
  end;

{ IXMLGroupType }

  IXMLGroupType = interface(IXMLNodeCollection)
    ['{E8CA3F35-8865-409B-B801-EF499C745006}']
    { Property Accessors }
    function Get_Id: WideString;
    function Get_Capability(Index: Integer): IXMLCapabilityType;
    procedure Set_Id(Value: WideString);
    { Methods & Properties }
    function Add: IXMLCapabilityType;
    function Insert(const Index: Integer): IXMLCapabilityType;
    property Id: WideString read Get_Id write Set_Id;
    property Capability[Index: Integer]: IXMLCapabilityType read Get_Capability; default;
  end;

{ IXMLCapabilityType }

  IXMLCapabilityType = interface(IXMLNode)
    ['{54F23BF1-5570-42E1-B46D-6F63847E8D0C}']
    { Property Accessors }
    function Get_Name: WideString;
    function Get_Value: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Value(Value: WideString);
    { Methods & Properties }
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  end;

{ Forward Decls }

  TXMLWurflType = class;
  TXMLVersionType = class;
  TXMLMaintainersType = class;
  TXMLMaintainerType = class;
  TXMLAuthorsType = class;
  TXMLAuthorType = class;
  TXMLContributorsType = class;
  TXMLContributorType = class;
  TXMLDevicesType = class;
  TXMLDeviceType = class;
  TXMLGroupType = class;
  TXMLCapabilityType = class;

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
    function Get_Ver: WideString;
    function Get_Last_updated: WideString;
    function Get_Official_url: WideString;
    function Get_Maintainers: IXMLMaintainersType;
    function Get_Authors: IXMLAuthorsType;
    function Get_Contributors: IXMLContributorsType;
    function Get_Statement: WideString;
    procedure Set_Ver(Value: WideString);
    procedure Set_Last_updated(Value: WideString);
    procedure Set_Official_url(Value: WideString);
    procedure Set_Statement(Value: WideString);
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
    function Get_Email: WideString;
    function Get_Home_page: WideString;
    function Get_Name: WideString;
    procedure Set_Email(Value: WideString);
    procedure Set_Home_page(Value: WideString);
    procedure Set_Name(Value: WideString);
  end;

{ TXMLAuthorsType }

  TXMLAuthorsType = class(TXMLNodeCollection, IXMLAuthorsType)
  protected
    { IXMLAuthorsType }
    function Get_Author(Index: Integer): IXMLAuthorType;
    function Add: IXMLAuthorType;
    function Insert(const Index: Integer): IXMLAuthorType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAuthorType }

  TXMLAuthorType = class(TXMLNode, IXMLAuthorType)
  protected
    { IXMLAuthorType }
    function Get_Name: WideString;
    function Get_Email: WideString;
    function Get_Home_page: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Email(Value: WideString);
    procedure Set_Home_page(Value: WideString);
  end;

{ TXMLContributorsType }

  TXMLContributorsType = class(TXMLNodeCollection, IXMLContributorsType)
  protected
    { IXMLContributorsType }
    function Get_Contributor(Index: Integer): IXMLContributorType;
    function Add: IXMLContributorType;
    function Insert(const Index: Integer): IXMLContributorType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLContributorType }

  TXMLContributorType = class(TXMLNode, IXMLContributorType)
  protected
    { IXMLContributorType }
    function Get_Name: WideString;
    function Get_Email: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Email(Value: WideString);
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
    function Get_Id: WideString;
    function Get_Fall_back: WideString;
    function Get_User_agent: WideString;
    function Get_Group(Index: Integer): IXMLGroupType;
    procedure Set_Id(Value: WideString);
    procedure Set_Fall_back(Value: WideString);
    procedure Set_User_agent(Value: WideString);
    function Get_Actual_device_root: WideString;
    procedure Set_Actual_device_root(Value: WideString);
    function Add: IXMLGroupType;
    function Insert(const Index: Integer): IXMLGroupType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGroupType }

  TXMLGroupType = class(TXMLNodeCollection, IXMLGroupType)
  protected
    { IXMLGroupType }
    function Get_Id: WideString;
    function Get_Capability(Index: Integer): IXMLCapabilityType;
    procedure Set_Id(Value: WideString);
    function Add: IXMLCapabilityType;
    function Insert(const Index: Integer): IXMLCapabilityType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCapabilityType }

  TXMLCapabilityType = class(TXMLNode, IXMLCapabilityType)
  protected
    { IXMLCapabilityType }
    function Get_Name: WideString;
    function Get_Value: WideString;
    procedure Set_Name(Value: WideString);
    procedure Set_Value(Value: WideString);
  end;

{ Global Functions }

function Getwurfl(Doc: IXMLDocument): IXMLWurflType;
function Loadwurfl(const FileName: WideString): IXMLWurflType;
function Newwurfl: IXMLWurflType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function Getwurfl(Doc: IXMLDocument): IXMLWurflType;
begin
  Result := Doc.GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
end;

function Loadwurfl(const FileName: WideString): IXMLWurflType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
end;

function Newwurfl: IXMLWurflType;
begin
  Result := NewXMLDocument.GetDocBinding('wurfl', TXMLWurflType, TargetNamespace) as IXMLWurflType;
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
  Result := ChildNodes['version'] as IXMLVersionType;
end;

function TXMLWurflType.Get_Devices: IXMLDevicesType;
begin
  Result := ChildNodes['devices'] as IXMLDevicesType;
end;

{ TXMLVersionType }

procedure TXMLVersionType.AfterConstruction;
begin
  RegisterChildNode('maintainers', TXMLMaintainersType);
  RegisterChildNode('authors', TXMLAuthorsType);
  RegisterChildNode('contributors', TXMLContributorsType);
  inherited;
end;

function TXMLVersionType.Get_Ver: WideString;
begin
  Result := ChildNodes['ver'].Text;
end;

procedure TXMLVersionType.Set_Ver(Value: WideString);
begin
  ChildNodes['ver'].NodeValue := Value;
end;

function TXMLVersionType.Get_Last_updated: WideString;
begin
  Result := ChildNodes['last_updated'].Text;
end;

procedure TXMLVersionType.Set_Last_updated(Value: WideString);
begin
  ChildNodes['last_updated'].NodeValue := Value;
end;

function TXMLVersionType.Get_Official_url: WideString;
begin
  Result := ChildNodes['official_url'].Text;
end;

procedure TXMLVersionType.Set_Official_url(Value: WideString);
begin
  ChildNodes['official_url'].NodeValue := Value;
end;

function TXMLVersionType.Get_Maintainers: IXMLMaintainersType;
begin
  Result := ChildNodes['maintainers'] as IXMLMaintainersType;
end;

function TXMLVersionType.Get_Authors: IXMLAuthorsType;
begin
  Result := ChildNodes['authors'] as IXMLAuthorsType;
end;

function TXMLVersionType.Get_Contributors: IXMLContributorsType;
begin
  Result := ChildNodes['contributors'] as IXMLContributorsType;
end;

function TXMLVersionType.Get_Statement: WideString;
begin
  Result := ChildNodes['statement'].Text;
end;

procedure TXMLVersionType.Set_Statement(Value: WideString);
begin
  ChildNodes['statement'].NodeValue := Value;
end;

{ TXMLMaintainersType }

procedure TXMLMaintainersType.AfterConstruction;
begin
  RegisterChildNode('maintainer', TXMLMaintainerType);
  inherited;
end;

function TXMLMaintainersType.Get_Maintainer: IXMLMaintainerType;
begin
  Result := ChildNodes['maintainer'] as IXMLMaintainerType;
end;

{ TXMLMaintainerType }

function TXMLMaintainerType.Get_Email: WideString;
begin
  Result := AttributeNodes['email'].Text;
end;

procedure TXMLMaintainerType.Set_Email(Value: WideString);
begin
  SetAttribute('email', Value);
end;

function TXMLMaintainerType.Get_Home_page: WideString;
begin
  Result := AttributeNodes['home_page'].Text;
end;

procedure TXMLMaintainerType.Set_Home_page(Value: WideString);
begin
  SetAttribute('home_page', Value);
end;

function TXMLMaintainerType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLMaintainerType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

{ TXMLAuthorsType }

procedure TXMLAuthorsType.AfterConstruction;
begin
  RegisterChildNode('author', TXMLAuthorType);
  ItemTag := 'author';
  ItemInterface := IXMLAuthorType;
  inherited;
end;

function TXMLAuthorsType.Get_Author(Index: Integer): IXMLAuthorType;
begin
  Result := List[Index] as IXMLAuthorType;
end;

function TXMLAuthorsType.Add: IXMLAuthorType;
begin
  Result := AddItem(-1) as IXMLAuthorType;
end;

function TXMLAuthorsType.Insert(const Index: Integer): IXMLAuthorType;
begin
  Result := AddItem(Index) as IXMLAuthorType;
end;

{ TXMLAuthorType }

function TXMLAuthorType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLAuthorType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLAuthorType.Get_Email: WideString;
begin
  Result := AttributeNodes['email'].Text;
end;

procedure TXMLAuthorType.Set_Email(Value: WideString);
begin
  SetAttribute('email', Value);
end;

function TXMLAuthorType.Get_Home_page: WideString;
begin
  Result := AttributeNodes['home_page'].Text;
end;

procedure TXMLAuthorType.Set_Home_page(Value: WideString);
begin
  SetAttribute('home_page', Value);
end;

{ TXMLContributorsType }

procedure TXMLContributorsType.AfterConstruction;
begin
  RegisterChildNode('contributor', TXMLContributorType);
  ItemTag := 'contributor';
  ItemInterface := IXMLContributorType;
  inherited;
end;

function TXMLContributorsType.Get_Contributor(Index: Integer): IXMLContributorType;
begin
  Result := List[Index] as IXMLContributorType;
end;

function TXMLContributorsType.Add: IXMLContributorType;
begin
  Result := AddItem(-1) as IXMLContributorType;
end;

function TXMLContributorsType.Insert(const Index: Integer): IXMLContributorType;
begin
  Result := AddItem(Index) as IXMLContributorType;
end;

{ TXMLContributorType }

function TXMLContributorType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLContributorType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLContributorType.Get_Email: WideString;
begin
  Result := AttributeNodes['email'].Text;
end;

procedure TXMLContributorType.Set_Email(Value: WideString);
begin
  SetAttribute('email', Value);
end;

{ TXMLDevicesType }

procedure TXMLDevicesType.AfterConstruction;
begin
  RegisterChildNode('device', TXMLDeviceType);
  ItemTag := 'device';
  ItemInterface := IXMLDeviceType;
  inherited;
end;

function TXMLDevicesType.Get_Device(Index: Integer): IXMLDeviceType;
begin
  Result := List[Index] as IXMLDeviceType;
end;

function TXMLDevicesType.Add: IXMLDeviceType;
begin
  Result := AddItem(-1) as IXMLDeviceType;
end;

function TXMLDevicesType.Insert(const Index: Integer): IXMLDeviceType;
begin
  Result := AddItem(Index) as IXMLDeviceType;
end;

{ TXMLDeviceType }

procedure TXMLDeviceType.AfterConstruction;
begin
  RegisterChildNode('group', TXMLGroupType);
  ItemTag := 'group';
  ItemInterface := IXMLGroupType;
  inherited;
end;

function TXMLDeviceType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLDeviceType.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

function TXMLDeviceType.Get_Fall_back: WideString;
begin
  Result := AttributeNodes['fall_back'].Text;
end;

function TXMLDeviceType.Get_Actual_device_root: WideString;
begin
  Result := AttributeNodes['actual_device_root'].Text;
end;

procedure TXMLDeviceType.Set_Fall_back(Value: WideString);
begin
  SetAttribute('fall_back', Value);
end;

function TXMLDeviceType.Get_User_agent: WideString;
begin
  Result := AttributeNodes['user_agent'].Text;
end;

procedure TXMLDeviceType.Set_User_agent(Value: WideString);
begin
  SetAttribute('user_agent', Value);
end;

procedure TXMLDeviceType.Set_Actual_device_root(Value: WideString);
begin
  SetAttribute('actual_device_root', Value);
end;

function TXMLDeviceType.Get_Group(Index: Integer): IXMLGroupType;
begin
  Result := List[Index] as IXMLGroupType;
end;

function TXMLDeviceType.Add: IXMLGroupType;
begin
  Result := AddItem(-1) as IXMLGroupType;
end;

function TXMLDeviceType.Insert(const Index: Integer): IXMLGroupType;
begin
  Result := AddItem(Index) as IXMLGroupType;
end;

{ TXMLGroupType }

procedure TXMLGroupType.AfterConstruction;
begin
  RegisterChildNode('capability', TXMLCapabilityType);
  ItemTag := 'capability';
  ItemInterface := IXMLCapabilityType;
  inherited;
end;

function TXMLGroupType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLGroupType.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

function TXMLGroupType.Get_Capability(Index: Integer): IXMLCapabilityType;
begin
  Result := List[Index] as IXMLCapabilityType;
end;

function TXMLGroupType.Add: IXMLCapabilityType;
begin
  Result := AddItem(-1) as IXMLCapabilityType;
end;

function TXMLGroupType.Insert(const Index: Integer): IXMLCapabilityType;
begin
  Result := AddItem(Index) as IXMLCapabilityType;
end;

{ TXMLCapabilityType }

function TXMLCapabilityType.Get_Name: WideString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLCapabilityType.Set_Name(Value: WideString);
begin
  SetAttribute('name', Value);
end;

function TXMLCapabilityType.Get_Value: WideString;
begin
  Result := AttributeNodes['value'].Text;
end;

procedure TXMLCapabilityType.Set_Value(Value: WideString);
begin
  SetAttribute('value', Value);
end;

end.

