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

    binding.pry
    @schedules = schedule
                   .css(".scheduleBox>table>tbody>tr").select do |white_schedules|
                     start = Time.parse("#{@date} #{white_schedule.css('span.strong.fontXL').children.text}")
                     # @dateの間の期間にあるものを取り出す
                     if Time.parse("#{@date} #{@time[0]}") < start && start < Time.parse("#{@date} #{@time[1]}")
                      # 席情報ページにアクセス
                     end
                   end 
    # 空席を取り出す
  end

  private

  def select_date
    @session.visit "http://www.smt-cinema.com/site/shinjuku/"
    @session.execute_script "$('#s0100_1051_#{@date}').click()"
  end
end

Piccadilly.new('20161004', ['18:00', '22:00']).set_schedules
