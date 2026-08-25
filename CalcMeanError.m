function [meanError, errors] = CalcMeanError(sigma, signal, options)
%CALCMEANERROR Estimate mean absolute range error using Monte Carlo trials.
%
%   MEANERROR = CALCMEANERROR(SIGMA, SIGNAL) adds zero-mean Gaussian noise
%   with standard deviation SIGMA to SIGNAL over 100 independent trials.
%
%   [MEANERROR, ERRORS] = CALCMEANERROR(..., OPTIONS) accepts:
%     options.TrueDistance - reference distance in meters (default 450)
%     options.NumTrials    - number of trials (default 100)
%     options.RandomSeed   - reproducible random seed (default 42)

    arguments
        sigma (1,1) double {mustBeNonnegative, mustBeFinite}
        signal (1,:) double {mustBeReal, mustBeFinite}
        options.TrueDistance (1,1) double {mustBeNonnegative} = 450
        options.NumTrials (1,1) double {mustBeInteger, mustBePositive} = 100
        options.RandomSeed (1,1) double {mustBeInteger, mustBeNonnegative} = 42
    end

    previousState = rng;
    cleanup = onCleanup(@() rng(previousState));
    rng(options.RandomSeed, 'twister');

    errors = zeros(1, options.NumTrials);
    for trial = 1:options.NumTrials
        noisySignal = MakeSignalNoisy(signal, sigma);
        estimatedDistance = GetDistance(noisySignal);
        errors(trial) = abs(estimatedDistance - options.TrueDistance);
    end
    meanError = mean(errors);
end
