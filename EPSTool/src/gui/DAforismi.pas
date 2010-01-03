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
unit DAforismi;

interface

uses
  SysUtils, Classes, StrUtils, INIFiles, uEPSUtil, Forms, DB, ADODB;

const
  DBPATH = 'aforismi\db\aforismi.mdb';

type
  TdmAforismi = class(TDataModule)
    dbAforismi: TADOConnection;
    tbGeneri: TADOTable;
    tbGeneriCodGen: TIntegerField;
    tbGeneriDesc: TWideStringField;
    tbGeneriLongDesc: TWideStringField;
    qryAforismi: TADOQuery;
    qryAforismiCodCat: TIntegerField;
    qryAforismiAforisma: TMemoField;
    qryAforismiCognome: TWideStringField;
    qryAforismiNome: TWideStringField;
    qryAforismiNote: TMemoField;
    qryAforismiTraduzione: TMemoField;
    qryAforismiOrder: TIntegerField;
    qryAforismiSignificato: TMemoField;
    qryAforismiCommenti: TMemoField;
    qryCategorie: TADOQuery;
    qryCategorieCodGen: TIntegerField;
    qryCategorieCodCat: TIntegerField;
    qryCateg: TADOQuery;
    qryCategCodCat: TIntegerField;
    qryCategDesc: TWideStringField;
    qryCategLongDesc: TWideStringField;
    qryCategDesc1: TWideStringField;
    qryCategConteggio: TIntegerField;
    tbAforismi: TADOTable;
    tbAforismiCodAfo: TAutoIncField;
    tbAforismiCodAut: TIntegerField;
    tbAforismiCodCat: TIntegerField;
    tbAforismilocale: TWideStringField;
    tbAforismiAforisma: TMemoField;
    tbAforismiTraduzione: TMemoField;
    tbAforismiNote: TMemoField;
    tbAforismiSignificato: TMemoField;
    tbAforismiCommenti: TMemoField;
    tbAforismiSearchKey: TWideStringField;
    tbAforismiOrder: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    procedure writeINIwithCategoria(CodCat: integer; aCallBack: TCallBack);
    procedure writeRSSwithCategoria(CodCat: integer; aCallBack: TCallBack);
    function getCategories(CodGen: integer; aCallBack: TCallBack): string;
    function convert(const source: string; aCallBack: TCallBack): string;
  public
    { Public declarations }
    procedure BuildSearchKey(aCallBack: TCallBack);
    procedure exportAsINI(aCallBack: TCallBack);
    procedure exportAsRSS(aCallBack: TCallBack);
  end;

var
  dmAforismi: TdmAforismi;

implementation

{$R *.dfm}

const
  OUT_AFORISMIPATH = 'aforismi\export\';

  conv_table: array[0..26,0..1] of string = (
    ('ç',  'c'),
    ('€',  'EUR'),
    ('&',  '&amp;'),
    ('°',  'o'),
    (#160, ' '),
    (#96,  '&#96;'),
    (#146, ''''),
    ('«',  '<<'),
    ('»',  '>>'),
    ('…',  '...'),
    ('"',  '&quot;'),
    ('è',  'e'''),
    ('à',  'a'''),
    ('á',  'a'''),
    ('ò',  'o'''),
    ('ó',  'o'''),
    ('é',  'e'''),
    ('ì',  'i'''),
    ('ù',  'u'''),
    ('ú',  'u'''),
    (#13,  '<br/>'),
    (#10,  ''),
    ('È',  'E'''),
    ('ö',  'o'),
    ('ü',  'u'),
    ('ï',  'i'),
    ('ô',  'o')
  );


procedure TdmAforismi.DataModuleCreate(Sender: TObject);
var
  path: string;
begin
  path:= extractFilePath(Application.ExeName);
  DBAforismi.ConnectionString:= 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+path+'\'+DBPATH+';Persist Security Info=False';
  dbAforismi.Connected:= true;
  qryCateg.Active:= true;
  tbGeneri.Active:= true;
  randomize;
end;

function TdmAforismi.convert(const source: string; aCallBack: TCallBack): string;
var
  i: integer;
  c: integer;
begin
  Result:= source;
  for i:= low(conv_table) to high(conv_table) do begin
    Result:= AnsiReplaceStr(Result, conv_table[i, 0], conv_table[i, 1]);
  end;
  for i:= length(Result) downto 1 do begin
    c:= ord(Result[i]);
    if (c < 32) then begin
      if Assigned(aCallBack) then aCallBack('Carattere illegale '+IntToStr(c));
      delete(Result, i, 1);
    end
    else if (c>127) then begin
      if Assigned(aCallBack) then aCallBack('Carattere non trappato '+IntToStr(c)+ ' =>'+chr(c));
      delete(Result, i, 1);
      insert('&#'+IntToStr(c), Result, i);
    end;
  end;
end;

procedure TdmAforismi.BuildSearchKey(aCallBack: TCallBack);
var
  afo: string;
  key: string;
  wrd: string;
  i, cnt: integer;
  ch: char;
  skip: boolean;
begin
  tbAforismi.Active:= true;
  cnt:= 0;
  while (not tbAforismi.Eof) do begin
    inc(cnt);
    if Assigned(aCallBack) then aCallBack(IntToStr(cnt));
    afo:= tbAforismiAforisma.Value;
    afo:= LowerCase(convert(afo, aCallBack));
    key:= '';
    wrd:= '';
    skip:= false;
    for i:= 1 to length(afo) do begin
      ch:= afo[i];
      if not (ch in ['a'..'z','0'..'9']) then ch:= ' ';
      if (ch = ' ') then begin
        skip:= true;
      end
      else begin
        if (skip) then begin
          if (length(wrd)>2) then begin
            key:= key + wrd + ' ';
          end;
          wrd:= '';
          skip:= false;
        end;
        wrd:= wrd + ch;
      end;
    end;
    if (length(wrd)>2) then begin
      key:= key + wrd + ' ';
    end;
    tbAforismi.Edit;
    tbAforismiSearchKey.Value:= key;
    tbAforismiOrder.Value:= random(100000);
    tbAforismi.Post;
    tbAforismi.Next;
  end;
  tbAforismi.Active:= false;
end;

function TdmAforismi.getCategories(CodGen: integer; aCallBack: TCallBack): string;
begin
  qryCategorie.Parameters.FindParam('CodGen').Value:= CodGen;
  qryCategorie.Active:= true;
  qryCategorie.First;
  Result:= '';
  while not qryCategorie.Eof do begin
    if (result<>'') then Result:= Result+' ';
    Result:= Result + qryCategorieCodCat.AsString;
    qryCategorie.Next;
  end;
  qryCategorie.Active:= false;
end;

procedure TdmAforismi.writeINIwithCategoria(CodCat: integer; aCallBack: TCallBack);
var
  ini: TMemINIFile;
  id: integer;
  aut, tmp,
  tmp_afo, tmp_tra, tmp_not, tmp_sig, tmp_com: string;
begin
  qryAforismi.Active:= false;
  qryAforismi.Parameters.FindParam('CodCat').Value:= CodCat;
  qryAforismi.Active:= true;
  qryAforismi.First;
  ini:= TMemINIFile.Create(OUT_AFORISMIPATH+IntToStr(CodCat)+'.ini');
  ini.WriteString('main', 'caption', '"'+convert(qryCategDesc.AsString, aCallBack)+'"');
  ini.WriteString('main', 'description', '"'+convert(qryCategLongDesc.AsString, aCallBack)+'"');
  ini.WriteString('main', 'label1', '"'+convert(qryCategDesc1.AsString, aCallBack)+'"');
  id:= 0;
  while not qryAforismi.Eof do begin
    tmp_afo:= convert(qryAforismiAforisma.Value, aCallBack);
    tmp_tra:= convert(qryAforismiTraduzione.Value, aCallBack);
    tmp_not:= convert(qryAforismiNote.Value, aCallBack);
    tmp_sig:= convert(qryAforismiSignificato.Value, aCallBack);
    tmp_com:= convert(qryAforismiCommenti.Value, aCallBack);
    if (length(tmp_afo)<240) and (length(tmp_tra)<240) and (length(tmp_not)<240) and (length(tmp_sig)<240) and (length(tmp_com)<240) then begin
      inc(id);
      tmp:= 'aforisma_'+IntToStr(id);
      ini.WriteString(tmp, 'description', '"'+tmp_afo+'"');
      if (not qryAforismiCognome.IsNull) then begin
        if qryAforismiNome.IsNull then aut:= qryAforismiCognome.asString
        else aut:= qryAforismiNome.asString + ' ' + qryAforismiCognome.asString;
        ini.WriteString(tmp, 'author', '"'+convert(aut, aCallBack)+'"');
      end;
      if (tmp_not <> '') then begin
        ini.WriteString(tmp, 'note', '"'+tmp_not+'"');
      end;
      if (tmp_tra <> '') then begin
        ini.WriteString(tmp, 'traduzione', '"'+tmp_tra+'"');
      end;
      if (tmp_sig <> '') then begin
        ini.WriteString(tmp, 'significato', '"'+tmp_sig+'"');
      end;
      if (tmp_com <> '') then begin
        ini.WriteString(tmp, 'commento', '"'+tmp_com+'"');
      end;
    end;
    qryAforismi.Next;
  end;
  ini.WriteInteger('main', 'count', id);
  ini.UpdateFile;
  ini.Free;
  qryAforismi.Active:= false;
end;

procedure TdmAforismi.exportAsINI(aCallBack: TCallBack);
var
  ini: TMemINIFile;
  CodGen: integer;
  CodCat: integer;
  genere: string;
  tmp: string;
begin
  ini:= TMemINIFile.Create(OUT_AFORISMIPATH+'index.ini');
  try
   tbGeneri.First;
    while not tbGeneri.Eof do begin
      CodGen:= tbGeneriCodGen.Value;
      tmp:= 'kind_'+IntToStr(CodGen);
      ini.WriteString(tmp, 'caption', '"'+tbGeneriDesc.AsString+'"');
      ini.WriteString(tmp, 'description', '"'+tbGeneriLongDesc.AsString+'"');
      ini.WriteString(tmp, 'categories', getCategories(CodGen, aCallBack));
      tbGeneri.Next;
    end;
    qryCateg.First;
    while not qryCateg.Eof do begin
      CodCat:= qryCategCodCat.Value;
      genere:= convert(qryCategDesc.Value, aCallBack);
      tmp:= 'category_'+IntToStr(CodCat);
      ini.WriteString(tmp, 'caption', Format('"%s (%d)"', [genere, qryCategConteggio.Value]));
      ini.WriteString(tmp, 'path', '"'+IntToStr(CodCat)+'.ini"');
      writeINIwithCategoria(CodCat, aCallBack);
      qryCateg.Next;
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
  if Assigned(aCallBack) then aCallBack('INI exported');
end;

procedure TdmAforismi.writeRSSwithCategoria(CodCat: integer; aCallBack: TCallBack);
var
  f: TextFile;
  aut: string;
begin
  qryAforismi.Active:= false;
  qryAforismi.Parameters.FindParam('CodCat').Value:= CodCat;
  qryAforismi.Active:= true;
  qryAforismi.First;
  AssignFile(f, OUT_AFORISMIPATH+IntToStr(CodCat)+'.rss');
  Rewrite(f);
  writeln(f, '<?xml version="1.0" encoding="iso-8859-1" ?>');
  writeln(f, '<rss version="0.91">');
  writeln(f, '<channel>');
  writeln(f, ' <title>'+qryCategDesc.AsString+'</title>');
  writeln(f, ' <description>'+qryCategLongDesc.AsString+'</description>');
  while not qryAforismi.Eof do begin
    writeln(f, ' <item>');
    writeln(f, '  <description>'+qryAforismiAforisma.Value+'</description>');
    if (not qryAforismiCognome.IsNull) then begin
      if qryAforismiNome.IsNull then aut:= qryAforismiCognome.asString
      else aut:= qryAforismiNome.asString + ' ' + qryAforismiCognome.asString;
      writeln(f, '  <author>'+aut+'</author>');
    end;
    writeln(f, ' </item>');
    qryAforismi.Next;
  end;
  writeln(f, '</channel>');
  writeln(f, '</rss>');
  CloseFile(f);
  qryAforismi.Active:= false;
end;

procedure TdmAforismi.exportAsRSS(aCallBack: TCallBack);
var
  ini: TMemINIFile;
  CodGen: integer;
  CodCat: integer;
  genere: string;
  tmp: string;
begin
  ini:= TMemINIFile.Create(OUT_AFORISMIPATH+'index.ini');
  try
   tbGeneri.First;
    while not tbGeneri.Eof do begin
      CodGen:= tbGeneriCodGen.Value;
      tmp:= 'kind_'+IntToStr(CodGen);
      ini.WriteString(tmp, 'caption', '"'+tbGeneriDesc.AsString+'"');
      ini.WriteString(tmp, 'description', '"'+tbGeneriLongDesc.AsString+'"');
      ini.WriteString(tmp, 'categories', getCategories(CodGen, aCallBack));
      tbGeneri.Next;
    end;
    qryCateg.First;
    while not qryCateg.Eof do begin
      CodCat:= qryCategCodCat.Value;
      genere:= convert(qryCategDesc.Value, aCallBack);
      tmp:= 'category_'+IntToStr(CodCat);
      ini.WriteString(tmp, 'caption', Format('"%s (%d)"', [genere, qryCategConteggio.Value]));
      ini.WriteString(tmp, 'path', '"'+IntToStr(CodCat)+'.ini"');
      writeRSSwithCategoria(CodCat, aCallBack);
      qryCateg.Next;
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
  if Assigned(aCallBack) then aCallBack('exported');
end;

end.

