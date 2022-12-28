module ClientFilesHelper

  include Reports::AccountExpenditureReport

  def file_colour(client_file)
    status_colour client_file.file_status.to_sym
  end

  def status_colour(status)
    return '' if status == :live

    return 'info' if status == :feed

    return 'warning' if status == :closed_not_feed

    'success'
  end

  def file_statuses(client_file)
    ClientFile.aasm.states
  end





end
