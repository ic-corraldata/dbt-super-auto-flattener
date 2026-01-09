{% macro render_parent_model(table, plan) %}
SELECT
    -- TODO: Add base columns manually
    {{ plan.parent.values() | join(',\n    ') }}
FROM {{ table }};
{% endmacro %}
