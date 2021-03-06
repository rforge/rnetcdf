\name{var.get.nc}

\alias{var.get.nc}

\title{Get a NetCDF Variable}

\description{Read the contents of a NetCDF variable.}

\usage{var.get.nc(ncfile, variable, start=NA, count=NA,
        na.mode=0, collapse=TRUE, unpack=FALSE, rawchar=FALSE, fitnum=FALSE)}

\arguments{
  \item{ncfile}{Object of class "\code{NetCDF}" which points to the NetCDF dataset (as returned from \code{\link[RNetCDF]{open.nc}}).}
  \item{variable}{ID or name of the variable.}
  \item{start}{A vector of indices indicating where to start reading the values (beginning at 1). The length of this vector must equal the number of dimensions the variable has. Order is leftmost varying fastest (as got from \code{\link[RNetCDF]{print.nc}}; opposite to the CDL conventions). If not specified (\code{start=NA}), reading starts at index 1.}
  \item{count}{A vector of integers indicating the count of values to read along each dimension. Order is leftmost varying fastest (as got from \code{\link[RNetCDF]{print.nc}}; opposite to the CDL conventions). The length of this vector must equal the number of dimensions the variable has. If not specified (\code{count=NA}), the entire variable or all values along the corresponding dimension(s) are read.}
  \item{na.mode}{Set the mode for handling missing values (\code{NA}) in numeric variables: 0=accept \code{_FillValue} or \code{missing_value} attribute, 1=accept only \code{_FillValue} attribute, 2=accept only \code{missing_value} attribute, 3=no missing value conversion.}
  \item{collapse}{\code{TRUE} if degenerated dimensions (length=1) should be omitted.}
  \item{unpack}{Packed variables are unpacked if \code{unpack=TRUE} and the attributes \code{add_offset} and \code{scale_factor} are defined. Default is \code{FALSE}.}
  \item{rawchar}{This option only relates to NetCDF variables of type \code{NC_CHAR}. When \code{rawchar} is \code{FALSE} (default), a NetCDF variable of type \code{NC_CHAR} is converted to a \code{character} array in R. The \code{character} values are from the fastest-varying dimension of the NetCDF variable, so that the R \code{character} array has one fewer dimensions than the \code{NC_CHAR} array. If \code{rawchar} is \code{TRUE}, the bytes of \code{NC_CHAR} data are read into an R \code{raw} array of the same shape.}
  \item{fitnum}{By default, all numeric variables are read into R as double precision values. When \code{fitnum==TRUE}, the smallest R type that can exactly represent each external type is used. Types \code{NC_BYTE}, \code{NC_UBYTE}, \code{NC_SHORT}, \code{NC_USHORT} and \code{NC_INT} are read as R integer values, which require half the memory of double precision. \code{NC_UINT} is always read as double precision to avoid integer overflow. Due to the lack of native support for 64-bit integers in R, \code{NC_INT64} and \code{NC_UINT64} are stored as R character vectors in decimal format.}
}

\value{A multidimensional array with a data type that depends on the NetCDF variable. For NetCDF variables of type \code{NC_CHAR}, the R type is either \code{character} or \code{raw}, as specified by argument \code{rawchar}. For \code{NC_STRING}, the R type is \code{character}. Numeric variables are read as double precision by default, but the smallest R type that exactly represents each external type is used if \code{fitnum} is \code{TRUE}.

The dimension order in the R array is reversed relative to the order reported by NetCDF commands such as \code{ncdump}, because NetCDF arrays are stored in row-major (C) order whereas R arrays are stored in column-major (Fortran) order.

Arrays of type \code{character} drop the fastest-varying dimension of the corresponding \code{NC_CHAR} array, because this dimension corresponds to the length of the individual \code{character} elements. For example, an \code{NC_CHAR} array with dimensions (5,10) would be returned as a \code{character} vector containing 5 elements, each with a maximum length of 10 characters.}

\details{This function returns the value of a variable. The conversion between R and NetCDF data types and array dimensions is described in the previous section.

Values of \code{NA} are supported in numeric variables. Values in the data file that match the variable's missing value attribute (as defined in \code{na.mode}) are automatically converted to \code{NA} before being returned to the user. If \code{na.mode=0} and both attributes are defined, the value of \code{_FillValue} is used.

To reduce the storage space required by a NetCDF file, numeric variables are sometimes "packed" into types of lower precision. The original data can be recovered (approximately) by multiplication of the stored values by attribute \code{scale_factor} followed by addition of attribute \code{add_offset}. This unpacking operation is performed automatically for variables with attributes \code{scale_factor} and \code{add_offset} if argument \code{unpack} is set to \code{TRUE}. If \code{unpack} is \code{FALSE}, values are read from each variable without alteration.

Data in a NetCDF file is conceived as being a multi-dimensional array. The number and length of dimensions is determined when the variable is created. The \code{start} and \code{count} indices that this routine takes indicate where the reading starts along each dimension, and the count of values along each dimension to read. 

The argument \code{collapse} allows to keep degenerated dimensions (if set to \code{FALSE}). As default, array dimensions with length=1 are omitted (e.g., an array with dimensions [2,1,3,4] in the NetCDF dataset is returned as [2,3,4]).

Awkwardness arises mainly from one thing: NetCDF data are written with the last dimension varying fastest, whereas R works opposite. Thus, the order of the dimensions according to the CDL conventions (e.g., time, latitude, longitude) is reversed in the R array (e.g., longitude, latitude, time).}

\references{\url{http://www.unidata.ucar.edu/software/netcdf/}}

\note{\code{NC_BYTE} is always interpreted as signed.}

\author{Pavel Michna, Milton Woods}

\examples{
##  Create a new NetCDF dataset and define two dimensions
nc <- create.nc("var.get.nc")

dim.def.nc(nc, "station", 5)
dim.def.nc(nc, "time", unlim=TRUE)
dim.def.nc(nc, "max_string_length", 32)

##  Create three variables, one as coordinate variable
var.def.nc(nc, "time", "NC_INT", "time")
var.def.nc(nc, "temperature", "NC_DOUBLE", c(0,1))
var.def.nc(nc, "name", "NC_CHAR", c("max_string_length", "station"))

##  Put some missing_value attribute for temperature
att.put.nc(nc, "temperature", "missing_value", "NC_DOUBLE", -99999.9)

##  Define variable values
mytime        <- c(1:2)
mytemperature <- c(1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, NA, NA, 9.9)
myname        <- c("alfa", "bravo", "charlie", "delta", "echo")

##  Put the data
var.put.nc(nc, "time", mytime, 1, length(mytime))
var.put.nc(nc, "temperature", mytemperature, c(1,1), c(5,2))
var.put.nc(nc, "name", myname, c(1,1), c(32,5))

##  Get the data (or a subset)
var.get.nc(nc, 0)
var.get.nc(nc, "time", 1, 1)
var.get.nc(nc, "time", 1, NA)
var.get.nc(nc, "temperature")
var.get.nc(nc, "temperature", c(NA,2), c(NA,1))
var.get.nc(nc, "name")
var.get.nc(nc, "name", c(1,2), c(4,2))
var.get.nc(nc, "name", c(1,2), c(NA,2))

close.nc(nc)
}

\keyword{file}
