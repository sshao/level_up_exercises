Given(/^there exists a user "(.*?)" with email "(.*?)" and password "(.*?)"$/) do |username, email, password|
  create_user(username, password, email)
end

Given(/^that I am signed in$/) do
  create_user("kcharlie", "birdlaw123", "birdlawyer@birdlaw.com")
  sign_in("kcharlie", "birdlaw123")
end

Given(/^I am on a palette set's page$/) do
  create_palette_set("charlie")
  visit palette_set_path(PaletteSet.first)
end

Given(/^I have favorited some palette sets$/) do
  create_palette_set("charlie")
  create_palette_set("nophotos")

  visit palette_set_path(PaletteSet.first)
  click_button "Favorite"

  visit palette_set_path(PaletteSet.last)
  click_button "Favorite"
end

Then(/^I should see all of my favorited palette sets$/) do
  expect(page).to have_content "charlie"
  expect(page).to have_content "nophotos"
end

