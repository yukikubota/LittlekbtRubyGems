class YourNameFinder
  class Base
    attr_accessor :date, :time, :session, :schedules
    def initialize(date, time)
      @date = date
      @time = time

      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
      end
      Capybara.javascript_driver = :poltergeist
      @session = Capybara::Session.new(:poltergeist)

      @session.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
      }
    end

    def set_schedules
    end

    private
    def select_date
    end

    def format_seats
    end
  end
end

