--Realiza exclusão
use medsystem
declare @CODIGO_DA_EMPRESA int;

while (Select count (*) codigo from mtempresas where ativa = 0) >0
begin

	set @CODIGO_DA_EMPRESA = (Select top (1) codigo from mtempresas where ativa = 0)
	
	delete from MTLTCAT where cod_empresa = @CODIGO_DA_EMPRESA
	delete from agitems where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTContratantes_LTCAT where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTExamesPeriodicos where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTEmpresaCampos where cod_empresa = @CODIGO_DA_EMPRESA
	delete from agitems_del where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTEmpresaCamposValores where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTEmpresaValorBase where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTEmpresaFatura where cod_empresa = @CODIGO_DA_EMPRESA
	delete from mtconsultas where cod_empresa = @CODIGO_DA_EMPRESA
	delete from swconsim where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTRegrasExP where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTEmpresaServicos where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTAcuidadeVisual where cod_empresa = @CODIGO_DA_EMPRESA
	delete MTCursos_Prestadores
FROM MTCursos_Prestadores p INNER JOIN MTCursos_Cad c
ON c.Cod_Curso_Cad = p.Cod_Curso_Cad 
where c.Cod_Empresa = @CODIGO_DA_EMPRESA
	delete MTCursos_Profissionais
	from MTCursos_Profissionais
	INNER JOIN MTCursos_Cad on MTCursos_Profissionais.Cod_Curso_Cad = MTCursos_Cad.Cod_Curso_Cad
	where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTConfigExamesP where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTCronograma where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTProcPact where cod_empresa = @CODIGO_DA_EMPRESA
	delete from MTAfastamento where codempresa = @CODIGO_DA_EMPRESA
	delete from mtaso where codempresa = @CODIGO_DA_EMPRESA
	delete from mtaudiometria where codempresa = @CODIGO_DA_EMPRESA
	delete from MTRiscosPPRAFunc where codempresa = @CODIGO_DA_EMPRESA
	delete from MTCursos_Cad where cod_empresa = @CODIGO_DA_EMPRESA
	delete from mtfuncoes where codempresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSOPadrao3
FROM MTHistoricoPCMSOPadrao3 h INNER JOIN mtdeptos s
ON h.CodSetor = s.Codigo 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
    delete MTHistoricoPCMSOExames
FROM MTHistoricoPCMSOExames h INNER JOIN mtdeptos s
ON h.CodSetor = s.Codigo 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
    delete MTHistoricoPCMSOSetores
FROM MTHistoricoPCMSOSetores h INNER JOIN mtdeptos s
ON h.CodSetor = s.Codigo 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
    delete from MTRiscosPPRA where codempresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSOExamesPadrao2
FROM MTHistoricoPCMSOExamesPadrao2 h INNER JOIN MTHistoricoPCMSO s
ON h.CodHistoricoPCMSO = s.CodHistoricoPCMSO 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSOPadrao4Exames  
    from MTHistoricoPCMSOPadrao4Exames INNER JOIN mtdeptos 
    ON mtdeptos.codigo = MTHistoricoPCMSOPadrao4Exames.codsetor
    where codempresa = @CODIGO_DA_EMPRESA
	delete from mtconvocados where codempresa = @CODIGO_DA_EMPRESA
	delete from mtespirometria where codempresa = @CODIGO_DA_EMPRESA
	delete from MTOutrasInfoPPRA where codempresa = @CODIGO_DA_EMPRESA
	delete from MTPPRA where codempresa = @CODIGO_DA_EMPRESA
    delete MTFuncionarios_Campos_Valores
	from MTFuncionarios_Campos_Valores fcv  INNER JOIN mthistfunc hf  
	ON hf.codigo = fcv.cod_historico
    where codempresa = @CODIGO_DA_EMPRESA
	delete from mtfuncionarios where codempresa = @CODIGO_DA_EMPRESA
	delete from MTRiscosPPRA where codempresa = @CODIGO_DA_EMPRESA
	delete from mtaso_del where codempresa = @CODIGO_DA_EMPRESA
	delete from MTOutrasInfoPPRA where codempresa = @CODIGO_DA_EMPRESA
	delete from MTPPD where codempresa = @CODIGO_DA_EMPRESA
	delete from MTAdicionais where codempresa = @CODIGO_DA_EMPRESA
	delete MTQResp
	from MTQResp 
	INNER JOIN MTPPR ON MTPPR.codppr = MTQResp.codppr
	delete from MTPPR where codempresa = @CODIGO_DA_EMPRESA
	delete from mtmonitbio where codempresa = @CODIGO_DA_EMPRESA
	delete from MTRAAT where codempresa = @CODIGO_DA_EMPRESA
	delete from MTEquipFunc where codempresa = @CODIGO_DA_EMPRESA
	delete from mtpcmso where codempresa = @CODIGO_DA_EMPRESA
	delete from MTCAT where codempresa = @CODIGO_DA_EMPRESA
	delete from MTPPRDados where codempresa = @CODIGO_DA_EMPRESA
	delete from mtppp where codempresa = @CODIGO_DA_EMPRESA
	delete from mtregamb where codempresa = @CODIGO_DA_EMPRESA
	delete from mtresultados where codempresa = @CODIGO_DA_EMPRESA
	delete from mtriscosemp where codempresa = @CODIGO_DA_EMPRESA
	delete from mtriscosfunc where codempresa = @CODIGO_DA_EMPRESA
	delete MTPacoteServicosDetalhes
FROM MTPacoteServicosDetalhes p INNER JOIN MTPacoteServicos s
ON p.CodPacoteServicos = s.CodPacoteServicos 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
	delete from MTPacoteServicos where CodEmpresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSOExamesProxAno
FROM MTHistoricoPCMSOExamesProxAno h INNER JOIN MTHistoricoPCMSO s
ON h.CodHistoricoPCMSO = s.CodHistoricoPCMSO 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
    delete MTHistoricoPCMSOTipoExame
FROM MTHistoricoPCMSOTipoExame h INNER JOIN MTHistoricoPCMSO s
ON h.CodHistoricoPCMSO = s.CodHistoricoPCMSO 
where s.CodEmpresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSOPadrao4AnComparativa
    from MTHistoricoPCMSOPadrao4AnComparativa a
    INNER JOIN MTHistoricoPCMSO 
    ON  a.CodHistoricoPCMSO = MTHistoricoPCMSO.CodHistoricoPCMSO
    where CodEmpresa = @CODIGO_DA_EMPRESA
	delete MTHistoricoPCMSO
    from MTHistoricoPCMSO 
    INNER JOIN mtempresas 
    ON mtempresas.codigo = MTHistoricoPCMSO.CodEmpresa
    where codigo = @CODIGO_DA_EMPRESA
	delete from mtempresas where codigo = @CODIGO_DA_EMPRESA
end

