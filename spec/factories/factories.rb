include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :company do 
    name "4FUNMEDIA"
  end

  factory :quote do
    sequence :date do |n|
      Time.now + n.days
    end
    open 34.5
    company
    close Random.rand(40)
  end

end
