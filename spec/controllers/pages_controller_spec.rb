require 'spec_helper'

describe PagesController do

  describe "GET 'quiz'" do
    it "returns http success" do
      get 'quiz'
      response.should be_success
    end
  end

  describe "GET 'benchmark'" do
    it "returns http success" do
      get 'benchmark'
      response.should be_success
    end
  end

  describe "GET 'wallet'" do
    it "returns http success" do
      get 'wallet'
      response.should be_success
    end
  end

end
