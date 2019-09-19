class ScrapperService
  def initialize(origin)
    File.open(origin, 'r') do |file|
      file.each do |line|
        content, counter = line.split
        unless FakeWord.all.pluck(:content).include? content
          FakeWord.create(content: content, counter: counter.to_i)
        end
      end
    end
  end

  def process
    FakeWord.all.each do |fake_word|
      DeclinaisonScrapperService.new(fake_word).process
      ConjugateScrapperService.new(fake_word).proces
    end
  end
end
