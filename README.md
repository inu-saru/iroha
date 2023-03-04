# README

## 初回起動
```
// $ docker-compose run web rails new . --api --force --no-deps --database=postgresql
$ docker compose build
$ docker compose run web rails db:create
$ docker compose run web rails db:migrate
```

## 起動
```
$ docker compose up
```
http://0.0.0.0:3000

## pre-commit
commit 時にrubocop を起動させる設定
```
cp pre-commit.sample .git/hooks/pre-commit
chmod a+x .git/hooks/pre-commit
```