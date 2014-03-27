# Uses a Twitter archive to find the latest location
# and resolve it to a formatted address.

require 'net/http'
require 'json'
require 'twitter'

class Location
  def location
    {
      source: geo_tweet.url,
      name: location_name,
      time: geo_tweet.created_at.dup.utc,
    }
  end

  private

  def location_name
    uri = URI("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng}&sensor=false")
    locations = Net::HTTP.get(uri)
    JSON.parse(locations)['results'].select { |result| result['types'] == %w[locality political] }.first['formatted_address']
  end

  def latlng
    geo_tweet.geo.coordinates.join(',')
  end

  def geo_tweet
    @geo_tweet ||= client.user_timeline('twe4ked').select(&:geo?).first
  end

  def tweets
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end
  end
end
