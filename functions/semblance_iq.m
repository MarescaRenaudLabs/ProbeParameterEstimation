function S = semblance_iq(sig)
    % Real signals:
    %     S = sum(sum(sig, 2) .^ 2) / sum(sum(sig .^ 2, 2));
    % Analystic signals:
    S = sum(abs(sum(sig, 2) .^ 2)) / sum(sum(abs(sig) .^ 2, 2));
end
