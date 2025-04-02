require "httparty"
require "nokogiri"

response = HTTParty.get("https://www.vagas.com.br/vagas-de-Fleury", 
    headers: {
        "User-agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    }
)

document = Nokogiri::HTML(response.body)

num_vagas = document.at_css("div.faixa.clearfix h1")&.text&.strip
puts "#{num_vagas} disponíveis, sendo elas:"

vagas = document.css("div.informacoes-header")

vagas.each do |vaga|
    cargo = vaga.at_css("h2.cargo")&.text&.strip
    link = vaga.at_css("h2.cargo a.link-detalhes-vaga")&.[]("href")
puts "Cargo: #{cargo}"
puts "Link: https:/#{link}"
end