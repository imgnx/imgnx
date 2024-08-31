<span style="font-size: 42px;">`rclone`</span>

<span style="display: flex; align-items:center; font-size: 42px;"><span role="image">☁️</span><span style="font-size: 18px; margin-left: 10px; margin-right: 10px;" role="image">▶️</span><span role="image">👩‍💻</span></span>

## Download `IMGNX_ORG`:
<code style="float: left; margin-top: 15px; margin-right: 15px;">pwsh</code>
```pwsh
rclone copy dmholdingsinccom:imgnx.org I:\IMGNX_ORG --exclude-from I:\.imgnx\.rclone.exclude
```
<code style="float: left; margin-top: 15px; margin-right: 15px;">zsh</code>
```zsh
rclone copy dmholdingsinccom:imgnx.org /mnt/i/IMGNX_ORG --exclude-from /mnt/i/.imgnx/.rclone.exclude
```



<span style="display: flex; align-items:center; font-size: 42px;"><span role="image">👩‍💻</span><span style="font-size: 18px; margin-left: 10px; margin-right: 10px;" role="image">▶️</span><span role="image">☁️</span></span>

## Upload `IMGNX_ORG`:

```bash
rclone copy I:\IMGNX_ORG dmholdingsinccom:imgnx.org --exclude-from I:\.imgnx\.rclone.exclude
```
This can also be used to copy the contents of `I:\` to the `IMGFUNNELS_COM` bucket (imgfunnels.com) on the cloud using `bash
rclone copy I:\ dmholdingsinccom:imgfunnels.com --exclude-from I:\.imgnx\.rclone.exclude`. Make sure you clear out `I:\IMGNX_ORG` before running the command.

<span style="display: flex; align-items:center; font-size: 42px;"><span role="image">💿</span><span style="font-size: 18px; margin-left: 10px; margin-right: 10px;" role="image">▶️</span><span role="image">💿</span></span>

## Mount `IMGFUNNELS_COM` to local storage:

```bash
rclone mount dmholdingsinccom:imgfunnels.com I:\IMGFUNNELS_COM --vfs-cache-mode full --cache-dir I:\__CACHE__\IMGFUNNELS_COM --debug-fuse -v --fuse-flag --network-mode
```

This will copy the contents of `example_dir` to `imgfunnels.com`
on the cloud. The `--exclude-from` flag is used to exclude files
from the copy operation.

Imaging is the process of comparing the source and destination
and removing files from the destination that are not in the
source. `sync` is `copy` with imaging (will remove files from
destination that are not in source)
