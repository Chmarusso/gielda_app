class CompaniesController < ApplicationController
  def search
    results = Company.where("LOWER(name) like ?", "%#{params[:term]}%").collect{ |x| {value: x.name, label: x.name} }
    render :json => results 
  end

  def calculator
    company = Company.by_name(params[:companyname])
    results = company.rate_of_return(params[:start_date], params[:end_date])
    render :json => results
  end
end
