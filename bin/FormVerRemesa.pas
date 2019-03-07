unit FormVerRemesa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, Vcl.ComCtrls, JvExComCtrls, JvStatusBar,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.StdCtrls, Vcl.Mask, DBCtrlsEh,
  JvExStdCtrls, JvCombobox, JvLabel, JvExControls, JvButton,
  JvTransparentButton, AdvGroupBox, JvEdit, FireDAC.Stan.Param, ppParameter,
  ppDesignLayer, ppBands, ppCtrls, ppPrnabl, ppClass, ppCache, ppProd, ppReport,
  ppDB, ppComm, ppRelatv, ppDBPipe, ppVar, ppStrtch, ppRichTx, acProgressBar,
  raCodMod, ppModule;

type
  TVerRemesa = class(TForm)
    empresaGB: TAdvGroupBox;
    btGenerar: TJvTransparentButton;
    btRellenar: TJvTransparentButton;
    lbCif: TJvLabel;
    lbNombre: TJvLabel;
    btBuscar: TJvTransparentButton;
    btBorrarRemesa: TJvTransparentButton;
    AdvGroupBox1: TAdvGroupBox;
    lbAnio: TJvLabel;
    lbMes: TJvLabel;
    lbIban: TJvLabel;
    lbSufijo: TJvLabel;
    lbTotal: TJvLabel;
    lbRemesa: TJvLabel;
    lbBIC: TJvLabel;
    comboMes: TJvComboBox;
    comboIban: TJvComboBox;
    gridRemesa: TDBGridEh;
    BarraEstado: TJvStatusBar;
    edCif: TJvEdit;
    edNombre: TJvEdit;
    edRemesa: TJvEdit;
    edAnio: TJvEdit;
    edBic: TJvEdit;
    edSufijo: TJvEdit;
    edTotal: TJvEdit;
    lbRemesaEmitida: TJvLabel;
    btImprimir: TJvTransparentButton;
    dbInformeRemesa: TppDBPipeline;
    rbInformeRemesa: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppDBText2: TppDBText;
    ppLabel3: TppLabel;
    ppDBText3: TppDBText;
    ppDetailBand1: TppDetailBand;
    ppLabel4: TppLabel;
    ppDBText4: TppDBText;
    ppLabel5: TppLabel;
    ppDBText5: TppDBText;
    ppLabel6: TppLabel;
    ppDBText6: TppDBText;
    ppFooterBand1: TppFooterBand;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    ppLabel7: TppLabel;
    ppDBText7: TppDBText;
    ppLine1: TppLine;
    ppDBText1: TppDBText;
    ppDBText8: TppDBText;
    ppLabel8: TppLabel;
    ppDBText9: TppDBText;
    ppLabel9: TppLabel;
    ppDBText10: TppDBText;
    ppLabel10: TppLabel;
    ppDBText11: TppDBText;
    ppShape1: TppShape;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppPageSummaryBand1: TppPageSummaryBand;
    ppLine2: TppLine;
    ppRichText1: TppRichText;
    bpRemesa: TsProgressBar;
    btBorrarEmpleado: TJvTransparentButton;
    sdRutaFichero: TSaveDialog;
    ppDBCalc1: TppDBCalc;
    ppLabel13: TppLabel;
    procedure FormActivate(Sender: TObject);
    procedure btBorrarRemesaClick(Sender: TObject);
    procedure limpiarPantalla;
    procedure MostrarRemesa;
    procedure btBuscarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btImprimirClick(Sender: TObject);
    procedure btGenerarClick(Sender: TObject);
    procedure calculaTotalRemesa();
    procedure gridRemesaKeyPress(Sender: TObject; var Key: Char);
    procedure gridRemesaSelectionChanged(Sender: TObject);
    procedure comboIbanChange(Sender: TObject);
    procedure CargarIban(iban:string);
    procedure btBorrarEmpleadoClick(Sender: TObject);
    function cambiacoma(num:string):string;
    function LimpiarCarNormaSEPAXML(texto: String; longitud: Integer):string;
    function EmitirRemesa():boolean;

  private
    { Private declarations }
    CodEmpresa : Integer;
    bRemesaEmitida : Boolean;
  public
    { Public declarations }
    remesaAMostrar : Integer;

  end;

var
  VerRemesa: TVerRemesa;

implementation

{$R *.dfm}

uses
  ModuloDatos, PantallaRemesas, PantallaPrincipal;

{******************************************************************
********************* CREACIÓN DEL FORMULARIO *********************
*******************************************************************}

procedure TVerRemesa.FormActivate(Sender: TObject);
begin
//----------- Control del evento FormActivate
  if (Tag = 0) or (Tag = 1) then
  begin
    Tag := 999;
    MostrarRemesa();
  end;
end;

procedure TVerRemesa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Tag := 0;
  bRemesaEmitida := false;
  limpiarPantalla;
end;

{******************************************************************
************ PROCEDIMIENTOS GENÉRICOS DEL FORMULARIO **************
*******************************************************************}

procedure TVerRemesa.CargarIban(iban:string);
begin
  with DataModule1.QBuscaCif do
  begin
    if Active then
      Close;
    ParamByName('cif').Value := edCif.Text;
    Open;
    CodEmpresa := FieldByName('CodEmpresa').AsInteger;
  end;
  with DataModule1.QCuentasEmpresa do
  begin
    if Active then
      Close;
    ParamByName('empresa').Value := CodEmpresa;
    Open;
    while not Eof do
    begin
      comboIban.Items.Add(FieldByName('IBAN').AsString);
      Next;
    end;
    comboIban.Text := DataModule1.QUnaRemesa.FieldByName('IBAN').AsString
  end;
end;

procedure TVerRemesa.MostrarRemesa;
var
  aux : integer;
begin
  with DataModule1.QUnaRemesa do
    begin
      if Active then
        Close;
      ParamByName('remesa').Value := remesaAMostrar;
      Open;
      edCif.Text := FieldByName('CIF').AsString;
      edNombre.Text := FieldByName('nombre').AsString;
      edRemesa.Text := FieldByName('codremesa').AsString;
      edAnio.Text := FieldByName('anio').AsString;
      comboMes.Text := FieldByName('mes').AsString;
      //comboIban.Text := FieldByName('iban').AsString;
      cargarIban(FieldByName('iban').AsString);
      edBic.Text := FieldByName('BIC').AsString;
      edSufijo.Text := FieldByName('sufijo').AsString;
      edTotal.Text := FormatFloat('#,##0.00 €',FieldByName('total').AsFloat);
      if FieldByName('EMITIDO').AsInteger = 1 then
      begin
        lbRemesaEmitida.Visible := true;
        gridRemesa.DataSource.DataSet.Open;
        edAnio.Color := clInfoBk;
        comboMes.Color := clInfoBk;
        comboMes.ReadOnly := true;
        comboIban.Color := clInfoBk;
        comboIban.ReadOnly := true;
        bRemesaEmitida := true;
      end
      else
      begin
        edAnio.Color := clWindow;
        comboMes.Color := clWindow;
        comboMes.ReadOnly := false;
        comboIban.Color := clWindow;
        comboIban.ReadOnly := false;
        gridRemesa.ReadOnly := false;
      end;
      with DataModule1.QLineasRemesa do
      begin
        Close;
        ParamByName('remesa').Value := remesaAMostrar;
        Open;
      end;
    end;
end;

function TVerRemesa.EmitirRemesa():boolean;
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

procedure TVerRemesa.limpiarPantalla;
begin
  edCif.Text := '';
  edNombre.Text := '';
  edRemesa.Text := '';
  edAnio.Text := '';
  comboMes.Text := '';
  comboIban.Items.Clear;
  comboIban.Text := '';
  edBic.Text := '';
  edSufijo.Text := '';
  edTotal.Text := '';
  lbRemesaEmitida.Visible := False;
  gridRemesa.DataSource.DataSet.Close;
  bRemesaEmitida := false;
end;

function TVerRemesa.cambiacoma(num:string):string;
{var
 aux : string;  }
begin
  result := Stringreplace(num,',','.',[rfReplaceAll, rfIgnoreCase]);
end;

Function TVerRemesa.LimpiarCarNormaSEPAXML(texto: String; longitud: Integer): String;
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

procedure TVerRemesa.calculaTotalRemesa();
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

procedure TVerRemesa.comboIbanChange(Sender: TObject);
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

procedure TVerRemesa.gridRemesaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  // ( #13 = tecla enter )
   begin
    gridRemesa.DataSource.DataSet.Post;
    calculaTotalRemesa();
   end;
end;

procedure TVerRemesa.gridRemesaSelectionChanged(Sender: TObject);
begin
  calculaTotalRemesa();
end;

{******************************************************************
********************* GESTIÓN DE LOS BOTONES **********************
*******************************************************************}

procedure TVerRemesa.btBuscarClick(Sender: TObject);
begin
  //limpiarPantalla();
  with TForm7.Create(nil) do
  begin
    Show;
  end;
end;

procedure TVerRemesa.btGenerarClick(Sender: TObject);
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
//  aux : string;
  num010,numreg341 : integer;
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

//          QLineasREmesa.First;

          ftotal := QUnaRemesa['total'];

//************ INICIALIZACIÓN BARRA DE PROGRESO ***********
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
          rutaFichero := DataModule1.sPath+'\'+NombreDir;
          if not directoryexists(rutaFichero) then
            Createdir(rutaFichero);


          {if rbsepa.Checked then
             nombrefichero := copy(QUnaRemesa['anio']+QUnaRemesa['mes']+QUnaRemesa['E.nombre'],1,6) + '.n34'  //**ANULADO MODELO .N34 POR OBSOLETOANULADO MODELO .N34 POR OBSOLETO
          else}
             //nombrefichero := copy(QUnaRemesa['anio']+QUnaRemesa['mes']+QUnaRemesa['nombre'],1,10) + '.xml';  }

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
          { ------------------------------------------- VER COMO SE CREAN ESTOS MENSAJES
          mensaje.IconType := suiInformation;
          mensaje.Text := 'Fichero creado.';
          mensaje.ShowModal;  }
          if EmitirRemesa() then
            showMEssage('Fichero creado y remesa emitida correctamente')
          else
            showMessage('Ha habido un error al generar y emitir la remesa');
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

procedure TVerRemesa.btImprimirClick(Sender: TObject);
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

procedure TVerRemesa.btBorrarEmpleadoClick(Sender: TObject);
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
      calculaTotalRemesa();
    end;
  end
  else
    showMessage('La remesa está emitida y no puede ser modificada.');
end;

procedure TVerRemesa.btBorrarRemesaClick(Sender: TObject);
var
  remesa : integer;
begin
  remesa := StrToInt(edRemesa.Text);
  with DataModule1.QUnaRemesa do
  begin
    if Active then
      Close();
    ParamByName('remesa').Value := remesa;
    Open();
    if not bRemesaEmitida then
    begin
      try
        with DataModule1.QBorrarRemesa do
        begin
          if Active then
            Close;
          ParamByName('remesa').Value := remesa;
          ExecSQL;
        end;
        ShowMessage('Remesa borrada correctamente.');
        gridREmesa.DataSource.DataSet.Refresh;
        limpiarPantalla;
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

end.
