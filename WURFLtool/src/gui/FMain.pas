(* GPL > 3.0
  Copyright (C) 1996-2014 eIrOcA Enrico Croce & Simona Burzio

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
unit FMain;

interface

uses
  uWURFL, uWURFL2PHP, uWURFL2TXT, FAboutGPL, Forms, Menus, Classes, Controls, ComCtrls, StdCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    sbStatus: TStatusBar;
    N1: TMenuItem;
    About1: TMenuItem;
    WURFL1: TMenuItem;
    miWURFLClose: TMenuItem;
    miWURFLExport: TMenuItem;
    miExportAsDB: TMenuItem;
    miExportAsTXT: TMenuItem;
    miExportAsPHP: TMenuItem;
    miWURFLLoad: TMenuItem;
    miExportProperties: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miWURFLCloseClick(Sender: TObject);
    procedure miWURFLLoadClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure miExportAsPHPClick(Sender: TObject);
    procedure miExportAsTXTClick(Sender: TObject);
    procedure miExportPropertiesClick(Sender: TObject);
    procedure miExportAsDBClick(Sender: TObject);
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

uses
  uElab, dWURFL2DB;

{$R *.dfm}

procedure TfmMain.WURFL_Open;
begin
  try
    mkdir(OUT_HANDSETPATH);
  except
  end;
  try
    wurfl:= TWURFL.Create('wurfl.xml');
    NotifyMessage(wurfl.wurflxml.Version.Ver + ' ' + wurfl.wurflxml.Version.Last_updated +
      ' loaded.');
    miWURFLLoad.Enabled:= false;
    miWURFLClose.Enabled:= true;
    miWURFLExport.Enabled:= true;
  except
    NotifyMessage('Unable to load wurfl.xml file');
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
end;

procedure TfmMain.miWURFLCloseClick(Sender: TObject);
begin
  WURFL_Close;
  NotifyMessage('WURFL file not loaded');
end;

procedure TfmMain.miWURFLLoadClick(Sender: TObject);
begin
  NotifyMessage('Loading WURFL...');
  WURFL_Open;
end;

procedure TfmMain.About1Click(Sender: TObject);
begin
  AboutGPL('WURFL2PHP');
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

procedure TfmMain.Load1Click(Sender: TObject);
begin
  WURFL_Open;
end;

procedure TfmMain.NotifyMessage(const aMsg: string);
begin
  sbStatus.SimpleText:= aMsg;
  Application.ProcessMessages;
end;

procedure TfmMain.miExportAsPHPClick(Sender: TObject);
var
  exporter: TPHPExporter;
begin
  exporter:= TPHPExporter.Create(wurfl, NotifyMessage);
  exporter.Export;
  exporter.Free;
end;

procedure TfmMain.miExportAsTXTClick(Sender: TObject);
var
  exporter: TTXTExporter;
begin
  exporter:= TTXTExporter.Create(wurfl, NotifyMessage);
  exporter.Export;
  exporter.Free;
end;

procedure TfmMain.miExportPropertiesClick(Sender: TObject);
var
  e: THandsetElab;
  s: TStrings;
begin
  e:= THandsetElab.Create('wurfl\wurfl.xml');
  try
    // s:= e.exportPropertyNames(NotifyMessage);
    // s.SaveToFile('wurfl\wurfl_properties.txt');
    s:= TStringList.Create;
    s.LoadFromFile('wurfl\wurfl_export.txt');
    e.exportProperties('wurfl\export.csv', s, nil);
  finally
    e.Free;
  end;
end;
    procedure TfmMain.miExportAsDBClick(Sender: TObject);
begin
  dmWURFL2DB.Run(wurfl);
end;


end.
