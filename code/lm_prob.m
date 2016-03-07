function logProb = lm_prob(sentence, LM, type, delta, vocabSize)
%
%  lm_prob
%
%  This function computes the LOG probability of a sentence, given a
%  language model and whether or not to apply add-delta smoothing
%
%  INPUTS:
%
%       sentence  : (string) The sentence whose probability we wish
%                            to compute
%       LM        : (variable) the LM structure (not the filename)
%       type      : (string) either '' (default) or 'smooth' for add-delta smoothing
%       delta     : (float) smoothing parameter where 0<delta<=1
%       vocabSize : (integer) the number of words in the vocabulary
%
% Template (c) 2011 Frank Rudzicz

  logProb = -Inf;

  % some rudimentary parameter checking
  if (nargin < 2)
    disp( 'lm_prob takes at least 2 parameters');
    return;
  elseif nargin == 2
    type = '';
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  end
  if (isempty(type))
    delta = 0;
    vocabSize = length(fieldnames(LM.uni));
  elseif strcmp(type, 'smooth')
    if (nargin < 5)
      disp( 'lm_prob: if you specify smoothing, you need all 5 parameters');
      return;
    end
    if (delta <= 0) or (delta > 1.0)
      disp( 'lm_prob: you must specify 0 < delta <= 1.0');
      return;
    end
  else
    disp( 'type must be either '''' or ''smooth''' );
    return;
  end

  words = strsplit(' ', sentence);

  % TODO: the student implements the following
  prev_word = '__DNE__';
  logProb = 1;
  for word = words
      word = char(word);

      % skip if empty
      if isempty(word)
          continue
      end

      % calculate UNIGRAM frequecy defined as count(w_i)
      if isfield(LM.uni, word)
          uni_freq = LM.uni.(word);
          fprintf('uni_frequency P(%s) is %d\n', word, uni_freq)
      else
          uni_freq = 0;
      end

      % Calculate prob (without taking log)
      if strcmp(prev_word, '__DNE__')
          % init
          prev_word = word;
          continue;
      end

      % calculate BIGRAM frequecy defined as count(w_(i-1), w_i)
      if isfield(LM.bi, prev_word) && isfield(LM.bi.(prev_word), word)
          bi_freq = LM.bi.(prev_word).(word);
          fprintf('bi_frequency P(%s|%s) is %d\n', word, prev_word, bi_freq)
      else
          bi_freq = 0;
      end

      % dirty deed done diry cheap
      partial_prob = (bi_freq + delta) / (uni_freq + delta * vocabSize);
      if isnan(partial_prob)
          partial_prob = 0;
      end
      logProb = logProb * partial_prob;

      % word => prev_word
      prev_word = word;
  end

  % take the log to get actual logProb
  logProb = log(logProb);
return
