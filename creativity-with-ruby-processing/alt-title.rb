# Title

class Title < Processing::App

  def setup
   size(1200, 1200)
   hint(ENABLE_NATIVE_FONTS)
   font = createFont('Avenir.ttc', 64)
   textAlign(CENTER, CENTER)
   textFont(font)

   @circle_count = 120
   @circles = []

    @circle_count.times do |c|
      circle = {}
      circle[:width] = random(15, width)
      circle[:height] = random(300, height)
      circle[:radius] = random(50, 100)
      circle[:x_speed] = random(-0.14, 0.14)
      circle[:y_speed] = random(-0.14, 0.14)
      @circles << circle
    end

   smooth
  end

  def draw
    background(0)

    fill(200, 120, 160, 100)
    no_stroke
    @circles.each do |c|
      ellipse(c[:width], c[:height], c[:radius], c[:radius])

      c[:x_speed] *= -1 if c[:width] > width - 30 || c[:width] < 10
      c[:y_speed] *= -1 if c[:height] > height - 30 || c[:height] < 250

      c[:width] += c[:x_speed]
      c[:height] += c[:y_speed]

      @circles.each do |c2|
        stroke(200, 120, 160)
        stroke_width(1)
        if sq(c[:width] - c2[:width]) + sq(c[:height] - c2[:height]) < sq(c[:radius])
          line(c[:width], c[:height], c2[:width], c2[:height])
        end
      end

      no_stroke
      rect(c[:width]-2, c[:height]-2, 4, 4)
    end

    fill(0)
    rect(0, height/4, width, 105)

    fill(255)
    text "Creativity With Ruby Processing", width/2, height/4 - 100
    scale(0.5)
    text "Joanne Cheng", width, height
    text "@joannecheng", width, height + 100
    scale(2.0)
  end

end

Title.new :title => "Title"
