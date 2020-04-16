# degauss/greenspace <a href='https://degauss-org.github.io/DeGAUSS/'><img src='DeGAUSS_hex.png' align="right" height="138.5" /></a>

> DeGAUSS container that calculates average greenness within 500 m, 1500 m, and 2500 m buffers

[![Docker Build Status](https://img.shields.io/docker/automated/degauss/greenspace)](https://hub.docker.com/repository/docker/degauss/greenspace/tags)
[![GitHub Latest Tag](https://img.shields.io/github/v/tag/degauss-org/greenspace)](https://github.com/degauss-org/greenspace/releases)

## DeGAUSS example call

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then

```sh
docker run --rm -v $PWD:/tmp degauss/greenspace:0.2 my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_greenspace.csv` with three added columns named `evi_500`, `evi_1500`, and `evi_2500`.

## geomarker methods

The Enhanced Vegetation Index (EVI) is a measure of greenness that ranges from -0.2 to 1, with higher values corresponding to more vegetation.

A cloud-free composite EVI raster at a resolution of 250 × 250 m was created by assembling individual images collected via remote sensing between June 10 and June 25, 2018.

![](figs/evi_us.png)

Residential greenspace is estimated by averaging EVI values within 500, 1500, and 2500 m of each geocoded address.

## geomarker data

To create the EVI raster, individual tiles were downloaded from the [LP DAAC](https://lpdaac.usgs.gov/) MOD13Q1 product and combined using the [`{MODIS}`](https://github.com/MatMatt/MODIS) R package. Then the raster was clipped and masked to the contiguous United States boundaries.

The raster file needed to build this container can be downloaded [here](https://s3.amazonaws.com/geomarker/greenspace/pepr_evi_June_2018_5072.tif). 

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS README](https://github.com/degauss-org/DeGAUSS).




