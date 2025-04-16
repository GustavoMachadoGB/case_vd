/case_especialista_dados/ \
│ \
├── 01_ingestao/ \
│   ├── [case_2_carga_de_dados_ao_gcp.py](./case_2_carga_de_dados_ao_gcp.py) \
│   └── [SP_carga_tb_vendas_vd.sql](./SP_carga_tb_vendas_vd.sql) \
│ \
├── 02_transformacoes/  \
│   └── [SP_gera_tabelas_vendas_vd.sql](./SP_gera_tabelas_vendas_vd.sql)  \
│  \
├── 03_visualizacao/  \
│   ├── [dashboard_lookerstudio.png](./dashboard_lookerstudio.png)  \
│   └── [link_dashboard.txt](./link_dashboard.txt)  \
│  \
└── README.md

# Projeto 
O projeto em questão teve como desafio estruturar a ETL de um processo de análise de performance de vendas para canais do Grupo Boticário. 

Há a divisão em 3 etapas: 
## 01 Ingestão de dados: 
Foi utilizado um código [Python em Colab](./case_2_carga_de_dados_ao_gcp.py) para carga incremental das bases presentes em um Drive. 
O Colab faz carga e uma tabela temporária <tb_raw_vendas_vd> e faz uma chamada da [procedure do SQL](./SP_carga_tb_vendas_vd.sql) que realiza a carga incremental, deletando registros que seriam duplicados e inserindo-os novamente.

## 02 Transformações 
É adicionada a uma base final os dados <tb_vendas_vd>. A partir dessa base são criadas 4 outras tabelas através de um [procedure do SQL](./SP_gera_tabelas_vendas_vd.sql): 

  Tabela 1: Consolidado de vendas por ano e mês; \
  Tabela 2: Consolidado de vendas por marca e linha; \
  Tabela 3: Consolidado de vendas por marca, ano e mês; \
  Tabela 4: Consolidado de vendas por linha, ano e mês; 

## 03 Visualização 
A visualização é feita em [Looker Studio](./link_dashboard.txt).
