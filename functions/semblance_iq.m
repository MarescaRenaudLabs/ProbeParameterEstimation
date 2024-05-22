function S = semblance_iq(sig)
    % REAL SIGNALS
    %     S = sum(sum(sig, 2) .^ 2) / sum(sum(sig .^ 2, 2));
    %     hilbert signals:
    S = sum(abs(sum(sig, 2) .^ 2)) / sum(sum(abs(sig) .^ 2, 2));
end
