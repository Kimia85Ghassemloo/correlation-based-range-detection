function noisySignal = MakeSignalNoisy(signal, sigma, stream)
%MAKESIGNALNOISY Add zero-mean white Gaussian noise to a real signal.
%   NOISYSIGNAL = MAKESIGNALNOISY(SIGNAL, SIGMA) preserves the size of
%   SIGNAL and uses SIGMA as the noise standard deviation.
%
%   NOISYSIGNAL = MAKESIGNALNOISY(SIGNAL, SIGMA, STREAM) uses the supplied
%   RandStream, which is useful for deterministic simulations and tests.

    arguments
        signal double {mustBeReal, mustBeFinite}
        sigma (1,1) double {mustBeNonnegative, mustBeFinite}
        stream (1,1) RandStream = RandStream.getGlobalStream
    end

    noisySignal = signal + sigma .* randn(stream, size(signal));
end
