function AM = align_ibm1(trainDir, numSentences, maxIter, fn_AM)
%
%  align_ibm1
% 
%  This function implements the training of the IBM-1 word alignment algorithm. 
%  We assume that we are implementing P(foreign|english)
%
%  INPUTS:
%
%       dataDir      : (directory name) The top-level directory containing 
%                                       data from which to train or decode
%                                       e.g., '/u/cs401/A2_SMT/data/Toy/'
%       numSentences : (integer) The maximum number of training sentences to
%                                consider. 
%       maxIter      : (integer) The maximum number of iterations of the EM 
%                                algorithm.
%       fn_AM        : (filename) the location to save the alignment model,
%                                 once trained.
%
%  OUTPUT:
%       AM           : (variable) a specialized alignment model structure
%
%
%  The file fn_AM must contain the data structure called 'AM', which is a 
%  structure of structures where AM.(english_word).(foreign_word) is the
%  computed expectation that foreign_word is produced by english_word
%
%       e.g., LM.house.maison = 0.5       % TODO
% 
% Template (c) 2011 Jackie C.K. Cheung and Frank Rudzicz
  
  global CSC401_A2_DEFNS
  
  AM = struct();
  
  % Read in the training data
  [eng, fre] = read_hansard(trainDir, numSentences);

  % Initialize AM uniformly 
  AM = initialize(eng, fre);

  % Iterate between E and M steps
  for iter=1:maxIter,
    AM = em_step(AM, eng, fre);
  end

  % Save the alignment model
  save( fn_AM, 'AM', '-mat'); 

  end


% --------------------------------------------------------------------------------
% 
%  Support functions
%
% --------------------------------------------------------------------------------

function [eng, fre] = read_hansard(mydir, numSentences)
%
% Read 'numSentences' parallel sentences from texts in the 'dir' directory.
%
% Important: Be sure to preprocess those texts!
%
% Remember that the i^th line in fubar.e corresponds to the i^th line in fubar.f
% You can decide what form variables 'eng' and 'fre' take, although it may be easiest
% if both 'eng' and 'fre' are cell-arrays of cell-arrays, where the i^th element of 
% 'eng', for example, is a cell-array of words that you can produce with
%
%         eng{i} = strsplit(' ', preprocess(english_sentence, 'e'));
%
  eng = {};
  fre = {};
  
  AM_index = 1;
  
  DD_en = dir( [ dataDir, filesep, '*', 'e'] );
  DD_fr = dir( [ dataDir, filesep, '*', 'f'] );
  
  % Iterate through all en/fr file pairs
  for iFile=1:length(DD_en)

    fprintf('File %s (#%d/%d)\n', DD(iFile).name, iFile, length(DD))
    
    % read all lines from en/fr file pairs
    lines_en = textread([dataDir, filesep, DD_en(iFile).name], '%s','delimiter','\n');
    lines_fr = textread([dataDir, filesep, DD_fr(iFile).name], '%s','delimiter','\n');
    
    % pre-process and split each line into eng and fre
    for line_idx=1:length(lines_en)
        eng{AM_index} = strsplit(' ', preprocess(lines_en{line_idx}, 'e'));
        fre{AM_index} = strsplit(' ', preprocess(lines_fr{line_idx}, 'f'));
        AM_index = AM_index + 1;
    end
  end


function AM = initialize(eng, fre)
%
% Initialize alignment model uniformly.
% Only set non-zero probabilities where word pairs appear in corresponding sentences.
%
    AM = {}; % AM.(english_word).(foreign_word)
    n_words = 0
    for i=1:length(eng)
        % iterate through all eng and french dicts
        for en_word = eng
            en_word = char(en_word)
            for fr_word = fre
                fr_word = char(fr_word)
                if ~isfield(AM, en_word)
                    AM.(en_word) = stuct();
                    n_word += 1
                end
            end
        end
    end
    fprintf('Total of %d different combinations, initializing all P to 1/%d\n', n_word, n_word);
    for i=1:length(eng)
        % iterate through all eng and french dicts
        for en_word = eng
            en_word = char(en_word)
            for fr_word = fre
                fr_word = char(fr_word)
                AM.(en_word).(fr_word) = 1.0/n_word;
            end
        end
    end

    % TODO: your code goes here

end

function t = em_step(t, eng, fre)
% 
% One step in the EM algorithm.
%
  
  % TODO: your code goes here
end


