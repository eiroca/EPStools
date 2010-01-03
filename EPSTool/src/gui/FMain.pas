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
unit FMain;

interface

uses
  uWURFL,
  Forms, Menus, Classes, Controls, ComCtrls, StdCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    miWURFL2PHP: TMenuItem;
    miWURFL2DB: TMenuItem;
    miWURFL2TXT: TMenuItem;
    sbStatus: TStatusBar;
    WURFL1: TMenuItem;
    Aforismi1: TMenuItem;
    Portal1: TMenuItem;
    miWURFLLoad: TMenuItem;
    miWURFLExport: TMenuItem;
    miWURFLClose: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miWURFL2PHPClick(Sender: TObject);
    procedure miWURFL2TXTClick(Sender: TObject);
    procedure miWURFL2DBClick(Sender: TObject);
    procedure BuildSearchKey1Click(Sender: TObject);
    procedure GenerateConfig1Click(Sender: TObject);
    procedure GenerateRSS1Click(Sender: TObject);
    procedure Portal1Click(Sender: TObject);
    procedure miWURFLCloseClick(Sender: TObject);
    procedure miWURFLLoadClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    wurfl: TWURFL;
    procedure NotifyMessage(const aMsg: string);
    procedure WURFL_Open;
    procedure WURFL_Close;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  dWURFL2DB, DAforismi, FPortal, uElab;

procedure TfmMain.WURFL_Open;
begin
  try
    mkdir(OUT_HANDSETPATH);
  except
  end;
  try
    wurfl:= TWURFL.Create('wurfl\wurfl.xml');
    sbStatus.SimpleText:= wurfl.wurflxml.Version.Ver+' '+wurfl.wurflxml.Version.Last_updated+' loaded.';
    miWURFLLoad.Enabled:= false;
    miWURFLClose.Enabled:= true;
    miWURFLExport.Enabled:= true;
  except
    sbStatus.SimpleText:= 'Unable to load wurfl.xml file';
    WURFL_Close;
  end;
end;

procedure TfmMain.WURFL_Close;
begin
  wurfl.Free;
  wurfl:= nil;
  miWURFLLoad.Enabled:= true;
  miWURFLClose.Enabled:= false;
  miWURFLExport.Enabled:= false;
  sbStatus.SimpleText:= 'WURFL file not loaded';
end;

procedure TfmMain.miWURFLCloseClick(Sender: TObject);
begin
   WURFL_Close;
end;

procedure TfmMain.miWURFLLoadClick(Sender: TObject);
begin
  WURFL_Open;
end;

procedure TfmMain.Button1Click(Sender: TObject);
var
  e: THandsetElab;
  s: TStrings;
begin
  e:= THandsetElab.Create('wurfl\wurfl.xml');
  try
//    s:= e.exportPropertyNames(NotifyMessage);
//    s.SaveToFile('wurfl\wurfl_properties.txt');
    s:= TStringList.Create;
    s.LoadFromFile('wurfl\wurfl_export.txt');
    e.exportProperties('wurfl\export.csv', s, NotifyMessage);
  finally
    e.Free;
  end;
end;

procedure TfmMain.Button2Click(Sender: TObject);
var
  fi: TextFile;
  fo: TextFile;
  os: string;
  ns: string;

begin
  AssignFile(fi, 'wurfl\export_in.csv');
  AssignFile(fo, 'wurfl\export_out.csv');
  reset(fi);
  rewrite(fo);
  os:= '';
  while not eof(fi) do begin
    readln(fi, ns);
    if (os <> ns) then begin
      if (os<>'') then begin
        writeln(fo, os);
      end;
      os:= ns;
    end;
  end;
  if (os<>'') then begin
    writeln(fo, os);
  end;
  CloseFile(fi);
  CloseFile(fo);
end;

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  wurfl:= nil;
  WURFL_Close;
end;

procedure TfmMain.NotifyMessage(const aMsg: string);
begin
  sbStatus.SimpleText:= aMsg;
  Application.ProcessMessages;
end;

procedure TfmMain.Portal1Click(Sender: TObject);
begin
  TfmPortal.Create(self);
end;

procedure TfmMain.miWURFL2PHPClick(Sender: TObject);
begin
  wurfl.exportPHP(NotifyMessage);
end;

procedure TfmMain.miWURFL2TXTClick(Sender: TObject);
begin
  wurfl.exportTXT(NotifyMessage);
end;

procedure TfmMain.miWURFL2DBClick(Sender: TObject);
begin
  dmWURFL2DB.Run(wurfl);
end;

procedure TfmMain.BuildSearchKey1Click(Sender: TObject);
begin
  dmAforismi.BuildSearchKey(NotifyMessage);
end;

procedure TfmMain.GenerateConfig1Click(Sender: TObject);
begin
  dmAforismi.exportAsINI(NotifyMessage);
end;

procedure TfmMain.GenerateRSS1Click(Sender: TObject);
begin
  dmAforismi.exportAsRSS(NotifyMessage);
end;

end.

