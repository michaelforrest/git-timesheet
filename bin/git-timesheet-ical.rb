#!/usr/bin/env ruby
require 'rubygems'
require 'icalendar'
require 'date'
require 'active_support/core_ext'
include Icalendar

class GitLogToICal
  

  def initialize
    @calendar = Calendar.new
    date = ""
    description = ""
    (`git log --date=iso`).lines.each do |line|
      #puts line
      if line.match("Date:")
        description = ""
        date = line
      end
      if line.match("commit ")
        add_entry(date,description) 
      else
        description += line
      end
    end
    add_entry(date,description)
    write_file
  end
  def add_entry(date,description)
   description = description.gsub!(date,"").to_s.chomp if date
    match, year, month, day, hour, minute = *date.match(/(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/)
   
    puts("#{year}, #{month}, #{day} #{hour},#{minute}") if match
   
    end_time = DateTime.civil(year.to_i,month.to_i,day.to_i,hour.to_i,minute.to_i) if match
    @calendar.event do
      dtstart      end_time - 1.hour
      dtend        end_time
      summary     description
      description description
      klass       "PRIVATE"
    end if match

  end

  def write_file
    filename = "gitlog.ics"
    File.delete(filename) if File.exists?(filename)
    File.open(filename,'a') do |file|
      file <<  @calendar.to_ical
    end
  end

end


GitLogToICal.new



# commit fcdf9ee04647feeb20a3b5b43a889427fa801410
# Author: Michael Forrest <michaelforrest@mf.local>
# =>      0          1          2  
# Date:   2008-09-03 01:06:00 +0100

# 
#     started navigation stuff. too tired not to fuck up the history logic..
# 
# commit 6d540ec643e4b6ee14cbc0f5f96651f556d11ba0
# Author: Michael Forrest <michaelforrest@mf.local>
# Date:   Tue Sep 2 21:44:23 2008 +0100
# 
#     created the content for the overview page
# 
# commit 52015c94e29a5808f542ceda30278806dc8ee8e6