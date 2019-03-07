unit AltaEmpresa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvLabel, Vcl.StdCtrls,
  Vcl.Mask, DBCtrlsEh, Vcl.DBCtrls, JvDBCheckBox, ModuloDatos, JvButton,
  JvTransparentButton, Firedac.Stan.Param, Data.DB, Vcl.Grids, Vcl.DBGrids,
  JvDotNetControls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.ComCtrls, JvExComCtrls,
  JvStatusBar, AdvGroupBox;

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
    btGuardarEmpresa: TJvTransparentButton;
    btCancelar: TJvTransparentButton;
    edCif: TDBEditEh;
    btPrevEmpresa: TJvTransparentButton;
    btNextEmpresa: TJvTransparentButton;
    gridCuentasEmpresa: TDBGridEh;
    BarraEstado: TJvStatusBar;
    AdvGroupBox1: TAdvGroupBox;
    bdEditarCuentas: TJvTransparentButton;
    btGuardarCuentas: TJvTransparentButton;
    btAniadirCuenta: TJvTransparentButton;
    procedure AltaEmpresa();
    procedure ModificaEmpresa();
    procedure btCancelarClick(Sender: TObject);
    procedure btGuardarEmpresaClick(Sender: TObject);
    procedure edCifExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btPrevEmpresaClick(Sender: TObject);
    procedure btNextEmpresaClick(Sender: TObject);
    procedure gridCuentasEmpresaColExit(Sender: TObject);
    function EsCif(Cif:string) : Boolean;
    function EsNif(Cif:String): Boolean;
    procedure gridCuentasEmpresaCellClick(Column: TColumnEh);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bdEditarCuentasClick(Sender: TObject);
    procedure btGuardarCuentasClick(Sender: TObject);
    procedure btAniadirCuentaClick(Sender: TObject);
    procedure edNombreExit(Sender: TObject);
    procedure edDireccionExit(Sender: TObject);
    procedure edLocalidadExit(Sender: TObject);

  private
    { Private declarations }
    iTagInicial : Integer;

  public
    { Public declarations }

  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses PantallaPrincipal, System.UITypes;

{*****************************************************************
********************* GESTIÓN DEL FORMULARIO *********************
******************************************************************}

// CONTROL DE TAGS:   0 --> Inicializado formulario.
procedure TForm3.FormActivate(Sender: TObject);
begin
  iTagInicial := Tag;
//  if (Tag = 0) then
//  begin
//    Tag := 999;
    edCif.SetFocus;
    if (Tag = 2) then
    begin
      ModificaEmpresa();
    end
    else if (Tag = 1) then
    begin
      AltaEmpresa();
    end;
    BarraEstado.SimplePanel := True;
//  end;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataModule1.QEmpresas.Cancel;
end;

{**************************************************************************
******************PROCEDIMIENTOS GENERALES DE FUNCIONAMIENTO***************
***************************************************************************}

// ------------------  Validar si un CIF introducido es correcto  ------------
function TForm3.EsCif(Cif : String) : Boolean;
 var
    Suma, Control : Integer;
    n             : Byte;
 begin
   Result := False;

//EL CAMPO NO ADMITE NI ESPACIOS NI GUIONES Y YA ESTA TODO EN MAYUSCULAS
   {Se pasa todo a mayúsculas limpio de espacios y de caracteres especiales}
   //Cif := UpperCase(Trim(Cif));
   {Se limpia de los caracteres '-' y '/'. }
   //Cif := StringReplace(Cif,'-','',[rfReplaceAll]);
   //Cif := StringReplace(Cif,'/','',[rfReplaceAll]);
   {El cif debe ser de 9 cifras}
   if (Length(Cif) = 9) or (Length(Cif) = 10) then
   begin
     {Comprobamos que sea un NIF}
     if (pos(Cif[1],'0123456789'))>0 then
       Result := EsNif(Cif)
     else
       begin
       {Se comprueba que la letra que designa el tipo de cif sea correcta}
         if (Pos(Cif[1], 'ABCDEFGHPQSKLMXYZJUVWR') = 0) then
           Result := False
         else
           {Se comprueba si es un extranjero,
            en ese caso se calcula el nif, cambiando la X, por 0}
           if (Pos(Cif[1], 'XYZ') = 1) then
             result := EsNif(Copy(Cif,2,9))
           else
             begin
               Suma:= StrToInt(Cif[3])+StrToInt(Cif[5])+StrToInt(Cif[7]);
               for n := 1 to 4 do
               Suma := Suma +
                 ((2*StrToInt(Cif[2*n])) mod 10)+((2*StrToInt(Cif[2*n])) div 10);
               Control := 10 - (Suma mod 10);
               {Se comprueba si es de tipo 'P' o 'S', es decir,
               Corporaciones Locales (Ayuntamientos, etc.)
               y Organismos públicos.}
               if Pos(Cif[1],'PSQ')<>0 then
                 {Control tipo letra}
                 Result := (Cif[9] = Chr(64+Control))
               else
                 {Resto de tipos de CIF}
                 begin
                   {Control tipo número}
                   if Control = 10 then
                     Control := 0;
                   Result:= ( StrToInt(Cif[9]) = Control);
                 end;
             end;
         end;
     end;
end;

{-----------------------------------------EsNif------------------------------}
function TForm3.EsNif(Cif:String): Boolean;
var a:string;
    Dni:String;
    Letra:String;
begin
  Dni:=copy(cif,1,8);
  a:=Copy('TRWAGMYFPDXBNJZSQVHLCKET',StrToInt( Dni ) mod 23 + 1, 1 );
  Letra:=Copy(cif,9,1);
  if a = letra then
     result:=True
  else
     result:=False;
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

//VALIDACION DE DATOS CRITICOS
procedure TForm3.edCifExit(Sender: TObject);
begin
  edCif.Text := UpperCase(edCif.Text);
  if NOT EsCif(edCif.Text) then
  begin
    showMessage('El cif/nif introducido es incorrecto.');
    edCif.SetFocus;
  end
  else
  begin
    //****** Control de estado del formulario:
    //****** TAG 1 --> Crear empresa; TAG 2 --> Modficación de datos
    if Tag = 1 then
    begin
      with DAtaModule1.QBuscaCif do
      begin
        if Active then
          Close;
        ParamByName('cif').Value := edCif.Text;
        Open;
        if REcordCount > 0 then
        begin
          showMEssage('Ya existe una empresa creada en la aplicación con ese CIF.');
          edCif.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TForm3.AltaEmpresa();
begin
  edCif.SetFocus;
  gridCuentasEmpresa.ReadOnly := True;
  gridCuentasEmpresa.Color := clMenu;
  with DataModule1 do
  begin
    with QEmpresas do
    begin
      Append;
      with QUltimaEmpresa do
      begin
        Open();
        edCodigo.Text := IntToStr(FieldByName('UltimaEmpresa').AsInteger+1);
      end;
    end;
    with QCuentasEmpresa do
    begin
      if (Active = true) then
        Close;
      ParamByName('EMPRESA').Value := QEmpresas.FieldByName('codempresa').AsInteger;
      Open;
    end;
    with QTodosEmpleados do
    begin
      Close;
      ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
      Open;
    end;
  end;
end;

procedure TForm3.ModificaEmpresa;
begin
  with DataModule1 do
  begin
    with QCuentasEmpresa do
    begin
      if (Active = true) then
        Close;
      ParamByName('EMPRESA').Value := QEmpresas.FieldByName('codempresa').AsInteger;
      Open;
    end;
  end;
end;

{******************************************************************
*************** CONTROL DE CAMPOS DEL FORMULARIO ******************
*******************************************************************}

procedure TForm3.edDireccionExit(Sender: TObject);
begin
  edDireccion.Text := UpperCase(edDireccion.Text);
end;

procedure TForm3.edLocalidadExit(Sender: TObject);
begin
  edLocalidad.Text := UpperCase(edLocalidad.Text);
end;

procedure TForm3.edNombreExit(Sender: TObject);
begin
  edNombre.Text := UpperCase(edNombre.Text);
end;

{******************************************************************
****************** BOTONES CONTROL DATOS EMPRESA ******************
*******************************************************************}

procedure TForm3.btPrevEmpresaClick(Sender: TObject);
begin
  if gridCuentasEmpresa.Color = clWindow then
    gridCuentasEmpresa.Color := clMenu;
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
          with QCuentasEmpresa do
          begin
            if (Active = true) then
              Close;
            ParamByName('EMPRESA').Value := QEmpresas.FieldByName('codempresa').AsInteger;
            Open;
          end;
          with QTodosEmpleados do
          begin
            Close;
            ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
            Open;
          end;
        end
        else
        begin
          BarraEstado.SimpleText := 'Ya se está mostrando el primer registro';
        end;
      end;
    end;
  end;
end;

procedure TForm3.btNextEmpresaClick(Sender: TObject);
begin
  if gridCuentasEmpresa.Color = clWindow then
    gridCuentasEmpresa.Color := clMenu;
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
          with QCuentasEmpresa do
          begin
            if (Active = true) then
              Close;
            ParamByName('EMPRESA').Value := QEmpresas.FieldByName('codempresa').AsInteger;
            Open;
          end;
          with QTodosEmpleados do
          begin
            if (Active = true) then
              Close;
            ParamByName('EMPRESA').Value := QEmpresas.FieldByName('codempresa').AsInteger;
            Open;
          end;
        end
        else
        begin
          BarraEstado.SimpleText := 'Ya se está mostrando el último registro';
        end;
      end;
    end;
  end;
end;

procedure TForm3.btCancelarClick(Sender: TObject);
begin
  DataModule1.QEmpresas.Cancel;
  with DataModule1.QTodosEmpleados do
  begin
    if (Active = true) then
      Close;
    ParamByName('EMPRESA').Value := DataModule1.QEmpresas.FieldByName('codempresa').AsInteger;
    Open;
  end;
  Close();
end;

procedure TForm3.btGuardarEmpresaClick(Sender: TObject);
begin
  with DataModule1 do
  begin
    if (Self.Tag = 1) then  //Tag 1: Alta nuevos datos datos existentes
    begin
      QEmpresas.Post;
      gridCuentasEmpresa.ReadOnly := False;
      gridCuentasEmpresa.Color := clWindow;
      If (MessageDlg('¿Quieres añadir otra empresa?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        AltaEmpresa();
      end
      else
      begin
        Close;
      end;
    end
    else if (Self.Tag = 2) then  //Tag 2: Modificar datos existentes
    begin
      with DataModule1.QEmpresas do
      begin
        Edit;
        FieldByName('CIF').Value := edCif.TExt;
        FieldByName('NOMBRE').Value := edNombre.Text;
        FieldByName('direccion').Value := edDireccion.Text;
        FieldByName('CP').Value := edCodPostal.Text;
        FieldByName('LOCALIDAD').Value := edLocalidad.Text;
        Post;
      end;
      If (MessageDlg('¿Quieres modificar datos de otra empresa?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
      begin
        Close;
      end;
    end;
    with QTodosEmpleados do
    begin
      Close;
      ParamByName('empresa').AsInteger := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
      Open;
    end;
  end;
end;

{******************************************************************
****************** BOTONES CONTROL TABLA CUENTAS ******************
*******************************************************************}

procedure TForm3.bdEditarCuentasClick(Sender: TObject);
begin
  with gridCuentasEmpresa do
  begin
    Color := clWindow;
    ReadOnly := False;
    DataSource.DataSet.Edit;
  end;

end;

procedure TForm3.btGuardarCuentasClick(Sender: TObject);
var
  aux : integer;
begin
  with gridCuentasEmpresa do
  begin
    DataSource.DataSet.Post;
    ReadOnly := true;
    Color := clMenu;
    with DataModule1.QBuscarCuentaPorDefecto do
    begin
      if Active then
        Close;
      ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('CodEmpresa').AsInteger;
      Open;
      if RecordCount < 1 then
      begin
        showMessage('Debe haber al menos un cuenta marcada como "POR DEFECTO".');
        with DataModule1.QPrimeraCuentaPorDefecto do
        begin
          with DataModule1.QPrimeraCuentaEmpresa do
          begin
            if Active then
              Close;
            ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('codempresa').AsInteger;
            Open;
          end;
          if Active then
            Close;
          ParamByName('PrimeraCuenta').Value := DataModule1.QPrimeraCuentaEmpresa.FieldByName('Codigo').AsInteger;
          ExecSQL;
          with DataModule1.QCuentasEmpresa do
          begin
            Refresh;
          end;
        end;
      end
      else if RecordCount > 1 then
      begin
        showMessage('No puede haber más de una cuenta marcada como "POR DEFECTO".');
        First;
        aux := FieldByName('codigo').AsInteger;
        with DataModule1.QPorDefecto do
        begin
          if Active then
            Close;
          ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('CodEmpresa').AsInteger;
          ParamByName('codigocuenta').Value := aux;
          ExecSQL;
        end;
        DataModule1.QCuentasEmpresa.Refresh;
      end;
    end;
  end;
end;

procedure TForm3.btAniadirCuentaClick(Sender: TObject);
begin
  with gridCuentasEmpresa do
  begin
    Color := clWindow;
    ReadOnly := False;
    with DataModule1.QUltimaCuenta do
    begin
      if not Active then
        Open;
      with DataModule1.QCuentasEmpresa do
      begin
        Append;
        FieldByName('codigo').Value := (DataModule1.QUltimaCuenta.FieldByName('codigo').AsInteger + 1);
      end;
      Close;
    end;
  end;
end;

{******************************************************************
********************** CONTROL TABLA CUENTAS **********************
*******************************************************************}

procedure TForm3.gridCuentasEmpresaColExit(Sender: TObject);
begin
  with gridCuentasEmpresa do
  begin
      // VALIDACIÓN DEL IBAN INTRODUCIDO.
      if SelectedIndex = 2 then
      begin
        SelectedField.Text := UpperCase(SelectedField.Text);
        if NOT IBANValido(SelectedField.Text) then
        begin
          showMessage('Deberías revisar el IBAN. Parece no ser correcto');
          Columns[2].Field.FocusControl;
        end;
      end;
      // VALIDACIÓN DEL BIC INTRODUCIDO.
      if SelectedIndex = 3 then
      begin
        if ((SelectedField.Text.Length < 8) or (SelectedField.Text.Length > 11)) then
        begin
          SelectedField.Text := UpperCase(SelectedField.Text);
          showMessage('Revisa el BIC introducido. El tamaño parece no ser correcto');
        end
        else
        begin
          SelectedField.Text := UpperCase(SelectedField.Text);
        end;
      end;
    end;
end;

// VALIDACION DE LA CUENTA POR DEFECTO --> VALORES DEL CHECKBOX: 0 DESMARCADO - 1 MARCADO
procedure TForm3.gridCuentasEmpresaCellClick(Column: TColumnEh);
{var
  iPorDefecto : integer;}

begin
  if (gridCuentasEmpresa.SelectedIndex = 5) and (gridCuentasEmpresa.ReadOnly = false) then
  begin
//    iPorDefecto := gridCuentasEmpresa.DataSource.DataSet.FieldByName('Pordefecto').AsInteger;
    with DataModule1.QPorDefecto do
    begin
      if Active then
        Close;
      ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('CodEmpresa').AsInteger;
      ParamByName('codigocuenta').Value := gridCuentasEmpresa.DataSource.DataSet.FieldByName('codigo').AsInteger;
      ExecSQL;
    end;
    with DataModule1.QCuentasEmpresa do
    begin
      Refresh;
    end;
  end;
end;

end.
