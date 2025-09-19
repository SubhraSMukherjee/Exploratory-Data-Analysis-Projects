-- Team level 	
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
                                                  partition by case_id
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
                                                  partition by case_id
                                                  ORDER BY event_timestamp desc
                                          )
                        as event_number
                From
                        Kyc_data qualify event_number = 1),
        caseAggregated as
        (
                Select
                        f.case_id                            ,
                        f.event_timestamp as first_timestamp ,
                        f.event_type      as first_event_type,
                        l.event_timestamp as last_timestamp  ,
                        l.event_type      as last_event_type
                From
                        FirstInteraction f
                join
                        LastInteraction l
                on
                        f.case_id = l.case_id),
        handlingtime as
        (
                Select
                        *,
                        datetime_diff(last_timestamp,first_timestamp, second) as handling_time
                From
                        caseAggregated)
Select
        EXTRACT(YEAR FROM first_timestamp)  as Year ,
        EXTRACT(month FROM first_timestamp) as Month,
        Round(Avg(
                Case
                When
                        last_event_type = 'SubmitResults'
                Then
                        handling_time
                Else
                        Null
                End ),2) as AHT_SubmitResults,
        Count( Distinct
        Case
        When
                last_event_type = 'SubmitResults'
        Then
                case_id
        Else
                Null
        End ) as CaseCounts_SubmitResults,
        Round(Avg(
                Case
                When
                        last_event_type = 'AssignVerification'
                Then
                        handling_time
                Else
                        Null
                End ) ,2) as AHT_AssignVerification,
        Count( Distinct
        Case
        When
                last_event_type = 'AssignVerification'
        Then
                case_id
        Else
                Null
        End )                       as CaseCounts_AssignVerification,
        Round(Avg(handling_time),2) as AHT                          ,
        Count(Distinct case_id)     as CaseCounts_Total
from
        handlingtime
Where
        handling_time>0
Group by
        1,2
Order by
        1,2