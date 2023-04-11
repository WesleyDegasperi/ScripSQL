--Verifica Agentes Nocivos sem CodigoRisco conforme tabelas MTriscospprafunc

select distinct a.docagnoc, rf.codppra, a.codempresa, a.codsetor, a.codfuncao, a.CodAgNoc, DescAgNoc,
LEFT (Convert(VARCHAR(max), a.definicao),50) as AgDefinicao,
LEFT (Convert(VARCHAR(max), r.definicao),50) as RDefinicao,
Convert(VARCHAR(max),a.Forma_Avaliacao) as AgForma_Avaliacao, 
Convert(VARCHAR(max),rf.Forma_Avaliacao) as RForma_Avaliacao,
rf.codrisco, a.CodigoRisco, r.Descricao, a.codesocial ,r.CodeSocial 

from mtagnocfunc a
INNER JOIN mtriscospprafunc rf on rf.codppra = a.docagnoc and rf.codempresa = a.codempresa
and rf.codsetor = a.codsetor and rf.codfuncao = a.codfuncao 
INNER JOIN mtppra p on p.CodPPRA = a.DocAgNoc and p.codempresa = a.codempresa
INNER JOIN mtriscos r on r.codigo = rf.codrisco and r.codesocial = a.CodeSocial 
INNER JOIN eSocial_Tabela24_AgentesNocivosAtividades e on e.CodAgNoc = a.CodAgNoc

where (codigorisco is null or codigorisco = 0) AND r.CodeSocial is not null 
and rf.apagado = 0 and p.Excluido = 0 
and p.CodPPRA in (SELECT MAX(CodPPRA) as CodPPRA FROM MTPPRA WHERE Excluido = 0 GROUP BY CodEmpresa) 
and LEFT (Convert(VARCHAR(max), a.definicao),50) = LEFT (Convert(VARCHAR(max), r.definicao ),50)


GROUP BY a.docagnoc, rf.codppra, a.codempresa, a.codsetor, a.codfuncao, a.CodAgNoc, DescAgNoc,
Convert(VARCHAR(max), a.definicao), Convert(VARCHAR(max), r.definicao), Convert(VARCHAR(max),a.Forma_Avaliacao), 
Convert(VARCHAR(max),rf.Forma_Avaliacao),rf.codrisco, 
a.CodigoRisco, r.Descricao, a.codesocial ,r.CodeSocial

