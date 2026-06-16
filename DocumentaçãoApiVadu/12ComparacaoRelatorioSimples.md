# 12.0 - Comparação: VaduSimples (LiveWork) vs simples.pdf (VADU completo)

## Contexto PARA entender

O relatório `VaduSimples.rpt` produzido pelo LiveWork ERP foi comparado com o `simples.pdf`
gerado diretamente pela plataforma VADU. O objetivo foi identificar quais seções estão
implementadas, quais estão faltando e qual a origem dos dados de cada bloco.

---

## Comparação por seção

| # | Seção | Páginas no simples.pdf | VaduSimples.rpt | Origem dos dados |
|---|---|---|---|---|
| 1 | Capa | p. 1 | ✅ | `ViewVaduConsultaCadastral` |
| 2 | Índice | p. 2-3 | ✅ | Texto fixo |
| 3 | Dados cadastrais | p. 1-3 | ✅ | `ViewVaduConsultaCadastral` |
| 4 | Sócios e Administradores | p. 1-3 | ✅ | `ViewVaduConsultaSocios` |
| 5 | SEFAZ | p. 1-3 | ✅ | `ViewVaduConsultaSefaz` |
| 6 | Fachada e entorno 360º | p. 4 | ❌ | Google Street View (API externa) |
| 7 | Processos judiciais | p. 5–11 | ❌ | API VADU — endpoint não integrado |
| 8 | Dados Serasa | p. 12 | ❌ | API Serasa — não integrada |
| 9 | Pontos de atenção | p. 13 | ❌ | API VADU — endpoint não integrado |
| 10 | Cartórios BOA VISTA | p. 14 | ❌ | API BOA VISTA — não integrada |
| 11 | Alterações cadastrais | p. 15–16 | ❌ | API VADU — endpoint não integrado |
| 12 | Cartórios CENPROT | p. 17 | ❌ | API CENPROT — não integrada |
| 13 | PEP / COAF por sócio | p. 19, 21 | ❌ | API VADU — não retornado no JSON atual |
| 14 | Empresas participantes (por sócio) | p. 20, 22 | ❌ | API VADU — não retornado no JSON atual |

---

## Causa raiz

O JSON atual (`RETORNO06.json`) retornado pela integração VADU é uma versão **básica** da API,
que contém apenas:

```
- Dados cadastrais (Receita Federal)
- Sócios (básico: Nome, Qualificação, PaisOrigem)
- retConsCad (SEFAZ)
- Filiais
- Fornecedores
- RecursoAmbiental
```

O `simples.pdf` da plataforma VADU utiliza uma versão **completa** que inclui dados de
múltiplas fontes externas não presentes na integração atual.

---

## Seções implementadas no VaduSimples.rpt

### Detalhes a — Dados Cadastrais
- **View:** `ViewVaduConsultaCadastral`
- **Campos:** Nome, CNPJ, NomeFantasia, Endereço, Telefone, Email, Site,
  CapitalSocial, NaturezaJuridica, AtividadePrincipal, AtividadesSecundarias,
  ReceitaSituacao, DataSituacaoCadastral, Porte, SimplesNacional, SIMEI

### Detalhes b — Sócios e Administradores
- **View:** `ViewVaduConsultaSocios`
- **Campos:** SocioNome, SocioQualificacao, SocioPaisOrigem,
  SocioRepresentante, SocioQualificacaoRepresentante
- **Observação:** Uma linha por sócio, agrupado por `SocioIndice`

### Detalhes c — SEFAZ
- **View:** `ViewVaduConsultaSefaz`
- **Campos:** SefazCNPJ, SefazNome, InscricaoEstadual, SefazUF,
  SituacaoCNPJ, SituacaoIE, RegimeApuracao, DfeHabilitados,
  SefazCodStatus, SefazMotivoStatus

### Detalhes d — Filiais
- **View:** `ViewVaduConsultaFiliais`
- **Campos:** FilialCNPJ, FilialMunicipio, FilialUF, FilialSituacao, FilialIndice

### Detalhes e — Fornecedores
- **View:** `ViewVaduConsultaFornecedores`
- **Status:** A implementar

---

## Seções que dependem de APIs adicionais

### Processos Judiciais
- Requer endpoint VADU de processos (não presente no JSON atual)
- Dados esperados: total, trabalhista, estadual, federal, gráficos por ano/área/status

### Dados Serasa
- Requer integração com API Serasa
- Dados esperados: pendências, scores, negativações

### Pontos de Atenção
- Requer processamento de regras sobre os dados retornados (ex: ICMS diferente de Habilitado)
- Pode ser implementado via fórmulas no Crystal Reports com os dados já disponíveis do SEFAZ

### Cartórios (BOA VISTA / CENPROT)
- Requer integração com APIs de protesto externas

### Alterações Cadastrais
- Requer endpoint VADU de histórico de alterações (não presente no JSON atual)

### PEP / COAF por Sócio
- Requer endpoint VADU específico ou dado complementar
- Campo esperado: `Socios[N]/PEP` — **não gravado** na `VaduDetalheTemp` atualmente

### Empresas Participantes por Sócio
- Tabela com: Qualificação, CNPJ, Razão Social, Nome Fantasia, Município, UF
- Requer endpoint VADU específico (grafia de sócios)
- Campo esperado: `Socios[N]/EmpresasParticipantes[M]/...` — **não gravado** atualmente

---

## Próximos passos para igualar ao simples.pdf

1. Verificar com a VADU quais endpoints adicionais estão disponíveis no contrato
2. Atualizar o código C# de importação do JSON para capturar novos campos na `VaduDetalheTemp`
3. Criar views para cada novo bloco de dados
4. Criar subrelatórios no Crystal Reports para cada seção

---

## Mapa de páginas — simples.pdf (22 páginas)

| Página(s) | Seção |
|---|---|
| p. 1–3 | Capa, Índice, Dados Cadastrais, Sócios, SEFAZ |
| p. 4 | Fachada e Entorno 360° |
| p. 5–11 | Processos Judiciais |
| p. 12 | Dados Serasa |
| p. 13 | Pontos de Atenção |
| p. 14 | Cartórios BOA VISTA |
| p. 15–16 | Alterações Cadastrais |
| p. 17 | Cartórios CENPROT |
| p. 18 | — |
| p. 19, 21 | PEP / COAF por Sócio |
| p. 20, 22 | Empresas Participantes por Sócio |

---

## Arquivos de referência

| Arquivo | Descrição |
|---|---|
| `C:\VADU\pdf\simples.pdf` | Relatório completo gerado pela plataforma VADU (22 páginas) |
| `C:\VADU\RelatoriosLive\LiveWork ERP - Rel. Vadu Simples Relatorios.pdf` | Relatório atual do LiveWork (4 páginas) |
| `C:\VADU\RETORNO06.json` | Exemplo de JSON retornado pela integração atual |
