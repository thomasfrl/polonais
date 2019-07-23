class Word < ApplicationRecord
  before_save :check_if_unique


  %w[word type personn grammatical_case number gender].each do |association|
    define_method("associated_#{association.pluralize}") do
      self.send("#{association}_ids".to_sym).map { |id| association.camelize.constantize.find(id) }
    end

    define_method("#{association}_values") do
      self.send("#{association}_ids".to_sym).map { |id| association.camelize.constantize.find(id).value }
    end
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
