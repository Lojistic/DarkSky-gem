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
client    = DarkskyWeather::Api::Client.new
lat, lng  = [37.8267, -122.4233]
client.get_weather(lat: lat, lng: lng)
```

Note the use of kwargs in the method call. Calling the `get_weather` method will return a `WeatherData` object that defines a number of useful methods/attributes:

Calling the `attributes` method on a `WeatherData` instance will return a Hash of the following information:

* `current_precipitation`: The amount of liquid rain in inches that has fallen as of the time of the weather report.
* `current_accumulation`: The amount of snow accumulation, in inches, that is present as of the time of the weather report.
* `current_visibility`: The number of miles of visibility at the time of the weather report.
* `current_temperature`: The temperature, in fahrenheit, at the time of the weather report.
* `current_wind_speed`: The sustained wind speed, in miles per hour, at the time of the weather report.
* `current_wind_gust`: The wind gust speed, in miles per hour, at the time of the weather report.
* `max_precipitation`: The largest amount of liquid rain, in inches, expected to fall on the day of the weather report.
* `max_accumulation`: The largest amount of snow accumulation, in inches, expected for the day of the report.
* `worst_visibility`: The worst visbility, (in terms of miles), expected for the day of the report.
* `max_temperature`: The highest temperature, in fahrenheit, expected for the day of the report.
* `min_temperature`: The lowest temperature, in fahrenheit, expected for the day of the report.
* `max_wind_speed`: The highest sustained wind speed, in miles per hour, expected for the day of the report.
* `max_wind_gust`: The highest wind gust speed, in miles per hour, expected for the day of the report.
* `report_date`: The date that the report was requested for.

Each of the data points in the Hash above _also_ corresponds to a method on the `WeatherData` instance. So, if you just want to know what the `max_precipitation` is, this is perfectly valid:

```ruby
client       = DarkskyWeather::Api::Client.new
lat, lng     = [37.8267, -122.4233]
weather_data = client.get_weather(lat: lat, lng: lng)

puts weather_data.max_precipitation

```
These attributes and convenience methods do _not_ represent the entirety of the data returned by the API call. Instead, the gem focuses on trying to present the data that's likely to be most useful for most contexts. That said, it is always possible to get back the entire API response as a Hash:

```ruby
  weather_data = client.get_weather(lat: lat, lng: lng)
  response = weather_data.raw
```

For more information about all of the data that comes back from the request, [see the documentation](https://darksky.net/dev/docs).

In addition, you can retrieve the URL for your particular API request by calling `source_url` on the `WeatherData` instance.

### Fetching Historical Weather

The gem also supports making [Dark Sky Time Machine Requests](https://darksky.net/dev/docs#time-machine-request). These work identically to a normal forecast request, with the exception that all of the data is related to the specified time in the past. You can make a time machine request by simply passing in a Unix timestamp along with the latitude and longitude in the `get_weather` call:

```ruby
client       = DarkskyWeather::Api::Client.new
lat, lng     = [37.8267, -122.4233]
weather_data = client.get_weather(lat: lat, lng: lng, timestamp: 30.days.ago.to_i)
```

You'll get back a `WeatherData` object, just as before, with all of the same methods and attributes to work with.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lojistic/DarkSky-gem. In particular, exposing more weather data through convenience methods and/or adding methods to analyze the data more effectively would be especially appreciated.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
