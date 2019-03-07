unit FormConfiguracion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvButton, JvTransparentButton,
  Vcl.StdCtrls, JvExStdCtrls, JvEdit, JvExControls, JvLabel, inifiles, sDialogs,
  JvBaseDlg, JvSelectDirectory, JvDialogs;

type
  TConfiguracion = class(TForm)
    lbBaseDatos: TJvLabel;
    edBaseDatos: TJvEdit;
    lbRemesas: TJvLabel;
    edDirectorioRemesas: TJvEdit;
    btBaseDatos: TJvTransparentButton;
    btDirectorioRemesas: TJvTransparentButton;
    sdRemesa: TJvSelectDirectory;
    odBaseDatos: TJvOpenDialog;
    btSeleccionar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    procedure FormCreate(Sender: TObject);
    procedure escribirIni();
    procedure btDirectorioRemesasClick(Sender: TObject);
    procedure btBaseDatosClick(Sender: TObject);
    procedure btSeleccionarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Configuracion: TConfiguracion;

implementation

{$R *.dfm}

uses
  ModuloDatos, PantallaPrincipal;

procedure TConfiguracion.FormCreate(Sender: TObject);
begin
  edBaseDatos.Text := DataModule1.sBD;
  edDirectorioRemesas.Text := DataModule1.sPath;
end;


{*****************************************************************
************ PROCEDIMIENTOS GENÉRICOS DEL FORMULARIO *************
******************************************************************}

procedure TConfiguracion.escribirIni();
var
  appINI : TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  try
    //if no last user return an empty string
    appINI.WriteString('Params','BD',edBaseDatos.Text) ;
    //if no last date return todays date
    appINI.WriteString('Params', 'Path', edDirectorioRemesas.Text) ;
    //show the message
    //DataModule1.BaseDatos.Params.Database := sBD;
    if not directoryexists(DataModule1.sPath) then
      Createdir(DataModule1.sPath);
  finally
    appINI.Free;
  end;
end;

{*****************************************************************
*********************** CONTROL DE BOTONES ***********************
******************************************************************}

procedure TConfiguracion.btBaseDatosClick(Sender: TObject);
begin
  if(odBAseDAtos.Execute())then
    edBaseDatos.Text := odBAseDAtos.FileName;
end;

procedure TConfiguracion.btCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure TConfiguracion.btDirectorioRemesasClick(Sender: TObject);
begin
  if(sdRemesa.Execute()) then
  edDirectorioRemesas.Text := sdRemesa.Directory;
end;

procedure TConfiguracion.btSeleccionarClick(Sender: TObject);
begin
  DataModule1.sBD := edBaseDatos.Text;
  DataModule1.sPath := edDirectorioRemesas.Text;
  escribirIni();
  Close();
end;

end.
