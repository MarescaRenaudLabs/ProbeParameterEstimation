function Cw = calc_weighted_coherence(RF, nelems)
    if nargin == 1; nelems = floor(size(RF, 2) / 2); end
    RF = RF(:, (-nelems:nelems) + ceil(size(RF, 2) / 2));
    assert(size(RF, 1) == 1, 'Number of samples in time must be 1!');
    Cw = abs(sum(RF ./ abs(RF))) ^ 2 * sum(abs(RF) .^ 2);
end
