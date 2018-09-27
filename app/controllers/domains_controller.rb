class DomainsController < ApplicationController
  before_action :authenticate_user!
  
  def import
    require 'csv'

    # purge all domains
    domains = Domain.all
    domains.destroy_all

    # import domains from CSV
    path = params[:file].path

    CSV.foreach(path, headers: true) do |row|
      domain = Domain.new
      domain.domain_name = row[0]
      domain.rank = row[1]
      domain.country = row[2]
      domain.save
    end

    redirect_to root_url
  end

  def check_websites
    # check if website uses https
    domains = Domain.where(redirect_to_https: false).order("rank ASC")

    domains.each do |domain|
      domain.redirect_to_https = Domain.check_https_redirect(domain.domain_name, 0)
      if !domain.save
        puts "failed to save - #{domain.errors.full_messages}"
      end
    end

    redirect_to root_url
  end
end
