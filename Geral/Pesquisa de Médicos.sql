select Codigo, Usuario, Tipo, swespecial.Especialidade from sistema
INNER JOIN swusuarios ON swusuarios.C�digo = sistema.Codigo
INNER JOIN swespecial ON swespecial.C�digo = swusuarios.Especialidade