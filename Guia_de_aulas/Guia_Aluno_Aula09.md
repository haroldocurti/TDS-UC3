# Guia da Aula 09: Retomada Prática e Fixação dos Conceitos da Aula 06 — DDL, Constraints, Alterações e Integridade Referencial (11/08/2026)

Olá! Hoje dedicamos nossa aula para revisitar, aprofundar e consolidar na bancada todos os conceitos fundamentais explorados na **Aula 06** (o ecossistema da *Retro-Vault*). Vamos garantir o domínio completo sobre a criação de tabelas pai e filha, relacionamentos com chave estrangeira (`FOREIGN KEY`), alterações estruturais (`ALTER TABLE`), testes de integridade referencial (como o erro 1451) e a diferença vital entre `TRUNCATE` e `DELETE`! 🕹️⚙️

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Implementar esquemas relacionais físicos, criar restrições e diagnosticar erros de integridade (Indicador 6). |
| **Marcas Formativas** | **Domínio Técnico-Científico**: Rigor no motor InnoDB, integridade referencial e comportamento do `AUTO_INCREMENT`.<br>**Colaboração e Comunicação**: Depuração em pares e compartilhamento de soluções para erros comuns de bancada. |
| **Dinâmica Metodológica** | **Ação-Reflexão-Ação**: Refatoração prática do script da Aula 06, simulação proposital de falhas e análise das respostas do SGBD. |

---

## 2. Mapa Conceitual Rápido (Revisão da Aula 06)

```text
  [ desenvolvedoras ] (Tabela Pai)        [ consoles ] (Tabela Pai)
   id_desenv (PK)                          id_console (PK)
         \                                       /
          \---- 1 : N ---- [ jogos ] ---- N : 1 /
                         id_jogo (PK)
                         id_desenv (FK) -> desenvolvedoras(id_desenv)
                         id_console (FK) -> consoles(id_console)
```

> **Regra de Ouro:** Não é possível criar uma Chave Estrangeira se a Chave Primária correspondente não existir previamente! Portanto, crie sempre as tabelas **pais** antes das tabelas **filhas**.

---

## 3. Roteiro Prático de Fixação no phpMyAdmin

Abra a aba **SQL** da sua base de dados individual e realize a revisão guiada:

### 🛠️ Desafio 1: Reconstrução Idempotente do Banco Retro-Vault

Recrie a estrutura garantindo idempotência e charset correto:

```sql
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS db_retro_games;
CREATE DATABASE db_retro_games 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE db_retro_games;

-- 1. Tabela Pai: Desenvolvedoras
CREATE TABLE desenvolvedoras (
    id_desenv INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    nacionalidade VARCHAR(50) DEFAULT 'Desconhecida'
) ENGINE=InnoDB;

-- 2. Tabela Pai: Consoles
CREATE TABLE consoles (
    id_console INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_console VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 3. Tabela Filha com Restrições Explícitas de FK
CREATE TABLE jogos (
    id_jogo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_lanc YEAR NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    id_desenv INT UNSIGNED,
    id_console INT UNSIGNED,
    CONSTRAINT fk_desenv_jogo FOREIGN KEY (id_desenv) REFERENCES desenvolvedoras(id_desenv),
    CONSTRAINT fk_console_jogo FOREIGN KEY (id_console) REFERENCES consoles(id_console)
) ENGINE=InnoDB;
```

---

### 🧬 Desafio 2: Evolução de Esquema sem Perda de Dados (`ALTER TABLE`)

Pratique a modificação da estrutura da tabela sem precisar recriá-la:

```sql
-- Adicionar coluna de avaliação com restrição de intervalo (CHECK)
ALTER TABLE jogos 
ADD COLUMN nota_metacritic DECIMAL(3,1) CHECK (nota_metacritic BETWEEN 0 AND 10);

-- Modificar a coluna nacionalidade para suportar mais caracteres
ALTER TABLE desenvolvedoras 
MODIFY COLUMN nacionalidade VARCHAR(70) DEFAULT 'Não Informada';
```

---

### 📥 Desafio 3: Povoamento e Teste de Integridade Referencial

Insira os dados respeitando a ordem de dependência:

```sql
-- 1. Inserir pais
INSERT INTO desenvolvedoras (nome, nacionalidade) VALUES 
('Nintendo', 'Japão'),
('Sega', 'Japão'),
('Capcom', 'Japão');

INSERT INTO consoles (nome_console) VALUES 
('SNES'),
('Mega Drive'),
('Arcade');

-- 2. Inserir filhos vinculados
INSERT INTO jogos (titulo, ano_lanc, preco, id_desenv, id_console, nota_metacritic) VALUES 
('Super Mario World', 1990, 250.00, 1, 1, 9.7),
('Sonic the Hedgehog', 1991, 180.00, 2, 2, 8.8),
('Street Fighter II', 1991, 300.00, 3, 3, 9.5);
```

---

### 💥 Desafio 4: Provocações Pedagógicas e Análise de Falhas

Execute e analise com atenção os comportamentos do SGBD:

```sql
-- TESTE 1: Tentar deletar um pai com filhos vinculados
-- DELETE FROM desenvolvedoras WHERE id_desenv = 1;
-- 💥 ERRO 1451: O banco protege a integridade e impede a criação de registros órfãos!

-- TESTE 2: Diferença prática de TRUNCATE vs DELETE
CREATE TABLE jogos_backup LIKE jogos;
INSERT INTO jogos_backup SELECT * FROM jogos;

-- Limpeza rápida e reset de contador (DDL):
TRUNCATE TABLE jogos_backup;

-- Exclusão de uma linha mantendo o histórico de IDs (DML):
DELETE FROM jogos WHERE id_jogo = 2;

-- Inserir novo jogo e verificar o comportamento do AUTO_INCREMENT:
INSERT INTO jogos (titulo, ano_lanc, preco, id_desenv, id_console, nota_metacritic) 
VALUES ('Chrono Trigger', 1995, 450.00, 1, 1, 9.8);

-- O novo jogo receberá id_jogo = 4!
SELECT * FROM jogos;
```

---

## 🧰 Dicas de Bancada

*   **InnoDB vs MyISAM:** Sempre declare `ENGINE=InnoDB`. O motor padrão InnoDB é o responsável por suportar transações ACID e garantir o funcionamento real de chaves estrangeiras (`FOREIGN KEY`).
*   **Idempotência:** O uso de `DROP TABLE IF EXISTS` e `DROP DATABASE IF EXISTS` permite que o script seja reexecutado múltiplas vezes sem falhas de "objeto já existente".

Parabéns por fixar e dominar os conceitos da Aula 06! Agora estamos 100% preparados para criar os bancos dos nossos próprios Projetos Integradores! 🚀💾
