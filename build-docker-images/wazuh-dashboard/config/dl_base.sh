WAZUH_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/wazuh/wazuh/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2-)
MAJOR_BUILD=$(echo $WAZUH_VERSION | cut -d. -f1)
MID_BUILD=$(echo $WAZUH_VERSION | cut -d. -f2)
MINOR_BUILD=$(echo $WAZUH_VERSION | cut -d. -f3)
MAJOR_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f1)
MID_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f2)
MINOR_CURRENT=$(echo $WAZUH_CURRENT_VERSION | cut -d. -f3)

## check version to use the correct repository
if [ "$MAJOR_BUILD" -ge "$MAJOR_CURRENT" ]; then
  REPOSITORY="packages-dev.wazuh.com"
elif [ "$MAJOR_BUILD" -eq "$MAJOR_CURRENT" ]; then
  if [ "$MID_BUILD" -ge "$MID_CURRENT" ]; then
    REPOSITORY="packages-dev.wazuh.com"
  elif [ "$MID_BUILD" -eq "$MID_CURRENT" ]; then
    if [ "$MINOR_BUILD" -ge "$MINOR_CURRENT" ]; then
      REPOSITORY="packages-dev.wazuh.com"
    else
      REPOSITORY="packages.wazuh.com"
    fi
  else
    REPOSITORY="packages.wazuh.com"
  fi
else
  REPOSITORY="packages.wazuh.com"
fi

curl -o wazuh-dashboard-base.tar.xz https://${REPOSITORY}/stack/dashboard/base/wazuh-dashboard-base-${WAZUH_VERSION}-${WAZUH_TAG_REVISION}-linux-x64.tar.xz
tar -xf wazuh-dashboard-base.tar.xz --directory  $INSTALL_DIR --strip-components=1