require './base'

pid = fork do
  toho = Toho.new('2016-10-07', ['18:00', '22:00'])
  toho.set_schedules
end

pid2= fork do
  piccadilly = Piccadilly.new('2016-10-07', ['18:00', '22:00'])
  piccadilly.set_schedules
end

p "hoge"

Process.waitall
