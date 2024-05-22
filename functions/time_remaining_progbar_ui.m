function time_remaining_progbar_ui(iteration, number_iterations, report_every_iterations)
    % Compute and display the time remaining for an iteration process.
    %
    % The function takes two arguments:
    %   iteration:                  the current iteration number
    %   number_iterations:          total number of iterations
    %   report_every_iterations:    report progress every n iterations
    %
    % Description
    %   The function displays the progress of the iteration process as
    %   a percentage and the estimated time remaining. The time remaining
    %   calculation is based on the average time per iteration, which is
    %   computed as the ratio of the elapsed time to the current iteration
    %   number. The elapsed time is determined using the MATLAB built-in
    %   function 'tic' and 'toc'. If the 'iteration' argument is equal to 0, the
    %   timer is initialized. The time remaining is formatted as a string with
    %   the format 'hh:mm:ss'.
    %
    % Example
    %   N = 10;
    %   time_remaining(0, N);
    %   for k = 1:N
    %       pause(1)
    %       time_remaining(k, N);
    %   end
    %
    % date:    30-01-2023
    % author:  R. Waasdorp (r.waasdorp@tudelft.nl)
    % ==============================================================================

    persistent start_time fbar
    if isempty(start_time) || iteration == 0
        start_time = tic;
        return;
    end

    if ~exist('report_every_iterations', 'var') || isempty(report_every_iterations)
        report_every_iterations = 1;
    end

    time_elapsed = toc(start_time);
    time_per_iteration = time_elapsed / iteration;

    time_remaining = (number_iterations - iteration) * time_per_iteration;

    if mod(iteration, report_every_iterations) == 0
        progress = iteration / number_iterations;
        if isempty(fbar) || ~isgraphics(fbar)
            fbar = waitbar(progress, sprintf('%.2f %% - Time remaining: %s', progress * 100, format_time_seconds(time_remaining)));
        else
            waitbar(progress, fbar, sprintf('%.2f %% - Time remaining: %s', progress * 100, format_time_seconds(time_remaining)));
        end
    end
    % cleanup progressbar
    if iteration == number_iterations; close(fbar); end
end

function str = format_time_seconds(time_in_seconds)
    hours = floor(time_in_seconds / 3600);
    minutes = floor(mod(time_in_seconds, 3600) / 60);
    seconds = mod(time_in_seconds, 60);
    str = sprintf('%02d:%02d:%02d', hours, minutes, round(seconds));
end
