function tests = testRangeDetection
%TESTRANGEDETECTION Unit tests for the public ranging functions.
    tests = functiontests(localfunctions);
end

function testNoiseFreeRange(testCase)
    signal = makeEcho(450, 0.1);
    distance = GetDistance(signal);
    verifyEqual(testCase, distance, 450, 'AbsTol', 0.15);
end

function testCorrelationContainsNoNaN(testCase)
    signal = makeEcho(450, 0.1);
    [~, correlation] = GetDistance(signal);
    verifyFalse(testCase, any(isnan(correlation)));
    verifyGreaterThanOrEqual(testCase, max(correlation), 1 - 1e-12);
end

function testZeroNoiseIsIdentity(testCase)
    signal = linspace(-1, 1, 50);
    verifyEqual(testCase, MakeSignalNoisy(signal, 0), signal);
end

function testMonteCarloIsReproducible(testCase)
    signal = makeEcho(450, 0.1);
    first = CalcMeanError(0.05, signal, NumTrials=10, RandomSeed=7);
    second = CalcMeanError(0.05, signal, NumTrials=10, RandomSeed=7);
    verifyEqual(testCase, first, second);
end

function signal = makeEcho(distance, attenuation)
    sampleTime = 1e-9;
    pulseSamples = round(1e-6 / sampleTime) + 1;
    signal = zeros(1, round(1e-5 / sampleTime) + 1);
    delaySamples = round((2 * distance / 3e8) / sampleTime);
    firstEchoSample = delaySamples + 1;
    signal(firstEchoSample:firstEchoSample + pulseSamples - 1) = attenuation;
end
