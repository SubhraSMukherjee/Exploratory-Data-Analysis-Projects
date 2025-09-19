-- Monthly average total margin
Select
        EXTRACT(MONTH FROM date) AS month,
        Avg(total_margin)                ,
        Count(Distinct order_number)
From
        `project.dataset.daily_transaction_aggregated`
Group by
        1
Order by
        1 asc;
		
-- Monthly Share Desktop Orders
Select
                           *,
        Round(Mobile_orders/Desktop_orders,3)
From
        (
                Select
                        EXTRACT(MONTH FROM date) AS month,
                        Count(Distinct
                        Case
                        When
                                device = 'Mobile'
                        Then
                                order_number
                        Else
                                Null
                        End) as Mobile_orders,
                        Count(Distinct
                        Case
                        When
                                device = 'Desktop'
                        Then
                                order_number
                        Else
                                Null
                        End) as Desktop_orders,
                From
                        `project.dataset.daily_transaction_aggregated`
                Group by
                        1
                Order by
                        1 asc);
						
-- Monthly Share Return Orders						
Select
                           *,
        Round(Return_orders/(Return_orders+One_Way_orders),3)
From
        (
                Select
                        EXTRACT(MONTH FROM date) AS month,
                        Count(Distinct
                        Case
                        When
                                flight_type = 'Return'
                        Then
                                order_number
                        Else
                                Null
                        End) as Return_orders,
                        Count(Distinct
                        Case
                        When
                                device = 'One Way'
                        Then
                                order_number
                        Else
                                Null
                        End) as One_Way_orders,
                From
                        `project.dataset.daily_transaction_aggregated`
                Group by
                        1
                Order by
                        1 asc);

-- Channel fee 	
Select
        EXTRACT(MONTH FROM date) AS month,
        Avg(channel_fee)                 ,
        Count(Distinct order_number)
From
        `project.dataset.daily_transaction_aggregated`
Group by
        1
Order by
        1 asc;

--Travix Clicks share
Select
                           *,
        Round(clicks_travix/(clicks_travix+clicks_competitor+clicks_airlines),3)
From
        (
                Select
                        EXTRACT(MONTH FROM date) AS month            ,
                        Sum(clicks_travix)       as clicks_travix    ,
                        Sum(clicks_competitor)   as clicks_competitor,
                        Sum(clicks_airlines)     as clicks_airlines
                From
                        `project.dataset.daily_clicks_aggregated`
                Group by
                        1);
						
-- Mean Total Margin with Lead time						
Select
        DATE_DIFF(departure_date, date, day) AS date_diff,
		Avg(total_margin)                ,
        Count(Distinct order_number)
From
        `project.dataset.daily_transaction_aggregated`
Group by
        1
Order by
        1 asc;


-- Monthly leadtime average		
Select
        EXTRACT(MONTH FROM date)                  AS month        ,
        Avg(DATE_DIFF(departure_date, date, day)) AS avg_date_diff,
From
        `project.dataset.daily_transaction_aggregated`
Where
        DATE_DIFF(departure_date, date, day) <= 32
Group by
        1
Order by
        1 asc;
		

		

-- Total margin by percentiles
Select
        Sum(total_margin) as total_margin,
        Sum(
                Case
                When
                        total_margin >
                        (
                                Select        Distinct
                                        PERCENTILE_CONT(total_margin, 0.8) OVER ()
                                From
                                        `project.dataset.daily_transaction_aggregated`
                                Where
                                        EXTRACT(MONTH FROM date) = 3)
                Then
                        total_margin
                Else
                        Null
                End) as sum_top_20_percentile
From
        `project.dataset.daily_transaction_aggregated`
Where
        EXTRACT(MONTH FROM date) = 3
		


Select
        Count(distinct order_number),
        Count(Distinct
        Case
        When
                total_margin >
                (
                        Select        Distinct
                                PERCENTILE_CONT(total_margin, 0.8) OVER ()
                        From
                                `project.dataset.daily_transaction_aggregated`
                        Where
                                EXTRACT(MONTH FROM date) = 3)
        Then
                order_number
        Else
                Null
        End) as sum_top_20_percentile
From
        `project.dataset.daily_transaction_aggregated`
Where
        EXTRACT(MONTH FROM date) = 3;
		
		

Select
        supplier          ,
        Avg(total_margin) ,
        Count(Distinct order_number)
From
        `project.dataset.daily_transaction_aggregated`
Where
        EXTRACT(MONTH FROM date) = 1
and     supplier in
        (
                Select
                        supplier
                From
                        (
                                Select
                                        supplier,
                                        Count(Distinct order_number)
                                From
                                        `project.dataset.daily_transaction_aggregated`
                                Group by
                                        1
                                Order by
                                        2 desc limit 10))
Group by
        1
Order by
        1 asc;



						


		
		
		