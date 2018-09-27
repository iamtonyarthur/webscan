class WelcomeController < ApplicationController
  def index
    @domains = Domain.order("rank ASC")
  end
end
