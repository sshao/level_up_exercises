Feature: Generate color palettes for a blog

  As a user
  I want to view the color palettes for each photo on a blog
  So that I can view the correlation between them

  Scenario: Generate palettes for an existing blog with photo posts
    Given there exists a tumblr blog "blog"
    And it has at least "10" photo posts
    When I submit it as "tumblr username" and click "Generate"
    Then I should see "10" palettes and their associated photo posts

  Scenario: Generate palettes for a non-existent blog
    Given there does not exist a tumblr blog "doesnotexist"
    When I submit it as "tumblr username" and click "Generate"
    Then I should see "not found, returned 404"

  Scenario: Generate palettes when no blog is input
    Given there does not exist a tumblr blog ""
    When I submit it as "tumblr username" and click "Generate"
    Then I should see "Source can't be blank"

  Scenario: Generate palettes for an existing blog with no photo posts
    Given there exists a tumblr blog "no_photos"
    And it has 0 photo posts
    When I submit it as "tumblr username" and click "Generate"
    Then I should see "0" palettes and their associated photo posts
    And I should see "No photo posts found"

  # Scenario? photosets 

