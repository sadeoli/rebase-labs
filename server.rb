require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require_relative './import_from_csv'

get '/tests' do
  ImportCSV.new.all.to_json
end

get '/import' do
  ImportCSV.new.all.to_json
end


Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)