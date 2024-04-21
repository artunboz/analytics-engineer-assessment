SELECT ROUND(AVG(ad.original_price), 2) AS avg_org_price_nl
FROM ad
         JOIN event ON ad.event_id = event.id
         JOIN event_location ON event.location_id = event_location.id
WHERE event_location.country = 'NL';

-- I noticed that, for certain events, there are more than one unique original_price
-- values. This makes me think that the original_price column does not mean the original
-- price of the event, but rather the price of the ad. If we want to prevent popular
-- events from having too much influence on the average price (because they have many
-- more ads), we should first calculate the average per event, and then take the average
-- of those averages. The query below does that.

SELECT ROUND(AVG(event_avg_org_price), 2) AS avg_org_price_nl
FROM (SELECT event.id               AS event_id,
             AVG(ad.original_price) AS event_avg_org_price
      FROM ad
               JOIN event ON ad.event_id = event.id
               JOIN event_location ON event.location_id = event_location.id
      WHERE event_location.country = 'NL'
      GROUP BY event.id) AS avg_org_price_per_event_nl;
