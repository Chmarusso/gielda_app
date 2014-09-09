class Company < ActiveRecord::Base
  has_many :quotes
  scope :by_name, ->(name) { where(name: name).limit(1).first }
  scope :first_best, ->(no) { where('rating IS NOT NULL').order('rating DESC').limit(no) }
  validates :name, uniqueness: true

  def number_of_days
    end_record = quotes.last.date
    start_record = quotes.first.date
    (end_record - start_record).to_i
  end

  def rates_of_return(start_date, end_date)
    quotes.where("date >= ? AND date <= ?", start_date, end_date).collect{ |x| ((x.close / x.open) - 1) }
  end

  def rate_of_return(start_date, end_date)
    end_record = quotes.where(date: end_date).first
    start_record = quotes.where(date: start_date).first
    if end_record.present? && start_record.present?
      ((end_record.close / start_record.close) - 1)
    else
      nil
    end
  end

  def beta_factor(wig, start_date, end_date)
    ri_mean = Quote.mean_for_company(self, start_date, end_date)

    company_results = rates_of_return(start_date, end_date).collect {|x| x-ri_mean }
    wig_results = wig
    wig_squared = wig_results.collect {|x| x=x*x}

    company_x_wig = Array.new
    company_results.each_with_index do |x, index|
      company_x_wig << x*wig_results[index]
    end
    company_x_wig.sum / wig_squared.sum
  end

  def best_rating(wig, wig_rate_of_return, wig_rates_of_return, start_date, end_date)
    rating = 0
    if (quotes.where(:date => start_date).count + quotes.where(:date => end_date).count) == 2
      swor = 0.0433 #stopa wolna od ryzyka
      rating = (rate_of_return(start_date, end_date) - swor) - beta_factor(wig_rates_of_return, start_date, end_date) * (wig_rate_of_return - swor)    
    end
    rating 
  end

  def calculate_rating
    start_date = quotes.first.date
    end_date = quotes.last.date 

    wig = Company.by_name("WIG")
    wig_rate_of_return = wig.rate_of_return(start_date, end_date) 
    rm_mean = Quote.mean_for_company(wig, start_date, end_date)
    wig_rates_of_return = wig.rates_of_return(start_date, end_date).collect {|x| x-rm_mean } 

    self.rating = best_rating(wig, wig_rate_of_return, wig_rates_of_return, start_date, end_date)
    save!
  end



  def self.best_companies(end_date, limit=5)
    companies = []
    wig = Company.by_name("WIG")

    swor = 0.0433 #stopa wolna od ryzyka
    Company.all.each do |company|
      if company.quotes.where("date > ?", end_date).count > 0
        start_date = company.quotes.first.date
        wig_rate_of_return = wig.rate_of_return(start_date, end_date) 
        rm_mean = Quote.mean_for_company(wig, start_date, end_date)
        wig_rates_of_return = wig.rates_of_return(start_date, end_date).collect {|x| x-rm_mean }
        companies << { company: company, rating: company.best_rating(wig, wig_rate_of_return, wig_rates_of_return, start_date, end_date) }
      end
    end
    companies = companies.sort_by { |x| x[:rating] }
    companies = companies.reverse
    companies[0..limit]
  end

  def self.benchmark_companies(investment, companies, start_date, end_date)
    results = []
    invested = investment/companies.size
    companies.each do |company|
      return_inv = company.rate_of_return(start_date, end_date)
      results << {name: company.name, rate_of_return: return_inv, revenue: invested*return_inv}
    end
    results 
  end




end
