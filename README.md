# RnwToRmd

The function RnwToRmd converts a knitr file to a R markdown file.
The conversion involves three steps:
1. insert the knitr R code into LaTex "verbatim"environments, so that the Rnw file is now pure LaTex code
2. use pandoc to convert the intermediate LaTeX file to a markdown file
3. convert the knitr code chunks to R markdown

### Install the package using
```
devtools::install_github('phenaff/RnwToRmd')
```
