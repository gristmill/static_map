# http://www.lateralcode.com/new-google-maps-api/
require "static_map/version"
require 'cgi'
require 'open-uri'

module StaticMap
  #
  # Example
  #
  # img = StaticMap::Image.new(size: 500)
  # img.center = 'Burlington, VT'
  # img.zoom = 4
  # img.markers << {latitude: 123, longitude: 321, color: 'red', label: 'VT'}
  #
  class Image
    # Base URL for Google Static Maps API endpoint
    URL = "http://maps.google.com/maps/api/staticmap"

    # center String   - center the map around this location
    # zoom Integer    - zoom level of the map
    # size String     - in pixels of the image. 500x500
    # sensor Boolean  - autodetect user user location
    # markers Hash    - location of pin on map, requires location address or lat/long
    # maptype String  - satelite, road... etc
    # path String     - where to save the file
    # alt String      - alt text if using image tag
    # title String    - title text if using image tag
    attr_accessor :center, :zoom, :size, :sensor, :markers, :maptype, :path, :alt, :title

    def initialize(options={})
      @markers  = options[:markers] || []
      @size     = options[:size]    || '500x500'
      @sensor   = options[:sensor]  || true
      @zoom     = options[:zoom]    || 1
      @center   = options[:center]  || nil
      @maptype  = options[:maptype] || 'road'
      @path     = options[:path]    || nil
      @alt      = options[:alt]     || nil
      @title    = options[:title]   || nil
    end

    def save
      raise "Please set the path argument to save the image" unless @path

      File.open(@path, "w") { |f| f.write(open(url).read) }
    end

    def url
      "#{URL}?#{params}"
    end

    def params
      x = { size: size, center: center, zoom: zoom, sensor: sensor }.reject { |k,v| v.nil? }.map do |k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      end.join("&")

      x += "&#{marker_params}" if @markers.any?
      x
    end

    def marker_params
      @markers.map do |marker|
        str = ["markers="]
        str << ["color:#{marker[:color]}"] if marker[:color]
        str << ["label:#{marker[:label]}"] if marker[:label]
        str << ["#{marker[:location]}"] if marker[:location]
        str << ["#{marker[:latitude]},#{marker[:longitude]}"] if marker[:latitude] && marker[:longitude]
        str.join("|")
      end.join("&").gsub(/\=\|/i, '=')
    end

    def to_html
      "<img src='#{url}' title='#{title}' alt='#{alt}'/>"
    end
    alias_method :to_s, :to_html

  end
end
