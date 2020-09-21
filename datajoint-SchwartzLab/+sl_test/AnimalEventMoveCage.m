%{
# animal has switched houses
-> sl_test.AnimalEvent                       # includes date the move ocurred
---
move_from_cage_number: int unsigned          # from cage number
move_to_cage_number: int unsigned            # to cage number
cause = NULL : enum('weaning', 'set as breeder', 'experiment', 'crowding', 'other','unknown')     # cause of move
notes = NULL : varchar(128)                   # any extra notes
(moved_by) -> sl_test.User(name)             # who did the move (we can have a User entry for CCM staff)
%}

classdef AnimalEventMoveCage < dj.Part    
    properties(SetAccess=protected)
        master = sl_test.AnimalEvent
    end
    methods
        function doMove(self)
            oldCage = fetch1(self,'move_from_cage_number');
            newCage = fetch1(self,'move_to_cage_number');
            try 
                currentCage = fetch1(sl_test.AnimalLive & self, 'cage_number');
                if currentCage ~= oldCage
                    disp(['Current cage: ' num2str(currentCage) ' not the same as move_from_cage ' num2str(oldCage)]);  
                    disp('Error: move not completed'); 
                    return;
                end
                %sl_test.
            catch
                disp('Error: move not completed'); 
                return;
            end
            q.animal_id = fetch1(self,'animal_id');
            %delQuick(sl_test.AnimalLive & q);
            q.cage_number = newCage;
            insert(sl_test.AnimalLive, q, 'REPLACE');
            disp('Move successful');
        end
    end
end
