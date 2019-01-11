# VideoSocialBookmark
## エレベータピッチ
複数の動画サービスを切り替えることなく動画を探したり観たりしたい動画サービス利用者向けの、VideoSocialBookmarkというソーシャルブックマークサービスです。はてぶやRedditとは違って、動画を再生したりプレイリストを作成する機能が備わっています。
## Usage
1. `$ mkdir workdir && cd workdir`
2. `$ touch docker-compose.yml Dockerfile`
3. Edit docker-compose.yml and Dockerfile.
4. `$ git clone git@github.com:enpitut2018/VideoSocialBookmark.git`
5. `$ git submodule init && git submodule update`
5. `$ docker-compose up --build -d`
6. `$ docker-compose exec web /bin/bash`
7. `# bundle install && yarn postinstall && rails db:setup && rails s`
8. Access to [localhost:3000](http://localhost:3000).

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.5.0

* System dependencies
docker(docker-compose)

* Configuration

* Database creation
require postgresql
`$ rails db:create`

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
