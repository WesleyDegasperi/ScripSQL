--Declara variável código da empresa. 

USE AGNOC
DECLARE @CODIGO_DA_EMPRESA int = '8';


--Delete responsáveis e Documento Mtdocagnoc criado anteriormente

DELETE FROM MTRespAgNoc
WHERE codempresa = @CODIGO_DA_EMPRESA

DELETE FROM MTDocAgNoc
WHERE codempresa = @CODIGO_DA_EMPRESA

DELETE FROM Mtagnocfunc
WHERE codempresa = @CODIGO_DA_EMPRESA




--Importa Riscos para tela de Agentes Nocivos (Pegando último código do PPRA) Empresa 8



INSERT INTO MTAgNocFunc (DocAgNoc, CodEmpresa, CodSetor, CodFuncao, CodeSocial, CodAgNoc,        
DescAgNoc, Definicao, Ambientais, Forma_Avaliacao, Limite_Tolerancia, eSocialIntensidade,        
Cod_UnidadeMedida, Tecnica_Utilizada, Hierarquia, EPC, EPI, CodigoRisco)

(SELECT p.CodPPRA AS DocAgNoc, rpf.CodEmpresa, rpf.CodSetor, rpf.CodFuncao, r.CodeSocial, an.CodAgNoc,        
an.Risco AS DescAgNoc, r.Definicao, p.Ambientais, rpf.Forma_Avaliacao, rpf.Limite_Tolerancia, rpf.eSocialIntensidade,        
rpf.Cod_UnidadeMedida, rpf.Tecnica_Utilizada, rpf.Hierarquia, rpf.EPC, rpf.EPI,rpf.codrisco AS CodigoRisco  
FROM  mtppra p

LEFT JOIN MTRiscosPPRAFunc rpf ON rpf.CodPPRA = p.CodPPRA
LEFT JOIN MTRiscos r ON rpf.CodRisco = r.Codigo
LEFT JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
INNER JOIN mtfuncoes f ON f.codigo = rpf.codfuncao
INNER JOIN mtdeptos s ON s.codigo = rpf.codsetor
WHERE rpf.Apagado = 0 
AND f.excluido = 0 AND s.excluido = 0
AND p.Excluido = 0 AND r.CodeSocial IS NOT NULL

and p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 
AND p.CodEmpresa = @CODIGO_DA_EMPRESA)




UPDATE MTAgNocFunc SET CodigoRef = Codigo
where codempresa = @CODIGO_DA_EMPRESA



--Importa EPIs para tela de Agentes Nocivos (Pegando último código do PPRA)




INSERT INTO MTAgNocEPIFunc (CodSetor, CodFuncao, CodFunc, CodEPI, EpiEpc, CodAgNoc,        
IdAgNoc, DocAgNoc, ID_CodigoRef)

(SELECT distinct repf.CodSetor, repf.CodFuncao, repf.CodFunc, repf.CodEPI, repf.EpiEpc, an.Id AS CodAgNoc, 
an.CodAgNoc AS IdAgNoc, repf.CodPPRA as DocAgNoc, anf.codigoref AS ID_CodigoRef  

FROM mtppra pp
LEFT JOIN MTRiscosEPIPPRAFunc repf ON repf.codppra = pp.codppra 
LEFT JOIN MTRiscosPPRAFunc pf ON pf.CodPPRA = repf.CodPPRA AND pf.CodFuncao = repf.CodFuncao AND pf.CodRisco = repf.CodRisco
LEFT JOIN MTPPRA p ON repf.CodPPRA = p.CodPPRA
LEFT JOIN MTRiscos r ON repf.CodRisco = r.Codigo
LEFT JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
INNER JOIN mtfuncoes f ON f.codigo = repf.codfuncao
INNER JOIN mtdeptos s ON s.codigo = repf.codsetor
INNER JOIN mthistfunc h ON h.codfunc = repf.CodFunc
INNER JOIN MTAgNocFunc anf ON anf.codagnoc = an.codagnoc AND anf.codfuncao = repf.codfuncao AND anf.docagnoc = repf.codppra
WHERE p.Excluido = 0 AND pf.Apagado = 0 AND r.CodeSocial IS NOT NULL
AND f.excluido = 0 AND s.excluido = 0 and h.apagado = 0 AND 
h.situacao = 3 AND repf.epiepc = 0 and anf.definicao like r.definicao and anf.Forma_Avaliacao like pf.Forma_Avaliacao 
and anf.cod_unidademedida = pf.cod_unidademedida  and anf.tecnica_utilizada like pf.tecnica_utilizada
AND p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa)
and p.codempresa = @CODIGO_DA_EMPRESA)





--Importa EPCs para tela de Agentes Nocivos (Pegando último código do PPRA)

    INSERT INTO MTAgNocEPIFunc (CodSetor, CodFuncao, CodEpi, EpiEpc, CodAgNoc, IdAgNoc, DocAgNoc, ID_CodigoRef)
	
	SELECT  distinct Epc.CodSetor, Epc.CodFuncao, Epc.CodEPI_EPC, repf.epiepc, an.Id As CodAgNoc, an.CodAgNoc As IdAgNoc, Epc.CodPPRA As DocAgNoc,  anf.codigoref AS ID_CodigoRef

    FROM mtppra pp 
	INNER JOIN MTPPRA_EPIs Epc ON epc.codppra = pp.codppra 
	INNER JOIN MTRiscosEPIPPRAFunc repf on repf.codepi = Epc.codepi_epc and repf.codrisco = Epc.codrisco
	AND repf.codppra = Epc.codppra
	INNER JOIN MTRiscosPPRAFunc rpf ON rpf.codrisco = Epc.codrisco 
	AND rpf.codfuncao = Epc.codfuncao
	LEFT JOIN MTPPRA p ON repf.CodPPRA = p.CodPPRA
    INNER JOIN MTRiscos r ON Epc.CodRisco = r.Codigo
    INNER JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
	INNER JOIN mtfuncoes f ON f.codigo = epc.codfuncao
	INNER JOIN mtdeptos s ON s.codigo = epc.codsetor
	INNER JOIN MTAgNocFunc anf ON anf.codagnoc = an.codagnoc AND anf.codfuncao = rpf.codfuncao AND anf.docagnoc = repf.codppra
	WHERE p.Excluido = 0 AND rpf.apagado = 0 AND repf.epiepc = 1 AND an.CodAgNoc IS NOT NULL 
	AND f.excluido = 0 AND s.excluido = 0 	and anf.definicao like r.definicao and anf.Forma_Avaliacao like rpf.Forma_Avaliacao 
	and anf.cod_unidademedida = rpf.cod_unidademedida and anf.tecnica_utilizada like rpf.tecnica_utilizada
	AND p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 
	and pp.codempresa = @CODIGO_DA_EMPRESA



	--Importa documento Riscos para MtDocAgNoc (Pegando último código do PPRA)


SET IDENTITY_INSERT MTDocAgNoc ON

INSERT INTO MTDocAgNoc (DocAgNoc, CodEmpresa, DataDoc, Cod_Elaborador, Cod_TipoDoc, NumDoc) 

SELECT p.CodPPRA AS DocAgNoc, p.CodEmpresa, p.Data_PPRA As DataDoc, 
p.Cod_Prestador_Elab, p.Codigo_TipoDoc, p.NumDocumento FROM 
 mtppra p

WHERE Excluido = 0 
and p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 
and p.codempresa = @CODIGO_DA_EMPRESA

GROUP BY p.CodPPRA, p.CodEmpresa, p.Data_PPRA, Cod_Prestador_Elab, 
Codigo_TipoDoc, NumDocumento

SET IDENTITY_INSERT MTDocAgNoc OFF


--Coloca Documento empresa como ativo. 


update mtdocagnoc
set ativo = 1
where codempresa = 8

--Insere informações Colunas criadas. 

UPDATE MTAgNocFunc SET eSocialIntensidade = '0' WHERE eSocialIntensidade = '' OR eSocialIntensidade IS NULL

