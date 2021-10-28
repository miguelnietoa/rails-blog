# Bloggy
An awesome blog built with Ruby on Rails.

[Live view](https://bloggy123.herokuapp.com/)

## Technologies
- Ruby on Rails 6.1
- PostgreSQL 14.0
- TailwindCSS
- FontAwesome


## Install dependencies
```bash
bundle && yarn
```

## Initialize the database
```bash
rails db:create db:migrate db:seed
```

## Recompile webpack
```bash
rails webpacker:clean && rails webpacker:clobber && rails webpacker:compile
```

## Run app
```bash
rails s
```
