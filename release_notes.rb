require 'date'
require 'json'
require 'net/http'


class ReleaseNotes

  attr_reader :git_log_location, :first_line, :start_date, :description, :config, :schema_desc

  def initialize(log_loc, rel_no, start_date)
    @git_log_location = log_loc
    @first_line = "# Release notes for #{rel_no}"
    @start_date = start_date
    @description = 'This minor release contains program-led and community pull requests that provide feature enhancements, bug fixes, and infrastructure improvements. Some items of note include...'
    @config = 'This release includes modifications to the defaults files:'
    @schema_desc = 'This release includes XXX new database migrations. The schema number for this release is YYY.'
  end

  def parse_log(log_file)
    file = File.new(log_file, "r")
    data_array = []
    while (line = file.gets)
      d = line.chomp.split('|')
      if d.length == 4
        if !d[2].start_with?("Merge pull request") && (d[2].start_with?("ANW-") || d[2].start_with?("AR-"))
          data_array << {:username=>d[0], :date=>Date.parse(d[1]), :subject=>d[2], :body=>d[3]}
        elsif d[2].start_with?("Merge pull request")
          data_array << {:username=>d[0], :date=>Date.parse(d[1]), :subject=>d[2], :body=>d[3]}
        end
      end
    end
    data_array
  end

  def write_markdown(rel_no, comm_contrib)
    file = File.open("ReleaseNotes#{rel_no}.md", "w")
    file.puts first_line
    file.puts "\n"
    file.puts description
    file.puts "\n"
    file.puts config
    file.puts "\n"
    file.puts schema_desc
    file.puts "\n"
    file.puts "## Community Contributions\n\n"
    file.puts "----\n\n"
    file.puts "## JIRA Tickets and Pull Requests Completed\n\n"
    comm_contrib.sort.each do | c |
      c.gsub!("\#", '')
      url = "https://api.github.com/repos/archivesspace/archivesspace/pulls/#{c}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      puls = JSON.parse(response)
      puts puls["title"]
      file.puts "  * Pull Request #{c} #{puls["title"]}\n"
    end
    file.close
  end
end

rn = ReleaseNotes.new('/Users/lyrasis/Desktop/ASpaceVersions/check-new-master/archivesspace', 'v2.8.0', '2019-10-06')

dt = Date.today
loc_for_log = "/Users/lyrasis/Desktop/StatisticsAndTechLeadTools/tools/release-notes/pretty_git_log_"

pretty_print_log = "#{loc_for_log}#{dt}.txt"
`rm -f "#{pretty_print_log}"`

`git -C "#{rn.git_log_location}" log --pretty='%cn|%cd|%s|%b' --since="#{rn.start_date}" > "#{pretty_print_log}"`

prs = rn.parse_log(pretty_print_log)

comm_contrib = []
prs.each do | n |
  comm_contrib << n[:subject].split[3] if n[:subject].split[3].length > 2
end

rn.write_markdown('2.8.0', comm_contrib)

comm_contrib.each do | c |
  c.gsub!("\#", '')
  url = "https://api.github.com/repos/archivesspace/archivesspace/pulls/#{c}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  puls = JSON.parse(response)
  puts puls["title"]
end
