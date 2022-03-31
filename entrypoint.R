#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))
withr::with_message_sink("/dev/null", library(sf))
withr::with_message_sink("/dev/null", library(terra))

doc <- "
      Usage:
      entrypoint.R <filename>
      "

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

message("reading input file...")
d <- dht::read_lat_lon_csv(opt$filename, nest_df = T, sf = T, project_to_crs = 5072)

dht::check_for_column(d$raw_data, "lat", d$raw_data$lat)
dht::check_for_column(d$raw_data, "lon", d$raw_data$lon)

message("reading EVI raster file...")
evi_2018 <- terra::rast("/app/evi_June_2018_5072.tif")

## add code here to calculate geomarkers
get_evi_buffer <- function(radius) {
  d_buffer <- st_buffer(d$d, dist = radius, nQuadSegs = 100)
  d_vect <- terra::vect(d_buffer)
  
  evi <- terra::extract(evi_2018,
                        d_vect,
                        fun = mean,
                        na.rm = TRUE) 
  
  return(round(evi$evi_June_2018_5072 * 0.0001, 4))
}

message('\nusing 500 m buffer...')
d$d$evi_500 <- get_evi_buffer(500)

message('\nusing 1500 m buffer...')
d$d$evi_1500 <- get_evi_buffer(1500)

message('\nusing 2500 m buffer...')
d$d$evi_2500 <- get_evi_buffer(2500)

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d$d, raw_data = d$raw_data, filename = opt$filename)