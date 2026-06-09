# 3.0 - Consulta CNPJ/CPF VADU

Esta API permite a consulta de informações cadastrais de empresas e pessoas físicas informadas na requisição.

## Informações retornadas

### Consulta de Empresa (CNPJ)

Serão retornadas informações cadastrais provenientes da Receita Federal.

### Consulta de Pessoa Física (CPF)

Serão retornados dados cadastrais disponíveis na base da VADU, respeitando as limitações impostas pela LGPD (Lei Geral de Proteção de Dados).

### Collection

**Link da Collection – Consulta CNPJ/CPF (Dados Cadastrais)**

> Disponibilizado pela VADU.

---

# 3.0.1 - Consultar CPF

Para consultar um CPF utilizando a Collection já importada:

## Passo 1 - Configurar a autenticação

Na aba **Authorization**:

| Campo | Valor                      |
| ----- | -------------------------- |
| Type  | Bearer Token               |
| Token | APIKEY fornecida pela VADU |

---

## Passo 2 - Informar o CPF

No endpoint da requisição **POST**, informe o CPF após o trecho:

```text
.../ConsultaPF/
```

### Exemplo

```text
.../ConsultaPF/12345678900
```

> Informe apenas os números do CPF, sem pontos ou traços.

---

## Passo 3 - Executar a consulta

Clique em:

```text
SEND
```

---

## Resultado

O retorno da consulta será exibido na parte inferior do Postman, na aba **Body** da resposta.

---

# 3.0.2 - Consultar CNPJ

Para consultar um CNPJ utilizando a Collection já importada:

## Passo 1 - Configurar a autenticação

Na aba **Authorization**:

| Campo | Valor                      |
| ----- | -------------------------- |
| Type  | Bearer Token               |
| Token | APIKEY fornecida pela VADU |

---

## Passo 2 - Informar o CNPJ

No endpoint da requisição **POST**, informe o CNPJ após o trecho:

```text
.../Consulta/
```

### Exemplo

```text
.../Consulta/12345678000199
```

> Informe apenas os números do CNPJ, sem pontos, barras ou traços.

---

## Passo 3 - Executar a consulta

Clique em:

```text
SEND
```

---

## Resultado

O retorno da consulta será exibido na parte inferior do Postman, na aba **Body** da resposta.

As informações retornadas corresponderão aos dados cadastrais do CNPJ consultado.
