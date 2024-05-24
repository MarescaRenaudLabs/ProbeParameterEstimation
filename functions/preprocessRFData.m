function data = preprocessRFData(P, RFData)
    
    fprintf('Preprocessing RFData...\n');

    % rearange the RF signals
    RF = zeros(P.Nz_RF, P.num_elements, P.num_elements);
    for k = 1:P.num_elements
        tmp = double(RFData(1 + (k - 1) * P.Nz_RF:k * P.Nz_RF, 1:P.num_elements, :));
        RF(:, :, k) = tmp;
    end

    % apply bandpass filter
    if P.applyFilter
        b = fir1(50, [0.5 1.5] * P.Fc / (P.Fs / 2), 'bandpass'); a = 1;
        RF = filtfilt(b, a, RF);
    end

    % apply TGC
    if P.applyTGC
        M = (linspace(1, size(RF, 1), size(RF, 1)).') .^ 1.5;
        M = M ./ max(M(:));
        RF = RF .* M;
    end

    % Average the shots
    Nh = P.half_width_aperture_nh_el;
    Nb = 2 * Nh + 1;
    nb_shots_for_average = P.num_elements - Nb;
    RF_avg = zeros(size(RF, 1), 2 * Nh + 1);
    for k_c = Nh + 1:Nh + 1 + nb_shots_for_average
        index = k_c - Nh:k_c + Nh;
        RF_avg = RF_avg + RF(:, index, k_c);
    end

    % hilbert transform of RF data
    RFIQ_avg = hilbert(RF_avg);

    % element positions and time vector
    data.RF = RF; % filtered data, single shots
    data.XS_all = (0:size(RF, 2) - 1) * P.pitch; % element positions full width data
    data.RF_avg = RF_avg; % averaged shots, smaller subaperture
    data.RFIQ_avg = RFIQ_avg; % hilbert transform of average data
    data.XS = (0:size(RF_avg, 2) - 1) * P.pitch; % element positions corresponding to smaller subaperture
    data.Time = (0:P.Nz_RF - 1) ./ P.Fs; % time vector

end
