# Guia da Aula 10: Materialização Física dos Projetos Integradores — Criando as Tabelas dos Projetos no MySQL (17/08/2026)

Olá, desenvolvedor(a)! Chegamos ao momento central da nossa Unidade Curricular! Hoje conectamos toda a teoria de modelagem de dados trabalhada até aqui com os **Projetos Integradores** desenvolvidos nas aulas com o **Prof. Facine**. Cada dupla irá transformar seus diagramas (DER/MER) e o Dicionário de Dados em tabelas físicas reais no SGBD MySQL através da interface do phpMyAdmin! 🚀💾

---

## 1. Sinopse Pedagógica (UC3 - Modelar e Estruturar Banco de Dados)

| Pilares da Competência | Detalhamento Pedagógico (MPS) |
| --- | --- |
| **Elemento de Competência** | **Saber-Fazer**: Elaborar scripts SQL de construção DDL e implementar fisicamente esquemas relacionais de projetos autorais (Indicadores 1, 3, 4 e 6). |
| **Marcas Formativas** | **Domínio Técnico-Científico**: Escolha consciente dos tipos de dados, chaves primárias e integridade com chaves estrangeiras.<br>**Autonomia Digital e Atitude Profissional**: Codificação de scripts SQL idempotentes, organizados e versionados no repositório Git.<br>**Visão Crítica**: Validação de requisitos e integridade relacional frente ao escopo real do projeto. |
| **Dinâmica Metodológica** | **Aprendizagem Baseada em Projetos (PBL)**: Desenvolvimento prático em duplas dos esquemas físicos de banco de dados para os projetos de software interdisciplinares. |

---

## 2. Checklist Pré-Implementação (Do Papel para o SQL)

Antes de começar a digitar os comandos `CREATE TABLE`, valide com sua dupla os seguintes pontos:

1.  ✅ **Ordem de Criação:** Identifique quais tabelas são independentes (tabelas pais) e quais são dependentes (tabelas filhas). Crie sempre as tabelas pais primeiro!
2.  ✅ **Tipos de Dados Físicos:**
    *   IDs / Chaves Primárias: `INT UNSIGNED AUTO_INCREMENT PRIMARY KEY`
    *   Nomes / Textos curtos: `VARCHAR(100)` ou `VARCHAR(150)` (evite usar `VARCHAR(255)` indiscriminadamente)
    *   Valores Monetários / Preços: `DECIMAL(10,2)` (nunca utilize `FLOAT` ou `DOUBLE` para moeda)
    *   Datas e Horários: `DATE` (para datas simples como nascimento) ou `DATETIME` / `TIMESTAMP` (para transações e logs)
    *   Opções fixas: `ENUM('Ativo', 'Inativo')` ou tabelas de domínio
3.  ✅ **Integridade Referencial:** Garanta que toda Chave Estrangeira (`FOREIGN KEY`) aponte para uma Chave Primária existente e tenha o **mesmo tipo de dado exato** (ex: `INT UNSIGNED` com `INT UNSIGNED`).
4.  ✅ **Charset e Engine:** Utilize sempre `ENGINE=InnoDB` e `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`.

---

## 3. Estrutura Padrão do Script SQL do Projeto (`banco_projeto.sql`)

Todo script profissional deve seguir este esqueleto no seu repositório:

```sql
-- ====================================================================
-- Script DDL: Criação do Banco de Dados do Projeto Integrador
-- Dupla: [Nome Aluno 1] e [Nome Aluno 2]
-- Tema do Projeto: [Ex: Floricultura / Clínica Pet / Locadora / Biblioteca]
-- UC3 - Professor Haroldo Curti | Interdisciplinaridade: Prof. Facine
-- ====================================================================

SET NAMES utf8mb4;

-- Substitua 'db_meu_projeto' pelo nome do banco atribuído à sua dupla
DROP DATABASE IF EXISTS db_meu_projeto;
CREATE DATABASE db_meu_projeto 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE db_meu_projeto;

-- --------------------------------------------------------------------
-- 1. TABELAS INDEPENDENTES (PAIS)
-- --------------------------------------------------------------------

CREATE TABLE clientes (
    id_cliente INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categorias (
    id_categoria INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(60) NOT NULL UNIQUE,
    descricao VARCHAR(255)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 2. TABELAS DEPENDENTES (FILHAS)
-- --------------------------------------------------------------------

CREATE TABLE produtos (
    id_produto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(150) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    id_categoria INT UNSIGNED NOT NULL,
    CONSTRAINT fk_categoria_produto 
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pedidos (
    id_pedido INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('Pendente', 'Pago', 'Cancelado', 'Entregue') DEFAULT 'Pendente',
    id_cliente INT UNSIGNED NOT NULL,
    CONSTRAINT fk_cliente_pedido 
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 3. TABELA ASSOCIATIVA (N:M - ITENS DO PEDIDO)
-- --------------------------------------------------------------------

CREATE TABLE itens_pedido (
    id_pedido INT UNSIGNED NOT NULL,
    id_produto INT UNSIGNED NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE RESTRICT
) ENGINE=InnoDB;
```

---

## 4. Desafios da Aula de Hoje

### 🛠️ Desafio 1: Redação e Execução do Script DDL do seu Projeto
Escreva o arquivo `banco_projeto.sql` com todas as tabelas do seu projeto e execute-o na aba **SQL** do phpMyAdmin.

### 🔍 Desafio 2: Auditoria Visual com a Ferramenta Designer
Acesse a opção **Designer** no menu superior do seu banco de dados no phpMyAdmin. Verifique se todas as linhas de relacionamento (*foreign keys*) conectam corretamente as tabelas conforme o DER/MER planejado.

### 📥 Desafio 3: Povoamento com Dados de Teste (DML)
Insira ao menos 3 registros em cada tabela do seu banco de dados, validando que as regras de negócio, chaves estrangeiras e valores padrão funcionam perfeitamente.

### 💾 Desafio 4: Versionamento no Git/GitHub
Faça o *commit* e *push* do seu arquivo `banco_projeto.sql` no repositório oficial da sua dupla no GitHub!

---

## 🧰 Dicas de Bancada

*   **Evite loops de dependência:** Nenhuma tabela deve ter Chave Estrangeira apontando para outra que ainda não foi criada.
*   **Atenção ao `ON DELETE CASCADE`:** Use com extremo cuidado! Em tabelas financeiras ou de clientes, prefira `RESTRICT` para evitar a deleção acidental de históricos importantes.
*   **Consulte o Professor:** Se tiver dúvidas sobre a cardinalidade ou a modelagem de entidades associativas, chame o docente para validação em bancada antes de rodar o script!

Excelente trabalho materializando a persistência de dados do seu Projeto Integrador! 🌟🚀
