
#######################################################
#                                                     #
#                     Find me on:                     #
# Github: https://www.github.com/Epsian               #
# BitBucket: https://www.bitbucket.org/Epsian/        #
# Twitter: https://www.twitter.com/Epsian             #
#                                                     #
#######################################################

#### Setup ####
# Required Packages
library(stringr)
library(lubridate)
library(plyr)

ics_convert = function(ics_file, tzone = "America/Los_Angeles"){

#### In/Out ####
# Where is the ical file you want to convert?
.ics_dir = ics_file

#### Convert ####
# Read in ical
cal = readLines(.ics_dir)

# Trim out metadata
meta = cal[1:match("BEGIN:VEVENT", cal)-1]
cal = cal[match("BEGIN:VEVENT", cal):length(cal)]

# Convert each event to list element
chunks = data.frame(starts = str_which(cal, "BEGIN:VEVENT"), ends = str_which(cal, "END:VEVENT"))
entries = apply(chunks, 1, FUN = function(x) (x[1]+1):(x[2]-1))

entries = lapply(entries, FUN = function(x){
  event = cal[x]

  # What do the valid entries start with?
  .starters = c("DTSTART:", "DTEND:", "DTSTAMP:", "UID:", "CREATED:", "DESCRIPTION:", "LAST-MODIFIED:", "LOCATION:", "SEQUENCE:", "STATUS:", "SUMMARY:", "TRANSP:", "RRULE:", "EXDATE;")
  
  # Find those that are fragments, past with prior entry
  info_fragment = !str_detect(event, paste(.starters, collapse = "|"))
  event[info_fragment] = trimws(event)[info_fragment]
  
  while(any(info_fragment)){
    event[which(info_fragment)[1]-1] = paste(event[which(info_fragment == TRUE)-1][1], event[info_fragment][1], sep = "")
    event = event[-which(info_fragment)[1]]
    info_fragment = !str_detect(event, paste(.starters, collapse = "|"))
  }
  
  # Turn each event into data frame
  event = data.frame(t(str_split(event, ":", n = 2, simplify = TRUE)), stringsAsFactors = FALSE)
  colnames(event) = event[1,]
  event = event[-1,]
})

rm(cal, meta, chunks)

# Convert list to DF
entries = plyr::rbind.fill(entries)

# Convert dates to lubridate
entries$DTSTART = as_datetime(entries$DTSTART, tz = tzone)
entries$DTEND = as_datetime(entries$DTEND, tz = tzone)
entries$DTSTAMP = as_datetime(entries$DTSTAMP, tz = tzone)
entries$CREATED = as_datetime(entries$CREATED, tz = tzone)
entries$`LAST-MODIFIED` = as_datetime(entries$`LAST-MODIFIED`, tz = tzone)

#### Save CSV ####
return(entries)

}

