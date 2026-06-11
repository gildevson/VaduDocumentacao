# 8.0 - Banco de Dados — Estrutura e Relacionamentos

## Visão Geral

Quando uma consulta VADU é realizada, o retorno da API é persistido em duas tabelas:

| Tabela | Função |
|---|---|
| `CadastroBaseConsulta` | Registro da consulta — guarda o JSON bruto e metadados |
| `VaduDetalheTemp` | JSON "explodido" — uma linha por campo do retorno |

---

## Diagrama de Relacionamentos

```
Cliente
  └─ CadastroBaseId
        │
        ▼
  CadastroBase
        │
        └─ Id ◄─────────────────── CadastroBaseConsulta
                                          │   │   │
                              CreditoProduto  │  Empresa
                                              │
                                    Id ◄──────────── VaduDetalheTemp
                                              │       CadastroBaseConsultaId
                                         (Retorno)
                                       JSON bruto da VADU
```

---

## Tabela: `CadastroBaseConsulta`

Armazena o registro de cada consulta realizada à API VADU.

### Colunas principais

| Coluna | Tipo | Descrição |
|---|---|---|
| `Id` | uniqueidentifier (PK) | Identificador único da consulta |
| `Data` | smalldatetime | Data/hora da consulta |
| `Sucesso` | tinyint | `1` = sucesso, `0` = falha |
| `Retorno` | varchar(max) | JSON bruto completo retornado pela VADU |
| `Mensagem` | varchar(max) | Mensagem de erro ou status da resposta |
| `AnaliseIA` | nvarchar(max) | Análise gerada por IA sobre o retorno |

### Chaves estrangeiras

| Coluna | Referência | Descrição |
|---|---|---|
| `CadastroBaseId` | `CadastroBase.Id` | CNPJ/CPF consultado |
| `CreditoProdutoId` | `CreditoProduto.Id` | Produto de crédito que originou a consulta |
| `EmpresaId` | `Empresa.Id` | Empresa do sistema que realizou a consulta |
| `ClienteId` | `Cliente.Id` | Cliente vinculado (sem FK declarada) |
| `OperacaoId` | `Operacao.Id` | Operação de crédito relacionada (sem FK declarada) |
| `DocumentoId` | — | Documento relacionado, ex: borderô (sem FK declarada) |

### Observações técnicas

- Tabela **temporal** (`SYSTEM_VERSIONING = ON`) com histórico de 6 meses em `CadastroBaseConsulta_History`
- `FILLFACTOR = 90` na PK para otimizar inserções
- `ValidFrom` / `ValidTo` gerados automaticamente (colunas ocultas)

---

## Tabela: `VaduDetalheTemp`

Armazena cada campo do JSON retornado pela VADU como uma linha individual — padrão **EAV (Entity-Attribute-Value)**.

### Colunas principais

| Coluna | Tipo | Descrição |
|---|---|---|
| `Id` | uniqueidentifier (PK) | Identificador único da linha |
| `Chave` | uniqueidentifier | Agrupador de um conjunto de linhas geradas no mesmo processamento |
| `Identificador` | nvarchar(500) | Caminho do campo no JSON (ex: `Fornecedores[8]/nome`) |
| `Valor` | nvarchar(max) | Valor do campo como texto |
| `CadastroBaseConsultaId` | uniqueidentifier (FK) | Consulta que originou este detalhe |

### Chaves estrangeiras

| Coluna | Referência |
|---|---|
| `CadastroBaseConsultaId` | `CadastroBaseConsulta.Id` |

---

## Relacionamento entre as tabelas

```
CadastroBaseConsulta (1) ──────── (N) VaduDetalheTemp
        Id            ◄────── CadastroBaseConsultaId
```

Uma consulta gera **N linhas** na `VaduDetalheTemp` — uma por campo do JSON.

### Exemplo prático

Consulta ao CNPJ `07.139.978/0001-88` gera em `CadastroBaseConsulta`:

```
Id: AEB21BC5-FB39-454F-94F4-D885932EF29F
Retorno: { "CnpjCpf": "07.139.978/0001-88", "Nome": "DTA COMERCIAL LTDA", ... }
Sucesso: 1
```

E gera em `VaduDetalheTemp` (uma linha por campo):

| Identificador | Valor |
|---|---|
| `CnpjCpf` | `07.139.978/0001-88` |
| `Nome` | `DTA COMERCIAL LTDA` |
| `NomeFantasia` | `DTA DISTRIBUIDORA` |
| `ReceitaSituacao` | `ATIVA` |
| `qtdFunc` | `14` |
| `Socios[0]/Nome` | `RAPHAELLA LORENZONI FALCHETTO TANAKA` |
| `Filiais[0]/cnpj` | `07.139.978/0001-88` |
| `Filiais[1]/cnpj` | `07.139.978/0002-69` |
| `Fornecedores[8]/nome` | `QUINELATO INDUSTRIA E COMERCIO LTDA` |
| `RecursoAmbiental/nivel` | `Sem risco` |
| `retConsCad/infCons/cStat` | `111` |
| ... | ... |

---

## Campos do retorno VADU mapeados

Os parâmetros da chamada controlam quais grupos de campos aparecem:

| Parâmetro | Valor | Campos gerados na `VaduDetalheTemp` |
|---|---|---|
| `AtualizaCadastro=1` | Atualiza cadastro | `Nome`, `CnpjCpf`, `Logradouro`, `ReceitaSituacao`, `Socios[]`, etc. |
| `ConsultaSefaz=1` | Consulta Sefaz | `retConsCad/infCons/*`, `retConsCad/infCad[]/ender/*` |
| `QtdFunc=1` | Qtd. funcionários | `qtdFunc`, `qtdFuncMatriz` |
| `Ultimoserasa=0` | Sem Serasa | Não gera campos de Serasa |
| `Filiais=2` | Filiais | `Filiais[N]/cnpj`, `Filiais[N]/municipioEndereco`, etc. |
| `PrincipaisFornecedores=1` | Fornecedores | `Fornecedores[N]/cnpj`, `Fornecedores[N]/nome` |

---

## Exemplo de consulta SQL

```sql
SELECT
    CadastroBase.Razao,
    CadastroBase.CPFCNPJ,
    VaduDetalheTemp.Identificador,
    VaduDetalheTemp.Valor
FROM VaduDetalheTemp
INNER JOIN CadastroBaseConsulta
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN Cliente
    ON Cliente.CadastroBaseId = CadastroBase.Id
WHERE VaduDetalheTemp.IsDeleted = 0
```
