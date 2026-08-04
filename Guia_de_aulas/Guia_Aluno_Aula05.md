# Guia da Aula 05: Do Minimundo à Normalização e Primeiro Acesso ao phpMyAdmin (03/08/2026)

Olá! Nas aulas anteriores, nós acompanhamos o nascimento da estrutura de dados do seu projeto. Hoje vamos entender como garantir que essa estrutura seja sólida e livre de redundâncias através das **Regras de Normalização (1FN, 2FN e 3FN)**. No segundo bloco da aula, daremos o primeiro passo prático no ambiente MySQL acessando a interface gráfica do **phpMyAdmin** com seu usuário individual! 🚀

---

## 🎯 Objetivos da Aula
Nesta aula, você compreenderá a trajetória completa da engenharia de dados (do Minimundo ao Dicionário de Dados), aprenderá o controle de qualidade da informação através da 1ª, 2ª e 3ª Formas Normais e realizará seu primeiro login no phpMyAdmin para explorar a interface de gestão de bancos de dados.

---

## 🧠 Competências Mobilizadas

### 📊 Indicadores (O que estamos avaliando)
- **3.** Constrói diagramas de dados aferindo a modelagem e estrutura do banco de dados, de acordo com as especificações técnicas.
- **4.** Aplica técnicas de Normalização de Tabelas, considerando os dados a serem armazenados.
- **5.** Realiza a instalação e configuração de sistema gerenciador de banco de dados (SGBD), de acordo com especificações técnicas.

### 📚 Conhecimentos (O que você vai aprender)
- O Pipeline da Modelagem Relacional (Minimundo ➔ DER ➔ MER ➔ Dicionário de Dados ➔ Normalização).
- As três Formas Normais fundamentais:
  - **1FN (Atomicidade):** Fim dos campos multivalorados na mesma célula.
  - **2FN (Dependência Total da Chave):** Dependência de toda a chave primária composta.
  - **3FN (Dependência Transitiva):** Atributos não-chave dependendo exclusivamente da Chave Primária.
- Apresentação e navegação no painel de controle do **phpMyAdmin**.

### 🛠️ Habilidades (O que você vai colocar em prática)
- Avaliar e refinar tabelas aplicando os critérios das Formas Normais.
- Acessar o ambiente phpMyAdmin via navegador usando seu usuário e senha individuais.
- Navegar nas abas da interface (Estrutura, SQL, Pesquisar, Exportar, Importar) e executar testes básicos de conexão.

### 🤝 Atitudes e Valores (Como vamos nos portar)
- **Domínio Técnico-Científico:** Compreender a fundamentação teórica que impede falhas e inconsistências no banco de dados.
- **Visão Crítica:** Identificar anomalias de atualização, inserção e exclusão antes de criar tabelas físicas.
- **Autonomia Digital:** Realizar o login individual e explorar com segurança o ambiente web do phpMyAdmin.

---

## 🚀 Passo a Passo da Missão de Hoje

### Missão 1: O Pipeline da Modelagem Relacional 🗺️
Antes de ir para a prática no computador, revisamos a jornada que um dado percorre até virar banco:
1. **Minimundo:** A descrição da regra do negócio em texto simples.
2. **DER (Modelo Conceitual):** A visão de negócio com Entidades, Atributos e Relacionamentos.
3. **MER (Modelo Lógico):** A visão de tecnologia com Tabelas, Colunas, PKs e FKs.
4. **Dicionário de Dados:** O contrato técnico com os tipos SQL, tamanhos e restrições.
5. **Normalização:** O controle de qualidade que blinda a estrutura contra dados duplicados.

---

### Missão 2: Dominando as Regras de Normalização ⚖️

#### 1️⃣ Primeira Forma Normal (1FN) — Atomicidade
> *Cada célula de uma tabela deve conter apenas **um único valor indivisível (atômico)**.*
* **O Problema:** Uma coluna `telefones` contendo `"(11) 9999-9999, (11) 8888-8888"` na mesma linha.
* **A Solução:** Extrair os telefones e criar linhas separadas (ou uma tabela separada de telefones vinculada ao id do cliente).

#### 2️⃣ Segunda Forma Normal (2FN) — Dependência Total da Chave
> *Exige a 1FN. Todo atributo não-chave deve depender da **chave primária inteira**, e não de apenas uma parte dela (em PKs compostas).*
* **O Problema:** Na tabela `ITENS_PEDIDO` (com PK composta por `id_pedido` + `id_produto`), ter a coluna `nome_produto`. O nome depende apenas do produto, não do pedido!
* **A Solução:** Segregar os dados do produto para a tabela `PRODUTO`.

#### 3️⃣ Terceira Forma Normal (3FN) — Fim das Dependências Transitivas
> *Exige a 2FN. Nenhum atributo não-chave pode depender de outro atributo não-chave.*
* **O Problema:** Na tabela `CLIENTE`, ter `cep`, `cidade` e `estado`. A cidade e o estado dependem do CEP, e não diretamente do cliente!
* **A Solução:** Isolar o endereço em uma tabela de referência `ENDERECO` vinculada pelo `cep`.

---

### Missão 3: Primeiro Acesso ao phpMyAdmin 🌐 *(Após o Intervalo)*

1. **Acessando a Aplicação:**
   - Abra o navegador web no seu computador.
   - Digite o endereço do phpMyAdmin informado pelo professor na sala de aula.

2. **Realizando o Login Individual:**
   - **Usuário:** *Seu usuário individual fornecido pelo docente.*
   - **Senha:** *Sua senha de acesso.*
   - Observe no painel esquerdo que o seu banco de dados pessoal já está pré-criado e pronto para uso!

3. **Explorando a Interface do phpMyAdmin:**
   - **Aba Estrutura:** Onde visualizamos as tabelas e suas colunas graficamente.
   - **Aba SQL:** Onde podemos digitar e executar comandos SQL manuais.
   - **Abas Exportar/Importar:** Onde geramos e restauramos backups de scripts `.sql`.

4. **Testando a Conexão:**
   - Clique no seu banco no painel esquerdo.
   - Abra a aba **SQL**, digite um teste simples fornecido pelo professor e clique em **Executar** para confirmar a resposta ativa do servidor MySQL!

> **Nota:** A escrita aprofundada de scripts SQL (criação de tabelas com `CREATE TABLE`, inserção com `INSERT` e consultas com `SELECT`) será realizada na **Aula 06**. Hoje o foco foi validar seu acesso e familiarizar-se com a interface gráfica!

---

## 🧰 Guia de Sobrevivência (Conceitos-Chave)

| Termo | O que significa na prática? |
| :--- | :--- |
| **Normalização** | Técnica de organização de dados para reduzir a redundância e melhorar a integridade. |
| **1FN** | Regra que garante células atômicas (sem múltiplos valores em uma mesma coluna). |
| **2FN** | Regra que garante que colunas dependam de TODA a chave primária (elimina dependência parcial). |
| **3FN** | Regra que impede que colunas não-chave dependam de outras colunas não-chave (elimina dependência transitiva). |
| **phpMyAdmin** | Interface gráfica web usada para administrar o servidor MySQL de forma amigável. |
| **Aba SQL** | Espaço dentro do phpMyAdmin onde os comandos e scripts de banco de dados são executados. |

Parabéns pelo primeiro acesso ao phpMyAdmin! Na próxima aula colocaremos a mão na massa com scripts SQL completos! 🚀
