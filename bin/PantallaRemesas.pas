unit PantallaRemesas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  JvExControls, JvButton, JvTransparentButton;

type
  TForm7 = class(TForm)
    gridRemesas: TDBGridEh;
    btSeleccionar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    procedure FormCreate(Sender: TObject);
    procedure btSeleccionarClick(Sender: TObject);
    procedure AbrirRemesa();
    procedure btCancelarClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.dfm}

uses
  ModuloDatos, Remesa, FormVerRemesa;

{******************************************************************
********************* CREACIÓN DEL FORMULARIO *********************
*******************************************************************}

procedure TForm7.FormCreate(Sender: TObject);
begin
  with DataModule1.QRemesas do
  begin
    if not Active then
      Open;
    Refresh;
  end;
end;

{******************************************************************
************ PROCEDIMIENTOS GENÉRICOS DEL FORMULARIO **************
*******************************************************************}

procedure TForm7.AbrirRemesa();
begin
  if not Assigned(VerRemesa) then
        VerRemesa := TVerRemesa.Create(Self);
  with VerRemesa do
  begin
//-------------- Control del estado de la ventana con TAG: 0 no creada.
    if Tag = 0 then
    begin
      remesaAMostrar := StrToInt(gridRemesas.Columns[0].DisplayText);
      Self.Hide;
      ShowModal();
    end
    else
    begin
      remesaAMostrar := StrToInt(gridRemesas.Columns[0].DisplayText);
      Tag := 1;
      Show();
    end;
  end;

  Close;
end;

{******************************************************************
********************* GESTIÓN DE LOS BOTONES **********************
*******************************************************************}

procedure TForm7.btCancelarClick(Sender: TObject);
begin
  gridRemesas.SearchPanel.CancelSearchFilter;
  Close();

end;

procedure TForm7.btSeleccionarClick(Sender: TObject);
begin
  gridRemesas.SearchPanel.CancelSearchFilter;
  AbrirRemesa;
end;

end.
