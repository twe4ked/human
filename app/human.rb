require 'sinatra/base'
require 'location'

class Human < Sinatra::Base
  before do
    content_type :json
  end

  get '/location.json' do
    Location.new.location.to_json
  end
end
