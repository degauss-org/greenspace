# degauss/pepr_greenspace

> DeGAUSS container that calculates average greenness within 500 m, 1500 m, and 2500 m buffers for PEPR multi-site study

![](figs/evi_us.png)

## Using

DeGAUSS arguments specific to this container:

- `file_name`: name of a CSV file in the current working directory with columns named `lat` and `lon`

Example call (that will work with example file included in repository):

```
docker run --rm -v "$PWD":/tmp docker.pkg.github.com/cole-brokamp/pepr_greenspace:0.2 my_address_file_geocoded.csv
```

In the above example call, replace `geocoded_csv_file.csv` with the name of your geocoded csv file.

Some progress messages will be printed and when complete, the program will save the output as the same name as the input file name, but with `pepr_greenspace` appended, e.g. `geocoded_csv_file_pepr_greenspace_cchmc.csv`

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS](https://github.com/cole-brokamp/DeGAUSS) README.

This software is part of DeGAUSS and uses its same [license](https://github.com/cole-brokamp/DeGAUSS/blob/master/LICENSE.txt).