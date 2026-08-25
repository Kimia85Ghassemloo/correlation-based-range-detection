function results = runRangeDetectionDemo()
%RUNRANGEDETECTIONDEMO Demonstrate correlation-based radar ranging.

    sampleTime = 1e-9;
    duration = 1e-5;
    pulseWidth = 1e-6;
    propagationSpeed = 3e8;
    trueDistance = 450;
    attenuation = 0.1;

    time = 0:sampleTime:duration;
    pulseSamples = round(pulseWidth / sampleTime) + 1;
    delaySeconds = 2 * trueDistance / propagationSpeed;
    delaySamples = round(delaySeconds / sampleTime);

    transmitted = zeros(size(time));
    transmitted(1:pulseSamples) = 1;

    received = zeros(size(time));
    firstEchoSample = delaySamples + 1;
    echoIndices = firstEchoSample:(firstEchoSample + pulseSamples - 1);
    received(echoIndices) = attenuation;

    [estimatedDistance, correlation] = GetDistance(received);

    noiseLevels = 0:0.1:1;
    meanAbsoluteError = zeros(size(noiseLevels));
    for index = 1:numel(noiseLevels)
        meanAbsoluteError(index) = CalcMeanError(noiseLevels(index), received);
    end

    figure('Name', 'Correlation-Based Range Detection');
    tiledlayout(2, 2, 'TileSpacing', 'compact');
    nexttile; plot(time, transmitted); grid on;
    title('Transmitted pulse'); xlabel('Time (s)'); ylabel('Amplitude');
    nexttile; plot(time, received); grid on;
    title('Received echo'); xlabel('Time (s)'); ylabel('Amplitude');
    nexttile; plot(time, correlation); grid on;
    title(sprintf('Correlation (estimated range: %.2f m)', estimatedDistance));
    xlabel('Time (s)'); ylabel('Normalized correlation');
    nexttile; plot(noiseLevels, meanAbsoluteError, 'o-', 'LineWidth', 1.2); grid on;
    title('Noise sensitivity'); xlabel('Noise standard deviation');
    ylabel('Mean absolute error (m)');

    results = table(trueDistance, estimatedDistance, ...
        'VariableNames', {'TrueDistanceMeters', 'EstimatedDistanceMeters'});
    disp(results);
end
