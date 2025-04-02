require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, 4567

get '/vagas' do
  content_type :json
  if File.exist?("vagas.json")
    File.read("vagas.json")
  else
    { error: "Nenhum dado disponível. Execute o scraper primeiro." }.to_json
  end
end
