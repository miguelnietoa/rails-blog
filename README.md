# Rails Blog
My blog

## Install dependencies
```bash
bundle install && yarn install
```

## Recompile webpack
If you want to recompile webpack, run the following command:
```bash
rails webpacker:clean && rails webpacker:clobber && rails webpacker:compile
```

## Run app
```bash
rails server
```
