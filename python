import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
import unicodedata
import re
import os

# ==========================================
# 1. CONFIGURAÇÕES GERAIS DE CONEXÃO E CAMINHOS
# ==========================================
USER = 'root'
PASSWORD = ''
HOST = '127.0.0.1'
PORT = '3306'
SCHEMA_ORIGEM = 'qvd'
SCHEMA_DESTINO = 'painel_tx'

# Caminhos de Arquivos (Atualizado para indicar 'vporte' no arquivo final)
CAMINHO_ENTRADA_SELIC = "W:/30 - ADMINISTRATIVO/FAMPE -HONRAS/BI/Painel Taxa Juros/FATO_SELIC.xlsx"
CAMINHO_SAIDA_CSV = "C:/Users/PLM.ANDREY.UCSF/OneDrive - SEBRAE/Área de Trabalho/csv TX/epp = me/pf_taxajurosvporte.csv"

# Criando Engine de Conexão
engine = create_engine(f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{SCHEMA_DESTINO}")

# ==========================================
# 2. FUNÇÃO DE LIMPEZA (SCRIPT 1)
# ==========================================
def limpar_nome_colunas(df):
    def normalizar(txt):
        txt = str(txt)
        txt = unicodedata.normalize('NFKD', txt).encode('ascii', 'ignore').decode('utf-8')
        txt = re.sub(r'[^a-zA-Z0-9]', '_', txt).strip('_').lower()
        if txt[0].isdigit():
            txt = 'col_' + txt
        return txt
    df.columns = [normalizar(col) for col in df.columns]
    return df

# ==========================================
# 3. EXECUÇÃO: IMPORTAÇÃO FATO_SELIC
# ==========================================
try:
    print(f"🔄 1/5 Lendo arquivo SELIC: {os.path.basename(CAMINHO_ENTRADA_SELIC)}...")
    df_selic_excel = pd.read_excel(CAMINHO_ENTRADA_SELIC)
    df_selic_excel = limpar_nome_colunas(df_selic_excel)
    
    print(f"🚀 Enviando 'fato_selic' para MySQL...")
    df_selic_excel.to_sql(name='fato_selic', con=engine, if_exists='replace', index=False)
    print("✅ Tabela 'fato_selic' atualizada.")

# ==========================================
# 4. EXECUÇÃO: CÁLCULOS E PROCESSAMENTO (SCRIPT 2)
# ==========================================
    print("🔄 2/5 Extraindo base histórica e realizando cálculos...")
    
    query_ope = f"""
    SELECT 
        BCO_CODIGOBANCO_OPE_CODIGOBANCO as COD_BANCO,
        OPE_NROOPERACAOBANCO,
        OPE_TAXAJUROS,
        OPE_DATAINICIO,
        OPE_VALOROPERACAO,
        OPE_UF, 
        OPE_CODIGOLINHAAVAL, 
        OPE_CODIGOSITUACAO_SIT_COD_N3,
        OPE_CODIGOPORTE_POR_CODIGOPORTE
    FROM {SCHEMA_ORIGEM}.ope 
    WHERE OPE_DATAINICIO >= '2020-01-01'
    """
    
    df_ope = pd.read_sql(query_ope, engine)
    df_selic = pd.read_sql("SELECT data, fator_acum_12mes FROM fato_selic", engine)

    # Limpeza e Normalização
    df_ope['OPE_TAXAJUROS'] = df_ope['OPE_TAXAJUROS'].astype(str).str.replace(',', '.').astype(float)
    df_ope['OPE_VALOROPERACAO'] = (
        df_ope['OPE_VALOROPERACAO']
        .astype(str)
        .str.replace('.', '', regex=False)
        .str.replace(',', '.', regex=False)
        .astype(float)
    )
    df_ope = df_ope[df_ope['OPE_TAXAJUROS'] > 0].copy()
    
    # Remover operações sem porte identificado (código 0, '0' ou nulo)
    df_ope = df_ope[
        (df_ope['OPE_CODIGOPORTE_POR_CODIGOPORTE'] != 0) & 
        (df_ope['OPE_CODIGOPORTE_POR_CODIGOPORTE'] != '0') &
        (df_ope['OPE_CODIGOPORTE_POR_CODIGOPORTE'].notnull())
    ].copy()

    df_ope['TAXA_DECIMAL'] = df_ope['OPE_TAXAJUROS'].apply(lambda x: x/100 if x > 0.5 else x)

    # Merge e Cálculo
    df_ope['OPE_DATAINICIO'] = pd.to_datetime(df_ope['OPE_DATAINICIO']).dt.date
    df_selic['data'] = pd.to_datetime(df_selic['data']).dt.date
    df_merged = pd.merge(df_ope, df_selic, left_on='OPE_DATAINICIO', right_on='data', how='left')

    # Lógica de cálculo parametrizada por Porte
    def processar_operacao(row):
        t = row['TAXA_DECIMAL']
        f = row['fator_acum_12mes'] if pd.notnull(row['fator_acum_12mes']) else 1
        porte = str(row['OPE_CODIGOPORTE_POR_CODIGOPORTE'])

        # Definição dos limites conforme o Porte
        if porte == '1':
            limite_pos = 0.0105 # até 1,05% ME
            limite_pre = 0.0300 # até 3,0% ME
        elif porte == '2':
            limite_pos = 0.0105 # até 1,05% EPP
            limite_pre = 0.0300 # até 3,0% EPP
        elif porte == '4':
            limite_pos = 0.0160 # até 1,6% MEI
            limite_pre = 0.0400 # até 4,0% MEI
        else:
            # Fallback de segurança para caso surja outro porte inesperado
            limite_pos = 0.0120
            limite_pre = 0.0400

        # Aplicação das fórmulas de acordo com os limites definidos
        if t <= limite_pos:
            tipo = 'PÓSFIXADA'
            taxa_anual = ((1 + t)**12 * f) - 1
        elif t < limite_pre:
            tipo = 'PREFIXADA'
            taxa_anual = (1 + t)**12 - 1
        else:
            tipo = 'PREFIXADA'
            taxa_anual = ((1 + t) * f) - 1

        return pd.Series([tipo, taxa_anual])

    df_merged[['TIPO_TAXA', 'TAXA_ANUAL_REAL']] = df_merged.apply(processar_operacao, axis=1)
    df_merged['VALOR_PONDERADO'] = df_merged['TAXA_ANUAL_REAL'] * df_merged['OPE_VALOROPERACAO']

    # ALTERADO: Nome da tabela para 'operacoes_processadasvporte'
    print(f"🚀 Enviando 'operacoes_processadasvporte' para MySQL...")
    df_merged.to_sql('operacoes_processadasvporte', engine, if_exists='replace', index=False)
    print(f"✅ {len(df_merged)} linhas processadas e salvas.")

# ==========================================
# 5. EXECUÇÃO DA STORED PROCEDURE
# ==========================================
    # ALTERADO: Nome da SP para 'sp_gerar_view_txjurosvporte'
    print("🔄 3/5 Rodando Stored Procedure 'sp_gerar_view_txjurosvporte'...")
    with engine.begin() as conn:
        conn.execute(text("CALL painel_tx.sp_gerar_view_txjurosvporte();"))
    print("✅ Stored Procedure executada com sucesso.")

# ==========================================
# 6. EXPORTAÇÃO PARA CSV
# ==========================================
    print(f"🔄 4/5 Gerando arquivo CSV final...")
    # ALTERADO: Leitura da View 'produtofinal.pf_taxajurosvporte'
    df_final = pd.read_sql("SELECT * FROM produtofinal.pf_taxajurosvporte", engine)
    
    df_final.to_csv(CAMINHO_SAIDA_CSV, index=False, sep=';', encoding='utf-8-sig')
    print(f"✅ Sucesso total! Arquivo salvo em: {CAMINHO_SAIDA_CSV}")

except Exception as e:
    print(f"❌ Erro detectado durante o processo: {e}")
