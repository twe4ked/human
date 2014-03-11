# Uses a Twitter archive to find the latest location
# and resolve it to a formatted address.
#
# Suggest using grailbird_updater[1] to keep your archive up to date.
#
# [1]: https://github.com/DeMarko/grailbird_updater

require 'net/http'
require 'json'

class Location
  def location
    {
      source: "https://twitter.com/twe4ked/statuses/#{geo_tweet['id_str']}",
      name: location_name,
      time: geo_tweet['created_at'],
    }
  end

  private

  def location_name
    uri = URI("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{latlng}&sensor=false")
    locations = Net::HTTP.get(uri)
    JSON.parse(locations)['results'].select { |result| result['types'] == %w[locality political] }.first['formatted_address']
  end

  def latlng
    geo_tweet['geo']['coordinates'].join(',')
  end

  def geo_tweet
    @geo_tweet ||= tweets.select { |tweet| tweet['geo'] }.select { |tweet| tweet['geo']['type'] == 'Point' }.first
  end

  def tweets
    json = []
    files.each do |file|
      json << JSON.parse(json file)
    end
    json.flatten.sort_by { |tweet| tweet['created_at'] }.reverse
  end

  def json(file)
    File.read(file, :encoding => 'utf-8').sub(%r{Grailbird.data.tweets_#{date(file)} = }, '')
  end

  def date(file)
    File.basename(file).sub /\..+/, ''
  end

  def files
    if File.directory? tweets_folder
      Dir.glob "#{tweets_folder}/data/js/tweets/*.js"
    else
      raise '"tweets" directory not found'
    end
  end

  def tweets_folder
    ENV['TWEETS_FOLDER']
  end
end
