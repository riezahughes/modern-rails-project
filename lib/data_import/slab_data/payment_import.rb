class DataImport::SlabData::PaymentImport

  def self.payments_from_xml(contents)
    doc = Nokogiri::XML(contents)

    payment_date = Date.parse doc.xpath("//paymentDate").first.content
    account_headers = doc.xpath("//accountHeader")

    payments = []
    missing_registration_numbers = []

    account_headers.each do |account_header|
      slab_registration_number = account_header.xpath("registrationNumber").first.content.gsub(/\/\d+$/,'')
      legal_aid_refernce = account_header.xpath("legalAidReference").first.content
      claim = Claim.find_by_slab_registration_number slab_registration_number

      if claim

        paid_footer_path = 'accountDetails/totalPaidFooter'
        total_fees_string = account_header.xpath("#{paid_footer_path}/fees").first.content
        total_outlay_strings = account_header.xpath("#{paid_footer_path}/outlays | #{paid_footer_path}/agents | #{paid_footer_path}/counsel")
        total_fees = total_fees_string.to_money
        total_outlays = total_outlay_strings.map(&:content).map(&:to_money).inject { |sum, outlay| sum + outlay }

        payments << Payment.new(claim: claim, payment_date: payment_date, fee_amount: total_fees, outlay_amount: total_outlays)
      else

        missing_registration_numbers << {slab_registration_number: slab_registration_number, legal_aid_refernce: legal_aid_refernce}
      end
    end

    [payments, missing_registration_numbers]
  end

end
