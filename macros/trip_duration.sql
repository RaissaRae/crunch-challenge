{% macro trip_duration(pickup_col, dropoff_col) %}

  datediff(minute, {{ pickup_col }}, {{ dropoff_col }})
{% endmacro %}
