
require 'net/http'
require 'json'

class ChatgptService
  OPENAI_API_KEY = ENV['OPENAI_API_KEY']

  def self.nova_avaliacao(entrada)
    prompt = <<~PROMPT
      Você é um especialista em planejamento estratégico corporativo.

      Com base nos dados abaixo, faça uma avaliação crítica do planejamento estratégico.

      Sua resposta DEVE conter exatamente três seções com estes títulos em negrito, SEM numeração e SEM repetições:

      **Pontos fortes**
      **Pontos a melhorar**
      **Recomendações**

      - Em "Pontos fortes" e "Pontos a melhorar", forneça apenas tópicos curtos, com poucas palavras, sem explicações longas.
      - Em "Recomendações", escreva um parágrafo contínuo, com sugestões práticas e claras.

      ---

      Dados:
      #{entrada}
    PROMPT

    uri = URI("https://api.openai.com/v1/chat/completions")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{OPENAI_API_KEY}"

    request.body = {
      model: "gpt-3.5-turbo",
      temperature: 0.4,
      messages: [
        { role: "system", content: "Você é um especialista em planejamento estratégico corporativo." },
        { role: "user", content: prompt }
      ]
    }.to_json

    response = http.request(request)
    resposta = JSON.parse(response.body)["choices"][0]["message"]["content"]

    {
      fortes: extrair_secao(resposta, "Pontos fortes", "Pontos a melhorar"),
      fracos: extrair_secao(resposta, "Pontos a melhorar", "Recomendações"),
      recomendacoes: extrair_secao(resposta, "Recomendações")
    }
  end

  def self.extrair_secao(texto, titulo_atual, proximo_titulo = nil)
    if proximo_titulo
      regex = /\*\*#{Regexp.escape(titulo_atual)}\*\*\s*(.+?)\s*\*\*#{Regexp.escape(proximo_titulo)}\*\*/im
    else
      regex = /\*\*#{Regexp.escape(titulo_atual)}\*\*\s*(.+)/im
    end
    match = texto.match(regex)
    match ? match[1].strip : "Não identificado"
  end
end
