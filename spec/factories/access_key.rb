FactoryGirl.define do
  factory :access_key do
    sequence(:value) { |n| "test_#{n}_code" }
    expires_after Date.tomorrow
  end

  factory :expired_access_key, class: AccessKey do
    value 'test_expired'
    expires_after Date.yesterday
  end

  factory :invalid_access_key, class: AccessKey do
    value ''
    expires_after ''
  end
end
