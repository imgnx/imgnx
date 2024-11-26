# # Ship It!

# Also works with local files, so no need for `rsync`, `scp`, or `rclone`.

# ## Local

# - Copy
gsutil cp "./my-file" "gs://[BUCKET-NAME]/[FILE]"

# - Move
gsutil mv "./my-file" "gs://[BUCKET-NAME]/[FILE]"

# ## Remote

# - Copy
gsutil cp "gs://[BUCKET-NAME]/[FILE]" "gs://[BUCKET-NAME]/[FILE]"

# - Move
gsutil mv "gs://[BUCKET-NAME]/[FILE]" "gs://[BUCKET-NAME]/[FILE]"
