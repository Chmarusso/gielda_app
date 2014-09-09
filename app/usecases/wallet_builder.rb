class WalletBuilder
	attr_reader :investor, :amount

	def initialize(investor_profile, amount)
		@investor = investor_profile
		@amount = amount 
	end

	def build
		companies = wallet(4, 0.8) if investor == "agressive"
		companies = wallet(6, 0.6) if investor == "neutral"
		companies = wallet(7, 0.5) if investor == "calm" 
		companies
	end

	private 

	def wallet_for_agressive 
		companies_no = 3
		companies_percentage = 0.8
		investment = (amount*companies_percentage)/companies_no
		companies = Company.first_best(companies_no)
		companies = companies.collect {|company| {name: company.name, amount: investment}}
		companies << {name: "Obligacje skarbowe", amount: (1.0-companies_percentage)*amount}
	end

	def wallet(companies_no, companies_percentage)
		investment = (amount*companies_percentage)/companies_no
		companies = Company.first_best(companies_no)
		companies = companies.collect {|company| {name: company.name, amount: investment}}
		companies << {name: "Obligacje skarbowe", amount: (1.0-companies_percentage)*amount}
		companies
	end

	def wallet_for_neutral 
		companies = Company.first_best(5)
	end

	def wallet_for_calm 
		companies = Company.first_best(6)
	end
end