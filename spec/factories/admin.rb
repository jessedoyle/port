FactoryGirl.define do
  factory :admin do
    email 'test@test.com'
    password '12345678'
    password_confirmation '12345678'
  end
end
