{% macro generate_super_models(table) %}
    {% set plan = {"parent": {}, "children": []} %}
    {% set base = table.split('.')[-1] %}
    {% set supers = get_super_columns(table) %}

    {% for col in supers %}
        {% set tree = inspect_super_recursive(table, col) %}
        {% do process_super_tree(plan, table, tree, col) %}
    {% endfor %}

    {% do write_file("models/staging/" ~ base ~ "_flat.sql",
        render_parent_model(table, plan)) %}

    {% for child in plan.children %}
        {% do write_file("models/staging/" ~ child.name ~ ".sql",
            render_child_model(table, child)) %}
    {% endfor %}

    {% do write_file("models/staging/super_models.yml",
        render_yaml(base, plan)) %}

    {{ return("SUPER models generated") }}
{% endmacro %}
