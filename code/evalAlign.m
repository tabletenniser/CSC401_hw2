%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in
%  Task 5.

% some of your definitions
trainDir     = '../data/Hansard/Training';
testDir      = '../data/Hansard/Testing';
fn_LME       = './Eng_LM.mat';
fn_LMF       = './Fre_LM.mat';
lm_type      = 'smooth';
delta        = '0.1';
vocabSize    = 10000;
numSentences = 100;
maxIter = 5;
fn_AM = './lang_align.mat';

% Train your language models. This is task 2 which makes use of task 1
% LME = lm_train( trainDir, 'e', fn_LME );
% LMF = lm_train( trainDir, 'f', fn_LMF );

LME = load('./trained_en.mat');
LMF = load('./trained_fr.mat');

LME = LME.LM;
LMF = LMF.LM;

% Train your alignment model of French, given English
AMFE = align_ibm1( trainDir, numSentences, maxIter, fn_AM );
% ... TODO: more

% TODO: a bit more work to grab the English and French sentences.
%       You can probably reuse your previous code for this
eng_sentences = textread([testDir, filesep, 'Task5.e'], '%s','delimiter','\n');
fre_sentences = textread([testDir, filesep, 'Task5.f'], '%s','delimiter','\n');

for i = 1:length(fre_sentences)
    fre = fre_sentences{i};
    % Decode the test sentence 'fre'
    eng = decode(preprocess(fre, 'f'), LME, AMFE, 'smooth', delta, vocabSize );
    % TODO: perform some analysis
    % add BlueMix code here
    username = '2c26f0a8-b83b-448c-8b44-daa6e799f8a3';
    password = 'WKW85r9ZVwuf';
    curl_str = strcat('curl -u "{', username, '}":"{', password, '}" -X POST -F "text=', fre,'" -F "source=fr" -F "target=en" "https://gateway.watsonplatform.net/language-translation/api/v2/translate"');
    [status, result] = unix(curl_str);

    fprintf('French sentence: %s\n', fre);
    fprintf('Translated English sentence: %s\n', char(eng));
    fprintf('Translated English sentence: %s\n',  strcat(eng{:}));
    
    fprintf('IBM curl status: %s\n', status);
    fprintf('IBM English sentence: %s\n', result);
end

