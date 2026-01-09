# dbt-super-auto-flattener

A dbt package that recursively inspects Amazon Redshift SUPER columns and
generates relational dbt models.

## Usage

```bash
dbt run-operation generate_super_models --args '{"table": "raw.events"}'
