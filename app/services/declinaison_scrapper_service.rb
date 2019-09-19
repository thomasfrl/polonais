class DeclinaisonScrapperService
  attr_accessor :post, :fake_word, :uri, :words
  @@adresses = { adjectif: 'http://odmiana.net/odmiana-przez-przypadki-przymiotnika-',
                 name:     'http://odmiana.net/odmiana-przez-przypadki-rzeczownika-' }

  def initialize(fake_word)
    @main_word      = Word.new
    @words          = []
    @fake_word      = fake_word.downcase
    @uri            = {}
    %i[adjectif name].each do |type|
      @uri[type] = URI(@@adresses[type] + @fake_word)
    end
  end

  def process
    uri.each do |type, link|
      post = Nokogiri::HTML(Net::HTTP.get(link))
      if post.css('h1').text != '301 Moved'
        send("analyze_#{type}")
      end
    end
  end

  private

  def analyze_adjectif
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
        # set_fake_word(word)
        # words << word
        # set_main_word(word)
        #miss analyze of colspan
      end
    end
    save_words
  end

  def analyze_name
    analyze_word do |content, grammatical_case|
      word = Word.new(content: content)
      word.set_case(grammatical_case)
      word.number = (i == 0 ? 'singulier' : 'pluriel')
    end
  end

  def analyze_word
    trs = post.css('tbody tr').drop(1)
    trs.each do |tr|
      tds = tr.css('td')
      grammatical_case = tds.shift.text
      tds.each_with_index do |td, i|
        yield(td.text, grammatical_case) if block_given?

        set_fake_word(word)
        set_main_word(word)
        words << word
        #miss analyze of colspan
      end
    end
    save_words
  end

  def save_words
    words.each do |word|
      word.main_word = @main_word
      word.type      = :nom_commun
      word.save
    end
  end

  def set_main_word(word) #dans model?
    if word.number == 'singulier' && word.grammatical_case == 'nominatif'
      word.main  = true
      @main_word = word
    end
  end

  def set_fake_word(word)
    word.fake_word = fake_word if fake_word.content == word.content
  end
end
