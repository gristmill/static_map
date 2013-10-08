$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'test/unit'
require 'static_map'
require 'tempfile'

class StaticMapTest < Test::Unit::TestCase

  def test_defaults
    img = StaticMap::Image.new
    assert_equal "http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true&maptype=road", img.url
    assert_equal %{<img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true&maptype=road' title='' alt=''/>}, img.to_html
  end

  def test_sets_sensor
    img = StaticMap::Image.new(sensor: false)
    assert_equal false, img.sensor
  end

  def test_sets_key
    img = StaticMap::Image.new(key: 'api-key')
    assert_equal 'api-key', img.key
    assert img.url.include?('key=api-key')
  end

  def test_style_params
    img = StaticMap::Image.new
    img.styles << { element: 'geometry', hue: '0xff0000', saturation: '-100' }
    img.styles << { feature: 'road', element: 'labels', visibility: 'off', lightness: '60' }
    assert_equal "style=element%3Ageometry%7Chue%3A0xff0000%7Csaturation%3A-100&style=feature%3Aroad%7Celement%3Alabels%7Cvisibility%3Aoff%7Clightness%3A60", img.style_params
  end

  def test_params
    img = StaticMap::Image.new
    assert_equal "size=500x500&zoom=1&sensor=true&maptype=road", img.params
    img.size = '900x900'
    assert_equal "size=900x900&zoom=1&sensor=true&maptype=road", img.params
  end

  def test_marker_params
    img = StaticMap::Image.new
    img.markers << { latitude: 44.477462, longitude: -73.212032, color: "red", label: "A" }
    img.markers << { location: "Winooski, Vermont", color: "red", label: "B" }
    assert_equal "markers=color%3Ared%7Clabel%3AA%7C44.477462,-73.212032&markers=color%3Ared%7Clabel%3AB%7CWinooski%2C+Vermont", img.marker_params
  end

  def test_shadow_marker_params
    img = StaticMap::Image.new
    img.markers << { shadow: false }
    assert_equal "markers=shadow%3Afalse", img.marker_params
  end

  def test_icon_marker_params
    img = StaticMap::Image.new
    img.markers << { icon: 'http://url.com' }
    assert_equal "markers=icon%3Ahttp%3A%2F%2Furl.com", img.marker_params
  end

  def test_multi_markers
    img = StaticMap::Image.new
    img.markers << { points: [[1, 2], [3, 4]] }
    assert_equal "markers=1,2%7C3,4", img.marker_params
  end

  def test_url
    img = StaticMap::Image.new
    img.center = nil
    img.size = '300x300'
    img.zoom = 11
    img.sensor = false
    img.markers << { latitude: 44.477462, longitude: -73.212032, color: "green", label: "A" }
    assert_equal "http://maps.google.com/maps/api/staticmap?size=300x300&zoom=11&sensor=false&maptype=road&markers=color%3Agreen%7Clabel%3AA%7C44.477462,-73.212032", img.url
  end

  def test_to_html
    img = StaticMap::Image.new(:size => "500x500", :alt => "Alt Test", :title => "Title Test")
    assert_equal "<img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true&maptype=road' title='Title Test' alt='Alt Test'/>", img.to_html
  end

  def test_save
    # TODO fake the remote resource
    img = StaticMap::Image.new(path: "./test/tmp.png")
    img.markers << { latitude: 44.477462, longitude: -73.212032, color: "red", label: "B" }
    img.markers << { location: "Santa Barbara,California", color: "blue", label: "A" }
    img.save
    assert File.exists?("./test/tmp.png")
    File.delete("./test/tmp.png")
  end

  def test_file
    img = StaticMap::Image.new
    assert_kind_of Tempfile, img.file
  end
end
