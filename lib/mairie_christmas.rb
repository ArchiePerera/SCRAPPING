require 'nokogiri'
require 'pry'
require 'rubocop'
require 'rspec'
require 'open-uri'

page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com/val-d-oise.html"))

def get_townhall_email(townhall_url)
  page = Nokogiri::HTML(URI.open(townhall_url))
  townhall_email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
  return townhall_email
end

def get_townhall_urls(page)
  array_of_urls = []
  for i in (8..192)
    town_url = page.css('table table a')[i]['href']
    town_final_url = "https://www.annuaire-des-mairies.com" + town_url[1..town_url.length-1]
    array_of_urls << town_final_url
  end
  return array_of_urls
end

def get_townhall_names(page)
  array_of_names = []
  for i in (8..192)
    town_name = page.css('table table a')[i].text
    town_final_name = town_name.capitalize
    array_of_names << town_final_name
  end
  return array_of_names
end

def final_array_of_hashes(array_of_urls, page)
  final_array = []
  array_of_urls = get_townhall_urls(page)
  for i in (0..184)
    final_hash = Hash.new
    emails = get_townhall_email(array_of_urls[i])
    final_hash[get_townhall_names(page)[i]] = emails
    final_array << final_hash
  end
  p final_array
end

final_array_of_hashes(get_townhall_urls(page), page)