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
program EPSTool;

uses
  Forms,
  DAforismi in 'gui\DAforismi.pas' {dmAforismi: TDataModule},
  dWURFL2DB in 'gui\dWURFL2DB.pas' {dmWURFL2DB: TDataModule},
  FPortal in 'gui\FPortal.pas' {fmPortal},
  FMain in 'gui\FMain.pas' {fmMain},
  eVCLUtil in 'dep\eVCLUtil.pas',
  eWait in 'dep\eWait.pas' {fmWait},
  uEPSUtil in 'lib\uEPSUtil.pas',
  uElab in 'lib\uElab.pas',
  wurfl in '..\..\library\src\lib\wurfl.pas',
  uWURFL in '..\..\library\src\lib\uWURFL.pas',
  FAbout in '..\..\library\mirror\FAbout.pas' {fmAbout},
  eHashList in '..\..\library\mirror\eHashList.pas',
  uWURFL2TXT in '..\..\library\src\lib\uWURFL2TXT.pas',
  uWURFL2PHP in '..\..\library\src\lib\uWURFL2PHP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmWURFL2DB, dmWURFL2DB);
  Application.CreateForm(TdmAforismi, dmAforismi);
  Application.CreateForm(TdmWURFL2DB, dmWURFL2DB);
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
