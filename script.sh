#!/bin/bash
DEPLOY_PATH="/opt/neyross"
ARCH_NAME="astra_dependencies.tar.gz"
NGINX_TMP=$DEPLOY_PATH/nginx
echo "Creating directory /opt/neyross"
mkdir -p $DEPLOY_PATH
echo "Copying archive to /opt/neyross "
tail -n +34 "$0" > $DEPLOY_PATH/$ARCH_NAME
cd $DEPLOY_PATH
echo "Extracting archive"
tar xzf $ARCH_NAME
echo "Removing archive"
rm -rf $DEPLOY_PATH/$ARCH_NAME
echo "Copying media-server dependencies files"
cp -rf $DEPLOY_PATH/astra_dependencies/media-server-dependencies /root
echo "Installing media-server dependencies"
bash /root/media-server-dependencies/install_dependencies.sh
echo "Making nginx directory"
mkdir -p $NGINX_TMP/nginx_tmp1 $NGINX_TMP/nginx_tmp2
echo "Copying nginx files"
cp -rf /etc/nginx $NGINX_TMP/nginx_tmp1 && cp -rf /usr/share/nginx $NGINX_TMP/nginx_tmp2
echo "Updating nginx"
apt remove -y nginx && dpkg -i $DEPLOY_PATH/astra_dependencies/nginx_1.18.0-1_amd64.deb
echo "Copying nginx files"
cp -rf $NGINX_TMP/nginx_tmp1/nginx /etc && cp -rf $NGINX_TMP/nginx_tmp2/nginx /usr/share/
echo "Restarting nginx"
systemctl restart nginx
echo "Restarting neyross server"
systemctl restart ultima-vmc
echo "Cleaning build directory"
rm -rf $DEPLOY_PATH
exit 0
# NOTE: Don't place any newline characters after the last line below.
