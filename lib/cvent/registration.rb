require_relative 'model'
module Cvent
  class Registration < Cvent::Model
    def self.authenticate(email, confirmation)
      search EmailAddress: email, ConfirmationNumber: confirmation
    end

    def initialize(hash)
      super

      # Create a accessor for each order detail product type
      groups = Array(order_detail).group_by { |item| item.product_type }
      groups.each { |k, v| define_reader "#{k}s", v }
    end
  end
end
