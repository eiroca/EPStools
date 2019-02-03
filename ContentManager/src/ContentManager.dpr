program ContentManager;

uses
  Vcl.Forms,
  FMain in 'gui\FMain.pas' {fmMain},
  DAforismi in 'model\DAforismi.pas' {dmAforismi: TDataModule},
  uUtils in '..\..\library\src\uUtils.pas',
  FAboutGPL in '..\..\library\src\eLib\FAboutGPL.pas' {fmAboutGPL};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmAforismi, dmAforismi);
  Application.Run;
end.
