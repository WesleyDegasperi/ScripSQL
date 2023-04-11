select mtagnocfunc.docagnoc, mtagnocfunc.codempresa, mtagnocfunc.codsetor, mtagnocfunc.codfuncao, mtagnocfunc.codagnoc, mtagnocfunc.DescAgNoc, mtagnocfunc.codigorisco, COUNT(*) as qtd
FROM mtagnocfunc
INNER JOIN (
    SELECT docagnoc, codempresa, codsetor, codfuncao, codagnoc, DescAgNoc, codigorisco, 
	MIN(Codigo) as codigo
FROM mtagnocfunc
WHERE codigorisco is not null and (excluido = 0 or excluido is null) or (riscoexcluido = 0 or riscoexcluido is null)

GROUP BY docagnoc, codempresa, codsetor, codfuncao,codagnoc, DescAgNoc, codigorisco
HAVING COUNT(*) > 1
) as duplicados
ON mtagnocfunc.docagnoc = duplicados.docagnoc
AND mtagnocfunc.codempresa = duplicados.codempresa
AND mtagnocfunc.codfuncao = duplicados.codfuncao
AND mtagnocfunc.codagnoc = duplicados.codagnoc
AND mtagnocfunc.codigorisco = duplicados.codigorisco
AND mtagnocfunc.codigo <> duplicados.codigo

GROUP BY mtagnocfunc.docagnoc, mtagnocfunc.codempresa, mtagnocfunc.codsetor, mtagnocfunc.codfuncao, mtagnocfunc.codagnoc, mtagnocfunc.DescAgNoc, mtagnocfunc.codigorisco