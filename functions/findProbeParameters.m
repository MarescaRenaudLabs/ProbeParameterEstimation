function result = findProbeParameters(P, data)

    fprintf('Finding Probe Parameters...\n');
    
    % unpack some variables
    XS = data.XS;
    Time = data.Time;
    Nh = P.half_width_aperture_nh_el;

    c_lens_vals = P.c_values_test;
    h_lens_vals = P.thickness_values_test;
    ttp_vals = P.ttp_values_test;

    %% OPTIMIZE
    S_all = zeros(P.NDelay, P.NCLens, P.NThickness, max(P.NR_to_use));
    P.NR_to_use = P.NR_to_use(:).'; % make sure its a row vector

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
                    rf_interp = interp1_per_channel(Time, data.RFIQ_avg, t_interp, 'cubic');
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
    result.metrics = metrics;
    result.metrics_normalized = metrics_normalized;

    fprintf('%s\nOptimal Parameters:\n', repelem('-', 60));
    fprintf('  LENS_THICKNESS = %.3f mm\n', result.val_h_lens * 1e3)
    fprintf('  LENS_SOS       = %.2f m/s\n', result.val_c_lens)
    fprintf('  TIME_TO_PEAK   = %.2f us;\n', result.val_ttp * 1e6)

end
