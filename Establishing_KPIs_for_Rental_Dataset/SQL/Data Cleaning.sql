Select
        city         ,
        category     ,
        country_code ,
        created_at   ,
        price        ,
        Case
        When
                furnished != 'null'
        Then
                REGEXP_EXTRACT(furnished, r'[a-zA-Z]+')
        Else
                Null
        End as furnished ,
        Case
        When
                total_size != 'null'
        Then
                CAST( REGEXP_EXTRACT(total_size, r'[0-9]+') as Numeric)
        Else
                Null
        End as total_size,
        Case
        When
                registration_possible != 'null'
        Then
                REGEXP_EXTRACT(registration_possible, r'[a-zA-Z]+')
        Else
                Null
        End as registration_possible,
        Case
        When
                washing_machine != 'null'
        Then
                REGEXP_EXTRACT(washing_machine, r'[a-zA-Z]+')
        Else
                Null
        End as washing_machine,
        Case
        When
                tv != 'null'
        Then
                REGEXP_EXTRACT(tv, r'[a-zA-Z]+')
        Else
                Null
        End as tv,
        Case
        When
                balcony != 'null'
        Then
                REGEXP_EXTRACT(balcony, r'[a-zA-Z]+')
        Else
                Null
        End as balcony,
        Case
        When
                garden != 'null'
        Then
                REGEXP_EXTRACT(garden, r'[a-zA-Z]+')
        Else
                Null
        End as garden,
        Case
        When
                terrace != 'null'
        Then
                REGEXP_EXTRACT(terrace, r'[a-zA-Z]+')
        Else
                Null
        End as terrace
from
        poetic-hexagon-412017.Trial.Ha
