--Seta codigorisco da tabela Mtagnocfunc (Documento de Agentes Nocivos) conforme tabelas mtriscospprafunc (Documento de Riscos)
update a
set a.codigorisco = rf.codrisco

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


--Deleta todos registros da tabela Mtagnocfunc que estão duplicados 

DELETE FROM mtagnocfunc
FROM mtagnocfunc
INNER JOIN (
    SELECT docagnoc, codempresa, codsetor, codfuncao, codagnoc, DescAgNoc, codigorisco, 
	MIN(Codigo) as codigo
FROM mtagnocfunc
WHERE codigorisco is not null and (excluido = 0 or excluido is null) and (riscoexcluido = 0 or riscoexcluido is null)
GROUP BY docagnoc, codempresa, codsetor, codfuncao,codagnoc, DescAgNoc, codigorisco
HAVING COUNT(*) > 1
) as duplicados
ON mtagnocfunc.docagnoc = duplicados.docagnoc
AND mtagnocfunc.codempresa = duplicados.codempresa
AND mtagnocfunc.codfuncao = duplicados.codfuncao
AND mtagnocfunc.codagnoc = duplicados.codagnoc
AND mtagnocfunc.codigorisco = duplicados.codigorisco
AND mtagnocfunc.codigo <> duplicados.codigo



--Atualiza CodigoRisco para 0 na tabela mtagnocfunc

update mtagnocfunc
set excluido = NULL, RiscoExcluido = NULL
where codigorisco IS NULL