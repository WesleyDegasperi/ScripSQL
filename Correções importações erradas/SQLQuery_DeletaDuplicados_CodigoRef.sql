DELETE FROM mtagnocfunc
FROM mtagnocfunc
INNER JOIN (
    SELECT docagnoc, codempresa, codsetor, codfuncao, codagnoc, DescAgNoc, codigoref, 
	max(Codigo) as codigo
FROM mtagnocfunc

GROUP BY docagnoc, codempresa, codsetor, codfuncao,codagnoc, DescAgNoc, codigoref
HAVING COUNT(*) > 1
) as duplicados
ON mtagnocfunc.docagnoc = duplicados.docagnoc
AND mtagnocfunc.codempresa = duplicados.codempresa
AND mtagnocfunc.codfuncao = duplicados.codfuncao
AND mtagnocfunc.codagnoc = duplicados.codagnoc
AND mtagnocfunc.codigoref = duplicados.codigoref
AND mtagnocfunc.codigo <> duplicados.codigo

where 
CodigoRisco is null and
(excluido = 0 or excluido is null) and (riscoexcluido = 0 or riscoexcluido is null)


