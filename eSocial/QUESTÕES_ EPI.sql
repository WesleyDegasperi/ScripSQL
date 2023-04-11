select MTRiscosEpiPPRAFunc.codrisco, MTRiscosPPRAFunc.EPI, MTRiscosPPRAFunc.CodRisco, mtriscos.Descricao, mtppra_epis.CodRisco from MTRiscosPPRAFunc
inner join mtriscos on mtriscos.Codigo = MTRiscosPPRAFunc.CodRisco
inner join MTRiscosEpiPPRAFunc on MTRiscosPPRAFunc.CodRisco = MTRiscosEpiPPRAFunc.CodRisco
inner join mtppra_epis on mtriscos.codigo = mtppra_epis.codrisco and mtppra_epis.CodEPI_EPC = MTRiscosEpiPPRAFunc.codepi

where MTRiscosPPRAFunc.Codfuncao = 98 and MTRiscosPPRAFunc.EPI = 2 and MTRiscosEpiPPRAFunc.codfunc = 110 and mtppra_epis.CodFuncao = 98