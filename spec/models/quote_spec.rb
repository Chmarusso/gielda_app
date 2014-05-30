require 'spec_helper'

describe Quote do
  let!(:first_quote) { FactoryGirl.create(:quote, date: Time.now - 13.days, company_id: 1) }
  let!(:last_quote) { FactoryGirl.create(:quote, date: Time.now - 10.days, company_id: 1) }

  context "#last_date_for_company_id" do
    it "returns proper date" do
      expect(Quote.last_date_for_company_id(1)).to eq last_quote.date
    end
  end 

  context "beta factor" do 
    it "calculates company mean for date range" do 
      quotes = FactoryGirl.create(:quote, quotes_count: 15)
      expect(Quote.mean_for_company("4FUNMEDIA", Time.now, Time.now+15.days)).to eq Quote.average("close")
    end
  end
end
