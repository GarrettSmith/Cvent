require_relative '../spec_helper.rb'

describe Cvent::Event do
  let (:ecode) { "ABCDE-12345-DEFGH-67890" }

  subject { Cvent::Event.new(ecode) }

  it "is an instance of an Event object" do
    subject.should be_an_instance_of Cvent::Event
  end

  describe "when authenticating against a cvent event" do
    context "and all of the necessary user information is provided" do
      context "and the event exists" do
        context "and the user is already recognized by cvent" do
          context "and the user has not previously registered for the event" do
            it "registers the user and sends back a redirect to the confirmation page" do
              stub_request(:post, Cvent::AUTHENTICATION_URL).to_return(status: 302)

              Cvent::Event.new("abc1234").authenticate({first_name: "John", last_name: "Doe"})

              assert_requested :post, Cvent::AUTHENTICATION_URL, times: 1
            end
          end
        end
      end
    end
  end
end
