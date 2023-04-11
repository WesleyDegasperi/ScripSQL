USE [MEDSYSTEM]
GO

/****** Object:  UserDefinedFunction [dbo].[TVF_StatusPeriodicos]    Script Date: 28/09/2020 17:27:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- +============================================================================+
-- | Author:		Aline Alves Garcia											|
-- | Create date:	07/04/2016													|
-- | Description:	Function que irá retornar a situação dos exames				|
-- |				periódicos de acordo com o período							|	
-- +============================================================================+

CREATE FUNCTION [dbo].[TVF_StatusPeriodicos]
(
	@Param_DataInicio		DATETIME,
	@Param_DataFim  		DATETIME,
	@Param_CodEmpresa		INT,
	@Param_CodFuncao		INT,
	@Param_CodFuncionario	INT

)
RETURNS @Resultado		TABLE
	(
		DataRealizado		DATETIME,
		StatusExame			VARCHAR(50),
		Periodo				VARCHAR(50),
		DataPrevista		DATETIME,
		CodFuncionario		INT,
		CodFuncao			INT,
		CodEmpresa			INT,
		CodExame			INT
		
	)
AS
BEGIN
	DECLARE @DataIni			DATETIME,
			@DataFim			DATETIME,
			@ConfigUltimo		BIT,
			@CodEmpresa			INT,
			@CodExame			INT,
			@CodFuncionario		INT,
			@CodFuncao			INT,			
			@DataRealizado		DATETIME,
			@StatusExame		VARCHAR(50),
			@Periodo			VARCHAR(50),
			@DataPrevista		DATETIME,
			@CodPeriodico		INT,
			@Ordem				INT,
			@IncData			INT,
			@QtdeRegra			INT,
			@ExisteExame		BIT,
			@QtdeRealizado		INT;


	SET @DataIni = CAST(@Param_DataInicio AS DATETIME)
	SET @DataFim = CAST(@Param_DataFim	  AS DATETIME);	
	
	IF ISDATE(@DataIni) = 1 AND ISDATE(@DataFim) = 1
	BEGIN
		DECLARE CODPERIODICO
		CURSOR FOR
			SELECT Codigo FROM MTExamesPeriodicos 
			WHERE Cod_TipoExame = 5 
			  AND Cod_Empresa = @Param_CodEmpresa
			  AND Cod_Funcao  = @Param_CodFuncao
			  AND Cod_Funcionario = @Param_CodFuncionario
		OPEN CODPERIODICO
		FETCH NEXT FROM CODPERIODICO INTO @CodPeriodico
			
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SELECT  @ConfigUltimo		= Data_Ultimo_Exame
			FROM MTConfigExamesP
			WHERE Cod_Empresa = @Param_CodEmpresa
			
			IF(@ConfigUltimo = 1)
			BEGIN
				IF(SELECT COUNT(*) FROM MTExamesPeriodicos WHERE Codigo = @CodPeriodico AND (DataUltimo <= @DataFim OR DataUltimo IS NULL)) > 0
					SET @ExisteExame = 1;
				ELSE
					SET @ExisteExame = 0;
			END
			ELSE
			BEGIN
				IF(SELECT COUNT(*) FROM MTExamesPeriodicos e
					INNER JOIN mthistfunc h ON h.CodFunc = e.Cod_Funcionario AND e.Cod_Funcao = h.CodFuncao AND e.Cod_Empresa = h.CodEmpresa
					WHERE e.Codigo = @CodPeriodico AND h.DataAdmissao <= @DataFim) > 0
					SET @ExisteExame = 1;
				ELSE
					SET @ExisteExame = 0;				
			END 

			IF(@ExisteExame = 1)
			BEGIN
				IF(@ConfigUltimo = 1)
				BEGIN
					SELECT	@CodEmpresa = Cod_Empresa,
							@CodExame	= Cod_Exame,
							@CodFuncao	= Cod_Funcao,
							@CodFuncionario = Cod_Funcionario,
							@DataPrevista = DataUltimo
					FROM MTExamesPeriodicos
					WHERE Codigo = @CodPeriodico
					IF(@DataPrevista IS NULL)
					BEGIN
						SELECT	@CodEmpresa = e.Cod_Empresa,
								@CodExame	= e.Cod_Exame,
								@CodFuncao	= e.Cod_Funcao,
								@CodFuncionario = e.Cod_Funcionario,
								@DataPrevista = h.DataAdmissao
						FROM MTExamesPeriodicos e
						INNER JOIN mthistfunc h ON h.CodFunc = e.Cod_Funcionario AND e.Cod_Funcao = h.CodFuncao AND e.Cod_Empresa = h.CodEmpresa
						WHERE e.Codigo = @CodPeriodico
					END
				END
				ELSE
				BEGIN					
					SELECT	@CodEmpresa = e.Cod_Empresa,
							@CodExame	= e.Cod_Exame,
							@CodFuncao	= e.Cod_Funcao,
							@CodFuncionario = e.Cod_Funcionario,
							@DataPrevista = h.DataAdmissao
					FROM MTExamesPeriodicos e
					INNER JOIN mthistfunc h ON h.CodFunc = e.Cod_Funcionario AND e.Cod_Funcao = h.CodFuncao AND e.Cod_Empresa = h.CodEmpresa
					WHERE e.Codigo = @CodPeriodico
				END													
				
				SET @Ordem = 1;
				SET @QtdeRegra = (SELECT COUNT(*) FROM MTRegrasExP 
									WHERE Cod_Empresa = @CodEmpresa AND Cod_Exame = @CodExame AND Cod_Funcao = @CodFuncao);

				WHILE(@DataIni <= @DataFim)
				BEGIN
					IF(@QtdeRegra > 0)
					BEGIN
						SELECT @Periodo = Periodicidade 
						FROM MTRegrasExP
						WHERE Cod_Empresa     = @CodEmpresa
							AND Cod_Exame	  = @CodExame
							AND Cod_Funcao    = @CodFuncao
							AND Ordem		  = @Ordem
					END
					ELSE
					BEGIN
						SELECT @Periodo = Periodo 
						FROM mtexamesperiodicos 
						WHERE Codigo = @CodPeriodico

					END

					SET @IncData = (CASE @Periodo 
									WHEN 0 THEN 1 
									WHEN 1 THEN 2 
									WHEN 2 THEN 3
									WHEN 3 THEN 6
									WHEN 4 THEN 12
									WHEN 5 THEN 24
									WHEN 6 THEN 36
									WHEN 7 THEN 60
									WHEN 8 THEN 48 
									ELSE 1
									END)
					
					IF(@DataPrevista IS NOT NULL)
						WHILE(@DataPrevista < @DataIni)
							SET @DataPrevista = (SELECT DATEADD(MONTH, @IncData, @DataPrevista))

					SET @DataIni = @DataPrevista
					SET @DataPrevista = (SELECT DATEADD(MONTH, @IncData, @DataPrevista))
					
					IF(SELECT dbo.F_ExOcultosPer(@CodFuncionario, @CodFuncao, @CodExame, @DataIni)) = 1
					BEGIN
						IF(@DataIni <= GETDATE() AND @DataIni IS NOT NULL)
							SET @StatusExame = 'Vencido';
						ELSE
							SET @StatusExame = 'Pendente';
							
						IF CAST(@DataIni AS DATE) = CAST(GETDATE() AS DATE)
							SET @StatusExame = 'Pendente';	

						SET @DataRealizado = (SELECT dbo.F_GetDataExP(@CodEmpresa, @CodExame, @CodFuncao, @CodFuncionario, @DataIni, @DataPrevista))
						
						IF(@QtdeRegra > @Ordem)
							SET @Ordem = @Ordem + 1;
								
						IF(@Ordem > @QtdeRegra) /*Se a quantidade de exames realizados ultrapassar a quantidade de regras, mantem a última regra*/
							SET @Ordem = @QtdeRegra;
							
						IF ISDATE(@DataRealizado) = 1
						BEGIN

							IF(@QtdeRegra > 0)
								SET @IncData = (SELECT (CASE Periodicidade
														WHEN 0 THEN 1 
														WHEN 1 THEN 2 
														WHEN 2 THEN 3
														WHEN 3 THEN 6
														WHEN 4 THEN 12
														WHEN 5 THEN 24
														WHEN 6 THEN 36
														WHEN 7 THEN 60
														WHEN 8 THEN 48 
														ELSE 1
														END) As Periodicidade
												FROM MTRegrasExP
												WHERE Cod_Empresa     = @CodEmpresa
													AND Cod_Exame	  = @CodExame
													AND Cod_Funcao    = @CodFuncao
													AND Ordem		  = @Ordem)
							SET @DataPrevista = (SELECT DATEADD(MONTH, @IncData, @DataRealizado))

							SET @StatusExame = 'Realizado';
						END

						INSERT INTO @Resultado VALUES(@DataRealizado, @StatusExame, @Periodo, @DataIni, @CodFuncionario, @CodFuncao, @CodEmpresa, @CodExame)		
					END
					
					IF(@DataPrevista IS NULL)
						SET @DataIni = (SELECT DATEADD(DAY, 1, @DataFim))					
				END
			END
			SET @DataIni = CAST(@Param_DataInicio AS DATETIME);
		FETCH NEXT FROM CODPERIODICO INTO @CodPeriodico
		END /* Fim do Cursor de periodico*/

		CLOSE CODPERIODICO
		DEALLOCATE CODPERIODICO

	END /*Fim do IF Data*/

RETURN
										
END
GO

