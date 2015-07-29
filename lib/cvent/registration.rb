require_relative 'model'
module Cvent
  class Registration < Cvent::Model
    def self.authenticate(email, confirmation)
      search EmailAddress: email, ConfirmationNumber: confirmation
    end
  end
end
