program WURFLtool;

uses
  Vcl.Forms,
  FMain in 'gui\FMain.pas' {fmMain},
  eLibCore in '..\..\library\src\eLib\eLibCore.pas',
  eLibHashList in '..\..\library\src\eLib\eLibHashList.pas',
  eLibVCL in '..\..\library\src\eLib\eLibVCL.pas',
  FAboutGPL in '..\..\library\src\eLib\FAboutGPL.pas' {fmAboutGPL},
  FWait in '..\..\library\src\eLib\FWait.pas' {fmWait},
  uElab in '..\..\library\src\wurfl\uElab.pas',
  uWURFL in '..\..\library\src\wurfl\uWURFL.pas',
  uWURFL2PHP in '..\..\library\src\wurfl\uWURFL2PHP.pas',
  uWURFL2TXT in '..\..\library\src\wurfl\uWURFL2TXT.pas',
  wurfl in '..\..\library\src\wurfl\wurfl.pas',
  dWURFL2DB in 'model\dWURFL2DB.pas' {dmWURFL2DB: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmWURFL2DB, dmWURFL2DB);
  Application.Run;
end.
