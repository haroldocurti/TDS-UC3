# Guia da Aula 11: Consultas Relacionais em SQL (DQL) e Análise de Dados — Estudo de Caso TechStore Brasil (18/08/2026)

Olá, futuro(a) Analista de Dados! Hoje daremos um salto fundamental na nossa formação técnica. Entraremos a fundo na **Linguagem de Consulta de Dados (SQL DQL)**, aprendendo a extrair respostas inteligentes e relatórios estratégicos a partir de bancos de dados relacionais! 📊🔍

Nesta aula, você assume o papel de **Analista de Dados Júnior da TechStore Brasil**, um e-commerce em plena expansão nacional. A diretoria e as áreas de negócio (Marketing, Logística, Estoque e Finanças) enviaram 15 chamados com demandas reais para você resolver!

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Elaborar scripts SQL de consulta, filtros condicionais, agregações estatísticas e junções relacionais multi-tabelas (Indicador 6). |
| **Marcas Formativas** | **Domínio Técnico-Científico**: Compreensão precisa da ordem lógica de processamento do SQL, rigor na sintaxe e conexão de chaves primárias e estrangeiras.<br>**Visão Crítica**: Capacidade de interpretar dados analíticos e identificar clientes inativos através de `LEFT JOIN ... IS NULL`.<br>**Atitude Profissional**: Resolução autônoma de chamados corporativos simulando a rotina real de um time de dados. |
| **Dinâmica Metodológica** | **Aprendizagem Baseada em Problemas (PBL)**: Atendimento prático a 15 chamados corporativos divididos em 3 módulos funcionais. |

---

## 2. Preparação do Ambiente de Laboratório

Para realizar os exercícios e testes da aula de hoje, utilizaremos a base de dados corporativa consolidada da TechStore Brasil:

1. Acesse o phpMyAdmin com o seu usuário individual.
2. Abra o arquivo **`loja_teste_completo.sql`** (disponível na pasta `Biblioteca/` do repositório).
3. Copie todo o conteúdo do script, cole na aba **SQL** do phpMyAdmin e clique em **Executar**.
4. Verifique se o banco de dados `loja_teste` foi criado com as 4 tabelas: `clientes` (25 registros), `produtos` (68 registros), `pedidos` (27 registros) e `itens_pedido` (35 registros).

---

## 3. Fundamentos Teóricos e Exemplos Práticos

### 🔍 3.1 Recuperação Básica: `SELECT`, `FROM`, `WHERE`, `ORDER BY` e `LIMIT`

A estrutura mais básica de consulta é composta pela seleção das colunas desejadas (`SELECT`) e pela indicação da tabela de origem (`FROM`):

```sql
-- Selecionando colunas específicas
SELECT nome, email, cidade FROM clientes;

-- Selecionando todas as colunas
SELECT * FROM produtos;
```

Para filtrar registros, utilizamos a cláusula `WHERE` combinada com operadores:

*   **Comparação:** `=`, `!=` (ou `<>`), `<`, `>`, `<=`, `>=`.
*   **Lógicos:** `AND` (ambas as condições verdadeiras), `OR` (ao menos uma verdadeira), `NOT` (negação).
*   **Intervalos (`BETWEEN`):** `WHERE preco BETWEEN 50.00 AND 100.00` (inclusivo).
*   **Listas de Valores (`IN`):** `WHERE estado IN ('SP', 'RJ', 'MG')`.
*   **Busca por Padrão de Texto (`LIKE`):**
    *   `%` representa zero ou múltiplos caracteres. Ex: `WHERE nome LIKE 'M%'` (começa com M) ou `WHERE email LIKE '%@email.com'` (termina com @email.com).
    *   `_` representa exatamente um caractere qualquer.

Para organizar a exibição e paginar os resultados:
*   **`ORDER BY coluna ASC`** (ordem crescente - padrão) ou **`DESC`** (ordem decrescente).
*   **`LIMIT N`** (restringe a quantidade máxima de linhas retornadas).

```sql
-- Exemplo: 5 produtos mais caros da categoria Eletrônicos
SELECT nome, preco, estoque 
FROM produtos 
WHERE categoria = 'Eletrônicos' 
ORDER BY preco DESC 
LIMIT 5;
```

---

### 📊 3.2 Análise e Agregações: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY` e `HAVING`

As funções de agregação processam múltiplos valores e retornam um único resumo numérico:

*   `COUNT(*)`: Conta a quantidade total de registros.
*   `SUM(coluna)`: Soma todos os valores numéricos.
*   `AVG(coluna)`: Calcula a média aritmética.
*   `MIN(coluna)` / `MAX(coluna)`: Retorna o menor e o maior valor.

Quando combinadas com o **`GROUP BY`**, as funções calculam métricas segmentadas por categorias ou dimensões:

```sql
-- Exemplo: Quantidade de produtos e preço médio por categoria
SELECT 
    categoria,
    COUNT(*) AS total_produtos,
    AVG(preco) AS media_preco
FROM produtos
GROUP BY categoria;
```

#### ⚠️ Distinção Fundamental: `WHERE` vs `HAVING`
*   **`WHERE`**: Filtra **linhas individuais** *antes* de qualquer agrupamento ou cálculo de agregação ser realizado.
*   **`HAVING`**: Filtra **os grupos já calculados** *após* o `GROUP BY`.

```sql
-- Exemplo: Apenas categorias que possuem média de preço superior a R$ 100,00
SELECT 
    categoria,
    AVG(preco) AS media_preco
FROM produtos
GROUP BY categoria
HAVING media_preco > 100.00;
```

---

### 🔗 3.3 Relacionamentos e Junções: `INNER JOIN`, `LEFT JOIN` e Junções Múltiplas

Em bancos relacionais, os dados estão distribuídos em tabelas conectadas por **Chaves Primárias (PK)** e **Chaves Estrangeiras (FK)**. Para cruzar essas informações em uma única visão, utilizamos os `JOIN`s:

#### 1. `INNER JOIN` (Interseção Exata)
Retorna **apenas** os registros que possuem correspondência mútua em ambas as tabelas:

```sql
SELECT 
    c.nome AS cliente,
    p.id AS id_pedido,
    p.data_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id;
```

#### 2. `LEFT JOIN` e o Padrão `IS NULL` (Preservação à Esquerda e Detecção de Inativos)
O `LEFT JOIN` preserva **todos** os registros da tabela principal (à esquerda), mesmo que não haja correspondência na tabela secundária (preenchendo com `NULL`). Quando filtramos por `WHERE tabela_direita.id IS NULL`, identificamos com precisão entidades órfãs ou sem movimentação (ex: clientes cadastrados que nunca compraram nada):

```sql
SELECT 
    c.nome,
    c.email
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
WHERE p.id IS NULL;
```

#### 3. Junções Múltiplas em Cadeia (Fluxo Completo)
Podemos conectar quantas tabelas forem necessárias encadeando os `JOIN`s pela sua chave de ligação:

```text
clientes (id) ➔ pedidos (cliente_id / id) ➔ itens_pedido (pedido_id / produto_id) ➔ produtos (id)
```

```sql
SELECT 
    c.nome AS cliente,
    p.id AS pedido,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN itens_pedido ip ON p.id = ip.pedido_id
INNER JOIN produtos pr ON ip.produto_id = pr.id;
```

---

## 🏢 Cenário de Negócio: TechStore Brasil

Você acaba de assumir a análise de dados da **TechStore Brasil**. O banco de dados (`loja_teste`) centraliza as operações de clientes, catálogo, pedidos e itens faturados.

Abaixo estão os 15 chamados recebidos pelo time de dados. Resolva cada um deles escrevendo a consulta SQL correspondente na aba SQL do phpMyAdmin!

---

## 📝 Lista de Chamados do Time de Negócios (Sem Gabarito)

### 👥 Módulo 1: Atendimento e Marketing (Filtros e Consultas Básicas)

*   📩 **Chamado #101 (Marketing): Campanha de E-mail Geral**  
    *Demanda:* O time de marketing precisa disparar uma newsletter institucional. Extraia apenas o `nome` e o `email` de todos os clientes da base.

*   📍 **Chamado #102 (Logística): Abertura de Novo CD em Minas Gerais**  
    *Demanda:* A logística quer mapear os clientes de Minas Gerais para dimensionar um novo centro de distribuição. Retorne todas as informações dos clientes que residem no estado `'MG'`.

*   🪑 **Chamado #103 (Comercial): Campanha Premium de Móveis**  
    *Demanda:* O setor de móveis quer promover produtos de maior valor agregado. Liste o `nome`, o `preco` e o `estoque` dos itens da categoria `'Móveis'` com `preco` superior a R$ 200,00.

*   🏷️ **Chamado #104 (Marketing): Promoção "Faixa Ideal"**  
    *Demanda:* Para um banner promocional de presentes intermediários, liste o `nome` e o `preco` dos produtos cujo valor fique entre R$ 50,00 e R$ 100,00.

*   🚚 **Chamado #105 (Logística): Campanha Regional Sudeste**  
    *Demanda:* A empresa vai conceder frete fixo regional. Localize todos os clientes que residem nos estados de `'SP'`, `'RJ'` ou `'MG'`.

*   🔍 **Chamado #106 (TI/Segurança): Auditoria de Base de Clientes**  
    *Demanda:* A equipe de TI identificou um lote de cadastros de teste. Liste todos os clientes cujo nome comece com a letra `'M'` e cujo e-mail termine com o domínio `@email.com`.

---

### 📦 Módulo 2: Gestão de Estoque e Indicadores Globais (Ordenação e Agregações)

*   ⚠️ **Chamado #107 (Estoque): Alerta de Ruptura Crítica**  
    *Demanda:* O time de compras precisa repor com urgência os itens com menos unidades disponíveis. Exiba o `nome`, o `preco` e o `estoque` dos 3 produtos com menor quantidade em estoque.

*   📊 **Chamado #108 (Diretoria): Painel Executivo de Faturamento Unitário**  
    *Demanda:* O conselho precisa de um resumo operacional da tabela `itens_pedido`. Em uma única consulta, calcule: o total de peças vendidas (`total_pecas_vendidas`), o preço médio unitário praticado (`preco_unitario_medio`) e o valor unitário mais alto já vendido (`item_mais_caro`).

*   🗺️ **Chamado #109 (Comercial): Concentração de Clientes por Estado**  
    *Demanda:* A diretoria quer saber onde concentrar os esforços de expansão. Liste cada `estado` e o total de clientes cadastrados (`total_clientes`), ordenando do estado com maior base para o menor.

*   💎 **Chamado #110 (Planejamento): Segmentos de Alto Valor Médio**  
    *Demanda:* O time de precificação quer identificar categorias sofisticadas. Agrupe a tabela `produtos` por `categoria`, calcule a média de preço (`media_preco`) e exiba apenas as categorias cuja média seja superior a R$ 150,00.

---

### 🔗 Módulo 3: Operações, Relacionamentos e Finanças (JOINs Simples e Múltiplos)

*   📦 **Chamado #111 (Atendimento): Histórico de Pedidos de Clientes**  
    *Demanda:* O SAC precisa cruzar cadastros e vendas. Gere uma lista com o `nome` do cliente, o `id` do pedido e a `data_pedido` para todas as compras registradas na base.

*   ⏳ **Chamado #112 (Logística): Pedidos Travados em Triagem**  
    *Demanda:* O setor de expedição precisa agir nos pedidos que ainda não foram enviados. Liste o `nome` do cliente, sua `cidade`, o `id` do pedido e o `status`, trazendo apenas os pedidos com `status = 'Processando'`.

*   💤 **Chamado #113 (CRM/Marketing): Reativação de Contas Inativas**  
    *Demanda:* O time de retenção quer criar uma campanha de "Primeira Compra" com cupom de desconto. Usando `LEFT JOIN`, identifique o `nome` e o `email` dos clientes que nunca realizaram nenhum pedido (`pedidos.id IS NULL`).

*   📋 **Chamado #114 (Auditoria): Rastreio Completo de Itens Faturados**  
    *Demanda:* A auditoria fiscal solicitou a visualização ponta a ponta dos itens. Conecte `pedidos`, `itens_pedido` e `produtos` para exibir: `id` do pedido, `data_pedido`, `nome` do produto, `quantidade` comprada e `preco_unitario`.

*   🏆 **Chamado #115 (Finanças): Relatório de Clientes VIP (Desafio Master)**  
    *Demanda:* O setor financeiro quer premiar os clientes de maior valor no trimestre. Conecte `clientes`, `pedidos` e `itens_pedido`, calcule o total financeiro gasto por cada cliente (soma de `quantidade * preco_unitario` com o alias `total_gasto`), mostre apenas quem gastou mais de R$ 300,00 no acumulado e ordene do maior comprador para o menor.

---

## 🧰 Dicas de Bancada

*   **Aliases de Tabela:** Utilize apelidos curtos (`FROM clientes c INNER JOIN pedidos p ON c.id = p.cliente_id`) para deixar suas consultas enxutas e fáceis de manter.
*   **Validação Visual:** Ao rodar uma consulta analítica, compare a quantidade de linhas retornadas com o esperado pelo modelo de dados para garantir que não houve duplicação indevida por produto cartesiano.

Excelente trabalho solucionando os chamados da TechStore Brasil! 🚀📈
