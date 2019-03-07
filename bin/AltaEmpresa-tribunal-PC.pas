unit AltaEmpresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvLabel, Vcl.StdCtrls,
  Vcl.Mask, DBCtrlsEh, Vcl.DBCtrls, JvDBCheckBox, ModuloDatos, JvButton,
  JvTransparentButton, Firedac.Stan.Param, Data.DB, Vcl.Grids, Vcl.DBGrids,
  JvDotNetControls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ComCtrls;

type
  TForm3 = class(TForm)
    lbCodigo: TJvLabel;
    lbCif: TJvLabel;
    lbNombre: TJvLabel;
    edCodigo: TDBEditEh;
    edNombre: TDBEditEh;
    lbDireccion: TJvLabel;
    edDireccion: TDBEditEh;
    lbCodPostal: TJvLabel;
    edCodPostal: TDBEditEh;
    lbLocalidad: TJvLabel;
    edLocalidad: TDBEditEh;
    btGuardar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    btAddCuenta: TJvTransparentButton;
    edCif: TDBEditEh;
    btPrevEmpresa: TJvTransparentButton;
    btNextEmpresa: TJvTransparentButton;
    JvTransparentButton1: TJvTransparentButton;
    DBGridEh1: TDBGridEh;
    BarraEstado: TStatusBar;
    procedure btCancelarClick(Sender: TObject);
    procedure btGuardarClick(Sender: TObject);
    procedure btAddCuentaClick(Sender: TObject);
    procedure edCifExit(Sender: TObject);
    procedure MAYUSCULAS(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btPrevEmpresaClick(Sender: TObject);
    procedure btNextEmpresaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
//    CodEmpresaForm3 : Integer;
  end;

var
  Form3: TForm3;
  CodEmpresaForm3 : Integer;

implementation

{$R *.dfm}

uses Cuentas, PantallaPrincipal;


//INICIALIZACION DE FORMULARIO
procedure TForm3.FormActivate(Sender: TObject);
begin
{  if (btGuardar.Caption = 'Modificar') then
  begin
    codEmpresaForm3 := codEmpresa;
    edCodigo.Text := IntToStr(codEmpresaForm3);
    with DataModule1 do
    begin
      with QUnaEmpresa do
      begin
        if (Active = true) then
          Close;
        ParamByName('empresa').Value := codEmpresaForm3;
        Open;
        edCif.Text := FieldByName('CIF').AsString;
        edNombre.Text := FieldByName('NOMBRE').AsString;
        edDireccion.Text := FieldByName('DIRECCION').AsString;
        edCodPostal.Text := FieldByName('CP').AsString;
        edLocalidad.Text := FieldByName('LOCALIDAD').AsString;
        edCif.SetFocus;
        Edit;
      end;
      with QCuentasEmpresa do
      begin
        if (Active = true) then
          Close;
        ParamByName('EMPRESA').Value := codEmpresaForm3;
        Open;
      end;
    end;
  end
  else
  begin
    with DataModule1.QUltimaEmpresa do
    begin
      Open();
      codEmpresaForm3 := FieldByName('UltimaEmpresa').AsInteger+1;
      edCodigo.Text := inttostr(CodEmpresaForm3);
    end;
  end;  }
end;

//PROCEDIMIENTOS GENERALES DE FUNCIONAMIENTO
procedure TForm3.MAYUSCULAS(Sender: TObject);
begin
  edCif.Text := UpperCase(edCif.Text);
  edNombre.Text := UpperCase(edNombre.Text);
  edDireccion.Text := UpperCase(edDireccion.Text);
  edLocalidad.Text := UpperCase(edLocalidad.Text);
end;

function LetraNIF(Numero: Integer): string;
begin
  Result:= copy('TRWAGMYFPDXBNJZSQVHLCKET',1 + numero mod 23,1);
end;

function EsNIFCorrecto(NIF: String): Boolean;
var
  Numero: Integer;
begin
  Result:= FALSE;
  if Length(NIF) = 9 then
  begin
    // Normal
    if TryStrToInt(Copy(NIF,1,Length(NIF)-1),Numero) then
      Result:= Uppercase(Copy(NIF,Length(NIF),1)) = LetraNIF(Numero);
    // Extranjero
    if Uppercase(Copy(NIF,1,1)) = 'X' then
      if TryStrToInt(Copy(NIF,2,Length(NIF)-1),Numero) then
        Result:= Uppercase(Copy(NIF,Length(NIF),1)) = LetraNIF(Numero);
  end;
end;

procedure TForm3.edCifExit(Sender: TObject);
begin
  if NOT EsNIFCorrecto(edCif.Text)then
  begin
    showMessage('El nif introducido es incorrecto.');
    edCif.SetFocus;
  end;
end;

//CONTROL DE BOTONES
procedure TForm3.btPrevEmpresaClick(Sender: TObject);
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
    with QCuentasEmpresa do
    begin
      Close;
      ParamByName('empresa').Value := QEmpresas.FieldByName('CODEMPRESA').Value;
      Open;
    end;
  end;
end;

procedure TForm3.btNextEmpresaClick(Sender: TObject);
var
  UltimaEmpresa : Integer;
begin
  with DataModule1 do
  begin
    with QUltimaEmpresa do
    begin
      Active := True;
      UltimaEmpresa := FieldByName('UltimaEmpresa').AsInteger;
      if (CodEmpresaForm3 < UltimaEmpresa) then
      begin
        CodEmpresaForm3 := CodEmpresaForm3+1;
        with QUnaEmpresa do
        begin
          if Active then
            Close;
          ParamByName('empresa').Value := codEmpresaForm3;
          Open;
          edCodigo.Text := IntToStr(codEmpresaForm3);
          edNombre.Text := FieldByName('Nombre').AsString;
          edDireccion.Text := FieldByName('Direccion').AsString;
          edCodPostal.Text := FieldByName('CP').AsString;
          edLocalidad.Text := FieldByName('Localidad').AsString;
        end;
        with QCuentasEmpresa do
        begin
          if Active then
           Close;
          ParamByName('Empresa').Value := codEmpresaForm3;
          Open;
        end;
      end
      else
      begin
        //BarraEstado.SimplePanel := True;
        //BarraEstado.SimpleText := 'Se está mostrando el último registro';
      end;
    end;
  end;
end;

procedure TForm3.btAddCuentaClick(Sender: TObject);
begin
  with Cuentas.TForm5.Create(nil) do
  begin
    Caption := 'Alta de cuentas';
    ShowModal;
  end;
end;

procedure TForm3.btCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure TForm3.btGuardarClick(Sender: TObject);
var
  result : integer;
begin
  with DataModule1 do
  begin
    if (btGuardar.Caption <> 'Modificar') then
    begin
      with QGuardarEmpresa do
      begin
        if (Active = True) then
        begin
          Close();
        end;
        ParamByName('empresa').Value := StrToInt(edCodigo.Text);
        ParamByName('nombre').Value := edNombre.Text;
        ParamByName('cif').Value := edCif.Text;
        ParamByName('direccion').Value := edDireccion.Text;
        ParamByName('cp').Value := edCodPostal.Text;
        ParamByName('localidad').Value := edLocalidad.Text;
        try
          ExecSQL;
          showMessage('Datos Guardados.');
        except on E:Exception do
          showmessage('Error al guardar los datos: '+E.message);
        end;
        with QUltimaEmpresa do
        begin
          Close;
          Open;
        end;
      end;
      with QCuentasEmpresa do
      begin
        if (Active = True) then
        begin
          Close();
        end;
        ParamByName('empresa').Value := CodEmpresaForm3;
        result := RecordCount;
        if (result = 0) then
          Cuentas.Form5.ShowModal;
      end;
    end
    else
    begin
      with DataModule1.QUnaEmpresa do
      begin
        Edit;
        FieldByName('CIF').Value := edCif.TExt;
        FieldByName('NOMBRE').Value := edNombre.Text;
        FieldByName('direccion').Value := edDireccion.Text;
        FieldByName('CP').Value := edCodPostal.Text;
        FieldByName('LOCALIDAD').Value := edLocalidad.Text;
        Post;
      end;
    end;
  end;
  Close;
end;


end.
