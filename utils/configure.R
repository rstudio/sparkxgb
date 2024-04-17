library(purrr)
library(rvest)
library(sparklyr)
library(fs)

# Install Scala version if missing
invisible(download_scalac())

# Get current compilation specs from `sparklyr`
sparklyr_comps <- sparklyr::spark_default_compilation_spec()

# Installs Spark versions if missing
sparklyr_comps %>% 
  map(~.x$spark_version) %>% 
  walk(spark_install)

maven_url <- "https://repo1.maven.org/maven2/ml/dmlc/"
pkg_name <- "xgboost4j-spark"

# Pull all of the links from the main page in Maven
maven_links <- maven_url %>% 
  read_html() %>% 
  html_elements("a") %>% 
  html_attr("href") 

scala_folders <- maven_links[
  grepl(pkg_name, maven_links) &
    !grepl("gpu", maven_links) &
    grepl("_", maven_links)
] 

scala_names <- substr(scala_folders, nchar(pkg_name) + 2, nchar(scala_folders) - 1)

# Iterates through each Scala version page, y select the most recent version
scala_links <- scala_folders %>% 
  paste0(maven_url, .) %>% 
  map(~{
    folder <-  .x %>% 
      read_html() %>% 
      html_elements("a") %>% 
      html_attr("href") 
    
    ver_folders <- folder[!grepl("maven", folder) & !grepl("\\.\\.", folder)]
    
    top_folder <- ver_folders %>% 
      sort(decreasing = TRUE) %>%  
      head(1)
    
    file_list <- paste0(.x, top_folder) %>% 
      read_html() %>% 
      html_elements("a") %>% 
      html_attr("href") 
    
    jar_file <- file_list[
      grepl("jar", file_list) &
        !grepl("\\.asc", file_list) &
        !grepl("\\.sha1", file_list) &
        !grepl("\\.md5", file_list) &
        !grepl("-sources", file_list) &
        !grepl("-javadoc", file_list)
      ] 
    paste0(.x, top_folder, jar_file)
  }) %>% 
  set_names(scala_names)


jar_paths <- path("utils", "jars")
if(!dir_exists(jar_paths)) dir_create(jar_paths)

# Downloads files if missing
scala_links %>% 
  map(~ {
    y <- path(jar_paths, path_file(.x)) 
    if(!file_exists(y)) {
      download.file(.x, y)
    }
  }) 

scala_ver <- function(x) {
  parts <- unlist(strsplit(x, "/"))
  sc_ver <- parts[grepl("scala-", parts)]
  substr(sc_ver, 7, 10)  
}

scala_ver(sparklyr_comps[[2]]$scalac_path)


if (!dir.exists("internal")) dir.create("internal")
if (!dir.exists("internal/xgboost4j-spark")) dir.create("internal/xgboost4j-spark")
if (!file.exists("internal/xgboost4j-spark/xgboost4j-spark-0.81.jar")) download.file(
  "http://central.maven.org/maven2/ml/dmlc/xgboost4j-spark/0.81/xgboost4j-spark-0.81.jar",
  "internal/xgboost4j-spark/xgboost4j-spark-0.81.jar"
)



spec <- sparklyr::spark_default_compilation_spec() %>%
  map(function(x) {
    x$jar_dep <- list.files("internal/xgboost4j-spark", full.names = TRUE) %>% 
      map_chr(normalizePath)
    x
  }) %>%
  keep(~ .x$spark_version >= "2.3.0")

sparklyr::compile_package_jars(spec = spec)
