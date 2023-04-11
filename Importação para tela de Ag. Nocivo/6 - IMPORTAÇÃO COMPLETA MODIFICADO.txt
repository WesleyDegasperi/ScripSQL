--Script Completo Modificado 19/03/2023 para pegar os últimos códigos de PPRA

--Importa Riscos para tela de Agentes Nocivos (Pegando último código do PPRA)

IF NOT EXISTS (SELECT * FROM SYSCOLUMNS WHERE ID = OBJECT_ID('MTAgNocFunc'))
BEGIN
SELECT IDENTITY(INT,1,1) AS Codigo, rpf.CodPPRA AS DocAgNoc, rpf.CodEmpresa, rpf.CodSetor, rpf.CodFuncao, r.CodeSocial, an.CodAgNoc,        
an.Risco AS DescAgNoc, r.Definicao, p.Ambientais, rpf.Forma_Avaliacao, rpf.Limite_Tolerancia, rpf.eSocialIntensidade,        
rpf.Cod_UnidadeMedida, rpf.Tecnica_Utilizada, rpf.Hierarquia, rpf.EPC, rpf.EPI, p.Cod_Prestador_Elab, p.Codigo_TipoDoc, 
p.NumDocumento

,rpf.codrisco AS CodigoRisco --Colocar essa informação

INTO MTAgNocFunc
FROM mtppra p 
LEFT JOIN MTRiscosPPRAFunc rpf ON rpf.CodPPRA = p.CodPPRA
LEFT JOIN MTRiscos r ON rpf.CodRisco = r.Codigo
LEFT JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
INNER JOIN mtfuncoes f ON f.codigo = rpf.codfuncao
INNER JOIN mtdeptos s ON s.codigo = rpf.codsetor
WHERE rpf.Apagado = 0 
AND f.excluido = 0 AND s.excluido = 0
AND p.Excluido = 0 AND r.CodeSocial IS NOT NULL
AND p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 



ALTER TABLE MTAgNocFunc
ADD PRIMARY KEY (Codigo);

ALTER TABLE [dbo].MTAgNocFunc 
ADD [Excluido] [int] NULL;

ALTER TABLE [dbo].MTAgNocFunc 
ADD [Data_Fim] [datetime] NULL;

ALTER TABLE [dbo].[MTAgNocFunc]
ADD VerificaCodSocialRepetido varchar(10);

ALTER TABLE [dbo].[MTAgNocFunc]
ADD [CodigoRef] [int] NULL;

UPDATE MTAgNocFunc SET eSocialIntensidade = '0' WHERE eSocialIntensidade = '' OR eSocialIntensidade IS NULL

UPDATE MTAgNocFunc SET CodigoRef = Codigo



END
GO

--Importa EPIs para tela de Agentes Nocivos (Pegando último código do PPRA)

IF NOT EXISTS (SELECT * FROM SYSCOLUMNS WHERE ID = OBJECT_ID('MTAgNocEPIFunc'))
BEGIN
SELECT distinct IDENTITY(INT,1,1) AS Codigo, repf.CodSetor, repf.CodFuncao, repf.CodFunc, repf.CodEPI, repf.EpiEpc,
       an.Id AS CodAgNoc, an.CodAgNoc AS IdAgNoc, repf.CodPPRA as DocAgNoc, anf.codigoref AS ID_CodigoRef

INTO MTAgNocEPIFunc
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
order by anf.codigoref, repf.CodEPI

ALTER TABLE MTAgNocEPIFunc
ADD [EPI_Eficaz] [BIT] DEFAULT (1) NOT NULL,
    [MedProtecao] [BIT] DEFAULT (1) NOT NULL,
    [CondFuncionamento] [BIT] DEFAULT (1) NOT NULL,
    [usoInint] [BIT] DEFAULT (1) NOT NULL,
    [PrazoValidade] [BIT] DEFAULT (1) NOT NULL,
    [Higienizacao] [BIT] DEFAULT (1) NOT NULL,
    [PeriodicidadeTroca] [BIT] DEFAULT (1) NOT NULL
	
	
ALTER TABLE MTAgNocEPIFunc
ADD PRIMARY KEY (Codigo);
end 


--Importar EPC para tela de Agentes Nocivos (Pegando último código do PPRA)

IF(SELECT COUNT(*) FROM [MTPPRA_EPIs]) > 0
BEGIN
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
	
	end
	


--Remove EPIs e EPCs de Ag. Nocivos que tem código, descrição, forma de avaliação, Unidade de medida e Tecnica utilizada iguais.

DELETE epi

FROM MTAgNocEPIFunc epi
INNER JOIN MTAgNocFunc a ON epi.docagnoc = a.docagnoc and epi.codfuncao = a.codfuncao 
and epi.idagnoc = a.codagnoc and epi.id_codigoref = a.codigoref
JOIN
(
    SELECT  CodSetor, CodFuncao, DocAgNoc, codagnoc, CodeSocial,convert(varchar(max),Definicao) AS Definicao,Forma_Avaliacao, 
	cod_unidademedida , convert(varchar(max),tecnica_utilizada) as tecnica_utilizada
	FROM MTAgNocFunc 
	WHERE codagnoc IS NOT NULL 
	GROUP BY CodSetor, CodFuncao, DocagNoc, codagnoc, CodeSocial, convert(varchar(max),Definicao), 
	Forma_Avaliacao, cod_unidademedida, convert(varchar(max),tecnica_utilizada)
	 HAVING COUNT(codagnoc) > 1 and count(convert(varchar(max),Definicao)) > 1
) b ON a.CodSetor = b.CodSetor AND a.CodFuncao = b.CodFuncao AND a.DocAgNoc = b.DocAgNoc 
AND a.CodeSocial = b.CodeSocial AND a.Definicao like b.Definicao AND a.Forma_Avaliacao = b.Forma_Avaliacao 
and a.cod_unidademedida = b.cod_unidademedida AND a.tecnica_utilizada like b.tecnica_utilizada AND
a.CodeSocial IN ('01.01.001', '01.02.001', '01.03.001', '01.04.001', '01.05.001', '01.06.001', '01.07.001', '01.08.001', 
'01.09.001', '01.10.001', '01.12.001', '01.13.001', '01.14.001', '01.15.001', '01.16.001', '01.17.001', '01.18.001', '05.01.001')




--Cria tabela MtDocAgNoc (Pegando último código do PPRA)

IF NOT EXISTS (SELECT * FROM SYSCOLUMNS WHERE ID = OBJECT_ID('MTDocAgNoc'))
BEGIN
CREATE TABLE MTDocAgNoc (
	DocAgNoc INT IDENTITY(1,1) NOT NULL,
	CodEmpresa INT NOT NULL,
	DataDoc DATETIME NULL,
	Cod_Elaborador INT NULL,
	Cod_TipoDoc INT NULL,
	NumDoc VARCHAR(50) NULL)

SET IDENTITY_INSERT MTDocAgNoc ON

INSERT INTO MTDocAgNoc (DocAgNoc, CodEmpresa, DataDoc, Cod_Elaborador, Cod_TipoDoc, NumDoc) 

SELECT p.CodPPRA AS DocAgNoc, p.CodEmpresa, p.Data_PPRA As DataDoc, 
p.Cod_Prestador_Elab, p.Codigo_TipoDoc, p.NumDocumento FROM 
 mtppra p

WHERE Excluido = 0

and p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 

GROUP BY p.CodPPRA, p.CodEmpresa, p.Data_PPRA, Cod_Prestador_Elab, 
Codigo_TipoDoc, NumDocumento

SET IDENTITY_INSERT MTDocAgNoc OFF

ALTER TABLE MTDocAgNoc
ADD PRIMARY KEY (DocAgNoc)

ALTER TABLE MTAgNocFunc
DROP COLUMN Cod_Prestador_Elab, Codigo_TipoDoc, NumDocumento

END
GO

