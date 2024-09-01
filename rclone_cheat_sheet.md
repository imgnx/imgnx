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

---

Edit: You can also place a file like this in your home directory and then `source` it:

```bash
#!/bin/bash

export gui="rclone rcd --rc-web-gui"
export mv="rclone move $@"
export cp="rclone copy $@"
```

Or if you'd rather use `gcloud storage`:

```bash
#!/bin/bash

export sign-url="gcloud storage sign-url $@"
export rsync="gcloud storage rsync $@"
export restore="gcloud storage restore $@"
export hmac="gcloud storage hmac $@"
export hash="gcloud storage hash $@"
export stat="gcloud storage stat $@"
export buckets="gcloud storage buckets $@"
export mv="gcloud storage mv $@"
export cp="gcloud storage cp $@"
export rm="gcloud storage rm $@"
export ls="gcloud storage ls $@"
export du="gcloud storage du $@"
export mb="gcloud storage mb $@"
export rb="gcloud storage rb $@"
export acl="gcloud storage acl $@"
export defacl="gcloud storage defacl $@"
export setdefacl="gcloud storage setdefacl $@"
export getdefacl="gcloud storage getdefacl $@"
export notification="gcloud storage notification $@"
export logging="gcloud storage logging $@"
export cors="gcloud storage cors $@"
export lifecycle="gcloud storage lifecycle $@"
export retention="gcloud storage retention $@"
export tempauth="gcloud storage tempauth $@"
export requesterpays="gcloud storage requesterpays $@"
export compose="gcloud storage compose $@"
export rewrite="gcloud storage rewrite $@"
export watchbucket="gcloud storage watchbucket $@"
export watchobject="gcloud storage watchobject $@"
export help="gcloud storage help $@"
export version="gcloud storage version $@"
export update="gcloud storage update $@"
export config="gcloud storage config $@"
export components="gcloud storage components $@"
export feedback="gcloud storage feedback $@"
export init="gcloud storage init $@"
export source="gcloud storage source $@"
export docker="gcloud storage docker $@"
export kubectl="gcloud storage kubectl $@"
export alpha="gcloud storage alpha $@"
export beta="gcloud storage beta $@"
export topic="gcloud storage topic $@"
export pubsub="gcloud storage pubsub $@"
export projects="gcloud storage projects $@"
export organizations="gcloud storage organizations $@"
export locations="gcloud storage locations $@"
export zones="gcloud storage zones $@"
export networks="gcloud storage networks $@"
export operations="gcloud storage operations $@"
export services="gcloud storage services $@"
export service-accounts="gcloud storage service-accounts $@"
export iam="gcloud storage iam $@"
export billing="gcloud storage billing $@"
export billing-accounts="gcloud storage billing-accounts $@"
export billing-projects="gcloud storage billing-projects $@"
export billing-quotas="gcloud storage billing-quotas $@"
export billing-usage="gcloud storage billing-usage $@"
export billing-invoices="gcloud storage billing-invoices $@"
export billing-subscriptions="gcloud storage billing-subscriptions $@"
export billing-subscription="gcloud storage billing-subscription $@"
export billing-subscription-projects="gcloud storage billing-subscription-projects $@"
export billing-subscription-services="gcloud storage billing-subscription-services $@"
export billing-subscription-skus="gcloud storage billing-subscription-skus $@"
export billing-subscription-quotas="gcloud storage billing-subscription-quotas $@"
export billing-subscription-usage="gcloud storage billing-subscription-usage $@"
export billing-subscription-invoices="gcloud storage billing-subscription-invoices $@"
export billing-subscription-subscriptions="gcloud storage billing-subscription-subscriptions $@"

```

Then you can use the variable `mv` in your scripts to move files around.
