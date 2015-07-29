require 'byebug'

module Cvent
  class Api
    extend Savon::Model

    def self.client(globals={})
      authenticate unless authenticated?
      super(globals)
    end

    operations :add_advanced_logic,
      :check_in,
      :copy_event,
      :create_approver,
      :create_budget_item,
      :create_contact,
      :create_contact_group,
      :create_conversion_rate,
      :create_custom_field,
      :create_distribution_list,
      :create_meeting_request,
      :create_no_reg_event,
      :create_post_event_feedback,
      :create_rate_history,
      :create_rfp,
      :create_session,
      :create_survey_answer,
      :create_transaction,
      :create_user,
      :delete_approver,
      :delete_budget_item,
      :delete_contact,
      :delete_conversion_rate,
      :delete_rate_history,
      :delete_user,
      :describe_cv_object,
      :describe_global,
      :get_deleted,
      :get_updated,
      :manage_contact_group_members,
      :manage_distribution_list_members,
      :manage_user_group,
      :retrieve,
      :search,
      :send_email,
      :session_reg_action,
      :simple_event_registration,
      :transfer_invitee,
      :update_approver,
      :update_contact,
      :update_custom_field,
      :update_event_parameters,
      :update_invitee_internal_info,
      :update_meeting_request,
      :update_session,
      :update_user,
      :upsert_contact,
      :validate_invitee

    def self.retrieve(type, ids)
      super message: {
        ObjectType: type,
        'ins0:Ids' => {
          'ins0:Id' => ids
        }
      }
    end

    def self.search(type, search_type, opts = {})
      raise "Invalid Search Type: \'#{search_type}\'" unless self.valid_search_type? search_type
      super message: {
        ObjectType: type,
        'ins0:CvSearchObject' => {
          attributes!: {
            'ins0:SearchType' => search_type
          },
          'ins0:Filter' => search_filter(opts)
        }
      }
    end

    private

    def self.authenticated?
      @authenticated
    end

    def self.authenticate
      account = Cvent.config['account']
      username = Cvent.config['username'],
      password = Cvent.config['password']
      response = Authenticator.login account, username, password
      login_result = response.body[:login_response][:login_result]
      if response.success? && login_result[:@login_success]
        cvent_session_header = login_result[:@cvent_session_header]
        server_url = login_result[:@server_url]
        @client = Savon.client do
          convert_request_keys_to :camelcase
          endpoint server_url
          soap_version 2
          ssl_version :TLSv1
          wsdl Cvent.config['wsdl']
          soap_header 'tns:CventSessionHeader' => {
            'tns:CventSessionValue' => cvent_session_header
          }
        end
        @authenticated = true
      else
        raise Cvent::ConnectionFailureError.new
      end
    end

    def self.valid_search_type?(search_type)
      ['AndSearch'].include? search_type
    end

    def self.search_filter(opts)
      opts.map do |field, value|
        {
          'ins0:Field' => field,
          'ins0:Operator' => "Equals",
          'ins0:Value' => value
        }
      end
    end
  end
end
