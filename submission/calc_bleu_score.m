function score = calc_bleu_score(translation, reference, n)
    translation = strsplit(' ', translation);
    reference = strsplit(' ', reference);
    
    BP = 1;
    t_len = length(translation);
    r_len = length(reference);
    if r_len > t_len
        BP = exp(1-r_len*1.0/t_len);
    end

    % Calculate unigram precision
    same_unigram_count = 0;
    same_bigram_count = 0;
    same_trigram_count = 0;

    for i = 1:length(translation)
        for j = 1:length(reference)
            if strcmp(char(translation{i}), char(reference{j}))
                same_unigram_count = same_unigram_count + 1;
                if i>1 && j>1 && strcmp(char(translation{i-1}), char(reference{j-1}))
                    same_bigram_count = same_bigram_count + 1;
                    if i>2 && j>2 && strcmp(char(translation{i-2}), char(reference{j-2}))
                        same_trigram_count = same_trigram_count + 1;
                    end
                end
                break;
            end
        end
    end
    unigram_precision = same_unigram_count / t_len;
    bigram_precision = same_bigram_count / t_len;
    trigram_precision = same_trigram_count / t_len;
    score = BP*unigram_precision;
    if n==2
        score = BP*sqrt(unigram_precision*bigram_precision);
    end
    if n==3
        score = BP*(unigram_precision*bigram_precision*trigram_precision)^(1/3);
    end
end
