#!/usr/local/bin/Rscript

# automagic::make_deps_file(directory=getwd())

suppressPackageStartupMessages(library(argparser))
p <- arg_parser('return greenspace for geocoded CSV file')
p <- add_argument(p, 'file_name', help = 'name of geocoded csv file')
args <- parse_args(p)

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(sp))    #required for raster package
suppressPackageStartupMessages(library(raster))
suppressPackageStartupMessages(library(sf))


message('\nloading and projecting input file...')
raw_data <- suppressMessages(read_csv(args$file_name))
# raw_data <- supressMessages(read_csv("./my_address_file_geocoded.csv"))
d_cc <- complete.cases(raw_data[ , c('lat','lon')])

if (! all(d_cc)) {
  message('\nWARNING: input file contains ', sum(!d_cc), ' rows with missing coordinates.')
  message('\nWill return NA for all greenspace measures for these rows.')
}

d <- raw_data[d_cc, ]

# store coords as separate numeric columns because
# trans and back trans lead to rounding errors, making them unsuitable for merging
d$old_lat <- d$lat
d$old_lon <- d$lon

d <- d %>%
  st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
  st_transform(5072)

### raster file is on GRAPPH Sharepoint site in __greenspace folder
message('\nloading greenspace raster file...')
evi_2018 <- raster::raster("evi_June_2018_5072.tif")

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

# remove transformed coords and add back "old" coords
d <- d %>%
  st_set_geometry(NULL) %>%
  rename(lon = old_lon,
         lat = old_lat)

# add back in original missing coords data for output file
out_file <- suppressWarnings(bind_rows(raw_data[!d_cc, ], d))

out_file_name <- paste0(tools::file_path_sans_ext(args$file_name), '_pepr_greenspace.csv')

write_csv(out_file, out_file_name)

message('\nFINISHED! output written to ', out_file_name)
