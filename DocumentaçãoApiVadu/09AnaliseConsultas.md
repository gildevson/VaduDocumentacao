# 9.0 - Análise das Consultas — CadastroBaseConsulta e VaduDetalheTemp

## Visão Geral dos Arquivos

| Arquivo | Tabela | Conteúdo |
|---|---|---|
| `CadastroConsultaDetalheTemp.sql` | `CadastroBaseConsulta` | 14 registros de consultas a múltiplos CNPJs |
| `VaduDetalheTemp.sql` | `VaduDetalheTemp` | 137 linhas do JSON explodido de uma consulta específica |

### Conexão entre os arquivos

```
CadastroBaseConsulta.Id  ◄──────  VaduDetalheTemp.CadastroBaseConsultaId
                                         (AEB21BC5-FB39-454F-94F4-D885932EF29F)
```

Os exports são de momentos e consultas diferentes — os IDs não se sobrepõem entre os dois arquivos, mas pertencem ao mesmo fluxo de dados.

---

## Estrutura do Fluxo de Consulta

```
1. Sistema chama a API VADU
         │
         ▼
2. Grava registro em CadastroBaseConsulta
   - Sucesso = 0 ou 1
   - Retorno = JSON ou HTML de erro
   - Mensagem = "Processando" → atualiza depois (ou não)
         │
         ▼ (apenas quando Sucesso = 1)
3. Explode o JSON em VaduDetalheTemp
   - Uma linha por campo
   - Chave agrupa todas as linhas do mesmo processamento
```

---

## Análise das 14 Consultas (CadastroConsultaDetalheTemp)

### CNPJs consultados

| CNPJ | Razão | Situação Receita |
|---|---|---|
| `07.139.978/0001-88` | DTA COMERCIAL LTDA | ATIVA (ES) |
| `52.229.334/0001-35` | RAFAEL LUIZ DE SOUZA MACHADO | ATIVA (SP) |
| `46.260.719/0001-62` | MARIA ELISALDA DIAS DE LIMA | BAIXADA (SP) |
| `21.312.445/0001-87` | FABIANE MARIA FERNANDES DA SILVA | BAIXADA (BA) |
| `00.512.368/0001-39` | JACOMOSARTTE COMERCIO E REP. | BAIXADA (DF) |

---

## Tipos de Resultado Encontrados

### Tipo 1 — Sucesso com Processamento Pendente (`Sucesso=1`, `Mensagem="Processando"`)

Ocorre quando a VADU retorna o JSON corretamente, mas o sistema salva o registro com status intermediário e **não atualiza a mensagem** após concluir.

| Id | CNPJ | Data |
|---|---|---|
| `0361CBEB` | 52.229.334 | 2026-05-05 13:52 |
| `E84D1304` | 00.512.368 | 2025-07-03 17:30 |
| `2C55A7B0` | 46.260.719 | 2026-05-05 13:31 |
| `71D3680A` | 46.260.719 | 2025-07-03 11:42 |
| `D4F3AFE7` | 46.260.719 | 2025-07-02 14:42 |
| `EA2C4E15` | 46.260.719 | 2026-06-01 13:47 |
| `8169B4AF` | 21.312.445 | 2026-05-05 13:52 |

> **Atenção:** Registros com `Sucesso=1` e `Mensagem="Processando"` indicam que o campo `Mensagem` não está sendo atualizado ao final do processamento.

---

### Tipo 2 — Erro 500 da VADU (`Sucesso=0`, `Mensagem="Erro ao consultar Vadu."`)

A VADU retornou uma página HTML de erro 500 em vez de JSON. O campo `Retorno` guarda o HTML completo.

```
EServicoAnaliseOperacao: Problemas com a consulta desse CNPJ
```

| Id | CNPJ | Data |
|---|---|---|
| `5C242867` | 07.139.978 | 2026-05-05 13:27 |
| `8DD15A5A` | 07.139.978 | 2026-05-05 13:30 |
| `0DAB187C` | 07.139.978 | 2026-05-05 13:31 |
| `EB0A720C` | 07.139.978 | 2026-05-05 13:28 |

> Quatro tentativas consecutivas no mesmo CNPJ em ~4 minutos — possível reprocessamento automático sem controle de retry.

---

### Tipo 3 — Bug Crítico: CNPJ passado como objeto LINQ (`Sucesso=0`)

**Registro:** `353A3A3E` — 2025-07-02 14:41

A URL enviada para a VADU foi:

```
/Consulta/System.Linq.Enumerable+WhereEnumerableIterator`1[System.Char]
         ?AtualizaCadastro=1&ConsultaSefaz=1&QtdFunc=1&Ultimoserasa=0
         &Filiais=2&PrincipaisFornecedores=1
```

**Causa:** O código enviou um iterador LINQ (`.Where(...)` sobre uma string de CNPJ) no lugar do valor string extraído. O IIS retornou erro **404.11 — Double Escape Sequence**.

**Erro retornado pelo IIS:**
```
HTTP Error 404.11 - Not Found
The request filtering module is configured to deny a request
that contains a double escape sequence.
```

> Este bug indica que a montagem da URL do CNPJ estava sem `.ToString()` ou sem materializar o resultado LINQ antes de concatenar na URL.

**Exemplo do código problemático (hipótese):**
```csharp
// ERRADO — passa o iterador
var cnpj = "46.260.719/0001-62".Where(char.IsDigit);
url = $"/Consulta/{cnpj}";

// CORRETO — extrai a string
var cnpj = new string("46.260.719/0001-62".Where(char.IsDigit).ToArray());
url = $"/Consulta/{cnpj}";
```

---

### Tipo 4 — Erro 404 da VADU — CNPJ não encontrado

| Id | Mensagem | Data |
|---|---|---|
| `3A39FFF9` | `Não foi encontrado o CNPJ 46` | 2025-07-02 14:38 |
| `12A62379` | `Não foi encontrado o CNPJ 46.260.719` | 2025-07-02 14:36 |

> O CNPJ foi enviado parcialmente ou com pontuação — a VADU respondeu com 404 em HTML.

---

## Análise das 137 Linhas (VaduDetalheTemp.sql)

Todas as linhas pertencem a **uma única consulta**:

| Campo | Valor |
|---|---|
| `CadastroBaseConsultaId` | `AEB21BC5-FB39-454F-94F4-D885932EF29F` |
| `Chave` | `4B128ECE-924D-4F80-8B1C-58C6CCE20E6D` |
| `CreationTime` | `2026-06-01 14:59:00` |
| CNPJ | `07.139.978/0001-88` (DTA COMERCIAL LTDA) |
| Total de campos | **137 linhas** |

### Distribuição dos campos por grupo

| Grupo | Campos | Exemplos de Identificador |
|---|---|---|
| Cadastral básico | ~35 | `Nome`, `CnpjCpf`, `Logradouro`, `ReceitaSituacao` |
| Sócios | 5 | `Socios[0]/Nome`, `Socios[0]/Qualificacao` |
| Sefaz (`retConsCad`) | ~30 | `retConsCad/infCons/cStat`, `retConsCad/infCons/infCad[0]/ender/xLgr` |
| Filiais (4) | 16 | `Filiais[0]/cnpj`, `Filiais[1]/receitaSituacao` |
| Fornecedores (16) | 32 | `Fornecedores[0]/cnpj`, `Fornecedores[8]/nome` |
| Recurso Ambiental | 4 | `RecursoAmbiental/nivel`, `RecursoAmbiental/score` |
| Outros | ~15 | `qtdFunc`, `CodIbge`, `atualizado` |

---

## Pontos de Atenção e Recomendações

| # | Problema | Impacto | Recomendação |
|---|---|---|---|
| 1 | `Mensagem="Processando"` não atualizada | Campo fica desatualizado | Garantir update do campo após processamento |
| 2 | Retry sem controle (4 erros 500 seguidos) | Cobranças desnecessárias na VADU | Implementar limite de tentativas e backoff |
| 3 | Bug LINQ no CNPJ | Erro 404.11 no IIS | Verificar se o fix foi aplicado em produção |
| 4 | CNPJ enviado parcialmente (404) | Consulta falha | Validar CNPJ antes de montar a URL |
| 5 | Sem `ClienteId` e `OperacaoId` em vários registros | Consultas não rastreadas | Verificar se é intencional ou falta de vínculo |
