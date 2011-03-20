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
unit uWURFL;

interface

uses
  wurfl, StrUtils, SysUtils, Classes, eHashList;

type
  TCallBack = procedure (const msg: string) of object;
  TWURFL = class;

  THandset = class
    id: integer;
    dev: IXMLDeviceType;
    wurfl: TWURFL;
    haveChild: boolean;
    haveCode: boolean;
    codeHandset: THandset;
    isWireless: boolean;
    isPlaceHolder: boolean;
    constructor Create(aWurfl: TWURFL; aid: integer; aDev: IXMLDeviceType);
    function getProperty(group, name: string): string;
  end;

  TWURFL = class
    private
      map: THashList;
      root: THandset;
    public
     wurflxml: IXMLWurflType;
    public
     constructor Create(const wurflPath: string);
     function getRoot: THandset;
     function getHandset(id: string): THandset;
     function getCodeHandset(id: string): THandset;
     destructor Destroy; override;
  end;


const
  OUT_HANDSETPATH = 'export\';

type

  // WURFL exporter base class
  TWURFLExporterClass = class of TWURFLExporter;
  TWURFLExporter = class
    private
      FWURFL: TWURFL;
      FCallBack: TCallBack;
    protected
     property wurfl: TWURFL read FWURFL;
     property CallBack: TCallBack read FCallBack;
    protected
     procedure NotifyMessage(const aMsg: string);
    protected
     procedure Prologue; virtual; abstract;
     procedure ExportDevice(id: integer); virtual; abstract;
     procedure Epilogue; virtual; abstract;
    public
     constructor Create(const wurlf: TWURFL; aCallBack: TCallBack);
     procedure   Export; virtual;
  end;

implementation

const
  PLACEHOLDER_STR = 'DO_NOT_MATCH_';
  NONUNIQUE_STR = 'NON_UNIQUE_';


constructor THandset.Create(aWurfl: TWURFL; aid: integer; aDev: IXMLDeviceType);
begin
  dev:= aDev;
  wurfl:= aWurfl;
  id:= aid;
  haveChild:= false;
  haveCode:= false;
  codeHandset:= nil;
  isWireless:= true;
  if ((Pos(PLACEHOLDER_STR, dev.User_agent)=1) or (Pos(NONUNIQUE_STR, dev.User_agent)=1)) then begin
    isPlaceHolder:= true;
  end
  else begin
    isPlaceHolder:= false;
  end;
end;

function _getProperty(dev: IXMLDeviceType; group, name: string): string;
var
  i, j: integer;
begin
  Result:= '';
  for i:= 0 to dev.Count-1 do begin
    if (dev.Group[i].Id=group) then begin
      for j:= 0 to dev.Group[i].Count-1 do begin
        if (dev.Group[i].Capability[j].Name=name) then begin
          Result:= dev.Group[i].Capability[j].Value;
          exit;
        end;
      end;
    end;
  end;
end;

function THandset.getProperty(group, name: string): string;
var
  device: IXMLDeviceType;
  parent: string;
  par: THandset;
begin
  device:= dev;
  repeat
    Result:= _getProperty(device, group, name);
    if (Result<>'') then begin
      break;
    end
    else begin
      parent:= device.Attributes['fall_back'];
      if (parent='root') then begin
        break;
      end;
      par:= wurfl.getHandset(parent);
      if (par=nil) then  begin
        break;
      end;
      device:= par.dev;
    end;
  until device=nil;
end;

function TWURFL.getRoot: THandset;
begin
  Result:= root;
end;

function TWURFL.getHandset(id: string): THandset;
begin
  Result:= THandset(map[id]);
end;

function TWURFL.getCodeHandset(id: string): THandset;
var
  h: THandset;
  hn: THandset;
begin
  h:= THandset(map[id]);
  while (h.haveCode = false) do begin
    hn:= THandset(map[h.dev.Attributes['fall_back']]);
    if (hn=nil) then break;
    h:= hn;
  end;
  Result:= h;
end;

constructor TWURFL.Create(const wurflPath: string);
var
  h: THandset;
  i: integer;
  fb: string;
  hc: boolean;
  devs: integer;
  devID: string;
  dev: IXMLDeviceType;
begin
  wurflxml:= Loadwurfl(wurflPath);
  if (wurflxml<>nil) then begin
    devs:= wurflxml.Devices.Count;
    map:= THashList.Create(devs*2, nil, nil);
    for i:= 0 to devs-1 do begin
      dev:= wurflxml.Devices[i];
      devID:= dev.id;
      h:= THandset.Create(self, i, dev);
      if (dev.ChildNodes.Count > 0) then begin
        h.haveCode:= true;
      end;
      map[devID]:= h;
      if dev.Attributes['fall_back']='root' then begin
        root:= h;
      end;
    end;
    for i:= 0 to devs-1 do begin
      dev:= wurflxml.Devices[i];
      fb:= dev.Fall_back;
      hc:= true;
      repeat
        if (fb='root') then break;
        h:= THandset(map[fb]);
        if (h=nil) then begin
          raise Exception.Create('Missing '+fb);
        end;
        fb:= h.dev.Attributes['fall_back'];
        hc:= h.haveChild;
        h.haveChild:= true;
      until hc = true;
    end;
    for i:= 0 to devs-1 do begin
      dev:= wurflxml.Devices[i];
      devID:= dev.Attributes['id'];
      h:= getHandset(devID);
      h.codeHandset:= getCodeHandset(devID);
    end;
    for i:= 0 to devs-1 do begin
      dev:= wurflxml.Devices[i];
      devID:= dev.Attributes['id'];
      h:= getHandset(devID);
      h.isWireless:= h.getProperty('product_info', 'is_wireless_device') = 'true';
    end;
  end;
end;

destructor TWURFL.Destroy;
begin
  if (map<>nil) then begin
    map.Iterate(nil, Iterate_FreeObjects);
    map.Free;
  end;
  map:= nil;
  wurflxml:= nil;
  root:= nil;
end;

constructor TWURFLExporter.Create(const wurlf: TWURFL; aCallBack: TCallBack);
begin
  FWURFL:= wurlf;
  FCallBack:= aCallBack;
end;

procedure TWURFLExporter.NotifyMessage(const aMsg: string);
begin
  if Assigned(FCallBack) then FCallBack(aMsg);
end;

procedure TWURFLExporter.Export;
var
  i: integer;
begin
  Prologue;
  for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    ExportDevice(i);
  end;
  Epilogue;
end;

end.

