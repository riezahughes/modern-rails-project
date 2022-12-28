module PhoneCallsHelper

  def phone_call_default_client(client_from_edit, client_file_from_params)
    return client_from_edit unless client_from_edit.nil? || client_from_edit.id.nil?

    return client_file_from_params.client unless client_file_from_params.nil?

    nil
  end

  def phone_call_default_client_id(client_from_edit, client_file_from_params)
    client = phone_call_default_client(client_from_edit, client_file_from_params)

    return client.id unless client.nil?

    nil
  end

end
