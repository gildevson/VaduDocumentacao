# 5.0 - API para Geração do Report do CreditBox

O processo de geração de relatórios do CreditBox é **assíncrono**, ou seja, utiliza uma requisição para iniciar a geração do report e outra para consultar o progresso e obter o resultado.

O conteúdo do report pode ser gerado nos formatos:

* PDF
* JSON

Abaixo estão descritas as Collections e endpoints necessários para integração com o módulo CreditBox.

---

# 5.0.1 – Collection

## API CreditBox

Collection para utilização no Postman:

* API CreditBox

## Endpoint Base

```text
https://www.creditbox.com.br/CreditBox.dll
```

---

# 5.0.2 – Informações de Acesso

O serviço utiliza:

* Arquitetura REST
* Autenticação JWT (JSON Web Token)

Antes de realizar qualquer consulta, é necessário executar o processo de autenticação utilizando o endpoint:

```text
JSONPegarToken
```

Nessa requisição deverá ser informado o token principal previamente fornecido pela VADU.

O serviço retornará um token temporário que deverá ser utilizado em todas as chamadas subsequentes da API.

## Endpoint Base

```text
https://www.creditbox.com.br/CreditBox.dll
```

---

# 5.0.3 – Adquirindo o Token Temporário

## URL

```http
GET https://www.creditbox.com.br/CreditBox.dll/Autenticacao/JSONPegarToken
```

A chamada acima retorna o token temporário necessário para utilização da API.

## Configuração no Postman

Após obter o token:

1. Copie o token completo;
2. Remova as aspas do valor retornado;
3. Selecione a Collection **API CreditBox**;
4. Abra a aba **Auth**;
5. Cole o token temporário;
6. Clique em **Save**.

Caso o botão Save não esteja visível:

1. Clique nos três pontos (**...**);
2. Selecione **Save**.

---

# 5.0.4 – Exemplo de Token Temporário

A Collection disponibiliza um exemplo de retorno da requisição:

```text
JSONPegarToken
```

O valor retornado será um JWT utilizado nas chamadas subsequentes.

---

# 5.0.5 – Gerar Report

## URL

```http
POST https://www.creditbox.com.br/CreditBox.dll/CreditBoxReport/JSONGerarReport
```

Esta requisição inicia a geração do relatório.

## Retorno

O serviço retorna um identificador único (**ID do Report**) que será utilizado posteriormente para acompanhar o processamento.

---

## Parâmetros da Requisição

A geração do relatório utiliza os seguintes parâmetros:

* CNPJ da empresa consultada;
* Formatos de saída;
* Blocos que deverão compor o relatório.

---

# 5.0.5.1 – Formatos

Os formatos suportados são:

```json
[
  "PDF",
  "JSON"
]
```

É possível solicitar um ou ambos os formatos simultaneamente.

---

# 5.0.5.2 – Blocos

Os dados do relatório estão organizados em quatro seções:

* Cedente
* Sacado
* Gerais
* Exclusivos

> Caso uma seção seja informada sem especificar os blocos, todos os blocos da seção serão incluídos automaticamente.

---

## Seção Cedente

Blocos disponíveis:

* carteiraAtiva
* historicoPagamento
* valorOperado
* ilm
* protestos
* historico

### Exemplo

```json
{
  "cedente": [
    "carteiraAtiva",
    "historicoPagamento",
    "valorOperado"
  ]
}
```

---

## Seção Sacado

Blocos disponíveis:

* carteiraAtiva
* historicoPagamento
* ilm
* protestos
* historico

### Exemplo

```json
{
  "sacado": [
    "carteiraAtiva",
    "historicoPagamento"
  ]
}
```

---

## Seção Gerais

Blocos disponíveis:

* score
* atividade
* socios
* consultas
* protestos
* administradores

### Exemplo

```json
{
  "gerais": [
    "score",
    "atividade",
    "socios"
  ]
}
```

---

## Seção Exclusivos

Blocos disponíveis:

* participacoes
* falencia
* trabalhoEscravo
* participacoesSocios
* evolucaoProtestos
* tributosPGFN

### Exemplo

```json
{
  "exclusivos": [
    "participacoes",
    "falencia",
    "tributosPGFN"
  ]
}
```

---

# 5.0.5.3 – Exemplos de Consulta

A Collection disponibiliza exemplos completos para:

* Solicitação do relatório;
* Retorno de sucesso;
* Retorno de falha.

---

## Exemplo de Retorno com Sucesso

```json
{
  "status": "sucesso",
  "reportId": "123456"
}
```

---

## Exemplo de Retorno com Falha

```json
{
  "status": "erro",
  "mensagem": "Parâmetros inválidos"
}
```

---

# 5.0.6 – Consultar Report

Após iniciar a geração do relatório, utilize o ID retornado para acompanhar o processamento.

## URL

```http
GET https://www.creditbox.com.br/CreditBox.dll/CreditBoxReport/JConsultarReport/{ID_DO_REPORT}
```

### Exemplo

```http
GET https://www.creditbox.com.br/CreditBox.dll/CreditBoxReport/JConsultarReport/123456
```

---

## Retorno

A API retornará:

* Status de processamento;
* Percentual de progresso;
* Conteúdo final do relatório quando concluído.

### Importante

Por questões de segurança e estabilidade:

> Cada ID pode ser consultado apenas uma vez a cada 3 segundos.

Consultas realizadas em intervalos menores serão rejeitadas.

---

# 5.0.7 – Tabelas de Resposta

As tabelas de códigos e respostas retornadas pela API estão disponíveis na documentação oficial da Collection.

---

# 5.0.8 – Exemplos de Consulta

A documentação disponibiliza exemplos para os seguintes cenários:

## Durante a Geração

```json
{
  "status": "processando",
  "progresso": 45
}
```

---

## Falha na Geração

```json
{
  "status": "erro",
  "mensagem": "Falha ao gerar relatório"
}
```

---

## Limite de Consulta Excedido

```json
{
  "status": "erro",
  "mensagem": "Intervalo mínimo de 3 segundos não respeitado"
}
```

---

## Processo Inexistente

```json
{
  "status": "erro",
  "mensagem": "Report não encontrado"
}
```

Este retorno ocorre quando o ID informado não existe ou já foi removido do sistema.
