class DocumentTemplating::TemplateValues
  require 'factory_girl'

  DATE_FORMAT = '%e %B %Y'
  TIME_FORMAT = '%l:%M %p'

  def self.valid_context_fields(client_file = nil, current_user = nil)
    client_file ||= ClientFile.offset(rand(ClientFile.count)).first
    client_file ||= FactoryGirl.create(:client_file)
    client_file_template_context(client_file, current_user)
  end

  def self.template_context(templateable, current_user)
    raise "Client File not found for #{templateable}" unless templateable.client_file

    client_file = templateable.client_file

    if templateable.created_by
      current_user = templateable.created_by
    end

    templateable_class = templateable.class.name
    templateable_context = templateable.to_template_values

    context = client_file_template_context(client_file, current_user)

    context[templateable_class] = templateable_context
    context
  end

  def self.client_file_template_context(client_file, current_user)
    file_number = client_file.file_number
    subject_matter = client_file.subject_matter
    locus = client_file.locus

    current_live_account = LiveAccount.for_client_file(client_file)
    account_type = current_live_account ? current_live_account.account_type : ''
    account_reference = current_live_account ? current_live_account.reference : ''

    file_court = client_file.court
    file_court_type = file_court ? file_court.court_type : ''
    file_court_city = file_court ? file_court.city : ''
    file_court_jurisdiction = file_court ? file_court.jurisdiction : ''
    file_court_official = file_court && file_court.court_official ? file_court.court_official : ''
    file_disposal = client_file.disposal
    file_date_of_offence = client_file.date_of_offence
    file_date_open = client_file.date_open
    file_meeting_count = client_file.meetings.count

    court_dates = client_file.court_dates.order(court_date: :asc)
    file_first_court_date = court_dates.first
    file_last_court_date = court_dates.last
    file_next_court_date = client_file.next_court_date
    file_most_recent_court_date = client_file.most_recent_past_court_date
    file_next_intermediate_court_date = client_file.next_court_date_by_court_date_type(CourtDateType.find_by_name('Intermediate Diet'))
    file_next_trial_court_date = client_file.next_court_date_by_court_date_type(CourtDateType.find_by_name('Trial Diet'))
    file_next_pleading_court_date = client_file.next_court_date_by_court_date_type(CourtDateType.find_by_name('Pleading Diet'))
    file_next_first_diet_court_date = client_file.next_court_date_by_court_date_type(CourtDateType.find_by_name('First Diet'))
    file_procurator_fiscal_reference = client_file.procurator_fiscal_reference
    file_procurator_fiscal_name = client_file.procurator_fiscal ? client_file.procurator_fiscal : ''
    file_procurator_fiscal_address = client_file.procurator_fiscal ? client_file.procurator_fiscal.address : ''
    file_procurator_fiscal_address_inline = file_procurator_fiscal_address.gsub(/(\r)?\n/, ', ')

    client_name = client_file.client.full_name
    client_forename = client_file.client.forename_name
    client_address = client_file.client.address
    client_address_inline = client_address ? client_address.gsub(/(\r)?\n/, ', ') : ''
    client_location = client_file.client.location
    client_location_address = client_location ? client_location.address : ''
    client_prison_number = client_file.client.prison_number
    client_date_of_birth = client_file.client.birth_date
    client_home_number = client_file.client.home_telephone
    client_mobile_number = client_file.client.mobile_telephone
    client_contact_number = client_file.client.contact_telephone
    client_national_insurance = client_file.client.national_insurance_number

    current_date = Date.today

    current_solicitor = client_file.current_solicitor
    current_solicitor_surname = current_solicitor ? current_solicitor.personal_details.surname : ''
    current_solicitor_surname_with_title = current_solicitor ? current_solicitor.personal_details.surname_with_title : ''
    current_solicitor_type = current_solicitor ? current_solicitor.user_type : ''

    current_user_initials = nil
    if !current_user && client_file.created_by
      current_user = client_file.created_by
    end

    if current_user
      current_user_initials = current_user.initials
    end

    {
      clientName: client_name,
      clientForename: client_forename,
      clientAddress: client_address,
      clientAddressInline: client_address_inline,
      location: client_location,
      locationAddress: client_location_address,
      clientPrisonNumber: client_prison_number,
      clientDob: client_date_of_birth.to_s,
      clientHomeNumber: client_home_number,
      clientMobileNumber: client_mobile_number,
      clientContactNumber: client_contact_number,
      clientNationalInsuranceNumber: client_national_insurance,
      fileNumber: file_number,
      fileDateOfOffence: file_date_of_offence,
      fileDateOpen: file_date_open,
      fileMeetingsCount: file_meeting_count,
      accountType: account_type,
      accountReference: account_reference,
      subjectMatter: subject_matter,
      fileLocus: locus,
      fileCourt: file_court.to_s,
      fileCourtType: file_court_type,
      fileCourtCity: file_court_city,
      fileCourtJurisdiction: file_court_jurisdiction,
      fileCourtOfficial: file_court_official,
      fileDisposal: file_disposal,
      fileFirstCourtDate: file_first_court_date,
      fileLastCourtDate: file_last_court_date,
      fileNextCourtDate: file_next_court_date,
      fileMostRecentCourtDate: file_most_recent_court_date,
      fileNextIntermediateCourtDate: file_next_intermediate_court_date,
      fileNextTrialDietCourtDate: file_next_trial_court_date,
      fileNextPleadingCourtDate: file_next_pleading_court_date,
      fileNextFirstDietCourtDate: file_next_first_diet_court_date,
      fileCourtDatesToBeChanged: court_dates_to_be_changed(client_file),
      fileProcuratorFiscalReference: file_procurator_fiscal_reference,
      fileProcuratorFiscalName: file_procurator_fiscal_name,
      fileProcuratorFiscalAddress: file_procurator_fiscal_address,
      fileProcuratorFiscalAddressInline: file_procurator_fiscal_address_inline,
      currentDate: current_date.strftime(DATE_FORMAT),
      currentSolicitor: current_solicitor,
      currentSolicitorInitials: current_solicitor ? current_solicitor.initials : '',
      currentSolicitorSurname: current_solicitor_surname,
      currentSolicitorSurnameWithTitle: current_solicitor_surname_with_title,
      currentSolicitorType: current_solicitor_type,
      currentUser: current_user,
      currentUserInitials: current_user_initials,
      ourRef: our_ref(file_number, client_file.partner, current_solicitor, current_user)
    }
  end


  private
  def self.our_ref(file_number, partner, current_solicitor, current_user)
    partner_initials = partner ? partner.initials : ''
    current_solicitor_initials = current_solicitor ? current_solicitor.initials : ''
    current_user_initials = current_user ? current_user.initials : ''

    return "#{file_number}/#{partner_initials}/#{current_user_initials}" if partner == current_solicitor

    return "#{file_number}/#{partner_initials}/#{current_solicitor_initials}/#{current_user_initials}"
  end

  def self.court_dates_to_be_changed(client_file)
    client_file.court_dates_to_be_changed.join(' and ')
  end
end
