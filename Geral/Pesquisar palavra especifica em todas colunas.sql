
SELECT CNS, Nome, Municipio, IBGE, Cod_Procedimento, CID, Carater_Atendimento, Autorizacao, VL_SA, VL_SP, Etnia, 
Servico, Classificacao, Equipe, CEP, Tipo_Logradouro, Endereco, Complemento, Numero, Bairro, Telefone, [E-Mail], CNPJ_OPM, UF
FROM bpai_procedimentos  
WHERE (CNS LIKE '%<<%') OR (Nome LIKE '%<<%') OR (Municipio LIKE '%<<%') OR (IBGE LIKE '%<<%') OR (Cod_Procedimento LIKE '%<<%') 
OR (CID LIKE '%<<%') OR (Carater_Atendimento LIKE '%<<%') OR (Autorizacao LIKE '%<<%') OR (VL_SA LIKE '%<<%') OR (VL_SP LIKE '%<<%') 
OR (Etnia LIKE '%<<%') OR (Servico LIKE '%<<%') OR  (Classificacao LIKE '%<<%') OR (Equipe LIKE '%<<%') OR (CEP LIKE '%<<%') 
OR (Tipo_Logradouro LIKE '%<<%') OR (Endereco LIKE '%<<%') OR (Complemento LIKE '%<<%') OR (Numero LIKE '%<<%') OR (Bairro LIKE '%<<%') 
OR (Telefone LIKE '%<<%') OR ([E-Mail] LIKE '%<<%') OR (CNPJ_OPM LIKE '%<<%') OR (UF LIKE '%<<%')



