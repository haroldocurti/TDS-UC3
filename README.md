# Unidade Curricular 3 (UC3): Modelar e Estruturar Banco de Dados

Esta Unidade Curricular (UC) foca no desenvolvimento da capacidade do futuro Técnico em Desenvolvimento de Sistemas de projetar, modelar e estruturar bancos de dados relacionais que atendam aos requisitos de sistemas de software. Os alunos aprenderão a traduzir regras de negócios em diagramas de dados (DER/MER), aplicar técnicas de normalização e construir bancos de dados relacionais utilizando a linguagem SQL para a criação e manipulação dos dados.

**Carga Horária Total:** 60 horas  
**Curso:** Técnico em Desenvolvimento de Sistemas — Senac

---

## 📁 Estrutura do Repositório

Neste repositório você encontrará todos os materiais pedagógicos e guias de acompanhamento da UC3:

* **[Guia_de_aulas/](Guia_de_aulas/)**: Roteiros das aulas práticas e teóricas, contendo objetivos, competências mobilizadas, instruções passo a passo e desafios.
* **[Biblioteca/](Biblioteca/)**: Acervo de materiais complementares em PDF, áudios, vídeos e infográficos explicativos para aprofundamento nos tópicos da disciplina.

---

## 📅 Histórico e Guias das Aulas

Acompanhe os guias detalhados de cada encontro da UC3:

- **[Aula 01 (08/06/2026)](Guia_de_aulas/Guia_Aluno_Aula01.html): Introdução a Bancos de Dados**  
  Diferenciação de dados e informações, volatilidade da memória RAM vs. persistência física, o papel dos SGBDs e a dinâmica lúdica *"Stop dos Dados"* comparando bancos SQL e NoSQL.

- **[Aula 02 (22/06/2026)](Guia_de_aulas/Guia_Aluno_Aula02.html): Levantamento de Requisitos e o Minimundo**  
  Conceitos de escopo em linguagem natural, aplicação de perguntas guia de investigação e simulação de requisitos através de role-play e prompts de IA.

- **[Aula 03 (29/06/2026)](Guia_de_aulas/Guia_Aluno_Aula03.html): Escrita do Minimundo, GitHub e Homologação de Requisitos**  
  Redação formal e versionamento do `minimundo.md` no GitHub, realização de auditoria cruzada por pares (*Peer Review*) e tratamento de lacunas de escopo via GitHub Issues.

- **[Aula 04 (27/07/2026)](Guia_de_aulas/Guia_Aluno_Aula04.html): Validação do DER, MER e Dicionário de Dados**  
  Revisão e auditoria técnica da documentação de modelagem iniciada na UC1. Alinhamento de regras de normalização, verificação de chaves primárias e estrangeiras e especificação do Dicionário de Dados.

- **[Aula 05 (03/08/2026)](Guia_de_aulas/Guia_Aluno_Aula05.html): Do Minimundo à Normalização e Primeiro Acesso ao phpMyAdmin**  
  Pipeline da engenharia de dados, aplicação prática das Formas Normais (**1FN, 2FN e 3FN**) para eliminação de redundâncias e navegação inicial na interface do phpMyAdmin.

- **[Aula 06 (04/08/2026)](Guia_de_aulas/Guia_Aluno_Aula06.html): Roteiro Prático de SQL — O Universo dos Games Retrô (DDL e DML)**  
  Construção e manipulação na prática do banco de dados *Retro-Vault*. Aplicação de comandos DDL (`CREATE`, `ALTER`), DML (`INSERT`, `UPDATE`), chaves estrangeiras (`FOREIGN KEY`) e escolha estratégica de charset (`utf8mb4`).

- **[Aula 08 (10/08/2026)](Guia_de_aulas/Guia_Aluno_Aula08.html): Oficina Prática de Estruturação e Manipulação em MySQL (DDL e DML)**  
  Criação de esquemas relacionais, gestão de constraints e chaves estrangeiras, evolução com `ALTER TABLE` e operações de carga e manutenção com `INSERT`, `UPDATE`, `DELETE` e `TRUNCATE`.

- **[Aula 09 (11/08/2026)](Guia_de_aulas/Guia_Aluno_Aula09.html): Retomada Prática e Fixação dos Conceitos da Aula 06**  
  Nivelamento e consolidação de bancada sobre criação de tabelas pai e filha, chaves estrangeiras (`FOREIGN KEY`), evolução de esquema (`ALTER TABLE`), simulação de violação de integridade referencial (Erro 1451) e comparação entre `TRUNCATE` e `DELETE`.

- **[Aula 10 (17/08/2026)](Guia_de_aulas/Guia_Aluno_Aula10.html): Materialização Física dos Projetos Integradores — Criando as Tabelas dos Projetos no MySQL**  
  Criação física das bases de dados e execução dos scripts DDL com as tabelas, tipos de dados e constraints dos Projetos Integradores desenvolvidos nas aulas do Prof. Facine.

- **[Aula 11 (18/08/2026)](Guia_de_aulas/Guia_Aluno_Aula11.html): Consultas Relacionais em SQL (DQL) e Análise de Dados — Estudo de Caso TechStore Brasil**  
  Recuperação com `SELECT`/`FROM`/`WHERE`, filtros avançados (`BETWEEN`, `IN`, `LIKE`), ordenação e limites (`ORDER BY`, `LIMIT`), funções de agregação (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), agrupamentos e filtros de grupos (`GROUP BY`, `HAVING`), junções relacionais (`INNER JOIN`, `LEFT JOIN` com `IS NULL`) e resolução de 15 chamados corporativos no estudo de caso *TechStore Brasil*.

- **[Aula 14 (31/08/2026)](Guia_de_aulas/Guia_Aluno_Aula14.html): Visões Relacionais (Views), Consultas Aninhadas e Gestão de Dados**  
  Camada de abstração com visões relacionais (`CREATE OR REPLACE VIEW`), segurança de dados / conformidade LGPD, visões operacionais de faturamento e estoque, além de rotinas operacionais de exportação, importação e backup (Indicador 7).

---

## 📚 Biblioteca de Apoio e Materiais Complementares

Consulte os arquivos na pasta **[Biblioteca/](Biblioteca/)** para aprofundar seu conhecimento:

| Arquivo | Formato | Descrição |
| --- | --- | --- |
| `loja_teste_completo.sql` | Script SQL | Script consolidado (DDL + DML) do banco de dados `loja_teste` da TechStore Brasil (clientes, produtos, pedidos e itens). |
| [Guia_Completo_Normalizacao_1FN_a_5FN.html](Biblioteca/Guia_Completo_Normalizacao_1FN_a_5FN.html) | Guia HTML Interativo | Manual definitivo de Normalização: 1FN, 2FN, 3FN, BCNF, 4FN, 5FN, anomalias e checklists. |
| [Guia_Completo_Chaves_Banco_de_Dados.html](Biblioteca/Guia_Completo_Chaves_Banco_de_Dados.html) | Guia HTML Interativo | Manual definitivo sobre Chaves Relacionais: Superchaves, Candidatas, PKs, AKs, FKs, Compostas, Conjugadas, Substitutas e Naturais. |
| `Comandos DDL do MySQL.pdf` | Documento PDF | Guia de referência rápida para comandos de definição de dados (`CREATE`, `ALTER`, `DROP`). |
| `Comandos DML em MySQL.pdf` | Documento PDF | Manual prático para inserção, atualização e consulta de dados (`INSERT`, `UPDATE`, `DELETE`, `SELECT`). |
| `Constraints de Tabela no MySQL_ Funções e Exemplos.pdf` | Documento PDF | Explicação sobre restrições de integridade (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`). |
| `Guia de Elaboração de Minimundo_.pdf` | Documento PDF | Orientações detalhadas para delimitação e escrita de escopos de sistemas (Minimundo). |
| `MER_para_DDL.pdf` | Documento PDF | Passo a passo técnico para traduzir o Modelo Entidade-Relacionamento em scripts SQL DDL. |
| `minimundo_ate_normalizacao.pdf` | Documento PDF | Resumo ilustrado da trajetória do levantamento de requisitos até a 3ª Forma Normal. |
| `Da_Modelagem_Lógica_ao_MySQL_Físico.m4a` | Áudio (Podclass) | Explicação narrada sobre a transição entre modelagem conceitual/lógica e o banco de dados MySQL físico. |
| `O_Dicionário_de_Dados_schemas_SQL.mp4` | Vídeo Explicativo | Demonstração sobre a importância e estrutura do Dicionário de Dados e Schemas no SQL. |
| `Comparação_entre_utf8_e_utf8mb4.png` | Infográfico | Comparativo detalhado entre os conjuntos de caracteres `utf8` e `utf8mb4` e seu suporte a emojis e símbolos suplementares. |

---

## 🎯 Indicadores de Competência
Estes são os critérios observáveis que atestam o domínio da competência pelos alunos:

1. **Levanta requisitos e coleta informações** de suporte do processo inicial de modelagem de banco de dados, de acordo com exigências do projeto de software.
2. **Realiza a instalação e configuração** de software, de acordo com especificações técnicas.
3. **Constrói diagramas de dados** aferindo a modelagem e estrutura do banco de dados, de acordo com as especificações técnicas.
4. **Aplica técnicas de Normalização de Tabelas**, considerando os dados a serem armazenados.
5. **Realiza a instalação e configuração** de sistema gerenciador de banco de dados (SGBD), de acordo com especificações técnicas.
6. **Elabora scripts SQL** de construção, inserção e manipulação dos dados conforme especificação técnica da linguagem SQL.
7. **Realiza importação e exportação** de dados, conforme regras do sistema gerenciador de banco de dados (SGBD).

---

## 🧠 C.H.A.V.s (Conhecimentos, Habilidades, Atitudes e Valores)

### 📚 Conhecimentos (Saber)
- **Modelo Relacional de Bancos de Dados:** fundamentos e conceitos.
- **Modelagem Banco de Dados:** levantamento de dados e especificação de requisitos. Diagrama Entidade-Relacionamento. Dicionário de dados. Integridade referencial. Arquitetura de arquivos de dados. Teoria dos conjuntos.
- **Estruturação de Dados:** Tipos de dados. Cardinalidade, normalização, entidade, visão, atributos, índices, chave candidata, chave primária e estrangeira, relacionamentos e integridade referencial.
- **Banco de dados relacional (Linguagem SQL):** histórico, definições, aplicabilidade, instruções e ferramentas.
- **Operações em SQL:** Criação, manipulação, ordenação, listagens e operações em consultas e subconsultas SQL; datas; união, intersecção e junção de dados; entidade, views, atributos, chave candidata, chave primária, chave estrangeira, relacionamentos e integridade referencial; importação e exportação de dados.

### 🛠️ Habilidades (Saber Fazer)
- Organizar arquivos.
- Identificar arquitetura de banco de dados.
- Aplicar comandos em SQL.
- Criar diagramas técnicos.
- Criar a documentação do projeto.
- Utilizar termos técnicos nas rotinas de trabalho.

### 🤝 Atitudes e Valores (Saber Ser / Conviver)
- Cordialidade no trato com as pessoas.
- Sigilo no tratamento de dados e informações.
- Proatividade na resolução de problemas.
- Flexibilidade nas diversas situações de trabalho.

---

## 💡 Orientações aos Alunos

1. **Foco Prático:** Utilize o repositório como guia durante as aulas no laboratório e para revisão individual.
2. **Execução de Scripts:** Ao rodar scripts SQL das aulas no phpMyAdmin ou MySQL Workbench, certifique-se de selecionar sua base de dados individual atribuída.
3. **Dúvidas e Sugestões:** Sinta-se à vontade para utilizar as *Issues* do GitHub ou entrar em contato com o docente para tirar dúvidas de modelagem e SQL.

