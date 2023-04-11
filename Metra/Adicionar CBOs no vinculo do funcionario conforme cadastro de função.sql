-------------------------------------SCRIPT PARA PESQUISAR QUANTIDADE DE CBOs DA MTHISFUNC ESTÃO NULOS OU EM BRANCO----------------------
  OBS: NESTE SCRIPT TAMBÉM IRÁ TRAZER SOMENTE AS FUNÇÕES QUE TENHAM CBO CADASTRADO. 


select mthistfunc.Codigo, mtfuncoes.CBO, mthistfunc.CBO FROM
mthistfunc
INNER JOIN mtfuncoes
ON mthistfunc.CodFuncao = mtfuncoes.Codigo

WHERE
mtfuncoes.CBO <> '' and  mthistfunc.CBO = '' or mthistfunc.CBO is null



-------------------SCRIPT PARA COPIAR OS CBOs DAS FUNÇÕES (QUANDO EXISTENTES) E COLA-LOS NA MTHISFUNC CONFORME A FUNÇÃO DO FUNCIONÁRIO---------------------


UPDATE mthistfunc
SET

mthistfunc.CBO = mtfuncoes.CBO

FROM
mthistfunc
INNER JOIN mtfuncoes
ON mthistfunc.CodFuncao = mtfuncoes.Codigo

WHERE
mtfuncoes.CBO <> '' and  mthistfunc.CBO = '' or mthistfunc.CBO is null




_______________________________________________________________________________________________________________________________________________


OBS: ESTE SCRIPT IRÁ SOMENTE COLOCAR OS CBOs NA MTHISTFUNC (TELA DE VINCULO DO FUNCIONARIO), CASO ELE EXISTA NA TABELA MTFUNCOES (CADASTRO DA FUNÇÃO).
CASO CONTRARIO IRÁ FICAR EM BRANCO.



