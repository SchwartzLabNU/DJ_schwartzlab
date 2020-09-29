%{
# eye injections
event_id : int unsigned auto_increment
---
-> sl.InjectionSubstance
-> sl.Eye
-> sl.User                      # who did the injection
time: time                    # time of day
date : date
entry_time = CURRENT_TIMESTAMP : timestamp # when this was entered into db

dilution: float                      # dilution of substance
notes: varchar(256)                  # injection notes (can include people who assisted)
%}

classdef AnimalEventEyeInjection < sl.AnimalEvent & dj.Manual
end
