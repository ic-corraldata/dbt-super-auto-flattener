{% macro process_super_tree(plan, table, tree, path) %}
    {% if tree.type == 'object' %}
        {% for key, child in tree.children.items() %}
            {% do plan.parent.update({
                path | replace('.', '__') ~ '__' ~ key: path ~ '.' ~ key
            }) %}
            {% do process_super_tree(plan, table, child, path ~ '.' ~ key) %}
        {% endfor %}
    {% elif tree.type == 'array' %}
        {% do plan.children.append({
            "name": table.split('.')[-1] ~ '_' ~ path | replace('.', '_'),
            "path": path
        }) %}
    {% endif %}
{% endmacro %}
