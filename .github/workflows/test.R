# test out some R script to manipulate
info <- gh::gh("GET /repos/{owner}/{repo}/pulls/{pull_number}", 
            owner = "k-doering-noaa", 
            repo = "test_github_site",
            pull_number = "24")
pr_body  <- strsplit(info$body, "\n" )[[1]]
pr_body <- gsub("\r", "",  pr_body, fixed = TRUE)
# Get info on which iseus should be closed

# Get issues
issue_num <- grep("Link issue", pr_body, value = TRUE)
# split at the pound sign
issue_num <- strsplit(issue_num, split = "#",  fixed = TRUE)[[1]][-1]
# Split at any other characters that aren't numbers
issue_num <- unlist(strsplit(issue_num, split = "\\D+"))
# these are the issues we will want to close.

# Get info on which repos need open issues, if a change log entry is needed.
# allow some flexibility for getting the spacing wrong, which is easy to do.
# look for checklist items like - []
needs_changes <- grep("-\\s*\\[\\s*\\]", pr_body, ignore.case = TRUE, value = TRUE)
# just do an if statement for each to determine which changes 
if (length(grep("r4ss", needs_changes)) == 1) {
    # set some value and post an issue to r4ss.
}

# should be 2 lines below the heading
change_log <- grep( "Version\\s*\\|\\s*Date", pr_body)+2
# all the info the user put into the change log
change_log_info <- strsplit(pr_body[change_log], split = "\\|")[[1]]
# this can then be manipulated and added to the change log (excel or a csv version, perhaps?)