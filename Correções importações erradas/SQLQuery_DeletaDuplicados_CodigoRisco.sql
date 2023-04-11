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