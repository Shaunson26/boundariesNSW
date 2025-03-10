
<!-- README.md is generated from README.Rmd. Please edit that file -->

# boundariesNSW <img src='man/figures/logo.png' align="right" height="139" />

<!-- badges: start -->

![GitHub R package
version](https://img.shields.io/github/r-package/v/shaunson26/boundariesNSW)
[![check-standard](https://github.com/Shaunson26/boundariesNSW/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/Shaunson26/boundariesNSW/actions/workflows/check-standard.yaml)
<!-- badges: end -->

The goal of boundariesNSW is to simplify the acquisition and use of NSW
boundary shapefiles, including simplification for simple plotting tasks.

The package has simply obtained various shapefiles, simplified spatial
objects (remove unnecessary fields), converted to geojson, and created
helper functions to import them into your R environment, or export them
to a chosen directory.

The package also provide the workflows used to generate these files from
the source locations they were obtained from:

> Sources  
> [maps.abs.gov.au/index.html](https://maps.abs.gov.au/index.html)  
> [abs.gov.au/statistics/standards/…](https://www.abs.gov.au/statistics/standards/australian-statistical-geography-standard-asgs-edition-3/jul2021-jun2026/access-and-downloads/digital-boundary-files)

There are now 2021 shapefiles available from ABS! They are not included
here as this package was created for other work purposes.

Current shape files:

- Local Government Area 2016 - `lga2016-geojson.gzip`  
- Local Government Area 2019 - `lga2019-geojson.gzip`  
- Local Health District 2010 - `lhd2010-geojson.gzip`  
- Postal Areas 2016 - `poa2016-geojson.gzip`
- Greater Capital City Statistical Area 2016; `gccsa2016-geojson.gzip`

These generally have boundary codes and names to join with other data.

## Installation

``` r
devtools::install_github("Shaunson26/boundariesNSW")
```

``` r
library(boundariesNSW)
```

## Usage

### bnsw_list_maps()

The geojsons are stored in the `extdata/` folder of the package
installation directory. We can list them with the function
`bnsw_list_maps()`. This function is just a wrapper for `list.files()`
and we can use the `full.names = TRUE` to list the full file path if
required. However, the next function `bnsw_get_map()` will handle
extraction and importing.

``` r
bnsw_list_maps(full.names = FALSE)
#> [1] "gccsa2016-geojson.gzip" "gccsa2021-geojson.gzip" "lga2016-geojson.gzip"  
#> [4] "lga2019-geojson.gzip"   "lhd2010-geojson.gzip"   "poa2016-geojson.gzip"
```

### bnsw_get_map()

`bnsw_get_map()` imports a chosen boundary into your R environment as an
`sf` object.

``` r
# Import LGA2019 into R
# * return_sf_object = TRUE is default
lga2019 <- bnsw_get_map(boundary = 'lga2019', return_sf_object = TRUE)
#> lga2019-geojson.gzip extracted to C:\Users\shaun\AppData\Local\Temp\RtmpSKzaA3
#> Reading layer `lga2019' from data source 
#>   `C:\Users\shaun\AppData\Local\Temp\RtmpSKzaA3\lga2019_boundaries.geojson' 
#>   using driver `GeoJSON'
#> Simple feature collection with 129 features and 2 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 140.9993 ymin: -37.5051 xmax: 153.6387 ymax: -28.157
#> Geodetic CRS:  GDA94
```

`bnsw_get_map()` has the option of just exporting the map to a chosen
directory. In this example, the geojson is extracted to the given
location and not imported to R.

``` r
bnsw_get_map(boundary = 'lga2019', geojson_extract_location = 'C:/temp', return_sf_object = FALSE)
#> lga2019-geojson.gzip extracted to C:/temp
```

### simplify_map

The default maps are often of too high resolution for regular tasks and
take time to plot. We can simplify the maps using `bnsw_simplify_map()`.
This is just a wrapper to the
`rmapshaper::ms_simplify(keep_proportion = 0.1, keep_shapes = TRUE)`.
You will find that plotting is faster, and that boundaries are less
fuzzy when you do this.

``` r
library(ggplot2)

ggplot(lga2019) +
  geom_sf() +
  theme_void()
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r

lga2019_min <- bnsw_simplify_map(lga2019, keep_proportion = 0.25)

# Notice clearer boundaries
ggplot(lga2019_min) +
  geom_sf() +
  theme_void()
```

<img src="man/figures/README-unnamed-chunk-8-2.png" width="100%" />

## Boundary metadata

Sometimes we may just want the IDs of the polygons in a shapefile. You
will find these as datasets `bnsw_{boundary}_code_names`

``` r
head(bnsw_lga2019_code_names)
#>   LGA_CODE19        LGA_NAME19
#> 1      10050            Albury
#> 2      10130 Armidale Regional
#> 3      10250           Ballina
#> 4      10300         Balranald
#> 5      10470 Bathurst Regional
#> 6      10500           Bayside
head(bnsw_lga2016_code_names)
#>   LGA_CODE16        LGA_NAME16
#> 1      10050            Albury
#> 2      10130 Armidale Regional
#> 3      10250           Ballina
#> 4      10300         Balranald
#> 5      10470 Bathurst Regional
#> 6      10550       Bega Valley
```

## Data aquisition

Scripts in `data-raw/` detail how each boundary was obtained. They use a
list object `bnsw_download_urls` that provides the URLs of the source
boundary archive.

    1. Download zip
    2. Extract
    3. Import SHP file
    4. Filter NSW and select relevant columns
    5. Output geojson file
    6. Compress geojson and copy zip to inst/extdata
