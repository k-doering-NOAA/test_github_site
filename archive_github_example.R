# example R script for archiving github repos using googledrive
# call from powershell using rscript archive_github_example.R
#devtools::install_github("ropensci-org/gitcellar")
local_dest_folder <- "download_archives"
gitcellar::download_organization_repos("r4ss", dest_fold = local_dest_folder) # or other org

files_to_upload <- list.files(local_dest_folder, recursive = TRUE)

lapply(files_to_upload, function(archive_file, local_dest_folder) {
  local_file_path <- file.path(local_dest_folder, archive_file)
  g_drive_path <- googledrive::as_id("https://drive.google.com/drive/u/0/folders/1tV8yRmdINmNAE4Ry_MMmwVIwnftuSbrQ")
  g_drive_name <- basename(archive_file) # may want to append a date
  # upload to google drive (expect needing some authentification, will be taken to browser)
  googledrive::drive_upload( media = local_file_path,  path = g_drive_path, 
  name = g_drive_name)
}, local_dest_folder = local_dest_folder)

# cleanup
unlink(local_dest_folder, recursive = TRUE)

# TODO

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