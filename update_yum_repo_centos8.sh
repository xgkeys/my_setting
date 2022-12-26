#!/usr/bin/env bash

# aliyun url
aliyun_url=https://mirrors.aliyun.com
# remote repo file
# cos7_repo=${aliyun_url}/repo/Centos-7.repo
cos8_repo=${aliyun_url}/repo/Centos-8.repo
# yum dir always usually
repo_dir=/etc/yum.repos.d/
# name a dir to mv all old repos to backup them
date_style=+%Y-%m-%d-%H-%M
name_suffix=backup_$(date ${date_style})
backup_dir=${repo_dir}${name_suffix}

# ###################################
# fastestmirror is plugins to speed up .
# modify enabled = 1 into enabled = 0 , disable it.
if [ -f /etc/yum/pluginconf.d/fastestmirror.conf ]; then
sed -i "s/enabled=1/enabled=0|g" /etc/yum/pluginconf.d/fastestmirror.conf
fi

# vim /etc/yum.conf modify plugins=0 not use it
if [ -f /etc/yum.conf ]; then
sed -i "s/plugins=1|plugins=0/g" /etc/yum.conf
fi
# make the backup dir
mkdir ${backup_dir} \
&& if [ -a ${repo_dir}*.repo ]; then
    mv ${repo_dir}*.repo ${backup_dir}
fi \
&& curl -o ${repo_dir}CentOS-Base.repo ${cos8_repo} \
&& yum clean all \
&& yum makecache \
&& echo "Finished"

