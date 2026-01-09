{% macro render_yaml(base, plan) %}
version: 2

models:
  - name: {{ base }}_flat
    columns:
{% for col, expr in plan.parent.items() %}
      - name: {{ col }}
        description: "Derived from {{ expr }}"
{% endfor %}

{% for child in plan.children %}
  - name: {{ child.name }}
    columns:
      - name: item
        description: "Flattened array element"
{% endfor %}
{% endmacro %}
