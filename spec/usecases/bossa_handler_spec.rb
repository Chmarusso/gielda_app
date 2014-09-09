require 'spec_helper'

describe "#BossaHandler" do

  subject(:handler) { BossaHandler.new }
  let(:first_result_file) { "06MAGNA.mst" }
  let(:second_result_file) { "4FUNMEDIA.mst" }
  let(:company) { FactoryGirl.build :company }
 
  it "downloads zip" do
    handler.download_zip("#{Rails.root}/spec/support/test_zip.zip")
    expect(File.exist?("#{Rails.root}/tmp/msctcgl.zip")).to be true  
  end

  it "unzips downloaded zip to dir" do
    handler.unzip("#{Rails.root}/spec/support/test_zip.zip")
    expect(File.exist?("#{Rails.root}/tmp/unziped/test_zip/#{first_result_file}")).to be true
  end

  it "lists companies from unziped archive" do
    companies = handler.companies_from_file
    expect(companies.size).to eq 2
    expect(companies[0]).to eq "06MAGNA"
    expect(companies[1]).to eq "4FUNMEDIA"
  end

  it "parses company from directory" do 
    parsed_data = handler.parse_company(company, nil)
    expect(parsed_data.size).to eq 835
    expect(parsed_data[0][:vol]).to eq 24307
  end

  it "updates companies list in db" do
    # handler.update_company_list
    # expect(Company.all.count).to eq 2
    # handler.update_company_list
    # expect(Company.all.count).to eq 2
  end

  it "updates quotes for all companies" do
    #allow(handler).to receive(:parse_company) { [{:open => 13, :date => "19971231".to_date}, {:open => 11, :date => "19971125".to_date}] }
    #handler.update_quotes
    #company = Company.by_name("4FUNMEDIA")
    #expect(company.quotes.count).to eq 2
  end

end
