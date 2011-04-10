require "lib/imageruby"

include ImageRuby

describe Color, "color" do

  def self.test_color_rgba(r,g,b,a)
    it "should create color from rgba" do
      nc = Color.from_rgba(r, g, b, a)
      nc.r.should be == r
      nc.g.should be == g
      nc.b.should be == b
      nc.a.should be == a
    end
  end


  def self.test_color_equality(c)
    it "should be equal to a rgba copy" do
      nc = Color.from_rgba(c.r, c.g, c.b, c.a)
      nc.should be == c
    end
  end

  def self.test_color_dup(c)
    it "should be equal to a dup object clone" do
      nc = c.dup
      nc.should be == c
    end
  end

  10.times do

    r = rand(255)
    g = rand(255)
    b = rand(255)
    a = rand(255)

    test_color_rgba(r,g,b,a)

    c = Color.from_rgba(r,g,b,a)
    test_color_equality(c)
    test_color_dup(c)
  end

  def self.test_color_inequality(color1,color2)
    it "color #{color1} and #{color2} should be diferent" do
      (color1 == color2).should be == false
    end
  end

  def self.test_color_name(hash)
    hash.each do |color_name,color_array|
      it "color of name '#{color_name}' should be #{color_array.inspect}" do
      Color.send(color_name).should be == Color.coerce(color_array)
      end
    end
  end

  test_color_inequality( Color.from_rgb(255,255,255), "str")
  test_color_inequality( Color.from_rgb(255,255,255), 54)
  test_color_inequality( Color.from_rgb(255,255,255), nil)


  test_color_name "red" => [255,0,0], "green" => [0,255,0], "blue" => [0,0,255],
                  "white" => [255,255,255], "silver" => [0xc0, 0xc0, 0xc0], "gray" => [0x80,0x80,0x80],
                  "black" => [0,0,0], "maroon" => [0x80,0,0], "yellow" => [0xff,0xff,0],
                  "olive" => [0x80,0x80,0], "lime" => [0,0xff,0], "aqua" => [0, 0xff, 0xff],
                  "teal" => [0, 0x80, 0x80], "navy" => [0,0,0x80], "fuchsia" => [0xff,0x00,0xff],
                  "purple" => [0x80,0,0x80]

  # web format


  def self.test_web_format(str, value)
    it "color code '#{str}' should be color #{value.inspect}" do
    Color.coerce(str).should be == Color.coerce(value)
    end
  end

  test_web_format("\#000000", [0,0,0])
  test_web_format("\#000", [0,0,0])

  (17..255).each do |x|
    test_web_format("\##{x.to_s(16)}0000", [x,0,0])
  end
  (0..15).each do |x|
    test_web_format("\##{x.to_s(16)}00", [x + x*0x10,0,0])
  end

  32.times do
    r = rand(235)+17
    g = rand(235)+17
    b = rand(235)+17
    test_web_format("\##{r.to_s(16)}#{g.to_s(16)}#{b.to_s(16)}", [r,g,b])
  end
end