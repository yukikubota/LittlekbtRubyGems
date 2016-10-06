pid = fork do
  exec('sleep 6')
end

pid2 = fork do
  exec('sleep 6')
end


exitpid, status = *Process.waitpid2(pid)
