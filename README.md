🌐 **Idioma / Language:** [Português](README.md) | [English](README_EN.md)

---

# 📊 Engenharia e Análise Quantitativa da Taxa de Juros de Fundos Garantidores

[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)](./python/)
[![SQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat&logo=mysql&logoColor=white)](./sql/)
[![Power Query](https://img.shields.io/badge/Power_Query-Linguagem_M-217346?style=flat&logo=powerbi&logoColor=white)](./power_query/)
[![Power BI](https://img.shields.io/badge/Power_BI-DAX-F2C811?style=flat&logo=powerbi&logoColor=black)](./dax/)

---

## 📋 Sumário
- [🏙️ Cenário e Contexto](#️-cenário-e-contexto)
- [⚠️ Problemáticas de Negócio](#️-problemáticas-de-negócio)
- [🛠️ Resolução de Dores e Solução Técnica](#️-resolução-de-dores-e-solução-técnica)
- [📂 Estrutura do Repositório e Códigos](#-estrutura-do-repositório-e-códigos)
- [💎 Geração de Valor para a Instituição e Gerência](#-geração-de-valor-para-a-instituição-e-gerência)
- [🎯 Conclusão e Tomada de Decisão](#-conclusão-e-tomada-de-decisão)

---

## 🏙️ Cenário e Contexto

No ecossistema de concessão de crédito apoiado por **Fundos Garantidores**, a instituição atua mitigando o risco de inadimplência de micro e pequenas empresas (MEI, ME e EPP) junto aos bancos e cooperativas parceiras. 

Para monitorar a efetividade do fundo e assegurar que as instituições financeiras cumpram os limites operacionais estabelecidos, a alta gestão necessita de visibilidade analítica sobre a **taxa de juros média praticada na ponta** para os tomadores finais de crédito.

No entanto, o volume massivo de operações originadas por dezenas de parceiros gera um grande fluxo de dados descentralizado, onde cada banco reporta suas taxas sob padrões, periodicidades e estruturas de campos distintas.

[⬆ Voltar ao Sumário](#-sumário)

---

## ⚠️ Problemáticas de Negócio

1. **Heterogeneidade e Ausência de Padronização:** Informações sem padrão nos arquivos das instituições parceiras (mistura de formatos mensais vs. anuais, decimais vs. percentuais e separadores de ponto vs. vírgula).
2. **Ambiguidade entre Taxas Pré e Pós-Fixadas:** Dificuldade em identificar se a taxa reportada é fixa ou atrelada ao indexador de mercado (Selic), inviabilizando a comparação direta da taxa real praticada.
3. **Distorção no Acumulado da Selic (Gap Temporal de 12M):** Para operações recentes sem 12 meses completos de histórico, a simples acumulação dos dias passados gera uma subestimação da taxa Selic anualizada, distorcendo o cálculo da taxa pós-fixada.
4. **Falta de Métricas Ponderadas por Volume:** A análise baseada em médias simples mascarava a real exposição financeira do fundo, pois operações de baixo valor financeiro tinham o mesmo peso visual de operações de elevado volume.

[⬆ Voltar ao Sumário](#-sumário)

---

## 🛠️ Resolução de Dores e Solução Técnica

O projeto foi estruturado através de uma esteira analítica integrada *end-to-end* onde o Power Query processa inicialmente a tabela do indexador, servindo de base para o motor de cálculos em Python e armazenamento relacional:

```mermaid
graph LR
    A[Power Query / M] -->|1. Tratamento Selic Híbrida 252DU| B[Python / Pandas]
    C[Dados Brutos de Operações] -->|2. Ingestão & Regras por Porte| B
    B -->|3. Carga Staging & Governança| D[(MySQL Staging)]
    D -->|4. SP Refresh & Visão de Produção| E[(MySQL Produção)]
    E -->|5. Star Schema & DAX Ponderado| F[Power BI Dashboards]
Detalhamento das Camadas Desenvolvidas:Séries Temporais e Indexador (Power Query / Linguagem M): Tratamento inicial na tabela FATO_SELIC, combinando o histórico real disponível com a projeção de mercado ajustada para a convenção bancária de 252 dias úteis.Motor de Tratamento e Classificação por Porte (Python): O script consome a base tratada da Selic e as operações, higienizando dados, corrigindo escalas e aplicando limiares operacionais por porte (MEI, ME e EPP) para calcular a Taxa Anual Real e o Valor Ponderado.Camada Relacional e Governança (SQL): Isola o ambiente de staging (painel_tx) do schema de produção (produtofinal) e automatiza a recriação de visões via Stored Procedure.Camada de Métricas Ponderadas (Power BI / DAX): Construção do modelo relacional em estrela e criação de medidas DAX para o cálculo dinâmico da Taxa Média Ponderada pelo Valor da Operação.⬆ Voltar ao Sumário📂 Estrutura do Repositório e CódigosAcesse os códigos e scripts de cada etapa do pipeline nas suas respectivas pastas:📄 Documentação em Inglês: README_EN.md🐍 Script de Tratamento em Python: python/processamento_taxas.py🗄️ Stored Procedure e Views SQL: sql/sp_gerar_view_txjuros.sql⚡ Linguagem M (Selic Híbrida 252DU): power_query/selic_acumulada_12m.m📊 Medidas Ponderadas em DAX: dax/medidas_taxa_ponderada.sqlPlaintext├── python/
│   └── processamento_taxas.py     # Script de ingestão, sanitização e motor de regras
├── sql/
│   └── sp_gerar_view_txjuros.sql  # Stored Procedure e Views de produção no MySQL
├── power_query/
│   └── selic_acumulada_12m.m     # Script M para cálculo móvel Selic Híbrida (252 DU)
├── dax/
│   └── medidas_taxa_ponderada.sql # Medidas DAX de taxa média ponderada e volume
├── README.md                      # Documentação executiva em Português
└── README_EN.md                   # Executive documentation in English
⬆ Voltar ao Sumário💎 Geração de Valor para a Instituição e GerênciaPadronização e Confiabilidade: Eliminação do risco de erro humano no tratamento manual de arquivos dos bancos parceiros, garantindo 100% de rastreabilidade do dado.Visão Real do Custo de Crédito: Com a anualização e a Selic híbrida de 252 dias úteis, a gerência enxerga a taxa efetiva real praticada na ponta, sem distorções operacionais.Métricas Financeiras Ponderadas: A substituição da média simples pela Média Ponderada assegura que a análise de risco reflita com precisão o volume financeiro exposto pelo fundo.Eficiência Operacional: Redução do tempo de preparação do painel analítico através da automação do fluxo de dados (Power Query $\rightarrow$ Python $\rightarrow$ SQL $\rightarrow$ Power BI).⬆ Voltar ao Sumário🎯 Conclusão e Tomada de DecisãoA implementação deste pipeline transformou dados brutos e despadronizados em inteligência analítica estratégica. Com esta estrutura, a gestão possui subsídios técnicos para:Negociação com Bancos Parceiros: Identificar instituições financeiras com taxas ou spreads acima do teto regulamentar e fundamentar renegociações operacionais.Ajuste de Políticas de Garantia: Direcionar recursos do fundo para linhas de crédito, portes empresariais e regiões geográficas que apresentam taxas mais equilibradas.Acompanhamento de Tendências: Monitorar o impacto direto da oscilação da taxa Selic sobre a carteira garantida através do modelo preditivo híbrido.🌐 Switch to English Version | ⬆ Voltar ao Topo
