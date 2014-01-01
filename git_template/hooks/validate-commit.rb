#!/usr/bin/ruby
# Encoding: utf-8

editor = ENV['EDITOR'] != 'none' ? ENV['EDITOR'] : 'vim'
message_file = ARGV[0]

def check_format_rules(line_number, line)
  real_line_number = line_number + 1
  return "Error #{real_line_number}: First line should be less than 50 characters in length." if line_number == 0 && line.length > 50
  return "Error #{real_line_number}: Second line should be empty." if line_number == 1 && line.length > 0
  (return "Error #{real_line_number}: No line should be over 72 characters long." if line.length > 72) unless line[0,1]  == '#'
  false
end

while true
  commit_msg = []
  errors = []

  File.open(message_file, 'r').each_with_index do |line, line_number|
    commit_msg.push line
    e = check_format_rules line_number, line.strip
    errors.push e if e
  end

  unless errors.empty?
    File.open(message_file, 'w') do |file|
      file.puts "\n# GIT COMMIT MESSAGE FORMAT ERRORS:"
      errors.each { |error| file.puts "#    #{error}" }
      file.puts "\n"
      commit_msg.each { |line| file.puts line }
    end
    puts 'Invalid git commit message format.  Press y to edit and n to cancel the commit. [y/n]'
    choice = $stdin.gets.chomp
    exit 1 if %w(no n).include?(choice.downcase)
    next if `#{editor} #{message_file}`
  end
  break
end
