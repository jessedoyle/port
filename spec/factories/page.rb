FactoryGirl.define do
  factory :page do
    sequence(:absolute_path) { |n| "#{n}/test/path" }
    relative_path 'test/path'
    root 'test'
  end

  factory :page_with_index, class: Page do
    sequence(:absolute_path) { |n| "/#{n}/test/path/index.html" }
    relative_path 'path/index.html'
    root 'test'
  end
end
