# 6.0 - API para Consultas ao SCR

API destinada à realização de consultas ao **SCR (Sistema de Informações de Crédito do Banco Central do Brasil)**.

O SCR é uma base de dados administrada pelo Banco Central que reúne informações sobre operações de crédito realizadas por pessoas físicas e jurídicas junto às instituições financeiras.

---

# 6.0.1 – Detalhamento dos Métodos

Esta seção apresenta os métodos disponíveis para consulta à plataforma SCR.

---

## 6.0.1.1 – Consultar SCR e Verificar Consultas Realizadas

### Consultar SCR

#### Endpoint

```text
[Endpoint disponibilizado pela VADU]
```

#### Método HTTP

```http
POST
```

---

### Verificar Consultas na Base de Dados

#### Endpoint

```text
[Endpoint disponibilizado pela VADU]
```

#### Método HTTP

```http
POST
```

---

## Descrição

A rota de consulta ao SCR permite realizar consultas utilizando:

* CNPJ da empresa;
* Período desejado para consulta.

### Parâmetros

| Campo   | Descrição                      |
| ------- | ------------------------------ |
| CNPJ    | CNPJ da empresa consultada     |
| Período | Intervalo de consulta desejado |

---

## Autenticação

Este método exige autenticação utilizando o token fornecido pela VADU.

No Postman, configure:

### Authorization

| Campo | Valor                     |
| ----- | ------------------------- |
| Type  | Bearer Token              |
| Token | Token fornecido pela VADU |

---

## Fluxo de Consulta

1. Obter o token de acesso fornecido pela VADU;
2. Configurar o Bearer Token na requisição;
3. Informar o CNPJ da empresa;
4. Informar o período desejado;
5. Executar a requisição;
6. Analisar os dados retornados pela API.

---

# 6.0.1.2 – Exemplos de Consulta

A Collection disponibiliza exemplos completos para utilização da API SCR.

## Modelo de Consulta

### Exemplo de Requisição

```json
{
  "cnpj": "12345678000199",
  "periodoInicial": "2024-01",
  "periodoFinal": "2024-12"
}
```

### Exemplo de Chamada

```http
POST /SCR/Consultar
Authorization: Bearer {TOKEN}
```

---

## Possíveis Retornos

### Consulta realizada com sucesso

```json
{
  "status": "sucesso",
  "mensagem": "Consulta realizada com sucesso."
}
```

### Falha de autenticação

```json
{
  "status": "erro",
  "mensagem": "Token inválido ou expirado."
}
```

### Empresa não encontrada

```json
{
  "status": "erro",
  "mensagem": "CNPJ não localizado."
}
```

### Período inválido

```json
{
  "status": "erro",
  "mensagem": "Período informado é inválido."
}
```

> Os exemplos apresentados acima servem apenas como referência. Os formatos exatos de requisição e resposta devem seguir a Collection oficial disponibilizada pela VADU.
