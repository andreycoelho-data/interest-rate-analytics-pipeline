let
    // Referência estável à tabela completa (Substitua "Colunas Removidas" pelo nome EXATO do passo anterior, se for diferente)
    FonteDeDados = #"Colunas Removidas", 
    
    // ----------------------------------------------------
    // 1. VARIÁVEIS DE CONFIGURAÇÃO
    // ----------------------------------------------------
    TaxaProjetadaAnual = 0.125, 
    BaseDeDiasUteis = 252,
    DiasUteisAnuaisParaProj = 252,
    FatorDiarioProjetado = Number.Power(1 + TaxaProjetadaAnual, 1/BaseDeDiasUteis),
    
    // ----------------------------------------------------
    // 2. DEFINIÇÃO DE DATAS CHAVE
    // ----------------------------------------------------
    DataInicio = [Data], 
    DataFim12M = Date.AddDays(Date.AddMonths(DataInicio, 12), -1),
    
    // Busca a última data DA TABELA
    DataLimiteReal = List.Max(FonteDeDados[Data]), 
    
    // ----------------------------------------------------
    // 3. CÁLCULO DO ACUMULADO REAL
    // ----------------------------------------------------
    DataFimReal = List.Min({DataFim12M, DataLimiteReal}),
    
    // Filtra o período REAL
    TabelaFiltradaReal = Table.SelectRows(
        FonteDeDados, 
        each [Data] >= DataInicio and [Data] <= DataFimReal
    ),
    
    DiasUteisReais = Table.RowCount(TabelaFiltradaReal),
    ProdutoReal = if DiasUteisReais > 0 then List.Product(TabelaFiltradaReal[FatorDiário]) else 1,
    
    // ----------------------------------------------------
    // 4. CÁLCULO DO ACUMULADO PROJETADO
    // ----------------------------------------------------
    
    DiasUteisAProjetar = 
        if DataFimReal < DataFim12M and DiasUteisReais > 0 then
            if DiasUteisAnuaisParaProj > DiasUteisReais
            then DiasUteisAnuaisParaProj - DiasUteisReais
            else 0
        else
            0, 
    
    ProdutoProjetado = Number.Power(FatorDiarioProjetado, DiasUteisAProjetar),
    
    // ----------------------------------------------------
    // 5. RESULTADO FINAL
    // ----------------------------------------------------
    ProdutoFinal = ProdutoReal * ProdutoProjetado
    
in
    ProdutoFinal
