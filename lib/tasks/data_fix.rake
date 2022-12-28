namespace :data_fix do

  desc "Merge duplicate clients, based on auxiliary id"
  task merge_duplicate_clients: :environment do

    Client.group(:auxiliary_id).having('COUNT(auxiliary_id) > 1').count.each do |auxiliary_id|
      client = Client.where(auxiliary_id: auxiliary_id).order(created_at: :desc).first

      Client.where(auxiliary_id: auxiliary_id).flat_map { |c| c.client_files }.each { |client_file| client_file.update!(client: client) }
      Client.where(auxiliary_id: auxiliary_id).flat_map { |c| c.ledgers }.each { |client_file| client_file.update!(client: client) }
      Client.where(auxiliary_id: auxiliary_id).flat_map { |c| c.documents }.each { |client_file| client_file.update!(client: client) }

      (Client.where(auxiliary_id: auxiliary_id) - [client]).each { |c| c.destroy! }
    end

  end

  desc "Merge clients, given ids, the last id will be used for collecting all of client data"
  task :merge_client_ids, [:client_ids] => :environment do |t, args|
    ids = args[:client_ids].split
    last_id = ids.last
    puts "Merging #{ids.join(',')} into #{last_id}"

    landing_client = Client.find(last_id)

    Client.find(ids).flat_map { |c| c.client_files }.each { |client_file| client_file.update!(client: landing_client) }
    Client.find(ids).flat_map { |c| c.ledgers }.each { |ledgers| ledgers.update!(client: landing_client) }
    Client.find(ids).flat_map { |c| c.documents }.each { |documents| documents.update!(client: landing_client) }

  end

  desc "For all claims which have 0 outstanding, set accpeted to true"
  task set_accepted_claims: :environment do |t|
    claims = Claim
      .joins(:payments)
      .where(accepted: false)
      .group(:claim_id)
      .having('claims.amount_pennies - (SUM(payments.fee_amount_pennies) + SUM(payments.outlay_amount_pennies)) <= 0')

    claims.update_all(accepted: true)
  end

  desc "For all claims with payments, set last payment on date"
  task set_last_payment_on_claims: :environment do |t|
    claims = Claim.joins(:payments).group(:claim_id).where(last_payment_on: nil).maximum('payments.payment_date')

    Claim.update(claims.keys, claims.values.map{|date| {last_payment_on: date} })
  end

end
