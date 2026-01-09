{% macro generate_super_plan(table) %}
    {% set supers = get_super_columns(table) %}
    {% if supers | length == 0 %}
        {% do log("No SUPER columns found.", info=True) %}
        {{ return(None) }}
    {% endif %}

    {% set plan = build_plan(table, supers) %}

    {% do log("===== SUPER FLATTEN PLAN =====", info=True) %}
    {% do log("Table: " ~ table, info=True) %}
    {% do log("Detected SUPER columns: " ~ supers | join(', '), info=True) %}

    {% do log("===== MODEL: " ~ plan.parent.name ~ " =====", info=True) %}
    {% do log(render_parent_model(plan.parent), info=True) %}

    {% for child in plan.children %}
        {% do log("===== MODEL: " ~ child.name ~ " =====", info=True) %}
        {% do log(render_child_model(child), info=True) %}
    {% endfor %}

    {% do log("===== SCHEMA YAML =====", info=True) %}
    {% do log(render_schema_yaml(plan), info=True) %}

    {{ return("Plan generated") }}
{% endmacro %}
