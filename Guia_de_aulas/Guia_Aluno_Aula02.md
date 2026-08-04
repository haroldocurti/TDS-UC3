# Guia da Aula 02: Levantamento de Requisitos e o Minimundo (22/06/2026)

Bem-vindos e bem-vindas de volta! Prontos para iniciar o nosso projeto prático? 🚀

Hoje daremos o ponto de partida do banco de dados que vocês construirão do início ao fim desta unidade. Antes de criar qualquer tabela, precisamos entender as necessidades de quem nos contratou. Como analistas de sistemas, nossa missão hoje é entrevistar o cliente e descrever o funcionamento do negócio no que chamamos de **Minimundo**.

---

## 🎯 Objetivos da Aula
Neste encontro, você vai aprender a recortar a realidade de um negócio para delimitar o que fará parte do seu banco de dados, entender a importância de documentar requisitos sem termos técnicos (a "Regra de Ouro") e realizar uma simulação de entrevista (usando Role-play ou Inteligência Artificial) para estruturar o rascunho inicial do seu Minimundo.

---

## 🧠 Competências Mobilizadas

### 📊 Indicadores (O que estamos avaliando)
- **1.** Levanta requisitos e coleta informações de suporte do processo inicial de modelagem de banco de dados, de acordo com exigências do projeto de software.

### 📚 Conhecimentos (O que você vai aprender)
- O conceito de Minimundo e delimitação de escopo de sistemas.
- Metodologia de levantamento de requisitos usando perguntas guia.
- Diferenciação entre regras de negócio reais e termos computacionais (visão funcional).

### 🛠️ Habilidades (O que você vai colocar em prática)
- Identificar elementos organizacionais de negócios (atores, atributos, ações e limites).
- Entrevistar um cliente para mapear o fluxo de funcionamento de uma empresa.
- Redigir uma especificação de requisitos em linguagem natural clara e objetiva.

### 🤝 Atitudes e Valores (Como vamos nos portar)
- **Colaboração e Comunicação:** Atuar em dupla com empatia para entrevistar o cliente e redigir o documento conjuntamente.
- **Autonomia Digital:** Interagir estrategicamente com ferramentas de Inteligência Artificial generativa configuradas como clientes.
- **Visão Crítica:** Aplicar filtros para distinguir dados essenciais para o sistema de dados irrelevantes para o negócio.

---

## 🚀 Passo a Passo da Missão de Hoje

### Missão 1: Entender a Regra de Ouro do Minimundo 🌍
1. Compreenda que o Minimundo é uma descrição textual resumida da realidade de uma empresa.
2. Siga a **Regra de Ouro**: **NÃO use jargões técnicos de banco de dados** (esqueça tabelas, chaves primárias, atributos, cardinalidade). 
3. O texto final deve ser tão natural que o próprio cliente possa ler e dizer: *"Perfeito, é exatamente assim que meu negócio funciona!"*.

### Missão 2: O Roteiro de Investigação ❓
Use as **Perguntas Guia** fornecidas pelo professor para conduzir a entrevista:
*   **Contextualização:** Qual o problema central que a empresa quer resolver com este sistema?
*   **Atores e Elementos:** Quem (pessoas) ou o que (objetos, eventos) participam do negócio?
*   **Atributos:** Quais informações desses elementos precisamos registrar? (Ex: CPF, nome, placa).
*   **Filtro de Relevância:** O que não precisamos registrar no sistema? (Ex: a cor favorita do cliente).
*   **Regras de Negócio:** Como os atores e objetos interagem? (Ex: *"o médico receita medicamentos"*).
*   **Limites (Escopo):** Quantidades e limites das interações. (Ex: *"um cliente pode comprar muitos produtos?"*).

### Missão 3: Formação de Duplas e Escolha do Tema 👥
1. Junte-se a um colega para formar sua **dupla de projeto** para a UC3.
2. Escolham um tema prático de negócio (Ex: Pet Shop, E-commerce, Locadora de Carros, Restaurante, Academia).

### Missão 4: Simulação de Entrevista (Role-play ou IA) 🎭
Conduzam a entrevista com o cliente para extrair todas as informações de requisitos do tema escolhido. Escolham um formato:
*   **Opção A (Role-play):** O professor ou um colega de outra dupla atuará como o cliente (dono do negócio). Façam as perguntas guia e anotem tudo.
*   **Opção B (Cliente de IA):** Usem uma ferramenta de IA generativa (ChatGPT, Gemini, etc.) e copiem um dos prompts prontos do arquivo [Prompts_Clientes_IA.md](Prompts_Clientes_IA.md). Conversem com a IA interpretando o papel de analistas profissionais.

### Missão 5: O Primeiro Rascunho 📝
Escrevam a primeira versão em linguagem natural do seu Minimundo com base nas anotações da entrevista. Guardem esse texto, pois ele será essencial na próxima aula!

---

## 🧰 Guia de Sobrevivência (Conceitos-Chave)

| Termo | O que significa na prática? | Exemplo |
| :--- | :--- | :--- |
| **Minimundo** | Recorte escrito em linguagem natural que descreve o escopo do banco de dados. | O texto descritivo do sistema de aluguel de carros. |
| **Requisitos** | Condições ou necessidades que o sistema deve atender. | "O sistema deve registrar a quilometragem do veículo." |
| **Regras de Negócio** | Declarações que definem ou restringem ações e comportamentos do negócio. | "Um cliente só pode alugar um carro se apresentar a CNH válida." |
| **Atores** | Pessoas ou sistemas que realizam ações descritas no Minimundo. | `Clientes`, `Vendedores`, `Veterinários`. |
| **Atributos de Negócio** | Características dos atores ou elementos que precisam ser armazenadas. | `CPF`, `CNH`, `E-mail`, `Preço Unitário`. |
| **Escopo** | Os limites do projeto. Define o que está incluído e o que é deixado de fora. | "Não guardaremos o histórico de manutenção mecânica dos carros." |

Bom trabalho na condução das entrevistas! Guardem o rascunho com carinho, pois na próxima aula colocaremos nosso Minimundo no GitHub. 🚀
