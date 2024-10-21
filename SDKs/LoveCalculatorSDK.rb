require 'dotenv/load'
require 'httparty'
require "json"

# Wrapper class for Love Calculator API
# Documentation: https://github.com/0xharshrastogi/love-calculator-api
class LoveCalculatorSDK
  include HTTParty
  # This is an azure VM I spun up which is hosting the API. Only existing one I found was unfortunately closed.
  base_uri 'http://20.55.107.46:8000/api/v1'

  def initialize
  end

  # fetcher for getting love percentage between two names
  def get_love_percentage(name1, name2)
    response = self.class.get("/calculate", {:query=>{:personA=>name1, :personB=>name2}})

    # Error handling
    if response.success?
      JSON.parse(response.body)
    else
      { error: "API request failed with status code: #{response.code}" }
    end
  rescue SocketError => e
    { error: "Network error: #{e.message}" }
  end

  # Make concurrent calls for the list of names passed.
  def get_love_percentage_bulk(name1, names)
    # Track threads and results
    threads = []
    loves = []

    # Start a thread for each name in the list
    names.each do |name|
      threads << Thread.new do
        result = get_love_percentage(name, name1)

        # If there was an error just dont include it in the returned array
        if result[:error]
          puts "Errored fetch for love calculation between #{name1} and #{name}!"
        else
          loves.push(result)
        end
      end
    end

    # Wait for all threads to finish
    threads.each(&:join)

    # return the result array
    loves
  end
end

