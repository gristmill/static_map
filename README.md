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

image = StaticMap::Image.new(options)

The options are

  * center String   - center the map around this location
  * zoom Integer    - zoom level of the map
  * size String     - in pixels of the image. 500x500
  * sensor Boolean  - autodetect user user location
  * markers Hash    - location of pin on map, requires location address or lat/long
  * maptype String  - satelite, road... etc
  * alt String      - alt text if using image tag
  * title String    - title text if using image tag

### Usage with Rails

```erb
<%=raw StaticMap::Image.new(size: '900x900', markers: [{location: "Burlington, Vermont", label: "A", color: "green"}], title: "Burlington, Vermont TITLE text", alt: "Burlington, Vermont ALT text") >
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
