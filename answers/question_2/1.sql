SELECT ROUND((SUM(CASE WHEN event_location.country = 'HU' THEN 1 ELSE 0 END) * 100.0) /
             COUNT(*), 2) AS percentage_hu_ads
FROM ad
         JOIN event ON ad.event_id = event.id
         JOIN event_location ON event.location_id = event_location.id;
