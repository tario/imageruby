require "lib/imageruby"

include ImageRuby

describe Image, "Image" do

  def self.test_create(width, height)
    it "should create images of #{width}x#{height}" do
      image = Image.new(width,height)

      image.width.should be == width
      image.height.should be == height
    end
  end

  def self.test_create_and_black(width, height)
    it "should create images of #{width}x#{height} and should be black for all pixels" do
      image = Image.new(width,height)
      image.pixel_data.should be == "\000"*width*height*3
    end
  end

  def self.test_one_pixel(c)
    it "should create a image of one pixel of color #{c.r}, #{c.g}, #{c.b}" do
      image = Image.new(1,1) { |x,y| c }
      image.get_pixel(0,0).should be == c
    end
  end

  test_create(10,10)
  test_create(0,0)
  test_create(640,480)
  test_create(1,100)
  test_create(20,67)

  test_create_and_black(10,10)
  test_create_and_black(0,0)
  test_create_and_black(640,480)
  test_create_and_black(1,100)
  test_create_and_black(20,67)

  test_one_pixel(Color.from_rgba(0,0,0,255))
  test_one_pixel(Color.from_rgba(255,255,255,255))
  test_one_pixel(Color.from_rgba(255,255,255,128))

  10.times do
  test_one_pixel(Color.from_rgba(rand(255),rand(255),rand(255),rand(255)))
  end

end