# Guia da Aula 04: Validação do DER, MER e Dicionário de Dados da UC1 (27/07/2026)

Olá! Na UC1, com outro docente, vocês iniciaram a jornada de modelagem criando os primeiros diagramas e especificações do sistema. Na aula passada da UC3, homologamos o texto final do Minimundo no GitHub. Hoje faremos uma auditoria técnica completa para alinhar tudo o que foi desenhado na UC1 com o escopo atual, deixando a documentação 100% pronta para virar banco de dados no MySQL! 📐📄

---

## 🎯 Objetivos da Aula
O objetivo de hoje é revisar e validar a documentação de modelagem do seu Projeto Integrador (DER, MER e Dicionário de Dados). Sua dupla garantirá que os diagramas atendam às regras de normalização, que as chaves primárias e estrangeiras estejam corretamente mapeadas e que os tipos de dados estejam definidos antes de passarmos para a fase prática no MySQL.

---

## 🧠 Competências Mobilizadas

### 📊 Indicadores (O que estamos avaliando)
- **1.** Levanta requisitos e coleta informações de suporte do processo inicial de modelagem de banco de dados, de acordo com exigências do projeto de software.
- **3.** Constrói diagramas de dados aferindo a modelagem e estrutura do banco de dados, de acordo com as especificações técnicas.
- **4.** Aplica técnicas de Normalização de Tabelas, considerando os dados a serem armazenados.

### 📚 Conhecimentos (O que você vai aprender)
- Validação de coerência entre Minimundo (texto), DER (conceitual) e MER (lógico).
- Aplicação prática de Normalização de Dados (1FN, 2FN, 3FN) para eliminar redundâncias e anomalias.
- Estruturação detalhada do Dicionário de Dados (definição de tipos SQL, tamanhos, nulabilidade e chaves).

### 🛠️ Habilidades (O que você vai colocar em prática)
- Auditarem e corrigirem inconsistências nos diagramas criados na UC1.
- Padronizar nomes de tabelas e colunas em `snake_case` (ex: `data_nascimento`, `valor_total`).
- Formatar e versionar o Dicionário de Dados no repositório do projeto no GitHub.

### 🤝 Atitudes e Valores (Como vamos nos portar)
- **Domínio Técnico-Científico:** Aplicar conceitos precisos de tipos de dados e integridade referencial.
- **Visão Crítica:** Identificar furos na modelagem conceitual antes de transformá-la em código físico.
- **Colaboração e Comunicação:** Trabalhar em dupla para revisar e homologar as regras do banco com o professor.

---

## 🚀 Passo a Passo da Missão de Hoje

### Missão 1: Resgate do Acervo da UC1 📁
1. Reúna-se com sua dupla e resgate todos os arquivos de modelagem criados na UC1:
   - Diagramas DER/MER (brModel, draw.io, Lucidchart ou fotos).
   - Rascunhos de tabelas e dicionário de dados.
2. Abra em paralelo o arquivo `minimundo.md` homologado no repositório GitHub do seu projeto na Aula 03.

### Missão 2: Checklist de Auditagem da Modelagem 🔍
Revisem os diagramas respondendo às seguintes perguntas:
1. **Entidades & Tabelas:** Todas as entidades descritas no Minimundo possuem uma tabela correspondente?
2. **Chaves Primárias (PK):** Toda tabela possui uma Chave Primária única identificada? (Ex: `id` ou `id_cliente`).
3. **Relacionamentos (1:N e N:N):**
   - Nos relacionamentos 1:N, a Chave Estrangeira (FK) está na tabela do lado N?
   - Se houver relacionamento N:N (Muitos para Muitos), vocês criaram a tabela intermediária/associativa? (Ex: `pedidos_produtos`).
4. **Normalização:** Não há listas de itens repetidos em uma mesma coluna? Todas as colunas dependem exclusivamente da Chave Primária?

### Missão 3: Padronização e Refinamento do Dicionário de Dados 🛠️
Construam ou atualizem a tabela do Dicionário de Dados da sua equipe seguindo o padrão abaixo:

#### Exemplo de Tabela: `clientes`
| Nome da Coluna | Tipo de Dado | Tamanho | Requerido (NOT NULL) | Chave (PK/FK) | Descrição |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `id` | `INT` | - | SIM | `PK` | Identificador único do cliente |
| `nome` | `VARCHAR` | 100 | SIM | - | Nome completo do cliente |
| `email` | `VARCHAR` | 100 | SIM (`UNIQUE`) | - | E-mail de login |
| `cpf` | `CHAR` | 11 | SIM (`UNIQUE`) | - | CPF (apenas números) |
| `data_cadastro` | `DATETIME` | - | SIM | - | Data e hora do cadastro |

### Missão 4: Homologação com o Professor 👨‍🏫
Apresentem a versão revisada do Dicionário de Dados ao professor. Após a validação e o "de acordo" do docente, a modelagem estará homologada e liberada para virar banco de dados no MySQL!

### Missão 5: Versionamento no GitHub 🐙
1. Crie ou atualize um arquivo chamado `dicionario_dados.md` (ou insira dentro da pasta `docs/`) no repositório da sua dupla.
2. Faça o **Commit** e o **Push** das alterações:
   ```bash
   git add .
   git commit -m "atualiza e valida dicionario de dados e modelagem da UC1"
   git push origin main
   ```

---

## 🧰 Guia de Sobrevivência (Tipos de Dados Essenciais)

| Tipo SQL | Quando utilizar? | Exemplo |
| :--- | :--- | :--- |
| `INT` | Números inteiros (IDs, quantidades, anos). | `id INT`, `quantidade INT` |
| `VARCHAR(N)` | Textos de tamanho variável até N caracteres (nomes, e-mails, endereços). | `nome VARCHAR(100)` |
| `CHAR(N)` | Textos de tamanho fixo sempre com N caracteres (UF, CPF sem máscara). | `uf CHAR(2)`, `cpf CHAR(11)` |
| `DECIMAL(M,D)` | Valores monetários ou decimais precisos (M = total de dígitos, D = casas decimais). | `preco DECIMAL(10,2)` |
| `DATE` | Apenas data (Ano-Mês-Dia). | `data_nascimento DATE` |
| `DATETIME` | Data e hora completas. | `criado_em DATETIME` |
| `BOOLEAN` | Valores lógicos de Verdadeiro/Falso (1 ou 0). | `ativo BOOLEAN` |

Parabéns! Com o Dicionário de Dados validado, seu projeto está pronto para a camada prática de banco de dados no MySQL! 🚀
