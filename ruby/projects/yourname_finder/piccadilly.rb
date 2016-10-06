require 'capybara/poltergeist'
require 'nokogiri'
require 'time'
require 'pry'
require './your_name_finder'
require './schedule'

class Piccadilly < YourNameFinder::Base
  def set_schedules
    select_date

    schedule = Nokogiri::HTML.parse(@session.html).css('#Day_schedule>.scheduleBox').select do |schedule|
      schedule.children[1].children[1].children[1].children[0].children.text == '君の名は。'
    end[0]

    links = schedule.css('>table>tbody>tr>td').select do |s|
              s.children.children.children.children.children[0] &&
              s.children.children.children.children.children[0].attributes["alt"].value != '販売終了'
            end.map do |white_schedule|
              start = Time.parse("#{@date} #{white_schedule.css('>table>tbody>tr>td>.strong.fontXL').children.text}")
              if Time.parse("#{@date} #{@time[0]}") < start && start < Time.parse("#{@date} #{@time[1]}")
                [start,  white_schedule.attributes['onclick'].value.match(/window.open\(\'(.*?)\'/)[1]]
              end
            end.select{|s| s}

    @schedules = links.map do |start, link|
                   @session.visit link
                   seats = Nokogiri::HTML.parse(@session.html).css('#choice>tbody>tr>td>a').map do |seat|
                     seat.attributes.has_key?('href') &&
                     seat.children[0].attributes.key?('class') &&
                     seat.attributes['title'].value
                   end.select{|s| s}
                   Schedule.new(:picadilly, @date, start, format_seats(seats))
                 end
  end

  private

  def select_date
    @session.visit "http://www.smt-cinema.com/site/shinjuku/"
    @session.execute_script "$('#s0100_1051_#{@date}').click()"
  end

  def format_seats(seats)
    hash = {}
    seats.each do |seat| 
      seat_char = seat[0]
      hash[seat_char] = [] unless hash.key?(seat_char)
      hash[seat_char] = hash[seat_char] << seat.split('-')[1]
    end
    hash
  end
end

Piccadilly.new('20161006', ['18:00', '22:00']).set_schedules
