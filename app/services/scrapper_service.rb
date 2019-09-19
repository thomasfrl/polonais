class ScrapperService
  def initialize(fake_words)
    fake_words.each do |fake_word|
      DeclinaisonScrapperService.new(fake_word).process
      ConjugateScrapperService.new(fake_word).proces
    end
  end
end
