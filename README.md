# StaticMap

_still in development_

Build static images using Google's Static Map API

## Installation

    gem 'static_map'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install static_map

## Usage

```ruby
image = StaticMap::Image.new(options)
image.url
# => http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true
image.to_html
# => <img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true' title='' alt=''/>

img.path = "./my-map.png"
img.save # save map to disk

```

The options are

* center String   - center the map around this location
* zoom Integer    - zoom level of the map
* size String     - in pixels of the image. 500x500
* sensor Boolean  - autodetect user user location
* markers Array of Hashes    - location of pin on map, requires location address or lat/long
* maptype String  - satelite, road... etc
* alt String      - alt text if using image tag
* title String    - title text if using image tag

### Usage with Rails

```erb
<%=raw StaticMap::Image.new %>
```

markers option accepts either a location (E.g., "Burlington, Vermont") or latitude and longitude coordinates.

```ruby
StaticMap::Image.new(zoom: 15, markers: [{latitude: 44.477462, longitude: -73.212032, color: "green", label: "A" }, { latitude: 44.477171, longitude: -73.222032, color: "blue", label: "B" }])
```

![StaticMap::Image of Burlington Vermont](http://maps.google.com/maps/api/staticmap?size=900x900&zoom=1&sensor=true&markers=color:green|label:A|Burlington,%20Vermont)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
