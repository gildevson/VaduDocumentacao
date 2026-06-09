# Introdução

Este manual tem por objetivo esclarecer as mais variadas possibilidades de integração via API com a plataforma Vadu. A partir do índice, você poderá navegar nas informações de acordo com suas necessidades.

A seguir, você encontrará um resumo dos temas abordados neste manual. Eles estão divididos de acordo com as funcionalidades de cada API disponibilizada.

---

# 1.0 Integração com o Motor de Crédito

Para essa opção, disponibilizamos no tópico **2.0 – Integração do Motor de Crédito** todo o processo que deve ser executado de maneira numerada (através de collections), desde o envio da análise até a sua conclusão e obtenção do resultado.

Também disponibilizamos, no link abaixo, o arquivo com as variáveis necessárias para envio de informações ao motor durante a requisição de análise.

**Link para envio de informações durante a análise:**

* Tabela de Variáveis

---

# 1.1 Envio de NF para Monitoramento

O Vadu disponibiliza para seus clientes uma API para monitorar eventos de Notas Fiscais de Venda emitidas através de NF-e.

Para isso, disponibilizamos este tópico específico com instruções sobre como realizar o monitoramento e manter as informações integradas ao seu sistema de gestão.

Para o envio de chaves para monitoramento, consulte o tópico **4.0 – API de Integração para o módulo de consulta NF-e**, que contém:

* Collection de envio de chaves para monitoramento;
* Detalhamento das consultas NF-e;
* Informações necessárias para integração.

---

# 1.2 Integração via API ao Sistema

O CreditBox disponibiliza uma API para geração de relatórios (*reports*), permitindo integração com sistemas próprios para geração de rating de crédito.

O módulo **SINDC (Sistema Integrado Nacional para Decisão de Crédito)** foi criado com o conceito de ser o SCR do BACEN, com exclusividade para os segmentos:

* Fomento Mercantil;
* Empresas Simples de Crédito (ESC);
* Securitizadoras;
* Factorings;
* Fundos de Investimento em Direitos Creditórios (FIDC).

Para mais detalhes sobre a integração, consulte o tópico:

**5.0 – API para geração do Report do CreditBox**

Este tópico contém todas as instruções necessárias para comunicação com a API.

> **Observação:** Funcionalidade exclusiva para o segmento financeiro.

---

# 1.3 Integração via API ao SCR do Bacen

## SCR - Sistema de Informações de Crédito do Banco Central do Brasil

O SCR é um sistema utilizado pelo Banco Central do Brasil para registro e acompanhamento das operações de crédito realizadas pelas instituições financeiras.

### Principais características

* Registros de crédito cujo risco direto na instituição financeira (somatório de operações de crédito, repasses interfinanceiros, coobrigações, limites e créditos a liberar) seja igual ou superior a **R$ 200,00** são registrados individualmente no SCR.

* O SCR é um instrumento gerido pelo Banco Central e alimentado mensalmente pelas instituições financeiras.

* O sistema permite à supervisão bancária a adoção de medidas preventivas, aumentando a eficácia da avaliação dos riscos inerentes à atividade financeira.

* Por meio dele, o Banco Central consegue identificar operações de crédito atípicas e de alto risco, sempre preservando o sigilo bancário.

* O SCR é um importante mecanismo utilizado pela supervisão bancária para acompanhar as instituições financeiras e auxiliar na prevenção de crises.

### API de Consulta ao SCR

O Vadu disponibiliza uma API completa para realização de consultas ao SCR.

Para mais informações, consulte o tópico:

**6.0 – API para Consultas ao SCR**
