function [ test_peaks,cat_peaks ] = check( test_peaks, cat_peaks )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
[test_rows_final, test_columns_final] = size(test_peaks);
[comparedRows, comparedColumns] = size(cat_peaks);
if test_columns_final < comparedColumns
    disp('1');
    cat_peaks = cat_peaks(:, 1:test_columns_final);
elseif test_columns_final > comparedColumns
    disp('2');
    test_peaks = test_peaks(:, 1:comparedColumns);
end
if test_rows_final < comparedRows
    disp('4');
    cat_peaks = cat_peaks(1:test_rows_final,:);
elseif test_rows_final > comparedRows
    disp('5');
    test_peaks = test_peaks(1:comparedRows,:);
end
end

