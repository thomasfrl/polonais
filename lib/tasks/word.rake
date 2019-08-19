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
end
