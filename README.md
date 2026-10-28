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

O projeto foi estruturado através de uma esteira analítica integrada *end-to-end* em 4 camadas técnicas:

```mermaid
graph LR
    A[Dados Brutos & Selic] -->|1. Ingestão & Regras por Porte| B[Python / Pandas]
    B -->|2. Carga Staging & Governança| C[(MySQL Staging)]
    C -->|3. SP Refresh & Visão de Produção| D[(MySQL Produção)]
    D -->|4. Selic Híbrida 252DU| E[Power Query / M]
    E -->|5. Star Schema & DAX Ponderado| F[Power BI Dashboards]
