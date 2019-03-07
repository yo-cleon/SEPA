unit PantallaBuscaEmpresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  JvExControls, JvButton, JvTransparentButton;

type
  TBuscaEmpresa = class(TForm)
    gridEmpresas: TDBGridEh;
    btConfirmar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    procedure btConfirmarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BuscaEmpresa: TBuscaEmpresa;

implementation

{$R *.dfm}

uses
  ModuloDatos, FormCambiaEmpleado;

procedure TBuscaEmpresa.btCancelarClick(Sender: TObject);
begin
  gridEmpresas.RestoreVertPos('CODEMPRESA');
  close;
end;

procedure TBuscaEmpresa.btConfirmarClick(Sender: TObject);
begin
//  CambiaEmpleado.edNuevaempresa.Text := gridEmpresas.Columns[0].DisplayText;
  showMessage(CambiaEmpleado.edAnteriorEmpresa.Text);
  gridEmpresas.RestoreVertPos('CODEMPRESA');
  Close;
end;

procedure TBuscaEmpresa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gridEmpresas.RestoreVertPos('CODEMPRESA');
end;

procedure TBuscaEmpresa.FormCreate(Sender: TObject);
begin
  gridEmpresas.SaveVertPos('CODEMPRESA');
end;

end.
