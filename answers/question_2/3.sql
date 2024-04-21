SELECT COUNT(*) AS sold_pixies_listings
FROM ad
         JOIN event ON ad.event_id = event.id
WHERE event.title LIKE '%Pixies%'
  AND ad.is_sold = 1;
