#!/usr/bin/env ruby

require 'pg'
require 'faker'
require 'ruby-progressbar'

def random_year
  (1900 + rand(100))
end

connection = PG::Connection.open(
  dbname: 'postgres',
  user: 'postgres',
  password: '',
  host: 'localhost',
  port: '5432'
)

NUM_USERS = 200_000
NUM_BEERS = 1_000
NUM_BREWERIES = 500
NUM_RATINGS = 1_000_000

users = []
progressbar = ProgressBar.create(title: "Users", starting_at: 0, total: NUM_USERS)
NUM_USERS.times do |i|
  name = connection.escape_literal(Faker::Name.first_name)
  users.push "(#{name})"
  progressbar.increment
end

connection.exec "INSERT INTO yadda.users (name) values #{users.join(", ")}"

breweries = []
progressbar = ProgressBar.create(title: "Breweries", starting_at: 0, total: NUM_BREWERIES)
NUM_BREWERIES.times do |i|
  name = connection.escape_literal(Faker::Name.first_name + " Brewery")
  address = connection.escape_literal(Faker::Address.street_address)
  description = connection.escape_literal(Faker::Company.catch_phrase)
  year = random_year

  breweries.push "(#{name}, #{address}, #{description}, #{year})"
  progressbar.increment
end
  
connection.exec "INSERT INTO yadda.breweries (name, address, description, year) VALUES #{breweries.join(", ")}"

beers = []
progressbar = ProgressBar.create(title: "Beers", starting_at: 0, total: NUM_BEERS)
NUM_BEERS.times do |i|
  name = connection.escape_literal(Faker::Name.first_name)
  style = connection.escape_literal(Faker::Commerce.color)
  description = connection.escape_literal(Faker::Lorem.sentence)
  year = random_year
  brewery = rand(1..NUM_BREWERIES)

  beers.push "(#{name}, #{style}, #{description}, #{year}, #{brewery})"
  progressbar.increment
end

connection.exec "INSERT INTO yadda.beers (name, style, description, year, brewery_id) VALUES #{beers.join(", ")}"

ratings = []
progressbar = ProgressBar.create(title: "Ratings", starting_at: 0, total: NUM_RATINGS)
NUM_RATINGS.times do |i|
  score = rand(1..5)
  beer = rand(1..NUM_BEERS)
  user = rand(1..NUM_USERS)

  ratings.push "(#{score}, #{beer}, #{user})"
  progressbar.increment
end

connection.exec "INSERT INTO yadda.ratings (score, beer_id, user_id) VALUES #{ratings.join(", ")}"
