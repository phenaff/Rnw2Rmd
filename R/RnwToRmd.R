library(knitr)
library(stringr)

#' Knitr to R markdown converter
#'
#' RnwToRmd converts a .Rnw file to .Rmd
#'
#' The conversion involves three steps:
#' - insert the knitr R code into LaTex "verbatim"environments, so that the Rnw file is now pure LaTex code
#' - use pandoc to convert the intermediate LaTeX file to a markdown file
#' - convert the knitr code chunks to R markdown
#'
#' @param input name of file to be converted
#'
#' @return None
#'
#' @author Patrick Henaff, \email{pa.henaff@gmail.com}
#' @keywords knitr, rmarkdown
#'
#' @examples
#' \dontrun{
#' RnwToRmd("test.Rnw")
#' }
#'
#' @export
RnwToRmd <- function(input) {
  verbatimRcode(input, '__tmp.tex')
  pandoc('__tmp.tex', format='markdown')
  out.file <- paste(tools::file_path_sans_ext(input), ".Rmd", sep="")
  unverbatimRcode("__tmp.markdown", out.file)
  if (file.exists("__tmp.tex"))
    file.remove("__tmp.tex")
  if (file.exists("__tmp.markdown"))
    file.remove("__tmp.markdown")
}



verbatimRcode <- function(input, output) {
  # put R code in tex verbatim environment
  lines <- readLines(input)

   n <- length(lines)
  count <- 1

  out.file <- file(output, "w")

  while(count <= n) {

  if(grepl(all_patterns$rnw$chunk.begin, lines[count])) {
    writeLines("\\begin{verbatim}", con=out.file)
  }

  writeLines(lines[count], con=out.file)

  if(grepl(all_patterns$rnw$chunk.end, lines[count])) {
    writeLines("\\end{verbatim}", con=out.file)
  }
  count <- count+1
  }

  close(out.file)
}

unverbatimRcode <- function(input, output) {
  # convert the R code in verbatim to r markdown environment
  # included <<>> knitr chunks remain as is
  lines <- readLines(input)
  n <- length(lines)
  count <- 1

  out.file <- file(output, "w")
  is.chunk <- FALSE

  while(count <= n) {
    if(grepl(knitr::all_patterns$rnw$chunk.begin, lines[count])) {
      line.out <- str_replace_all(string = lines[count],
                  pattern = all_patterns$rnw$chunk.begin,
                  replacement = "```{r, \\1}")
      is.chunk = TRUE
    } else if(grepl(knitr::all_patterns$rnw$chunk.end, lines[count])) {
      line.out <- "```"
      is.chunk = FALSE
    } else {
      if(is.chunk) {
        line.out <- str_sub(lines[count], start=3)
      } else {
        line.out <- lines[count]
      }
    }
    writeLines(line.out, con=out.file)
    count <- count+1
  }

  close(out.file)
}
