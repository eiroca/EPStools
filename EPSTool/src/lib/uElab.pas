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
unit uElab;

interface

uses
  Classes, uWURFL;

type
  THandsetElab = class(TWURFL)
    function exportPropertyNames(aCallBack: TCallBack): TStrings;
    procedure exportProperties(path: string; propList: TStrings; aCallBack: TCallBack);
  end;

implementation

uses
  SysUtils, wurfl, eHashList;

function THandsetElab.exportPropertyNames(aCallBack: TCallBack): TStrings;
var
  i,j,k: integer;
  propList: TStringList;
  dev: IXMLDeviceType;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
  tmp: string;
begin
  propList:= TStringList.create;
  for k:= 0 to wurflxml.Devices.Count-1 do begin
    if Assigned(acallBack) then acallBack('Processing handset definition ('+IntToStr(k)+')');
    dev:= wurflxml.Devices[k];
    if (dev.Fall_back='root') then begin
      for i:= 0 to dev.Count-1 do begin
        grp:= dev.Group[i];
         for j:= 0 to grp.Count-1 do begin
          cap:= grp.Capability[j];
          tmp:= grp.Id+'.'+cap.Name;
          propList.Add(tmp);
        end;
      end;
    end;
  end;
  if Assigned(acallBack) then acallBack('Done');
  Result:= propList;
end;

procedure THandsetElab.exportProperties(path: string; propList: TStrings; aCallBack: TCallBack);
var
  def: THashList;
  f: textfile;
  i,j,k: integer;
  dev: IXMLDeviceType;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
  tmp, nam: string;
  h, ht: THandsetDef;
  handset: THandset;
  val: string;
  cnt: integer;
begin
  cnt:= wurflxml.Devices.Count-1;
  AssignFile(f, path);
  rewrite(f);
  tmp:='"ID";"userAgent";"Child";"Code"';
  for i:= 0 to propList.Count-1 do begin
    tmp:=tmp+';"'+propList[i]+'"';
  end;
  writeln(f, tmp);
  def:= THashList.Create(wurflxml.Devices.Count*2, nil, nil);
  for k:= 0 to cnt do begin
    if Assigned(acallBack) then acallBack('Processing handset definition ('+IntToStr(k)+')');
    dev:= wurflxml.Devices[k];
    h:= THandsetDef.Create;
    h.id:= dev.Id;
    h.parent:= dev.Fall_back;
    h.userAgent:= dev.User_agent;
    for i:= 0 to dev.Count-1 do begin
      grp:= dev.Group[i];
       for j:= 0 to grp.Count-1 do begin
        cap:= grp.Capability[j];
        tmp:= grp.Id+'.'+cap.Name;
        h.prop.Values[tmp]:= cap.Value;
      end;
    end;
    def[dev.Id]:= h;
  end;

  for k:= 0 to cnt do begin
    if Assigned(acallBack) then acallBack('Exporting handset definition ('+IntToStr(k)+')');
    dev:= wurflxml.Devices[k];
    h:= THandsetDef(def[dev.id]);
    handset:= getHandset(h.id);
    tmp:= Format('"%s";"%s";"%s";"%s"', [h.id,h.userAgent,BoolToStr(not handset.haveChild), BoolToStr(handset.haveCode)]);
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
  CloseFile(f);
  def.Iterate(nil, Iterate_FreeObjects);
  def.Free;
  if Assigned(acallBack) then acallBack('Done');
end;

end.
