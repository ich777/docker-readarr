# Readarr in Docker optimized for Unraid
Readarr is an ebook and audiobook collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new books from your favorite authors and will grab, sort, and rename them. Note that only one type of a given book is supported. If you want both an audiobook and ebook of a given book you will need multiple instances.

**UPDATE:** The container will check on every start/restart if there is a newer version available.

**MANUAL VERSION:** You can also set a version manually by typing in the version number that you want to use for example: '0.3.28.2554' (without quotes) - valid options are 'develop' and 'latest' without quotes PLEASE NOTE THAT CURRENTLY ONLY DEVELOP IS WORKING BECAUSE ONLY DEVELOP BRANCH IS IN ACTIVE DEVELOPMENT

**ATTENTION:** Don't change the port in the Readarr config itself.

**MIGRATION:** If you are migrating from another Container please be sure to deltete the files/folders 'logs' and 'config.xml', don't forget to change the root folder for your books and select 'No, I'll Move the Files Myself'!

#### **WARNING: The main configuration of the paths has a performance and disk usage impact: slow, I/O intensive moves and wasted disk space. For a detailed guide to change that see https://trash-guides.info/hardlinks/#unraid .**

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /readarr |
| READARR_REL | Select if you want to download a stable or prerelease | develop |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name Readarr -d \
	-p 8787:8787 \
	--env 'READARR_REL=develop' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /path/to/readarr:/readarr \
	--volume /path/to/Books:/mnt/books \
	--volume /path/to/Downloads:/mnt/downloads \
	ich777/readarr
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/