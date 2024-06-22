#!/bin/bash
ARCH="x64"
if [ "$READARR_REL" == "latest" ]; then
  LAT_V="$(wget -qO- "https://readarr.servarr.com/v1/update/master/changes?runtime=netcore&os=linux" | jq -r '.[0].version' | sed 's/null//')"
  if [ -z $LAT_V ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Readarr | grep LATEST | cut -d '=' -f2)"
  fi
  RELEASE="master"
elif [ "$READARR_REL" == "develop" ]; then
  LAT_V="$(wget -qO- "https://readarr.servarr.com/v1/update/develop/changes?runtime=netcore&os=linux" | jq -r '.[0].version'| sed 's/null//')"
  if [ -z $LAT_V ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Readarr | grep DEVELOP | cut -d '=' -f2)"
  fi
  RELEASE="develop"
else
  echo "---Version manually set to: v$READARR_REL---"
  LAT_V="$READARR_REL"
fi

if [ ! -f ${DATA_DIR}/logs/readarr.txt ]; then
  CUR_V=""
else
  CUR_V="$(cat ${DATA_DIR}/logs/readarr.txt | grep " - Version" | tail -1 | rev | cut -d ' ' -f1 | rev)"
fi

if [ -z $LAT_V ]; then
  if [ -z $CUR_V ]; then
    echo "---Can't get latest version of Readarr, putting container into sleep mode!---"
    sleep infinity
  else
    echo "---Can't get latest version of Readarr, falling back to v$CUR_V---"
    LAT_V="$CUR_V"
  fi
fi

if [ -f ${DATA_DIR}/Readarr-v$LAT_V.tar.gz ]; then
  rm ${DATA_DIR}/Readarr-v$LAT_V.tar.gz
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
  echo "---Readarr not found, downloading and installing v$LAT_V...---"
  cd ${DATA_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Readarr-v$LAT_V.tar.gz "https://github.com/Readarr/Readarr/releases/download/v${LAT_V}/Readarr.${RELEASE}.${LAT_V}.linux-core-${ARCH}.tar.gz" ; then
    echo "---Successfully downloaded Readarr v$LAT_V---"
  else
    echo "---Something went wrong, can't download Readarr v$LAT_V, putting container into sleep mode!---"
    sleep infinity
  fi
  mkdir ${DATA_DIR}/Readarr
  tar -C ${DATA_DIR}/Readarr --strip-components=1 -xf ${DATA_DIR}/Readarr-v$LAT_V.tar.gz
  rm ${DATA_DIR}/Readarr-v$LAT_V.tar.gz
elif [ "$CUR_V" != "$LAT_V" ]; then
  echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
  cd ${DATA_DIR}
  if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Readarr-v$LAT_V.tar.gz "https://github.com/Readarr/Readarr/releases/download/v${LAT_V}/Readarr.${RELEASE}.${LAT_V}.linux-core-${ARCH}.tar.gz" ; then
    echo "---Successfully downloaded Readarr v$LAT_V---"
  else
    echo "---Something went wrong, can't download Readarr v$LAT_V, putting container into sleep mode!---"
    sleep infinity
  fi
  mkdir ${DATA_DIR}/Readarr 2>/dev/null
  tar -C ${DATA_DIR}/Readarr --strip-components=1 -xf ${DATA_DIR}/Readarr-v$LAT_V.tar.gz
  rm ${DATA_DIR}/Readarr-v$LAT_V.tar.gz
elif [ "$CUR_V" == "$LAT_V" ]; then
  echo "---Readarr v$CUR_V up-to-date---"
fi

echo "---Preparing Server---"
if [ ! -f ${DATA_DIR}/config.xml ]; then
  echo "<Config>
  <LaunchBrowser>False</LaunchBrowser>
</Config>" > ${DATA_DIR}/config.xml
fi
if [ -f ${DATA_DIR}/readarr.pid ]; then
  rm ${DATA_DIR}/readarr.pid
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Readarr---"
cd ${DATA_DIR}
${DATA_DIR}/Readarr/Readarr -nobrowser -data=${DATA_DIR} ${START_PARAMS}