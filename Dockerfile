FROM postgres

# ENV POSTGRES_USER=postgres_user
# ENV POSTGRES_PASSWORD=postgres_password
# ENV POSTGRES_DB=postgres_db

docker pull postgres
docker run --name postgres-container -e POSTGRES_USER=postgres_user -e POSTGRES_PASSWORD=postgres_password -e POSTGRES_DB=postgres_db -d -p 5432:5432 postgres
docker run --name psql-container\
	--link postgres-container:postgres\ # docker container and image 
	-it postgres\ # image
	 psql -h postgres -U postgres_user postgres_db
