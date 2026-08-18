# Guia da Aula 08: Oficina Prática de Estruturação e Manipulação em MySQL (DDL e DML) (10/08/2026)

Olá! Hoje dedicamos nossa aula à prática intensiva de **Definição de Dados (DDL)** e **Manipulação de Dados (DML)** no MySQL! Vamos dominar a construção física de tabelas, chaves primárias e estrangeiras, modificações estruturais com `ALTER TABLE`, inserções, atualizações com `UPDATE`, exclusões seguras e análise do comportamento do banco com `TRUNCATE` vs `DELETE`! 🛠️💾

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Elaborar scripts SQL de criação, alteração e manipulação de dados (Indicador 6). |
| **Marcas Formativas** | **Domínio Técnico-Científico**: Rigor na tipagem física, declaração de constraints e integridade de FKs.<br>**Visão Crítica**: Análise de impacto de operações estruturais e prevenção de perda de dados. |
| **Dinâmica Metodológica** | **Ação-Reflexão-Ação**: Prática guiada em bancada, simulação de erros reais do SGBD e consolidação de boas práticas. |

---

## 2. Roteiro de Desafios Práticos no phpMyAdmin / MySQL

Acesse a aba **SQL** do seu banco de dados individual no phpMyAdmin e execute os desafios passo a passo:

### 🛠️ Desafio 1: Construção Estruturada com Chaves Primárias e Estrangeiras (DDL)

Crie o banco de dados e as tabelas pai e filha com integridade referencial:

```sql
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS db_laboratorio_pratico;
CREATE DATABASE db_laboratorio_pratico 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE db_laboratorio_pratico;

-- Tabela Pai 1: Categorias
CREATE TABLE categorias (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE,
    descricao VARCHAR(200)
) ENGINE=InnoDB;

-- Tabela Pai 2: Fornecedores
CREATE TABLE fornecedores (
    id_fornecedor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(120) NOT NULL UNIQUE,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL DEFAULT 'SP'
) ENGINE=InnoDB;

-- Tabela Filha: Produtos (com FKs vinculadas aos pais)
CREATE TABLE produtos (
    id_produto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    id_categoria INT UNSIGNED NOT NULL,
    id_fornecedor INT UNSIGNED NOT NULL,
    CONSTRAINT fk_categoria_prod FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    CONSTRAINT fk_fornecedor_prod FOREIGN KEY (id_fornecedor) REFERENCES fornecedores(id_fornecedor)
) ENGINE=InnoDB;
```

---

### 🧬 Desafio 2: Modificações de Esquema sem Perda de Dados (`ALTER TABLE`)

Pratique a evolução da estrutura da tabela:

```sql
-- 1. Adicionar uma nova coluna com restrição CHECK para nota de avaliação
ALTER TABLE produtos 
ADD COLUMN avaliacao DECIMAL(3,1) CHECK (avaliacao BETWEEN 0.0 AND 10.0);

-- 2. Modificar o tamanho e valor padrão de uma coluna existente
ALTER TABLE fornecedores 
MODIFY COLUMN cidade VARCHAR(100) DEFAULT 'Não Informada';

-- 3. Adicionar e remover coluna temporária de teste
ALTER TABLE produtos ADD COLUMN campo_temporario VARCHAR(20);
ALTER TABLE produtos DROP COLUMN campo_temporario;
```

---

### 📥 Desafio 3: Povoamento Ordenado e Atualização de Dados (DML)

Insira registros respeitando a precedência de chaves e pratique atualizações pontuais:

```sql
-- 1. Povoando tabelas pais
INSERT INTO categorias (nome, descricao) VALUES 
('Hardware', 'Componentes físicos e periféricos'),
('Acessórios', 'Itens complementares e cabos');

INSERT INTO fornecedores (razao_social, cidade, estado) VALUES 
('Tech Distribuidora SP', 'São Paulo', 'SP'),
('Sul Componentes', 'Curitiba', 'PR');

-- 2. Povoando tabela filha
INSERT INTO produtos (nome, preco, estoque, id_categoria, id_fornecedor, avaliacao) VALUES 
('Teclado Mecânico RGB', 280.00, 15, 1, 1, 9.5),
('Mouse Sem Fio 1600DPI', 95.00, 30, 2, 1, 8.8),
('Monitor 27 Pol 144Hz', 1250.00, 8, 1, 2, 9.8);

-- 3. Atualização direcionada de preço e estoque (DML)
UPDATE produtos 
SET preco = 269.90, estoque = 12 
WHERE id_produto = 1;
```

---

### 💥 Desafio 4: Teste de Violação de Chave Estrangeira e Análise de Deleção

```sql
-- 1. Teste de Integridade Referencial (Provocação Pedagógica):
-- DELETE FROM categorias WHERE id_categoria = 1;
-- 💥 ERRO 1451: O MySQL impede a deleção da categoria 1 porque existem produtos vinculados a ela!

-- 2. Comparativo Prático: TRUNCATE vs DELETE
CREATE TABLE produtos_backup LIKE produtos;
INSERT INTO produtos_backup SELECT * FROM produtos;

-- DDL: Limpeza total ultra-rápida e reinício do AUTO_INCREMENT
TRUNCATE TABLE produtos_backup;

-- DML: Exclusão de registro específico mantendo o contador da sequência
DELETE FROM produtos WHERE id_produto = 2;

-- Inserir novo produto e observar o próximo ID gerado (será o ID 4)
INSERT INTO produtos (nome, preco, estoque, id_categoria, id_fornecedor, avaliacao) 
VALUES ('Headset USB 7.1', 220.00, 20, 2, 1, 9.0);
```

---

## 🧰 Dicas de Bancada

*   **Sempre use `WHERE` no `UPDATE` e `DELETE`:** Sem a cláusula `WHERE`, todos os registros da tabela serão alterados ou apagados!
*   **Idempotência:** Garanta que seu script possa ser reexecutado do zero sem apresentar erros de "tabela já existente".

Excelente prática de DDL e DML! 🚀💾
