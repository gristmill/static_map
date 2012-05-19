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
    # sensor Boolean  - autodetect user location
    # markers Array of Hashes - location of pins on map. Requires a location address or lat/long coordinates
    # maptype String  - type of map (satellite, road, hybrid, terrain)
    # path String     - path to write file to when #save is called
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

      File.open(@path, "w") { |f| f.write( open(url).read ) }
    end

    def url
      "#{URL}?#{params}".strip
    end

    def params
      x = { size: size, center: center, zoom: zoom, sensor: sensor, maptype: maptype }.reject { |k,v| v.nil? }.map do |k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      end.join("&")

      x += "&#{marker_params}" if @markers.any?
      x
    end

    def marker_params
      @markers.map do |marker|
        str = ["markers="]
        str << [CGI.escape("color:#{marker[:color]}")] if marker[:color]
        str << [CGI.escape("label:#{marker[:label]}")] if marker[:label]
        str << [CGI.escape("#{marker[:location]}")] if marker[:location]
        str << ["#{marker[:latitude]},#{marker[:longitude]}"] if marker[:latitude] && marker[:longitude]
        str.map{|v| v }.join("%7C") # %7C
      end.join("&").gsub(/\=\%7C/i, '=')
    end

    def to_html
      "<img src='#{url}' title='#{title}' alt='#{alt}'/>"
    end
    alias_method :to_s, :to_html

  end
end
