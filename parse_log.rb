#git log --pretty='%cn|%cd|%s|%b' > /Users/lyrasis/Desktop/CurrentASpaceDevelopment/releaseNotesTool/pretty_git_log.txt
require 'date'
require 'json'

file = File.new("pretty_git_log.txt", "r")
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
  puts a.to_json if a[:date] >= Date.parse("May 14 2019")
end
prs.each do | p |
  puts p.to_json if p[:date] >= Date.parse("May 14 2019")
end
