
Rails.application.routes.draw do
  root to: 'avaliacoes#index'
  post 'avaliacoes/gerar', to: 'avaliacoes#gerar', as: 'gerar_avaliacao'
end
