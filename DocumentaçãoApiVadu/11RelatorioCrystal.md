# 11.0 - Relatório Crystal Reports — VaduRelatoSimples.rpt

## Estrutura das Seções

```
┌─────────────────────────────────────────────────────────┐
│  Cabeçalho do Relatório a                               │
│  Logo da empresa consultante                            │
├─────────────────────────────────────────────────────────┤
│  Cabeçalho do Relatório b                               │
│  Título: "Relatório de Crédito VADU"  |  Data emissão  │
├─────────────────────────────────────────────────────────┤
│  Cabeçalho da Página a                                  │
│  {CNPJConsultado}  |  Relatório de Crédito - {Data}     │
├─────────────────────────────────────────────────────────┤
│  Detalhes a  →  ViewVaduConsultaCadastral               │
│  Bloco cadastral completo (texto + campos)              │
├─────────────────────────────────────────────────────────┤
│  Detalhes b  →  Subreport: ViewVaduConsultaSocios       │
│  Lista de sócios (uma linha por sócio)                  │
├─────────────────────────────────────────────────────────┤
│  Detalhes c  →  Subreport: ViewVaduConsultaSefaz        │
│  Situação fiscal junto à Sefaz                          │
├─────────────────────────────────────────────────────────┤
│  Detalhes d  →  Subreport: ViewVaduConsultaFiliais      │
│  Lista de filiais                                       │
├─────────────────────────────────────────────────────────┤
│  Detalhes e  →  Subreport: ViewVaduConsultaFornecedores │
│  Lista de fornecedores                                  │
├─────────────────────────────────────────────────────────┤
│  Rodapé da Página b                                     │
│  Confidencial para: {UsuarioConsultou}                  │
│  Página {N} / {Total}                                   │
└─────────────────────────────────────────────────────────┘
```

---

## Detalhamento de Cada Seção

### Cabeçalho do Relatório a
- Logo da empresa consultante

### Cabeçalho do Relatório b
- Título do relatório
- Data de emissão (`CurrentDate`)

### Cabeçalho da Página a
```
{CNPJConsultado}                    Relatório de Crédito - {DataConsulta}
```

---

### Detalhes a — Bloco Cadastral

**View:** `ViewVaduConsultaCadastral`

**Parâmetro de filtro:** `ConsultaId = {?ConsultaId}`

**Conteúdo:**
```
{RazaoSocialConsultada}. - CNPJ: {CNPJConsultado}
{NomeFantasia}
{@IdadeEmpresa}, localizada na cidade de {Municipio} - {UF} no endereço {Logradouro}
{NumeroLogradouro} - {ComplementoEndereco} CEP: {CEP}.
Telefone: {Telefone} - E-mail: {Email} - site: {Site}
Possui um Capital social de {CapitalSocial}
A descrição da natureza jurídica é uma {NaturezaJuridica} e sua atividade econômica principal é {AtividadePrincipal}
Atividades Econômicas Secundarias:
{AtividadesSecundarias}
A situação cadastral da empresa é {ReceitaSituacao} desde {DataSituacaoCadastral}
O Porte segundo a Receita Federal é {Porte}
```

**Fórmula `@IdadeEmpresa`:**
```
Local DateVar DataAbertura;
Local NumberVar IdadeEmpresa;

If IsNull({ViewVaduConsultaCadastral.ReceitaAbertura})
    Or {ViewVaduConsultaCadastral.ReceitaAbertura} = ""
Then
    "Data de abertura não informada"
Else (
    DataAbertura := DateValue({ViewVaduConsultaCadastral.ReceitaAbertura});
    IdadeEmpresa := DateDiff("yyyy", DataAbertura, CurrentDate);

    If Date(Year(CurrentDate), Month(DataAbertura), Day(DataAbertura)) > CurrentDate Then
        IdadeEmpresa := IdadeEmpresa - 1;

    "Empresa fundada em "
    + ToText(DataAbertura, "dd/MM/yyyy")
    + " com "
    + ToText(IdadeEmpresa, 0)
    + " anos no mercado"
)
```

---

### Detalhes b — Subreport Sócios

**Arquivo:** `VaduSocios.rpt`

**View:** `ViewVaduConsultaSocios`

**Link com relatório principal:** `ConsultaId = ConsultaId`

**Conteúdo do Details (repete por sócio):**
```
{SocioNome} - {SocioQualificacao}
```

---

### Detalhes c — Subreport Sefaz

**Arquivo:** `VaduSefaz.rpt` (ou `VaduSimples.rpt`)

**View:** `ViewVaduConsultaSefaz`

**Link com relatório principal:** `ConsultaId = ConsultaId`

**Conteúdo do Details:**
```
Consulta Sefaz realizada em {SefazDataConsulta} - UF: {SefazUF}
Status: {SefazCodStatus} - {SefazMotivoStatus}
Inscrição Estadual: {InscricaoEstadual} - Situação IE: {SituacaoIE}
Situação CNPJ na Sefaz: {SituacaoCNPJ}
Regime de Apuração: {RegimeApuracao}
DFe Habilitados: {DfeHabilitados}
```

---

### Detalhes d — Subreport Filiais

**View:** `ViewVaduConsultaFiliais`

**Link com relatório principal:** `ConsultaId = ConsultaId`

**Conteúdo do Details (repete por filial, ordenado por `FilialIndice`):**
```
{FilialCNPJ}  |  {FilialMunicipio} - {FilialUF}  |  {FilialSituacao}
```

| Campo | Descrição |
|---|---|
| `FilialIndice` | Ordem da filial no retorno VADU (0, 1, 2...) |
| `FilialCNPJ` | CNPJ da filial |
| `FilialMunicipio` | Município do endereço |
| `FilialUF` | UF do endereço |
| `FilialSituacao` | Situação na Receita Federal (ex: ATIVA, BAIXADA) |

---

### Detalhes e — Subreport Fornecedores

**View:** `ViewVaduConsultaFornecedores`

**Link com relatório principal:** `ConsultaId = ConsultaId`

**Conteúdo do Details (repete por fornecedor):**
```
{CampoFornecedor} - {ValorFornecedor}
```

---

### Rodapé da Página b
```
Este relatório é confidencial para: {UsuarioConsultou}
                        Página {Número da Página} / {Contagem Total de Páginas}
```

---

## Parâmetro do Relatório

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `{?ConsultaId}` | String (GUID) | Id da consulta selecionada na tela |

O `ConsultaId` é passado pelo sistema quando o usuário clica no botão de impressão na tela de **Consulta de crédito** do LiveWork.

---

## Resumo de Views por Seção

| Seção CR | View SQL | Tipo |
|---|---|---|
| Detalhes a | `ViewVaduConsultaCadastral` | Principal |
| Detalhes b | `ViewVaduConsultaSocios` | Subreport |
| Detalhes c | `ViewVaduConsultaSefaz` | Subreport |
| Detalhes d | `ViewVaduConsultaFiliais` | Subreport |
| Detalhes e | `ViewVaduConsultaFornecedores` | Subreport |
