-- 5 oldest users
Select * 
From users
order by created_at limit 5;

-- Number of photos uploaded by each user
SELECT u.username,p.user_id, COUNT(p.user_id) as photos_uploaded
FROM photos as p
Join users as u
ON p.user_id = u.id
GROUP BY user_id;

-- Average number of photos uploaded by one user 
SELECT (SELECT count(*) FROM photos)/(SELECT count(*) FROM users) AS avg;

-- To target our inactive users with an email campaign, It is necessary to know users who have never posted a photo. 
SELECT id, username
from users
WHERE id not in (SELECT user_id
from photos); 

-- Which day most people create their account
SELECT date_format(created_at, '%W')as Day,COUNT(id)as number_of_accounts_created
FROM users
GROUP BY date_format(created_at, '%W')
ORDER BY COUNT(id) desc;

-- Who can get the most likes on a single photo.
SELECT u.username, p.id, p.image_url, COUNT(*) AS total_likes
FROM photos as p
INNER JOIN likes as l
    ON l.photo_id = p.id
INNER JOIN users as u
    ON p.user_id = u.id
GROUP BY p.id
ORDER BY total_likes DESC
limit 1;

-- user ranking by posts higher to lower
SELECT u.username, Count(p.image_url)
FROM users as u
JOIN photos as p
ON u.id = p.user_id
group by p.user_id
ORDER BY Count(p.image_url) desc;

-- Total numbers of users who have posted at least one time
SELECT Count(id)
from users
WHERE id in (SELECT user_id FROM photos);

-- What are the top 5 most commonly used hashtags?
SELECT t.tag_name,Count(t.id) as total
From tags as t
Join photo_tags as pt
ON t.id = pt.tag_id
group by t.id
order by total desc
limit 5;

-- Users who have liked every single photo on the site
Select user_id, Count(user_id) total_likes 
from likes 
group by user_id
having count(user_id) in (Select Count(*) from photos);

--  Users who have never commented on a photo
Select id, username 
from users
where id not in (SELECT user_id from comments)






