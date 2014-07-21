module FieldHelpers
  def field_name(field)
    field.gsub(/\s/, "_")
  end
  
  def upload_file(filepath)
    attach_file "upload_receipt", filepath
  end
  
  def upload_file(filepath)
    attach_file "upload_receipt", filepath
  end
end
World(FieldHelpers)

module PaletteSetHelpers
  def create_palette_set(username)
    stub_info_request(username)
    stub_photos_request(username, PULL_LIMIT)
    PaletteSet.create!(source: username)
  end
end
World(PaletteSetHelpers)

module UserHelpers
  def create_user(username, password, email)
    User.create!(username: username, email: email, password: password)
  end

  def sign_in(username, password)
    visit "/"
    fill_in "user[login]", with: username
    fill_in "user[password]", with: password
  end
end
World(UserHelpers)

