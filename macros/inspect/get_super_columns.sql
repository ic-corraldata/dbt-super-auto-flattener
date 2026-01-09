{% macro get_super_columns(table) %}
    {% set sql %}
        SELECT column_name
        FROM pg_table_def
        WHERE tablename = '{{ table.split('.')[-1] }}'
          AND type = 'super'
    {% endset %}

    {% set result = run_query(sql) %}
    {{ return(result.columns[0].values()) }}
{% endmacro %}
