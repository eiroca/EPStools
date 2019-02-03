unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, uWURFL, uWURFL2PHP, uWURFL2TXT,
  uElab;

type
  TfmMain = class(TForm)
    sbStatus: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    About1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    WURFL1: TMenuItem;
    miWURFLLoad: TMenuItem;
    miWURFLExport: TMenuItem;
    miExportAsPHP: TMenuItem;
    miExportAsTXT: TMenuItem;
    miExportAsDB: TMenuItem;
    miExportProperties: TMenuItem;
    miWURFLClose: TMenuItem;
    odWURL: TFileOpenDialog;
    odDB: TFileOpenDialog;
    odProperties: TFileOpenDialog;
    MainMenu2: TMainMenu;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure miWURFLLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miWURFLCloseClick(Sender: TObject);
    procedure miExportAsPHPClick(Sender: TObject);
    procedure miExportAsTXTClick(Sender: TObject);
    procedure miExportPropertiesClick(Sender: TObject);
    procedure miExportAsDBClick(Sender: TObject);
  private
    { Private declarations }
    wurfl: TWURFL;
    procedure NotifyMessage(const aMsg: string);
    procedure WURFL_Open(const path: string);
    procedure WURFL_Close;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
  FAboutGPL, wurfl, dWURFL2DB;

{$R *.dfm}

const
  OUT_HANDSETPATH = 'export\';

procedure TfmMain.NotifyMessage(const aMsg: string);
begin
  sbStatus.SimpleText:= aMsg;
  Application.ProcessMessages;
end;

procedure TfmMain.WURFL_Open(const path: string);
begin
  try
    mkdir(OUT_HANDSETPATH);
  except
  end;
  try
    wurfl:= TWURFL.Create(path);
    NotifyMessage(wurfl.wurflxml.Version.Ver + ' ' + wurfl.wurflxml.Version.Last_updated +
      ' loaded.');
    miWURFLLoad.Enabled:= false;
    miWURFLClose.Enabled:= true;
    miWURFLExport.Enabled:= true;
  except
    on E: Exception do begin
      NotifyMessage('Unable to load wurfl.xml file: ' + E.Message);
      WURFL_Close;
    end;
  end;
end;

procedure TfmMain.WURFL_Close;
begin
  FreeAndNil(wurfl);
  miWURFLLoad.Enabled:= true;
  miWURFLClose.Enabled:= false;
  miWURFLExport.Enabled:= false;
end;

procedure TfmMain.About1Click(Sender: TObject);
begin
  AboutGPL(fmMain.Caption);
end;

procedure TfmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  WURFL_Close;

end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  WURFL_Close;
end;

procedure TfmMain.miWURFLCloseClick(Sender: TObject);
begin
  WURFL_Close;
  NotifyMessage('WURFL file not loaded');
end;

procedure TfmMain.miWURFLLoadClick(Sender: TObject);
begin
  NotifyMessage('Loading WURFL...');
  if (odWURL.Execute) then begin
    WURFL_Open(odWURL.FileName);
  end;
end;

procedure TfmMain.miExportAsPHPClick(Sender: TObject);
var
  exporter: TPHPExporter;
begin
  exporter:= TPHPExporter.Create(wurfl, NotifyMessage);
  exporter.Export(OUT_HANDSETPATH);
  exporter.Free;
end;

procedure TfmMain.miExportAsTXTClick(Sender: TObject);
var
  exporter: TTXTExporter;
begin
  exporter:= TTXTExporter.Create(wurfl, NotifyMessage);
  exporter.Export(OUT_HANDSETPATH);
  exporter.Free;
end;

procedure TfmMain.miExportPropertiesClick(Sender: TObject);
var
  E: THandsetElab;
  s: TStrings;
begin
  if (odWURL.Execute) and (odProperties.Execute) then begin
    E:= THandsetElab.Create(odWURL.FileName);
    try
      // s:= e.exportPropertyNames(NotifyMessage);
      // s.SaveToFile('wurfl\wurfl_properties.txt');
      s:= TStringList.Create;
      s.LoadFromFile(odProperties.FileName);
      E.exportProperties(OUT_HANDSETPATH + 'export.csv', s, NotifyMessage);
    finally
      E.Free;
    end;
  end;
end;

procedure TfmMain.miExportAsDBClick(Sender: TObject);
begin
  if odDB.Execute then begin
    dmWURFL2DB.OpenDB(odDB.FileName);
    dmWURFL2DB.Run(wurfl);
  end;
end;

end.
