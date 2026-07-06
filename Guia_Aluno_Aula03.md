# Guia da Aula 03: Escrita do Minimundo, GitHub e Homologação de Requisitos (29/06/2026)

Olá! Na aula passada, vocês colheram informações do cliente e fizeram um rascunho. Hoje, daremos um tom profissional a esse documento, subiremos no GitHub e passaremos por um processo real de auditoria técnica. 💻

---

## 🎯 Objetivos da Aula
O objetivo de hoje é refinar a redação do seu Minimundo, versioná-lo em formato Markdown no GitHub, participar de uma auditoria cruzada por meio de GitHub Issues (identificando "buracos" nas regras de negócio das outras duplas) e homologar o escopo do seu projeto resolvendo todas as issues abertas.

---

## 🧠 Competências Mobilizadas

### 📊 Indicadores (O que estamos avaliando)
- **1.** Levanta requisitos e coleta informações de suporte do processo inicial de modelagem de banco de dados, de acordo com exigências do projeto de software.

### 📚 Conhecimentos (O que você vai aprender)
- Versionamento básico de documentação técnica com Git e GitHub.
- Formatação básica de texto usando Markdown (`.md`).
- Metodologia de homologação de requisitos e tratamento de gaps usando Issues.

### 🛠️ Habilidades (O que você vai colocar em prática)
- Criar e gerenciar um repositório no GitHub para o seu projeto.
- Analisar de forma crítica e identificar lacunas em requisitos de softwares alheios (Peer Review).
- Gerenciar, discutir e resolver demandas e dúvidas de escopo técnicas via GitHub Issues.

### 🤝 Atitudes e Valores (Como vamos nos portar)
- **Visão Crítica:** Ler documentações alheias e identificar cenários omitidos (gaps) ou contradições de lógica.
- **Colaboração e Comunicação:** Negociar escopo de forma profissional e cordata através das discussões nas Issues do GitHub.
- **Autonomia Digital:** Realizar commits, push e fechamento de issues no GitHub de forma independente.

---

## 🚀 Passo a Passo da Missão de Hoje

### Missão 1: Checklist de Refinamento (Em Duplas) 📝
Reúna-se com sua dupla e revisem o rascunho do Minimundo da aula passada:
1. Certifiquem-se de que os atores (quem participa), atributos (quais dados guardamos), ações (o que acontece) e limites (o que fica de fora) estão evidentes no texto.
2. **Revisão Importante:** Garantam que não há jargões de TI no texto. Substituam coisas como "tabela cliente" por "registro de clientes".

### Missão 2: Versionamento no GitHub 🐙
1. Crie um repositório no GitHub para o projeto da sua dupla.
2. Crie um arquivo na raiz chamado `minimundo.md`.
3. Escreva o Minimundo utilizando formatação Markdown (use `#` para títulos, `*` para tópicos e blocos de notas se necessário).
4. Faça o **Commit** e o **Push** do arquivo.
5. Compartilhem o link do repositório conforme orientação do professor.

### Missão 3: Auditoria Cruzada (Peer Review) 🕵️‍♂️
1. O professor sorteará outra dupla para vocês auditarem.
2. Acessem o repositório dela e leiam o arquivo `minimundo.md`.
3. Pensem em furos na lógica de negócio (Ex: *"Eles disseram que alugam carros, mas o que acontece se o carro bater? Quem paga o seguro? O sistema registra multas?"*).
4. **Abram no mínimo duas Issues** no repositório da dupla parceira, descrevendo a dúvida/lacuna de forma clara e educada.
5. Fiquem de olho: o professor também auditará o seu projeto abrindo Issues!

### Missão 4: Resolução de Issues e Ajuste de Escopo 🛠️
Sua dupla receberá Issues no seu repositório. Debatam e respondam a cada uma delas:
*   **Se a regra entra no sistema:** Editem o arquivo `minimundo.md` no seu repositório local, adicionando a regra. Façam o commit adicionando a mensagem de fechamento (Ex: `ajusta regras de frete. fecha #1`) e enviem para o GitHub. A issue será fechada automaticamente.
*   **Se a regra NÃO entra no sistema:** Respondam na própria Issue justificando de forma profissional o porquê de estar fora do escopo do projeto (Ex: *"Essa funcionalidade está fora do escopo desta versão do banco de dados."*) e fechem a Issue manualmente.

### Missão 5: Homologação 🏁
Apresentem o Minimundo homologado (com todas as Issues fechadas) para a turma. Este documento final será o contrato do banco de dados para a próxima fase: **Modelagem Conceitual (MER)**.

---

## 🧰 Guia de Sobrevivência (Conceitos-Chave)

| Termo | O que significa na prática? | Exemplo |
| :--- | :--- | :--- |
| **Markdown (.md)** | Linguagem de marcação de texto leve usada para formatar documentações no GitHub. | Usar `**texto**` para deixar o texto em negrito. |
| **Commit** | Gravar as alterações que você fez nos arquivos do projeto com uma mensagem descritiva. | `git commit -m "adiciona minimundo.md"` |
| **GitHub Issues** | Seção do repositório usada para registrar tarefas, dúvidas, bugs ou discussões sobre o projeto. | Uma issue intitulada "Dúvida sobre cancelamento de reservas". |
| **Peer Review** | Processo de revisão técnica onde colegas avaliam o trabalho de colegas para propor melhorias. | Ler o Minimundo da dupla vizinha para achar furos lógicos. |
| **Gaps de Requisitos** | Lacunas ou furos lógicos nas regras do negócio que não foram previstas inicialmente. | Esquecer de definir se o cliente paga multa por devolução em atraso. |
| **Homologação** | Aprovação final de um documento ou funcionalidade, garantindo que ela atende aos requisitos combinados. | O Minimundo final sem nenhuma Issue aberta. |

Bom trabalho auditando e refinando seus projetos! O Minimundo de vocês agora é oficial e robusto. 🚀
