db:
	@mysql -uroot -proot < SQL_creacion_tablas.sql
	@mysql -uroot -proot < SQL_populacion_tablas.sql

run:
	@mysql -uroot -proot < SQL_queries.sql
