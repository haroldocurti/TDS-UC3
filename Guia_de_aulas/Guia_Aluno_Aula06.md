# Guia da Aula 06: Roteiro de Aula Prática — O Universo dos Games Retrô (DDL e DML) (04/08/2026)

Olá! Na aula passada, entendemos a jornada da modelagem (do Minimundo até a Normalização 1FN, 2FN e 3FN) e fizemos nosso primeiro acesso ao phpMyAdmin. Hoje colocaremos a mão na massa com a linguagem SQL na prática! Você vai arquitetar o banco de dados **Retro-Vault**, aplicando comandos DDL e DML, tratando chaves estrangeiras, evolução de esquemas e analisando o comportamento do banco em tempo real! 🕹️💾

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Elaborar scripts SQL de construção, inserção, alteração e manipulação (Indicador 6). |
| **Marcas Formativas** | **Visão Crítica**: Decisão sobre tipos de dados, restrições e charsets.<br>**Domínio Técnico-Científico**: Rigor na integridade referencial e sintaxe SQL. |
| **Dinâmica Metodológica** | **Ação-Reflexão-Ação**: Implementação técnica seguida de análise de impacto estrutural, integridade e performance. |

> **Marca Formativa - Visão Crítica**: Ao escolher o `utf8mb4`, você não apenas "copia um comando", mas exerce uma decisão técnica baseada na necessidade de suporte a emojis e caracteres suplementares, evitando a corrupção silenciosa de dados comum no antigo padrão `utf8` (`utf8mb3`).

---

## 2. Minimundo: O Universo dos Games Retrô (Retro-Vault)

> "Você foi designado para arquitetar o banco de dados da **Retro-Vault**, uma plataforma dedicada à preservação histórica de videogames. O desafio é organizar décadas de informações sobre consoles, estúdios lendários e os títulos que definiram gerações. A integridade desses dados é vital para que a história dos games não seja perdida em 'glitches' de bancos mal estruturados."

### Requisitos do Sistema:
* **Desenvolvedoras**: Registrar o nome do estúdio (ex: Nintendo, Sega, Capcom) e seu país de origem.
* **Consoles**: Catalogar o hardware (ex: SNES, Mega Drive, Arcade).
* **Jogos**: O centro do catálogo. Deve conter o título, ano de lançamento e o preço estimado para colecionadores. Cada jogo pertence a um console e a uma desenvolvedora.

---

## 3. Modelo Entidade-Relacionamento (DER)

A estrutura lógica do nosso universo retrô define as fronteiras e os vínculos de cada informação:

* **Entidade: Desenvolvedora** ➔ Atributos: `id_desenv` (PK), `nome`, `nacionalidade`. (1:N com Jogos)
* **Entidade: Console** ➔ Atributos: `id_console` (PK), `nome_console`. (1:N com Jogos)
* **Entidade: Jogo** ➔ Atributos: `id_jogo` (PK), `titulo`, `ano_lanc`, `preco`. Vínculos: `id_console` (FK) e `id_desenv` (FK).

```text
[ DESENVOLVEDORA ] 1 ----- N < assina > N ----- 1 [ CONSOLE ]
       |                                              |
       +------------------- 1 : N --------------------+
                              |
                           ( JOGO )
```

---

## 4. Modelo Relacional (MER) Mapeado

Nas relações físicas, as restrições de integridade (*Constraints*) conectam as chaves primárias (PK) às chaves estrangeiras (FK):
* `desenvolvedoras (id_desenv)` PK $\leftarrow$ (1:N) $\rightarrow$ `jogos (id_desenv)` FK
* `consoles (id_console)` PK $\leftarrow$ (1:N) $\rightarrow$ `jogos (id_console)` FK

---

## 5. Dicionário de Dados Técnico

| Tabela | Campo | Tipo Físico | Restrições | Comentário Pedagógico |
| --- | --- | --- | --- | --- |
| **desenvolvedoras** | `id_desenv` | `INT UNSIGNED` | PK, AUTO_INCREMENT | Identificador numérico otimizado. |
|  | `nome` | `VARCHAR(100)` | NOT NULL, UNIQUE | Garante que não existam estúdios duplicados. |
|  | `nacionalidade` | `VARCHAR(70)` | DEFAULT 'Desconhecida' | País de origem da desenvolvedora. |
| **consoles** | `id_console` | `INT UNSIGNED` | PK, AUTO_INCREMENT | Chave primária do hardware. |
|  | `nome_console` | `VARCHAR(50)` | NOT NULL | Ex: "Mega Drive", "SNES", "Arcade". |
| **jogos** | `id_jogo` | `INT UNSIGNED` | PK, AUTO_INCREMENT | Identificador único do título. |
|  | `titulo` | `VARCHAR(150)` | NOT NULL | Nome do jogo. |
|  | `ano_lanc` | `YEAR` | NOT NULL | Tipo específico para datas anuais (4 dígitos). |
|  | `preco` | `DECIMAL(10,2)` | NOT NULL | Essencial para valores monetários. O tipo FLOAT usa aproximação binária e gera erros. |
|  | `nota_metacritic` | `DECIMAL(3,1)` | CHECK (0.0 a 10.0) | Adicionado via `ALTER TABLE` no Desafio 1.1. |
|  | `id_desenv` | `INT UNSIGNED` | FK | Relacionamento com a tabela pai `desenvolvedoras`. |
|  | `id_console` | `INT UNSIGNED` | FK | Relacionamento com a tabela pai `consoles`. |

---

## 6. Roteiro de Desafios Práticos no phpMyAdmin / MySQL

Acesse a aba **SQL** do seu phpMyAdmin e execute os desafios passo a passo junto com o professor:

### 🛠️ Desafio 1: Construindo a Fundação (DDL)

```sql
-- Configuração do cliente para garantir o envio correto do conjunto de caracteres
SET NAMES utf8mb4;

-- Garantindo idempotência: reiniciando o banco para ambiente de testes
DROP DATABASE IF EXISTS db_retro_games;
CREATE DATABASE db_retro_games 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE db_retro_games;

-- Criando tabelas independentes (Tabelas Pais)
DROP TABLE IF EXISTS desenvolvedoras;
CREATE TABLE desenvolvedoras (
    id_desenv INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    nacionalidade VARCHAR(50)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS consoles;
CREATE TABLE consoles (
    id_console INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_console VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- Criando tabela dependente (Tabela Filha com Restrições de FK)
DROP TABLE IF EXISTS jogos;
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

### 🧬 Desafio 1.1: Evolução de Esquema sem Destruição (DDL - `ALTER TABLE`)

```sql
-- DDL: Adicionando nova coluna com restrição CHECK na tabela jogos
ALTER TABLE jogos 
ADD COLUMN nota_metacritic DECIMAL(3,1) CHECK (nota_metacritic BETWEEN 0 AND 10);

-- DDL: Modificando tipo/tamanho e valor padrão de uma coluna existente
ALTER TABLE desenvolvedoras 
MODIFY COLUMN nacionalidade VARCHAR(70) DEFAULT 'Desconhecida';

-- DDL: Criando e removendo uma coluna temporária para teste de manipulação de estrutura
ALTER TABLE jogos ADD COLUMN rascunho VARCHAR(10);
ALTER TABLE jogos DROP COLUMN rascunho;
```

---

### 📥 Desafio 2: Povoamento e Integridade (DML)

```sql
-- DML: Inserindo desenvolvedoras
INSERT INTO desenvolvedoras (nome, nacionalidade) VALUES 
('Nintendo', 'Japão'),
('Sega', 'Japão'),
('Capcom', 'Japão');

-- DML: Inserindo consoles
INSERT INTO consoles (nome_console) VALUES 
('SNES'),
('Mega Drive'),
('Arcade');

-- DML: Inserindo jogos vinculados aos pais
INSERT INTO jogos (titulo, ano_lanc, preco, id_desenv, id_console, nota_metacritic) VALUES 
('Super Mario World', 1990, 250.00, 1, 1, 9.7),
('Sonic the Hedgehog', 1991, 180.00, 2, 2, 8.8),
('Street Fighter II', 1991, 300.00, 3, 3, 9.5);
```

---

### 🔍 Desafio 3: Otimização e Refatoração (DQL e DDL)

```sql
-- DQL: Consulta de validação e junção dos dados das 3 tabelas
SELECT 
    j.id_jogo,
    j.titulo, 
    c.nome_console, 
    d.nome AS desenvolvedora,
    j.preco,
    j.nota_metacritic
FROM jogos j
INNER JOIN consoles c ON j.id_console = c.id_console
INNER JOIN desenvolvedoras d ON j.id_desenv = d.id_desenv;

-- DDL: Criando índice secundário para acelerar buscas frequentes no título do jogo
CREATE INDEX idx_jogos_titulo ON jogos(titulo);
```

---

### 💥 Desafio 4: Ação, Reflexão e Manutenção (DML x DDL)

```sql
-- 1. DML: Atualização direcionada
UPDATE jogos 
SET preco = 320.50 
WHERE id_jogo = 3;

-- 2. DML (Provocação Pedagógica - Teste de Integridade Referencial):
-- Execute o comando abaixo e observe o resultado no console:
-- DELETE FROM desenvolvedoras WHERE nome = 'Nintendo';
-- 💥 ERRO ESPERADO: ER 1451 (Cannot delete or update a parent row: a foreign key constraint fails)

-- 3. DDL x DML (Demonstração Prática de TRUNCATE vs DELETE):
-- Criando uma tabela clone para testes
CREATE TABLE jogos_rascunho LIKE jogos;
INSERT INTO jogos_rascunho SELECT * FROM jogos;

-- DDL: Limpeza completa da tabela clone (Reseta o AUTO_INCREMENT e limpa a estrutura rapidamente)
TRUNCATE TABLE jogos_rascunho;

-- DML: Remoção de linha única mantendo o estado da tabela original
DELETE FROM jogos WHERE id_jogo = 2;

-- Teste Final de AUTO_INCREMENT após o DELETE:
INSERT INTO jogos (titulo, ano_lanc, preco, id_desenv, id_console, nota_metacritic) 
VALUES ('Chrono Trigger', 1995, 450.00, 1, 1, 9.8);

-- Verificação: O próximo ID gerado será 4 (mantendo a lacuna do ID 2 deletado)
SELECT * FROM jogos;
```

---

## 🧰 Dicas de Bancada (Conceitos Avançados)

* **Commit Implícito**: Comandos DDL (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`) causam um *commit* automático no MySQL. Não aceitam `ROLLBACK`! Cuidado ao rodar em produção.
* **Erro 1451 (FK Constraint Fail)**: Acontece quando você tenta deletar uma desenvolvedora ou console que possui jogos vinculados a ele. A chave estrangeira impede a criação de "órfãos".
* **TRUNCATE vs DELETE**: O `TRUNCATE` é um comando DDL ultra-rápido que zera a tabela inteira e reseta o contador de `AUTO_INCREMENT`. Já o `DELETE` é um comando DML linha a linha que mantém o histórico dos IDs já utilizados.
* **Idempotência**: Usar `IF EXISTS` / `IF NOT EXISTS` garante que seu script possa ser executado múltiplas vezes sem quebrar o banco.

Excelente trabalho construindo e dominando a estrutura da Retro-Vault! 🚀🎮
