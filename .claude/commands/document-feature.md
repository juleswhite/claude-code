---
description: Gera documentação técnica (dev) e um guia de usuário para uma funcionalidade existente no projeto
argument-hint: [nome-da-funcionalidade]
allowed-tools: Glob, Grep, Read, Write, Bash(ls:*), Bash(find:*)
---

# document-feature

Você vai documentar a funcionalidade **"$ARGUMENTS"** do projeto, gerando dois arquivos
separados: um técnico (para devs) e um guia simples (para usuários finais).

Se `$ARGUMENTS` estiver vazio, pare e peça ao usuário o nome da funcionalidade antes de
continuar. Não prossiga com um nome genérico ou adivinhado.

## 1. Normalize o nome da funcionalidade

- Derive um **slug** em kebab-case a partir de `$ARGUMENTS`: minúsculas, espaços e
  underscores viram `-`, remova acentos e caracteres especiais.
  Ex.: "Exportação de Dados" → `exportacao-de-dados`.
- Derive um **nome legível** para títulos (capitalizado, sem kebab-case).
  Ex.: `exportacao-de-dados` → "Exportação de Dados".
- Use esse slug em todos os nomes de arquivo do passo 4.

## 2. Encontre a funcionalidade no código

Pesquise o repositório para localizar os arquivos relevantes, combinando:

- `Glob` por nomes de pastas/arquivos que contenham o slug ou palavras-chave do nome
  (ex.: `**/*export*`, `**/*Export*`).
- `Grep` pelo termo (e variações/sinônimos óbvios em inglês e português) no conteúdo do
  código: componentes, rotas/endpoints, serviços, hooks, modelos de dados, testes.
- Priorize: ponto de entrada (rota/endpoint/comando), lógica principal, modelos/tipos
  envolvidos e testes existentes.

Monte uma lista dos arquivos relevantes com caminho e um resumo de uma linha do papel de
cada um. Limite-se aos arquivos realmente relevantes — não inclua arquivos apenas porque
mencionam o termo de passagem.

### Caso a funcionalidade não seja encontrada

Se a busca não retornar nenhum arquivo claramente relacionado:

1. Não invente conteúdo nem gere os documentos.
2. Liste os termos e padrões que você tentou buscar.
3. Se encontrar nomes parecidos (matches parciais), sugira-os como possíveis alternativas.
4. Pergunte ao usuário o nome exato da funcionalidade ou peça um arquivo de entrada
   (ex.: a rota, componente ou serviço principal) para prosseguir.

## 3. Verifique padrões de documentação existentes

- Confira se `docs/dev/` e `docs/user/` já existem e têm arquivos. Se sim, leia 1-2
  exemplos para identificar: estrutura de seções, tom de voz, idioma usado, e se há
  front-matter (metadados) no topo dos arquivos `.md`.
- Se existir um guia de estilo (ex.: `CONTRIBUTING.md`, `docs/README.md`,
  `docs/STYLE_GUIDE.md`), siga as convenções descritas nele.
- Se não houver nenhum padrão existente, use a estrutura definida nos passos 4a e 4b
  abaixo como padrão.

## 4. Gere os dois documentos

Crie os diretórios `docs/dev/` e `docs/user/` caso não existam.

**Antes de escrever**, verifique se os arquivos de destino já existem. Se existirem,
avise o usuário e peça confirmação antes de sobrescrever — não sobrescreva
silenciosamente documentação existente.

### 4a. `docs/dev/[slug]-implementation.md` — documentação técnica

Use exatamente estas seções, nesta ordem:

```markdown
# {Nome Legível} — Documentação Técnica

> Documentação para usuários: [Como usar: {Nome Legível}](../user/how-to-[slug].md)

## Visão Geral
{2-4 frases explicando o que a funcionalidade faz e por que existe no sistema}

## Arquivos Envolvidos
- `caminho/arquivo.ext:linha` — {o que esse arquivo faz nesta funcionalidade}
{um item por arquivo relevante encontrado no passo 2}

## Arquitetura e Fluxo de Dados
{como a informação flui: entrada → processamento → saída/persistência.
Use uma lista numerada ou um bloco ```mermaid``` se ajudar a clarear o fluxo}

## API / Interfaces
{endpoints, assinaturas de função/método públicas, parâmetros e formato de
request/response. Se não houver API pública, escreva "Não aplicável — funcionalidade
sem interface externa exposta."}

## Modelos de Dados
{tipos/schemas/tabelas envolvidos, com campos relevantes. Se não houver, escreva
"Não aplicável."}

## Notas de Implementação
{decisões não óbvias, edge cases tratados no código, limitações técnicas conhecidas.
Baseie-se apenas no que está no código — não especule}

## Dependências
{bibliotecas internas/externas de que essa funcionalidade depende}

## Testes
{arquivos de teste relacionados encontrados e como executá-los, se houver script/comando
identificável no projeto}

---
*Gerado em {data atual} via `/document-feature`.*
```

### 4b. `docs/user/how-to-[slug].md` — guia do usuário final

Use exatamente estas seções, nesta ordem. Escreva em linguagem simples, sem jargão
técnico, como se explicasse para alguém que nunca programou:

```markdown
# Como usar: {Nome Legível}

> Documentação técnica: [{Nome Legível} — Documentação Técnica](../dev/[slug]-implementation.md)

## O que é isso
{1-2 frases em linguagem simples sobre o que essa funcionalidade permite fazer}

## Antes de começar
{pré-requisitos, permissões ou condições necessárias, se aplicável. Se não houver,
omita esta seção}

## Passo a passo
1. {instrução curta e direta}

   [SCREENSHOT: {descrição objetiva da tela nesse passo}]

2. {próxima instrução}

   [SCREENSHOT: {descrição objetiva da tela nesse passo}]

{continue numerando até completar o fluxo. Todo passo que muda de tela ou estado
visível deve ter um placeholder de screenshot logo abaixo}

## Solução de problemas
{erros ou mensagens comuns que o usuário pode encontrar, baseados em validações/
mensagens de erro reais existentes no código. Se não for possível identificar nenhum
com base no código, omita esta seção — não invente}

---
*Precisa de mais detalhes técnicos? Veja a [documentação para desenvolvedores](../dev/[slug]-implementation.md).*
```

## 5. Confirme o resultado

Ao terminar, responda ao usuário com:
- Os dois caminhos de arquivo criados (ou atualizados).
- A lista de arquivos de código que você analisou para gerar a documentação.
- Qualquer suposição que você teve que fazer por falta de informação no código (ex.:
  "não encontrei mensagens de erro específicas, então a seção de solução de problemas
  foi omitida").
