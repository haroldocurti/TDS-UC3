# Guia da Aula 08: Prática Intensiva de SQL — Consultas, Agregações e Junções Relacionais (10/08/2026)

Olá! Após construirmos as primeiras tabelas e relacionamentos em MySQL, hoje vamos expandir nosso domínio sobre a linguagem SQL! Vamos explorar consultas analíticas poderosas com filtros avançados, funções de agregação (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`), agrupamento de dados com `GROUP BY` e junções entre tabelas via `INNER JOIN`! 📊🔍

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Elaborar scripts SQL de manipulação, agregação e consulta relacional (Indicador 6). |
| **Marcas Formativas** | **Domínio Técnico-Científico**: Rigor na utilização da sintaxe SQL, tipagem e funções analíticas.<br>**Visão Crítica**: Análise da precisão das consultas e integridade dos resultados retornados. |
| **Dinâmica Metodológica** | **Ação-Reflexão-Ação**: Execução prática de desafios com complexidade progressiva e validação imediata no SGBD. |

---

## 2. Roteiro de Desafios Práticos no phpMyAdmin / MySQL

Acesse a aba **SQL** do seu banco de dados individual no phpMyAdmin e execute os desafios passo a passo:

### 🎯 Desafio 1: Filtros Condicionais Avançados (DQL)

Filtre registros utilizando operadores lógicos e condicionais no catálogo da Retro-Vault:

```sql
USE db_retro_games;

-- 1. Buscar jogos lançados entre 1990 e 1995 ordenados pelo ano (mais antigo primeiro)
SELECT id_jogo, titulo, ano_lanc, preco 
FROM jogos 
WHERE ano_lanc BETWEEN 1990 AND 1995 
ORDER BY ano_lanc ASC;

-- 2. Buscar jogos com preço superior a R$ 200,00 ou nota Metacritic maior que 9.0
SELECT titulo, preco, nota_metacritic 
FROM jogos 
WHERE preco > 200.00 OR nota_metacritic > 9.0;

-- 3. Buscar desenvolvedoras cujo nome comece com a letra 'S' ou termine com 'a'
SELECT * 
FROM desenvolvedoras 
WHERE nome LIKE 'S%' OR nome LIKE '%a';
```

---

### 📊 Desafio 2: Funções de Agregação e Estatísticas de Dados

Extraia métricas do banco de dados utilizando funções agregadas:

```sql
-- 1. Contar o total de jogos cadastrados
SELECT COUNT(*) AS total_jogos FROM jogos;

-- 2. Calcular o valor médio, preço máximo e preço mínimo dos jogos
SELECT 
    AVG(preco) AS preco_medio,
    MAX(preco) AS preco_mais_caro,
    MIN(preco) AS preco_mais_barato
FROM jogos;

-- 3. Calcular o valor total do catálogo (soma de todos os preços)
SELECT SUM(preco) AS patrimonio_total_catalogo FROM jogos;
```

---

### 🧩 Desafio 3: Agrupamentos com `GROUP BY` e Filtros de Grupo com `HAVING`

Agrupe os dados para gerar relatórios consolidados:

```sql
-- 1. Quantidade de jogos e preço médio por console
SELECT 
    c.nome_console,
    COUNT(j.id_jogo) AS total_jogos,
    AVG(j.preco) AS media_preco
FROM consoles c
LEFT JOIN jogos j ON c.id_console = j.id_console
GROUP BY c.id_console, c.nome_console;

-- 2. Desenvolvedoras que possuem jogos com média de nota superior a 9.0
SELECT 
    d.nome AS desenvolvedora,
    AVG(j.nota_metacritic) AS media_nota
FROM desenvolvedoras d
INNER JOIN jogos j ON d.id_desenv = j.id_desenv
GROUP BY d.id_desenv, d.nome
HAVING media_nota >= 9.0;
```

---

### 🔗 Desafio 4: Consultas com Múltiplos `JOIN`s e Apelidos (Aliases)

Construa um relatório completo consolidando todas as entidades do banco:

```sql
SELECT 
    j.id_jogo AS Codigo,
    j.titulo AS Titulo_Jogo,
    c.nome_console AS Plataforma,
    d.nome AS Estúdio,
    d.nacionalidade AS Origem_Estudio,
    CONCAT('R$ ', FORMAT(j.preco, 2, 'pt_BR')) AS Preco_Formatado,
    j.nota_metacritic AS Nota_Critica
FROM jogos j
INNER JOIN consoles c ON j.id_console = c.id_console
INNER JOIN desenvolvedoras d ON j.id_desenv = d.id_desenv
ORDER BY j.nota_metacritic DESC;
```

---

## 🧰 Dicas de Bancada (Boas Práticas SQL)

*   **`COUNT(*)` vs `COUNT(coluna)`:** `COUNT(*)` conta todas as linhas retornadas pela consulta, enquanto `COUNT(coluna)` ignora valores `NULL` naquela coluna específica.
*   **`WHERE` vs `HAVING`:** O `WHERE` filtra linhas **antes** do agrupamento. O `HAVING` filtra os resultados agregados **depois** do `GROUP BY`.
*   **Aliases com `AS`:** Sempre nomeie colunas calculadas com apelidos claros para facilitar a leitura e o consumo por aplicações backend.

Bons estudos e continue praticando suas consultas no phpMyAdmin! 🚀💾
