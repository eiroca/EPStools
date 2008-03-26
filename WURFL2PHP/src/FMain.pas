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
  uWURFL, fAbout,
  Forms, Menus, Classes, Controls, ComCtrls, StdCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    miWURFL2PHP: TMenuItem;
    sbStatus: TStatusBar;
    miWURFLLoad: TMenuItem;
    miWURFLClose: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    About1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miWURFL2PHPClick(Sender: TObject);
    procedure miWURFL2TXTClick(Sender: TObject);
    procedure miWURFLCloseClick(Sender: TObject);
    procedure miWURFLLoadClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
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

procedure TfmMain.WURFL_Open;
begin
  try
    mkdir(OUT_HANDSETPATH);
  except
  end;
  try
    wurfl:= TWURFL.Create('wurfl.xml');
    sbStatus.SimpleText:= wurfl.wurflxml.Version.Ver+' '+wurfl.wurflxml.Version.Last_updated+' loaded.';
    miWURFLLoad.Enabled:= false;
    miWURFLClose.Enabled:= true;
    miWURFL2PHP.Enabled:= true;
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
  miWURFL2PHP.Enabled:= false;
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

procedure TfmMain.About1Click(Sender: TObject);
begin
  About('WURFL2PHP');
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

procedure TfmMain.miWURFL2PHPClick(Sender: TObject);
begin
  wurfl.exportPHP(NotifyMessage);
end;

procedure TfmMain.miWURFL2TXTClick(Sender: TObject);
begin
  wurfl.exportTXT(NotifyMessage);
end;

end.

