{% test assert_non_negative_fares(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} < 0

{% endtest %}