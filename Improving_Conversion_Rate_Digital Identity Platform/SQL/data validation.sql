Select
        *
From
        `project.dataset.kyc`
Where
        event_type != 'Unknown'
and     kyc_analyst is not null
and     EXTRACT(YEAR FROM event_timestamp) = 2024
and     EXTRACT(month FROM event_timestamp) in (1,2)