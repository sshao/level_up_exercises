Feature: Generate color palettes for a blog

  As a user
  I want to view the color palettes for each photo on a blog
  So that I can view the correlation between them

  Scenario: Generate palettes for an existing blog with photo posts
    Given there exists a tumblr blog "blog"
    And the blog has at least "10" photo posts
    When I submit "blog" as "tumblr username" and click "Generate"
    Then I should see "10" palettes and their associated photo posts

  # Scenario? photosets 
  # Scenario: existing blog, no photo posts
  #
  # Scenario: nonexistent blog