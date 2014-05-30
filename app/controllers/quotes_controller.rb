class QuotesController < ApplicationController
  def index
  end

  def show
    @company = Company.find(params[:id])
    @quotes = @company.quotes.order('id DESC')
  end
end
