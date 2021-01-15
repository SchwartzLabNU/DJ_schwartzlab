function [] = runFullPipeline(pipeline, workingGroup, analysisSteps, loadFirst, exportStates)
if nargin<5
    export = false;
else
    export = true;
end

Nsteps = length(analysisSteps);
workingQuery = workingGroup.searchTable & workingGroup.primaryKeyStruct;
fname = [getenv('pipelines_folder'), pipeline, filesep, 'runLog.txt'];
if ~exist(fname, 'file')
    fid = fopen(fname, 'w');
else
    fid = fopen(fname, 'a');
end

fprintf(fid, '%s: beginning run of pipeline %s\n', datestr(now), pipeline);
try
    for i=1:Nsteps
        funcType = analysisSteps(i).funcType;
        funcName = analysisSteps(i).funcName;
        P = analysisSteps(i).P;
        
        fprintf(fid,'Step %d: %s function %s\n', i, funcType, funcName);
        tic;
        
        foundAll = false;
        
        if loadFirst
            %fprintf(fid,'Loading previously computed results.\n');
            %[analysisOutput, loaded_some, missed_some] = loadResult(pipeline, funcType, funcName, workingQuery);
            % look for results that will be needed but don't fetch them because that is slow
            missingEntries = findResults(pipeline, funcType, funcName, workingQuery);
            if ~isempty(missingEntries) && missingEntries.exists
                fprintf(fid,'Running function %s for %d entries not found in database.\n', funcName, missingEntries.count);
            %    missingEntries_struct = missingEntries.fetch();
            %    for e=1:missingEntries.count
            %        e
            %        missingEntries_struct(e)
            %        fprintf(fid,'Running function %s on entry %d\n', funcName, e);
                    analysisOutput = runAnalysis(pipeline, funcType, funcName, P, missingEntries, []);
%                    fprintf(fid,'Writing results of function %s for entry %d\n', funcName, e);
                    writeResult(pipeline, funcType, funcName, P, analysisOutput, true);
           %     end
            else
                fprintf(fid,'All results for %s found in database so not running analysis.\n', funcName);
                foundAll = true;
            end
        else
            allEntries_struct = workingQuery.fetch();
            fprintf(fid,'Running function %s for all %d entries.\n', funcName, length(allEntries_struct));
            %for e=1:workingQuery.count
            %    e
            %    allEntries_struct(e)
            %    fprintf(fid,'Running function %s on entry %d\n', funcName, e);
                analysisOutput = runAnalysis(pipeline, funcType, funcName, P, workingQuery, []);
            %    fprintf(fid,'Writing results of function %s for entry %d\n', funcName, e);
                writeResult(pipeline, funcType, funcName, P, analysisOutput, true);
           % end
        end
        
        if ~foundAll
            fprintf(fid,'Writing results of %s to database.\n', funcName);
            writeResult(pipeline, funcType, funcName, P, analysisOutput, true);
        end
        
        if export
            exportState = exportStates{i};
            if ~isempty(exportState)
                fprintf(fid,'Exporting results of %s to hdf5 files.\n', funcName);
                analysisOutput = loadResult(pipeline, funcType, funcName, workingQuery);
                h5Export(pipeline, exportState, analysisOutput, true);
            end
        end
        
        elapsed = toc;
        fprintf(fid,'Step %d: elapsed time = %.1f seconds.\n', i, elapsed);
    end
    
catch ME
    fprintf(fid,'Pipeline run error.\n');
    fprintf(fid,'--------------------------------\n\n');
    fclose(fid);
    rethrow(ME);
end

fprintf(fid,'Pipeline run completed successfully.\n');
fprintf(fid,'--------------------------------\n\n');
fclose(fid);
