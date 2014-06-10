require 'spec_helper'

describe CompaniesController do

  describe "GET 'search'" do
    it "returns http success" do
      get 'search', {:params => {:term => 'baN'}}
      parsed_body = JSON.parse(response.body)
      parsed_body[0][:value].should eq "MBANK"
    end
  end

  describe "GET 'calculator'" do
    it "returns http success" do
      get 'calculator', {:params => {:companyname => 'MBANK'}}
      Company.any_instance.stub(:rate_of_return).and_return(56.666)
      parsed_body = JSON.parse(response.body)
      parsed_body.should eq 56.666
    end
  end

end
