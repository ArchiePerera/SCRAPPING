require 'nokogiri'
require 'pry'
require 'rubocop'
require 'rspec'
require 'open-uri'

def readPage(url)
  #Read the page
  page = Nokogiri::HTML(URI.open(url))
  return page
end

def parseData(page)
  #Get and return the name of the crypto
  content_name = page.xpath('//tbody/tr/td[2]//a/text()')
  content_price = page.xpath('//tbody/tr/td[5]//a/text()')

  return content_name, content_price
end

def returnArrayofHash(content_name, content_price)
  #Return an array of hash like this [{"BITCOIN" => "$ XXX"}]
  array = []
  hash = {}
  i = 0

  content_name.each do |value|
    array << {value.to_s => content_price[i].to_s}
    i += 1
  end
  return array
end

def perform(uri)
  page = readPage(uri)
  content_name, content_price = parseData(page)
  return returnArrayofHash(content_name, content_price)
end

puts perform('https://coinmarketcap.com/all/views/all/')

/html/body/div[1]/div/div[1]/div[2]/div/div/div[2]/table/tbody/tr[4]/td[3]/div/a/div/div/div/