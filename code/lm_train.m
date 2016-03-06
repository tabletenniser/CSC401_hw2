function LM = lm_train(dataDir, language, fn_LM)
%
%  lm_train
% 
%  This function reads data from dataDir, computes unigram and bigram counts,
%  and writes the result to fn_LM
%
%  INPUTS:
%
%       dataDir     : (directory name) The top-level directory containing 
%                                      data from which to train or decode
%                                      e.g., '/u/cs401/A2_SMT/data/Toy/'
%       language    : (string) either 'e' for English or 'f' for French
%       fn_LM       : (filename) the location to save the language model,
%                                once trained
%  OUTPUT:
%
%       LM          : (variable) a specialized language model structure  
%
%  The file fn_LM must contain the data structure called 'LM', 
%  which is a structure having two fields: 'uni' and 'bi', each of which holds
%  sub-structures which incorporate unigram or bigram COUNTS,
%
%       e.g., LM.uni.word = 5       % the word 'word' appears 5 times
%             LM.bi.word.bird = 2   % the bigram 'word bird' appears twice
% 
% Template (c) 2011 Frank Rudzicz

global CSC401_A2_DEFNS

LM=struct();
LM.uni = struct();
LM.bi = struct();

SENTSTARTMARK = 'SENTSTART'; 
SENTENDMARK = 'SENTEND';

DD = dir( [ dataDir, filesep, '*', language] );

disp([ dataDir, filesep, '.*', language] ); 

fprintf('TOTAL of %d %s\n', length(DD), ' files')

for iFile=1:length(DD)
    
  fprintf('File %s (#%d/%d)\n', DD(iFile).name, iFile, length(DD))

  lines = textread([dataDir, filesep, DD(iFile).name], '%s','delimiter','\n');

  for l=1:length(lines)
    processedLine =  preprocess(lines{l}, language);
    words = strsplit(' ', processedLine );
    
    prev_word = 'DNE';
    % TODO: THE STUDENT IMPLEMENTS THE FOLLOWING
    for word = words
        % cell array => string to make LM.uni.(word) happy
        word = char(word);
        
        % skip the empty ones
        if isempty(word)
            continue
        end          
        
        % UNIGRAM + BIGRAM INIT
        if isfield(LM.uni, word)
            LM.uni.(word) = LM.uni.(word) + 1;
        else
            % previously unseen
            LM.uni.(word) = 1;
            if ~strcmp(word, CSC401_A2_DEFNS.SENTEND)
                % initialize bigram key 1 iff it is not SENTEND
                % because p(word|SENTEND) = 0 V word
                LM.bi.(word) = struct();
            end
                
        end
                
        % BIGRAM
        if strcmp(word, CSC401_A2_DEFNS.SENTSTART)
            % nothing is in front of SENTSTART
            prev_word = word;
        else
            if isfield(LM.bi.(prev_word), word)
                LM.bi.(prev_word).(word) = LM.bi.(prev_word).(word) + 1;
            else
                LM.bi.(prev_word).(word) = 1;
            end
            prev_word = word;
        end
    end

    % TODO: THE STUDENT IMPLEMENTED THE PRECEDING
  end
end

save( fn_LM, 'LM', '-mat'); 
