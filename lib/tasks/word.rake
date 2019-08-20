require 'nokogiri'
require 'open-uri'

namespace :word do
  desc "TODO"
  task init: :environment do
    File.open('/home/thomas/Documents/Polonais/polish.txt', 'r') do |file|
      file.each do |line|
        content, counter = line.split
        unless FakeWord.all.pluck(:content).include? content
          FakeWord.create(content: content, counter: counter.to_i)
        end
      end
    end
  end


  task scrap_odmiany: :environment do |t, word|
    page = Nokogiri::HTML(open("http://odmiana.net/odmiana-przez-przypadki-rzeczownika-#{word.downcase}"))
    # puts page.css('.ekran')
  end

  task scrap_conjuguate: :environment do |t, word|
    uri = URI("https://fr.bab.la/conjugaison/polonais/#{word.downcase}")
    post = Net::HTTP.get(uri)
    # check if good page
    # look for each 'word' in the page
    # for each word 'analyse' word
    # for each new word save the word
    post.css('#conjFull > div:nth-child(2)').each do |element|
      element.content
    end
  end
end
