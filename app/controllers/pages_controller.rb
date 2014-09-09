class PagesController < ApplicationController
  def quiz
  end

  def benchmark
  end

  def wallet
    @companies = WalletBuilder.new(params[:profile], params[:amount].to_i).build
  end

  def ranking
    @top_companies = Company.where('rating IS NOT NULL').order('rating DESC').limit(10)
    @last_update = Quote.last.date
  end

  def set_profile
    cookies['investor'] = params['profile'] if params['profile'].present?
    render nothing: true
  end
end
