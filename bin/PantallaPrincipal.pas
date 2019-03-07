unit PantallaPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, Data.DB, Vcl.Grids,
  Vcl.DBGrids, JvExDBGrids, JvDBGrid, Vcl.StdCtrls, sButton, acFloatCtrls,
  JvExControls, JvButton, JvTransparentButton,ModuloDatos, JvLabel, Vcl.Mask,
  DBCtrlsEh, AltaEmpresa, AltaEmpleado, PantallaEmpresa, Firedac.Stan.Param,
  JvNavigationPane, Vcl.ComCtrls, JvExComCtrls, JvStatusBar, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, Vcl.DBCtrls, JvDBCheckBox, JvExStdCtrls, JvCheckBox, Vcl.Menus,
  JvMenus, Vcl.Buttons, JvExButtons, JvButtons, JvgButton, JvDialogs, JvGroupBox,
  AdvGroupBox;

type
  TForm1 = class(TForm)
    btAddEmpresa: TJvTransparentButton;
    btEditEmpresa: TJvTransparentButton;
    lbEmpresa: TJvLabel;
    edEmpresa: TDBEditEh;
    lbNif: TJvLabel;
    edCif: TDBEditEh;
    btAddEmpleado: TJvTransparentButton;
    btSiguienteEmpresa: TJvTransparentButton;
    btAnteriorEmpresa: TJvTransparentButton;
    BarraEstado: TJvStatusBar;
    btEditEmpleado: TJvTransparentButton;
    gridEmpleados: TDBGridEh;
    cbTodos: TJvCheckBox;
    Menu: TJvMainMenu;
    A1: TMenuItem;
    A2: TMenuItem;
    E1: TMenuItem;
    A3: TMenuItem;
    E2: TMenuItem;
    E3: TMenuItem;
    sSkinManager1: TsSkinManager;
    btSiguienteEmpleado: TJvTransparentButton;
    btAnteriorEmpleado: TJvTransparentButton;
    btNuevaRemesa: TJvTransparentButton;
    C1: TMenuItem;
    E4: TMenuItem;
    gr: TJvOpenDialog;
    grEmpresa: TAdvGroupBox;
    grEmpleados: TAdvGroupBox;
    CambiarEmpleado: TMenuItem;
    JvTransparentButton1: TJvTransparentButton;
    a4: TMenuItem;
    lbCodigo: TJvLabel;
    edCodEmpresa: TDBEditEh;
    B1: TMenuItem;
    btBuscar: TJvTransparentButton;
    procedure btAddEmpresaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAddEmpleadoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btSiguienteEmpresaClick(Sender: TObject);
    procedure btAnteriorEmpresaClick(Sender: TObject);
    procedure btEditEmpleadoClick(Sender: TObject);
    procedure cbTodosClick(Sender: TObject);
    procedure MenuAltaEmpresa(Sender: TObject);
    procedure btEditEmpresaClick(Sender: TObject);
    procedure MenuModificaEmpresa(Sender: TObject);
    procedure MenuAltaEmpleado(Sender: TObject);
    procedure MenuModificarEmpleado(Sender: TObject);
    procedure btSiguienteEmpleadoClick(Sender: TObject);
    procedure btAnteriorEmpleadoClick(Sender: TObject);
    procedure btNuevaRemesaClick(Sender: TObject);
    procedure gridEmpleadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure E4Click(Sender: TObject);
    procedure MenuCambiaEmpleado(Sender: TObject);
    procedure c2Click(Sender: TObject);
    procedure MenuAcercade(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure btBuscarClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;
  codEmpresa : Integer;

implementation

{$R *.dfm}

uses
  Remesa, FormAcercaDe, FormCambiaEmpleado, System.UITypes,
  PantallaRemesas, FormVerRemesa, FormConfiguracion;

{*****************************************************************
************ PROCEDIMIENTOS GENÉRICOS DEL FORMULARIO *************
******************************************************************}

procedure AltaEmpresa();
begin
  with TForm3.Create(nil) do
  begin
    Tag := 1; //Marcar estado del formulario (1: Alta de nuevos datos)
    ShowModal;
  end;
end;

procedure ModificaEmpresa();
begin
  with TForm3.Create(nil) do
  begin
    Tag := 2;  //Marcar estado del formulario (2: Modificación de datos)
    Caption := 'Ver datos Empresa';
    btPrevEmpresa.Visible := True;
    btNextEmpresa.Visible := True;
    ShowModal;
  end;
end;

procedure AltaEmpleado();
begin
  with TForm4.Create(nil) do
  begin
    Tag := 1; //Marcar estado del formulario (1: Alta de nuevos datos)
    ShowModal;
  end;
end;

procedure ModificaEmpleado();
begin
  with TForm4.Create(nil) do
  begin
    Tag := 2;  //Marcar estado del formulario (2: Modificación de datos)
    Caption := 'Modificar Datos Empleados';
    btAntEmpleado.Visible := True;
    btSgteEmpleado.Visible := True;
    cbBaja.Visible := True;
    ShowModal;
  end;
end;

procedure CambiaEmpleado();
begin
  If (MessageDlg('Va a cambiar un empleado de empresa. ¿Desea continuar?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    with TCambiaEmpleado.Create(nil) do
    begin
      Show();
    end;
  end
end;

{*****************************************************************
**************** INICIALIZACIÓN DE LA APLICACIÓN *****************
******************************************************************}

procedure TForm1.FormCreate(Sender: TObject);
begin
  with ModuloDatos.DataModule1 do
  begin
    BaseDatos.Connected := true;
    if not fileexists(BaseDatos.Params.Database) then
      ShowMessage('No existe la base de datos'+BaseDatos.Params.Database);
    BaseDatos.Connected:=True;
    DSEmpresas.Enabled:=True;
    QEmpresas.Active:=True;
    DSTodosEmpleados.Enabled :=True;
    QTodosEmpleados.Active := True;
    BarraEstado.SimplePanel := True;
  end;
  if ModuloDatos.DataModule1.DSEmpresas.DataSet.IsEmpty then
  begin
      AltaEmpresa;
  end
  else
  begin
    with PantallaEmpresa.TForm2.Create(nil) do
    begin
      ShowModal;
    end;
  end;
  with DataModule1.QTodosEmpleados do
    begin
      Close;
      ParamByName('empresa').AsInteger := DataModule1.QEmpresas.FieldByName('CODEMPRESA').AsInteger;
      SQL.Add('and activo = 1');
      Open;
    end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if cbTodos.Checked then
  begin
    with DataModule1.QTodosEmpleados do
    begin
      Close;
      ParamByName('empresa').AsInteger := DataModule1.QEmpresas.FieldByName('CODEMPRESA').AsInteger;
      SQL.Add('and activo = 1');
      Prepare;
      Active;
      Open;
    end;
  end
  else
  begin
    with DataModule1.QEmpleados do
    begin
      Close;
      ParamByName('empresa').AsInteger := DataModule1.QEmpresas.FieldByName('CODEMPRESA').AsInteger;
      Open;
    end;
  end;
end;

procedure TForm1.gridEmpleadosDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
begin
  with sender as Tdbgrideh do
 begin
   if DataModule1.QTodosEmpleados['ACTIVO'] = 0 then
     canvas.font.Color := clSilver;
   DefaultDrawColumnCell(rect,datacol,column,state);
 end;
end;




procedure TForm1.MenuCambiaEmpleado(Sender: TObject);
begin
  CambiaEmpleado();
end;

procedure TForm1.btNuevaRemesaClick(Sender: TObject);
begin
  with Tform6.Create(self) do
  begin
    ShowModal;
  end;
end;

{*****************************************************************
***************** CONTROL BOTONES DE LA EMPRESA ******************
******************************************************************}

procedure TForm1.btAddEmpresaClick(Sender: TObject);
begin
  AltaEmpresa();
end;

procedure TForm1.btEditEmpresaClick(Sender: TObject);
begin
  ModificaEmpresa();
end;

procedure TForm1.btAnteriorEmpresaClick(Sender: TObject);
begin
  with DataModule1 do
  begin
    with QEmpresas do
    begin
      if Active then
      begin
        if not Bof then
        begin
          Prior;
          if BarraEstado.SimpleText <> '' then
            BarraEstado.SimpleText := '';
        end
        else
        begin
          BarraEstado.SimpleText := 'Ya se está mostrando el primer registro';
        end;
      end;
    end;
    if cbTodos.Checked then
    begin
      with QTodosEmpleados do
      begin
        Close;
        ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
        Open;
      end;
    end
    else
    begin
      with QTodosEmpleados do
      begin
        Close;
        ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
        Open;
      end;
    end;
  end;
end;

procedure TForm1.btBuscarClick(Sender: TObject);
begin
  with TForm7.Create(nil) do
  begin
    ShowModal;
  end;
end;

procedure TForm1.btSiguienteEmpresaClick(Sender: TObject);
begin
  with DataModule1 do
  begin
    with QEmpresas do
    begin
      if Active then
      begin
        if not Eof then
        begin
          Next;
          if BarraEstado.SimpleText <> '' then
            BarraEstado.SimpleText := '';
        end
        else
        begin
          BarraEstado.SimpleText := 'Ya se está mostrando el último registro';
        end;
      end;
    end;
    if cbTodos.Checked then
    begin
      with QTodosEmpleados do
      begin
        Close;
        ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
        Open;
      end;
    end
    else
    begin
      with QTodosEmpleados do
      begin
        Close;
        ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
        Open;
      end;
    end;
  end;
end;

//BOTONES DE MENÚS:
procedure TForm1.MenuAltaEmpresa(Sender: TObject);
begin
  AltaEmpresa();
end;

procedure TForm1.MenuModificaEmpresa(Sender: TObject);
begin
  ModificaEmpresa;
end;

procedure TForm1.B1Click(Sender: TObject);
begin
  with TForm7.Create(nil) do
  begin
    ShowModal;
  end;
end;

procedure TForm1.MenuModificarEmpleado(Sender: TObject);
begin
  ModificaEmpleado();
end;

procedure TForm1.MenuAltaEmpleado(Sender: TObject);
begin
  AltaEmpleado;
end;

procedure TForm1.MenuAcercade(Sender: TObject);
begin
  with TAcercaDe.Create(nil) do
  begin
    ShowModal();
  end;
end;

{*****************************************************************
***************** CONTROL BOTONES DE EMPLEADOS *******************
******************************************************************}


procedure TForm1.btAddEmpleadoClick(Sender: TObject);
begin
  AltaEmpleado();
end;

procedure TForm1.btEditEmpleadoClick(Sender: TObject);
begin
  ModificaEmpleado();
end;

procedure TForm1.btSiguienteEmpleadoClick(Sender: TObject);
begin
  if BarraEstado.SimpleText <> '' then
    BarraEstado.SimpleText := '';
  if not gridEmpleados.DataSource.DataSet.Eof then
  begin
    gridEmpleados.DataSource.DataSet.Next;
  end
  else
  begin
    BarraEstado.SimpleText := 'Estás en el último registro';
  end;
end;

procedure TForm1.btAnteriorEmpleadoClick(Sender: TObject);
begin
  if BarraEstado.SimpleText <> '' then
    BarraEstado.SimpleText := '';
  if gridEmpleados.DataSource.DataSet.Bof = false then
  begin
    gridEmpleados.DataSource.DataSet.Prior;
  end
  else
  begin
    BarraEstado.SimpleText := 'Estás visualizando el primer registro.';
  end;
end;

procedure TForm1.c2Click(Sender: TObject);
begin
  CambiaEmpleado;
end;

procedure TForm1.cbTodosClick(Sender: TObject);
begin
  if cbTodos.Checked then
  begin
    with DataModule1.QTodosEmpleados do
    begin
      if Active then
        Close;
      ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('codempresa').AsInteger;
      SQL[13] := '';
      Open;
    end;
  end
  else
  begin
    with DataModule1.QTodosEmpleados do
    begin
      if Active then
        Close;
      SQL[13] := 'and activo = 1';
      Prepare;
      Open;
    end;
  end;
end;

procedure TForm1.E4Click(Sender: TObject);
begin
  with TConfiguracion.Create(nil) do
    ShowModal();
end;

end.
