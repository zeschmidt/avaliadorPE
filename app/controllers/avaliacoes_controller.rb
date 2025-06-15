
class AvaliacoesController < ApplicationController
  def index
  end

  def gerar
    entrada = """
Todos os fatores do SWOT foram preenchidos
Nenhum registro do SWOT vencido
O indicador de favorabilidade está positivo
Objetivos
O percentual de desempenho por meta atingida dos objetivos estratégicos deste ano está em 49%
Mais de 50% dos objetivos possuem indicadores e metas
Mais de 50% dos objetivos possuem projetos ou processos

Indicadores
Mais de 50% dos indicadores estão atualizados
Mais de 50% dos indicadores não atingidos não possuem Fato-Causa-Ação
Mais de 50% dos indicadores possuem metas atingidas

Projetos
Mais de 50% dos projetos não estão atrasados
Mais de 50% das ações não estão atrasadas
Mais de 50% das ações possuem responsáveis

Processos
Mais de 50% dos processos não estão atrasados
Mais de 50% das ações não estão atrasadas
Mais de 50% das ações possuem responsáveis

Usuários
8 usuários e seguidores não acessaram o sistema neste mês
A média de eficácia dos coordenadores dos indicadores é 48.63%
A média de eficácia dos responsáveis dos indicadores é 59.87%
A média de eficácia dos coordenadores dos projetos/processos é 69.46%
A média de eficácia dos responsáveis das ações é 77.24%
"""

    resultado = ChatgptService.nova_avaliacao(entrada)

    @fortes = resultado[:fortes].split("\n").map(&:strip)
    @fracos = resultado[:fracos].split("\n").map(&:strip)
    @recomendacoes = resultado[:recomendacoes].split("\n").map(&:strip)

    render :resultado
  end
end
