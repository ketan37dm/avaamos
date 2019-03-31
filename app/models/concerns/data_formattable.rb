module DataFormattable
  extend ActiveSupport::Concern

  included do
    before_validation :squish_fields
  end

  private

  def squish_fields
    self.attributes.map { |k, v| v&.downcase&.squish! if v.is_a? String }
  end
end
