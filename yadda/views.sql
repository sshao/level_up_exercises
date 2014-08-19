DROP VIEW IF EXISTS brewery_top_beers;

-- wtf
CREATE VIEW brewery_top_beers AS
SELECT brewery.name, brewery.brewery_id, array_agg(beer_name)
FROM yadda.breweries AS brewery
LEFT JOIN (
  SELECT * FROM (
    SELECT beer.beer_id, beer.name AS beer_name, beer.brewery_id, AVG(rate.score) AS ave, ROW_NUMBER() OVER (PARTITION BY beer.brewery_id ORDER BY AVG(rate.score)) AS rownum
    FROM yadda.beers AS beer 
    LEFT JOIN yadda.ratings rate 
      ON beer.beer_id = rate.beer_id 
      GROUP BY beer.brewery_id, beer.beer_id 
    ) tmp
  WHERE rownum < 4
) AS x ON x.brewery_id = brewery.brewery_id 
GROUP BY brewery.name, brewery.brewery_id
ORDER BY brewery.brewery_id;

-- jesus
CREATE VIEW beer_recent_scores AS
SELECT beer.name, AVG(recent_score)
FROM yadda.beers AS beer
LEFT JOIN (
  SELECT beer_id, score as recent_score
  FROM (
    SELECT rating.beer_id, rating.rating_id, rating.score, rating.updated_at as updated_at
    FROM yadda.ratings as rating 
    GROUP BY rating.beer_id, rating.rating_id, rating.score, rating.updated_at
  ) tmp
  WHERE updated_at >= NOW() - INTERVAL '6 months'
) AS x ON x.beer_id = beer.beer_id
GROUP BY beer.name
ORDER BY beer.name;

-- fuck it
CREATE VIEW more_like_this_beer_id AS
SELECT primary_beer.beer_id, array_agg(x.name ORDER BY RANDOM())
FROM yadda.beers AS primary_beer 
LEFT JOIN (
  SELECT * FROM(
    SELECT style, name FROM (
      SELECT beer.beer_id, beer.name, beer.style, AVG(rate.score), ROW_NUMBER() OVER (PARTITION BY beer.style ORDER BY AVG(rate.score) DESC) as row_num
      FROM yadda.beers AS beer
      LEFT JOIN yadda.ratings rate
      ON beer.beer_id = rate.beer_id
      GROUP BY beer.beer_id
    ) tmp
    WHERE row_num < 6
    GROUP BY style, name, avg
  ) fuck
  GROUP BY style, name
) AS x ON x.style = primary_beer.style
GROUP BY primary_beer.beer_id;
