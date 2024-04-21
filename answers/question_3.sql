SELECT filtered_ad.id                                    AS ad_id,
       ad_ticket_count.id                                AS ad_ticket_count_id,
       event.event_end                                   AS event_end,
       ad_ticket_count.counter                           AS ad_ticket_count,
       SUM(CASE WHEN event.is_expired THEN 1 ELSE 0 END) AS expired_count
FROM (SELECT *
      FROM website.ad
      WHERE source NOT IN ('web-mobile', 'web')
        AND source IS NOT NULL) AS filtered_ad
         LEFT JOIN
     (SELECT * FROM website.event WHERE is_verified ORDER BY created_at) AS event
     ON filtered_ad.event_id = event.id
         LEFT JOIN
     (SELECT ad_id, COUNT(*) AS counter
      FROM website.ad_ticket
      GROUP BY ad_id) AS ad_ticket_count ON filtered_ad.id = ad_ticket_count.ad_id
GROUP BY filtered_ad.id, ad_ticket_count.id, event.event_end, ad_ticket_count.counter;

-- Changes:
-- 1. Made the commands all capital case.
-- 2. Formatted the lines.
-- 3. Used 0 instead of False in the CASE statement.
-- 4. Used aliases for all selected columns in the returned table.
-- 5. Changed the existing aliases for clarity.
-- 6. Swapped "left inner join" with "LEFT JOIN".
-- 7. Moved the filtering on the website.ad.source column to an earlier location to make
--    the query faster. I placed the filtering on when we first get the ad table.
-- 8. Fixed the filtering such that NULL check is done properly with "IS NOT NULL".
-- 9. Removed the final grouping column (5) as it is an aggregate function and not a
--    column.
