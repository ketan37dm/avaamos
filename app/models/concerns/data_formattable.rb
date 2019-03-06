module DataFormattable
  extend ActiveSupport::Concern

  included do
    before_create :squish_fields
  end

  private

  def squish_fields
    self.attributes.map { |k, v| v&.squish! if v.is_a? String }
  end
end
