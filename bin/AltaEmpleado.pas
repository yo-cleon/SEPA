unit AltaEmpleado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ModuloDatos, Vcl.StdCtrls, DBCtrlsEh,
  Vcl.Mask, JvExControls, JvLabel, JvButton, JvTransparentButton, Vcl.ComCtrls,
  AdvGroupBox;

type
  TForm4 = class(TForm)
    lbCodigo: TJvLabel;
    lbNif: TJvLabel;
    edCodigo: TDBEditEh;
    edNif: TDBEditEh;
    lbNombre: TJvLabel;
    lbApellidos: TJvLabel;
    edNombre: TDBEditEh;
    edApellidos: TDBEditEh;
    lbIban: TJvLabel;
    edIban: TDBEditEh;
    lbSueldo: TJvLabel;
    edNomina: TDBEditEh;
    cbBaja: TDBCheckBoxEh;
    btGuardar: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    lbLocalidad: TJvLabel;
    edLocalidad: TDBEditEh;
    btAntEmpleado: TJvTransparentButton;
    btSgteEmpleado: TJvTransparentButton;
    BarraEstado: TStatusBar;
    AdvGroupBox1: TAdvGroupBox;
    lbBIC: TJvLabel;
    edBic: TDBEditEh;
    procedure FormActivate(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btGuardarClick(Sender: TObject);
    procedure btAntEmpleadoClick(Sender: TObject);
    procedure btSgteEmpleadoClick(Sender: TObject);
    function EsNif(nif:string):Boolean;
    procedure edNifExit(Sender: TObject);
    procedure edIbanExit(Sender: TObject);
    procedure edNombreExit(Sender: TObject);
    procedure edApellidosExit(Sender: TObject);
    procedure edLocalidadExit(Sender: TObject);
    procedure edBicExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NuevoEmpleado();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  CodEmpresaForm4 : Integer;
  codEmpleado : Integer;

implementation

{$R *.dfm}

uses PantallaPrincipal, FireDAC.Stan.PAram, System.UITypes;

{******************************************************************
*********** INICIALIZACIÓN DEL FORMULARIO ***********
*******************************************************************}

// CONTROL DE TAGS:   0 --> Inicializado formulario.

procedure TForm4.FormActivate(Sender: TObject);
begin
//  if (Tag = 0) then
//  begin
//    Tag := 999;
//    with DataModule1 do
//    begin
      if (Tag = 1) then
      begin
        NuevoEmpleado();
      end;
//    end;
//  end;
end;

{******************************************************************
*********** PROCEDIMIENTOS REUTILIZABLES DEL FORMULARIO ***********
*******************************************************************}

{------------------------------EsNif---------------------------------------}
function TForm4.EsNif(nif:String): Boolean;
var a:string;
    Dni:String;
    Nie:String;
    Letra:String;
begin
  if (Pos(Nif[1], 'XYZ') = 1) then
  begin
    Nie := Copy(Nif,2,7);
    a:=Copy('TRWAGMYFPDXBNJZSQVHLCKET',StrToInt( Nie ) mod 23 + 1, 1 );
    Letra:=Copy(nif,9,1);
    if a = letra then
      result:=True
    else
      result:=False;
  end
  else
  begin
    Dni:=copy(nif,1,8);
    a:=Copy('TRWAGMYFPDXBNJZSQVHLCKET',StrToInt( Dni ) mod 23 + 1, 1 );
    Letra:=Copy(nif,9,1);
    if a = letra then
      result:=True
    else
      result:=False;
  end;
end;

{--------------------------  Validar IBAN ----------------------------------- }
function Modulo97(s: string): integer;
var
  v, l : integer;
  alpha : string;
  number : longint;
begin
  v := 1;
  l := 9;
  Result := 0;
  alpha := '';

  while (v <= Length(s)) do
  begin
     if (l > Length(s)) then
        l := Length(s);
     alpha := alpha + Copy(s, v, l);
     number := StrToInt(alpha);
     Result := number mod 97;
     v := v + l;
     alpha := IntToStr(Result);
     l := 9 - Length(alpha);
  end;
end;

function ChangeAlpha(input: string): string;
var
  a : char;
begin
  /// A -> 10, B -> 11, C -> 12 ...
  Result := input;
  for a := 'A' to 'Z' do
  begin
     Result := StringReplace(Result, a, IntToStr(Ord(a) - 55), [rfReplaceAll]);
  end;
end;

function IBANValido(IBAN: string): boolean;
var
  i : integer;
  TmpIBAN : string;
begin
  Result := True;
  IBAN := UpperCase(IBAN);
  // Compruebo que sean caracteres válidos
  for i := 1 to Length(IBAN) do
        if ((IBAN[i] in ['A'..'Z', '0'..'9'])) then
           TmpIBAN := TmpIBAN + IBAN[i];
  if (Result) then
  begin
     // Paso los primeros 4 digitos al final (Pais + Control)
     IBAN := IBAN + Copy(IBAN, 1, 4);
     Delete(IBAN, 1, 4);
     // Convierto letras a digitos
     iban := ChangeAlpha(IBAN);
     // Si el resto de modulo 97 es 1 es una cuenta válida
     Result := (Modulo97(IBAN) = 1);
  end;
end;

{---------------------  AÑADIR UN NUEVO EMPLEADO---------------------- }

procedure TForm4.NuevoEmpleado();
begin
  with DataModule1.QTodosEmpleados do
  begin
    Append;
    with DataModule1.QUltimoEmpleado do
    begin
      Open;
      edCodigo.Text := IntToStr(FieldByName('UltimoEmpleado').AsInteger+1);
      edNif.SetFocus;
    end;
  end;
end;

{******************************************************************
********************* FUNCIONES DE LOS BOTONES ********************
*******************************************************************}

procedure TForm4.btAntEmpleadoClick(Sender: TObject);
begin
  with DataModule1.QTodosEmpleados do
  begin
    if not Bof then
    begin
      Prior;
      if BarraEstado.SimpleText = '' then
        BarraEstado.SimpleText := '';
    end
    else
    begin
      BarraEstado.SimpleText := 'Ya se está visualizando el primer registro.';
    end;
  end;
end;

procedure TForm4.btSgteEmpleadoClick(Sender: TObject);
begin
  with DataModule1.QTodosEmpleados do
  begin
    if not Eof then
    begin
      Next;
      if BarraEstado.SimpleText = '' then
        BarraEstado.SimpleText:= '';
    end
    else
    begin
      BarraEstado.SimpleText := 'Ya se está visualizando el último registro.';
    end;
  end;
end;

procedure TForm4.btGuardarClick(Sender: TObject);
begin
  if (Tag = 2) then
  begin       // PROCEDIMIENTO PARA MODIFICAR UN EMPLEADO
    with DataModule1.QTodosEmpleados do
    begin
      Edit;
      if cbBaja.Checked = true then
      begin
        with DataModule1.QTodosEmpleados do
        begin
          BeforePost := nil;
        end;
      end;
      Post;
    end;
    Form1.gridEmpleados.DataSource.DataSet.Refresh;
    If (MessageDlg('¿Quieres modificar otro empleado?',
     mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
    begin
      Close;
    end;
  end
  else if (Tag = 1) then
  begin       // PROCEDIMIENTO PARA GUARDAR UN EMPLEADO
    with DataModule1.QTodosEmpleados do
    begin
      Edit;
      Post;
      DataModule1.QUltimoEmpleado.Refresh;
      Refresh;
    end;
    If (MessageDlg('¿Quieres añadir otro empleado?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      NuevoEmpleado();
    end
    else
    begin
      Close;
    end;
  end;
end;

procedure TForm4.btCancelarClick(Sender: TObject);
begin
  try
    with DataModule1.QTodosEmpleados do
    begin
      Cancel;
    end;
    Close;
  except
    showMessage('Ha habido un error al cerrar el formulario');
  end;
end;

{******************************************************************
********************** CONTROL DE LOS CAMPOS **********************
*******************************************************************}

procedure TForm4.edNifExit(Sender: TObject);
begin
  if edNif.Text <> '' then
  begin
    edNif.Text := UpperCase(edNif.Text);
    if NOT EsNif(edNif.Text) then
    begin
      showMessage('EL nif/nie introducido no es correcto');
      edNif.SetFocus;
    end
    else
    begin
      if Tag = 1 then
      begin
        with DataModule1.QBuscarNif do
        begin
          if Active then
            Close;
          ParamByName('nif').Value := edNif.Text;
          Open;
          if RecordCount > 0 then
          begin
            showMessage('El nif introduce pertenece a un trabajador ya ' +
                        'existente en la aplicación.');
            edNif.SetFocus;
          end;
        end;
      end;
    end;
  end
  else
  begin
    showMessage('El campo NIF no puede estar vacío.');
    edNif.SetFocus;
  end;
end;

procedure TForm4.edNombreExit(Sender: TObject);
begin
  edNombre.Text := UpperCase(edNombre.Text);
end;

procedure TForm4.edApellidosExit(Sender: TObject);
begin
  edApellidos.Text := UpperCase(edApellidos.Text);
end;

procedure TForm4.edLocalidadExit(Sender: TObject);
begin
    edLocalidad.Text := UpperCase(edLocalidad.Text);
end;

procedure TForm4.edIbanExit(Sender: TObject);
begin
  edIban.Text := UpperCase(edIban.Text);
  if NOT IBANValido(edIban.Text) then
  begin
    showMessage('Deberías revisar el IBAN. Parece no ser correcto');
    edIban.SetFocus;
  end;
end;

procedure TForm4.edBicExit(Sender: TObject);
begin
  edBic.Text := UpperCase(edBic.Text);
end;

{******************************************************************
********************** CIERRE DEL FORMULARIO **********************
*******************************************************************}

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  with DataModule1 do
  begin
    QTodosEmpleados.Cancel();
  end;
end;

end.
