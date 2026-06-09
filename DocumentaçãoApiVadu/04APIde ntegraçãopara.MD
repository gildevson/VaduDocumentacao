# 4.0 - API de Integração para o Módulo de Consulta NF-e

A seguir estão listadas as Collections utilizadas na integração com o módulo de monitoramento de eventos de Notas Fiscais Eletrônicas (NF-e).

O monitoramento é realizado para notas emitidas em até:

* **45 dias** para consultas via **SEFAZ**;
* **30 dias** para consultas via **SERPRO**.

Após esse período, o usuário ainda poderá consultar as notas manualmente na plataforma, porém os novos eventos não serão atualizados automaticamente.

Utilize as Collections abaixo em seu Postman para realizar testes e integrações.

---

# 4.0.1 – Collection de Envio de Chaves para Monitoramento

**Link da Collection:**

* Collection - Envio de Chaves para Monitoramento

---

# 4.0.2 – Endpoint para Envio de JSON

## URL

```text
https://www.vadu.com.br/vadu.dll/ServicoNFe2/JSON
```

## Método

```http
POST
```

## Corpo da Requisição (Body)

Na aba **Body → raw**, envie o seguinte JSON:

```json
{
  "credencial": {
    "appId": "",
    "appSecret": ""
  },
  "documentos": [
    {
      "chaveAcesso": "35180200233695000151550100003190581009693188"
    },
    {
      "chaveAcesso": "35180200233695000151550100003190171001565765"
    }
  ]
}
```

### Credenciais

Os campos abaixo são fornecidos pela VADU:

* `appId`
* `appSecret`

---

## Resposta de Sucesso

Quando o envio for realizado corretamente, a API retornará:

```http
200 OK
```

Além disso, será retornado um JSON semelhante ao exemplo abaixo:

```json
{
  "status": {
    "codigo": "00"
  },
  "documentosErro": [
    {
      "chaveAcesso": "35180200233695000151550100003190171001565764"
    }
  ],
  "documentos": [
    {
      "chaveAcesso": "35180200233695000151550100003190581009693188"
    },
    {
      "chaveAcesso": "35180200233695000151550100003190171001565765"
    }
  ]
}
```

---

## Interpretação da Resposta

### Status

```json
{
  "codigo": "00"
}
```

Indica que o envio foi realizado com sucesso e as notas fiscais serão incluídas no monitoramento conforme os critérios previamente definidos.

### Documentos Aceitos

Os documentos processados com sucesso são retornados na propriedade:

```json
"documentos"
```

### Documentos Rejeitados

Os documentos que não puderam ser aceitos são retornados na propriedade:

```json
"documentosErro"
```

---

# 4.0.3 – Retorno dos Eventos

Para receber os eventos monitorados, é necessário disponibilizar um serviço HTTP capaz de receber requisições do tipo:

```http
POST
```

A VADU enviará os eventos para uma URL de Postback previamente cadastrada.

## Cadastro da URL de Postback

A URL deve ser enviada para:

```text
suporte.vadu@dimensa.com.br
```

### Assunto do e-mail

```text
URL de postback
```

### Informações recomendadas

Caso aplicável, informe também:

* Horários de indisponibilidade do servidor;
* Restrições de acesso por geolocalização;
* Regras de firewall;
* Particularidades da infraestrutura.

---

## Exemplo de XML Recebido

O XML será enviado no corpo da requisição HTTP:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<notificacaoEvento>
    <chaveAcesso>23150404311391000116550030000333341764573103</chaveAcesso>
    <status>AUTORIZADA</status>
    <tipo>NFE</tipo>

    <evento>
        <codigo>410</codigo>
        <descricao>Ciência da Operação</descricao>
        <dataEvento>29/04/2015 18:19:06</dataEvento>
        <protocolo>891150273135770</protocolo>
    </evento>
</notificacaoEvento>
```

---

## Campos do XML

| Campo       | Descrição                     |
| ----------- | ----------------------------- |
| chaveAcesso | Chave de acesso da NF-e       |
| status      | Situação atual da nota        |
| tipo        | Tipo do documento fiscal      |
| codigo      | Código do evento ocorrido     |
| descricao   | Descrição do evento           |
| dataEvento  | Data e hora do evento         |
| protocolo   | Número do protocolo do evento |

> Os campos são autoexplicativos. A única informação complementar necessária é a tabela de códigos dos eventos, disponibilizada na sequência deste manual.
