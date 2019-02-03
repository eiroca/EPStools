(* GPL > 3.0
  Copyright (C) 1996-2019 eIrOcA Enrico Croce & Simona Burzio

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*)
(*
  @author(Enrico Croce)
*)
unit DAforismi;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, uUtils;

type
  TdmAforismi = class(TDataModule)
    qryCateg: TADOQuery;
    dbAforismi: TADOConnection;
    tbAforismi: TADOTable;
    tbAforismiCodAfo: TAutoIncField;
    tbAforismiCodAut: TIntegerField;
    tbAforismiCodCat: TIntegerField;
    tbAforismiEtico: TWideStringField;
    tbAforismilocale: TWideStringField;
    tbAforismiAforisma: TWideMemoField;
    tbAforismiTraduzione: TWideMemoField;
    tbAforismiNote: TWideMemoField;
    tbAforismiSignificato: TWideMemoField;
    tbAforismiCommenti: TWideMemoField;
    tbAforismiSearchKey: TWideStringField;
    tbAforismiOrder: TIntegerField;
    tbGeneri: TADOTable;
    tbGeneriCodGen: TIntegerField;
    tbGeneriDesc: TWideStringField;
    tbGeneriLongDesc: TWideStringField;
    tbGeneriGenere: TWideStringField;
    qryCategCodCat: TIntegerField;
    qryCategDesc: TWideStringField;
    qryCategLongDesc: TWideStringField;
    qryCategGenere: TWideStringField;
    qryCategConteggio: TIntegerField;
    qryCatInGen: TADOQuery;
    qryCatInGenCodGen: TIntegerField;
    qryCatInGenCodCat: TIntegerField;
    qryCatInGenDesc: TWideStringField;
    qryCatInGenLongDesc: TWideStringField;
    qryCatInGenGenere: TWideStringField;
    qryAfoInCat: TADOQuery;
    qryAfoInCatCodAfo: TAutoIncField;
    qryAfoInCatCodCat: TIntegerField;
    qryAfoInCatEtico: TWideStringField;
    qryAfoInCatlocale: TWideStringField;
    qryAfoInCatAforisma: TWideMemoField;
    qryAfoInCatTraduzione: TWideMemoField;
    qryAfoInCatNote: TWideMemoField;
    qryAfoInCatSignificato: TWideMemoField;
    qryAfoInCatCommenti: TWideMemoField;
    qryAfoInCatSearchKey: TWideStringField;
    qryAfoInCatOrder: TIntegerField;
    qryAfoInCatCodAut: TAutoIncField;
    qryAfoInCatCognome: TWideStringField;
    qryAfoInCatNome: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FDBPath: string;
    FExportPath: string;
    FCallBack: TCallBack;
    function wikiNL(var T: string): boolean;
    function convert(const source: string): string;
    function getCategories(CodGen: integer): string;
    procedure writeINIwithCategoria(CodCat: integer);
    procedure writeRSSwithCategoria(CodCat: integer);
    procedure setDBPath(const Value: string);
    procedure setExportPath(const Value: string);
    procedure notify(const msg: string);
  public
    { Public declarations }
    function Open(const path: string): boolean;
    function Close(): boolean;
    procedure ExportAsINI;
    procedure ExportAsRSS;
    procedure ExportAsDokuWiki;
    procedure BuildSearchKey;
  public
    property CallBack: TCallBack write FCallBack;
    property DBPath: string read FDBPath write setDBPath;
    property ExportPath: string read FExportPath write setExportPath;
  end;

var
  dmAforismi: TdmAforismi;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  StrUtils, IniFiles;

const
  conv_table: array [0 .. 26, 0 .. 1] of string = (('ç', 'c'), ('€', 'EUR'), ('&', '&amp;'),
    ('°', 'o'), (#160, ' '), (#96, '&#96;'), (#146, ''''), ('«', '<<'), ('»', '>>'), ('…', '...'),
    ('"', '&quot;'), ('è', 'e'''), ('à', 'a'''), ('á', 'a'''), ('ò', 'o'''), ('ó', 'o'''),
    ('é', 'e'''), ('ì', 'i'''), ('ù', 'u'''), ('ú', 'u'''), (#13, '<br/>'), (#10, ''), ('È', 'E'''),
    ('ö', 'o'), ('ü', 'u'), ('ï', 'i'), ('ô', 'o'));

  WIKI_NL: string = '\\' + chr(13);

procedure TdmAforismi.DataModuleCreate(Sender: TObject);
begin
  randomize;
  ExportPath:= '';
end;

procedure TdmAforismi.notify(const msg: string);
begin
  if Assigned(FCallBack) then FCallBack(msg);
end;

function TdmAforismi.Open(const path: string): boolean;
begin
  DBPath:= path;
  Result:= dbAforismi.Connected;
  if (Result) then notify('Connected to DB');
end;

procedure TdmAforismi.setDBPath(const Value: string);
begin
  FDBPath:= Value;
  dbAforismi.Connected:= false;
  if (Value <> '') then begin
    dbAforismi.ConnectionString:=
      Format('Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False',
      [DBPath]);
    dbAforismi.Connected:= true;
  end;
end;

procedure TdmAforismi.setExportPath(const Value: string);
begin
  FExportPath:= Value;
  if (FExportPath <> '') then begin
    try
      MkDir(FExportPath);
    except
    end;
  end;
end;

function TdmAforismi.Close(): boolean;
begin
  dbAforismi.Connected:= false;
  Result:= false;
end;

function TdmAforismi.convert(const source: string): string;
var
  i: integer;
  c: integer;
begin
  Result:= source;
  for i:= low(conv_table) to high(conv_table) do begin
    Result:= ReplaceStr(Result, conv_table[i, 0], conv_table[i, 1]);
  end;
  for i:= length(Result) downto 1 do begin
    c:= ord(Result[i]);
    if (c < 32) then begin
      notify('Carattere illegale ' + IntToStr(c));
      delete(Result, i, 1);
    end
    else if (c > 127) then begin
      notify('Carattere non trappato ' + IntToStr(c) + ' =>' + chr(c));
      delete(Result, i, 1);
      insert('&#' + IntToStr(c), Result, i);
    end;
  end;
end;

function TdmAforismi.getCategories(CodGen: integer): string;
begin
  qryCatInGen.Parameters.FindParam('CodGen').Value:= CodGen;
  qryCatInGen.Active:= true;
  qryCatInGen.First;
  Result:= '';
  while not qryCatInGen.Eof do begin
    if (Result <> '') then Result:= Result + ' ';
    Result:= Result + qryCatInGenCodCat.AsString;
    qryCatInGen.Next;
  end;
  qryCatInGen.Active:= false;
end;

procedure TdmAforismi.writeINIwithCategoria(CodCat: integer);
var
  ini: TMemINIFile;
  id: integer;
  aut, tmp, tmp_afo, tmp_tra, tmp_not, tmp_sig, tmp_com: string;
  desc1: string;
begin
  qryAfoInCat.Parameters.FindParam('CodCat').Value:= CodCat;
  qryAfoInCat.Active:= true;
  qryAfoInCat.First;
  ini:= TMemINIFile.Create(ExportPath + IntToStr(CodCat) + '.ini');
  ini.WriteString('main', 'caption', '"' + convert(qryCategDesc.AsString) + '"');
  ini.WriteString('main', 'description', '"' + convert(qryCategLongDesc.AsString) + '"');
  if ((qryCategGenere.AsString = 'F') or (qryCategGenere.AsString = '')) then
      desc1:= 'un''altra a caso'
  else desc1:= 'un altro a caso';
  ini.WriteString('main', 'label1', '"' + convert(desc1) + '"');
  id:= 0;
  while not qryAfoInCat.Eof do begin
    tmp_afo:= convert(qryAfoInCatAforisma.Value);
    tmp_tra:= convert(qryAfoInCatTraduzione.Value);
    tmp_not:= convert(qryAfoInCatNote.Value);
    tmp_sig:= convert(qryAfoInCatSignificato.Value);
    tmp_com:= convert(qryAfoInCatCommenti.Value);
    if (length(tmp_afo) < 240) and (length(tmp_tra) < 240) and (length(tmp_not) < 240) and
      (length(tmp_sig) < 240) and (length(tmp_com) < 240) then begin
      inc(id);
      tmp:= 'aforisma_' + IntToStr(id);
      ini.WriteString(tmp, 'description', '"' + tmp_afo + '"');
      if (not qryAfoInCatCognome.IsNull) then begin
        if qryAfoInCatNome.IsNull then aut:= qryAfoInCatCognome.AsString
        else aut:= qryAfoInCatNome.AsString + ' ' + qryAfoInCatCognome.AsString;
        ini.WriteString(tmp, 'author', '"' + convert(aut) + '"');
      end;
      if (tmp_not <> '') then ini.WriteString(tmp, 'note', '"' + tmp_not + '"');
      if (tmp_tra <> '') then ini.WriteString(tmp, 'traduzione', '"' + tmp_tra + '"');
      if (tmp_sig <> '') then ini.WriteString(tmp, 'significato', '"' + tmp_sig + '"');
      if (tmp_com <> '') then ini.WriteString(tmp, 'commento', '"' + tmp_com + '"');
    end;
    qryAfoInCat.Next;
  end;
  ini.WriteInteger('main', 'count', id);
  ini.UpdateFile;
  ini.Free;
  qryAfoInCat.Active:= false;
end;

procedure TdmAforismi.ExportAsINI;
var
  ini: TMemINIFile;
  CodGen: integer;
  CodCat: integer;
  genere: string;
  tmp: string;
begin
  ini:= TMemINIFile.Create(ExportPath + 'index.ini');
  try
    tbGeneri.Active:= true;
    tbGeneri.First;
    while not tbGeneri.Eof do begin
      CodGen:= tbGeneriCodGen.Value;
      tmp:= 'kind_' + IntToStr(CodGen);
      ini.WriteString(tmp, 'caption', '"' + tbGeneriDesc.AsString + '"');
      ini.WriteString(tmp, 'description', '"' + tbGeneriLongDesc.AsString + '"');
      ini.WriteString(tmp, 'categories', getCategories(CodGen));
      tbGeneri.Next;
    end;
    qryCateg.Active:= true;
    qryCateg.First;
    while not qryCateg.Eof do begin
      CodCat:= qryCategCodCat.Value;
      genere:= convert(qryCategDesc.Value);
      tmp:= 'category_' + IntToStr(CodCat);
      ini.WriteString(tmp, 'caption', Format('"%s (%d)"', [genere, qryCategConteggio.Value]));
      ini.WriteString(tmp, 'path', '"' + IntToStr(CodCat) + '.ini"');
      writeINIwithCategoria(CodCat);
      qryCateg.Next;
    end;
  finally
    ini.UpdateFile;
    ini.Free;
    qryCateg.Active:= false;
    tbGeneri.Active:= false;
  end;
  notify('INI exported');
end;

procedure TdmAforismi.writeRSSwithCategoria(CodCat: integer);
var
  f: TextFile;
  aut: string;
begin
  qryAfoInCat.Active:= false;
  qryAfoInCat.Parameters.FindParam('CodCat').Value:= CodCat;
  qryAfoInCat.Active:= true;
  qryAfoInCat.First;
  AssignFile(f, ExportPath + IntToStr(CodCat) + '.rss');
  Rewrite(f);
  writeln(f, '<?xml version="1.0" encoding="iso-8859-1" ?>');
  writeln(f, '<rss version="0.91">');
  writeln(f, '<channel>');
  writeln(f, ' <title>' + qryCategDesc.AsString + '</title>');
  writeln(f, ' <description>' + qryCategLongDesc.AsString + '</description>');
  while not qryAfoInCat.Eof do begin
    writeln(f, ' <item>');
    writeln(f, '  <description>' + qryAfoInCatAforisma.Value + '</description>');
    if (not qryAfoInCatCognome.IsNull) then begin
      if qryAfoInCatNome.IsNull then aut:= qryAfoInCatCognome.AsString
      else aut:= qryAfoInCatNome.AsString + ' ' + qryAfoInCatCognome.AsString;
      writeln(f, '  <author>' + aut + '</author>');
    end;
    writeln(f, ' </item>');
    qryAfoInCat.Next;
  end;
  writeln(f, '</channel>');
  writeln(f, '</rss>');
  CloseFile(f);
  qryAfoInCat.Active:= false;
end;

procedure TdmAforismi.ExportAsRSS;
var
  ini: TMemINIFile;
  CodGen: integer;
  CodCat: integer;
  genere: string;
  tmp: string;
begin
  ini:= TMemINIFile.Create(ExportPath + 'index.ini');
  try
    tbGeneri.Active:= true;
    tbGeneri.First;
    while not tbGeneri.Eof do begin
      CodGen:= tbGeneriCodGen.Value;
      tmp:= 'kind_' + IntToStr(CodGen);
      ini.WriteString(tmp, 'caption', '"' + tbGeneriDesc.AsString + '"');
      ini.WriteString(tmp, 'description', '"' + tbGeneriLongDesc.AsString + '"');
      ini.WriteString(tmp, 'categories', getCategories(CodGen));
      tbGeneri.Next;
    end;
    qryCateg.Active:= true;
    qryCateg.First;
    while not qryCateg.Eof do begin
      CodCat:= qryCategCodCat.Value;
      genere:= convert(qryCategDesc.Value);
      tmp:= 'category_' + IntToStr(CodCat);
      ini.WriteString(tmp, 'caption', Format('"%s (%d)"', [genere, qryCategConteggio.Value]));
      ini.WriteString(tmp, 'path', '"' + IntToStr(CodCat) + '.ini"');
      writeRSSwithCategoria(CodCat);
      qryCateg.Next;
    end;
  finally
    ini.UpdateFile;
    ini.Free;
    qryCateg.Active:= false;
    tbGeneri.Active:= false;
  end;
  notify('RSS exported');
end;

function TdmAforismi.wikiNL(var T: string): boolean;
begin
  T:= ReplaceStr(T, chr(10), chr(13));
  T:= ReplaceStr(T, chr(13) + chr(13), chr(13));
  Result:= Pos(chr(13), T) > 0;
  T:= ReplaceStr(T, chr(13), WIKI_NL);
end;

procedure TdmAforismi.ExportAsDokuWiki;
var
  f: TextFile;
  CodGen: integer;
  CodCat: integer;
  genere: string;
  hasNL: boolean;
  cat, tmp_afo, tmp_aut, tmp_tra, tmp_not, tmp_loc, tmp_sig, tmp_com: string;
begin
  tbGeneri.Active:= true;
  tbGeneri.First;
  while not tbGeneri.Eof do begin
    CodGen:= tbGeneriCodGen.Value;
    genere:= tbGeneriDesc.AsString;
    AssignFile(f, ExportPath + LowerCase(genere));
    Rewrite(f);
    writeln(f, '====== ' + genere + ' ======');
    qryCatInGen.Parameters.FindParam('CodGen').Value:= CodGen;
    qryCatInGen.Active:= true;
    qryCatInGen.First;
    while not qryCatInGen.Eof do begin
      CodCat:= qryCatInGenCodCat.Value;
      cat:= qryCatInGenDesc.AsString;
      notify('Exporting: ' + cat);
      writeln(f);
      writeln(f, '=====' + cat + '=====');
      qryAfoInCat.Parameters.FindParam('CodCat').Value:= CodCat;
      qryAfoInCat.Active:= true;
      qryAfoInCat.First;
      while not qryAfoInCat.Eof do begin
        tmp_afo:= qryAfoInCatAforisma.Value;
        tmp_tra:= qryAfoInCatTraduzione.Value;
        tmp_not:= qryAfoInCatNote.Value;
        tmp_sig:= qryAfoInCatSignificato.Value;
        tmp_com:= qryAfoInCatCommenti.Value;
        tmp_loc:= qryAfoInCatlocale.Value;
        if (not qryAfoInCatCognome.IsNull) then begin
          if qryAfoInCatNome.IsNull then tmp_aut:= qryAfoInCatCognome.AsString
          else tmp_aut:= qryAfoInCatNome.AsString + ' ' + qryAfoInCatCognome.AsString;
        end
        else tmp_aut:= '';
        if (tmp_afo <> '') then begin
          hasNL:= wikiNL(tmp_afo);
          hasNL:= hasNL or wikiNL(tmp_tra);
          writeln(f);
          if (tmp_tra <> '') then begin
            writeln(f, '//' + tmp_afo + '//\\');
            write(f, tmp_tra);
            hasNL:= true;
          end
          else begin
            write(f, tmp_afo);
          end;
          if (tmp_aut <> '') or (tmp_not <> '') then begin
            if (hasNL) then write(f, WIKI_NL)
            else write(f, ' ');
            write(f, '(//');
            if (tmp_aut <> '') then write(f, tmp_aut);
            if (tmp_aut <> '') and (tmp_not <> '') then write(f, ', ');
            if (tmp_not <> '') then write(f, tmp_not);
            write(f, '//)');
          end;
          writeln(f);
          if (tmp_sig <> '') then writeln(f, WIKI_NL + '//Significato: ' + tmp_sig + '//');
          if (tmp_com <> '') then writeln(f, WIKI_NL + '//' + tmp_com + '//');
        end;
        qryAfoInCat.Next;
      end;
      qryAfoInCat.Active:= false;
      qryCatInGen.Next;
    end;
    qryCatInGen.Active:= false;
    CloseFile(f);
    tbGeneri.Next;
  end;
  tbGeneri.Active:= false;
  notify('Wiki pages exported');
end;

procedure TdmAforismi.BuildSearchKey;
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
    notify(IntToStr(cnt));
    afo:= tbAforismiAforisma.Value;
    afo:= LowerCase(convert(afo));
    key:= '';
    wrd:= '';
    skip:= false;
    for i:= 1 to length(afo) do begin
      ch:= afo[i];
      if not(CharInSet(ch, ['a' .. 'z', '0' .. '9'])) then ch:= ' ';
      if (ch = ' ') then begin
        skip:= true;
      end
      else begin
        if (skip) then begin
          if (length(wrd) > 2) then begin
            key:= key + wrd + ' ';
          end;
          wrd:= '';
          skip:= false;
        end;
        wrd:= wrd + ch;
      end;
    end;
    if (length(wrd) > 2) then begin
      key:= key + wrd + ' ';
    end;
    tbAforismi.Edit;
    tbAforismiSearchKey.Value:= key;
    tbAforismiOrder.Value:= random(100000);
    tbAforismi.Post;
    tbAforismi.Next;
  end;
  tbAforismi.Active:= false;
  notify('Completed');
end;

end.
