-- Analyst level 	
With Kyc_data as
        (
                Select
                        *
                From
                         `project.dataset.kyc`
                Where
                        event_type != 'Unknown'
                and     kyc_analyst is not null
                and     EXTRACT(YEAR FROM event_timestamp) = 2024
                and     EXTRACT(month FROM event_timestamp) in (1,2)),
        FirstInteraction as
        (
                Select
                        *,
                        row_number() over
                                          (
                                                  partition by case_id,
                                                          kyc_analyst
                                                  ORDER BY event_timestamp asc
                                          )
                        as event_number
                From
                        Kyc_data qualify event_number = 1),
        LastInteraction as
        (
                Select
                        *,
                        row_number() over
                                          (
                                                  partition by case_id,
                                                          kyc_analyst
                                                  ORDER BY event_timestamp desc
                                          )
                        as event_number
                From
                        Kyc_data qualify event_number = 1),
        caseAggregated as
        (
                Select
                        f.case_id                            ,
                        f.kyc_analyst                        ,
                        f.event_timestamp as first_timestamp ,
                        f.event_type      as first_event_type,
                        l.event_timestamp as last_timestamp  ,
                        l.event_type      as last_event_type
                From
                        FirstInteraction f
                join
                        LastInteraction l
                on
                        f.case_id     = l.case_id
                and     f.kyc_analyst = l.kyc_analyst),
        handlingtime as
        (
                Select
                        *,
                        datetime_diff(last_timestamp,first_timestamp, second) as handling_time
                From
                        caseAggregated)
Select
        kyc_analyst                                 ,
        Round(Avg( handling_time),2) as AHT_analyst ,
        Count(Distinct case_id) cases_handled       ,
From
        handlingtime
Where
        last_event_type = 'SubmitResults'
and     handling_time   > 0
Group by
        1
Order by
        2 desc