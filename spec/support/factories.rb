Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :name do |n|
  "User Name #{n}"
end


Factory.define :user do |f|
  f.name { Factory.next(:name) }
  f.email { Factory.next(:email) }
  f.password 'secret'
  f.password_confirmation { |u| u.password }
end

Factory.define :admin, :parent => :user do |f|
  f.email 'admin@example.com'
  f.admin true
end

Factory.define :page do |f|
  f.title 'Great news'
  f.content 'This is a great post whatsoever'
end