class PandaController < ApplicationController

  # override rails' default csrf check to use the json encoded payload instead of params
  def verify_authenticity_token
    handle_unverified_request unless (form_authenticity_token == upload_payload['csrf'])
  end

  def upload_payload
    @upload_payload ||= JSON.parse(params['payload'])
  end

  def authorize_upload
    upload = Panda.post('/videos/upload.json', {
      file_name: upload_payload['filename'],
      file_size: upload_payload['filesize'],
      profiles: "h264,thumbnail",
    })

    render :json => {:upload_url => upload['location']}
  end
end