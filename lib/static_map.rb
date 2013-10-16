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
    URL = "//maps.google.com/maps/api/staticmap"
    PIPE = "%7C"

    # center String   - center the map around this location
    # zoom Integer    - zoom level of the map
    # size String     - in pixels of the image. 500x500
    # sensor Boolean  - autodetect user location
    # markers Array of Hashes - location of pins on map. Requires a location address or lat/long coordinates
    # maptype String  - type of map (satellite, road, hybrid, terrain)
    # path String     - path to write file to when #save is called
    # alt String      - alt text if using image tag
    # title String    - title text if using image tag
    # key String      - Google maps api key
    # styles Array of Hashses - style customization
    attr_accessor :center, :zoom, :size, :sensor, :markers, :maptype, :path, :alt, :title, :key, :styles

    def initialize(options={})
      @markers  = options.has_key?(:markers)  ? options[:markers]   : []
      @size     = options.has_key?(:size)     ? options[:size]      : '500x500'
      @sensor   = options.has_key?(:sensor)   ? options[:sensor]    : true
      @zoom     = options.has_key?(:zoom)     ? options[:zoom]      : 1
      @center   = options.has_key?(:center)   ? options[:center]    : nil
      @maptype  = options.has_key?(:maptype)  ? options[:maptype]   : 'road'
      @path     = options.has_key?(:path)     ? options[:path]      : nil
      @alt      = options.has_key?(:alt)      ? options[:alt]       : nil
      @title    = options.has_key?(:title)    ? options[:title]     : nil
      @key      = options.has_key?(:key)      ? options[:key]       : nil
      @styles   = options.has_key?(:styles)   ? options[:styles]    : []
    end

    def save
      raise "Please set the path argument to save the image" unless @path

      File.open(@path, "w") { |f| f.write(file.read) }
    end

    def file
      open("http:#{url}")
    end

    def url
      "#{URL}?#{params}".strip
    end

    def params
      x = { size: size, center: center, zoom: zoom, sensor: sensor, maptype: maptype, key: key }
      x = x.reject { |k,v| v.nil? }.map do |k,v|
        "#{k}=#{CGI.escape(v.to_s)}"
      end.join("&")

      x += "&#{style_params}" if @styles.any?
      x += "&#{marker_params}" if @markers.any?
      x
    end

    def style_params
      @styles.map do |style|
        str = ["style="]
        str << style.map { |k,v| [CGI.escape("#{k}:#{v}")] }
        str.join(PIPE)
      end.join("&").gsub(/\=#{PIPE}/i, '=')
    end

    def marker_params
      @markers.map do |marker|
        str = ["markers="]
        str << [CGI.escape("shadow:#{marker[:shadow]}")]            if marker.has_key?(:shadow)
        str << [CGI.escape("icon:#{marker[:icon]}")]                if marker.has_key?(:icon)
        str << [CGI.escape("color:#{marker[:color]}")]              if marker.has_key?(:color)
        str << [CGI.escape("label:#{marker[:label]}")]              if marker.has_key?(:label)
        str << [CGI.escape("#{marker[:location]}")]                 if marker.has_key?(:location)
        str << ["#{marker[:latitude]},#{marker[:longitude]}"]       if marker.has_key?(:latitude) && marker.has_key?(:longitude)
        str << marker[:points].map { |p| ["#{p.first},#{p.last}"] } if marker.has_key?(:points)
        str.join(PIPE)
      end.join("&").gsub(/\=#{PIPE}/i, '=')
    end

    def to_html
      "<img src='#{url}' title='#{title}' alt='#{alt}'/>"
    end
    alias_method :to_s, :to_html

  end
end
