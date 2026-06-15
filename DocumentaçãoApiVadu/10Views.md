# 10.0 - Views — Consultas VADU

## Contexto

O sistema possui dois papéis distintos em uma consulta VADU:

| Papel | Tabela | Descrição |
|---|---|---|
| **Consultante** (quem consulta) | `Empresa` | Empresa usuária do sistema que disparou a consulta |
| **Consultado** (sacado) | `CadastroBase` | CNPJ/CPF que foi pesquisado na VADU |

> **Exemplo prático (simples.pdf):** A empresa consultante gerou um relatório sobre a **NEW INVEST SECURITIZACAO DE CREDITOS S.A.** (CNPJ 21.586.743/0001-65). A NEW INVEST é o **consultado** — todos os dados retornados pela VADU (processos, Serasa, sócios, situação cadastral) são sobre ela.

---

## Estrutura base das Views

```
Empresa (consultante)
    │
    └─ EmpresaId
              │
              ▼
     CadastroBaseConsulta ◄─── CadastroBase (consultado)
              │
              └─ Id
                    │
                    ▼
            VaduDetalheTemp
          (campos do retorno JSON)
```

---

## ViewVaduConsultaDetalhe

View principal que conecta todas as tabelas, expondo os dois papéis e os campos do retorno VADU.

```sql
CREATE VIEW ViewVaduConsultaDetalhe AS
SELECT
    -- QUEM CONSULTOU
    Empresa.Id                          AS EmpresaConsultanteId,
    Empresa.Nome                        AS EmpresaConsultante,

    -- QUEM FOI CONSULTADO
    CadastroBase.Id                     AS CadastroBaseId,
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,

    -- DADOS DA CONSULTA
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,
    CadastroBaseConsulta.Sucesso        AS ConsultaSucesso,
    CadastroBaseConsulta.Mensagem       AS ConsultaMensagem,

    -- CAMPOS DO RETORNO VADU (sobre o consultado)
    VaduDetalheTemp.Identificador       AS CampoIdentificador,
    VaduDetalheTemp.Valor               AS CampoValor

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
```

**Uso:** Base para todas as demais views. Retorna uma linha por campo do retorno VADU por consulta.

---

## ViewVaduConsultaCadastral

View com os campos cadastrais principais do consultado em colunas separadas (formato PIVOT).

```sql
CREATE VIEW ViewVaduConsultaCadastral AS
SELECT
    -- QUEM CONSULTOU
    Empresa.Nome                        AS EmpresaConsultante,

    -- QUEM FOI CONSULTADO
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,

    -- DADOS DA CONSULTA
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,
    CadastroBaseConsulta.Sucesso        AS ConsultaSucesso,

    -- CAMPOS CADASTRAIS DO RETORNO VADU
    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'Nome'
        THEN VaduDetalheTemp.Valor END) AS Nome,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'NomeFantasia'
        THEN VaduDetalheTemp.Valor END) AS NomeFantasia,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'CnpjCpf'
        THEN VaduDetalheTemp.Valor END) AS CnpjCpf,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaSituacao'
        THEN VaduDetalheTemp.Valor END) AS ReceitaSituacao,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaTipo'
        THEN VaduDetalheTemp.Valor END) AS ReceitaTipo,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'Porte'
        THEN VaduDetalheTemp.Valor END) AS Porte,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaAbertura'
        THEN VaduDetalheTemp.Valor END) AS ReceitaAbertura,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaNaturezaJuridica'
        THEN VaduDetalheTemp.Valor END) AS NaturezaJuridica,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaCapitalSocial'
        THEN VaduDetalheTemp.Valor END) AS CapitalSocial,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'SimplesNacional'
        THEN VaduDetalheTemp.Valor END) AS SimplesNacional,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'SIMEI'
        THEN VaduDetalheTemp.Valor END) AS SIMEI,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'qtdFunc'
        THEN VaduDetalheTemp.Valor END) AS QtdFuncionarios,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'Logradouro'
        THEN VaduDetalheTemp.Valor END) AS Logradouro,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'NumeroLogradouro'
        THEN VaduDetalheTemp.Valor END) AS NumeroLogradouro,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'BairroEndereco'
        THEN VaduDetalheTemp.Valor END) AS Bairro,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'MunicipioEndereco'
        THEN VaduDetalheTemp.Valor END) AS Municipio,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'UfEndereco'
        THEN VaduDetalheTemp.Valor END) AS UF,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'CepEnderecoFormatado'
        THEN VaduDetalheTemp.Valor END) AS CEP,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'TelefonePrincipal'
        THEN VaduDetalheTemp.Valor END) AS Telefone,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'EmailPrincipal'
        THEN VaduDetalheTemp.Valor END) AS Email,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'ReceitaAtividade'
        THEN VaduDetalheTemp.Valor END) AS AtividadePrincipal,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'VaduAtividadeCNAE'
        THEN VaduDetalheTemp.Valor END) AS SetorAtividade,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'RecursoAmbiental/nivel'
        THEN VaduDetalheTemp.Valor END) AS RiscoAmbiental,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'atualizado'
        THEN VaduDetalheTemp.Valor END) AS CadastroAtualizado

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
GROUP BY
    Empresa.Nome,
    CadastroBase.CPFCNPJ,
    CadastroBase.Razao,
    CadastroBaseConsulta.Id,
    CadastroBaseConsulta.Data,
    CadastroBaseConsulta.Sucesso
```

**Uso:** Visão cadastral do consultado com uma linha por consulta. Ideal para relatórios e listagens.

---

## ViewVaduConsultaFornecedores

View que lista os fornecedores retornados pela VADU para cada consulta.

```sql
CREATE VIEW ViewVaduConsultaFornecedores AS
SELECT
    -- QUEM CONSULTOU
    Empresa.Nome                        AS EmpresaConsultante,

    -- QUEM FOI CONSULTADO
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,

    -- DADOS DA CONSULTA
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,

    -- FORNECEDORES
    VaduDetalheTemp.Identificador       AS CampoFornecedor,
    VaduDetalheTemp.Valor               AS ValorFornecedor

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
  AND VaduDetalheTemp.Identificador LIKE 'Fornecedores%'
```

**Uso:** Listar todos os fornecedores identificados pela VADU para o consultado.

---

## ViewVaduConsultaFiliais

View que lista as filiais retornadas pela VADU para cada consulta.

```sql
CREATE VIEW ViewVaduConsultaFiliais AS
SELECT
    -- QUEM CONSULTOU
    Empresa.Nome                        AS EmpresaConsultante,

    -- QUEM FOI CONSULTADO
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,

    -- DADOS DA CONSULTA
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,

    -- FILIAIS
    VaduDetalheTemp.Identificador       AS CampoFilial,
    VaduDetalheTemp.Valor               AS ValorFilial

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
  AND VaduDetalheTemp.Identificador LIKE 'Filiais%'
```

**Uso:** Listar todas as filiais do consultado retornadas pela VADU.

---

## ViewVaduConsultaSefaz

View com os dados da Sefaz (retConsCad) retornados pela VADU.

```sql
CREATE VIEW ViewVaduConsultaSefaz AS
SELECT
    -- QUEM CONSULTOU
    Empresa.Nome                        AS EmpresaConsultante,

    -- QUEM FOI CONSULTADO
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,

    -- DADOS DA CONSULTA
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,

    -- DADOS SEFAZ
    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/cStat'
        THEN VaduDetalheTemp.Valor END) AS SefazCodStatus,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/xMotivo'
        THEN VaduDetalheTemp.Valor END) AS SefazMotivoStatus,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/UF'
        THEN VaduDetalheTemp.Valor END) AS SefazUF,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/dhCons'
        THEN VaduDetalheTemp.Valor END) AS SefazDataConsulta,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/infCad[0]/situacaoIE'
        THEN VaduDetalheTemp.Valor END) AS SituacaoIE,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/infCad[0]/situacaoCNPJ'
        THEN VaduDetalheTemp.Valor END) AS SituacaoCNPJ,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/infCad[0]/IE'
        THEN VaduDetalheTemp.Valor END) AS InscricaoEstadual,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/infCad[0]/xRegApur'
        THEN VaduDetalheTemp.Valor END) AS RegimeApuracao,

    MAX(CASE WHEN VaduDetalheTemp.Identificador = 'retConsCad/infCons/infCad[0]/dfeHabilitados'
        THEN VaduDetalheTemp.Valor END) AS DfeHabilitados

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
  AND VaduDetalheTemp.Identificador LIKE 'retConsCad%'
GROUP BY
    Empresa.Nome,
    CadastroBase.CPFCNPJ,
    CadastroBase.Razao,
    CadastroBaseConsulta.Id,
    CadastroBaseConsulta.Data
```

**Uso:** Verificar situação fiscal do consultado junto à Sefaz.

---

## ViewVaduConsultaSocios

View que lista os sócios retornados pela VADU para cada consulta. Retorna **uma linha por sócio** — diferente das demais views que fazem PIVOT.

```sql
CREATE VIEW ViewVaduConsultaSocios AS
SELECT
    Empresa.Razao                       AS EmpresaConsultante,
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,

    CAST(
        SUBSTRING(
            VaduDetalheTemp.Identificador,
            CHARINDEX('[', VaduDetalheTemp.Identificador) + 1,
            CHARINDEX(']', VaduDetalheTemp.Identificador) - CHARINDEX('[', VaduDetalheTemp.Identificador) - 1
        ) AS INT
    )                                   AS SocioIndice,

    MAX(CASE WHEN VaduDetalheTemp.Identificador LIKE 'Socios[%]/Nome'
        THEN VaduDetalheTemp.Valor END) AS SocioNome,

    MAX(CASE WHEN VaduDetalheTemp.Identificador LIKE 'Socios[%]/Qualificacao'
        THEN VaduDetalheTemp.Valor END) AS SocioQualificacao,

    MAX(CASE WHEN VaduDetalheTemp.Identificador LIKE 'Socios[%]/PaisOrigem'
        THEN VaduDetalheTemp.Valor END) AS SocioPaisOrigem,

    MAX(CASE WHEN VaduDetalheTemp.Identificador LIKE 'Socios[%]/NomeRepresentanteLegal'
        THEN VaduDetalheTemp.Valor END) AS SocioRepresentante,

    MAX(CASE WHEN VaduDetalheTemp.Identificador LIKE 'Socios[%]/QualificacaoRepresentanteLegal'
        THEN VaduDetalheTemp.Valor END) AS SocioQualificacaoRepresentante

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.IsDeleted = 0
  AND VaduDetalheTemp.Identificador LIKE 'Socios[%]%'
GROUP BY
    Empresa.Razao,
    CadastroBase.CPFCNPJ,
    CadastroBase.Razao,
    CadastroBaseConsulta.Id,
    CadastroBaseConsulta.Data,
    CAST(
        SUBSTRING(
            VaduDetalheTemp.Identificador,
            CHARINDEX('[', VaduDetalheTemp.Identificador) + 1,
            CHARINDEX(']', VaduDetalheTemp.Identificador) - CHARINDEX('[', VaduDetalheTemp.Identificador) - 1
        ) AS INT
    )
```

**Uso:** Listar todos os sócios do consultado retornados pela VADU. No Crystal Reports, o Details da sub repete uma linha por sócio.

---

## ViewVaduConsultasComErro

View que lista consultas que falharam — sem detalhe na VaduDetalheTemp.

```sql
CREATE VIEW ViewVaduConsultasComErro AS
SELECT
    Empresa.Nome                        AS EmpresaConsultante,
    CadastroBase.CPFCNPJ                AS CNPJConsultado,
    CadastroBase.Razao                  AS RazaoSocialConsultada,
    CadastroBaseConsulta.Id             AS ConsultaId,
    CadastroBaseConsulta.Data           AS DataConsulta,
    CadastroBaseConsulta.Sucesso        AS ConsultaSucesso,
    CadastroBaseConsulta.Mensagem       AS ConsultaMensagem

FROM CadastroBaseConsulta
INNER JOIN Empresa
    ON Empresa.Id = CadastroBaseConsulta.EmpresaId
INNER JOIN CadastroBase
    ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
LEFT JOIN VaduDetalheTemp
    ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
WHERE CadastroBaseConsulta.IsDeleted = 0
  AND VaduDetalheTemp.Id IS NULL
```

**Uso:** Monitorar falhas de consulta — registros que não geraram detalhe na VaduDetalheTemp.

---

## Resumo das Views

| View | Finalidade |
|---|---|
| `ViewVaduConsultaDetalhe` | Base geral — uma linha por campo do retorno |
| `ViewVaduConsultaCadastral` | Dados cadastrais do consultado em colunas (PIVOT) |
| `ViewVaduConsultaFornecedores` | Fornecedores retornados pela VADU |
| `ViewVaduConsultaFiliais` | Filiais retornadas pela VADU |
| `ViewVaduConsultaSocios` | Sócios retornados pela VADU — uma linha por sócio |
| `ViewVaduConsultaSefaz` | Situação fiscal do consultado na Sefaz |
| `ViewVaduConsultasComErro` | Consultas que falharam sem gerar detalhe |
