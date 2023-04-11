--Script Completo Modificado para pegar os últimos códigos de PPRA

--Importa Riscos para tela de Agentes Nocivos (Pegando último código do PPRA)

IF NOT EXISTS (SELECT * FROM SYSCOLUMNS WHERE ID = OBJECT_ID('MTAgNocFunc'))
BEGIN
SELECT IDENTITY(INT,1,1) AS Codigo, rpf.CodPPRA AS DocAgNoc, rpf.CodEmpresa, rpf.CodSetor, rpf.CodFuncao, r.CodeSocial, an.CodAgNoc,        
an.Risco AS DescAgNoc, r.Definicao, p.Ambientais, rpf.Forma_Avaliacao, rpf.Limite_Tolerancia, rpf.eSocialIntensidade,        
rpf.Cod_UnidadeMedida, rpf.Tecnica_Utilizada, rpf.Hierarquia, rpf.EPC, rpf.EPI, p.Cod_Prestador_Elab, p.Codigo_TipoDoc, 
p.NumDocumento 
INTO MTAgNocFunc
FROM   
(select max(codppra) as codppra, codempresa FROM MTPPRA
group by codempresa) PPRA

JOIN mtppra p ON p.CodPPRA = PPRA.codppra and p.codempresa = PPRA.codempresa
LEFT JOIN MTRiscosPPRAFunc rpf ON rpf.CodPPRA = p.CodPPRA
LEFT JOIN MTRiscos r ON rpf.CodRisco = r.Codigo
LEFT JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
WHERE rpf.Apagado = 0
AND p.Excluido = 0
AND r.CodeSocial IS NOT NULL


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
SELECT IDENTITY(INT,1,1) AS Codigo, repf.CodSetor, repf.CodFuncao, repf.CodFunc, repf.CodEPI, repf.EpiEpc,
       an.Id AS CodAgNoc, an.CodAgNoc AS IdAgNoc, repf.CodPPRA as DocAgNoc
INTO MTAgNocEPIFunc
FROM 
(select 
max(codppra) as codppra, codempresa FROM MTPPRA
group by codempresa
) PPRA 
join mtppra pp ON pp.CodPPRA = PPRA.codppra and pp.codempresa = PPRA.codempresa
LEFT JOIN MTRiscosEPIPPRAFunc repf ON repf.codppra = pp.codppra 
LEFT JOIN MTRiscosPPRAFunc pf ON pf.CodPPRA = repf.CodPPRA AND pf.CodFuncao = repf.CodFuncao AND pf.CodRisco = repf.CodRisco
LEFT JOIN MTPPRA p ON repf.CodPPRA = p.CodPPRA
LEFT JOIN MTRiscos r ON repf.CodRisco = r.Codigo
LEFT JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
WHERE p.Excluido = 0 AND pf.Apagado = 0 AND r.CodeSocial IS NOT NULL

ALTER TABLE MTAgNocEPIFunc
ADD [EPI_Eficaz] [BIT] DEFAULT (1) NOT NULL,
    [MedProtecao] [BIT] DEFAULT (1) NOT NULL,
    [CondFuncionamento] [BIT] DEFAULT (1) NOT NULL,
    [usoInint] [BIT] DEFAULT (1) NOT NULL,
    [PrazoValidade] [BIT] DEFAULT (1) NOT NULL,
    [Higienizacao] [BIT] DEFAULT (1) NOT NULL,
    [PeriodicidadeTroca] [BIT] DEFAULT (1) NOT NULL,
	[ID_CodigoRef] [int] NULL
	
ALTER TABLE MTAgNocEPIFunc
ADD PRIMARY KEY (Codigo);
end 

--Atualiza CodigoRef da tabela MTAgNocFunc de acordo com CodSetor, CodFuncao, IdAgNoc e DocAgNoc após importação.
UPDATE epi  
SET epi.ID_CodigoRef = noc.CodigoRef
FROM MTAgNocEPIFunc epi 
INNER JOIN mtagnocfunc noc ON 
noc.CodSetor = epi.CodSetor AND noc.CodFuncao = epi.CodFuncao AND noc.CodAgNoc = epi.IdAgNoc AND noc.DocAgNoc = epi.DocAgNoc
WHERE epi.ID_CodigoRef IS NULL

--Remove agentes repetidos da tabela de Epis após importação.

DELETE a
FROM MTAgNocEPIFunc a
JOIN
(
    SELECT  CodSetor, CodFuncao, DocAgNoc, codagnoc  FROM MTAgNocFunc 
	WHERE codagnoc IS NOT NULL 
	GROUP BY CodSetor, CodFuncao, DocagNoc, codagnoc HAVING COUNT(codagnoc) > 1
) b ON a.CodSetor = b.CodSetor AND a.CodFuncao = b.CodFuncao AND a.DocAgNoc = b.DocAgNoc 
AND a.IdAgNoc = b.codagnoc AND a.EPIEPC = 0 AND
a.codagnoc IN ('01.01.001', '01.02.001', '01.03.001', '01.04.001', '01.05.001', '01.06.001', '01.07.001', '01.08.001', 
'01.09.001', '01.10.001', '01.12.001', '01.13.001', '01.14.001', '01.15.001', '01.16.001', '01.17.001', '01.18.001', '05.01.001')



--Importar EPC para tela de Agentes Nocivos (Pegando último código do PPRA)

IF(SELECT COUNT(*) FROM [MTPPRA_EPIs]) > 0
BEGIN
    INSERT INTO MTAgNocEPIFunc (CodSetor, CodFuncao, CodEpi, EpiEpc, CodAgNoc, IdAgNoc, DocAgNoc)
    
	SELECT DISTINCT Epc.CodSetor, Epc.CodFuncao, Epc.CodEPI_EPC, Epc.Utiliza_CA As EpiEpc, 
        an.Id As CodAgNoc, an.CodAgNoc As IdAgNoc, Epc.CodPPRA As DocAgNoc
    FROM 
	(select 
max(codppra) as codppra, codempresa FROM MTPPRA
group by codempresa) PPRA 
	JOIN mtppra pp ON pp.CodPPRA = PPRA.codppra and pp.codempresa = PPRA.codempresa
	INNER JOIN MTPPRA_EPIs Epc ON epc.codppra = pp.codppra 
	INNER JOIN MTRiscosEPIPPRAFunc repf on repf.codepi = Epc.codepi_epc and repf.codrisco = Epc.codrisco
	AND repf.codppra = Epc.codppra
	INNER JOIN MTRiscosPPRAFunc rpf ON rpf.codrisco = Epc.codrisco 
	AND rpf.codfuncao = Epc.codfuncao
	LEFT JOIN MTPPRA p ON repf.CodPPRA = p.CodPPRA
    INNER JOIN MTRiscos r ON Epc.CodRisco = r.Codigo
    INNER JOIN eSocial_Tabela24_AgentesNocivosAtividades an ON r.CodeSocial = an.Id
    WHERE p.Excluido = 0 AND rpf.apagado = 0 AND Utiliza_CA = 1 AND an.CodAgNoc IS NOT NULL 
	



	--query para setar os ID_CodigoRef na tabela de Epis para os Epcs
    UPDATE epi  
    SET epi.ID_CodigoRef = noc.CodigoRef
    FROM MTAgNocEPIFunc epi 
    INNER JOIN mtagnocfunc noc ON 
    noc.CodSetor = epi.CodSetor AND noc.CodFuncao = epi.CodFuncao AND noc.CodAgNoc = epi.IdAgNoc AND noc.DocAgNoc = epi.DocAgNoc
    WHERE epi.ID_CodigoRef IS NULL AND epi.EpiEpc = 1       
	END
GO
	
	--Remove agentes repetidos da tabela de Epcs após importação.

DELETE a
FROM MTAgNocEPIFunc a
JOIN
(SELECT CodSetor, CodFuncao, DocAgNoc, CodAgNoc FROM MTAgNocFunc 
	WHERE CodAgNoc IS NOT NULL 
	GROUP BY CodSetor, CodFuncao, DocagNoc, CodAgNoc HAVING COUNT(CodAgNoc) > 1
) b ON a.CodSetor = b.CodSetor AND a.CodFuncao = b.CodFuncao AND a.DocAgNoc = b.DocAgNoc 
AND a.IdAgNoc = b.CodAgNoc   AND a.EPIEPC = 1 AND
a.codagnoc IN ('01.01.001', '01.02.001', '01.03.001', '01.04.001', '01.05.001', '01.06.001', '01.07.001', '01.08.001', 
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
(SELECT rpf.CodPPRA AS DocAgNoc, rpf.CodEmpresa, p.Data_PPRA As DataDoc, 
p.Cod_Prestador_Elab, p.Codigo_TipoDoc, p.NumDocumento FROM 
(select 
max(codppra) as codppra, codempresa FROM MTPPRA
group by codempresa
) r
INNER JOIN mtppra p ON p.CodPPRA = r.codppra and p.codempresa = r.codempresa
INNER JOIN MTRiscosPPRAFunc rpf ON rpf.CodPPRA = p.CodPPRA
WHERE Excluido = 0
 GROUP BY rpf.CodPPRA, rpf.CodEmpresa, p.Data_PPRA, Cod_Prestador_Elab, 
Codigo_TipoDoc, NumDocumento)
SET IDENTITY_INSERT MTDocAgNoc OFF

ALTER TABLE MTDocAgNoc
ADD PRIMARY KEY (DocAgNoc)

ALTER TABLE MTAgNocFunc
DROP COLUMN Cod_Prestador_Elab, Codigo_TipoDoc, NumDocumento

END
GO

