module Fields
  def field_name(field)
    field.gsub(/\s/, '_')
  end
end
World(Fields)

module KnowsUser
  def create_user(username, password, email = "dummyemail@dummyemail123.com")
    User.create!(username: username, email: email, password: password)
  end

  def login(username, username_field, password, password_field)
    fill_in field_name(username_field), with: username
    fill_in field_name(password_field), with: password
    click_link_or_button 'Log in'
  end
end
World(KnowsUser)
