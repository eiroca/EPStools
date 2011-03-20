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
program WURFL2PHP;

uses
  Forms,
  eHashList in '..\..\library\mirror\eHashList.pas',
  FAbout in '..\..\library\mirror\FAbout.pas' {fmAbout},
  FMain in 'gui\FMain.pas' {fmMain},
  uWURFL in '..\..\library\src\lib\uWURFL.pas',
  wurfl in '..\..\library\src\lib\wurfl.pas',
  uWURFL2PHP in '..\..\library\src\lib\uWURFL2PHP.pas',
  uWURFL2TXT in '..\..\library\src\lib\uWURFL2TXT.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
