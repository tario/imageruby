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
      (color1 == color2).should be false
    end
  end

  test_color_inequality( Color.from_rgb(255,255,255), "str")
  test_color_inequality( Color.from_rgb(255,255,255), 54)
  test_color_inequality( Color.from_rgb(255,255,255), nil)

end