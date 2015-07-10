function A = padshift(A, k, pad)
    d = length(k);
    s = size(A);

    A = circshift(A, k);
    for i = 1:d
        if (abs(k(i)) >= s(i))
            A = zeros(s);
            break;
        end
        subs = num2cell(repmat(':', 1, d));
        idx = s(i) - abs(k(i)) + 1 : s(i);
        if (k(i) > 0)
            idx = idx - (s(i) - k(i));
        end
        subs{i} = idx;
        A = subsasgn(A, substruct('()', subs), pad);
    end

    %% slower:
    %
    %subsin = num2cell(repmat(':', 1, d));
    %for i = 1:d
    %    if (abs(k(i)) >= s(i))
    %        continue;
    %    end
    %    idx = abs(k(i)) + 1 : s(i);
    %    if (k(i) > 0)
    %        idx = idx - k(i);
    %    end
    %    subsin{i} = idx;
    %    subsout{i} = idx + k(i);
    %end
    %A = subsasgn(zeros(s), substruct('()', subsout), subsref(A, substruct('()', subsin)));
end
