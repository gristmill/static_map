$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'test/unit'
require 'static_map'

class StaticMapTest < Test::Unit::TestCase

  def test_defaults
    img = StaticMap::Image.new
    assert_equal "http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true", img.url
    assert_equal %{<img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true' title='' alt=''/>}, img.to_html
  end

  def test_params
    img = StaticMap::Image.new
    assert_equal "size=500x500&zoom=1&sensor=true", img.params
    img.size = '900x900'
    assert_equal "size=900x900&zoom=1&sensor=true", img.params
  end

  def test_marker_params
    img = StaticMap::Image.new
    img.markers << { latitude: 44.477462, longitude: -73.212032, color: "red", label: "A" }
    img.markers << { location: "Winooski, Vermont", color: "red", label: "B" }
    assert_equal "markers=color:red|label:A|44.477462,-73.212032&markers=color:red|label:B|Winooski, Vermont", img.marker_params
  end

  def test_url
    img = StaticMap::Image.new
    img.center = nil
    img.size = '300x300'
    img.zoom = 11
    img.sensor = false
    img.markers << { latitude: 44.477462, longitude: -73.212032, color: "green", label: "A" }
    assert_equal "http://maps.google.com/maps/api/staticmap?size=300x300&zoom=11&sensor=false&markers=color:green|label:A|44.477462,-73.212032", img.url
  end

  def test_to_html
    img = StaticMap::Image.new(:size => "500x500", :alt => "Alt Test", :title => "Title Test")
    assert_equal "<img src='http://maps.google.com/maps/api/staticmap?size=500x500&zoom=1&sensor=true' title='Title Test' alt='Alt Test'/>", img.to_html
  end
end