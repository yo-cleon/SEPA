unit ModuloDatos;

interface

uses
  System.SysUtils, System.Classes, FIBDatabase, pFIBDatabase, Data.DB,
  JvDataSource, FIBDataSet, pFIBDataSet, FIBQuery, pFIBQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase,
  FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  MemTableDataEh, DataDriverEh, MemTableEh;

type
  TDataModule1 = class(TDataModule)
    BaseDatos: TFDConnection;
    TPrincipal: TFDTransaction;
    TUpdate: TFDTransaction;
    QEmpresas: TFDQuery;
    DSEmpresas: TDataSource;
    DSEmpleados: TDataSource;
    QUnaEmpresa: TFDQuery;
    QUltimaEmpresa: TFDQuery;
    QGuardarEmpresa: TFDQuery;
    IntegerField1: TIntegerField;
    QUltimoEmpleado: TFDQuery;
    QPrimeraEmpresa: TFDQuery;
    QPrimerEmpleado: TFDQuery;
    QUltimaEmpresaULTIMAEMPRESA: TIntegerField;
    QPrimeraEmpresaPRIMERAEMPRESA: TIntegerField;
    QPrimerEmpleadoPRIMEREMPLEADO: TIntegerField;
    QUltimoEmpleadoULTIMOEMPLEADO: TIntegerField;
    QUnEmpleado: TFDQuery;
    QGuardarEmpleado: TFDQuery;
    DSTodosEmpleados: TDataSource;
    QUnaEmpresaCODEMPRESA: TIntegerField;
    QUnaEmpresaCIF: TWideStringField;
    QUnaEmpresaNOMBRE: TWideStringField;
    QUnaEmpresaDIRECCION: TWideStringField;
    QUnaEmpresaCP: TWideStringField;
    QUnaEmpresaLOCALIDAD: TWideStringField;
    QBuscarCuentaPorDefecto: TFDQuery;
    QUltimaCuenta: TFDQuery;
    QEmpleados: TFDQuery;
    QTodosEmpleados: TFDQuery;
    QTodosEmpleadosCODEMPRESA: TIntegerField;
    QTodosEmpleadosCODEMPLEADO: TIntegerField;
    QTodosEmpleadosNOMBRE: TWideStringField;
    QTodosEmpleadosAPELLIDOS: TWideStringField;
    QTodosEmpleadosNIF: TWideStringField;
    QTodosEmpleadosLOCALIDAD: TWideStringField;
    QTodosEmpleadosIBAN: TWideStringField;
    QTodosEmpleadosSNETO: TSingleField;
    QTodosEmpleadosACTIVO: TIntegerField;
    DSUnaEmpresa: TDataSource;
    QEmpresasCODEMPRESA: TIntegerField;
    QEmpresasNOMBRE: TWideStringField;
    QEmpresasCIF: TWideStringField;
    QEmpresasDIRECCION: TWideStringField;
    QEmpresasCP: TWideStringField;
    QEmpresasLOCALIDAD: TWideStringField;
    DSCuentasEmpresa: TDataSource;
    QCuentasEmpresa: TFDQuery;
    DSCabeceraRemesa: TDataSource;
    QCabeceraRemesa: TFDQuery;
    DSLineasRemesa: TDataSource;
    QLineasRemesa: TFDQuery;
    QDatosCuenta: TFDQuery;
    QDatosCuentaCODIGO: TIntegerField;
    QDatosCuentaCODEMPRESA: TIntegerField;
    QDatosCuentaIBAN: TWideStringField;
    QDatosCuentaSUFIJO: TWideStringField;
    QSiguienteRemesa: TFDQuery;
    QSiguienteLinea: TFDQuery;
    QNuevaLineaRemesa: TFDQuery;
    QNuevaLineaRemesaCODREMESA: TIntegerField;
    QNuevaLineaRemesaCODOPERACION: TIntegerField;
    QNuevaLineaRemesaCODEMPLEADO: TIntegerField;
    QNuevaLineaRemesaIBAN: TWideStringField;
    QNuevaLineaRemesaSNETO: TSingleField;
    QSiguienteLineaLINEA: TIntegerField;
    QTotalRemesa: TFDQuery;
    QTotalRemesaTOTALREMESA: TFloatField;
    QUnaRemesa: TFDQuery;
    QCuentasEmpresaCODIGO: TIntegerField;
    QCuentasEmpresaCODEMPRESA: TIntegerField;
    QCuentasEmpresaIBAN: TWideStringField;
    QCuentasEmpresaBIC: TWideStringField;
    QCuentasEmpresaSUFIJO: TWideStringField;
    QCuentasEmpresaPORDEFECTO: TIntegerField;
    QEmpleadosCODEMPRESA: TIntegerField;
    QEmpleadosCODEMPLEADO: TIntegerField;
    QEmpleadosNOMBRE: TWideStringField;
    QEmpleadosAPELLIDOS: TWideStringField;
    QEmpleadosNIF: TWideStringField;
    QEmpleadosLOCALIDAD: TWideStringField;
    QEmpleadosIBAN: TWideStringField;
    QEmpleadosBIC: TWideStringField;
    QEmpleadosSNETO: TSingleField;
    QEmpleadosACTIVO: TIntegerField;
    QTodosEmpleadosBIC: TWideStringField;
    QPorDefecto: TFDQuery;
    QPrimeraCuentaPorDefecto: TFDQuery;
    QLineasRemesaCODREMESA: TIntegerField;
    QLineasRemesaCODOPERACION: TIntegerField;
    QLineasRemesaCODEMPLEADO: TIntegerField;
    QLineasRemesaNIF: TWideStringField;
    QLineasRemesaNOMBRE: TWideStringField;
    QLineasRemesaAPELLIDOS: TWideStringField;
    QLineasRemesaIBAN: TWideStringField;
    QLineasRemesaBIC: TWideStringField;
    QLineasRemesaSNETO: TSingleField;
    QNuevaLineaRemesaBIC: TWideStringField;
    QDatosCuentaBIC: TWideStringField;
    QUltimaCuentaCODIGO: TIntegerField;
    QPrimeraCuentaEmpresa: TFDQuery;
    QPrimeraCuentaEmpresaCODIGO: TIntegerField;
    QBuscarCuentaPorDefectoCODIGO: TIntegerField;
    QBuscarCuentaPorDefectoCODEMPRESA: TIntegerField;
    QBuscarCuentaPorDefectoIBAN: TWideStringField;
    QBuscarCuentaPorDefectoBIC: TWideStringField;
    QBuscarCuentaPorDefectoSUFIJO: TWideStringField;
    QBuscarCuentaPorDefectoPORDEFECTO: TIntegerField;
    QBuscarNif: TFDQuery;
    QBuscarNifCODEMPRESA: TIntegerField;
    QBuscarNifCODEMPLEADO: TIntegerField;
    QBuscarNifNOMBRE: TWideStringField;
    QBuscarNifAPELLIDOS: TWideStringField;
    QBuscarNifNIF: TWideStringField;
    QBuscarNifACTIVO: TIntegerField;
    QBorrarRemesa: TFDQuery;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    WideStringField3: TWideStringField;
    SingleField1: TSingleField;
    IntegerField4: TIntegerField;
    QCambiaEmpleado: TFDQuery;
    QEmitirRemesa: TFDQuery;
    IntegerField5: TIntegerField;
    IntegerField6: TIntegerField;
    WideStringField4: TWideStringField;
    WideStringField5: TWideStringField;
    WideStringField6: TWideStringField;
    SingleField2: TSingleField;
    IntegerField7: TIntegerField;
    QRemesas: TFDQuery;
    IntegerField8: TIntegerField;
    IntegerField9: TIntegerField;
    WideStringField7: TWideStringField;
    WideStringField8: TWideStringField;
    WideStringField9: TWideStringField;
    SingleField3: TSingleField;
    IntegerField10: TIntegerField;
    DSRemesas: TDataSource;
    QUnaRemesaCODREMESA: TIntegerField;
    QUnaRemesaCODEMPRESA: TIntegerField;
    QUnaRemesaNOMBRE: TWideStringField;
    QUnaRemesaCIF: TWideStringField;
    QUnaRemesaMES: TWideStringField;
    QUnaRemesaANIO: TWideStringField;
    QUnaRemesaIBAN: TWideStringField;
    QUnaRemesaBIC: TWideStringField;
    QUnaRemesaSUFIJO: TWideStringField;
    QUnaRemesaTOTAL: TSingleField;
    QUnaRemesaEMITIDO: TIntegerField;
    QCabeceraRemesaCODREMESA: TIntegerField;
    QCabeceraRemesaCODEMPRESA: TIntegerField;
    QCabeceraRemesaNOMBRE: TWideStringField;
    QCabeceraRemesaMES: TWideStringField;
    QCabeceraRemesaANIO: TWideStringField;
    QCabeceraRemesaIBAN: TWideStringField;
    QCabeceraRemesaBIC: TWideStringField;
    QCabeceraRemesaSUFIJO: TWideStringField;
    QCabeceraRemesaTOTAL: TSingleField;
    QCabeceraRemesaEMITIDO: TIntegerField;
    QSiguienteRemesaNUEVAREMESA: TIntegerField;
    DSInformeRemesa: TDataSource;
    QInformeRemesa: TFDQuery;
    QInformeRemesaCODEMPRESA: TIntegerField;
    QInformeRemesaNOMBRE: TWideStringField;
    QInformeRemesaCIF: TWideStringField;
    QInformeRemesaCODREMESA: TIntegerField;
    QInformeRemesaMES: TWideStringField;
    QInformeRemesaANIO: TWideStringField;
    QInformeRemesaIBAN: TWideStringField;
    QInformeRemesaBIC: TWideStringField;
    QInformeRemesaSUFIJO: TWideStringField;
    QInformeRemesaTOTAL: TSingleField;
    QInformeRemesaEMITIDO: TIntegerField;
    QInformeRemesaCODOPERACION: TIntegerField;
    QInformeRemesaCODEMPLEADO: TIntegerField;
    QInformeRemesaNOMBRE_1: TWideStringField;
    QInformeRemesaAPELLIDOS: TWideStringField;
    QInformeRemesaIBAN_1: TWideStringField;
    QInformeRemesaBIC_1: TWideStringField;
    QInformeRemesaSNETO: TSingleField;
    QBuscaCif: TFDQuery;
    QBuscaCifCODEMPRESA: TIntegerField;
    QBuscaCifNOMBRE: TWideStringField;
    QBuscaCifCIF: TWideStringField;
    QBuscaCifDIRECCION: TWideStringField;
    QBuscaCifCP: TWideStringField;
    QBuscaCifLOCALIDAD: TWideStringField;
    QBorrarLineaRemesa: TFDQuery;
    procedure QCuentasEmpresaBeforePost(DataSet: TDataSet);
    procedure QEmpleadosBeforePost(DataSet: TDataSet);
    procedure QTodosEmpleadosBeforePost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure LeerIni();

  private
    { Private declarations }
  public
    { Public declarations }
    sBD, sPath : string;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses inifiles,  AltaEmpresa, AltaEmpleado, Vcl.Forms;

{$R *.dfm}

procedure TDataModule1.LeerIni();
var
  appINI : TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  try
    //if no last user return an empty string
    sBD := appINI.ReadString('Params','BD','') ;
    //if no last date return todays date
    sPath := appINI.ReadString('Params', 'Path', '') ;
    //show the message
    BaseDatos.Params.Database := sBD;
    if not directoryexists(sPath) then
      Createdir(sPath);
  finally
    appINI.Free;
  end;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  LeerIni();
end;

procedure TDataModule1.QCuentasEmpresaBeforePost(DataSet: TDataSet);
begin
  QCuentasEmpresa['codempresa'] := QEmpresas.FieldByName('CODEMPRESA').AsInteger;
end;

procedure TDataModule1.QEmpleadosBeforePost(DataSet: TDataSet);
begin
  QEmpleados['codempresa'] := QEmpresas.FieldByName('codempresa').AsInteger;
  QEmpleados['activo'] := 1;
end;

procedure TDataModule1.QTodosEmpleadosBeforePost(DataSet: TDataSet);
begin
  QTodosEmpleados['codempresa'] := QEmpresas.FieldByName('codempresa').AsInteger;
  QTodosEmpleados['activo'] := 1;
end;

end.
