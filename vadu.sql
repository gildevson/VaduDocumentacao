
select 
CadastroBase.Razao,
CadastroBase.CPFCNPJ,

* from VaduDetalheTemp

INNER JOIN CadastroBaseConsulta ON VaduDetalheTemp.CadastroBaseConsultaId = CadastroBaseConsulta.Id
INNER JOIN CadastroBase ON CadastroBase.Id = CadastroBaseConsulta.CadastroBaseId
INNER JOIN Cliente ON Cliente.CadastroBaseId = CadastroBase.Id

where VaduDetalheTemp.Id = '91098CFE-60B7-4DF3-BDFD-012B2765F99E'


SELECT * FROM VaduDetalheTemp --91098CFE-60B7-4DF3-BDFD-012B2765F99E