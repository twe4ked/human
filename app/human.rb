require 'sinatra/base'
require 'location'

class Human < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    {
      _links: {
        location: {
          href: "#{request.url.sub(%r{#{request.path}$}, '')}/location.json"
        }
      }
    }.to_json
  end

  get '/location.json' do
    Location.new.location.to_json
  end
end
