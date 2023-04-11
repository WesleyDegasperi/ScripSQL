select Codigo, Usuario, Tipo, swespecial.Especialidade from sistema
INNER JOIN swusuarios ON swusuarios.Código = sistema.Codigo
INNER JOIN swespecial ON swespecial.Código = swusuarios.Especialidade