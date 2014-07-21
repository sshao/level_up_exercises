module FieldHelpers
  def field_name(field)
    field.gsub(/\s/, '_')
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
  def create_user(username, password, email = "dummyemail@dummyemail123.com")
    User.create!(username: username, email: email, password: password)
  end
end
World(UserHelpers)

