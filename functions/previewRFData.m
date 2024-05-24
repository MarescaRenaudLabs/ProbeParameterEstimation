function [] = previewRFData(P, data)

    fprintf('Previewing RFData...\n');

    XS = data.XS;
    time = data.Time;
    RF_avg = data.RF_avg;

    show_tx = 64; Nh = P.half_width_aperture_nh_el;
    RF_shot = data.RF(:, show_tx + (-Nh:Nh), show_tx);
    RF_shot(1:P.numSamplesMute, :, :) = 0;
    RF_shot = RF_shot ./ max(abs(RF_shot));

    RF_avg(1:P.numSamplesMute, :, :) = 0;
    RF_avg = RF_avg ./ max(abs(RF_avg));

    RFIQ_avg = data.RFIQ_avg;

    figure(79); clf;
    imagesc(XS * 1e3, time * 1e6, RF_avg);
    xlabel('Element position (mm)')
    ylabel('Time (\mus)')
    title('Averaged shots')
    h = yline(P.min_round_trip * 1e6, 'r--');
    yline(P.max_round_trip * 1e6, 'r--');
    legend(h, 'Search boundaries, align first arrival between these lines')
    colorbar

    f = figure(80); clf;
    f.Position = [120 200 1200 400];
    subplot(131)
    imagesc(XS * 1e3, time * 1e6, RF_shot);
    xlabel('Element position (mm)')
    ylabel('Time (\mus)')
    title('Single shot')
    colorbar

    subplot(132)
    imagesc(XS * 1e3, time * 1e6, RF_avg);
    xlabel('Element position (mm)')
    ylabel('Time (\mus)')
    title('Averaged shots')
    colorbar

    subplot(133)
    imagesc(XS * 1e3, time * 1e6, abs(RFIQ_avg));
    xlabel('Element position (mm)')
    ylabel('Time (\mus)')
    title('Hilbert of Averaged shots')
    colorbar

end
