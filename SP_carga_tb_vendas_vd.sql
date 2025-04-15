CREATE OR REPLACE PROCEDURE `sandbox-fpa-online.repositorio_informacoes.SP_carga_tb_vendas_vd`()
BEGIN

-- Declaração de variáveis
DECLARE linhas_carregadas INT64;
DECLARE linhas_excluidas  INT64;
DECLARE arquivo_carga     STRING;

-- Cria a tabela se não existir
CREATE TABLE IF NOT EXISTS `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd` (
  cod_id          STRING,  
  cod_marca       INT64,
  des_marca       STRING,
  cod_linha       INT64,
  des_linha       STRING,
  dt_venda        DATE,
  vlr_qt_venda    INT64,
  des_arq_carga   STRING, 
  dt_carga        DATETIME);

-- Tabela temporária para fazer dedup/update + insert
CREATE TEMP TABLE tb_stg_vendas_vd AS (SELECT 
  CONCAT(ID_LINHA,'_', ID_MARCA, '_', CAST(UNIX_SECONDS(TIMESTAMP(DATA_VENDA)) AS STRING)) AS cod_id,
  ID_MARCA          AS cod_marca,
  MARCA             AS des_marca,
  ID_LINHA          AS cod_linha,
  LINHA             AS des_linha,
  DATE(DATA_VENDA)  AS dt_venda,
  SUM(QTD_VENDA)    AS vlr_qt_venda,
  des_arq_carga,
  dt_carga,
FROM `sandbox-fpa-online.repositorio_informacoes.tb_raw_vendas_vd`
GROUP BY ALL);

-- Salvando valores para o log da carga
SET linhas_carregadas = (SELECT COUNT(*) FROM tb_stg_vendas_vd);
SET linhas_excluidas = (SELECT COUNT(*) FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
  WHERE cod_id IN (SELECT DISTINCT cod_id FROM tb_stg_vendas_vd));
SET arquivo_carga = (SELECT DISTINCT des_arq_carga FROM tb_stg_vendas_vd);

-- Dedup/update + Insert
DELETE FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
WHERE cod_id IN (SELECT DISTINCT cod_id FROM tb_stg_vendas_vd);
INSERT INTO `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
SELECT * FROM tb_stg_vendas_vd;

-- Adicionando registor da carga no log
INSERT INTO `sandbox-fpa-online.repositorio_informacoes.tb_log_carga_vendas_vd` (
  SELECT 
    CURRENT_TIMESTAMP() AS dt_carga, 
    linhas_carregadas AS qt_linhas_add, 
    linhas_excluidas AS qt_linhas_del, 
    arquivo_carga AS des_arquivo_carga);

END;