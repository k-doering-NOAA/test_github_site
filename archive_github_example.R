# example R script for archiving github repos using googledrive
# call from powershell using rscript archive_github_example.R
#devtools::install_github("ropensci-org/gitcellar")
local_dest_folder <- "download_archives"
gitcellar::download_organization_repos("r4ss", dest_fold = local_dest_folder) # or other org

files_to_upload <- list.files(local_dest_folder, recursive = TRUE)

lapply(files_to_upload, function(archive_file, local_dest_folder) {
  local_file_path <- file.path(local_dest_folder, archive_file)
  g_drive_path <- googledrive::as_id("https://drive.google.com/drive/u/0/folders/1Qbs9ts4cQ9XlJ2mj6ZQAMSR4dAFQSTup")
  g_drive_name <- basename(archive_file) # may want to append a date
  #g_drive_name <- sub(".", paste0("_" , Sys.Date(), "."), g_drive_name, 
  #  fixed = TRUE)
  # upload to google drive (expect needing some authentification, will be taken to browser)
  # drive put will either make a new file if one doesnt exist, or update the
  # version if one already exists.
  googledrive::drive_put( media = local_file_path,  path = g_drive_path, 
  name = g_drive_name)
}, local_dest_folder = local_dest_folder)
1
# # If there are more than 5 copies, delete the oldest ones for each archive.
#  g_drive_path <- googledrive::as_id("https://drive.google.com/drive/u/0/folders/1tV8yRmdINmNAE4Ry_MMmwVIwnftuSbrQ")

# cleanup
unlink(local_dest_folder, recursive = TRUE)

# An alternative (manual) way to save 5 versions. Way more manual work
# # get all the .tar.gz extension files within a specific parent folder.
# files_to_search <- googledrive::drive_find(pattern = "*.tar.gz", 
#   n_max = 30, 
#   q = paste0("'", g_drive_path, "' in parents"))

# if(nrow(files_to_search == 30)) {
#   warning(" May need to increase n_max in drive_find, because hit 30.")
# }

# # pull out the different patterns
# filename_splits <- strsplit(files_to_search$name, "_migration_archive_")
# patterns <- unique(unlist(lapply(filename_splits, function(x) x[1])))
# n_ver_to_keep <- 5

# # get the dates associated with each
# for(p in patterns) {
#   dates <- lapply(filename_splits, function(x, pat) {
#     if(x[1] == pat) {
#       x[2]
#     } else {
#     NULL
#     }
#   }, pat = p)
#   dates <- unlist(dates)
#   if (isTRUE(length(dates) > n_ver_to_keep)) {
#     # delete the older versions
#     dates <- as.Date(dates)
#     to_reorder <- order(dates)
#     # older is first
#     dates <- dates[to_reorder]
#     dates_to_rm <- dates[1:(length(dates)-n_ver_to_keep)]
#     # delete dates_to_rm from googledrive
#   }
# }

# may want o append a date to the archive names, otherwise running the code
# again will upload a file with the same name, but a different id, which could
# get confusing It would be nice to have a process for autodeleting older
# versions of the archive (e.g., maybe keep 5 version, then delete anything
# older? The gdrive pkg may have some tools for doing this)

# might need to check on the auth, to make sure it is available when scheduling 
# a job. One resource:
#   See gargle's "Non-interactive auth" vignette for more details:
# https://gargle.r-lib.org/articles/non-interactive-auth.html

# Finally, need to set this up to run with windows task scheduler. May need to 
# simply make a batch file in the same location as this script that contains
# rscript archive_github_example.R as the instructions?