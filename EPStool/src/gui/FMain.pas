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
  Forms, Menus, Classes, Controls, ComCtrls, StdCtrls;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    sbStatus: TStatusBar;
    Portal1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Portal1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  FPortal;

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.Portal1Click(Sender: TObject);
begin
  TfmPortal.Create(self);
end;

end.
