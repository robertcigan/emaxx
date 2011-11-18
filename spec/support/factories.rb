FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :name do |n|
    "User Name #{n}"
  end

  factory :user do
    name { Factory.next(:name) }
    email { Factory.next(:email) }
    password 'secret'
    password_confirmation { |u| u.password }
  end

  factory :admin, :parent => :user do
    email 'admin@example.com'
    admin true
  end

  factory :page do
    title 'Great news'
    content 'This is a great post whatsoever'
    publish_at '2010-01-01 8:00:00'
    html_content 'This is a great post whatsoever'
    tag_list 'news, worldwide'
  end

  factory :photo do
    association :page
    file { File.open(File.join(Rails.root, 'spec', 'files', 'test_image.jpg')) }
  end
end