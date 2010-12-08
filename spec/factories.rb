Factory.define :user do |user|
  user.name 'Gabriel Laden'
  user.email 'gabriel94109@gmail.com'
  user.password 'rubypass'
  user.password_confirmation 'rubypass'
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content 'Foo bar'
  micropost.association :user
end
