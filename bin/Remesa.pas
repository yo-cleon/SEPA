unit Remesa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.DBCtrls, Vcl.StdCtrls, JvExStdCtrls,
  JvCombobox, Vcl.Mask, DBCtrlsEh, JvExControls, JvLabel, JvExMask, JvToolEdit,
  JvButton, JvTransparentButton, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Vcl.ComCtrls, JvExComCtrls, JvStatusBar, JvGroupBox, JvGroupHeader,
  JvgGroupBox, AdvGroupBox, sDialogs, acProgressBar, ppComm,
  ppRelatv, ppProd, ppClass, ppReport, ppCtrls, ppPrnabl, ppDB, ppBands,
  ppCache, ppDesignLayer, ppParameter, ppDBPipe, ppVar, ppStrtch, ppRichTx,
  JvProgressBar, JvDBProgressBar, JvDialogs;

type
  TForm6 = class(TForm)
    edCif: TDBEditEh;
    edNombre: TDBEditEh;
    gridRemesa: TDBGridEh;
    BarraEstado: TJvStatusBar;
    btRellenar: TJvTransparentButton;
    btGenerar: TJvTransparentButton;
    lbCif: TJvLabel;
    lbNombre: TJvLabel;
    lbAnio: TJvLabel;
    lbMes: TJvLabel;
    edAnio: TDBEditEh;
    comboMes: TJvComboBox;
    AdvGroupBox1: TAdvGroupBox;
    lbIban: TJvLabel;
    comboIban: TJvComboBox;
    lbSufijo: TJvLabel;
    edSufijo: TDBEditEh;
    lbTotal: TJvLabel;
    edTotal: TDBEditEh;
    empresaGB: TAdvGroupBox;
    lbRemesa: TJvLabel;
    edRemesa: TDBEditEh;
    edBic: TDBEditEh;
    lbBIC: TJvLabel;
    btBorrarRemesa: TJvTransparentButton;
    bpRemesa: TsProgressBar;
    lbRemesaEmitida: TJvLabel;
    dbInformeRemesa: TppDBPipeline;
    btImprimir: TJvTransparentButton;
    btBorrarEmpleado: TJvTransparentButton;
    sdRutaFichero: TSaveDialog;
    rbInformeRemesa: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppShape1: TppShape;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppDBText2: TppDBText;
    ppLabel3: TppLabel;
    ppDBText3: TppDBText;
    ppLabel4: TppLabel;
    ppLabel7: TppLabel;
    ppDBText7: TppDBText;
    ppLabel5: TppLabel;
    ppLabel6: TppLabel;
    ppLine1: TppLine;
    ppDBText1: TppDBText;
    ppDBText8: TppDBText;
    ppLabel8: TppLabel;
    ppDBText9: TppDBText;
    ppLabel9: TppLabel;
    ppDBText10: TppDBText;
    ppLabel12: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppDBCalc1: TppDBCalc;
    ppLabel13: TppLabel;
    ppDetailBand1: TppDetailBand;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppRichText1: TppRichText;
    ppPageSummaryBand1: TppPageSummaryBand;
    ppLabel10: TppLabel;
    ppLine2: TppLine;
    ppDBText11: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppLabel11: TppLabel;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    procedure calculaTotalRemesa();
    procedure btRellenarClick(Sender: TObject);
    procedure btGenerarClick(Sender: TObject);
    procedure comboIbanChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gridRemesaSelectionChanged(Sender: TObject);
    procedure gridRemesaKeyPress(Sender: TObject; var Key: Char);
    procedure btBorrarRemesaClick(Sender: TObject);
    procedure nuevaRemesa();
    procedure FormActivate(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btBorrarEmpleadoClick(Sender: TObject);
    function cambiacoma(num:string):string;
    function LimpiarCarNormaSEPAXML(texto: String; longitud: Integer):string;
    function EmitirRemesa():boolean;

  private
    { Private declarations }
    iRemesa : Integer;
    iNumFichCreado : Integer;
    bRemesaCreada : Boolean;
    bRemesaEmitida : Boolean;
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses
  ModuloDatos, FireDAC.Stan.Param, PantallaRemesas, PantallaPrincipal;

{******************************************************************
********************* CREACIÓN DEL FORMULARIO *********************
*******************************************************************}

procedure TForm6.FormActivate(Sender: TObject);
begin
  Tag := 1;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  bRemesaCreada := false;
  bRemesaEmitida := false;
  nuevaRemesa();
end;

{******************************************************************
*********************** FUNCIONES GENÉRICAS ***********************
*******************************************************************}

function TForm6.cambiacoma(num:string):string;
begin
  result := Stringreplace(num,',','.',[rfReplaceAll, rfIgnoreCase]);
end;

Function TForm6.LimpiarCarNormaSEPAXML(texto: String; longitud: Integer): String;
var
  i : integer;
begin
//    Result := Utf8Encode(Trim(Copy(texto, 1, longitud)));
 texto := Trim(Copy(texto, 1, longitud));
  for i := 1 to Length(texto) do
  begin
    if not(Ord(texto[i]) in [65..90,97..122,48..57,47,45,63,58,40,41,46,44,39,43,32]) then
       texto[i] := '¤'
  end;
  texto := StringReplace(texto,'¤','',[rfReplaceAll, rfIgnoreCase]);
  result := texto;
end;

procedure TForm6.calculaTotalRemesa();
begin
  with DataModule1 do
  begin
    with QTotalRemesa do
    begin
      if Active then
        Close;
      ParamByName('Remesa').Value := edRemesa.Text;
      Open;
      edTotal.Text := FormatFloat('#,##0.00 €',DataModule1.QTotalRemesa.FieldByName('TotalRemesa').AsFloat);
      if edTotal.Font.Color = clRed then
          edTotal.Font.Color := clBlack;
    end;
    with QCabeceraRemesa do
    begin
      Close;
      SQL.Add('AND CodRemesa = :remesa');
      Prepare;
      ParamByName('remesa').Value := edRemesa.Text;
      Open;
      Edit;
      FieldByName('Total').AsFloat := DataModule1.QTotalRemesa.FieldByName('TotalRemesa').AsFloat;
      Post;
    end;
  end;
end;

procedure TForm6.nuevaRemesa();
begin
  with DataModule1 do
  begin
    if not Active then
      QCabeceraRemesa.Open();
    if not Active then
      QLineasRemesa.Open();
    if not Active then
      QSiguienteRemesa.Open();
    if not Active then
      QSiguienteLinea.OPen();
    if not Active then
      QNuevaLineaRemesa.Open();
    if not Active then
      QTotalRemesa.Open();
    QSiguienteRemesa.Refresh;
    iRemesa := (QSiguienteRemesa.FieldByName('NuevaRemesa').AsInteger)+1;
  end;
  if edRemesa.Text <>'' then
    edRemesa.Text:='';
  edAnio.Text := FormatDateTime('yyyy', Date);
  edAnio.Font.Color := clRed;
  comboMes.ItemIndex := StrToInt(FormatDateTime ('MM',Date))-1;
  comboMes.Font.Color := clRed;
  comboIban.Font.Color := clRed;
  edSufijo.Font.Color := clRed;
  edBic.Font.Color := clRed;
  with DataModule1.QCuentasEmpresa do
  begin
    if Active then
      Close;
    ParamByName('empresa').Value := DataModule1.QEmpresas.FieldByName('CodEmpresa').AsInteger;
    Open;
    while not Eof do
    begin
      comboIban.Items.Add(FieldByName('IBAN').AsString);
      if (FieldByName('PorDefecto').AsInteger = 1) then
      begin
        comboIban.Text := FieldByName('IBAN').AsString;
        edSufijo.Text := FieldByName('SUFIJO').AsString;
      edBic.Text := FieldByName ('BIC').AsString;
      end;
      Next;
    end;
  end;
  if edTotal.Text <> '' then
    edTotal.Text := '';
  bRemesaCreada := false;
  bRemesaEmitida := false;
  gridRemesa.DataSource.DataSet.Close;
end;

function TForm6.EmitirRemesa():boolean;
begin
  try
    with DataModule1.QEmitirRemesa do
    begin
      if Active then
        Close;
      ParamByName('remesa').Value := StrToInt(edREmesa.Text);
      ExecSQL;
    end;
    bpRemesa.Visible := false;
    lbRemesaEmitida.Visible := true;
    edAnio.Color := clInfoBk;
    comboMes.Color := clInfoBk;
    comboMes.ReadOnly := true;
    comboIban.Color := clInfoBk;
    comboIban.ReadOnly := true;
    bRemesaEmitida := true;
    result := true;
  except
    result := false;
  end;
end;

{******************************************************************
****************** BOTONES CONTROL DATOS REMESA ******************
*******************************************************************}

procedure TForm6.gridRemesaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // ( #13 = tecla enter )
   begin
    gridRemesa.DataSource.DataSet.Post;
    calculaTotalRemesa();
   end;
end;

procedure TForm6.gridRemesaSelectionChanged(Sender: TObject);
begin
  calculaTotalRemesa();
end;

procedure TForm6.comboIbanChange(Sender: TObject);
begin
  with DataModule1.QDatosCuenta do
  begin
    If Active then
      Close;
    ParamByName('cuenta').Value := comboIban.Text;
    Open;
    edSufijo.Text := FieldByName('SUFIJO').AsString;
    edBic.Text := FieldByName('BIC').AsString;
  end;
end;

procedure TForm6.btRellenarClick(Sender: TObject);
var
  i : Integer;
  linea : Integer;
begin
  if not bRemesaCreada then
  begin
    with DataModule1 do
    begin
      with QCabeceraRemesa do
      begin
        Append;
        FieldByName('CODREMESA').Value := iRemesa;
        FieldByName('CODEMPRESA').Value := QEmpresas.FieldByName('CodEmpresa').AsInteger;
        FieldByName('MES').Value := comboMes.Text;
        FieldByName('ANIO').Value := edAnio.Text;
        FieldByName('IBAN').Value := comboIban.Text;
        FieldByName('BIC').Value := edBic.Text;
        FieldByName('SUFIJO').Value := edSufijo.Text;
        FieldByNaME('EMITIDO').Value := 0;
        edRemesa.Text := IntToStr(iRemesa);
        edCif.Font.Color := clBlack;
        edNombre.Font.Color := clBlack;
        edAnio.Font.Color := clBlack;
        comboMes.Enabled := true;
        comboMes.Font.Color := clBlack;
        comboIban.Enabled := true;
        comboIban.Font.Color := clBlack;
        edSufijo.Font.Color := clBlack;
        edBIC.Font.Color := clBlack;
        Post;
        Refresh;
      end;
      with QSiguienteLinea do
      begin
        if Active then
          Close;
        ParamByName('remesa').Value := iRemesa;
        Open();
        linea := (FieldByName('LINEA').AsInteger+1);
      end;
      with QEmpleados do
      begin
        Close;
        ParamByName('empresa').Value := QEmpresas.FieldByName('CodEmpresa').AsInteger;
        Open;
        while not Eof do
        begin
          for i := 0 to Qempleados.RowsAffected -1 do
          begin
            with QNuevaLineaRemesa do
            begin
              Append;
              FieldByName('Codremesa').Value := iRemesa;
              FieldByName('CodOperacion').Value := linea;
              FieldByName('CodEmpleado').Value := QEmpleados.FieldByName('codempleado').AsInteger;
              FieldByName('Iban').Value := QEmpleados.FieldByName('iban').AsString;
              FieldByName('BIC').Value := QEmpleados.FieldByName('bic').AsString;
              FieldByName('SNETO').Value := QEmpleados.FieldByName('sneto').AsFloat;
              Post;
            end;
            linea := linea+1;
            QEmpleados.Next;
          end;
        end;
      end;
      calculaTotalRemesa();
      with QLineasRemesa do
      begin
        Close;
        ParamByName('remesa').Value := iRemesa;
        Open;
      end;
      btGenerar.Enabled := True;
      bRemesaCreada := true;
    end;
  end
  else
    showMessage('La remesa ya ha sido creada.');
end;

procedure TForm6.btBorrarEmpleadoClick(Sender: TObject);
var
  linea : integer;
  remesa : integer;
begin
  linea := StrToInt(gridRemesa.Columns[1].DisplayText);
  remesa := StrToInt(edRemesa.Text);
  if not bRemesaEmitida then
  begin
    with DataModule1.QBorrarLineaRemesa do
    begin
      if Active then
        Close;
      ParamByName('remesa').Value := remesa;
      ParamByName('linea').Value := linea;
      ExecSQL;
      gridRemesa.DataSource.DataSet.Refresh;
    end;
  end
  else
    showMessage('La remesa está emitida y no puede ser modificada.');
end;

procedure TForm6.btBorrarRemesaClick(Sender: TObject);
begin
 with DataModule1.QUnaRemesa do
  begin
    if Active then
      Close();
    ParamByName('remesa').Value := iRemesa;
    Open();
    if not bRemesaEmitida then
    begin
      try
        DataModule1.QCabeceraRemesa.Delete;
        ShowMessage('Remesa borrada correctamente.');
        gridREmesa.DataSource.DataSet.Refresh;
        DataModule1.QCabeceraRemesa.Refresh;
        nuevaRemesa();
      except
        showMessage('Ha habido un error al borarar la remesa');
      end;
    end
    else
    begin
      ShowMessage('La remesa está emitida y no puede ser borrada.');
    end;
  end;
end;

procedure TForm6.btGenerarClick(Sender: TObject);
var
  //creación fichero xml
  rutaFichero : string;
  fichero : TextFile;

  //generación archivo xml
  nombre, apellidos,linea,lineafichero,
  nombrefichero,relleno,cif,nreg,numero,nifempleado,total,nlin,idunico : string;
  //r : registro;
  nlinea,nrelleno,i : integer;
  ftotal, fresta, Tingresado : double;
  //aux : integer;
  num010,numreg341 : integer;
  sGuardaDir : string;
  NombreDir : String;
  //r341 : cabecera341;
  path : string;
  FicheroN341 : Boolean;
  dtotalBanco : double;
  NumPagos : integer;

  //CabFichero: cabeceraordenante;
  //CabTransf : CabeceraTRansf;
  //regtransf : RegistroTransf;
  //TotalFichero : totales;
  ibanordenante : string[34];
  numregtotales : integer;

  mensajeid : string[35];
  numop : integer;
  banco:integer;
  bic:string;

begin
  with DataModule1 do
  begin
    if gridRemesa.DataSource.DataSet.RecordCount = 0 then
    begin
      showMessage('No se puede guardar una remesa sin líneas.');
    end
    else
    begin

      // Las lineas tienen que tener una longitud de 74 caracteres,
      // desde el 1 al 73.
      ftotal := 0;
      fresta := 0;
      with DataModule1 do
        begin
          QUnaRemesa.close;
          QUnaRemesa.ParamByName('remesa').asinteger := StrToInt(edRemesa.Text);
          //QrestauranteFicheroNominas.ParamByName('grupo').asinteger := QNominas['grupo'];
          QUnaRemesa.open;

          QLineasRemesa.Close;
          QLineasREmesa.ParamByName('remesa').AsInteger := QUnaRemesa['codremesa'];
          QLineasRemesa.Open;
          QLineasRemesa.Last;
          Numop := QLineasRemesa.RecordCount;
          QLineasREmesa.First;

          ftotal := QUnaRemesa['total'];

//******************** INICIALIZACIÓN BARRA DE PROGRESO ******************
          //bpRemesa.Step := 1;
          bpRemesa.Min := 0;
          bpRemesa.Max := 100;
          bpRemesa.Position := 0;
          bpRemesa.Visible := true;

//************ SELECCIÓN DIRECTORIO PARA ALMACENAR LOS ARCHIVOS ***********
          with sdRutaFichero do
          begin
            Create(self);
            InitialDir := DataModule1.sPath;
            Title := 'Indica la carpeta para guardar el archivo SEPA.';
            if Execute then
            begin
              nombrefichero := sdRutaFichero.FileName+'.xml';
              assignfile(fichero,nombrefichero);
            end
            else
            begin
              NombreDir := edAnio.Text+comboMes.Text;
              rutaFichero := DataModule1.sPath+'\'+NombreDir;
              if not directoryexists(rutaFichero) then
                Createdir(rutaFichero);
              nombrefichero := QUnaRemesa['Cif']+'_'+IntToStr(QUnaRemesa['CodRemesa'])+'_'+QUnaRemesa['anio']+'_'+QUnaRemesa['mes']+ '.xml';
              assignfile(fichero,rutaFichero+'\'+nombrefichero);
            end;
          end;

//************************* CÓDIGO ORIGINAL GENERAR FICHERO SEPA ****************************
{         NombreDir := formatdatetime('mmmmyyyy', date);

          if Modulodatos.UsuarioPathBanco<>'' then
           path := Modulodatos.UsuarioPathBanco
          else
          begin
            mensaje.IconType := suiStop;
            mensaje.Text := 'El parametro "PathBanco" del usuario esta en blanco usando E:\banco\';
            path := 'e:\banco\';
            Mensaje.ShowModal;
          end;

          if rbsepa.Checked then
            nombrefichero := copy(QUnaRemesa['anio']+QUnaRemesa['mes']+QUnaRemesa['E.nombre'],1,6) + '.n34'   //**ANULADO MODELO .N34 POR OBSOLETOANULADO MODELO .N34 POR OBSOLETO
          else
            nombrefichero := copy(QUnaRemesa['anio']+QUnaRemesa['mes']+QUnaRemesa['nombre'],1,10) + '.xml';

          assignfile(fichero,'c:\banco'+NombreDir+'\'+nombrefichero);
          assignfile(fichero,rutaFichero+'\'+nombrefichero);              }

          {$I-}
          rewrite(fichero);
          {$I+}
          if ioresult = 0 then
          //begin
          begin  // XML
            Writeln(Fichero,'<?xml version="1.0" encoding="UTF-8"?>');
            Writeln(Fichero,'<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">');
            Writeln(Fichero,' <CstmrCdtTrfInitn>');

            mensajeid:='ORD'+formatdatetime('yyyymmddhhmmsszzz',now);
          // Cabecera (Group Header) BLOQUE B
            Writeln(Fichero,'  <GrpHdr>');
            Writeln(Fichero,'    <MsgId>'+LimpiarCarNormaSEPAXML(mensajeid,35)+'</MsgId>');
            Writeln(Fichero,'    <CreDtTm>'+formatdatetime('yyyy-mm-dd',Now)+'T'+formatdatetime('hh:mm:dd',Now)+'</CreDtTm>');
            Writeln(Fichero,'    <NbOfTxs>'+IntToStr(Numop)+'</NbOfTxs>');
            Writeln(Fichero,'    <CtrlSum>'+cambiacoma(floattostrf(ftotal,fffixed,18,2))+'</CtrlSum>');
            Writeln(Fichero,'    <InitgPty>');
            Writeln(Fichero,'      <Nm>'+LimpiarCarNormaSEPAXML(EdNombre.text,70)+'</Nm>');
            Writeln(Fichero,'      <Id>');
            Writeln(Fichero,'        <OrgId>');
            Writeln(Fichero,'          <Othr>');
            Writeln(Fichero,'            <Id>'+LimpiarCarNormaSEPAXML(EdCif.Text+edsufijo.text,16)+'</Id>');
            Writeln(Fichero,'          </Othr>');
            Writeln(Fichero,'        </OrgId>');
            Writeln(Fichero,'      </Id>');
            Writeln(Fichero,'    </InitgPty>');
            Writeln(Fichero,'  </GrpHdr>');

            // BLQOUE C
            Writeln(Fichero,'  <PmtInf>');
            Writeln(Fichero,'    <PmtInfId>' + EdCif.Text+formatdatetime('yyyymmdd',Now)+formatdatetime('yyyymmddhhmmsszzz',now)+'</PmtInfId>');
            Writeln(Fichero,'    <PmtMtd>TRF</PmtMtd>');
            Writeln(Fichero,'    <BtchBookg>false</BtchBookg>');
            Writeln(Fichero,'    <NbOfTxs>'+IntToStr(Numop)+'</NbOfTxs>');
            Writeln(Fichero,'    <CtrlSum>'+cambiacoma(floattostrf(ftotal,fffixed,18,2))+'</CtrlSum>');
            Writeln(Fichero,'    <PmtTpInf>');
            Writeln(Fichero,'      <InstrPrty>NORM</InstrPrty>');
            Writeln(Fichero,'      <SvcLvl>');
            Writeln(Fichero,'       <Cd>SEPA</Cd>');
            Writeln(Fichero,'      </SvcLvl>');
            Writeln(Fichero,'      <CtgyPurp>');
            Writeln(Fichero,'       <Cd>SALA</Cd>');
            Writeln(Fichero,'      </CtgyPurp>');
            Writeln(Fichero,'    </PmtTpInf>');
            Writeln(Fichero,'    <ReqdExctnDt>'+formatdatetime('yyyy-mm-dd',Date)+'</ReqdExctnDt>');
            Writeln(Fichero,'    <Dbtr>');
            Writeln(Fichero,'      <Nm>'+LimpiarCarNormaSEPAXML(EdNombre.text,70)+'</Nm>');
            Writeln(Fichero,'      <Id>');
            Writeln(Fichero,'        <OrgId>');
            Writeln(Fichero,'          <Othr>');
            Writeln(Fichero,'            <Id>'+LimpiarCarNormaSEPAXML(EdCif.Text+edsufijo.text,16)+'</Id>');
            Writeln(Fichero,'          </Othr>');
            Writeln(Fichero,'        </OrgId>');
            Writeln(Fichero,'      </Id>');
            Writeln(Fichero,'    </Dbtr>');
            Writeln(Fichero,'    <DbtrAcct>');
            Writeln(Fichero,'      <Id>');
            ibanordenante := comboIban.Text;
            Writeln(Fichero,'       <IBAN>'+LimpiarCarNormaSEPAXML(ibanordenante,35)+'</IBAN>');
            Writeln(Fichero,'      </Id>');
            Writeln(Fichero,'    </DbtrAcct>');
            Writeln(Fichero,'    <DbtrAgt>');
            Writeln(Fichero,'      <FinInstnId>');
            //Writeln(Fichero,'        <BIC>'+ Qcuentabanconomina['bic']+'</BIC>');
            Writeln(Fichero,'        <BIC>'+ edBic.Text +'</BIC>');
            Writeln(Fichero,'      </FinInstnId>');
            Writeln(Fichero,'    </DbtrAgt>');
            QLineasRemesa.First;
            while not QLineasRemesa.Eof do
            begin
              Writeln(fichero,'    <CdtTrfTxInf>');
              Writeln(fichero,'      <PmtId>');
              // general identificadorunico
              idunico := 'TRFCHK'+formatdatetime('yyyymmddhhmmsszzz',now);
              Writeln(fichero,'       <EndToEndId>'+LimpiarCarNormaSEPAXML(idunico,35)+'</EndToEndId>');
              Writeln(fichero,'      </PmtId>');
              Writeln(fichero,'      <Amt>');
              numero := cambiacoma(floattostr(trunc(QLineasRemesa['sneto']*100)/100));
              Writeln(fichero,'        <InstdAmt Ccy="EUR">'+LimpiarCarNormaSEPAXML(numero,11)+'</InstdAmt>');
              Writeln(fichero,'      </Amt>');
              Writeln(fichero,'      <ChrgBr>SLEV</ChrgBr>');
              Writeln(fichero,'      <CdtrAgt>');
              Writeln(fichero,'        <FinInstnId>');
              Writeln(Fichero,'        <BIC>'+ QLineasRemesa['bic']+'</BIC>');
              Writeln(fichero,'        </FinInstnId>');
              Writeln(fichero,'      </CdtrAgt>');
              Writeln(fichero,'      <Cdtr>');
              if QLineasRemesa['nombre'] <> null then
                  nombre := LimpiarCarNormaSEPAXML(QLineasRemesa['nombre'],35)
              else
                  nombre := '';
              if QLineasRemesa['apellidos'] <> null then
                apellidos := LimpiarCarNormaSEPAXML(QLineasRemesa['apellidos'],35)
              else
                apellidos := '';
              Writeln(fichero,'        <Nm>'+LimpiarCarNormaSEPAXML(nombre+' '+apellidos,35)+'</Nm>');
              Writeln(Fichero,'       <Id>');
              Writeln(Fichero,'         <PrvtId>');
              Writeln(Fichero,'           <Othr>');

              if QLineasRemesa['nif']<>NULL then
                cif := QLineasRemesa ['nif']
              else
                cif := '';
              Writeln(Fichero,'             <Id>'+LimpiarCarNormaSEPAXML(cif,16)+'</Id>');
              Writeln(Fichero,'           </Othr>');
              Writeln(Fichero,'         </PrvtId>');
              Writeln(Fichero,'       </Id>');
              Writeln(fichero,'      </Cdtr>');
              Writeln(fichero,'      <CdtrAcct>');
              Writeln(Fichero,'        <Id>');
              Writeln(Fichero,'          <IBAN>'+LimpiarCarNormaSEPAXML(QLineasRemesa['iban'],35)+'</IBAN>');
              Writeln(Fichero,'        </Id>');
              Writeln(fichero,'      </CdtrAcct>');
              Writeln(fichero,'      <Purp>');
              Writeln(fichero,'        <Cd>SALA</Cd>');
              Writeln(fichero,'      </Purp>');
              Writeln(fichero,'    </CdtTrfTxInf>');

              bpRemesa.Position := Round((QLineasRemesa.RecNo/numop)*100);
              QLineasRemesa.Next;
              Sleep(500);
            end;
          Writeln(Fichero,'  </PmtInf>');
          Writeln(Fichero,' </CstmrCdtTrfInitn>');
          Writeln(Fichero,'</Document>');
          CloseFile(fichero);
          { --------------------------------------------------------------- VER COMO SE CREAN ESTOS MENSAJES
          mensaje.IconType := suiInformation;
          mensaje.Text := 'Fichero creado.';
          mensaje.ShowModal;  }
          with DataModule1.QEmitirRemesa do
          begin
            if Active then
              Close;
            ParamByName('remesa').Value := StrToInt(edREmesa.Text);
            ExecSQL;
          end;
          //bpRemesa.Visible := false;
          showMessage('Fichero creado');
          bpRemesa.Visible := false;
          lbRemesaEmitida.Visible := true;
          bRemesaEmitida := true;
          end // del ioresult = 0
          else
          begin
            {mensaje.IconType := suiStop;
            mensaje.Text := 'No se ha podido crear el fichero.Compruebe que la ruta en la configuracion de usuario es correcta';
            Mensaje.ShowModal;}
            showMessage('No se ha podido crear el fichero.Compruebe que la ruta en la configuracion de usuario es correcta');
          end;
        end;
    end;
  end;
end;

procedure TForm6.btImprimirClick(Sender: TObject);
begin
  with DataModule1.QInformeRemesa do
  begin
    if Active then
      Close;
    ParamByName('remesa').Value := edRemesa.Text;
    Open;
  end;
  rbInformeRemesa.Print;
end;

end.
