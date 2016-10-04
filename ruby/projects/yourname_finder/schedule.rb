class Schedule
  attr_accessor :cinema, :date, :time, :seats
  def initialize(cinema, date, time, seats)
    @cinema = cinema
    @date   = date
    @time   = time
    @seats  = seats
  end

  # seatsを分ける。
  def split
  end
end

# Scheduleインスタンスの集合
class Schedule::Set
end

