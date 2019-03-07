object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 612
  Width = 950
  object BaseDatos: TFDConnection
    Params.Strings = (
      'CharacterSet=UTF8'
      'User_Name=sysdba'
      'Password=masterkey'
      'Database=C:\SEPA\SEPA\data\SEPA.FDB'
      'Port=3050'
      'Server=localhost'
      'DriverID=FB')
    TxOptions.AutoStop = False
    LoginPrompt = False
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    Left = 48
    Top = 16
  end
  object TPrincipal: TFDTransaction
    Connection = BaseDatos
    Left = 24
    Top = 72
  end
  object TUpdate: TFDTransaction
    Connection = BaseDatos
    Left = 72
    Top = 72
  end
  object QEmpresas: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select '
      '  CODEMPRESA,'
      '  NOMBRE,'
      '  CIF,'
      '  DIRECCION,'
      '  CP,'
      '  LOCALIDAD '
      'from EMPRESA'
      'order by CODEMPRESA')
    Left = 208
    Top = 72
    object QEmpresasCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QEmpresasNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 100
    end
    object QEmpresasCIF: TWideStringField
      FieldName = 'CIF'
      Origin = 'CIF'
      Required = True
      Size = 9
    end
    object QEmpresasDIRECCION: TWideStringField
      FieldName = 'DIRECCION'
      Origin = 'DIRECCION'
      Size = 150
    end
    object QEmpresasCP: TWideStringField
      FieldName = 'CP'
      Origin = 'CP'
      Required = True
      Size = 5
    end
    object QEmpresasLOCALIDAD: TWideStringField
      FieldName = 'LOCALIDAD'
      Origin = 'LOCALIDAD'
      Required = True
      Size = 60
    end
  end
  object DSEmpresas: TDataSource
    DataSet = QEmpresas
    Enabled = False
    Left = 208
    Top = 24
  end
  object DSEmpleados: TDataSource
    DataSet = QEmpleados
    Enabled = False
    Left = 144
    Top = 192
  end
  object QUnaEmpresa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      
        'select CODEMPRESA, CIF, NOMBRE, DIRECCION, CP, LOCALIDAD from EM' +
        'PRESA'
      ' where CODEMPRESA = :empresa')
    Left = 280
    Top = 72
    ParamData = <
      item
        Name = 'EMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QUnaEmpresaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QUnaEmpresaCIF: TWideStringField
      FieldName = 'CIF'
      Origin = 'CIF'
      Required = True
      Size = 9
    end
    object QUnaEmpresaNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 100
    end
    object QUnaEmpresaDIRECCION: TWideStringField
      FieldName = 'DIRECCION'
      Origin = 'DIRECCION'
      Size = 150
    end
    object QUnaEmpresaCP: TWideStringField
      FieldName = 'CP'
      Origin = 'CP'
      Required = True
      Size = 5
    end
    object QUnaEmpresaLOCALIDAD: TWideStringField
      FieldName = 'LOCALIDAD'
      Origin = 'LOCALIDAD'
      Required = True
      Size = 60
    end
  end
  object QUltimaEmpresa: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select max(codempresa) as UltimaEmpresa from EMPRESA'
      '')
    Left = 376
    Top = 24
    object QUltimaEmpresaULTIMAEMPRESA: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ULTIMAEMPRESA'
      Origin = 'ULTIMAEMPRESA'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QGuardarEmpresa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      
        'insert into EMPRESA (CODEMPRESA, NOMBRE, CIF, DIRECCION, CP, LOC' +
        'ALIDAD)'
      ' values (:empresa, :nombre, :cif, :direccion, :cp, :localidad)'
      '')
    Left = 456
    Top = 24
    ParamData = <
      item
        Name = 'EMPRESA'
        ParamType = ptInput
      end
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'CIF'
        ParamType = ptInput
      end
      item
        Name = 'DIRECCION'
        ParamType = ptInput
      end
      item
        Name = 'CP'
        ParamType = ptInput
      end
      item
        Name = 'LOCALIDAD'
        ParamType = ptInput
      end>
    object IntegerField1: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QUltimoEmpleado: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select MAX(CODEMPLEADO) as UltimoEmpleado from EMPLEADO'
      ''
      '')
    Left = 216
    Top = 192
    object QUltimoEmpleadoULTIMOEMPLEADO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ULTIMOEMPLEADO'
      Origin = 'ULTIMOEMPLEADO'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QPrimeraEmpresa: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select MIN(CODEMPRESA) as PrimeraEmpresa from EMPRESA')
    Left = 376
    Top = 72
    object QPrimeraEmpresaPRIMERAEMPRESA: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'PRIMERAEMPRESA'
      Origin = 'PRIMERAEMPRESA'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QPrimerEmpleado: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select MIN(CODEMPLEADO) as PrimerEmpleado from EMPLEADO'
      'where CODEMPRESA = :empresa'
      '')
    Left = 216
    Top = 240
    ParamData = <
      item
        Name = 'EMPRESA'
        ParamType = ptInput
      end>
    object QPrimerEmpleadoPRIMEREMPLEADO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'PRIMEREMPLEADO'
      Origin = 'PRIMEREMPLEADO'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QUnEmpleado: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select '
      ' CODEMPRESA,'
      ' CODEMPLEADO,'
      ' NOMBRE,'
      ' APELLIDOS,'
      ' NIF,'
      ' LOCALIDAD,'
      ' IBAN,'
      ' SNETO,'
      ' ACTIVO'
      'from empleado'
      'where CODEMPLEADO = :empleado')
    Left = 280
    Top = 192
    ParamData = <
      item
        Name = 'EMPLEADO'
        ParamType = ptInput
      end>
  end
  object QGuardarEmpleado: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      
        'insert into EMPLEADO (CODEMPRESA, CODEMPLEADO, NOMBRE, APELLIDOS' +
        ', NIF, LOCALIDAD, IBAN, SNETO, ACTIVO)'
      
        'values (:EMPRESA, :EMPLEADO, :NOMBRE, :APELLIDOS, :NIF, :LOCALID' +
        'AD, :IBAN, :SNETO, :ACTIVO)')
    Left = 280
    Top = 240
    ParamData = <
      item
        Name = 'EMPRESA'
        ParamType = ptInput
      end
      item
        Name = 'EMPLEADO'
        ParamType = ptInput
      end
      item
        Name = 'NOMBRE'
        ParamType = ptInput
      end
      item
        Name = 'APELLIDOS'
        ParamType = ptInput
      end
      item
        Name = 'NIF'
        ParamType = ptInput
      end
      item
        Name = 'LOCALIDAD'
        ParamType = ptInput
      end
      item
        Name = 'IBAN'
        ParamType = ptInput
      end
      item
        Name = 'SNETO'
        ParamType = ptInput
      end
      item
        Name = 'ACTIVO'
        ParamType = ptInput
      end>
  end
  object DSTodosEmpleados: TDataSource
    DataSet = QTodosEmpleados
    Left = 72
    Top = 192
  end
  object QBuscarCuentaPorDefecto: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select'
      '  CODIGO,'
      '  CODEMPRESA,'
      '  IBAN,'
      '  BIC,'
      '  SUFIJO,'
      '  PORDEFECTO'
      'from CUENTA'
      'where'
      '  codempresa = :empresa'
      '  and pordefecto = 1')
    Left = 688
    Top = 24
    ParamData = <
      item
        Name = 'EMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QBuscarCuentaPorDefectoCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QBuscarCuentaPorDefectoCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QBuscarCuentaPorDefectoIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QBuscarCuentaPorDefectoBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QBuscarCuentaPorDefectoSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QBuscarCuentaPorDefectoPORDEFECTO: TIntegerField
      FieldName = 'PORDEFECTO'
      Origin = 'PORDEFECTO'
      Required = True
    end
  end
  object QUltimaCuenta: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select First(1) codigo from CUENTA order by codigo desc')
    Left = 776
    Top = 32
    object QUltimaCuentaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object QEmpleados: TFDQuery
    BeforePost = QEmpleadosBeforePost
    Connection = BaseDatos
    SQL.Strings = (
      'select '
      '  CODEMPRESA,'
      '  CODEMPLEADO,'
      '  NOMBRE,'
      '  APELLIDOS, '
      '  NIF,'
      '  LOCALIDAD,'
      '  IBAN,'
      '  BIC,'
      '  SNETO,'
      '  ACTIVO '
      'from empleado'
      'where ACTIVO = 1 and CODEMPRESA = :empresa'
      '')
    Left = 144
    Top = 240
    ParamData = <
      item
        Name = 'EMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QEmpleadosCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QEmpleadosCODEMPLEADO: TIntegerField
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QEmpleadosNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 50
    end
    object QEmpleadosAPELLIDOS: TWideStringField
      FieldName = 'APELLIDOS'
      Origin = 'APELLIDOS'
      Size = 100
    end
    object QEmpleadosNIF: TWideStringField
      FieldName = 'NIF'
      Origin = 'NIF'
      Required = True
      Size = 9
    end
    object QEmpleadosLOCALIDAD: TWideStringField
      FieldName = 'LOCALIDAD'
      Origin = 'LOCALIDAD'
      Required = True
      Size = 60
    end
    object QEmpleadosIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QEmpleadosBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QEmpleadosSNETO: TSingleField
      FieldName = 'SNETO'
      Origin = 'SNETO'
    end
    object QEmpleadosACTIVO: TIntegerField
      FieldName = 'ACTIVO'
      Origin = 'ACTIVO'
      Required = True
    end
  end
  object QTodosEmpleados: TFDQuery
    BeforePost = QTodosEmpleadosBeforePost
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  CODEMPRESA,'
      '  CODEMPLEADO, '
      '  NOMBRE, '
      '  APELLIDOS, '
      '  NIF, '
      '  LOCALIDAD, '
      '  IBAN,'
      '  BIC, '
      '  SNETO, '
      '  ACTIVO'
      'from empleado'
      'where CODEMPRESA = :empresa')
    Left = 72
    Top = 240
    ParamData = <
      item
        Name = 'EMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QTodosEmpleadosCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QTodosEmpleadosCODEMPLEADO: TIntegerField
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QTodosEmpleadosNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 50
    end
    object QTodosEmpleadosAPELLIDOS: TWideStringField
      FieldName = 'APELLIDOS'
      Origin = 'APELLIDOS'
      Size = 100
    end
    object QTodosEmpleadosNIF: TWideStringField
      FieldName = 'NIF'
      Origin = 'NIF'
      Required = True
      Size = 9
    end
    object QTodosEmpleadosLOCALIDAD: TWideStringField
      FieldName = 'LOCALIDAD'
      Origin = 'LOCALIDAD'
      Required = True
      Size = 60
    end
    object QTodosEmpleadosIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QTodosEmpleadosSNETO: TSingleField
      FieldName = 'SNETO'
      Origin = 'SNETO'
    end
    object QTodosEmpleadosACTIVO: TIntegerField
      FieldName = 'ACTIVO'
      Origin = 'ACTIVO'
      Required = True
    end
    object QTodosEmpleadosBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
  end
  object DSUnaEmpresa: TDataSource
    DataSet = QUnaEmpresa
    Left = 280
    Top = 24
  end
  object DSCuentasEmpresa: TDataSource
    DataSet = QCuentasEmpresa
    Left = 608
    Top = 32
  end
  object QCuentasEmpresa: TFDQuery
    BeforePost = QCuentasEmpresaBeforePost
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    SQL.Strings = (
      'select'
      '  CODIGO,'
      '  CODEMPRESA,'
      '  IBAN,'
      '  BIC,'
      '  SUFIJO,'
      '  PORDEFECTO'
      'from cuenta'
      'where codempresa = :empresa')
    Left = 608
    Top = 80
    ParamData = <
      item
        Name = 'EMPRESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QCuentasEmpresaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QCuentasEmpresaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QCuentasEmpresaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QCuentasEmpresaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QCuentasEmpresaSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QCuentasEmpresaPORDEFECTO: TIntegerField
      FieldName = 'PORDEFECTO'
      Origin = 'PORDEFECTO'
      Required = True
    end
  end
  object DSCabeceraRemesa: TDataSource
    DataSet = QCabeceraRemesa
    Left = 608
    Top = 208
  end
  object QCabeceraRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  R.CODREMESA,'
      '  R.CODEMPRESA,'
      '  E.NOMBRE,'
      '  R.MES,'
      '  R.ANIO,'
      '  R.IBAN,'
      '  R.BIC,'
      '  R.SUFIJO,'
      '  R.TOTAL,'
      '  R.EMITIDO'
      'From '
      '  REMESACAB R, EMPRESA E'
      'where'
      '  R.CODEMPRESA = E.CODEMPRESA')
    Left = 608
    Top = 256
    object QCabeceraRemesaCODREMESA: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QCabeceraRemesaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QCabeceraRemesaNOMBRE: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object QCabeceraRemesaMES: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object QCabeceraRemesaANIO: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object QCabeceraRemesaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QCabeceraRemesaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QCabeceraRemesaSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QCabeceraRemesaTOTAL: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object QCabeceraRemesaEMITIDO: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
  end
  object DSLineasRemesa: TDataSource
    DataSet = QLineasRemesa
    Left = 728
    Top = 208
  end
  object QLineasRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  R.CODREMESA,'
      '  R.CODOPERACION,'
      '  R.CODEMPLEADO,'
      '  E.NIF,'
      '  E.NOMBRE,'
      '  E.APELLIDOS,'
      '  R.IBAN,'
      '  R.BIC,'
      '  R.SNETO'
      'From '
      '  REMESALIN R, EMPLEADO E'
      'where'
      '  R.CODEMPLEADO = E.CODEMPLEADO and'
      '  R.CODREMESA = :remesa')
    Left = 728
    Top = 256
    ParamData = <
      item
        Name = 'REMESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QLineasRemesaCODREMESA: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QLineasRemesaCODOPERACION: TIntegerField
      FieldName = 'CODOPERACION'
      Origin = 'CODOPERACION'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QLineasRemesaCODEMPLEADO: TIntegerField
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      Required = True
    end
    object QLineasRemesaNIF: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NIF'
      Origin = 'NIF'
      ProviderFlags = []
      ReadOnly = True
      Size = 9
    end
    object QLineasRemesaNOMBRE: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object QLineasRemesaAPELLIDOS: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'APELLIDOS'
      Origin = 'APELLIDOS'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object QLineasRemesaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QLineasRemesaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QLineasRemesaSNETO: TSingleField
      FieldName = 'SNETO'
      Origin = 'SNETO'
      Required = True
    end
  end
  object QDatosCuenta: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select '
      '  CODIGO,'
      '  CODEMPRESA,'
      '  IBAN,'
      '  BIC,'
      '  SUFIJO'
      'from'
      '  CUENTA'
      'where'
      '  IBAN = :cuenta'
      'order by'
      '  CODIGO')
    Left = 688
    Top = 80
    ParamData = <
      item
        Name = 'CUENTA'
        DataType = ftWideString
        ParamType = ptInput
        Size = 24
      end>
    object QDatosCuentaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QDatosCuentaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QDatosCuentaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QDatosCuentaSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QDatosCuentaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
  end
  object QSiguienteRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select'
      '  MAX(CodRemesa) as NuevaRemesa'
      'from'
      '  REMESACAB')
    Left = 608
    Top = 304
    object QSiguienteRemesaNUEVAREMESA: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'NUEVAREMESA'
      Origin = 'NUEVAREMESA'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QSiguienteLinea: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select'
      '  MAX(CodOPERACION) as Linea'
      'from'
      '  REMESALIN'
      'where CodREmesa = :remesa')
    Left = 728
    Top = 360
    ParamData = <
      item
        Name = 'REMESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QSiguienteLineaLINEA: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'LINEA'
      Origin = 'LINEA'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QNuevaLineaRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  CODREMESA,'
      '  CODOPERACION,'
      '  CODEMPLEADO,'
      '  IBAN,'
      '  BIC,'
      '  SNETO'
      'From '
      '  REMESALIN R')
    Left = 728
    Top = 312
    object QNuevaLineaRemesaCODREMESA: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QNuevaLineaRemesaCODOPERACION: TIntegerField
      FieldName = 'CODOPERACION'
      Origin = 'CODOPERACION'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QNuevaLineaRemesaCODEMPLEADO: TIntegerField
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      Required = True
    end
    object QNuevaLineaRemesaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QNuevaLineaRemesaSNETO: TSingleField
      FieldName = 'SNETO'
      Origin = 'SNETO'
      Required = True
    end
    object QNuevaLineaRemesaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
  end
  object QTotalRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  SUM(SNETO) as TotalRemesa'
      'From '
      '  REMESALIN '
      'where'
      '  CODREMESA = :Remesa')
    Left = 608
    Top = 528
    ParamData = <
      item
        Name = 'REMESA'
        ParamType = ptInput
      end>
    object QTotalRemesaTOTALREMESA: TFloatField
      AutoGenerateValue = arDefault
      FieldName = 'TOTALREMESA'
      Origin = 'TOTALREMESA'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QUnaRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  R.CODREMESA,'
      '  R.CODEMPRESA,'
      '  E.NOMBRE,'
      '  E.CIF,'
      '  R.MES,'
      '  R.ANIO,'
      '  R.IBAN,'
      '  R.BIC,'
      '  R.SUFIJO,'
      '  R.TOTAL,'
      '  R.EMITIDO'
      'From '
      '  REMESACAB R, EMPRESA E'
      'where R.CODEMPRESA = E.CODEMPRESA'
      'and R.CODREMESA = :remesa'
      '  ')
    Left = 608
    Top = 360
    ParamData = <
      item
        Name = 'REMESA'
        ParamType = ptInput
      end>
    object QUnaRemesaCODREMESA: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QUnaRemesaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QUnaRemesaNOMBRE: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object QUnaRemesaCIF: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'CIF'
      Origin = 'CIF'
      ProviderFlags = []
      ReadOnly = True
      Size = 9
    end
    object QUnaRemesaMES: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object QUnaRemesaANIO: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object QUnaRemesaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QUnaRemesaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QUnaRemesaSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QUnaRemesaTOTAL: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object QUnaRemesaEMITIDO: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
  end
  object QPorDefecto: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    UpdateOptions.AssignedValues = [uvUpdateNonBaseFields]
    UpdateOptions.UpdateNonBaseFields = True
    SQL.Strings = (
      'update CUENTA set pordefecto = 0'
      ' where codempresa = :empresa'
      '  and codigo <> :codigocuenta')
    Left = 768
    Top = 80
    ParamData = <
      item
        Name = 'EMPRESA'
        ParamType = ptInput
      end
      item
        Name = 'CODIGOCUENTA'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
  object QPrimeraCuentaPorDefecto: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'update cuenta'
      '    set pordefecto = 1'
      '        where codigo = :primeraCuenta')
    Left = 864
    Top = 80
    ParamData = <
      item
        Name = 'PRIMERACUENTA'
        ParamType = ptInput
      end>
  end
  object QPrimeraCuentaEmpresa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select'
      '  First(1) codigo'
      'from CUENTA'
      'where codempresa = :empresa'
      'order by codigo')
    Left = 848
    Top = 32
    ParamData = <
      item
        Name = 'EMPRESA'
        ParamType = ptInput
      end>
    object QPrimeraCuentaEmpresaCODIGO: TIntegerField
      FieldName = 'CODIGO'
      Origin = 'CODIGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object QBuscarNif: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'select'
      '  CODEMPRESA,'
      '  CODEMPLEADO,'
      '  NOMBRE,'
      '  APELLIDOS,'
      '  NIF,'
      '  ACTIVO'
      'from empleado'
      'where NIF = :nif')
    Left = 352
    Top = 240
    ParamData = <
      item
        Name = 'NIF'
        DataType = ftWideString
        ParamType = ptInput
        Size = 9
      end>
    object QBuscarNifCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QBuscarNifCODEMPLEADO: TIntegerField
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QBuscarNifNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 50
    end
    object QBuscarNifAPELLIDOS: TWideStringField
      FieldName = 'APELLIDOS'
      Origin = 'APELLIDOS'
      Size = 100
    end
    object QBuscarNifNIF: TWideStringField
      FieldName = 'NIF'
      Origin = 'NIF'
      Required = True
      Size = 9
    end
    object QBuscarNifACTIVO: TIntegerField
      FieldName = 'ACTIVO'
      Origin = 'ACTIVO'
      Required = True
    end
  end
  object QBorrarRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'delete from REMESACAB'
      ' where CODREMESA = :remesa'
      '  ')
    Left = 608
    Top = 416
    ParamData = <
      item
        Name = 'REMESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object IntegerField2: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField3: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object WideStringField1: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object WideStringField2: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object WideStringField3: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object SingleField1: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object IntegerField4: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
  end
  object QCambiaEmpleado: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'update empleado'
      'set codempresa = :nuevaempresa'
      'where codempleado = :empleado')
    Left = 344
    Top = 192
    ParamData = <
      item
        Name = 'NUEVAEMPRESA'
        ParamType = ptInput
      end
      item
        Name = 'EMPLEADO'
        ParamType = ptInput
      end>
  end
  object QEmitirRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'update REMESACAB'
      'set emitido = 1'
      ' where CODREMESA = :remesa')
    Left = 608
    Top = 472
    ParamData = <
      item
        Name = 'REMESA'
        ParamType = ptInput
      end>
    object IntegerField5: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField6: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object WideStringField4: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object WideStringField5: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object WideStringField6: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object SingleField2: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object IntegerField7: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
  end
  object QRemesas: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select '
      '  R.CODREMESA,'
      '  R.CODEMPRESA,'
      '  E.NOMBRE,'
      '  R.MES,'
      '  R.ANIO,'
      '  R.TOTAL,'
      '  R.EMITIDO'
      'From '
      '  REMESACAB R'
      'inner join EMPRESA E'
      '  on R.CodEmpresa = E.CodEmpresa'
      'order by CODREMESA')
    Left = 496
    Top = 344
    object IntegerField8: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField9: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object WideStringField7: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object WideStringField8: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object WideStringField9: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object SingleField3: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object IntegerField10: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
  end
  object DSRemesas: TDataSource
    DataSet = QRemesas
    Left = 496
    Top = 280
  end
  object DSInformeRemesa: TDataSource
    DataSet = QInformeRemesa
    Left = 64
    Top = 368
  end
  object QInformeRemesa: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select'
      '  C.Codempresa,'
      '  E.Nombre,'
      '  E.Cif,'
      '  C.CodRemesa,'
      '  C.Mes,'
      '  C.Anio,'
      '  C.Iban,'
      '  C.Bic,'
      '  C.Sufijo,'
      '  C.Total,'
      '  C.Emitido,'
      '  L.CodOperacion,'
      '  L.CodEmpleado,'
      '  T.Nombre,'
      '  T.Apellidos,'
      '  L.Iban,'
      '  L.Bic,'
      '  L.Sneto    '
      'from RemesaCab C'
      '  inner join RemesaLin L'
      '   on C.CodRemesa = L.CodRemesa'
      '  inner join Empresa E'
      '    on C.CodEmpresa = E.codempresa'
      '  inner join Empleado T'
      '    on L.Codempleado = T.Codempleado'
      '  where C.CodRemesa = :remesa')
    Left = 64
    Top = 424
    ParamData = <
      item
        Name = 'REMESA'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object QInformeRemesaCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      Required = True
    end
    object QInformeRemesaNOMBRE: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object QInformeRemesaCIF: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'CIF'
      Origin = 'CIF'
      ProviderFlags = []
      ReadOnly = True
      Size = 9
    end
    object QInformeRemesaCODREMESA: TIntegerField
      FieldName = 'CODREMESA'
      Origin = 'CODREMESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QInformeRemesaMES: TWideStringField
      FieldName = 'MES'
      Origin = 'MES'
      Required = True
      Size = 10
    end
    object QInformeRemesaANIO: TWideStringField
      FieldName = 'ANIO'
      Origin = 'ANIO'
      Required = True
      Size = 4
    end
    object QInformeRemesaIBAN: TWideStringField
      FieldName = 'IBAN'
      Origin = 'IBAN'
      Required = True
      Size = 24
    end
    object QInformeRemesaBIC: TWideStringField
      FieldName = 'BIC'
      Origin = 'BIC'
      Required = True
      Size = 11
    end
    object QInformeRemesaSUFIJO: TWideStringField
      FieldName = 'SUFIJO'
      Origin = 'SUFIJO'
      Required = True
      Size = 3
    end
    object QInformeRemesaTOTAL: TSingleField
      FieldName = 'TOTAL'
      Origin = 'TOTAL'
    end
    object QInformeRemesaEMITIDO: TIntegerField
      FieldName = 'EMITIDO'
      Origin = 'EMITIDO'
      Required = True
    end
    object QInformeRemesaCODOPERACION: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'CODOPERACION'
      Origin = 'CODOPERACION'
      ProviderFlags = []
      ReadOnly = True
    end
    object QInformeRemesaCODEMPLEADO: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'CODEMPLEADO'
      Origin = 'CODEMPLEADO'
      ProviderFlags = []
      ReadOnly = True
    end
    object QInformeRemesaNOMBRE_1: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'NOMBRE_1'
      Origin = 'NOMBRE'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object QInformeRemesaAPELLIDOS: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'APELLIDOS'
      Origin = 'APELLIDOS'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object QInformeRemesaIBAN_1: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'IBAN_1'
      Origin = 'IBAN'
      ProviderFlags = []
      ReadOnly = True
      Size = 24
    end
    object QInformeRemesaBIC_1: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'BIC_1'
      Origin = 'BIC'
      ProviderFlags = []
      ReadOnly = True
      Size = 11
    end
    object QInformeRemesaSNETO: TSingleField
      AutoGenerateValue = arDefault
      FieldName = 'SNETO'
      Origin = 'SNETO'
      ProviderFlags = []
      ReadOnly = True
    end
  end
  object QBuscaCif: TFDQuery
    Connection = BaseDatos
    Transaction = TPrincipal
    UpdateTransaction = TUpdate
    SQL.Strings = (
      'select'
      ' CODEMPRESA,'
      '  NOMBRE,'
      '  CIF,'
      '  DIRECCION,'
      '  CP,'
      '  LOCALIDAD'
      'from EMPRESA'
      'where CIF = :cif')
    Left = 456
    Top = 72
    ParamData = <
      item
        Name = 'CIF'
        DataType = ftWideString
        ParamType = ptInput
        Size = 9
      end>
    object QBuscaCifCODEMPRESA: TIntegerField
      FieldName = 'CODEMPRESA'
      Origin = 'CODEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object QBuscaCifNOMBRE: TWideStringField
      FieldName = 'NOMBRE'
      Origin = 'NOMBRE'
      Required = True
      Size = 100
    end
    object QBuscaCifCIF: TWideStringField
      FieldName = 'CIF'
      Origin = 'CIF'
      Required = True
      Size = 9
    end
    object QBuscaCifDIRECCION: TWideStringField
      FieldName = 'DIRECCION'
      Origin = 'DIRECCION'
      Size = 150
    end
    object QBuscaCifCP: TWideStringField
      FieldName = 'CP'
      Origin = 'CP'
      Required = True
      Size = 5
    end
    object QBuscaCifLOCALIDAD: TWideStringField
      FieldName = 'LOCALIDAD'
      Origin = 'LOCALIDAD'
      Required = True
      Size = 60
    end
  end
  object QBorrarLineaRemesa: TFDQuery
    Connection = BaseDatos
    SQL.Strings = (
      'delete'
      'from'
      '  REMESALIN'
      'where codremesa = :remesa'
      'and codoperacion = :linea')
    Left = 728
    Top = 416
    ParamData = <
      item
        Name = 'REMESA'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'LINEA'
        DataType = ftInteger
        ParamType = ptInput
      end>
  end
end
