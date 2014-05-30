class BossaHandler
  require 'zip'
  require 'fileutils'
  require 'csv' 
  require 'open-uri'
  attr_reader :filename
  attr_accessor :added_quotes, :added_companies

  def download_zip(source="http://bossa.pl/pub/ciagle/mstock/mstcgl.zip")
    filename="#{Rails.root}/tmp/msctcgl.zip"
    open(filename, 'wb') do |file|
      file << open(source).read 
    end
  end

  def unzip(file)
    file_to_unzip = file.blank? ? filename : file
    remove_target_directory
    Zip::File.open(file) do |zip_file|
      zip_file.each do |entry|
        f_path=File.join("#{Rails.root}/tmp/unziped/", entry.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        entry.extract("#{Rails.root}/tmp/unziped/#{entry}") 
        zip_file.extract(entry, f_path) unless File.exist?(f_path)
      end
    end
  end
  
  def companies_from_file(file="#{Rails.root}/tmp/unziped/**/*.mst") 
    mst_files = Dir[file]
    mst_files.collect { |x| Pathname.new(x).basename.to_s[0..-5] }
  end

  def parse_company(company, from_date)
    from_date = Time.now - 30.years if from_date.nil?
    file = search_directory_for_company(company.name)
    results = Array.new
    CSV.foreach(file, :headers => true) do |csv_obj|
      quote_date = csv_obj["<DTYYYYMMDD>"].to_date
      if quote_date > from_date
        results << {
          :date => quote_date,
          :open => csv_obj["<OPEN>"].to_f,
          :high => csv_obj["<HIGH>"].to_f,
          :low => csv_obj["<LOW>"].to_f,
          :close => csv_obj["<CLOSE>"].to_f,
          :vol => csv_obj["<VOL>"].to_i,
          :company_id => company.id
        }
      end 
    end
    results
  end

  def update_company_list
    companies_from_file.each do |company|
      Company.find_or_create_by(name: company)
    end
  end

  def update_quotes
    companies_from_file.each do |company|
      company_to_update = Company.where(:name => company).first
      if company_to_update.present?
        quotes_to_save = []
        quotes = parse_company(company_to_update, Quote.last_date_for_company_id(company_to_update.id))
        #company_to_update.quotes.create(quotes)
        quotes.each do |q|
          quotes_to_save << Quote.new(q)
          increment_added_quotes
        end
        Quote.import quotes_to_save
        puts "#{company_to_update.name} imported to database"
      end
    end
  end

  def beta_factor(company, start_date, end_date)

  end

  def rate_of_return(company, start_date, end_date)
    start_date = fix_weekends(start_date)
    end_date = fix_weekends(end_date)

    end_record = company.quotes.where(date: end_date).first
    start_record = company.quotes.where(date: start_date).first
    if end_record.present? && start_record.present?
      ((end_record.close / start_record.close) - 1)*100
    else
      nil
    end
  end

  def fix_weekends(date)
    if date.saturday?
      date = date + 2.day
    elsif date.sunday?
      date = date + 1.day
    end
    date
  end

  private 



  def increment_added_quotes
    if self.added_quotes.nil?
      self.added_quotes = 1
    else
      self.added_quotes += 1
    end
  end

  def increment_added_companies
    if self.added_companies.nil?
      self.added_companies = 1
    else
      self.added_companies += 1
    end
  end

  def remove_target_directory
    FileUtils.rm_rf("#{Rails.root}/tmp/unziped")
  end

  def search_directory_for_company(company)
    result = nil
    mst_files = Dir["#{Rails.root}/tmp/unziped/**/*.mst"]
    mst_files.each do |p|
      if p.include?(company)
        result = p
        break
      end
    end
    result
  end

end