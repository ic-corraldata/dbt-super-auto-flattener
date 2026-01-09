{% macro inspect_super_recursive(table, column, path=[]) %}
    {% set sql %}
        SELECT
            json_extract_path_text({{ column }}, '{{ path | join("','") }}') IS NOT NULL AS exists,
            json_typeof(json_extract_path({{ column }}, '{{ path | join("','") }}')) AS type
        FROM {{ table }}
        WHERE {{ column }} IS NOT NULL
        LIMIT 100
    {% endset %}

    {# Pseudocode — result used to branch #}
    {% if type == 'array' %}
        {{ return({"path": path, "cardinality": "many"}) }}
    {% elif type == 'object' %}
        {# recurse into keys #}
    {% else %}
        {{ return({"path": path, "cardinality": "one"}) }}
    {% endif %}
{% endmacro %}
