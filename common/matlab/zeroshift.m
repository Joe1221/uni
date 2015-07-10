function B = zeroshift (A, k)
    B = circshift(A, k);

    for i = 1:numel(k)
        if (abs(k(i)) >= size(A,i))
            B = zeros(size(A));
            break
        end
        if (k(i) > 0)
            B(1:k(i),:) = 0;
        elseif (k(i) < 0)
            B(mod(k(i),size(A,i))+1:end,:) = 0;
        end
        B = shiftdim(B, 1);
    end
end
