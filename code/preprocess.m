function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  warning('off','all')
   
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  % separate sentence end punctuations
  outSentence = regexprep( outSentence, '([\.!\?]+) (SENTEND) ', '$1 $2');
  % separate dashes between parenthesis
  outSentence = regexprep( outSentence, '(\(.*)(-)(.*\))', '$1 $2 $3');
  % separate commas, colons, semicolons, parenthesis, dashes, math operations, question marks 
  outSentence = regexprep( outSentence, '([,:;\)\+=-\*\/>!\?])', ' $1 ');
  outSentence = regexprep( outSentence, ' ([\(<])', ' $1 ');
  outSentence = regexprep( outSentence, '  ', ' ');

  switch language
   case 'e'
    % 1) separate 's and s' into its own token
    outSentence = regexprep( outSentence, '''s ', ' ''s ');
    outSentence = regexprep( outSentence, 's'' ', 's '' ');
    outSentence = regexprep( outSentence, 'n''t', 'n ''t');

   case 'f'
    % 1) Separate leading l' from concatenated words
    % outSentence = regexprep( outSentence, ' l''', ' l'' ');
    % 2) Separate single leading consonant and ' from concatenated word
    outSentence = regexprep(outSentence, '(.*) ([qwrtypsdfghjklzxcvbnm]'')(.*)', '$1 $2 $3');
    % 3) Separate qu and ' from concatenated word
    outSentence = regexprep(outSentence, ' qu''', ' qu'' ');
    % 4) Separate [on|il] and ' from concatenated word
    outSentence = regexprep(outSentence, '''on', ''' on');
    outSentence = regexprep(outSentence, '''il', ''' il');
    % 5) d'abord, d'accord, d'ailleurs and d'habitable should not be
    % separated
    outSentence = regexprep(outSentence, 'd'' abord', 'd''abord');
    outSentence = regexprep(outSentence, 'd'' accord', 'd''accord');
    outSentence = regexprep(outSentence, 'd'' ailleurs', 'd''ailleurs');
    outSentence = regexprep(outSentence, 'd'' habitude', 'd''habitude');

  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

