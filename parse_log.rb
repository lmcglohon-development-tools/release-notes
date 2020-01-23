require 'date'
require 'json'

file = File.new("pretty_git_log_20200116.txt", "r")
data = []
prs = []
while (line = file.gets)
  d = line.chomp.split('|')
  if d.length == 4
    if !d[2].start_with?("Merge pull request") && (d[2].start_with?("ANW-") || d[2].start_with?("AR-"))
      data << {:username=>d[0], :date=>Date.parse(d[1]), :subject=>d[2], :body=>d[3]}
    elsif d[2].start_with?("Merge pull request")
      prs << {:username=>d[0], :date=>Date.parse(d[1]), :subject=>d[2], :body=>d[3]}
    end
  end
end

data.each do | a |
  puts a.to_json
end
prs.each do | p |
  puts p.to_json
end
