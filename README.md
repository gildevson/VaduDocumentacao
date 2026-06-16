# Integração VADU — LiveWork ERP

Documentação da integração entre o sistema **LiveWork ERP** e a plataforma **VADU** para consulta de dados cadastrais, fiscais e de crédito de CNPJ e CPF.

---

## Sobre o projeto

O projeto integra a API da VADU ao LiveWork ERP para:

- Consultar dados cadastrais de CNPJ e CPF (Receita Federal)
- Consultar situação fiscal junto à SEFAZ
- Obter sócios, filiais, fornecedores e dados de crédito
- Persistir o retorno no banco de dados do LiveWork
- Gerar relatórios de crédito em Crystal Reports

---

## Estrutura da documentação

| Arquivo | Descrição |
|---|---|
| [01INSTRUCAO.md](DocumentaçãoApiVadu/01INSTRUCAO.md) | Introdução e visão geral da API VADU |
| [02APIClientPOSTMAN.md](DocumentaçãoApiVadu/02APIClientPOSTMAN.md) | Como testar a API com Postman |
| [03Consulta CNPJ_CPFVADU.MD](DocumentaçãoApiVadu/03Consulta%20CNPJ_CPFVADU.MD) | Endpoints de consulta de CNPJ e CPF |
| [05APIparageraçãodoReport.md](DocumentaçãoApiVadu/05APIparageraçãodoReport.md) | API para geração de relatórios (CreditBox) |
| [06APIparaconsultasaoSCR.md](DocumentaçãoApiVadu/06APIparaconsultasaoSCR.md) | API para consultas ao SCR do BACEN |
| [07.Monitoramento de CNPJ.md](DocumentaçãoApiVadu/07.Monitoramento%20de%20CNPJ.md) | Monitoramento de eventos de CNPJ |
| [08BancoDeDados.md](DocumentaçãoApiVadu/08BancoDeDados.md) | Estrutura do banco de dados e relacionamentos |
| [09AnaliseConsultas.md](DocumentaçãoApiVadu/09AnaliseConsultas.md) | Análise das consultas realizadas |
| [10Views.md](DocumentaçãoApiVadu/10Views.md) | Views SQL usadas nos relatórios |
| [11RelatorioCrystal.md](DocumentaçãoApiVadu/11RelatorioCrystal.md) | Estrutura do relatório Crystal Reports |
| [12ComparacaoRelatorioSimples.md](DocumentaçãoApiVadu/12ComparacaoRelatorioSimples.md) | Comparação entre o relatório atual e o modelo VADU |
| [13TodoList.md](DocumentaçãoApiVadu/13TodoList.md) | Lista de tarefas pendentes |

---

## Arquitetura

```
API VADU
    │
    ▼ JSON
C# (LiveWork ERP)
    │
    ├─► CadastroBaseConsulta  (JSON bruto + metadados)
    │
    └─► VaduDetalheTemp       (JSON "explodido" — 1 linha por campo)
              │
              ▼
         Views SQL
              │
              ▼
      Crystal Reports (.rpt)
              │
              ▼
       Relatório de Crédito (PDF)
```

---

## Banco de dados

Duas tabelas principais armazenam o retorno da API:

| Tabela | Função |
|---|---|
| `CadastroBaseConsulta` | Registro da consulta — JSON bruto e metadados |
| `VaduDetalheTemp` | JSON "explodido" — padrão EAV (uma linha por campo) |

Consulte [08BancoDeDados.md](DocumentaçãoApiVadu/08BancoDeDados.md) para o diagrama completo e exemplos de SQL.

---

## Relatório Crystal Reports

O relatório principal é o `VaduSimples.rpt`, composto por subrelatórios:

| Subrelatório | View SQL | Status |
|---|---|---|
| Dados Cadastrais | `ViewVaduConsultaCadastral` | ✅ Implementado |
| Sócios | `ViewVaduConsultaSocios` | ✅ Implementado |
| SEFAZ | `ViewVaduConsultaSefaz` | ✅ Implementado |
| Filiais | `ViewVaduConsultaFiliais` | ✅ Implementado |
| Fornecedores | `ViewVaduConsultaFornecedores` | ❌ A implementar |
| Processos Judiciais | — | ❌ Depende de endpoint VADU |
| Dados Serasa | — | ❌ Depende de API Serasa |
| Cartórios BOA VISTA | — | ❌ Depende de API BOA VISTA |
| Cartórios CENPROT | — | ❌ Depende de API CENPROT |
| Fachada 360° | — | ❌ Depende de Google Street View |

Veja o detalhamento completo em [13TodoList.md](DocumentaçãoApiVadu/13TodoList.md).

---

## Exemplo de retorno da API

O arquivo [RETORNOMODELO.json](RETORNOMODELO.json) contém um exemplo de retorno completo da API VADU para consulta de CNPJ, com os seguintes blocos:

- Dados cadastrais (Receita Federal)
- Sócios (`Socios[]`)
- Situação SEFAZ (`retConsCad`)
- Filiais (`Filiais[]`)
- Fornecedores (`Fornecedores[]`)
- Risco Ambiental (`RecursoAmbiental`)

---

## Referências

| Recurso | Descrição |
|---|---|
| `C:\VADU\pdf\simples.pdf` | Modelo de relatório completo gerado pela plataforma VADU |
| `C:\VADU\pdf\Manual API_3.5.pdf` | Manual oficial da API VADU v3.5 |
| `C:\VADU\RelatoriosLive\` | Relatórios Crystal Reports do LiveWork |
| `C:\VADU\RETORNO06.json` | Exemplo de retorno real da API VADU |
