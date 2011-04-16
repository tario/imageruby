require "lib/imageruby"

include ImageRuby

describe Color, "Color" do

  def self.validate_out_of_range(*values)
    values.each do |value|
      it "should validate out of range color channels with red=#{value} when create with Color.from_rgb" do
        lambda {
          Color.from_rgb(value,0,0)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channels with red=#{value} when create with Color.from_rgba" do
        lambda {
          Color.from_rgba(value,0,0,0)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channel with value #{value} when assign red channel" do
        color = Color.from_rgb(0,0,0)
        lambda {
          color.r = value
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channels with green=#{value} when create with Color.from_rgb" do
        lambda {
          Color.from_rgb(0,value,0)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channels with green=#{value} when create with Color.from_rgba" do
        lambda {
          Color.from_rgba(0,value,0,0)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channel with value #{value} when assign green channel" do
        color = Color.from_rgb(0,0,0)
        lambda {
          color.g = value
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channels with blue=#{value} when create with Color.from_rgb" do
        lambda {
          Color.from_rgb(0,0,value)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channels with blue=#{value} when create with Color.from_rgba" do
        lambda {
          Color.from_rgba(0,0,value,0)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channel with value #{value} when assign blue channel" do
        color = Color.from_rgb(0,0,0)
        lambda {
          color.b = value
        }.should raise_error(Color::OutOfRangeException)
      end


      it "should validate out of range color channel alpha with value #{value} when create with Color.from_rgba" do
        lambda {
          Color.from_rgba(0,0,0,value)
        }.should raise_error(Color::OutOfRangeException)
      end

      it "should validate out of range color channel with value #{value} when assign alpha channel" do
        color = Color.from_rgb(0,0,0)
        lambda {
          color.a = value
        }.should raise_error(Color::OutOfRangeException)
      end
    end
  end


  validate_out_of_range(-1)
  validate_out_of_range(256)

  validate_out_of_range 500,1000,2000000000
  validate_out_of_range -500,-1000,-2000000000
end