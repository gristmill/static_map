# StaticMap

Build static images using Google's Static Map API

## Installation

    gem 'static_map'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install static_map

## Usage

```ruby
image = StaticMap::Image.new({
  size: '500x500',
  sensor: false,
  markers: [],
  maptype: 'road',
  zoom: 8,
  title: 'A map',
  alt: 'Alt text for img html',
  path: './my-map.png'
})

image.url
# => http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true

image.to_html
# => <img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true' title='' alt=''/>

img.save # save map to disk with path option

```

The options are

* center String   - center the map around this location
* zoom Integer    - zoom level of the map
* size String     - in pixels of the image. 500x500
* sensor Boolean  - autodetect user location
* markers Array of Hashes - location of pins on map. Requires a location address or lat/long coordinates
* maptype String  - satelite, road... etc
* path String     - path to write file to when #save is called
* alt String      - alt text if using image tag
* title String    - title text if using image tag

### Usage with Rails

```erb
<%=raw StaticMap::Image.new %>
```

markers option accepts either a location (E.g., "Burlington, Vermont") or latitude and longitude coordinates.

```ruby
<%=raw StaticMap::Image.new({
  zoom: 13,
  markers: [
    { location: "Winooski,Vermont", color: "green", label: "A" },
    { latitude: 44.477171, longitude: -73.222032, color: "blue", label: "B" }
    ]
  }) %>
```

![StaticMap::Image of Burlington Vermont](http://maps.google.com/maps/api/staticmap?size=500x500&zoom=13&sensor=true&markers=color:green|label:A|Winooski,VT&markers=color:blue|label:B|44.477171,-73.222032)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
