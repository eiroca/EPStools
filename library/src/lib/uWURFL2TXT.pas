(****************************************************************************)
(*  Copyright (C) 1996-2011 eIrOcA Enrico Croce & Simona Burzio             *)
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
unit uWURFL2TXT;

interface

uses
  wurfl, StrUtils, SysUtils, Classes, eHashList, uWURFL;

type
  // Definition of an handset
  THandsetDef = class
     prop: TStringList;
     id: string;
     parent: string;
     userAgent: string;
     constructor Create;
     destructor Destroy; override;
  end;

  // WURFL -> TXT (CSV) converter
  TTXTExporter = class(TWURFLExporter)
    private
     f: textfile;
     def: THashList;
     propList: TStringList;
    private
     procedure SetupPropList(const dev: IXMLDeviceType);
    protected
     procedure   Prologue; override;
     procedure   ExportDevice(id: integer); override;
     procedure   Epilogue; override;
  end;

implementation

constructor THandsetDef.Create;
begin
  prop:= TStringList.Create;
end;

destructor THandsetDef.Destroy;
begin
  prop.Free;
end;

procedure TTXTExporter.SetupPropList(const dev: IXMLDeviceType);
var
  i, j: integer;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
  tmp: string;
begin
  for i:= 0 to dev.Count-1 do begin
    grp:= dev.Group[i];
    for j:= 0 to grp.Count-1 do begin
      cap:= grp.Capability[j];
      tmp:= grp.Id+'.'+cap.Name;
      propList.Add(tmp);
    end;
  end;
end;

procedure TTXTExporter.Prologue;
var
  i, j, k: integer;
  tmp: string;
  dev: IXMLDeviceType;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
  h: THandsetDef;
begin
  def:= THashList.Create(wurfl.wurflxml.Devices.Count*2, nil, nil);
  propList:= TStringList.create;
  for k:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    NotifyMessage('Processing handset definition ('+IntToStr(k)+')');
    dev:= wurfl.wurflxml.Devices[k];
    if (dev.Fall_back='root') then begin
      SetupPropList(dev);
    end;
    h:= THandsetDef.Create;
    h.id:= dev.Id;
    h.parent:= dev.Fall_back;
    h.userAgent:= dev.User_agent;
    for i:= 0 to dev.Count-1 do begin
      grp:= dev.Group[i];
       for j:= 0 to grp.Count-1 do begin
        cap:= grp.Capability[j];
        tmp:= grp.Id+'.'+cap.Name;
        h.prop.Values[tmp]:=cap.Value;
      end;
    end;
    def[dev.Id]:= h;
  end;
  AssignFile(f, OUT_HANDSETPATH+'hadset.txt');
  rewrite(f);
  tmp:='"ID";"ParentID";"userAgent"';
  for i:= 0 to propList.Count-1 do begin
    tmp:=tmp+';"'+propList[i]+'"';
  end;
  writeln(f, tmp);
end;

procedure TTXTExporter.ExportDevice(id: integer);
var
  i: integer;
  tmp, nam, val: string;
  dev: IXMLDeviceType;
  h, ht: THandsetDef;
begin
  NotifyMessage('Exporting handset definition ('+IntToStr(id)+')');
  dev:= wurfl.wurflxml.Devices[id];
  h:= THandsetDef(def[dev.id]);
  tmp:='"'+h.id+'";"'+h.parent+'";"'+h.userAgent+'"';
  for i:= 0 to propList.Count-1 do begin
    nam:= propList[i];
    ht:= h;
    repeat
      val:= ht.prop.Values[nam];
      if (val<>'') then break;
      ht:= THandsetDef(def[ht.parent]);
    until ht=nil;
    tmp:= tmp+';"'+val+'"';
  end;
  writeln(f, tmp);
end;

procedure TTXTExporter.Epilogue;
begin
  CloseFile(f);
  def.Iterate(nil, Iterate_FreeObjects);
  def.Free;
  NotifyMessage('Done');
end;

end.

