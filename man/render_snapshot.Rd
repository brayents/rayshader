% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/render_snapshot.R
\name{render_snapshot}
\alias{render_snapshot}
\title{Render Snapshot of 3D Visualization}
\usage{
render_snapshot(filename)
}
\arguments{
\item{filename}{Filename of snapshot. If missing, will display to current device.}
}
\value{
Displays snapshot of current rgl plot (or saves to disk).
}
\description{
Either captures the current rgl view and displays, or saves the current view to disk.
}
\examples{
\dontrun{
montereybay \%>\%
 sphere_shade() \%>\%
 plot_3d(montereybay,zscale=50,zoom=0.6,theta=-90)
}
 
\dontrun{
render_snapshot()
rgl::rgl.clear()
}
}
