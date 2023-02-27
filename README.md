# README

## 初回起動
```
// $ docker-compose run web rails new . --api --force --no-deps --database=postgresql
$ docker-compose build
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate
```

## 起動
```
$ docker-compose up
```
http://0.0.0.0:3000