# Guia Completo API Vadu — GF Distribuidora

## Dados da empresa
- **Nome:** GF DISTRIBUIDORA DE PECAS LTDA EPP
- **CNPJ:** 07139978000188

---

## Como importar as Collections no Postman

1. Abra o Postman
2. Clique em **Import** (canto superior esquerdo)
3. Selecione a aba **Link**
4. Cole a URL da collection desejada abaixo
5. Clique em **Continue** → **Import**

---

## Collections disponíveis

| Collection | Finalidade |
|---|---|
| Motor de Crédito CNPJ | Análise de crédito por CNPJ/CPF |
| Consulta CNPJ/CPF | Consulta cadastral simples |
| Bordero (CNAB/XML/ZIP) | Análise de borderô |
| Monitoramento NF-e | Envio de chaves de NF-e |
| CreditBox | Relatórios de rating de crédito |

---

## Fluxo 1 — Consulta Simples de CNPJ

### Autenticação
- **Auth:** Bearer Token = sua API KEY

### Endpoint
```
POST https://www.vadu.com.br/vadu.dll/ServicoAnaliseOperacao/Consulta/{cnpj}
```

### Query Parameters
| Parâmetro | Valor | Descrição |
|---|---|---|
| AtualizaCadastro | 1 | Atualiza dados cadastrais |
| ConsultaSefaz | 1 | Consulta situação na Sefaz |
| QtdFunc | 1 | Retorna quantidade de funcionários |
| Ultimoserasa | 0 | Não retorna último Serasa |
| Filiais | 2 | Retorna filiais |
| PrincipaisFornecedores | 1 | Retorna fornecedores |

### Exemplo completo
```
POST https://www.vadu.com.br/vadu.dll/ServicoAnaliseOperacao/Consulta/07139978000188?AtualizaCadastro=1&ConsultaSefaz=1&QtdFunc=1&Ultimoserasa=0&Filiais=2&PrincipaisFornecedores=1
```

---

## Fluxo 2 — Consulta Simples de CPF

### Endpoint
```
POST https://www.vadu.com.br/vaduIntegracao.dll/ServicoAnaliseOperacao/ConsultaPF/{cpf}
```

### Exemplo
```
POST https://www.vadu.com.br/vaduIntegracao.dll/ServicoAnaliseOperacao/ConsultaPF/12345678900
```

---

## Fluxo 3 — Motor de Crédito CNPJ (4 passos)

### Passo 01 — Pegar Token Temporário (válido 18h)

```
GET https://www.vadu.com.br/vadu.dll/Autenticacao/JSONPegarToken
```
- **Auth:** Bearer Token = **API KEY**
- **Body:** vazio
- **Retorno:** token temporário JWT → guarde para os próximos passos

---

### Passo 02 — Listar Grupos de Análise

```
GET https://www.vadu.com.br/api-analise-bordero-config/v1/grupoanalise/cnpjcpf
```
- **Auth:** Bearer Token = **token temporário do Passo 01**
- **Body:** vazio
- **Retorno:** lista de grupos com `id` → anote o `id` do grupo desejado

---

### Passo 03 — Enviar CNPJs para Análise

```
POST https://www.vadu.com.br/api-analise-cnpjcpf/v1/erp/analise
```
- **Auth:** Bearer Token = **token temporário do Passo 01**
- **Header:** `Content-Type: application/json`

**Body (raw JSON):**
```json
{
  "cnpj_empresa": "07139978000188",
  "id_grupo_analise": 45,
  "lista_cnpj_cpf": [
    "12345678000199",
    "98765432000100"
  ]
}
```

> Substitua `id_grupo_analise` pelo ID obtido no Passo 02.
> Substitua `lista_cnpj_cpf` pelos CNPJs que deseja analisar.

- **Retorno:** `analise_id` → anote este número para os próximos passos

---

### Passo 04 — Verificar Status da Análise

```
GET https://www.vadu.com.br/api-analise-cnpjcpf/v1/erp/status/analise/id/{analise_id}
```
- **Auth:** Bearer Token = **token temporário do Passo 01**
- Substitua `{analise_id}` pelo ID obtido no Passo 03

---

### Passo 05 — Obter Resultado Detalhado

```
GET https://www.vadu.com.br/api-analise-cnpjcpf/v1/erp/analise/id/{analise_id}/cnpjcpf/detalhado
```
- **Auth:** Bearer Token = **token temporário do Passo 01**
- Substitua `{analise_id}` pelo ID obtido no Passo 03

---

## Fluxo 4 — Monitoramento NF-e

```
POST https://www.vadu.com.br/vadu.dll/ServicoNFe2/JSON
```

**Body (raw JSON):**
```json
{
  "credencial": {
    "appId": "seu_app_id",
    "appSecret": "seu_app_secret"
  },
  "documentos": [
    { "chaveAcesso": "35180200233695000151550100003190581009693188" }
  ]
}
```

> `appId` e `appSecret` são fornecidos pela Vadu.

---

## Resumo dos endpoints

| # | Método | URL | Finalidade |
|---|---|---|---|
| 1 | GET | `/vadu.dll/Autenticacao/JSONPegarToken` | Token temporário |
| 2 | POST | `/vadu.dll/ServicoAnaliseOperacao/Consulta/{cnpj}` | Consulta CNPJ |
| 3 | POST | `/vaduIntegracao.dll/ServicoAnaliseOperacao/ConsultaPF/{cpf}` | Consulta CPF |
| 4 | GET | `/api-analise-bordero-config/v1/grupoanalise/cnpjcpf` | Listar grupos |
| 5 | POST | `/api-analise-cnpjcpf/v1/erp/analise` | Enviar análise |
| 6 | GET | `/api-analise-cnpjcpf/v1/erp/status/analise/id/{id}` | Status análise |
| 7 | GET | `/api-analise-cnpjcpf/v1/erp/analise/id/{id}/cnpjcpf/detalhado` | Resultado |
| 8 | POST | `/vadu.dll/ServicoNFe2/JSON` | Monitoramento NF-e |

**Base URL:** `https://www.vadu.com.br`

---

## Contato suporte
**E-mail:** suporte.vadu@dimensa.com.br
