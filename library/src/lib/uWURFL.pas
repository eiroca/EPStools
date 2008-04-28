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
unit uWURFL;

interface

uses
  wurfl, StrUtils, SysUtils, Classes, eHashList;

const
  OUT_HANDSETPATH = 'export\';

  PHP_BEGIN       = '<?php ';
  PHP_END         = '?>';
  PHP_REGFILE     = 'handset_reg_%s.inc';
  PHP_REGINDEX    = 'handset_index.inc';
  PHP_DEFFILE     = 'wurfl\export\';
  PHP_COPYRIGHT   = '/** This file is dynamically generated form WURFL XML file. */'+char(13);

(*
  PHP_CLASS_OPEN  = 'class %s extends %s {'+chr(13);
  PHP_CLASS_CLOSE = '}'+chr(13);
  PHP_PROPERTY    = 'var $%s=%s;'+chr(13);
  PHP_INCLUDE     = 'require_once(EPS_HANDSET_DIR."%s");'+chr(13);
(* *)
(* *)
  PHP_CLASS_OPEN  = '';
  PHP_CLASS_CLOSE = '';
  PHP_PROPERTY    = '$this->%s=%s;'+char(13);
  PHP_INCLUDE     = 'include_once(EPS_HANDSET_DIR."%s");'+char(13);
(* *)

type
  TWURFL = class;

  THandsetDef = class
     prop: TStringList;
     id: string;
     parent: string;
     userAgent: string;
     constructor Create;
     destructor Destroy; override;
  end;

  THandsetListElement = class
    index: integer;
    userAgent: string;
    dev: IXMLDeviceType;
    endSearch: boolean;
    constructor Create(wurfl: TWURFL; idx: integer);
  end;

  TCallBack = procedure (const msg: string) of object;

  TWURFLExporterClass = class of TWURFLExporter;

  TWURFLExporter = class
    public
     procedure setupDevice(id: integer); virtual; abstract;
     procedure prologue; virtual; abstract;
     procedure exportDevice(id: integer); virtual; abstract;
     procedure exportRegistry(S: TList); virtual; abstract;
     procedure epilogue; virtual; abstract;
  end;

  TPHPExporter = class(TWURFLExporter)
    private
     callback: TCallBack;
     IDMap: THashList;
     wurfl: TWURFL;
     hid: integer;
    private
     procedure NotifyMessage(const aMsg: string);
     procedure computeEndSearch(S: TList);
     procedure exportRegistryPart(part: string; S: TList; iFrom, iTo: integer; append: boolean);
    public
     constructor Create(aWurfl: TWURFL; aCallBack: TCallBack);
     destructor  Destroy; override;
     procedure   setupDevice(id: integer); override;
     procedure   prologue; override;
     procedure   exportDevice(id: integer); override;
     procedure   exportRegistry(S: TList); override;
     procedure   epilogue; override;
    private
     function getPHPID(wurflID: integer; var phpHID, phpFID, phpGID, phpPath: string): boolean;
     procedure PurgeDupl(Handsets: TList);
     procedure NewAlg(Handsets: TList);
     procedure writeRegistry;
  end;

  THandset = class
    id: integer;
    isGeneric: boolean;
    dev: IXMLDeviceType;
    haveChild: boolean;
    haveCode: boolean;
    codeHandset: THandset;
    constructor Create(aid: integer; aDev: IXMLDeviceType);
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
     procedure exportTXT(aCallBack: TCallBack);
     procedure exportPHP(aCallBack: TCallBack);
     destructor Destroy; override;
  end;

type
  TPHPDef = class
    oid: integer;
    hid: integer;
    fid: integer;
    gid: integer;
    data: string;
    shared: boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor TPHPDef.Create;
begin
  oid:= -1;
  hid:= -1;
  fid:= -1;
  gid:= -1;
  data:= '';
  shared:= false;
end;

constructor THandsetDef.Create;
begin
  prop:= TStringList.Create;
end;

destructor THandsetDef.Destroy;
begin
  prop.Free;
end;

function HandsetListElementCompare(Item1, Item2: Pointer): Integer;
var
  e1, e2: THandsetListElement;
begin
  e1:= THandsetListElement(Item1);
  e2:= THandsetListElement(Item2);
  Result:= CompareText(e1.userAgent, e2.userAgent);
end;

constructor THandsetListElement.Create(wurfl: TWURFL; idx: integer);
begin
  index:= idx;
  dev:= wurfl.wurflxml.Devices[idx];
  userAgent:=dev.User_agent;
  endSearch:= false;
end;

destructor TPHPDef.Destroy;
begin
  inherited Destroy;
end;

constructor TPHPExporter.Create(aWurfl: TWURFL; aCallBack: TCallBack);
begin
  wurfl:= aWurfl;
  callback:= aCallBack;
  IDMap:= THashList.Create(10000, nil, nil);
  hid:= 0;
end;

destructor TPHPExporter.Destroy;
begin
  IDMap.Iterate(nil, Iterate_FreeObjects);
  IDMap.Free;
end;

procedure TPHPExporter.NotifyMessage(const aMsg: string);
begin
  if Assigned(callback) then callback(aMsg);
end;

function TPHPExporter.getPHPID(wurflID: integer; var phpHID, phpFID, phpGID, phpPath: string): boolean;
var
  def: TPHPDef;
begin
  Result:= false;
  def:= TPHPDef(IDMap[IntToStr(wurflID)]);
  if (def <> nil) then begin
    def.fid:= def.hid;
    def.gid:= def.fid div 64;
    Result:= true;
    phpHID:= 'H'+IntToStr(def.hid);
    phpFID:= 'F'+IntToStr(def.fid)+'.php';
    phpGID:= 'G'+IntToStr(def.gid);
    phpPath:= phpGID+'/'+phpFID;
  end;
end;

procedure TPHPExporter.prologue;
var
  i: integer;
  dev: IXMLDeviceType;
  hself: THandset;
  def: TPHPDef;
  fid: integer;
  siz: integer;
begin
  fid:= 0;
  for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    dev:= wurfl.wurflxml.Devices[i];
    hself:= wurfl.getHandset(dev.id);
    if (hself.haveCode) then begin
      def:= TPHPDef(IDMap[IntToStr(i)]);
      if (def <> nil) then begin
        if (hself.haveChild) then begin
          def.fid:= fid;
          def.gid:= fid div 64;
          inc(fid);
        end;
      end;
    end;
  end;
  siz:= 0;
  for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    dev:= wurfl.wurflxml.Devices[i];
    hself:= wurfl.getHandset(dev.id);
    if (hself.haveCode) then begin
      def:= TPHPDef(IDMap[IntToStr(i)]);
      if (def <> nil) then begin
        if (not hself.haveChild) then begin
          def.fid:= fid;
          def.gid:= fid div 64;
          siz:= siz + length(def.data);
          if (siz > 0) then begin
            siz:= 0;
            inc(fid);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPHPExporter.epilogue;
begin
  NotifyMessage('Export done.');
end;

procedure TPHPExporter.setupDevice(id: integer);
var
  i, j: integer;
  dev: IXMLDeviceType;
  hself: THandset;
  def: TPHPDef;
  outDef: string;
  tmp1, tmp2: string;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
begin
  NotifyMessage('Setup Handset Definition ('+IntToStr(id)+')');
  dev:= wurfl.wurflxml.Devices[id];
  hself:= wurfl.getHandset(dev.id);
  if not(hself.haveCode) then exit;
  def:= TPHPDef.Create;
  def.oid:= id;
  def.hid:= hid;
  inc(hid);
  IDMap[IntToStr(id)]:= def;
  outDef:= outDef + Format(PHP_PROPERTY, ['ID', IntToStr(def.hid)]);
  for i:= 0 to dev.Count-1 do begin
    grp:= dev.Group[i];
    for j:= 0 to grp.Count-1 do begin
      cap:= grp.Capability[j];
      tmp1:= grp.Id+'_'+cap.Name;
      if (pos('name', cap.Name) > 0 ) and (pos('namespace', cap.Name) = 0) then begin
        tmp2:= '"' + cap.Value + '"';
      end
      else if ((cap.Value='false') or (cap.Value='true')) then begin
        tmp2:= cap.Value;
      end
      else begin
        try
          StrToInt(cap.Value);
          tmp2:= cap.Value;
        except
          tmp2:= '"' + cap.Value + '"';
        end;
      end;
      outDef:= outDef + Format(PHP_PROPERTY, [tmp1, tmp2]);
    end;
  end;
  def.data:= outDef;
end;

procedure TPHPExporter.exportDevice(id: integer);
var
  dev: IXMLDeviceType;
  hself: THandset;
  hparent: THandset;
  prn: string;
  f: textfile;
  outDef: string;
  tmp1, tmp2: string;
  prtHID, prtFID, prtGID, prtPath: string;
  phpHID, phpFID, phpGID, phpPath: string;
  def: TPHPDef;
begin
  NotifyMessage('Export Handset Definition ('+IntToStr(id)+')');
  dev:= wurfl.wurflxml.Devices[id];
  hself:= wurfl.getHandset(dev.id);
  if not(hself.haveCode) then exit;
  def:= TPHPDef(IDMap[IntToStr(id)]);
  getPHPID(id, phpHID, phpFID, phpGID, phpPath);
  try
    mkDir(OUT_HANDSETPATH+phpGID);
  except
  end;
  outDef:= PHP_BEGIN;
  if (not def.shared) then begin
    outDef:= outDef + PHP_COPYRIGHT;
  end;
  prn:= dev.Fall_back;
  tmp1:= phpHID;
  tmp2:= 'THandset';
  if (prn <> 'root') then begin
    hparent:= wurfl.getHandset(prn).codeHandset;
    if getPHPID(hparent.id, prtHID, prtFID, prtGID, prtPath) then begin
      tmp2:= prtHID;
      outDef:= outDef + Format(PHP_INCLUDE, [prtPath]);
    end
    else begin
      NotifyMessage('Error in definition ('+dev.Id+')');
    end;
  end;
  outDef:= outDef + Format(PHP_CLASS_OPEN, [tmp1, tmp2]);
  outDef:= outDef + def.data;
  outDef:= outDef + PHP_CLASS_CLOSE;
  outDef:= outDef + PHP_END;
  AssignFile(f, OUT_HANDSETPATH+phpPath);
  try
    Append(f);
  except
    Rewrite(f);
  end;
  writeln(f, outDef);
  CloseFile(f);
end;

function encode(source: string): string;
begin
  Result:= source;
  Result:= AnsiReplaceStr(Result, '\', '\\');
end;

procedure TPHPExporter.exportRegistryPart(part: string; S: TList; iFrom, iTo: integer; append: boolean);
var
  i: integer;
  f: textfile;
  hi: THandsetListElement;
  h1, h2: THandset;
  phpHID, phpFID, phpGID, phpPath: string;
  dev: IXMLDeviceType;
begin
  AssignFile(f, OUT_HANDSETPATH+Format(PHP_REGFILE, [part]));
  rewrite(f);
  writeln(f, '<?php');
  getPHPID(wurfl.getRoot.id, phpHID, phpFID, phpGID, phpPath);
  writeln(f, 'global $handset_registry;');
  if (not append) then begin
    writeln(f, 'global $handset_default_class;');
    writeln(f, 'global $handset_default_path;');
    writeln(f, '$handset_default_class = "'+phpHID+'";');
    writeln(f, '$handset_default_path  = "'+phpPath+'";');
    writeln(f, '$handset_registry = array(');
  end
  else begin
    writeln(f, '$handset_registry = array_merge($handset_registry, array(');
  end;
  for i:= iTo downto iFrom do begin
    hi:= THandsetListElement(S[i]);
    if (hi=nil) then continue;
    dev:= hi.dev;
    h1:= wurfl.getHandset(dev.id);
    h2:= h1.codeHandset;
    if (h2.dev.Fall_back<>'root') then begin
      getPHPID(h2.id, phpHID, phpFID, phpGID, phpPath);
      writeln(f, Format(' array("%s","%s","%s",%s),', [encode(hi.userAgent), phpHID, phpPath, BoolToStr(hi.endSearch)]));
    end;
  end;
  if (not append) then begin
    writeln(f, '  );');
  end
  else begin
    writeln(f, '  ));');
  end;
  writeln(f, '?>');
  CloseFile(f);
end;

procedure TPHPExporter.computeEndSearch(S: TList);
var
  lastUA: string;
  thisUA: string;
  i: integer;
  hi: THandsetListElement;
  h1, h2: THandset;
  dev: IXMLDeviceType;
begin
  lastUA:= '';
  for i:= S.Count-1 downto 0 do begin
    hi:= THandsetListElement(S[i]);
    if (hi=nil) then continue;
    dev:= hi.dev;
    h1:= wurfl.getHandset(dev.id);
    h2:= h1.codeHandset;
    if (h2.dev.Fall_back<>'root') then begin
      hi.endSearch:= not h2.isGeneric;
      thisUA:= hi.userAgent;
      if not hi.endSearch then begin
        if pos(thisUA, lastUA) > 0 then begin
          hi.endSearch:= true;
        end;
      end;
      lastUA:= thisUA;
    end;
  end;
end;

procedure TPHPExporter.exportRegistry(S: TList);
var
  i: integer;
  hi: THandsetListElement;
  sezExp: TList;
  sezDef: TList;
  cnt: integer;
  index: TList;
  f: textfile;
const
  ROWS = 500;
begin
  computeEndSearch(S);
  index:= TList.Create;
  sezDef:= TList.Create;
  sezExp:= TList.Create;
  cnt:= 0;
  hi:= nil;
  for i:= 0 to s.Count-1 do begin
    hi:= THandsetListElement(S[i]);
    if (hi=nil) then continue;
    if not hi.endSearch then begin
      sezDef.Add(hi);
    end
    else begin
      sezExp.Add(hi);
      if (sezExp.Count>=ROWS) then begin
        exportRegistryPart(IntToStr(cnt), sezExp, 0, sezExp.Count-1, false);
        index.Add(hi);
        inc(cnt);
        sezExp.Clear;
      end;
    end;
  end;
  if (sezExp.Count>0) then begin
    exportRegistryPart(IntToStr(cnt), sezExp, 0, sezExp.Count-1, false);
    index.Add(hi);
  end;
  exportRegistryPart('def', sezDef, 0, sezDef.Count-1, true);
  AssignFile(f, OUT_HANDSETPATH+PHP_REGINDEX);
  rewrite(f);
  writeln(f, '<?php');
  writeln(f, 'global $handset_index;');
  writeln(f, '$handset_index = array(');
  for i:= 0 to index.Count-1 do begin
    hi:= THandsetListElement(index[i]);
    writeln(f, Format(' array("%s","%s"),', [encode(hi.userAgent), Format(PHP_REGFILE, [IntToStr(i)])]));
  end;
  writeln(f, '  );');
  writeln(f, '?>');
  CloseFile(f);
  index.Free;
  sezDef.Free;
  sezExp.Free;
end;

procedure TPHPExporter.PurgeDupl(Handsets: TList);
var
  cnt, i, j: integer;
  dev1, dev2: IXMLDeviceType;
  h1, h2: THandset;
  s1, s2: string;
  hi1, hi2: THandsetListElement;
begin
  cnt:= Handsets.Count;
  i:= 0;
  while (i<=Handsets.Count-1) do begin
    dec(cnt);
    NotifyMessage('Purging ('+IntToStr(cnt)+')');
    hi1:= THandsetListElement(Handsets[i]);
    if (hi1=nil) then continue;
    if (hi1.userAgent='') then begin
      inc(i);
      continue;
    end;
    dev1:= hi1.dev;
    for j:= Handsets.Count-1 downto i+1 do begin
      hi2:= THandsetListElement(Handsets[j]);
      dev2:= hi2.dev;
      s1:= hi1.userAgent;
      s2:= hi2.userAgent;
      if (pos(s1, s2) = 1) then begin
        h1:= wurfl.getHandset(dev1.id).codeHandset;
        h2:= wurfl.getHandset(dev2.id).codeHandset;
        if (h1.id=h2.id) then begin
          THandsetListElement(Handsets[j]).Free;
          Handsets.Delete(j);
          dec(cnt);
        end
      end;
    end;
    inc(i);
  end;
end;

procedure TPHPExporter.NewAlg(Handsets: TList);
const
  MIN_LEN = 5;
var
  cnt, i, j, k: integer;
  userAgent, subUserAgent: string;
  dev1, dev2: IXMLDeviceType;
  h1, h2: THandset;
  l: integer;
  len: TStringList;
  isGeneric, ok: boolean;
  hi1, hi2: THandsetListElement;
begin
  len:= TStringList.Create;
  cnt:= Handsets.Count;
  for i:= 0 to Handsets.Count-1 do begin
    dec(cnt);
    NotifyMessage('Compacting ('+IntToStr(cnt)+')');
    hi1:= THandsetListElement(Handsets[i]);
    if (hi1=nil) then begin
      len.InsertObject(i, '', nil);
      continue;
    end;
    dev1:= hi1.dev;
    h1:= wurfl.getHandset(dev1.id).codeHandset;
    userAgent:= hi1.userAgent;
    subUserAgent:= userAgent;
    ok:= true;
    isGeneric:= true;
    for l:= MIN_LEN to length(userAgent) do begin
      subUserAgent:= copy(userAgent, 1, l);
      ok:= true;
      for k:= 1 to Handsets.Count-1 do begin
        j:= i + k;
        if (j>=Handsets.Count) then j:= j - Handsets.Count;
        hi2:= THandsetListElement(Handsets[j]);
        if (hi2=nil) then continue;
        dev2:= hi2.dev;
        h2:= wurfl.getHandset(dev2.id).codeHandset;
        if (h1.id = h2.id) then begin
          continue;
        end;
        if (pos(subUserAgent, hi2.userAgent) = 1) then begin
          ok:= false;
          break;
        end;
      end;
      if (ok) then begin
        isGeneric:= false;
        break;
      end;
    end;
    h1.isGeneric:= isGeneric;
    if (ok) then begin
      len.InsertObject(i, subUserAgent, pointer(1));
    end
    else begin
      len.InsertObject(i, subUserAgent, nil);
    end;
  end;
  for i:= 0 to Handsets.Count-1 do begin
    if len[i]<>'' then begin
      hi1:= THandsetListElement(Handsets[i]);
      hi1.userAgent:= len[i];
    end;
  end;
end;

procedure TPHPExporter.writeRegistry;
var
  Handsets: TList;
  i: integer;
begin
  Handsets:= TList.Create;
  for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    Handsets.Add(THandsetListElement.Create(wurfl, i));
  end;
  Handsets.Sort(HandsetListElementCompare);
  PurgeDupl(Handsets);
  NewAlg(Handsets);
  PurgeDupl(Handsets);
  exportRegistry(Handsets);
  for i:= Handsets.Count-1 downto 0 do begin
    THandsetListElement(Handsets[i]).Free;
  end;
  Handsets.Free;
end;

constructor THandset.Create(aid: integer; aDev: IXMLDeviceType);
begin
  dev:= aDev;
  id:= aid;
  isGeneric:= false;
  haveChild:= false;
  haveCode:= false;
  codeHandset:= nil;
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
      h:= THandset.Create(i, dev);
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
  end;
end;

procedure TWURFL.exportTXT(aCallBack: TCallBack);
var
  def: THashList;
  propList: TStringList;
  f: textfile;
  h, ht: THandsetDef;
  dev: IXMLDeviceType;
  grp: IXMLGroupType;
  cap: IXMLCapabilityType;
  tmp, nam, val: string;
  i,j,k: integer;
begin
  def:= THashList.Create(wurflxml.Devices.Count*2, nil, nil);
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
  for k:= 0 to wurflxml.Devices.Count-1 do begin
    if Assigned(acallBack) then acallBack('Exporting handset definition ('+IntToStr(k)+')');
    dev:= wurflxml.Devices[k];
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
  CloseFile(f);
  def.Iterate(nil, Iterate_FreeObjects);
  def.Free;
  if Assigned(acallBack) then acallBack('Done');
end;

procedure TWURFL.exportPHP(aCallBack: TCallBack);
var
  i: integer;
  exp: TPHPExporter;
begin
  exp:= TPHPExporter.Create(self, aCallBack);
  for i:= 0 to wurflxml.Devices.Count-1 do begin
    exp.setupDevice(i);
  end;
  exp.prologue;
  for i:= 0 to wurflxml.Devices.Count-1 do begin
    exp.exportDevice(i);
  end;
  exp.writeRegistry;
  exp.epilogue;
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

end.

