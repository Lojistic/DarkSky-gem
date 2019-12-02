# DarkskyWeather::Api

This gem provides a wrapper around the [Dark Sky API](https://darksky.net/dev) for retrieving and analyzing past and current weather forecasts. In order to use this gem, you'll need to [register for an account](https://darksky.net/dev/register) on Dark Sky so that you can get an API key to make requests with. The account is free, and your first 1,000 calls per day are also free. After that, you'll be billed for each subsequent call. See the [Dark Sky FAQ](https://darksky.net/dev/docs/faq) for more details.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'darksky_weather-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install darksky_weather-api

## Usage

The main purpose of this gem is to make it easy to retrieve and perform basic analysis on weather data provided by the Dark Sky API. The goal is to offer simple configuration and an easy-to-use interface for working with the information provided. Once you've set up your account, you'll be ready to go with this gem after just a few configuration steps.

### Configuring a Rails Application

First create `config/initializers/darksky.rb`. Inside that file, place the following contents:

```ruby
DarkskyWeather::Api.configure{|c| c.api_key = "YourDarkskySecretKeyHere" }
```

The above example not withstanding, it's a better security practice to store your API key outside of version control and to pass it in via configuration or environment variables. There are a number of methods for doing so which are beyond the scope of this documentation. In any case, once you've set up the initializer, you're done with all configuration.

### Configuring Other Rack Applications

If you're using an alternative framework like Sinatra or Grape that adheres to the Rack interface, you can place the above configuration line inside your `rackup.ru` file to ensure that it executes before you start using the gem.

### Configuring Any Other Ruby Application

If you're using this gem outside of the context of a rack application, just make sure that the configuration line above is called after you've required the gem but before you use it.

### Fetching The Weather

The gem makes a [forecast request](https://darksky.net/dev/docs#forecast-request) in order to obtain current weather information from the Dark Sky API.

To fetch the current weather for a given location, you'll need to know the latitude and longitude of that location. You can obtain this information via a number of methods in a process called "geocoding". Both Google Maps and Bing Maps provide geocoding API's that will transform an address into a latitude, longitude pair. It's beyond the scope of this documentation to discuss their use in detail. Once you have a latitude, longitude pair to work with, retrieving weather is as simple as instantiating a client and calling a single method:

```ruby
client       = DarkskyWeather::Api::Client.new
opts         = {units: 'auto'}
lat, lng     = [37.8267, -122.4233]
weather_data = client.get_weather(lat: lat, lng: lng, opts: opts)
```

Note the use of kwargs in the method call. Calling the `get_weather` method will return a `WeatherData` object that defines a number of useful methods/attributes. The attributes all correspond to the snake-cased version of the JSON key present in the API response. For instance, `weather_data.currently.apparent_temperature` corresponds with the JSON at `raw_response['currently']['apparentTemperature']`.

The `opts` hash will be converted into a query string and may contain key/value pairs for the four optional query parameters supported by the Darksky Api: `extend`, `units`, `exclude`, and `lang`.

For more information about the optional parameters and all of the data that comes back from the request, [see the documentation](https://darksky.net/dev/docs).

In addition, you can retrieve the URL for your particular API request by calling `source_url` on the `WeatherData` instance.

There are additional methods that are useful for analyzing returned weather data that will be discussed further down.

### Fetching Historical Weather

The gem also supports making [Dark Sky Time Machine Requests](https://darksky.net/dev/docs#time-machine-request). These work identically to a normal forecast request, with the exception that all of the data is related to the specified time in the past. You can make a time machine request by simply passing in a Unix timestamp along with the latitude and longitude in the `get_weather` call:

```ruby
client       = DarkskyWeather::Api::Client.new
lat, lng     = [37.8267, -122.4233]
weather_data = client.get_weather(lat: lat, lng: lng, timestamp: 30.days.ago.to_i)
```

You'll get back a `WeatherData` object, just as before, with all of the same methods and attributes to work with.

### Aggregating Weather Information

The Darksky API is limited in the sense that you may only retrieve one day of historical weather at a time. However, there are many circumstances where you might want to _analyze_ that data as a single unit. For a simple instance, you may want to know what the maximum temperature over a 72 hour period was. To faciliate this sort of multi-day grouping, this gem introduces the concept of a `WeatherCollection`. A `WeatherCollection` is instantiated by passing two or more instances of `WeatherData` to a constructor:

```ruby
client       = DarkskyWeather::Api::Client.new
lat, lng     = [37.8267, -122.4233]
wd1 = client.get_weather(lat: lat, lng: lng, timestamp: 3.days.ago.to_i)
wd2 = client.get_weather(lat: lat, lng: lng, timestamp: 2.days.ago.to_i)
wd3 = client.get_weather(lat: lat, lng: lng, timestamp: 1.days.ago.to_i)

collection = DarkskyWeather::Api::WeatherCollection.new(wd1, wd2, wd3)
```

A `WeatherCollection` is similar to a `WeatherData` object, in that it contains many of the same attributes, (`daily`, `hourly` and `minutely`), and all of the same methods for analyzing hour-by-hour weather information, discussed below. The primary difference lies in the fact that a `WeatherCollection` contains data for the full range of days, collated together.

### Analyzing Weather Information

Whether you're dealing with a `WeatherData` object or a `WeatherCollection`, the gem provides a handful of methods helpful for isolating and analyzing particular information about the weather. These methods are:

* `max_precipitation`: Returns the largest amount of rainfall per hour within the data/collection.
* `max_preciptiation_datetime`: Returns the datetime when the largest amount of rainful per hour occurred within the data/collection.
* `max_accumulation`: Returns the largest amount of snowfall accumulation that occurred within the data/collection.
* `max_accumulation_datetime`: Returns the datetime when the largest amount of snowfall accumulation was recorded within the data/collection.
* `best_visibility`: Returns the best visibility number within the data/collection.
* `best_visibility_datetime`: Returns the datetime when the best visibility within the data/collection was observed.
* `worst_visibility`: Returns the worst visibility number within the data/collection.
* `worst_visibility_datetime`: Returns the datetime when the worst visibility within the data/collection was observed.
* `average_visibility`: Returns the average visibility over the time period within the data/collection.
* `max_temperature`: Returns the highest observed temperature within the data/collection
* `max_temperature_datetime`: Returns the datetime when the highest observed temperature occurred within the data/collection
* `min_temperature`: Returns the lowest observed temperature within the data/collection
* `min_temperature_datetime`: Returns the datetime when the lowest observed temperature occurred within the data/collection
* `max_wind_speed`: Returns the highest observed windspeed within the data/collection.
* `max_wind_speed_datetime`: Returns the datetime when the highest windspeed within the data/collection was observed.
* `average_wind_speed`: Returns the average wind speed within the data/collection.
* `max_wind_gust`: Returns the highest wind gust speed within the data/collection.
* `max_wind_gust_datetime`: Returns the datetime when the highest observed wind gust speed occurred within the data/collection.

Each of the methods above takes an optional array of "hours" as a parameter. If provided, the method will only considered the passed range of hours when returning a value. If left out, the entire array of "hours" returned by the API response will be considered.

In order to get back a narrowed list of hours to work with, you could use standard array slicing methods, but the gem provides two methods that work on either a `WeatherData` or `WeatherCollection` object that will return narrowed sets of hours:

The `weather_at` method takes an integer, (Unix) timestamp, and returns the hour of weather that corresponds with that timestamp. The timestamp doesn't have to be exact. If you pass the Unix time for 12:15 PM, the 12 PM hour will be returned.

The `weather_between` method takes two integer (Unix) timestamps, and returns the hours of weather that fall between them, inclusive. Again, the timestamp doesn't have to be exact.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lojistic/DarkSky-gem. In particular, exposing more weather data through convenience methods and/or adding methods to analyze the data more effectively would be especially appreciated.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
