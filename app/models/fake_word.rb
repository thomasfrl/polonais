class FakeWord < ApplicationRecord
  has_many :words

  def decorate_content
    content.downcase.strip
  end

end
