Select
        city                         ,
        Count(city)                              as Count_Listings,
        Avg(price)                               as Average_Price ,
        APPROX_QUANTILES(price, 100)[OFFSET(50)] as Median_Price
From
        poetic-hexagon-412017.Trial.HA_Clean
Group by
        city
Order by
        2 desc