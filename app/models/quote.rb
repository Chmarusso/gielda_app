class Quote < ActiveRecord::Base
  belongs_to :company
  scope :dates_between, ->(start_date, end_date) { where("date >= ? AND date <= ?", start_date, end_date ) }

  def self.last_date_for_company_id(company_id)
    begin
      Quote.where(:company_id => company_id).order('date DESC').limit(1).first.date
    rescue
      nil
    end
  end

  def self.mean_for_company(company, start_date, end_date)
    Quote.where(:company => company).dates_between(start_date, end_date).average("close")
  end

  def self.mean_for_wig(start_date, end_date)
    company = Company.by_name("WIG")
    Quote.where(:company => company).dates_between(start_date, end_date).average("close")
  end
end
