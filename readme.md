## Gerekenler

* `ruby 2.1.5`
* `git`
* [Heroku][heroku] hesabı.
* [Heroku Toolbelt][toolbelt]

## Kurulum

```bash
bundle install --path vendor/bundle  # ilgili ruby gem'leri kuralım

bundle exec rake run:shotgun # sunucuyu shotgun ile çalıştırmak için... ya da
bundle exec rake run:rackup  # rackup ile çalıştırmak için
```


[heroku]:       http://heroku.com
[toolbelt]:     https://toolbelt.heroku.com/