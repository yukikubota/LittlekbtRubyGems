class Toho < YourNameFinder::Base
  def set_schedules
    select_date

    schedule = Nokogiri::HTML.parse(@session.html).css('.schedule-body-section-item').select do |schedule|
      schedule.children[1].children[1].children[0].text == '君の名は。'
    end[0]

    @schedules = schedule
                   .css('.schedule-item.white')
                   .map do |white_schedule|
                     start = Chronic.parse("#{@date} #{white_schedule.css('a > .time > .start')[0].children.text}")
                     if Chronic.parse("#{@date} #{@time[0]}") < start && start < Chronic.parse("#{@date} #{@time[1]}")
                       @session.execute_script white_schedule.children[0].attributes['href'].value
                       sleep 3

                       # 空き席一覧
                       seats = Nokogiri::HTML(@session.html)
                                 .xpath("//table//tbody//tr")
                                 .map do |tr|
                                   tr.children.select do |td|
                                       td.children.count >= 1 &&
                                       td.children[0].respond_to?(:attributes) &&
                                       td.children[0].attributes.key?('alt') &&
                                       td.children[0].attributes['alt'].value.include?('空席')
                                   end
                                 end.map do |tr|
                                   tr.map {|td| td.children[0].attributes['alt'].value}
                                 end.select do |tr|
                                   tr.size >= 1
                                 end
                       		 Schedule.new(:toho, @date, start, format_seats(seats))
                     end
                   end.select{|s| s}
  end

  private

  def select_date
    @session.visit "https://hlo.tohotheater.jp/net/schedule/076/TNPI2000J01.do"
    @session.execute_script "$('##{@date.delete('-')}').trigger('click')"
    sleep 5
  end

  def format_seats(seats)
    hash = {}
    seats.each do |row|
      row.each do |seat|
        seat = seat.split()[0].split('-')
        seat_char = seat[0]
        hash[seat_char] = [] unless hash.key?(seat_char)
        hash[seat_char] = hash[seat_char] << seat[1]
      end
    end
    hash
  end
end
