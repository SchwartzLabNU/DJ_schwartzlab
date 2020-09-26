%{
# Session in 3 chamber circular social behavior device. Animal here is the TEST (center) animal

event_id : int unsigned auto_increment
--- 
-> sl_test.Animal
-> sl_test.User                                          # who performed the experiment
-> sl_test.SocialBehaviorExperimentType    # type of experiment, like social dominance, mate preference familiarity with rig, etc.  
date: date
time : time                                         # session start time
entry_time = CURRENT_TIMESTAMP : timestamp # when this was entered into db

duration : time                 # approximate duration
fname = NULL : varchar(128)                          # root filename if session was recorded
notes : varchar(256)                                 # notes about the animal's state and comfort level, other people involvd, etc. 
%}

classdef AnimalEventSocialBehaviorSession < sl_test.AnimalEvent & dj.Manual
end
