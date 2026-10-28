# interest-rate-analytics-pipeline

# 📊 Engenharia e Análise Quantitativa da Taxa de Juros de Fundos Garantidores

[![Language: English](https://img.shields.io/badge/Language-English-blue.svg)](README_en.md)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)](python/)
[![SQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat&logo=mysql&logoColor=white)](sql/)
[![Power BI](https://img.shields.io/badge/Power_BI-DAX_%26_M-F2C811?style=flat&logo=powerbi&logoColor=black)](dax/)

---

## 📋 Sumário
- [🏙️ Cenário e Contexto](#-cenário-e-contexto)
- [⚠️ Problemáticas de Negócio](#️-problemáticas-de-negócio)
- [🛠️ Resolução de Dores e Solução Técnica](#️-resolução-de-dores-e-solução-técnica)
- [📂 Estrutura do Repositório](#-estrutura-do-repositório)
- [💎 Geração de Valor para a Instituição e Gerência](#-geração-de-valor-para-a-instituição-e-gerência)
- [🎯 Conclusão e Tomada de Decisão](#-conclusão-e-tomada-de-decisão)

---

## 🏙️ Cenário e Contexto

No ecossistema de concessão de crédito apoiado por **Fundos Garantidores**, a instituição atua como prestadora de garantia para mitigar o risco de inadimplência de micro e pequenas empresas (MEI, ME e EPP) junto aos bancos parceiros. 

Para monitorar a efetividade do fundo e garantir que os tomadores finais estejam recebendo taxas de juros competitivas e alinhadas às diretrizes operacionais, a alta gestão necessita de visibilidade clara sobre o custo do crédito concedido na ponta.

No entanto, o volume massivo de operações originadas por dezenas de instituições financeiras parceiras gera um grande fluxo de dados descentralizado, onde cada banco reporta suas taxas sob padrões, periodicidades e formatos próprios.

[🌐 Switch to English Version](README_en.md) | [⬆ Voltar ao Sumário](#-sumário)

---

## ⚠️ Problemáticas de Negócio

1. **Heterogeneidade e Ausência de Padronização:** Os bancos parceiros enviam arquivos com formatos de taxas distintos (taxas mensais vs. anuais, decimais vs. percentuais, separadores de ponto vs. vírgula).
2. **Ambiguidade entre Taxas Pré e Pós-Fixadas:** Dificuldade em identificar se a taxa reportada é fixa ou atrelada ao indexador de mercado (Selic), inviabilizando a comparação direta da taxa real praticada.
3. **Distorção no Acumulado da Selic (Distorção Temporal de 12M):** Para operações recentes sem 12 meses completos de histórico, a simples acumulação dos dias passados gera uma subestimação da taxa Selic anualizada, distorcendo o cálculo da taxa pós-fixada.
4. **Falta de Métricas Ponderadas por Volume:** A análise baseada em médias simples mascarava a real exposição financeira do fundo, pois operações de R$ 5 mil tinham o mesmo peso visual de operações de R$ 500 mil.

[⬆ Voltar ao Sumário](#-sumário)

---

## 🛠️ Resolução de Dores e Solução Técnica

Para resolver estas dores, foi desenvolvida uma arquitetura de dados *end-to-end* estruturada em 4 camadas de engenharia e inteligência analítica:

```mermaid
graph LR
    A[Dados Brutos & Selic] -->|1. Ingestão & Regras por Porte| B[Python / Pandas]
    B -->|2. Carga Staging & Governance| C[(MySQL Staging)]
    C -->|3. SP Refresh & Production View| D[(MySQL Produção)]
    D -->|4. Selic Híbrida 252DU| E[Power Query / M]
    E -->|5. Star Schema & DAX Ponderado| F[Power BI Dashboards]# 📊 Engenharia e Análise Quantitativa da Taxa de Juros de Fundos Garantidores

[![Language: English](https://img.shields.io/badge/Language-English-blue.svg)](README_en.md)
[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat&logo=python&logoColor=white)](python/)
[![SQL](https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat&logo=mysql&logoColor=white)](sql/)
[![Power BI](https://img.shields.io/badge/Power_BI-DAX_%26_M-F2C811?style=flat&logo=powerbi&logoColor=black)](dax/)

---

## 📋 Sumário
- [🏙️ Cenário e Contexto](#-cenário-e-contexto)
- [⚠️ Problemáticas de Negócio](#️-problemáticas-de-negócio)
- [🛠️ Resolução de Dores e Solução Técnica](#️-resolução-de-dores-e-solução-técnica)
- [📂 Estrutura do Repositório](#-estrutura-do-repositório)
- [💎 Geração de Valor para a Instituição e Gerência](#-geração-de-valor-para-a-instituição-e-gerência)
- [🎯 Conclusão e Tomada de Decisão](#-conclusão-e-tomada-de-decisão)

---

## 🏙️ Cenário e Contexto

No ecossistema de concessão de crédito apoiado por **Fundos Garantidores**, a instituição atua como prestadora de garantia para mitigar o risco de inadimplência de micro e pequenas empresas (MEI, ME e EPP) junto aos bancos parceiros. 

Para monitorar a efetividade do fundo e garantir que os tomadores finais estejam recebendo taxas de juros competitivas e alinhadas às diretrizes operacionais, a alta gestão necessita de visibilidade clara sobre o custo do crédito concedido na ponta.

No entanto, o volume massivo de operações originadas por dezenas de instituições financeiras parceiras gera um grande fluxo de dados descentralizado, onde cada banco reporta suas taxas sob padrões, periodicidades e formatos próprios.

[🌐 Switch to English Version](README_en.md) | [⬆ Voltar ao Sumário](#-sumário)

---

## ⚠️ Problemáticas de Negócio

1. **Heterogeneidade e Ausência de Padronização:** Os bancos parceiros enviam arquivos com formatos de taxas distintos (taxas mensais vs. anuais, decimais vs. percentuais, separadores de ponto vs. vírgula).
2. **Ambiguidade entre Taxas Pré e Pós-Fixadas:** Dificuldade em identificar se a taxa reportada é fixa ou atrelada ao indexador de mercado (Selic), inviabilizando a comparação direta da taxa real praticada.
3. **Distorção no Acumulado da Selic (Distorção Temporal de 12M):** Para operações recentes sem 12 meses completos de histórico, a simples acumulação dos dias passados gera uma subestimação da taxa Selic anualizada, distorcendo o cálculo da taxa pós-fixada.
4. **Falta de Métricas Ponderadas por Volume:** A análise baseada em médias simples mascarava a real exposição financeira do fundo, pois operações de R$ 5 mil tinham o mesmo peso visual de operações de R$ 500 mil.

[⬆ Voltar ao Sumário](#-sumário)

---

## 🛠️ Resolução de Dores e Solução Técnica

Para resolver estas dores, foi desenvolvida uma arquitetura de dados *end-to-end* estruturada em 4 camadas de engenharia e inteligência analítica:

```mermaid
graph LR
    A[Dados Brutos & Selic] -->|1. Ingestão & Regras por Porte| B[Python / Pandas]
    B -->|2. Carga Staging & Governance| C[(MySQL Staging)]
    C -->|3. SP Refresh & Production View| D[(MySQL Produção)]
    D -->|4. Selic Híbrida 252DU| E[Power Query / M]
    E -->|5. Star Schema & DAX Ponderado| F[Power BI Dashboards]
