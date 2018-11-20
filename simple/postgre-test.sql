--Question1
SELECT
		b.user_id
	,	avg(b.balance) avgBalance
	,	avg(s.swipes) avgSwipes
FROM
	customer_balances b
	LEFT JOIN customer_swipe s
		ON	s.user_id = b.user_id
		AND	s.date BETWEEN '2017-12-01' AND '2017-12-31'
WHERE
		b.user_id = 'c99a5f84f2165c2808a2f0d314fac243'
	AND	b.date BETWEEN '2017-12-01' AND '2017-12-31'
GROUP BY
		b.user_id

--Question 2
SELECT user_id, totalswipes FROM (
SELECT
		user_id
	,	sum(swipes) totalSwipes
	,	row_number() OVER (ORDER BY sum(swipes) DESC) myRow
FROM
	customer_swipe
WHERE
		date BETWEEN '2017-02-01' AND '2017-02-01'
GROUP BY
		user_id
) a WHERE myRow=5

--Question 3
SELECT
		count(distinct b.user_id) answerTotal
FROM
		customer_balances b
		LEFT JOIN customer_swipe s
			ON	s.user_id = b.user_id
			AND	s.date = b.date
WHERE
		b.date BETWEEN '2017-11-01' AND '2017-11-30'
	AND	b.balance > 0
	AND s.swipes IS NULL

--Question 4
WITH user_pop AS (
SELECT DISTINCT
		b.user_id
FROM
		customer_balances b
		LEFT JOIN customer_swipe s
			ON	s.user_id = b.user_id
			AND	s.date = b.date
WHERE
		b.date BETWEEN '2017-11-01' AND '2017-11-30'
	AND	b.balance > 0
	AND s.swipes IS NULL
),
avgs AS (
SELECT
  		to_char(b.date, 'FMMonth') as Month
	,	p.user_id
  	,	avg(b.balance) avgBalance
  	,	avg(s.swipes) avgSwipes
FROM
  	customer_balances b
  	LEFT JOIN customer_swipe s
  		ON	s.user_id = b.user_id
  		AND	s.date = b.date
  	INNER JOIN user_pop p
  		ON	p.user_id = b.user_id
GROUP BY
  		to_char(b.date, 'FMMonth')
  	,	p.user_id
)

SELECT
		month
	,	avg(avgbalance) avgBalanceAll
	,	avg(avgswipes) avgSwipesAll
FROM
	avgs
GROUP BY
		month
