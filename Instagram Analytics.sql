likesUSE ig_clone;

#1 Find the 5 oldest users of the Instagram from the database provided.

SELECT 
	username, 
    created_at
FROM users
ORDER BY created_at 
LIMIT 5;users

/*
	username		| 			created_at
--------------------|--------------------------
Darby_Herzog		|		2016-05-06 00:14:21
Emilio_Bernier52	|		2016-05-06 13:04:30
Elenor88			|		2016-05-08 01:30:41
Nicole71			|		2016-05-09 17:30:22
Jordyn.Jacobson2	|		2016-05-14 07:56:26
*/


#2 Find the users who have never posted a single photo on Instagram.

SELECT 
	u.id,
	username
FROM users u
LEFT JOIN photos p
	ON u.id = p.user_id
WHERE p.user_id IS NULL
ORDER BY u.username;

/*
id		|		username
--------|---------------------------
5		|	Aniya_Hackett
83		|	Bartholome.Bernhard
91		|	Bethany20
80		|	Darby_Herzog
45		|	David.Osinski47
54		|	Duane60
90		|	Esmeralda.Mraz57
81		|	Esther.Zulauf61
68		|	Franco_Keebler64
74		|	Hulda.Macejkovic
14		|	Jaclyn81
76		|	Janelle.Nikolaus81
89		|	Jessyca_West
57		|	Julien_Schmidt
7		|	Kasandra_Homenick
75		|	Leslie67
53		|	Linnea59
24		|	Maxwell.Halvorson
41		|	Mckenna17
66		|	Mike.Auer39
49		|	Morgan.Kassulke
71		|	Nia_Haag
36		|	Ollie_Ledner37
34		|	Pearl7
21		|	Rocio33
25		|	Tierra.Trantow

*/

#3 Identify the winner of the contest and provide their details to the team.

SELECT
	u.id,
	u.username,
    p.image_url,
	count(l.user_id) AS Likes
FROM likes l
INNER JOIN photos p
	ON l.photo_id = p.id
INNER JOIN users u
	ON p.user_id = u.id
GROUP BY l.photo_id, u.username
ORDER BY Likes DESC
LIMIT 1;

/*
	id		|		username		|		image_url		|		Likes
------------|-----------------------|-----------------------|-----------------
	52		|		Zack_Kemmer93	|	https://jarret.name	|		48
    
*/


#4 Identify and suggest the top 5 most commonly used hashtags on the platform.

SELECT 
	t.tag_name,
    COUNT(p.photo_id) AS num_tags
FROM photo_tags p
INNER JOIN tags t
	ON p.tag_id = t.id
GROUP BY tag_name 
ORDER BY num_tags DESC
LIMIT 5;

/*
tag_name		|		num_tags
----------------|---------------------
smile			|		59
beach			|		42
party			|		39
fun				|		38
concert			|		24
*/


#5 What day of the week do most users register on? Provide insights on when to schedule an ad campaign.

/*
	0 - Monday 
	1 - Tuesday
	2 - Wednesday
	3 - Thursday 
	4 - Friday
	5 - Saturday 
	6 - Sunday
*/

SELECT 
	WEEKDAY(created_at) AS weekday,
	COUNT(username) AS num_users
FROM users 
GROUP BY 1
ORDER BY 2 DESC;

/*
weekday		|	num_users
------------|-----------------
	3		|	16
	6		|	16
	4		|	15
	1		|	14
	0		|	14
	2		|	13
	5		|	12
*/

#6 Provide how many times does average user posts on Instagram. 
# Also, provide the total number of photos on Instagram/total number of users

WITH CTE AS 
(
	SELECT
		u.id AS userid, 
		COUNT(p.id) AS photoid
	FROM users u
	LEFT JOIN photos p
		ON u.id = p.user_id
	GROUP BY u.id
)
SELECT 
    SUM(photoid)/COUNT(userid) AS photos_per_user
FROM CTE
WHERE photoid >0
;
      
/*
photos_per_user
---------------
3.4730
*/


WITH CTE AS 
(
	SELECT
		u.id AS userid, 
		COUNT(p.id) AS photoid
	FROM users u
	LEFT JOIN photos p
		ON u.id = p.user_id
	GROUP BY u.id
)
SELECT 
	SUM(photoid) AS total_photos, 
    COUNT(userid) AS total_users, 
    SUM(photoid)/COUNT(userid) AS photos_per_user
FROM CTE;

/*
total_photos	|	total_users	|	photos_per_user
----------------|---------------|-------------------
	257			|		100		|		2.5700
*/


#7 Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).

WITH photo_count as
(
	SELECT 
		l.user_id, u.username,
		COUNT(l.photo_id) AS num_like
	FROM likes l 
    Join users u on l.user_id=u.id
	GROUP BY user_id
	ORDER BY user_id 
)
SELECT 
	*
FROM photo_count
WHERE num_like = (SELECT COUNT(*) FROM photos);


/*
user_id		|	username			|	num_like
------------|-----------------------|--------------
	5		|	Aniya_Hackett		|	257
	91		|	Bethany20			|	257
	54		|	Duane60				|	257
	14		|	Jaclyn81			|	257
	76		|	Janelle.Nikolaus81	|	257
	57		|	Julien_Schmidt		|	257
	75		|	Leslie67			|	257
	24		|	Maxwell.Halvorson	|	257
	41		|	Mckenna17			|	257
	66		|	Mike.Auer39			|	257
	71		|	Nia_Haag			|	257
	36		|	Ollie_Ledner37		|	257
	21		|	Rocio33				|	257
*/