unit PantallaEmpresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvLabel, Vcl.StdCtrls, ModuloDatos,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, JvButton, JvTransparentButton, acPNG,
  Vcl.ExtCtrls, JvExExtCtrls, JvImage, Vcl.ComCtrls, JvExComCtrls, JvStatusBar;

type
  TForm2 = class(TForm)
    gridEmpresas: TDBGridEh;
    btSeleccionar: TJvTransparentButton;
    JvImage1: TJvImage;
    JvStatusBar1: TJvStatusBar;
    JvTransparentButton1: TJvTransparentButton;
    procedure btSeleccionarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JvTransparentButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses PantallaPrincipal, AltaEmpresa, FormCambiaEmpleado;

procedure TForm2.btSeleccionarClick(Sender: TObject);
begin
  Close();
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
{  if DataModule1.QEmpresas.DataSource.DataSet.IsEmpty then
    ShowMessage('No hay Empresas.'+#10+'Debes crear al menos una empresa'+#10+'para empezar a trabajar');
    with TForm3.Create(nil) do
    begin
      ShowModal;
    end; }
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  JvStatusBar1.SimplePanel := True;
  JvStatusBar1.SimpleText := 'Selecciona una empresa para empezar.';
end;

procedure TForm2.JvTransparentButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
