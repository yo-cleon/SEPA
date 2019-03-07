program Sepa;

uses
  Vcl.Forms,
  PantallaPrincipal in 'PantallaPrincipal.pas' {Form1},
  ModuloDatos in 'ModuloDatos.pas' {DataModule1: TDataModule},
  PantallaEmpresa in 'PantallaEmpresa.pas' {Form2},
  AltaEmpresa in 'AltaEmpresa.pas' {Form3},
  AltaEmpleado in 'AltaEmpleado.pas' {Form4},
  Remesa in 'Remesa.pas' {Form6},
  PantallaRemesas in 'PantallaRemesas.pas' {Form7},
  FormAcercaDe in 'FormAcercaDe.pas' {AcercaDe},
  FormCambiaEmpleado in 'FormCambiaEmpleado.pas' {CambiaEmpleado},
  FormVerRemesa in 'FormVerRemesa.pas' {VerRemesa},
  FormConfiguracion in 'FormConfiguracion.pas' {Configuracion},
  PantallaBuscaEmpresa in 'PantallaBuscaEmpresa.pas' {BuscaEmpresa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
