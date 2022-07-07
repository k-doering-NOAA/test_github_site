# example R script for archiving github repos using googledrive

#devtools::install_github("opensci-org/gitcellar")
gitcellar::download_organization_repos("r4ss", dest_fold = "try_download") # or other org

local_file_path <- file.path("try_download", "archive-r4ss_r4ss", 
    "r4ss_r4ss_migration_archive.tar.gz")
g_drive_path <- "archive-r4ss_r4ss.tar.gz"
# upload to google drive (expect needing some authentification, will be taken to browser)
drive_upload(media = local_file_path,  g_drive_path)

# TODO: use drive_share to change permissions so that it is read only for all of
# NOAA (not sure how to do this right now)
#drive_share(gdrive_path, role = "reader", type = "group")

