# 1.0 API Client – Postman

## 1.0.1 Por que utilizar o Postman?

Além da praticidade de ter todos os exemplos e códigos de integração prontos, o Postman é a ferramenta oficial de testes utilizada pelas equipes de desenvolvimento da Vadu.

Dessa forma, ao realizar integrações, caso surjam dúvidas, será mais rápido e simples validar o comportamento das requisições e identificar possíveis problemas em seu código.

### Vantagens do Postman

* Ferramenta gratuita;
* Compatível com Windows, macOS e Linux;
* Converte requisições JSON para diversas linguagens (Python, PHP, Ruby, entre outras);
* Sincronização entre diferentes dispositivos e ambientes.

---

## 1.0.2 Instalação e Usabilidade

Para utilizar o Postman, basta instalar o aplicativo em seu computador ou acessar a versão web.

### Instalação da versão Desktop

Realize o download do instalador e siga as instruções até a conclusão da instalação.

### Utilização da versão Web

Acesse:

```text
https://www.postman.com/
```

Ao acessar o Postman pela primeira vez, será solicitado um login.

> **Observação:** O login é opcional, porém recomendado, pois permite sincronizar suas configurações com sua conta Postman, facilitando o acesso em outros computadores.

Após a instalação ou acesso à plataforma web, configure suas Collections e Ambientes para iniciar os testes.

---

## 1.0.3 Importando uma Collection

A Vadu disponibiliza collections padrão para suas APIs.

Você pode importá-las diretamente para o Postman e utilizar exemplos prontos sem a necessidade de copiar manualmente cada requisição.

### Como importar uma Collection

1. Localize o link da Collection desejada no manual:

   * Collection Motor de Crédito;
   * Collection de envio de NF-e;
   * Outras collections disponíveis.

2. Copie o link da Collection.

3. No Postman, clique no botão **Import**, localizado no canto superior esquerdo.

4. Na tela exibida, selecione a aba **Link**.

5. Cole a URL da Collection.

6. Clique em **Continue**.

A Collection será importada automaticamente.

> **Importante:** As Collections importadas não são atualizadas automaticamente. Sempre utilize a versão mais recente disponível neste manual.

---

## 1.0.4 Executando uma Requisição GET ou POST

Durante este manual serão apresentadas diversas requisições dos tipos GET e POST.

### Criando uma nova requisição

1. No Postman, clique no ícone **+**, localizado próximo ao botão **Import**.
2. Uma nova aba de requisição será aberta.

### Definindo o tipo da requisição

No campo onde aparece o método HTTP:

```text
GET
```

Selecione o método desejado:

* GET
* POST
* PUT
* DELETE
* PATCH
* Outros métodos suportados

Após selecionar o método:

1. Cole a URL da API.
2. Clique em **Send**.

### Configurando a autenticação

Acesse a aba **Authorization**.

Configure os seguintes parâmetros:

| Campo | Valor                       |
| ----- | --------------------------- |
| Type  | Bearer Token                |
| Token | API KEY fornecida pela Vadu |

Após essa configuração, a requisição estará autenticada e pronta para ser enviada.

> **Importante:** Todas as Collections apresentadas neste manual exigem a inclusão da API KEY na aba Authorization. Caso contrário, a requisição não será processada.

---

## 1.0.5 Geração e Tipos de Tokens

Atualmente, a Vadu utiliza autenticação baseada em **JWT (JSON Web Token)**.

Existem dois tipos de tokens utilizados durante o processo de autenticação.

### 1. Token Principal

O Token Principal é obtido no painel de Administração do sistema e fornecido ao cliente.

Sua finalidade é permitir a autenticação inicial nas APIs da plataforma.

### 2. Token Temporário

O Token Temporário é obtido através do endpoint:

```text
https://www.vadu.com.br/vadu.dll/Autenticacao/JSONPegarToken
```

Esse token possui validade de:

```text
18 horas
```

Ele deve ser utilizado nas chamadas subsequentes às APIs da Vadu.

---

# Estrutura do JWT

Os tokens temporários seguem o padrão JWT e são compostos por três blocos codificados em Base64, separados por pontos.

## 1. Header

O Header contém informações sobre:

* Tipo do token;
* Algoritmo de assinatura utilizado.

Atualmente é utilizado:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

---

## 2. Payload

O Payload contém os dados utilizados pela plataforma para identificar a sessão.

Exemplos de informações presentes:

* Identificador do usuário;
* Identificador da empresa;
* Data de emissão;
* Data de expiração;
* Informações de autenticação.

---

## 3. Assinatura

A assinatura garante a integridade do token.

Caso qualquer informação presente no Header ou Payload seja alterada, a assinatura se torna inválida e o token é rejeitado pelo servidor.

---

# Ciclo de Vida do Token

* O Token Temporário possui validade de **18 horas**.
* Caso um novo token seja solicitado durante esse período, o token anterior continuará válido até sua expiração.
* A renovação deve ser realizada por meio da API:

```text
JSONPegarToken
```

sempre que o prazo de expiração estiver próximo.

Essa prática garante a continuidade da comunicação com as APIs da plataforma Vadu.
