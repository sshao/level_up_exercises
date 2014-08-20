DROP VIEW IF EXISTS brewery_top_beers;
DROP VIEW IF EXISTS beer_recent_scores;
DROP VIEW IF EXISTS more_like_this_beer;
DROP VIEW IF EXISTS beer_avg_ratings;

-- given a Beer, find its average overall score
CREATE VIEW beer_avg_ratings AS
SELECT beer.*, AVG(rate.score) as avg_score
FROM yadda.beers as beer
LEFT JOIN yadda.ratings as rate
ON beer.beer_id = rate.beer_id
GROUP BY beer.beer_id;

-- given a Brewery, get its top-rated (by overall avg) Beers
CREATE VIEW brewery_top_beers AS
SELECT brewery.*, array_agg(top_beers_per_brewery.name) AS top_beers
FROM yadda.breweries AS brewery
LEFT JOIN (
  SELECT * FROM (
    SELECT beer.beer_id, beer.name, beer.brewery_id, avg_score, ROW_NUMBER() OVER (PARTITION BY beer.brewery_id ORDER BY avg_score DESC) AS rownum
    FROM beer_avg_ratings AS beer 
  ) tmp
  WHERE rownum < 4
) AS top_beers_per_brewery
ON top_beers_per_brewery.brewery_id = brewery.brewery_id 
GROUP BY brewery.brewery_id;

-- given a Beer, compute average score from scores made within the last 6 months
CREATE VIEW beer_recent_scores AS
SELECT beer.*, AVG(recent_ratings.score)
FROM yadda.beers AS beer
LEFT JOIN (
  SELECT beer_id, score
  FROM yadda.ratings as rating
  WHERE updated_at >= NOW() - INTERVAL '6 months'
) AS recent_ratings
ON recent_ratings.beer_id = beer.beer_id
GROUP BY beer.beer_id;

-- given a Beer, get an array of top-rated (by overall avg) Beers of the same style
CREATE VIEW more_like_this_beer AS
SELECT primary_beer.*, array_agg(top_by_style.name ORDER BY RANDOM()) as similar_beers
FROM yadda.beers AS primary_beer 
LEFT JOIN (
  SELECT style, name FROM (
    SELECT beer.beer_id, beer.name, beer.style, ROW_NUMBER() OVER (PARTITION BY beer.style ORDER BY avg_score DESC) as row_num
    FROM beer_avg_ratings AS beer
    ORDER BY beer.style
  ) beer_avg_ratings
  WHERE row_num < 6
) AS top_by_style 
ON top_by_style.style = primary_beer.style
GROUP BY primary_beer.beer_id;
