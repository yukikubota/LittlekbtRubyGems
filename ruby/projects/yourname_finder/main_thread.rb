require './base'

objs = [Toho.new('2016-10-07', ['18:00', '22:00']), Piccadilly.new('2016-10-07', ['18:00', '22:00'])]

begin
  ts = objs.map do |obj|
    Thread.start(obj) { |obj| p Thread.current; obj.set_schedules }
    #obj.set_schedules
  end

  # 全てのThreadの終わりを待つ。
  ThreadsWait.all_waits(*ts) do |th| 
    printf("end %s\n", th.inspect)
  end 

rescue  => e
  p e  # => "unhandled exception"
end
