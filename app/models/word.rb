class Word < ApplicationRecord
  before_save :check_if_unique

  def associated_words
    self.associated_ids.map {|id| Word.find(id)}
  end

  def total_counter
    total = counter
    associated_words.each do |word|
      total + word.counter
    end
    total
  end

  scope :all_main, -> { where(main: true, valid: true).order( : :desc) }
  scope :valid, -> { where(valid: true).order(counter: :desc) }
  scope :not_valid, -> { where(valid: false).order(counter: :desc) }

  private

  def check_if_unique
    if where(content: content).empty?
      valid = false
      return true
    end 
  end
end
