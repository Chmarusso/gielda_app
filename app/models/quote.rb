class Quote < ActiveRecord::Base
  belongs_to :company
  scope :dates_between, ->(start_date, end_date) { where("created_at >= ? AND created_at <= ?", start_date, end_date ) }

  def self.last_date_for_company_id(company_id)
    begin
      Quote.where(:company_id => company_id).order('date DESC').limit(1).first.date
    rescue
      nil
    end
  end

  def self.mean_for_company(company_name, start_date, end_date)
    company = Company.by_name(company_name)
    Quote.where(:company => company).dates_between(start_date, end_date).average("close")
  end

  def self.mean_for_wig(start_date, end_date)
    company = Company.by_name("WIG")
    Quote.where(:company => company).dates_between(start_date, end_date).average("close")
  end
end
