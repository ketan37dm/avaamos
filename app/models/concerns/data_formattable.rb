module DataFormattable
  included do
    before_create :squish_fields
  end

  private

  def squish_fields
    self.attributes.map { |k, v| v&.squish! }
  end
end
