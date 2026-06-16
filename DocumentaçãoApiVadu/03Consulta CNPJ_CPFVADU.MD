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

### Exemplo de Retorno JSON — CPF

```json
{
  "status": "OK",
  "cpf": "123.456.789-00",
  "nome": "JOÃO DA SILVA SANTOS",
  "dataNascimento": "1985-03-15",
  "sexo": "M",
  "situacaoCadastral": "REGULAR",
  "obito": false,
  "enderecos": [
    {
      "logradouro": "RUA DAS FLORES",
      "numero": "123",
      "complemento": "APTO 45",
      "bairro": "JARDIM PRIMAVERA",
      "municipio": "SÃO PAULO",
      "uf": "SP",
      "cep": "01234-567"
    }
  ],
  "telefones": [
    {
      "ddd": "11",
      "numero": "98765-4321",
      "tipo": "CELULAR"
    }
  ],
  "emails": [
    {
      "email": "joao.silva@email.com"
    }
  ]
}
```

> **Nota:** Os dados retornados respeitam as limitações da LGPD. Algumas informações podem estar omitidas ou mascaradas conforme as regras vigentes.

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

### Exemplo de Retorno JSON — CNPJ

```json
{
    "CnpjCpf": "07.139.978/0001-88",
    "Nome": "DTA COMERCIAL LTDA",
    "NomeFantasia": "DTA DISTRIBUIDORA",
    "Logradouro": "RODOVIA GOVERNADOR MARIO COVAS",
    "NumeroLogradouro": "11206",
    "ComplementoEndereco": "PAVMTO03",
    "BairroEndereco": "SERRA DO ANIL",
    "MunicipioEndereco": "CARIACICA",
    "UfEndereco": "ES",
    "TelefonePrincipal": "(27) 3770-1800 / (27) 3216-6026",
    "EmailPrincipal": "processos@icc.cnt.br",
    "Site": "",
    "ReceitaSituacao": "ATIVA",
    "ReceitaDataSituacao": "2004-12-07T00:00:00.000",
    "ReceitaMotivoSituacao": "",
    "ReceitaTipo": "MATRIZ",
    "ReceitaAbertura": "2004-12-07T00:00:00.000",
    "ReceitaNaturezaJuridica": "206-2 - Sociedade Empresária Limitada",
    "ReceitaEFR": "",
    "ReceitaSituacaoEspecial": "",
    "ReceitaDataSituacaoEspecial": null,
    "ReceitaCapitalSocial": 400000,
    "CadastroRaizCNPJ_Id": 7139978,
    "Nire": "32.600.096.315",
    "SimplesNacional": false,
    "SIMEI": false,
    "SimplesNacionalSIMEIConsultaDe": "2021-09-14T00:00:00.000",
    "Porte": "EPP",
    "ReceitaAtividade": "45.30-7/01 Comércio por atacado de peças e acessórios novos para veículos automotores",
    "ReceitaAtividadeSecundaria": "45.41-2/02 Comércio por atacado de peças e acessórios para motocicletas e motonetas\n45.30-7/02 Comércio por atacado de pneumáticos e câmaras-de-ar\n46.81-8/05 Comércio atacadista de lubrificantes",
    "VaduAtividadeCNAE": "Comércio",
    "ReceitaMatrizCapitalSocial": 400000,
    "CepEnderecoFormatado": "29147-030",
    "Socios": [
        {
            "Qualificacao": "49-Sócio-Administrador",
            "PaisOrigem": "",
            "QualificacaoRepresentanteLegal": "",
            "Nome": "RAPHAELLA LORENZONI FALCHETTO TANAKA",
            "NomeRepresentanteLegal": null
        }
    ],
    "retConsCad": {
        "consultaComSucesso": true,
        "infCons": {
            "verAplic": "",
            "cStat": 111,
            "xMotivo": "Consulta cadastro com uma ocorrencia",
            "UF": "ES",
            "CNPJ": "07139978000188",
            "CPF": null,
            "dhCons": "2026-05-04T10:03:06.648",
            "cUF": 32,
            "infCad": [
                {
                    "IE": "082306273",
                    "CNPJ": "7139978000188",
                    "CPF": null,
                    "UF": "ES",
                    "cSit": 1,
                    "indCredNFe": 4,
                    "indCredCTe": 4,
                    "xNome": "GF DISTRIBUIDORA DE PECAS EIRELI EPP",
                    "xRegApur": "NÃO INFORMADO",
                    "CNAE": "4530701",
                    "dIniAtiv": "2005-03-03T00:00:00.000",
                    "dUltSit": "2013-05-27T00:00:00.000",
                    "dBaixa": null,
                    "tipoIE": "NÃO INFORMADO",
                    "situacaoIE": "Habilitado",
                    "situacaoCNPJ": "Sem restrição",
                    "dfeHabilitados": "Nenhum",
                    "ender": {
                        "xLgr": "RUA CLARICE LISPECTOR",
                        "nro": "122",
                        "xCpl": "GALPAO AREA 26 CONTORNO",
                        "xBairro": "SERRA DO ANIL",
                        "cMun": "3201308",
                        "xMun": "Cariacica",
                        "CEP": "29147025"
                    }
                }
            ]
        },
        "log": [
            {
                "uf": "ES",
                "mensagem": "Contribuintes de ES foram encontrados via webService da receita"
            }
        ]
    },
    "qtdFunc": 14,
    "qtdFuncMatriz": 14,
    "CodIbge": "3201308",
    "Filiais": [
        {
            "cnpj": "07.139.978/0001-88",
            "municipioEndereco": "CARIACICA",
            "ufEndereco": "ES",
            "receitaSituacao": "ATIVA"
        },
        {
            "cnpj": "07.139.978/0002-69",
            "municipioEndereco": "VITORIA",
            "ufEndereco": "ES",
            "receitaSituacao": "BAIXADA"
        }
    ],
    "Fornecedores": [
        {
            "cnpj": "07.262.105/0001-68",
            "nome": "DAINAPECK DISTRIBUIDORA DE COMPONENTES AUTOMOTIVOS LTDA."
        }
    ],
    "RecursoAmbiental": {
        "dataAtualizacao": null,
        "score": 0,
        "nivel": "Sem risco",
        "potencialidade": "Sem risco"
    },
    "atualizado": true
}
```
