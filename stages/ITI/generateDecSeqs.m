function num_seqs = generateDecSeqs(n_seq, l_seq, min_num, max_num)
    %% Generates sequences of numbers with decreasing values
    % Usage:
    %   numberSequences = generateDecreasingSequences(numSequences, sequenceLength)
    % Input:
    %   n_seq: Int.Number of sequences to generate
    %   l_seq: Int.Length of each sequence (number of numbers in each sequence)
    %   min_num, max_num: range of minmum and maximum number. 
    % Output:
    %   numberSequences - A matrix where each row is a sequence of numbers with decreasing values
    
    %% Initialize the matrix to store sequences
    num_seqs = zeros(n_seq, l_seq);

    % Generate each sequence
    for iSeq = 1:n_seq
        curr_num = randi([min_num, max_num]);  % Start with a random number between 1 and 16
        num_seqs(iSeq, 1) = curr_num;

        % Generate subsequent numbers in the sequence
        for j = 2:l_seq
            curr_num = randi([1, curr_num]);  % Subsequent numbers must be less than or equal to the previous
            num_seqs(iSeq, j) = curr_num;
        end
    end
end
