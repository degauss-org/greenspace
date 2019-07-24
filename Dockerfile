FROM rocker/geospatial:3.6.0

LABEL maintainer="Cole Brokamp <cole.brokamp@gmail.com>"

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), prompt='R > ', download.file.method = 'libcurl')" > /.Rprofile

RUN R -e "devtools::install_version(package = 'argparser', version = '0.4', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'dplyr', version = '0.8.1', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'readr', version = '1.3.1', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'sp', version = '1.3-1', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'raster', version = '2.9-5', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'sf', version = '0.7-4', upgrade = FALSE, quiet = TRUE)"

RUN R -e "library(argparser); library(dplyr); library(readr); library(sp); library(raster); library(sf)"

RUN mkdir /app
COPY . /app

WORKDIR /tmp

RUN chmod +x /app/_get_pepr_greenspace.R
ENTRYPOINT ["/app/_get_pepr_greenspace.R"]