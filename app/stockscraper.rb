#stock scraper for droid bot
require 'pry'
require 'rest-client'
require 'json'
def get_stock_value(symbol)
  url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{symbol}&interval=15min&outputsize=full&apikey=7NSC7Q3PC9UOG5C6"
  stock_data = RestClient.get(url)
  stock_hash = JSON.parse(stock_data)
  
  if stock_hash["Error Message"]
    return nil
  end
  hash = stock_hash["Time Series (15min)"].first[1]["4. close"]
end
