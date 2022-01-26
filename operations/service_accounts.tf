
# # Landscape Service account
# resource "google_service_account" "tuk_gitlab" {
#   account_id   = "${var.tuk}-gitlab"
#   display_name = "TUK GitLab"
# }

# # Grant folder rights to gitlab account
# variable "gitlab_folder_roles" {
#   description = "The list of folder IAM roles for tuk-gitlab user"
#   type        = list(string)

#   default = [
#     "roles/owner",
#   ]
# }

# resource "google_folder_iam_member" "gitlab_folder_roles" {
#   member = "serviceAccount:${google_service_account.tuk_gitlab.email}"
#   folder = google_folder.tuk_folder.name
#   role   = element(var.gitlab_folder_roles, count.index)
#   count  = length(var.gitlab_folder_roles)
# }
