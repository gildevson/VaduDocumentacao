# 13.0 - Lista de Tarefas — VaduSimples.rpt

## Status geral

| Símbolo | Significado |
|---|---|
| ✅ | Concluído |
| 🔨 | Em desenvolvimento |
| ❌ | Não iniciado |
| 🔗 | Depende de API externa |

---

## 1. Seções do relatório

### ✅ Já implementadas

- [x] **Capa** — Logo da empresa consultante + título do relatório
- [x] **Índice** — Texto fixo com as seções
- [x] **Dados Cadastrais** — `ViewVaduConsultaCadastral`
- [x] **Sócios e Administradores** — `ViewVaduConsultaSocios`
- [x] **SEFAZ** — `ViewVaduConsultaSefaz`
- [x] **Filiais** — `ViewVaduConsultaFiliais`

---

### ❌ A implementar — dados já disponíveis no JSON

- [ ] **Fornecedores**
  - View: `ViewVaduConsultaFornecedores`
  - Campos disponíveis: `Fornecedores[N].cnpj`, `Fornecedores[N].nome`
  - Ação: criar subrelatório `VaduFornecedores.rpt` e linkar ao principal

---

### ❌ A implementar — requer endpoint adicional da VADU

- [ ] **Processos Judiciais**
  - Verificar endpoint disponível no contrato VADU
  - Dados esperados: total de processos, trabalhista, estadual, federal
  - Ação: gravar na `VaduDetalheTemp`, criar view, criar subrelatório

- [ ] **Alterações Cadastrais**
  - Verificar endpoint de histórico de alterações da VADU
  - Dados esperados: campo alterado, valor anterior, data da alteração
  - Ação: gravar na `VaduDetalheTemp`, criar view, criar subrelatório

- [ ] **PEP / COAF por Sócio**
  - Campo esperado: `Socios[N].PEP`
  - Verificar com VADU se o campo é retornado em outro endpoint
  - Ação: gravar na `VaduDetalheTemp` (campo sócios), criar view, criar subrelatório

- [ ] **Empresas Participantes por Sócio**
  - Campo esperado: `Socios[N].EmpresasParticipantes[M]`
  - Requer endpoint de "grafia de sócios" da VADU
  - Ação: gravar na `VaduDetalheTemp`, criar view, criar subrelatório

---

### 🔗 A implementar — requer API externa

- [ ] **Fachada e Entorno 360°**
  - API: Google Street View
  - Entrada: endereço do CNPJ (`Logradouro + Numero + Municipio + UF`)
  - Ação: chamar API no C# durante importação e salvar imagem no banco

- [ ] **Dados Serasa**
  - API: Serasa (contrato necessário)
  - Dados esperados: score, pendências, negativações
  - Ação: integrar API, gravar na `VaduDetalheTemp`, criar view, criar subrelatório

- [ ] **Cartórios BOA VISTA**
  - API: BOA VISTA (contrato necessário)
  - Dados esperados: protestos, valores, datas
  - Ação: integrar API, gravar na `VaduDetalheTemp`, criar view, criar subrelatório

- [ ] **Cartórios CENPROT**
  - API: CENPROT (contrato necessário)
  - Dados esperados: protestos em cartório
  - Ação: integrar API, gravar na `VaduDetalheTemp`, criar view, criar subrelatório

- [ ] **Pontos de Atenção**
  - Pode ser parcialmente implementado via fórmulas Crystal Reports
  - Usar dados já disponíveis: situação SEFAZ, `ReceitaSituacao`, `SimplesNacional`
  - Ação: criar fórmulas de alertas no Crystal e exibir como bloco de resumo

---

## 2. Backend — C# (importação do JSON)

- [ ] Mapear campos de **Fornecedores** na `VaduDetalheTemp`
- [ ] Mapear campo **PEP** dos sócios (quando disponível)
- [ ] Mapear **EmpresasParticipantes** por sócio (quando disponível)
- [ ] Mapear dados de **Processos Judiciais** (quando endpoint disponível)
- [ ] Mapear dados de **Alterações Cadastrais** (quando endpoint disponível)
- [ ] Salvar imagem do **Street View** no banco (quando API integrada)

---

## 3. Banco de dados — Views SQL

- [ ] Criar `ViewVaduConsultaFornecedores`
- [ ] Criar `ViewVaduConsultaProcessos`
- [ ] Criar `ViewVaduConsultaAlteracoes`
- [ ] Criar `ViewVaduConsultaPEP`
- [ ] Criar `ViewVaduConsultaEmpresasSocio`

---

## 4. Crystal Reports — Subrelatórios

- [ ] Criar `VaduFornecedores.rpt`
- [ ] Criar `VaduProcessos.rpt`
- [ ] Criar `VaduAlteracoes.rpt`
- [ ] Criar `VaduPEP.rpt`
- [ ] Criar `VaduEmpresasSocio.rpt`
- [ ] Criar `VaduSerasa.rpt`
- [ ] Criar `VaduCartoriosBV.rpt`
- [ ] Criar `VaduCartoriosCenprot.rpt`
- [ ] Criar bloco de **Pontos de Atenção** no `VaduSimples.rpt`

---

## 5. Próximo passo imediato

1. **Fornecedores** — dados já estão no JSON; implementar agora sem dependência externa
2. **Pontos de Atenção** — pode ser feito com os dados atuais via fórmulas Crystal
3. **Confirmar com a VADU** quais endpoints estão disponíveis no contrato atual