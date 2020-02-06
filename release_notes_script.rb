require_relative 'release_notes'

rn = ReleaseNotes.new('/Users/lyrasis/Desktop/ASpaceVersions/check-new-master/archivesspace', 'v2.7.1', '2019-10-06')

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

rn.write_markdown('2.7.1', comm_contrib)
