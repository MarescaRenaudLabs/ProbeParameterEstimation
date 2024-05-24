# ProbeParameterEstimation

Code and data accompanying the paper: "Assessing Transducer Parameters for
accurate medium sound speed estimation and image reconstruction" 

Example data of internal lens reflections for the L12-3v and L6-24D can be
found in the data folder. See the files `example_L6_24D.m` and `example_L12_3v.m`
for a demo on how to find the probe parameters.

Brief function description 

| Name                  | Description                                                                                                                                                                                                     |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `preprocessRFData`    | Preprocesses the RFData, will bandpass filter the data (optional), apply time gain compensation (optional), average the shot data and Hilbert transform the data.                                               |
| `previewRFData`       | Shows a preview of the RFData, and show whether the parameters `min_round_trip` and `max_round_trip`  are setup correctly. The first arrival of the primary reflection should be between the red plotted lines. |
| `findProbeParameters` | Runs the parameter search. Depending on your system specs this can take some time.                                                                                                                              |
| `plotProbeParameters` | Plots the final result.                                                                                                                                                                                         |
