# ProbeParameterEstimation

Code and data accompanying the paper: "Assessing Transducer Parameters for Accurate Medium Sound Speed Estimation and Image Reconstruction" (DOI: [10.1109/TUFFC.2024.3445131](https://doi.org/10.1109/TUFFC.2024.3445131))

Example data of internal lens reflections for the L12-3v and L6-24D can be
found in the data folder. See the files `example_L6_24D.m` and `example_L12_3v.m` for a demo on how to find the probe parameters.

Brief function description 

| Name                  | Description                                                                                                                                                                                                     |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `preprocessRFData`    | Preprocesses the RFData, will bandpass filter the data (optional), apply time gain compensation (optional), average the shot data and Hilbert transform the data.                                               |
| `previewRFData`       | Shows a preview of the RFData, and show whether the parameters `min_round_trip` and `max_round_trip`  are setup correctly. The first arrival of the primary reflection should be between the red plotted lines. |
| `findProbeParameters` | Runs the parameter search. Depending on your system specs this can take some time.                                                                                                                              |
| `plotProbeParameters` | Plots the final result.                                                                                                                                                                                         |
## Licence
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## Cite

R. Waasdorp, D. Maresca and G. Renaud, "Assessing Transducer Parameters for Accurate Medium Sound Speed Estimation and Image Reconstruction," in IEEE Transactions on Ultrasonics, Ferroelectrics, and Frequency Control, doi: 10.1109/TUFFC.2024.3445131. 
