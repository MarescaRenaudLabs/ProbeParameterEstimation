function result = findProbeParameters(P, RFData)

    % rearange the RF signals
    RF = zeros(P.Nz_RF, P.num_elements, P.num_elements);
    for k = 1:P.num_elements
        tmp = double(RFData(1 + (k - 1) * P.Nz_RF:k * P.Nz_RF, 1:P.num_elements, :));
        tmp = mean(tmp, 3);
        RF(1:end, :, k) = tmp;
    end

    % apply bandpass filter
    if P.applyFilter
        b = fir1(50, [0.5 1.5] * P.Fc / (P.Fs / 2), 'bandpass'); a = 1;
        RF = filter(b, a, RF);
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
    XS = (0:size(RF_avg, 2) - 1) * P.pitch;
    Time = (0:P.Nz_RF - 1) ./ P.Fs;

    %% OPTIMIZE
    S_all = zeros(P.NDelay, P.NCLens, P.NThickness, max(P.NR_to_use));
    P.NR_to_use = P.NR_to_use(:).'; % make sure its a row vector

    c_lens_vals = P.c_values_test;
    h_lens_vals = P.thickness_values_test;
    ttp_vals = P.ttp_values_test;

    time_remaining_progbar_ui(0, P.NDelay)
    for k_ttp = 1:P.NDelay
        for k_c = 1:P.NCLens
            for k_h = 1:P.NThickness
                round_trip_and_ttp = 2 * h_lens_vals(k_h) / c_lens_vals(k_c) + ttp_vals(k_ttp);
                if (round_trip_and_ttp < P.min_round_trip) || (round_trip_and_ttp > P.max_round_trip)
                    continue
                end
                [tof{1}, tof{2}, tof{3}] = n_reflection_traveltime(XS, XS(Nh + 1), c_lens_vals(k_c), h_lens_vals(k_h), P.t_rt_matching_layers);
                for k = P.NR_to_use
                    t_interp = tof{k} + ttp_vals(k_ttp);
                    rf_interp = interp1_per_channel(Time, RFIQ_avg, t_interp, 'cubic');
                    [S, nrj] = calc_semblance_iq(rf_interp);
                    S_all(k_ttp, k_c, k_h, k) = S * nrj;

                end
            end
        end
        time_remaining_progbar_ui(k_ttp, P.NDelay)
    end

    metrics_normalized = S_all ./ max(S_all, [], [1 2 3]);

    %% find the peak in the normalized metrics
    metrics = sum(metrics_normalized(:, :, :, P.NR_to_use), 4);

    % first get the global max
    [Y, IND] = max(metrics(:));
    [result.idx_ttp, result.idx_c_lens, result.idx_h_lens] = ind2sub(size(metrics), IND);

    % convert indices to values
    result.val_ttp = ttp_vals (result.idx_ttp);
    result.val_c_lens = c_lens_vals (result.idx_c_lens);
    result.val_h_lens = h_lens_vals(result.idx_h_lens);

    % pack data in results struct
    result.XS = XS;
    result.Time = Time;
    result.RF_avg = RF_avg;
    result.RFIQ_avg = RFIQ_avg;
    result.metrics = metrics;
    result.metrics_normalized = metrics_normalized;

    fprintf('%s\nOptimal Parameters:\n', repelem('-', 60));
    fprintf('  LENS_THICKNESS = %.3f mm\n', result.val_h_lens * 1e3)
    fprintf('  LENS_SOS       = %.2f m/s\n', result.val_c_lens)
    fprintf('  TIME_TO_PEAK   = %.2f us;\n', result.val_ttp * 1e6)

end
