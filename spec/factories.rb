# By using the :user symbol we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                   "Rafael Garcia"
  user.email                  "rgarcia2009@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

