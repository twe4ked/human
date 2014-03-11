$LOAD_PATH << "#{File.dirname(__FILE__)}/app"

def STDERR.write string
  log = File.new('sinatra-err.log', 'a+')
  log.write string
  super
end
STDERR.sync = true

require 'human'

run Human
