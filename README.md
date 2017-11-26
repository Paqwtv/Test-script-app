# Test application
Exchanging US dollar/Euro using ECB rates from:
https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A

## Require:

    Ruby 2.2 or newer

Sequel database toolkit

    gem install sequel

## Usage:

```bash
git clone https://github.com/Paqwtv/Test-script-app.git
```

Require `exchanger.rb` to irb or 

```ruby
  Exchanger.exchange(110.23, Date.yesterday - 24, Date.today, '2017-01-25')
  => [127.99908, "Sorry, no data for 2017-11-26", 118.42009]
```
