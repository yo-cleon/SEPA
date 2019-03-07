unit FormCambiaEmpleado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  JvExControls, JvLabel, JvExStdCtrls, JvEdit, JvButton, JvTransparentButton,
  AdvGroupBox;

type
  TCambiaEmpleado = class(TForm)
    lbEmpleado: TJvLabel;
    lbNombreNuevaEmp: TJvLabel;
    Label1: TLabel;
    Label2: TLabel;
    edAnteriorEmpresa: TJvEdit;
    lbNombreAnteriorEmp: TLabel;
    edNuevaEmpresa: TJvEdit;
    Label4: TLabel;
    btConfirmar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    AdvGroupBox1: TAdvGroupBox;
    btBuscar: TJvTransparentButton;
    procedure FormActivate(Sender: TObject);
    procedure edNuevaEmpresaExit(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btConfirmarClick(Sender: TObject);
    procedure btBuscarClick(Sender: TObject);
  private
    { Private declarations }
    codempleado : integer;
  public
    { Public declarations }
  end;

var
  CambiaEmpleado: TCambiaEmpleado;

implementation

{$R *.dfm}

uses ModuloDatos, PantallaEmpresa, PantallaPrincipal, FireDAC.Stan.Param,
      PantallaBuscaEmpresa;

{******************************************************************
********************* CREACIÓN DEL FORMULARIO *********************
*******************************************************************}

procedure TCambiaEmpleado.FormActivate(Sender: TObject);
var
  empleado, nombreEmpresa : string;
begin
  if Tag = 0  then
  begin
    Tag := 999;
    with DataModule1 do
    begin
      with QTodosEmpleados do
      begin
        codempleado := FieldByName('CodEmpleado').AsInteger;
        empleado := codempleado.ToString;
        empleado := empleado + ' - ';
        empleado := empleado + FieldByName('Nombre').AsString;
        empleado := empleado+' '+FieldByName('Apellidos').AsString;
      end;
//      lbCodEmpleado.Caption := IntToStr(CodEmpleado);
      lbEmpleado.Caption :=  empleado;
      edAnteriorEmpresa.Text := IntToStr(QTodosEmpleados.FieldByName('codempresa').AsInteger);
      with QUnaEmpresa do
      begin
        if Active then
          Close;
        ParamByName('empresa').Value := StrToInt(edAnteriorEmpresa.Text);
        Open();
        nombreEmpresa := FieldByName('nombre').AsString;
      end;
      lbNombreAnteriorEmp.Caption := nombreEmpresa;
    end;
    edNuevaEmpresa.SetFocus;
  end;
end;


procedure TCambiaEmpleado.btBuscarClick(Sender: TObject);
begin
  with TBuscaEmpresa.Create(self) do
  begin
    ShowModal;
  end;
end;

procedure TCambiaEmpleado.btCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure TCambiaEmpleado.btConfirmarClick(Sender: TObject);
begin
  with DataModule1.QCambiaEmpleado do
  begin
    if Active then
      Close();
    ParamByName('nuevaempresa').Value := StrToInt(edNuevaEmpresa.Text);
    ParamByName('empleado').Value := codempleado;//StrToInt(lbCodEmpleado.Caption);
    ExecSQL;
    if RowsAffected = 1 then
    begin
      DataModule1.QTodosEmpleados.Refresh;
      showMessage('Proceso ejecutado correctamente.');
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TCambiaEmpleado.edNuevaEmpresaExit(Sender: TObject);
begin
  if StrToInt(edNuevaEmpresa.Text) <> StrtoInt(edAnteriorEmpresa.Text) then
  begin
      with DataModule1.QUnaEmpresa do
      begin
        if Active then
          Close;
        ParamByName('empresa').Value := StrToInt(edNuevaEmpresa.Text);
        Open;
        if RowsAffected = 0 then
        begin
          showMessage('Ninguna empresa coincide con el código indicado');
          edNuevaEmpresa.Text := '';
          edNuevaEmpresa.SetFocus;
        end
        else
        begin
          lbNombreNuevaEmp.Caption := FieldByName('Nombre').AsString;
          edNuevaEmpresa.SetFocus;
        end;
      end;
  end
  else
  begin
    showMessage('Los códigos de empresa no pueden ser iguales');
    edNuevaEmpresa.Text := '';
    edNuevaEmpresa.SetFocus;
  end;
end;

end.
