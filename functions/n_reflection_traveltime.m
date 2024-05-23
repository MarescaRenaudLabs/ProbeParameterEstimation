function [tof1, tof2, tof3] = n_reflection_traveltime(x_elem_r, x_elem_t, c_lens, t_lens, t_rt_matching_layers)
    % [tof1, tof2, tof3, tof4] = n_reflection_traveltime(x_elem_r, x_elem_t, c_lens, t_lens)
    % x_elem_r: x position element reception
    % x_elem_t: x position element transmission
    % c_lens:   speed of sound lens
    % t_lens:   thickness lens
    %
    % date:    20-01-2023
    % author:  R. Waasdorp (r.waasdorp@tudelft.nl)
    % ==============================================================================

    % thickness is the thickness at the left end of the layer
    zs = t_lens;
    tof1 = sqrt((2 * zs) .^ 2 + (x_elem_r - x_elem_t) .^ 2) ./ c_lens;
    % tof1 = tof1 ;% + t_rt_matching_layers;

    SA = 2 * (t_lens);
    RB = 2 * (t_lens);
    SR = (x_elem_r - x_elem_t);
    beta = atan((SA + RB) ./ SR);

    tof2 = sqrt(SA ^ 2 + (SR * SA .* cos(beta) ./ (SA .* cos(beta) + RB .* cos(- beta))) .^ 2 + 2 * SA .* ((SR .* SA .* cos(beta)) ./ (SA .* cos(beta) + RB .* cos(- beta))) * 0) .* (1 + RB / SA) / c_lens;
    tof2(x_elem_r == x_elem_t) = 4 * t_lens / c_lens;
    tof2 = tof2 + t_rt_matching_layers;

    if nargout >= 3
        tof3 = 6 * sqrt((SR / 6) .^ 2 + t_lens .^ 2) / c_lens;
        tof3(x_elem_r == x_elem_t) = 6 * t_lens / c_lens;
        tof3 = tof3 + 2 * t_rt_matching_layers;
    end

end
