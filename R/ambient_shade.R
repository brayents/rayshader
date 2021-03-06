#'@title Calculate Ambient Occlusion Map
#'
#'@description Calculates Ambient Occlusion Shadow Map
#'
#'@param heightmap  A two-dimensional matrix, where each entry in the matrix is the elevation at that point. All points are assumed to be evenly spaced.
#'@param anglebreaks The angle(s), in degrees, as measured from the horizon from which the light originates.
#'@param sunbreaks Default 12. Number of rays to be sent out in a circle, evenly spaced, around the point being tested.
#'@param maxsearch Default `20`. The maximum horizontal distance that the system should propogate rays to check for surface intersections. 
#'@param multicore Default FALSE. If TRUE, multiple cores will be used to compute the shadow matrix. By default, this uses all cores available, unless the user has
#'set `options("cores")` in which the multicore option will only use that many cores.
#'@param zscale Default 1. The ratio between the x and y spacing (which are assumed to be equal) and the z axis. 
#'@param cache_mask Default `NULL`. A matrix of 1 and 0s, indicating which points on which the raytracer will operate.
#'@param shadow_cache Default `NULL`. The shadow matrix to be updated at the points defined by the argument `cache_mask`.
#'@param progbar Default `TRUE` if interactive, `FALSE` otherwise. If `FALSE`, turns off progress bar.
#'@param ... Additional arguments to pass to the `makeCluster` function when `multicore=TRUE`.
#'@return Shaded texture map.
#'@export
#'@examples
#'#Here we produce a ambient occlusion map of the `montereybay` elevation map.
#'\dontrun{
#'amb = ambient_shade(heightmap = montereybay)
#'plot_map(amb)
#'}
#'
#'#We can increase the distance to look for surface intersections `maxsearch`
#'#and the density of rays sent out around the point `sunbreaks`.
#'\dontrun{
#'amb = ambient_shade(heightmap = montereybay,sunbreaks=24,maxsearch=50)
#'plot_map(amb)
#'}
ambient_shade = function(heightmap, anglebreaks = seq(1,46,15), sunbreaks = 12, 
                        maxsearch=20,
                        multicore=FALSE, zscale=1, cache_mask = NULL, 
                        shadow_cache=NULL, progbar=interactive(), ...) {
  if(sunbreaks < 3) {
    stop("sunbreaks needs to be at least 3")
  }
  shademat = matrix(0,nrow=nrow(heightmap),ncol = ncol(heightmap))
  for(angle in seq(0,360,length.out = sunbreaks+1)[-(sunbreaks+1)]) {
    shademat = shademat + ray_shade(heightmap,anglebreaks=anglebreaks,sunangle = angle, 
                                    maxsearch = maxsearch, zscale=zscale,
                                    multicore=multicore, lambert=FALSE, 
                                    cache_mask = cache_mask, progbar = progbar, ...)^2.2
  }
  shademat = shademat/sunbreaks
  shademat = shademat ^ (1/2.2)
  if(!is.null(shadow_cache)) {
    cache_mask = (cache_mask)
    shadow_cache[cache_mask == 1] = shademat[cache_mask == 1]
    shademat = matrix(shadow_cache,nrow=nrow(shademat),ncol=ncol(shademat))
  }
  return(shademat)
}