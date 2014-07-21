Feature: Generate color palettes for a blog

  As a user
  I want to view the color palettes for each photo on a blog
  So that I can view the correlation between them

  Background:
    Given I am on the home page

  Scenario: Generate palettes for an existing blog with photo posts
    Given there exists a tumblr with username "charlie"
    And it has at least "10" photo posts
    When I fill in "tumblr username" with "charlie"
    And I click "Generate"
    Then I should see "10" palettes and their associated photo posts

  Scenario: Generate palettes for a non-existent blog
    Given there does not exist a tumblr with username "doesnotexist"
    When I fill in "tumblr username" with "doesnotexist"
    And I click "Generate"
    Then I should see "not found, returned 404"

  Scenario: Generate palettes when no blog is input
    Given there does not exist a tumblr with username ""
    When I fill in "tumblr username" with ""
    And I click "Generate"
    Then I should see "Source can't be blank"

  Scenario: Generate palettes for an existing blog with no photo posts
    Given there exists a tumblr with username "nophotos"
    And it has 0 photo posts
    When I fill in "tumblr username" with "nophotos"
    And I click "Generate"
    Then I should see "0" palettes and their associated photo posts
    And I should see "No photo posts found"

  Scenario: Generate palettes for a blog already in database
    Given there exists a tumblr with username "charlie"
    And palettes have already been generated for it
    When I fill in "tumblr username" with "charlie"
    And I click "Generate"
    Then I should see "10" palettes and their associated photo posts

  # Scenario? photosets 

