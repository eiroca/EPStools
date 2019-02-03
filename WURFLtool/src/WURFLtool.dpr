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
program WURFLtool;

uses
  Forms,
  FMain in 'gui\FMain.pas' {fmMain},
  uWURFL in '..\..\library\src\wurfl\uWURFL.pas',
  uWURFL2PHP in '..\..\library\src\wurfl\uWURFL2PHP.pas',
  uWURFL2TXT in '..\..\library\src\wurfl\uWURFL2TXT.pas',
  wurfl in '..\..\library\src\wurfl\wurfl.pas',
  eLibHashList in '..\..\library\src\eLib\eLibHashList.pas',
  FAboutGPL in '..\..\library\src\eLib\FAboutGPL.pas' {fmAboutGPL},
  uElab in '..\..\library\src\wurfl\uElab.pas',
  dWURFL2DB in 'model\dWURFL2DB.pas' {dmWURFL2DB: TDataModule},
  FWait in '..\..\library\src\eLib\FWait.pas' {fmWait},
  eLibVCL in '..\..\library\src\eLib\eLibVCL.pas',
  eLibCore in '..\..\library\src\eLib\eLibCore.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmWURFL2DB, dmWURFL2DB);
  Application.Run;
end.
