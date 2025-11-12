# Side-Scan-Sonar-Processing-with-TVG-Correction
MATLAB scripts for processing side-scan sonar data, including echo level visualization, time-varied gain (TVG) correction, bottom detection, and cumulative energy analysis.

This repository contains MATLAB scripts for processing side-scan sonar data. The workflow includes loading sonar files, applying time-varied gain (TVG) correction, detecting the seabed, analyzing echo levels, and computing cumulative energy profiles.

## Features

- **TVG Correction**: Compensates for signal attenuation with depth.
- **Bottom Detection**: Identifies the seafloor location for each ping.
- **Energy Integration**: Calculates cumulative energy in the water column and at the bottom.
- **Visualization**: Generates plots of echo levels, bottom depth, and cumulative energy.

## Files

- `L0069SideScan200kHz.mat` – Example sonar data file.
- `process_sonar.m` – Main MATLAB script for data processing (translated to English).

## Dependencies

- MATLAB R2018b or later (should work in older versions as well).
- Signal Processing Toolbox (for Hilbert transform).

## Usage

1. Place your `.mat` sonar file in the same directory as the script.
2. Open `process_sonar.m` in MATLAB.
3. Run the script to visualize:
   - Echograms before and after TVG correction
   - Detected bottom depth
   - Cumulative energy profiles

## Plots Generated

1. **Echogram**: Raw and TVG-corrected echo levels.
2. **Bottom Depth**: Depth of the seabed for each ping.
3. **Cumulative Energy**: Normalized cumulative energy in the water column.
4. **Bottom Energy Waveform**: Hilbert-transformed energy at the seabed.
5. **Example Ping Analysis**: Echo level and cumulative energy for a single ping.

## Author

[Your Name] – [Optional contact or link]

## License

This project is licensed under the MIT License.

