w, fi_pid =
  if ARGV.first == "--auto"
    r,w = IO.pipe
    fi_pid = spawn "git", "fast-import", :in => r; r.close
    [w, fi_pid]
  else
    [$stdout, nil]
  end

self_end = "END---#{rand(999_999_999)}"
w.write <<FI
commit refs/heads/master
author Matt Burke <spraints@gmail.com> #{Time.now.to_i} -0400
committer Matt Burke <spraints@gmail.com> #{Time.now.to_i} -0400
data <<E
The generator for the initial couple of commits.
E
M 100644 inline fast-import.rb
data <<#{self_end}
#{File.read(__FILE__)}
#{self_end}

commit refs/heads/master
author Matt Burke <spraints@gmail.com> 1433217560 -0400
committer Matt Burke <spraints@gmail.com> 1433217560 -0400
data <<E
original images

from https://github.com/spraints/ccc-production/commit/2bda40f4652b334879a694e5d2e43c2f5512d167
E
M 100644 068baf8d7929ea96242aa04965ea9134c27bf7a9 sound-board.jpg
M 100644 1bdad6effab59942b758936de5c78cf353d4f79b rack.jpg
D fast-import.rb

commit refs/heads/master
author Matt Burke <spraints@gmail.com> 1433220531 -0400
committer Matt Burke <spraints@gmail.com> 1433220531 -0400
data <<E
mark up images

from https://github.com/spraints/ccc-production/commit/10ef902d441deaebb0e73d9c9a059e9910ade47b
E
M 100644 28e307a492952014d0e380b71d0547214dbe47ca sound-board.jpg
M 100644 ae2add80293b249c6b0171147497297c11bb0538 rack.jpg
FI

if fi_pid
  w.close
  Process.wait
end

