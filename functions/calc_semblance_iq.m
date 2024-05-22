function [S, nrj] = calc_semblance_iq(RF, nelems)
    if nargin == 1; nelems = floor(size(RF, 2) / 2); end

    RF = RF(:, (-nelems:nelems) + ceil(size(RF, 2) / 2));
    nrj = sum(abs(RF(:)) .^ 2);
    for kk = 1:size(RF, 2)
        if all(RF(:, kk) == 0); continue; end
        % channel normalization:
        RF(:, kk) = RF(:, kk) / max(abs(RF(:, kk)));
    end
    S = semblance_iq(RF);
    % S = S * nrj; %*maxi;
end
