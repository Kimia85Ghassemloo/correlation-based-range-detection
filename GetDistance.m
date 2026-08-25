function [distanceMeters, correlation, delaySeconds] = GetDistance(signal, options)
%GETDISTANCE Estimate target range by normalized template matching.
%   DISTANCE = GETDISTANCE(SIGNAL) correlates SIGNAL with a rectangular
%   transmit pulse and converts the detected round-trip delay into meters.
%
%   [DISTANCE, CORRELATION, DELAY] = GETDISTANCE(SIGNAL, OPTIONS) accepts:
%     options.SampleTime       - sampling interval in seconds (default 1e-9)
%     options.PulseWidth       - pulse width in seconds (default 1e-6)
%     options.PropagationSpeed - wave speed in m/s (default 3e8)

%   The implementation uses a normalized sliding correlation and explicitly
%   handles zero-energy windows, so noise-free leading/trailing regions do
%   not produce NaN values.

%   See also MAKESIGNALNOISY, CALCMEANERROR.

    arguments
        signal (1,:) double {mustBeReal, mustBeFinite}
        options.SampleTime (1,1) double {mustBePositive} = 1e-9
        options.PulseWidth (1,1) double {mustBePositive} = 1e-6
        options.PropagationSpeed (1,1) double {mustBePositive} = 3e8
    end

    pulseSamples = round(options.PulseWidth / options.SampleTime) + 1;
    if numel(signal) < pulseSamples
        error('RangeDetection:SignalTooShort', ...
            'Signal must contain at least %d samples.', pulseSamples);
    end

    template = ones(1, pulseSamples);
    numerator = conv(signal, fliplr(template), 'valid');
    windowEnergy = conv(signal.^2, ones(1, pulseSamples), 'valid');
    denominator = sqrt(windowEnergy) * norm(template);

    validCorrelation = zeros(size(numerator));
    nonzeroEnergy = denominator > eps(class(denominator));
    validCorrelation(nonzeroEnergy) = ...
        numerator(nonzeroEnergy) ./ denominator(nonzeroEnergy);

    correlation = zeros(size(signal));
    correlation(1:numel(validCorrelation)) = validCorrelation;

    [~, peakIndex] = max(validCorrelation);
    delaySeconds = (peakIndex - 1) * options.SampleTime;
    distanceMeters = options.PropagationSpeed * delaySeconds / 2;
end
