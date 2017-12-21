FactoryGirl.define do
  factory :user do
    uid { Faker::Internet.email }
    email { uid }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    provider 'email'
    password 'P@ssw0rd'
    confirmed_at { Time.now }
  end

  factory :post do
    quote 'EURUSD'
    market 'Currency'
    recommend 'Sell'
    price '1.0987'
    access 'Public'
    content  'Some cool news'
    forecast '29.07.2017'
  end

  factory :group do
    name { Faker::Company.name }
    description { Faker::Company.bs }
    access 'Public'
    image ''
  end

end