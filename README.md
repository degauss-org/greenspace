# degauss/pepr_greenspace

> DeGAUSS container that calculates average greenness within 500 m, 1500 m, and 2500 m buffers for PEPR multi-site study

![](figs/evi_us.png)

## Using

DeGAUSS arguments specific to this container:

- `file_name`: name of a CSV file in the current working directory with columns named `lat` and `lon`

Example call (that will work with example file included in repository):

**MacOS**

```
docker run --rm -v "$PWD":/tmp docker.pkg.github.com/cole-brokamp/pepr_greenspace:0.2 my_address_file_geocoded.csv
```

**Microsoft Windows**

```
docker run --rm -v "%cd%":/tmp docker.pkg.github.com/cole-brokamp/pepr_greenspace:0.2 my_address_file_geocoded.csv
```

In the above example call, replace `my_address_file_geocoded.csv` with the name of your geocoded csv file.

Some progress messages will be printed and when complete, the program will save the output as the same name as the input file name, but with `pepr_greenspace` appended, e.g. `my_address_file_geocoded_pepr_greenspace.csv`

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS](https://github.com/cole-brokamp/DeGAUSS) README.

This software is part of DeGAUSS and uses its same [license](https://github.com/cole-brokamp/DeGAUSS/blob/master/LICENSE.txt).