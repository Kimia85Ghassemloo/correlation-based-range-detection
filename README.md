# Correlation-Based Range Detection

[![MATLAB R2024b](https://img.shields.io/badge/MATLAB-R2024b-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![MATLAB tests](https://github.com/Kimia85Ghassemloo/correlation-based-range-detection/actions/workflows/matlab-tests.yml/badge.svg)](https://github.com/Kimia85Ghassemloo/correlation-based-range-detection/actions/workflows/matlab-tests.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> A MATLAB reference implementation of pulse-radar range estimation using
> normalized cross-correlation and time-of-flight measurement.

This repository simulates a single-target pulsed-radar experiment. An attenuated,
delayed rectangular echo is detected with a known transmit-pulse template, and
the peak delay is converted to range using

\[
R = \frac{c\,t_d}{2}.
\]

The implementation includes a reproducible Monte Carlo study that quantifies
how additive Gaussian noise affects range-estimation accuracy.

## Highlights

- **Toolbox-free** normalized template matching in MATLAB
- **Numerically safe** correlation for zero-energy signal windows
- **Configurable** sample time, pulse width, and propagation speed
- **Reproducible** noise experiments with seeded random-number generation
- **Automated tests** executed by GitHub Actions
- **Clear scope:** a focused reference model rather than an overextended radar simulator

## Quick start

### Requirements

- MATLAB R2021a or newer
- No additional toolboxes

Clone the repository, open MATLAB in the project directory, and run:

```matlab
results = runRangeDetectionDemo();
```

The demo generates four plots: transmitted pulse, received echo, normalized
correlation, and mean absolute range error versus noise level.

## Usage

### Estimate a target range

`GetDistance` accepts a real row-vector received signal and returns the estimated
range, full correlation trace, and peak delay.

```matlab
[distanceMeters, correlation, delaySeconds] = GetDistance(receivedSignal);
```

Its physical parameters can be adjusted without modifying the source code:

```matlab
distanceMeters = GetDistance(receivedSignal, ...
    SampleTime=1e-9, ...
    PulseWidth=1e-6, ...
    PropagationSpeed=3e8);
```

### Evaluate noise sensitivity

`CalcMeanError` runs repeated noisy trials and returns mean absolute range error.

```matlab
[meanError, errors] = CalcMeanError(0.15, receivedSignal, ...
    TrueDistance=450, NumTrials=100, RandomSeed=42);
```

## Default scenario

| Parameter | Value |
| --- | ---: |
| Target range | 450 m |
| Sample interval | 1 ns |
| Observation duration | 10 us |
| Pulse width | 1 us |
| Propagation speed | 3e8 m/s |
| Echo amplitude | 0.1 |

At the default range, the round-trip delay is 3 us.

## Detection pipeline

```text
Transmit pulse -> delayed/attenuated echo -> optional AWGN
      -> normalized sliding correlation -> peak delay -> range estimate
```

For a received signal \(y[n]\) and rectangular template \(p[n]\), the detector
evaluates a normalized correlation score across each valid window. Normalization
prevents correlation magnitude from being driven only by local signal energy;
zero-energy windows are assigned a score of zero.

## Repository layout

```text
.
|-- GetDistance.m             # Public range-estimation API
|-- MakeSignalNoisy.m         # Additive white Gaussian-noise model
|-- CalcMeanError.m           # Reproducible Monte Carlo analysis
|-- runRangeDetectionDemo.m   # End-to-end simulation and visualisation
|-- runNoiseRobustnessExperiment.m # Exploratory noise-sensitivity script
|-- tests/
|   `-- testRangeDetection.m  # MATLAB unit tests
`-- .github/workflows/
    `-- matlab-tests.yml      # Continuous-integration workflow
```

## Testing

Run the complete test suite from the repository root:

```matlab
results = runtests("tests");
assertSuccess(results);
```

The test suite covers the noise-free range estimate, zero-energy correlation
handling, zero-noise signal preservation, and reproducibility of the Monte Carlo
simulation. The same tests run automatically on pushes and pull requests via
GitHub Actions.

## Model assumptions and limitations

This is intentionally a compact single-target reference model. It assumes:

- one stationary point target;
- a known rectangular transmit pulse;
- a constant propagation speed;
- additive, independent, zero-mean Gaussian noise; and
- integer-sample delay.

It does not model clutter, multipath, Doppler, target radar-cross-section
variation, fractional-sample delay, or detection thresholds. Those are natural
next steps for a higher-fidelity radar-processing chain.

## Contributing

Contributions are welcome. Please keep changes focused, document public MATLAB
functions, add tests for behavior changes, and run `runtests("tests")` before
opening a pull request. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Citation

If you use this project in academic work, use the citation metadata provided in
[CITATION.cff](CITATION.cff).

## License

This project is distributed under the [MIT License](LICENSE).
