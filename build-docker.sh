# https://github.com/sameersbn/docker-postgresql

docker pull sameersbn/postgresql:12-20200524
docker build -t sameersbn/postgresql github.com/sameersbn/docker-postgresql
docker run --name postgresql -itd --restart always \
  --publish 5432:5432 \
  --volume postgresql:/vol/postgresql \
  sameersbn/postgresql:12-20200524
docker exec -it postgresql sudo -u postgres psql
