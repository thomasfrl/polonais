module Concerns::Taxonomy
  extend ActiveSupport::Concern

  included do
    has_many :words
  end
end