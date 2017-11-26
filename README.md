# Test application
Exchanging US dollar/Euro using ECB rates from:
https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A

## Require:

    Ruby 2.2 or newer

Sequel database toolkit

    gem install sequel

The database that you prefer to use.
Default requires `sqlite3`

## Configuration:

You can choose which database you want to use in `db_adapter.rb`
The default is `sqlite3` which stored in RAM memory, because it's fast.
But you can set up a connection to any of the static databases.
The first initialization will take some time, but in the future the database will be updated only if necessary.

## Usage:

```bash
git clone https://github.com/Paqwtv/Test-script-app.git
```

Require `exchanger.rb` to **irb** or your **Rails application**

```ruby
  Exchanger.exchange(110.23, Date.yesterday - 24, Date.today, '2017-01-25')
  => [127.99908, "Sorry, no data for 2017-11-26", 118.42009]
```
