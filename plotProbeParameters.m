function f = plotProbeParameters(P, data, result)

    % unpack somethings
    metrics = result.metrics;
    Time = data.Time;
    XS = data.XS;
    NR_to_use = P.NR_to_use;

    RF_plot = data.RF_avg;
    RF_plot(1:P.numSamplesMute, :) = 0; % only for visualization

    % compute tof
    [tof{1}, tof{2}, tof{3}] = n_reflection_traveltime(XS, XS(P.half_width_aperture_nh_el + 1), result.val_c_lens, result.val_h_lens, P.t_rt_matching_layers);

    % set colormap and figure settings
    cmap_s = parula;
    f = figure(81); clf;
    f.Color = 'w';
    f.Position = [100 100 1600 800];

    % plot RF data
    subplot(2, 3, [1 4]);
    imagesc(1:length(tof{1}), Time * 1e6, RF_plot ./ max(RF_plot))
    hold on
    for k = NR_to_use; plot((tof{k} + result.val_ttp) * 1e6, 'r--', 'linewidth', 1); end
    for k = setdiff(1:3, NR_to_use); plot((tof{k} + result.val_ttp) * 1e6, 'k--', 'linewidth', 1); end
    ylabel('arrival time (\mus)')
    xlabel('elements')
    % set(gca, 'fontsize', 12)
    % title(strrep(result.title, '_', ' '))

    % plot RF data zoom
    subplot(2, 3, 2);
    hold on
    set(gca, 'YDir', 'reverse')
    margin_semblance_ind_disp = 5;

    rf_coherence = cell(3, 1);
    yax_tmp = (- margin_semblance_ind_disp:margin_semblance_ind_disp);
    for k = 1:3
        t_interp = tof{k} + result.val_ttp + (- margin_semblance_ind_disp:margin_semblance_ind_disp).' ./ P.Fs;
        sig_interp = interp1_per_channel(Time, RF_plot, t_interp);
        rf_coherence{k} = sig_interp;
    end

    % tv_disp = Time(1:margin_semblance_ind_disp * 2 + 1); tv_disp = tv_disp - mean(tv_disp);
    nREF_to_plot = max(NR_to_use);
    yticks_tmp = zeros(nREF_to_plot, 1);
    for k = 1:nREF_to_plot
        yax_k = yax_tmp + (numel(yax_tmp) + 2) * (k - 1);
        xax_k = 0:size(rf_coherence{k}, 2);
        imagesc(xax_k, yax_k, rf_coherence{k} ./ max(rf_coherence{k}))
        yline(mean(yax_k), 'r')
        xlim([min(xax_k), max(xax_k)])
        yticks_tmp(k) = mean(yax_k);
    end
    yticks(yticks_tmp); yticklabels(compose('refl %i', 1:nREF_to_plot))
    % title(sprintf('ttp idx %i/%i - Metric score: %.2f', ...
    %     result.idx_ttp, numel(ttp_vals), metrics_peak));

    h_vals = P.thickness_values_test;
    c_vals = P.c_values_test;
    ttp_vals = P.ttp_values_test;

    % plot solution metrics
    subplot(2, 3, 3);
    imagesc(h_vals * 1e3, c_vals, squeeze(metrics(result.idx_ttp, :, :)))
    colorbar
    xlabel('lens thickness (mm)')
    ylabel('lens wavespeed (m/s)')
    hold on
    scatter(result.val_h_lens * 1e3, result.val_c_lens, 'rx')
    colormap(cmap_s)
    title(sprintf('t_{ttp} = %.2f ns', result.val_ttp * 1e9))

    subplot(2, 3, 5);
    imagesc(ttp_vals * 1e9, c_vals, squeeze(metrics(:, :, result.idx_h_lens)).')
    colorbar
    xlabel('time to peak (us)')
    ylabel('lens wavespeed (m/s)')
    hold on
    scatter(result.val_ttp * 1e9, result.val_c_lens, 'rx')
    colormap(cmap_s)
    title(sprintf('h_{lens} = %.2f mm', result.val_h_lens * 1e3))

    subplot(2, 3, 6);
    imagesc(h_vals * 1e3, ttp_vals * 1e9, squeeze(metrics(:, result.idx_c_lens, :)))
    colorbar
    ylabel('time to peak (us)')
    xlabel('lens thickness (mm)')
    hold on
    scatter(result.val_h_lens * 1e3, result.val_ttp * 1e9, 'rx')
    colormap(cmap_s)
    title(sprintf('c_{lens} = %.2f m/s', result.val_c_lens))

end
