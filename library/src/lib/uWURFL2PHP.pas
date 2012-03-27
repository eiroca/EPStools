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
unit uWURFL2PHP;

interface

uses
  wurfl, StrUtils, SysUtils, Classes, eHashList, uWURFL;

const

  _PHP_COPYRIGHT   = '/** This file is dynamically generated form WURFL XML file. */'+char(13);
  PHP_BEGIN       = '<?php '+_PHP_COPYRIGHT;
  PHP_END         = '?>';
  PHP_REGFILE     = 'handset_reg_%s.inc';
  PHP_REGINDEX    = 'handset_index.inc';
  PHP_DEFFILE     = 'wurfl\export\';

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
  // Handset wrapper for indexing in list
  THandsetListElement = class
    index: integer;
    userAgent: string;
    dev: IXMLDeviceType;
    handset: THandset;
    endSearch: boolean;
    constructor Create(wurfl: TWURFL; idx: integer);
  end;

function HandsetListElementCompare(Item1, Item2: Pointer): Integer;

type
  TPHPDef = class
    id: integer;
    seq: integer;
    data: string;
    isGeneric: boolean;
    constructor Create;
  end;

type
  // WURFL -> PHP classes converter
  TPHPExporter = class(TWURFLExporter)
    private
     IDMap: THashList;
     WebBrowsers: TStrings;
    private
    private
     function getPHPID(wurflID: integer; var phpHID, phpFID, phpGID, phpPath: string): boolean;
     function encode(source: string): string;
     procedure computeEndSearch(S: TList);
     procedure exportRegistryPart(part: string; S: TList; iFrom, iTo: integer; append: boolean);
     procedure PurgeDupl(Handsets: TList);
     procedure Compact(Handsets: TList);
     procedure setupDevice(id: integer; var seqID: integer);
     procedure ExportRegistry(S: TList);
     function  getDef(id: integer): TPHPDef;
     procedure setDef(id: integer; def: TPHPDef);
    protected
     procedure   Prologue; override;
     procedure   ExportDevice(id: integer); override;
     procedure   Epilogue; override;
    public
     constructor Create(aWurfl: TWURFL; aCallBack: TCallBack);
     destructor  Destroy; override;
  end;

implementation

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
  handset:= wurfl.getHandset(dev.Id);
  userAgent:=dev.User_agent;
  endSearch:= false;
end;

constructor TPHPDef.Create;
begin
  id:= -1;
  seq:= -1;
  data:= '';
  isGeneric:= false;
end;

constructor TPHPExporter.Create(aWurfl: TWURFL; aCallBack: TCallBack);
begin
  inherited Create(aWurfl, aCallBack);
  IDMap:= THashList.Create(aWurfl.wurflxml.Devices.Count*2, nil, nil);
  WebBrowsers:= TStringList.Create;
end;

destructor TPHPExporter.Destroy;
begin
  IDMap.Iterate(nil, Iterate_FreeObjects);
  IDMap.Free;
  WebBrowsers.Free;
end;

function TPHPExporter.getPHPID(wurflID: integer; var phpHID, phpFID, phpGID, phpPath: string): boolean;
var
  def: TPHPDef;
  fid: integer;
  did: integer;
begin
  Result:= false;
  def:= getDef(wurflID);
  if (def <> nil) then begin
    fid:= def.seq;
    did:= fid div 256;
    Result:= true;
    phpHID:= Format('H%x', [def.seq]);
    phpFID:= Format('F%4.4x.php', [fid]);
    phpGID:= Format('G%2.2x', [did]);
    phpPath:= phpGID+'/'+phpFID;
  end;
end;

function TPHPExporter.encode(source: string): string;
begin
  Result:= source;
  Result:= AnsiReplaceStr(Result, '\', '\\');
end;

function  TPHPExporter.getDef(id: integer): TPHPDef;
begin
  Result:= TPHPDef(IDMap[IntToStr(id)]);
end;

procedure TPHPExporter.setDef(id: integer; def: TPHPDef);
begin
  IDMap[IntToStr(id)]:= def;
end;

procedure TPHPExporter.Prologue;
var
  i: integer;
  seqID: integer;
begin
  seqID:= 0;
  for i:= 0 to wurfl.wurflxml.Devices.Count-1 do begin
    setupDevice(i, seqID);
  end;
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
  def:= getDef(id);
  getPHPID(id, phpHID, phpFID, phpGID, phpPath);
  try
    mkDir(OUT_HANDSETPATH+phpGID);
  except
  end;
  outDef:= PHP_BEGIN;
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
  Rewrite(f);
  writeln(f, outDef);
  CloseFile(f);
end;

procedure TPHPExporter.Epilogue;
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
  Compact(Handsets);
  PurgeDupl(Handsets);
  ExportRegistry(Handsets);
  for i:= Handsets.Count-1 downto 0 do begin
    THandsetListElement(Handsets[i]).Free;
  end;
  Handsets.Free;
  NotifyMessage('Device Registry export done.');
end;

const

 sNAME: WideString = 'name';
 sNAMESPACE: WideString = 'namespace';

procedure TPHPExporter.setupDevice(id: integer; var seqID: integer);
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
  if ((not hself.isWireless) and (not hself.isPlaceHolder)) then begin
    WebBrowsers.Add(hself.dev.User_agent);
  end;
  if not(hself.haveCode) then exit;
  def:= TPHPDef.Create;
  def.id:= id;
  def.seq:= seqID;
  inc(seqID);
  setDef(id, def);
  outDef:= Format(PHP_PROPERTY, ['ID', IntToStr(def.seq)]);
  for i:= 0 to dev.Count-1 do begin
    grp:= dev.Group[i];
    for j:= 0 to grp.Count-1 do begin
      cap:= grp.Capability[j];
      tmp1:= grp.Id+'_'+cap.Name;
      if (pos(sNAME, cap.Name) > 0 ) and (pos(sNAMESPACE, cap.Name) = 0) then begin
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
          tmp2:= Format('"%s"', [cap.Value]);
        end;
      end;
      outDef:= outDef + Format(PHP_PROPERTY, [tmp1, tmp2]);
    end;
  end;
  def.data:= outDef;
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
  write(f, PHP_BEGIN);
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
      writeln(f, Format('array("%s","%s","%s",%s),', [encode(hi.userAgent), phpHID, phpPath, BoolToStr(hi.endSearch)]));
    end;
  end;
  if (not append) then begin
    writeln(f, ');');
  end
  else begin
    writeln(f, '));');
  end;
  writeln(f, PHP_END);
  CloseFile(f);
end;

procedure TPHPExporter.computeEndSearch(S: TList);
var
  isLeaf: boolean;
  i, j: integer;
  hand1: THandsetListElement;
  hand2: THandsetListElement;
  ua1,ua2: string;
begin
  for i:= 0 to S.Count-1 do begin
    NotifyMessage('Searching leafs ('+IntToStr(i)+')');
    hand1:= THandsetListElement(S[i]);
    isLeaf:= true;
    if ((hand1=nil) or (hand1.handset.isPlaceHolder)) then continue;
    for j:= 0 to i-1 do begin
      hand2:= THandsetListElement(S[j]);
      if ((hand2=nil) or (hand2.handset.isPlaceHolder)) then continue;
      if (not hand2.handset.isWireless) then continue;
      if (Pos(hand1.userAgent, hand2.userAgent)>0) then begin
        ua1:= hand1.userAgent;
        ua2:= hand2.userAgent;
        isLeaf:= false;
        break;
      end;
    end;
    hand1.endSearch:= isLeaf;
  end;
  ua2:= ua2+ ua1;
end;

procedure TPHPExporter.ExportRegistry(S: TList);
var
  i: integer;
  hi: THandsetListElement;
  sezExp: TList;
  sezDef: TList;
  cnt: integer;
  index: TList;
  f: textfile;
const
  ROWS = 512;
begin
  computeEndSearch(S);
  index:= TList.Create;
  sezDef:= TList.Create;
  sezExp:= TList.Create;
  cnt:= 0;
  hi:= nil;
  for i:= 0 to s.Count-1 do begin
    hi:= THandsetListElement(S[i]);
    if ((hi=nil) or (hi.handset.isPlaceHolder)) then continue;
    if (not hi.endSearch) then begin
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
  write(f, PHP_BEGIN);
  writeln(f, 'global $handset_index;');
  writeln(f, '$handset_index = array(');
  for i:= 0 to index.Count-1 do begin
    hi:= THandsetListElement(index[i]);
    writeln(f, Format('array("%s","%s"),', [encode(hi.userAgent), Format(PHP_REGFILE, [IntToStr(i)])]));
  end;
  writeln(f, ');');
  writeln(f, PHP_END);
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

procedure TPHPExporter.Compact(Handsets: TList);
const
  MIN_LEN = 6;
var
  cnt, i, j, k: integer;
  userAgent, subUserAgent: string;
  dev1, dev2: IXMLDeviceType;
  h1, h2: THandset;
  l: integer;
  len: TStringList;
  isGeneric, ok: boolean;
  hi1, hi2: THandsetListElement;
  def: TPHPDef;
  shrink: boolean;
begin
  len:= TStringList.Create;
  cnt:= Handsets.Count;
  for i:= 0 to cnt-1 do begin
    NotifyMessage('Compacting ('+IntToStr(cnt)+')');
    dec(cnt);
    len.InsertObject(i, '', nil);
    hi1:= THandsetListElement(Handsets[i]);
    if (hi1=nil) or (hi1.handset.isPlaceHolder) then  continue;
    dev1:= hi1.dev;
    h1:= wurfl.getHandset(dev1.id).codeHandset;
    userAgent:= hi1.userAgent;
    subUserAgent:= userAgent;
    ok:= true;
    isGeneric:= true;
    shrink:= true;
    if not hi1.handset.isWireless then begin
      shrink:= false;
    end
    else begin
      for k := 0 to WebBrowsers.Count - 1 do begin
        if Pos(WebBrowsers[k], userAgent)>0 then begin
          shrink:= false;
          break;
        end;
      end;
    end;
    if shrink then begin
      for l:= MIN_LEN to length(userAgent) do begin
        subUserAgent:= copy(userAgent, 1, l);
        ok:= true;
        for k:= 1 to Handsets.Count-1 do begin
          j:= i + k;
          if (j>=Handsets.Count) then j:= j - Handsets.Count;
          hi2:= THandsetListElement(Handsets[j]);
          if ((hi2=nil) or (hi2.handset.isPlaceHolder)) then continue;
          dev2:= hi2.dev;
          h2:= wurfl.getHandset(dev2.id).codeHandset;
          if (h1.id = h2.id) then continue;
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
    end;
    def:= getDef(h1.id);
    def.isGeneric:= isGeneric;
    len[i]:= subUserAgent;
    if (ok) then begin
      len.Objects[i]:= pointer(1);
    end;
  end;
  for i:= 0 to Handsets.Count-1 do begin
    if len[i]<>'' then begin
      hi1:= THandsetListElement(Handsets[i]);
      hi1.userAgent:= len[i];
    end;
  end;
end;

end.
