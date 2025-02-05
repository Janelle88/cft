
test_that("A full run of cftdata completes and saves an expected file", {
  aoi <- rgdal::readOGR(system.file("extdata", "windcave.geojson", package = "cft"))
  file_refs <- cftdata(aoi = aoi,
                       area_name = "test",
                       parameters = "tasmax",
                       years = c(2020, 2021), 
                       models = "CCSM4", 
                       scenarios = "rcp85")

  expect_true(file.exists(file_refs$local_path))
})

test_that("A cftdata run on a one pixel park completes successfully", {
  aoi <- rgdal::readOGR(system.file("extdata", "wolftrap.geojson", package = "cft"))
  file_refs <- cftdata(aoi = aoi, 
                       area_name = "wolftrap",
                       parameters = "tasmax",
                       years = c(2000, 2001), 
                       models = "CCSM4", 
                       scenarios = "rcp85")
  expect_true(file.exists(file_refs$local_path))
})

test_that("A cftdata run with a point aoi works", {
  pt <- sp::SpatialPointsDataFrame(
    coords = data.frame(lon = -77, lat = 39), 
    data = data.frame(id = 1), 
    proj4string = sp::CRS("+proj=longlat +datum=WGS84"))

  file_refs <- cftdata(aoi = pt, 
                       area_name = "wolftrap",
                       parameters = "tasmax",
                       years = c(2000, 2001), 
                       models = "CCSM4", 
                       scenarios = "rcp85")
  expect_true(file.exists(file_refs$local_path))
})

test_that("AOI is in CFT data range", {
  pt <- sp::SpatialPointsDataFrame(
    coords = data.frame(lon = -77, lat = 39), 
    data = data.frame(id = 1), 
    proj4string = sp::CRS("+proj=longlat +datum=WGS84"))
  
  file_refs <- cftdata(aoi = pt, 
                       area_name = "wolftrap",
                       parameters = "tasmax",
                       years = c(2000, 2001), 
                       models = "CCSM4", 
                       scenarios = "rcp85")
  
  test <- raster::raster(file_refs$local_path)
  test_extent_matrix <- rbind(c(round(test@extent@xmin), round(test@extent@xmax)), 
                                c(round(test@extent@ymin), round(test@extent@ymax)))
  
  expect_true(length(which(pt@bbox != test_extent_matrix)) == 0)
})
