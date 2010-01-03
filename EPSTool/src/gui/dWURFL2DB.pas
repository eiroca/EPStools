(****************************************************************************)
(*  Copyright (C) 1996-2008 eIrOcA Enrico Croce & Simona Burzio             *)
(*                                                                          *)
(*  This program is free software: you can redistribute it and/or modify    *)
(*  it under the terms of the GNU General Public License as published by    *)
(*  the Free Software Foundation, either version 3 of the License, or       *)
(*  (at your option) any later version.                                     *)
(*                                                                          *)
(*  This program is distributed in the hope that it will be useful,         *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of          *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *)
(*  GNU General Public License for more details.                            *)
(*                                                                          *)
(*  You should have received a copy of the GNU General Public License       *)
(*  along with this program.  If not, see <http://www.gnu.org/licenses/>.   *)
(*                                                                          *)
(*--------------------------------------------------------------------------*)
(*                                                                          *)
(* Author :  Enrico Croce                                                   *)
(*                                                                          *)
(****************************************************************************)
unit dWURFL2DB;

interface

uses
  uWURFL,
  Classes, Forms, DB, ADODB, Variants, wurfl, SysUtils;

const
  DBPATH = 'wurfl\db\wurfl.mdb';

type
  TdmWURFL2DB = class(TDataModule)
    DBDevice: TADOConnection;
    tbDevice: TADOTable;
    tbDeviceCodDev: TAutoIncField;
    tbDeviceCodParent: TIntegerField;
    tbDeviceID: TWideStringField;
    tbDeviceUserAgent: TWideStringField;
    tbGroup: TADOTable;
    tbGroupCodGrp: TAutoIncField;
    tbGroupName: TWideStringField;
    tbProperties: TADOTable;
    tbPropertiesCodPro: TAutoIncField;
    tbPropertiesCodGrp: TIntegerField;
    tbPropertiesName: TWideStringField;
    tbDefinition: TADOTable;
    tbDefinitionCodDev: TIntegerField;
    tbDefinitionCodPro: TIntegerField;
    tbDefinitionValue: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function getDeviceID(const ID: string): integer;
    function getGroup(grp: IXMLGroupType): integer;
    function getDevice(dev: IXMLDeviceType): integer;
    function getProperties(const Name: string; CodGrp: integer): integer;
  public
    { Public declarations }
    procedure Run(wurfl: TWURFL);
  end;

var
  dmWURFL2DB: TdmWURFL2DB;

implementation

{$R *.dfm}

uses
  eWait;

function TdmWURFL2DB.getProperties(const Name: string; CodGrp: integer): integer;
var
  res: variant;
begin
  res:= tbProperties.Lookup('CodGrp;Name', VarArrayOf([CodGrp, Name]), 'CodPro');
  if (res = null) then begin
    tbProperties.Append;
    tbPropertiesName.Value:= Name;
    tbPropertiesCodGrp.Value:= CodGrp;
    tbProperties.Post;
    Result:= tbPropertiesCodPro.Value;
  end
  else begin
    Result:= res;
  end;
end;

function TdmWURFL2DB.getGroup(grp: IXMLGroupType): integer;
var
  res: variant;
begin
  res:= tbGroup.Lookup('Name', grp.Id, 'CodGrp');
  if (res = null) then begin
    tbGroup.Append;
    tbGroupName.Value:= grp.Id;
    tbGroup.Post;
    Result:= tbGroupCodGrp.Value;
  end
  else begin
    Result:= res;
  end;
end;

function TdmWURFL2DB.getDeviceID(const ID: string): integer;
begin
  Result:= tbDevice.Lookup('ID', ID, 'CodDev');
end;

function TdmWURFL2DB.getDevice(dev: IXMLDeviceType): integer;
var
  res: variant;
begin
  res:= tbDevice.Lookup('ID', dev.id, 'CodDev');
  if (res = null) then begin
    tbDevice.Append;
    tbDeviceID.Value:= dev.Id;
    tbDeviceUserAgent.Value:= dev.User_agent;
    tbDevice.Post;
    Result:=tbDeviceCodDev.Value;
  end
   else begin
    Result:=res;
  end;
end;

procedure TdmWURFL2DB.Run(wurfl: TWURFL);
  function findDevice(const ID: string): IXMLDeviceType;
  var
    i: integer;
  begin
    Result:= nil;
    for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
      if wurfl.wurflxml.Devices[i].id = ID then begin
        Result:= wurfl.wurflxml.Devices[i];
        break;
      end;
    end;
  end;
  procedure CheckHandset;
  var
    dev: IXMLDeviceType;
    i: integer;
    P: TProgress;
  begin
    //Check presenza terminali
    P:= TProgress.Create(1, wurfl.wurflxml.Devices.Count);
    P.Caption:= 'Check presenza terminali';
    for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
      dev:= wurfl.wurflxml.Devices[i];
      getDevice(dev);
      P.Step;
    end;
    P.Free;
  end;
  procedure UpdateParent;
  var
    dev: IXMLDeviceType;
    i: integer;
    CodDev: integer;
    CodParent: integer;
    P: TProgress;
  begin
    //Aggiornamento Parent
    P:= TProgress.Create(1, wurfl.wurflxml.Devices.Count);
    P.Caption:= 'Aggiornamento Parent';
    for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
      dev:= wurfl.wurflxml.Devices[i];
      if (dev.Fall_back<>'root') then begin
        CodParent:= getDeviceID(dev.Fall_back);
        CodDev:= getDeviceID(dev.ID);
        tbDevice.Locate('CodDev', CodDev, []);
        if (tbDeviceCodParent.Value <> CodParent) then begin
          tbDevice.Edit;
          tbDeviceCodParent.Value:= CodParent;
          tbDevice.Post;
        end;
      end;
      P.Step;
    end;
    P.Free;
  end;
  procedure AddProperties(dev: IXMLDeviceType; CodDev: integer; direct: boolean);
  var
    i, j: integer;
    grp: IXMLGroupType;
    cap: IXMLCapabilityType;
    CodGrp: integer;
    CodPro: integer;
  begin
    for i:= 0 to dev.Count-1 do begin
      grp:= dev.Group[i];
      CodGrp:= getGroup(grp);
       for j:= 0 to grp.Count-1 do begin
        cap:= grp.Capability[j];
        CodPro:= getProperties(cap.Name, CodGrp);
        if tbDefinition.Locate('CodDev;CodPro', VarArrayOf([CodDev, CodPro]), []) then begin
          if (tbDefinitionValue.Value <> cap.Value) then begin
            tbDefinition.Edit;
            tbDefinitionValue.Value:= cap.Value;
//            tbDefinitionDirect.Value:= direct;
            tbDefinition.Post;
          end;
        end
        else begin
          tbDefinition.Append;
          tbDefinitionCodDev.Value:= CodDev;
          tbDefinitionCodPro.Value:= CodPro;
          tbDefinitionValue.Value:= cap.Value;
//          tbDefinitionDirect.Value:= direct;
          tbDefinition.Post;
        end;
      end;
    end;
  end;
  procedure AddHandset(dev: IXMLDeviceType; CodDev: integer; direct: boolean; full: boolean);
  var
    Parent: IXMLDeviceType;
  begin
    if (full) then begin
      Parent:= findDevice(dev.Fall_back);
      if (Parent<>nil) then begin
        AddHandset(Parent, CodDev, false, full);
      end;
    end;
    AddProperties(dev, CodDev, direct);
  end;
  procedure AddDefinition;
  var
    i: integer;
    dev: IXMLDeviceType;
    P: TProgress;
    CodDev: integer;
  begin
    //Aggiornamento Properties
    P:= TProgress.Create(1, wurfl.wurflxml.Devices.Count);
    P.Caption:= 'Aggiornamento Properties';
    for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
      dev:= wurfl.wurflxml.Devices[i];
      CodDev:= getDeviceID(dev.id);
      AddHandset(dev, CodDev, true, false);
      P.Step;
    end;
    P.Free;
  end;
begin
  DBDevice.Connected:= true;
  tbDevice.Active:= true;
  tbGroup.Active:= true;
  tbProperties.Active:= true;
  tbDefinition.Active:= true;
  CheckHandset;
  UpdateParent;
  AddDefinition;
  DBDevice.Connected:= false;
end;

procedure TdmWURFL2DB.DataModuleCreate(Sender: TObject);
var
  path: string;
begin
  path:= extractFilePath(Application.ExeName);
  DBDevice.ConnectionString:= 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+path+'\'+DBPATH+';Persist Security Info=False';
end;

end.

