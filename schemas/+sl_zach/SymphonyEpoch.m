%{
# A single Symphony epoch, which may contain one or more channels
-> sl_zach.Symphony
epoch_number : unsigned int   # the index of this epoch in the HDF5 file
-> sl_zach.SymphonyProtocols #protocol_name: varchar(128)
---
start_time : int unsigned # number of milliseconds since midnight on the day the session started
duration: int unsigned # number of milliseconds

%TODO: verify that other fields from sl.Dataset should be here... i think not?
%}
classdef SymphonyEpoch < dj.Part
  properties(SetAccess=protected)
    master = sl_zach.Symphony;
  end

end