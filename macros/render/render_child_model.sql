{% macro render_child_model(table, child) %}
SELECT
    t.<PRIMARY_KEY>, -- replace
    f.value AS item
FROM {{ table }} t,
     TABLE_FLATTEN(input => {{ child.path }}) f;
{% endmacro %}
