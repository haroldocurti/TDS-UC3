# Guia da Aula 01: Introdução a Bancos de Dados (08/06/2026)

Bem-vindos e bem-vindas à **UC3: Modelar e estruturar banco de dados**! 🎉

Hoje iniciamos uma jornada fundamental no desenvolvimento de sistemas. Todo grande software que você conhece — como Instagram, Spotify, Netflix ou o sistema de um grande banco — depende de uma coisa essencial: guardar dados de forma segura, estruturada e rápida. 

Mas antes de sairmos criando tabelas ou programando, precisamos dar um passo atrás e responder: **O que são dados e por que inventamos os bancos de dados?**

---

## 🎯 Objetivos da Aula
Neste primeiro encontro, vamos diferenciar dados de informações, entender por que a memória do computador não é suficiente para guardar tudo (volatilidade vs. persistência) e participar de um jogo dinâmico — o **"Stop dos Dados"** — para mapear as primeiras diferenças entre bancos relacionais (SQL) e não-relacionais (NoSQL).

---

## 🧠 Competências Mobilizadas

### 📊 Indicadores (O que estamos avaliando)
- **1.** Levanta requisitos e coleta informações de suporte do processo inicial de modelagem de banco de dados, de acordo com exigências do projeto de software.

### 📚 Conhecimentos (O que você vai aprender)
- A diferença conceitual entre Dado e Informação.
- O conceito de Memória Volátil (RAM) e Persistência de Dados (Gravação Física).
- O propósito e os problemas resolvidos por um SGBD (Sistema Gerenciador de Banco de Dados).
- Introdução aos conceitos de Bancos de Dados SQL (Relacionais) e NoSQL (Não-Relacionais).

### 🛠️ Habilidades (O que você vai colocar em prática)
- Categorizar elementos em entidades, atributos e tipos de dados.
- Diferenciar SGBDs reais do mercado entre as categorias SQL e NoSQL.
- Trabalhar de forma colaborativa para estruturar conjuntos de dados baseados em critérios lógicos.

### 🤝 Atitudes e Valores (Como vamos nos portar)
- **Colaboração e Comunicação:** Atuar em equipe para resolver desafios sob pressão de tempo de forma coordenada.
- **Autonomia Digital:** Buscar ativamente termos técnicos e conceitos de armazenamento em fontes de pesquisa.
- **Visão Crítica:** Analisar o cenário de um sistema simples e apontar por que arquivos de texto comuns não bastam para sistemas reais.

---

## 🚀 Passo a Passo da Missão de Hoje

### Missão 1: O Enigma do "42" 🕵️‍♂️ (Dados vs. Informação)
Você verá no quadro alguns valores soltos (ex: `42`, `F`, `São Paulo`). 
1. Reflita com seus colegas: o que esses valores significam para vocês nesse exato momento?
2. Observe o que acontece quando adicionamos rótulos como `Idade: 42`, `Sexo: F` ou `Local do Evento: São Paulo`.
3. Discuta com a turma a diferença prática entre um **Dado** (elemento bruto, cru) e uma **Informação** (o dado contextualizado e útil).

### Missão 2: O Desafio da Persistência 💾 (RAM vs. Disco)
O professor mostrará um programa simples que aceita entradas de teclado e guarda em uma lista na memória do computador.
1. Observe o que acontece quando o programa é reiniciado. Onde estavam guardadas aquelas informações?
2. Compreenda o conceito de **Volatilidade** (dados guardados temporariamente na memória RAM) e a necessidade de **Persistência** (dados guardados permanentemente no disco rígido/SSD).
3. Pense: *se pudermos salvar tudo em arquivos de texto comuns (.txt ou .json), por que precisamos de softwares específicos de Banco de Dados?* Pense em problemas como 1000 pessoas tentando ler e escrever no mesmo arquivo ao mesmo tempo.

### Missão 3: Jogo "Stop dos Dados"! 🎮 (SQL vs. NoSQL)
Para consolidar os primeiros conceitos de modelagem e conhecer os tipos de bancos de dados existentes, faremos um jogo baseado no clássico "Stop" (Adedanha).

#### Como jogar:
1. Reúna-se com seu grupo (3 a 4 integrantes).
2. Vocês receberão uma folha ou link de planilha com as seguintes colunas:
   - **Letra:** Sorteada pelo professor.
   - **Entidade:** O "objeto" do mundo real que queremos mapear (Ex: **C**liente, **C**arro, **C**achorro).
   - **Atributo:** Uma característica dessa entidade (Ex: **C**pf, **C**or, **C**omprimento).
   - **Tipo de Dado:** Como o computador armazena isso (Ex: **C**har, **C**haracter).
   - **Banco SQL (Relacional):** Nome de um SGBD relacional conhecido (Ex: **C**loud SQL ou algum outro que comece com a letra sorteada).
   - **Banco NoSQL (Não-Relacional):** Nome de um SGBD não-relacional conhecido (Ex: **C**assandra, **C**ouchDB).
3. Quando o professor disser a letra, pesquisem e preencham a linha o mais rápido possível.
4. O primeiro grupo a terminar grita **"STOP!"**. Todos param de preencher imediatamente.
5. Faremos a correção no quadro. Aproveite para entender por que cada banco de dados pertence à sua respectiva categoria (SQL vs. NoSQL).

---

## 🧰 Guia de Sobrevivência (Conceitos-Chave)

| Termo | Significado Rápido | Exemplo Prático |
| :--- | :--- | :--- |
| **Dado** | Item bruto, isolado e sem contexto. | `1500` |
| **Informação** | Dado organizado que possui significado e utilidade. | `Preço do produto: R$ 1500,00` |
| **Volatilidade** | Perda de dados quando o sistema é desligado ou reiniciado. | Vetor na memória RAM do Node.js. |
| **Persistência** | Armazenamento estável de dados no disco físico. | Gravar dados em um arquivo ou banco. |
| **Entidade** | Representação de algo do mundo real no banco. | Tabela `Alunos` ou Coleção `Clientes`. |
| **Atributo** | Características ou campos de uma entidade. | `nome`, `email`, `data_nascimento`. |
| **Banco SQL** | Banco relacional clássico, estruturado em tabelas rígidas. | MySQL, PostgreSQL, Oracle, SQLite. |
| **Banco NoSQL** | Banco flexível, estruturado em documentos, grafos ou chave-valor. | MongoDB, Redis, Cassandra, Firebase. |

Bom jogo e boa imersão no universo dos dados! 🚀
