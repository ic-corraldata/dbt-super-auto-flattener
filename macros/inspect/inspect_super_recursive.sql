{% macro inspect_super_recursive(table, col) %}
    {% set type_sql %}
        SELECT typeof({{ col }})
        FROM {{ table }}
        WHERE {{ col }} IS NOT NULL
        LIMIT 1
    {% endset %}
    {% set dtype = run_query(type_sql).rows[0][0] %}

    {% if dtype == 'object' %}
        {% set keys_sql %}
            SELECT DISTINCT json_object_keys({{ col }})
            FROM {{ table }}
            WHERE {{ col }} IS NOT NULL
            LIMIT 50
        {% endset %}
        {% set keys = run_query(keys_sql).columns[0].values() %}

        {% set children = {} %}
        {% for k in keys %}
            {% do children.update({
                k: inspect_super_recursive(table, col ~ '.' ~ k)
            }) %}
        {% endfor %}

        {{ return({"type": "object", "children": children}) }}

    {% elif dtype == 'array' %}
        {% set element_sql %}
            SELECT typeof({{ col }}[0])
            FROM {{ table }}
            WHERE {{ col }} IS NOT NULL
            LIMIT 1
        {% endset %}
        {% set elem_type = run_query(element_sql).rows[0][0] %}

        {% if elem_type == 'object' %}
            {% set keys_sql %}
                SELECT DISTINCT json_object_keys({{ col }}[0])
                FROM {{ table }}
                WHERE {{ col }} IS NOT NULL
                LIMIT 50
            {% endset %}
            {% set keys = run_query(keys_sql).columns[0].values() %}

            {% set children = {} %}
            {% for k in keys %}
                {% do children.update({
                    k: inspect_super_recursive(table, col ~ '[0].' ~ k)
                }) %}
            {% endfor %}

            {{ return({"type": "array", "children": children}) }}
        {% else %}
            {{ return({"type": "array", "element_type": elem_type}) }}
        {% endif %}
    {% else %}
        {{ return({"type": "scalar"}) }}
    {% endif %}
{% endmacro %}
