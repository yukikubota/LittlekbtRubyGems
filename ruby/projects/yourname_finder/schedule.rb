class Seats
  attr_accessor :seats
  # in ... {a: [1, 2, 3 ...], b: [1, 5, 7]...}
  def initialize(seats)
    self.seats = Seats.split(seats)
  end

  # seatsを分ける。
  def self.split(seats)
    spliter = [:front, :middle, :back]
    factor = seats.size / spliter.size 
    s = {}
    spliter.each do |split|
      s[split] = {}
    end

    seats.each.with_index(1) do |(char, row), i|
      if 1 <= i && i < factor
        s[:front][char] = row 
      elsif factor <= i && i < (factor * 2)
        s[:middle][char] = row 
      else
        s[:back][char] = row
      end
    end
    seats = s
  end
end

class Schedule
  attr_accessor :cinema, :date, :time, :seats
  def initialize(cinema, date, time, seats)
    @cinema = cinema
    @date   = date
    @time   = time
    @seats  = Seats.new(seats)
  end

  def to_json
  end
end
