With Price_Median_Data as
        (
                Select
                        EXTRACT(YEAR from created_at)            as Year        ,
                        EXTRACT(Month from created_at)           as Month       ,
                        APPROX_QUANTILES(price, 100)[OFFSET(50)] as Median_Price,
                        Count(city)                              as listings
                From
                        poetic-hexagon-412017.Trial.HA_Clean
                Where
                        city = 'Milan'
                Group by
                        1,2
                Order by
                        1,2)
Select
                             *,
        Round( (Median_Price + LAG(Median_Price, 1) OVER (ORDER BY Year,Month ASC) + LAG(Median_Price, 2) OVER (ORDER BY Year,Month ASC) ) / 3 , 2) as rolling_average
From
        Price_Median_Data
Order by
        1,2