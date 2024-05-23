function data_interp = interp1_per_channel(t, data, t_interp, varargin)
    % data_interp = interp1_per_channel(t,data,t_interp, varargin)
    % interpolates data per channel at the requested time samples.
    % Data will be interpolated along the first dimension.
    %
    % varargin can be other input arguments to interp1:
    %   Vq = interp1(X,V,Xq,METHOD):
    %       'linear'   - (default) linear interpolation
    %       'nearest'  - nearest neighbor interpolation
    %       'next'     - next neighbor interpolation
    %       'previous' - previous neighbor interpolation
    %       'spline'   - piecewise cubic spline interpolation (SPLINE)
    %       'pchip'    - shape-preserving piecewise cubic interpolation
    %       'cubic'    - cubic convolution interpolation for uniformly-spaced
    %                    data. This method does not extrapolate and falls back to
    %                    'spline' interpolation for irregularly-spaced data.
    %              NOTE: 'cubic' changed in R2020b to perform cubic convolution.
    %                    In previous releases, 'cubic' was the same as 'pchip'.
    %       'v5cubic'  - same as 'cubic'
    %       'makima'   - modified Akima cubic interpolation
    %
    %  Vq = interp1(X,V,Xq,METHOD,'extrap')
    %  Vq = interp1(X,V,Xq,METHOD,EXTRAPVAL)
    %
    % date:    26-02-2024
    % author:  R. Waasdorp (r.waasdorp@tudelft.nl)
    % ==============================================================================

    s = size(data);
    s_interp = size(t_interp);

    % check inputs
    assert(s_interp(2) == s(2), 'Number of elements in t_interp must be equal to number of channels in data')
    data_interp = zeros(s_interp(1), s(2));

    for k = 1:s(2)
        data_interp(:, k) = interp1(t, data(:, k), t_interp(:, k), varargin{:});
    end

end
