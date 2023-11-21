# GETTING STARTED - IMPORT MODULES AND READ IN FILE
import os
import pandas as pd
import numpy as np
import regex
os.getcwd()
os.chdir(r'C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-1-return-to-work\\data')
Twitter_batch1 = pd.read_table("Twitter_batch_1.csv", sep=",")
Twitter_batch2 = pd.read_table("Twitter_batch_2.csv", sep=",")
Twitter_batches = pd.concat([Twitter_batch1, Twitter_batch2], axis = 0)
Twitter_batches.columns
len(Twitter_batches)

#### CREATE VARIABLES FOR THE SEARCH TERMS AND EVALUATE LENGTH OF RESULTS
# 'BACK INTO THE OFFICE' OR 'BACK INTO THE OFFICE'
backintotheoffice_pattern = "([Bb]ack[ -][Ii]nto[ -][Tt]he[ -][Oo]ffice)|([Bb]ack[ -][Tt]o[ -][Tt]he[ -][Oo]ffice)"
backintotheoffice = Twitter_batches[Twitter_batches["text"].str.contains(backintotheoffice_pattern)]
len(backintotheoffice)

# COMING INTO WORK
comingintowork_pattern = "[Cc]oming[ -][Ii]nto[ -][Ww]ork"
comingintowork = Twitter_batches[Twitter_batches["text"].str.contains(comingintowork_pattern)]
len(comingintowork)

# DAYS IN THE OFFICE
daysintheoffice_pattern = "[Dd]ays[ -][Ii]n[ -][Tt]he[ -][Oo]ffice)"
daysintheoffice = Twitter_batches[Twitter_batches["text"].str.contains(daysintheoffice_pattern)]
len(backtotheoffice)

# 'HYBRID OPTIONS' OR 'HYBRID WORK'
hybridoptions_pattern = "([Hh]ybrid[ -][Oo]ptions)|([Hh]ybrid[ -][Ww]ork)"
hybridoptions = Twitter_batches[Twitter_batches["text"].str.contains(hybridoptions_pattern)]
len(hybridoptions)

# IN-PERSON WORK
inpersonwork_pattern = "[Ii]n[ -][Pp]erson[ -][Ww]ork"
in_personwork = Twitter_batches[Twitter_batches["text"].str.contains(inpersonwork_pattern)]
len(in_personwork)

# 'PRODUCTIVE AT WORK' OR 'PRODUCTIY AT WORK'
productiveatwork_pattern = "([Pp]roductive[ -][Aa]t[ -][Ww]ork)|([Pp]roductivity[ -][Aa]t[ -][Ww]ork)"
productiveatwork = Twitter_batches[Twitter_batches["text"].str.contains(productiveatwork_pattern)]
len(productiveatwork)

# 'REMOTE WORK' OR 'REMOTE WORKERS'
remotework_pattern = "([Rr]emote[ -][Ww]ork)|([Rr]emote[ -][Ww]orkers)"
remotework = Twitter_batches[Twitter_batches["text"].str.contains(remotework_pattern)]
len(remotework)

# 'RETURN TO OFFICE' OR 'RETURN TO THE OFFICE'
returntooffice_pattern = "([Rr]eturn[ -][Tt]o[ -][Oo]ffice)|([Rr]eturn[ -][Tt]o[ -][Tt]he[ -][Oo]ffice)"
returntooffice = Twitter_batches[Twitter_batches["text"].str.contains(returntooffice_pattern)]
len(returntooffice)

# RETURN-TO-WORK
return_to_work_pattern = "[Rr]eturn[ -][Tt]o[ -][Ww]ork"
return_to_work = Twitter_batches[Twitter_batches["text"].str.contains(return_to_work_pattern)]
len(return_to_work)

# WORK IN OFFICE
workinoffice_pattern = "[Ww]ork[ -][Ii]n[ -][Oo]ffice"
workinoffice = Twitter_batches[Twitter_batches["text"].str.contains(workinoffice_pattern)]
len(workinoffice)

# 'WORK ONSITE' OR 'WORKING ONSITE'
workonsite_pattern = "([Ww]ork[ -][Oo]nsite)|([Ww]orking[ -][Oo]nsite)"
workonsite = Twitter_batches[Twitter_batches["text"].str.contains(workonsite_pattern)]
len(workonsite)

# 'WORK REMOTELY' OR 'WORKING REMOTELY'
workremotely_pattern = "([Ww]ork[ -][Rr]emotely)|([Ww]orking[ -][Rr]emotely)"
workremotely = Twitter_batches[Twitter_batches["text"].str.contains(workremotely_pattern)]
len(workremotely)

# COMBINE PATTERNS INTO THREE VARIABLES TO FACILITATE SIMPLER FILTERING
combine_pattern1 = "([Bb]ack[ -][Ii]nto[ -][Tt]he[ -][Oo]ffice)|([Bb]ack[ -][Tt]o[ -][Tt]he[ -][Oo]ffice)|([Cc]oming[ -][Ii]nto[ -][Ww]ork)|([Dd]ays[ -][Ii]n[ -][Tt]he[ -][Oo]ffice)|([Hh]ybrid[ -][Oo]ptions)|([Hh]ybrid[ -][Ww]ork)"
combine_pattern2 = "([Ii]n[ -][Pp]erson[ -][Ww]ork)|([Pp]roductive[ -][Aa]t[ -][Ww]ork)|([Pp]roductivity[ -][Aa]t[ -][Ww]ork)|([Rr]emote[ -][Ww]ork)|([Rr]emote[ -][Ww]orkers)|([Rr]eturn[ -][Tt]o[ -][Oo]ffice)|([Rr]eturn[ -][Tt]o[ -][Tt]he[ -][Oo]ffice)"
combine_pattern3 = "([Rr]eturn[ -][Tt]o[ -][Ww]ork)|([Ww]ork[ -][Ii]n[ -][Oo]ffice)|([Ww]ork[ -][Oo]nsite)|([Ww]orking[ -][Oo]nsite)|([Ww]ork[ -][Rr]emotely)|([Ww]orking[ -][Rr]emotely)"


# FILTER OUT TWITTER_BATCHES TO ONLY INCLUDE RESULTS WITH DESIGNATED SEARCH TERMS; REMOVE DUPLICATES
TwitterMatches = Twitter_batches[Twitter_batches["text"].str.contains(combine_pattern1)|Twitter_batches["text"].str.contains(combine_pattern2)|Twitter_batches["text"].str.contains(combine_pattern3)]
len(TwitterMatches)
TwitterMatches_Final = TwitterMatches.drop_duplicates(['created_at', 'text'], keep='first')
len(TwitterMatches_Final)

#### FILTER OUT RETWEETS
TwitterMatches_Final_NoRetweets = TwitterMatches_Final[~TwitterMatches_Final['text'].str.startswith('RT')]
len(TwitterMatches_Final_NoRetweets)

#### EVALUATE LENGTHS OF FINAL RESULTS AND CONVERT TO COMMA SEPARATED FILES
len(TwitterMatches_Final)
len(TwitterMatches_Final_NoRetweets)
TwitterMatches_Final.to_csv("TwitterMatches.csv", sep=",")
TwitterMatches_Final_NoRetweets.to_csv("TwitterMatches_NoRetweets.csv", sep=",")


