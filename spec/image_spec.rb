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
    image = Image.new(1,1) { |x,y| c }
    image.get_pixel(x,y).should be == c
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

end