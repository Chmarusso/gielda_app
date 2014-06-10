class PagesController < ApplicationController
  def quiz
  end

  def benchmark
  end

  def wallet
  end

  def ranking
    @top_companies = Company.where('rating IS NOT NULL').order('rating DESC').limit(10)
    @last_update = Quote.last.date
  end
end
