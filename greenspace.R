#!/usr/local/bin/Rscript

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(sp))    #required for raster package
suppressPackageStartupMessages(library(raster))
suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(dplyr))

doc <- '
Usage:
  greenspace.R <filename>
'

opt <- docopt::docopt(doc)

message('\reading input file...')
raw_data <- readr::read_csv(opt$filename)
# raw_data <- read_csv("./my_address_file_geocoded.csv")

## prepare data for calculations
raw_data$.row <- seq_len(nrow(raw_data))

d <-
  raw_data %>%
  dplyr::select(.row, lat, lon) %>%
  na.omit() %>%
  group_by(lat, lon) %>%
  tidyr::nest(.rows = c(.row)) %>%
  st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
  st_transform(5072)

### raster file is on GRAPPH Sharepoint site in __greenspace folder
message('\nloading greenspace raster file...')
evi_2018 <- raster::raster("/app/evi_June_2018_5072.tif")
# evi_2018 <- raster::raster("./evi_June_2018_5072.tif")

message('\nfinding greenspace for each point...')
message('\nusing 500 m buffer...')
evi_buf_500 <- raster::extract(evi_2018,
                               d,
                               buffer = 500,
                               fun = mean,
                               na.rm = TRUE,
                               small = TRUE,
                               df = TRUE)

message('\nusing 1500 m buffer...')
evi_buf_1500 <- raster::extract(evi_2018,
                               d,
                               buffer = 1500,
                               fun = mean,
                               na.rm = TRUE,
                               small = TRUE,
                               df = TRUE)

message('\nusing 2500 m buffer...')
evi_buf_2500 <- raster::extract(evi_2018,
                               d,
                               buffer = 2500,
                               fun = mean,
                               na.rm = TRUE,
                               small = TRUE,
                               df = TRUE)

d <- d %>%
  mutate(evi_500 = evi_buf_500$evi_June_2018_5072 * 0.0001,
         evi_1500 = evi_buf_1500$evi_June_2018_5072 * 0.0001,
         evi_2500 = evi_buf_2500$evi_June_2018_5072 * 0.0001)


## merge back on .row after unnesting .rows into .row
d <- d %>%
  tidyr::unnest(cols = c(.rows)) %>%
  st_drop_geometry()

out <- left_join(raw_data, d, by = '.row') %>% dplyr::select(-.row)

out_file_name <- paste0(tools::file_path_sans_ext(opt$filename), '_greenspace.csv')
readr::write_csv(out, out_file_name)
message('\nFINISHED! output written to ', out_file_name)
