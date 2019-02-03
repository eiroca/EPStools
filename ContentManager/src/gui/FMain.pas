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
unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Actions, Vcl.ActnList, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ComCtrls;

type
  TfmMain = class(TForm)
    odDB: TFileOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Aforismi1: TMenuItem;
    OpenDB1: TMenuItem;
    ActionManager1: TActionManager;
    aOpenAforismi: TAction;
    aExportAforismiAsRSS: TAction;
    exportasINI1: TMenuItem;
    sbStatus: TStatusBar;
    aExportAforismiAsINI: TAction;
    ExportasRSS1: TMenuItem;
    aExportAforismiAsDokuWiki: TAction;
    ExportasDokuWiki1: TMenuItem;
    aGenerateOrderAforimi: TAction;
    Randomizeorder1: TMenuItem;
    N1: TMenuItem;
    aAbout: TAction;
    About1: TMenuItem;
    aExit: TAction;
    Exit1: TMenuItem;
    procedure aOpenAforismiExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure aExportAforismiAsINIExecute(Sender: TObject);
    procedure aExportAforismiAsRSSExecute(Sender: TObject);
    procedure aExportAforismiAsDokuWikiExecute(Sender: TObject);
    procedure aGenerateOrderAforimiExecute(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure aAboutExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
  private
    { Private declarations }
    exportPath: string;
    procedure NotifyMessage(const aMsg: string);
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  DAforismi, FAboutGPL;

procedure TfmMain.NotifyMessage(const aMsg: string);
begin
  sbStatus.SimpleText:= aMsg;
  Application.ProcessMessages;
end;

procedure TfmMain.aOpenAforismiExecute(Sender: TObject);
begin
  if (odDB.Execute) then begin
    if (dmAforismi.Open(odDB.FileName)) then begin
      dmAforismi.exportPath:= exportPath;
      dmAforismi.CallBack:= NotifyMessage;
      aExportAforismiAsINI.Enabled:= true;
      aExportAforismiAsRSS.Enabled:= true;
      aExportAforismiAsDokuWiki.Enabled:= true;
      aGenerateOrderAforimi.Enabled:= true;

    end;
  end;
end;

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.aGenerateOrderAforimiExecute(Sender: TObject);
begin
  dmAforismi.BuildSearchKey;
end;

procedure TfmMain.aAboutExecute(Sender: TObject);
begin
  AboutGPL('Content Manager');
end;

procedure TfmMain.aExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.aExportAforismiAsDokuWikiExecute(Sender: TObject);
begin
  dmAforismi.ExportAsDokuWiki;
end;

procedure TfmMain.aExportAforismiAsINIExecute(Sender: TObject);
begin
  dmAforismi.ExportAsINI;
end;

procedure TfmMain.aExportAforismiAsRSSExecute(Sender: TObject);
begin
  dmAforismi.ExportAsRSS;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  exportPath:= extractFilePath(Application.ExeName) + 'export\';
  aExportAforismiAsINI.Enabled:= false;
  aExportAforismiAsRSS.Enabled:= false;
  aExportAforismiAsDokuWiki.Enabled:= false;
  aGenerateOrderAforimi.Enabled:= false;
end;

end.
