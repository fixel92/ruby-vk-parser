class OnlineTableSender
  def send(data)
    Output.new.send_report(HtmlSender.new, data)
    remove_folder
    create_folder
    share_folder
    remove_old_file
    upload_file
    message
  end

  private

  def message
    puts "Success! Your table is here - https://drv.tw/~#{GMAIL}/gd/web/index.html"
  end

  def session
    @session ||= GoogleDrive::Session.from_config('client_secret.json')
  end

  def create_folder
    session.create_folder('web') if session.folders_by_name('web').nil?
  end

  def remove_folder
    session.folders_by_name('web')&.delete(true)
  end

  def folder
    session.folders_by_name('web')
  end

  def share_folder
    folder.acl.push({ type: 'anyone', role: 'reader' })
  end

  def remove_old_file
    session.spreadsheet_by_name('web')&.delete(true)
  end

  def upload_file
    folder.upload_from_file('my_output.html', 'index.html', convert: false)
  end
end
