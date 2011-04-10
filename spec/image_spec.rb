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

  def self.test_multiple_pixel
    it "should create a image with specific pixels" do

      data = Array.new

      image = Image.new(10,10) do |x,y|
        data[x*10+y] = Color.from_rgb(rand(255),rand(255),rand(255))
        data[x*10+y]
      end

      (0..9).each do |x|
         (0..9).each do |y|
           image.get_pixel(x,y).should be == data[x*10+y]
         end
      end
    end
  end

  def self.test_multiple_pixel_each
    it "should create a image with specific pixels" do

      data = Array.new

      image = Image.new(10,10) do |x,y|
        data[x*10+y] = Color.from_rgb(rand(255),rand(255),rand(255))
        data[x*10+y]
      end

      image.each_pixel do |x,y,c|
           c.should be == data[x*10+y]
      end
    end
  end

  def self.rand_image(width, height)
    Image.new(width, height) do
      Color.from_rgb(rand(255),rand(255),rand(255))
    end
  end

  def self.test_portion(width, height, x, y, part_width, part_height)
    source_image = rand_image(width,height)
    it "should extract a portion [#{x..x+part_width-1},#{y..y+part_height-1}] with the [] operator" do
      subimage = source_image[x..x+part_width-1, y..y+part_height-1]

      subimage.each_pixel do |x_,y_,c|
        source_image.get_pixel(x+x_, y+y_).should be == c
      end
    end
  end

  def self.test_portion_insertion(width, height, x, y, part_width, part_height)
    source_image = rand_image(width,height)
    identical = source_image.dup
    insert_image = rand_image(part_width, part_height)
    it "should insert a portion of size #{part_width}*#{part_height} with the []= operator" do
      source_image[x..x+part_width-1, y..y+part_height-1] = insert_image

      source_image.each_pixel do |x_,y_,c|
        if (x..x+part_width-1) === x_ and (y..y+part_height-1) === y_ then
          c.should be == insert_image.get_pixel(x_-x, y_-y)
        else
          c.should be == identical.get_pixel(x_, y_)
        end
      end
    end
  end

  def self.test_dup(width,height)
    source_image = rand_image(width,height)

    it "should dup image of size #{width}*#{height} and the dupped should be identical pixel to pixel" do

      dupped_image = source_image.dup

      source_image.each_pixel do |x_,y_,c|
        c.should be == dupped_image.get_pixel(x_, y_)
      end
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
  test_multiple_pixel
  test_multiple_pixel_each
  end

  test_portion 1,1,0,0,1,1
  test_portion 10,10,4,6,1,1
  test_portion 10,10,0,0,4,5
  test_portion 10,10,4,6,3,3

  test_portion_insertion 1,1,0,0,1,1
  test_portion_insertion 10,10,4,6,1,1
  test_portion_insertion 10,10,0,0,4,5
  test_portion_insertion 10,10,4,6,3,3

  10.times do |x|
    test_dup(x+1,x+1)
  end
end