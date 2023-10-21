#!/bin/bash

antgz=apache-ant-1.10.14-bin.tar.gz
# Servlet 3.x with javax.servlet namespace
jettygz=jetty-home-10.0.17.tar.gz
# Serlvet 4.0 with jakarta.servlet namespace
# jettygz=jetty-home-11.0.17.tar.gz
# https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/10.0.17/jetty-home-10.0.17.tar.gz

if ! [ -f $antgz ]; then
  echo "Download Ant 1.10.14"
  wget --no-check-certificate https://dlcdn.apache.org/ant/binaries/$antgz
else
  echo "File $antgz existed"
fi

if ! [ -f $jettygz ]; then
  echo "Download Jetty 10.0.17"
  wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/10.0.17/jetty-home-10.0.17.tar.gz
else
  echo "File $jettygz existed"
fi

tar xf $antgz
tar xf $jettygz


if ! [ -f mainapp/lib/fastjson2-2.0.41.jar ]; then
  wget https://repo1.maven.org/maven2/com/alibaba/fastjson2/fastjson2/2.0.41/fastjson2-2.0.41.jar
  mv -f fastjson2-2.0.41.jar  mainapp/lib/
  echo "Copy fastjson to lib"
else
  echo "fastjson existed, skipped"
fi

if ! [ -f mainapp/libservlet/jetty-servlet-api-4.0.6.jar ]; then
  cp -f jetty-home-10.0.17/lib/jetty-servlet-api-4.0.6.jar mainapp/libservlet/
  echo "Copy jett-servlet-api to libservlet"
else
  echo "servlet api existed, skipped"
fi