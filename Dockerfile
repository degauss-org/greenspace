FROM rocker/r-ver:3.6.1

# DeGAUSS container metadata
ENV degauss_name="greenspace"
ENV degauss_version="0.2"
ENV degauss_description="enhanced vegetation index"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

# install a newer-ish version of renv, but the specific version we want will be restored from the renv lockfile
ENV RENV_VERSION 0.8.3-81
RUN R --quiet -e "source('https://install-github.me/rstudio/renv@${RENV_VERSION}')"

WORKDIR /app

RUN apt-get update \
&& apt-get install -yqq --no-install-recommends \
libgdal-dev=2.1.2+dfsg-5 \
libgeos-dev=3.5.1-3 \
libudunits2-dev=2.2.20-1+b1 \
libproj-dev=4.9.3-1 \
&& apt-get clean

COPY renv.lock .
RUN R --quiet -e "renv::restore()"

COPY evi_June_2018_5072.tif .
COPY greenspace.R .

WORKDIR /tmp

ENTRYPOINT ["/app/greenspace.R"]
