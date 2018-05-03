db:
	@mysql -uroot < SQL_creacion_tablas.sql
	@mysql -uroot < SQL_populacion_tablas.sql

run:
	@mysql -uroot < SQL_queries.sql
