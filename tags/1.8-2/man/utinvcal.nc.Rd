\name{utinvcal.nc}

\alias{utinvcal.nc}

\title{Convert UTC Referenced Dates Into Temporal Amounts}

\description{Convert a UTC referenced date into a temporal amount.}

\usage{utinvcal.nc(unitstring, value)}

\arguments{
  \item{unitstring}{A temporal unit with an origin (e.g., ``days since 1900-01-01'').}
  \item{value}{Dates to convert as a numeric vector or array, or a vector of strings or POSIXct values.}
}

\value{A vector containing the amount(s) of the temporal unit(s) corresponding to the given date(s).}

\details{Converts a UTC-referenced date and time into the amount, \code{value}, of the temporal unit, \code{unitstring}.
       
The UDUNITS package uses a mixed Gregorian/Julian calendar system. Dates prior to 1582-10-15 are assumed to use the Julian calendar, which was introduced by Julius Caesar in 46 BCE and is based on a year that is exactly 365.25 days long. Dates on and after 1582-10-15 are assumed to use the Gregorian calendar, which was introduced on that date and is based on a year that is exactly 365.2425 days long. (A year is actually approximately 365.242198781 days long.) Seemingly strange behavior of the UDUNITS package can result if a user-given time interval includes the changeover date.

If the dates are given in string form, the structure must be exactly \code{"YYYY-MM-DD hh:mm:ss"}.

A vector of POSIXct values is also accepted as input. These are converted to the specified units by a linear transformation, without an intermediate separation into date components.}

\references{\url{http://www.unidata.ucar.edu/software/udunits/}}

\author{Pavel Michna}

\examples{
##  Convert UTC referenced time to other time units
utinvcal.nc("hours since 1900-01-01 00:00:00 +01:00", c(1900,1,1,5,25,0))
utinvcal.nc("hours since 1900-01-01 00:00:00 +01:00", "1900-01-01 05:25:00")
utinvcal.nc("hours since 1900-01-01 00:00:00 +01:00", ISOdatetime(1900,1,1,5,25,0,tz="UTC"))
}

\keyword{utilities}
