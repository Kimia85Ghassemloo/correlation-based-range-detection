# Correlation-Based Range Detection

[![MATLAB](https://img.shields.io/badge/MATLAB-R2024b-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A compact radar-ranging simulation that estimates target distance from the
round-trip delay of a reflected rectangular pulse. The detector uses normalized
sliding correlation (template matching), followed by the standard time-of-flight
relationship

\[
R = \frac{c\,t_d}{2}.
\]

The repository includes a reproducible Monte Carlo experiment for measuring
range error as the received signal becomes increasingly noisy.

## Features

- Toolbox-free MATLAB implementation of normalized template matching
- Robust handling of zero-energy windows (no `NaN` correlation values)
- Configurable sample time, pulse width, and propagation speed
- Reproducible Gaussian-noise simulations
- MATLAB unit tests and GitHub Actions continuous integration
- An early noise-sensitivity experiment retained for comparison

## Quick start

Requires MATLAB R2021a or newer. The repository is tested with R2024b.

```matlab
results = runRangeDetectionDemo();
```

For direct use with a row-vector signal:

```matlab
[distanceMeters, correlation, delaySeconds] = GetDistance(receivedSignal);
```

Run the test suite with:

```matlab
results = runtests("tests");
assertSuccess(results);
```

## Method

1. Generate a rectangular transmit pulse of width `tau`.
2. Model the received echo as an attenuated, delayed copy of that pulse.
3. Slide the known pulse template over the received samples.
4. Normalize each correlation value by the energy of the template and window.
5. Convert the peak location to round-trip delay, then to target range.
6. Repeat the experiment with Gaussian noise and report mean absolute error.

The default scenario uses a 1 ns sample interval, a 1 us pulse, a propagation
speed of 3e8 m/s, and a target at 450 m.

## Repository layout

```text
.
|-- GetDistance.m             # Core range estimator
|-- MakeSignalNoisy.m         # Gaussian-noise model
|-- CalcMeanError.m           # Monte Carlo error analysis
|-- runRangeDetectionDemo.m   # End-to-end example and plots
|-- tests/                    # Automated MATLAB tests
`-- p3_4.m                    # Early noise-sensitivity experiment
```

## Model assumptions

- A single stationary point target and one ideal echo
- Known rectangular pulse shape
- Constant propagation speed
- Additive, independent, zero-mean Gaussian noise
- No clutter, multipath, Doppler shift, or fractional-sample delay

These assumptions make the project suitable as a clear reference implementation.
Real radar processing would typically add detection thresholds, interpolation,
clutter suppression, and a calibrated channel model.

## Contributing

Bug reports and focused pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md)
for the local verification steps.

## License

Distributed under the MIT License. See [LICENSE](LICENSE).
