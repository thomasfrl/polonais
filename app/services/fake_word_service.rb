class FakeWordService
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
end
