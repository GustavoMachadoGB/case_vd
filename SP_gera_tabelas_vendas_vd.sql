CREATE OR REPLACE PROCEDURE `sandbox-fpa-online.repositorio_informacoes.SP_gera_tabelas_vendas_vd`()
BEGIN

-- Carga da Tabela 1: Consolidado de vendas por ano e mês;
CREATE OR REPLACE TABLE `sandbox-fpa-online.repositorio_informacoes.tb_consolidado_mensal` AS (
  SELECT
    EXTRACT(YEAR FROM DT_VENDA) AS nr_ano,
    EXTRACT(MONTH FROM DT_VENDA) AS nr_mes,
    DATE_TRUNC(DT_VENDA, MONTH) AS dt_referencia,
    SUM(vlr_qt_venda) AS vlr_qt_vendas
  FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
  GROUP BY ALL
);

-- Carga da Tabela 2: Consolidado de vendas por marca e linha;
CREATE OR REPLACE TABLE `sandbox-fpa-online.repositorio_informacoes.tb_consolidado_marca_linha` AS (
  SELECT
    cod_marca,
    des_marca,
    cod_linha,
    des_linha,
    SUM(vlr_qt_venda) AS vlr_qt_vendas
  FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
  GROUP BY ALL
);

-- Carga da Tabela 3: Consolidado de vendas por marca, ano e mês;
CREATE OR REPLACE TABLE `sandbox-fpa-online.repositorio_informacoes.tb_consolidado_mensal_marca` AS (
  SELECT
    EXTRACT(YEAR FROM DT_VENDA) AS nr_ano,
    EXTRACT(MONTH FROM DT_VENDA) AS nr_mes,
    DATE_TRUNC(DT_VENDA, MONTH) AS dt_referencia,
    cod_marca,
    des_marca,
    SUM(vlr_qt_venda) AS vlr_qt_vendas
  FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
  GROUP BY ALL
);

-- Carga da Tabela 4: Consolidado de vendas por linha, ano e mês;
CREATE OR REPLACE TABLE `sandbox-fpa-online.repositorio_informacoes.tb_consolidado_mensal_linha` AS (
  SELECT
    EXTRACT(YEAR FROM DT_VENDA) AS nr_ano,
    EXTRACT(MONTH FROM DT_VENDA) AS nr_mes,
    DATE_TRUNC(DT_VENDA, MONTH) AS dt_referencia,
    cod_linha,
    des_linha,
    SUM(vlr_qt_venda) AS vlr_qt_vendas
  FROM `sandbox-fpa-online.repositorio_informacoes.tb_vendas_vd`
  GROUP BY ALL
);

END;