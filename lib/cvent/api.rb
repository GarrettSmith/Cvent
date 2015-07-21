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
        @client = Savon.client(
          wsdl: Cvent.config['wsdl'],
          endpoint: server_url,
          ssl_version: :TLSv1,
          soap_header: {
            "tns:CventSessionHeader" => {
              "tns:CventSessionValue" => cvent_session_header
            }
          }
        )
        @authenticated = true
      else
        raise Cvent::ConnectionFailureError.new
      end
    end
  end
end
