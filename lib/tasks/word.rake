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


  task scrap_odmiany: :environment do |t, false_word|
    # miss:
    # check if good page (not working)
    # check if already exist word
    # relation main_word, false_word

    uri = {}
    uri[:adjectif] = URI("http://odmiana.net/odmiana-przez-przypadki-przymiotnika-#{false_word.downcase}")
    uri[:name]     = URI("http://odmiana.net/odmiana-przez-przypadki-rzeczownika-#{false_word.downcase}")

    uri.each do |type, link|
      post = Nokogiri::HTML(Net::HTTP.get(link))
      if post.css('h1').text != '301 Moved'
        send("analyze_#{type}", post)
      end
    end
  end

  task scrap_conjuguate: :environment do |t, false_word|
    uri = URI("https://fr.bab.la/conjugaison/polonais/#{false_word.downcase}")
    post = Nokogiri::HTML(Net::HTTP.get(uri))
    # miss:
    # check if good page
    # check if already exist word

    main_word_content = post.css('h2').first.content
    main_word_content.slice('polonaisConjugaison de «')
    main_word_content.slice('»')
    main_word_content.strip!
    main_word = Word.new(content: main_word_content, type: 'verbe', mode: 'infinitif')
    main_word.save

    post.css('.conj-tense-wrapper').each do |mode|
      mode_name = mode.css('.conj-block.container.result-block').first.content
      mode.css('.conj-tense-block').each do |time|
        time_name = time.css('.conj-tense-block-header').first.content
        time.css('.conj-item').each do |conjuguate_item|
          pronom  = conjuguate_item.css('.conj-person').first.content
          content = conjuguate_item.css('.conj-result').first.content
          puts "mode: #{mode_name}"
          puts "time:  #{time_name}"
          puts "pronom: #{pronom}"
          puts "content: #{content}"
          # word = Word.new(content: content)
          # word.set_pronom(pronom)
          # word.set_time(time)
          # word.set_mode(mode)
          # word.false_word = fake_word if false_word == content
          # word.main_word = main_word
          # word.save
        end
      end
    end
  end

  def analyze_adjectif(post)
    trs = post.css('tbody tr').drop(1)
    genres = trs.shift.css('td').drop(1).map(&:text)
    trs.each do |tr|
      tds = tr.css('td')
      grammatical_case = tds.shift.text
      tds.each_with_index do |td, i|
        puts td.text
        # word = Word.new(content: td.text)
        # word.set_genre_and_number(genres[i])
        # word.set_case(grammatical_case)
        #miss analyze of colspan
      end
    end
  end

  def analyze_name(post)
    trs = post.css('tbody tr').drop(1)
    trs.each do |tr|
      tds = tr.css('td')
      grammatical_case = tds.shift.text
      tds.each_with_index do |td, i|
        puts td.text
        # word = Word.new(content: td.text)
        # word.set_case(grammatical_case)
        # word.number = i == 0 ? 'singulier' : 'pluriel'
        #miss analyze of colspan
      end
    end
  end

end
