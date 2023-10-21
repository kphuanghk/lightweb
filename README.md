# Automate Java Web App build tooling with Ant and Jetty

## Overview

Java web app has internal package namespace has changed from `javax.servlet` 
from `< 4.0` to `jakarta.servlet` from `>= 4.0`. It is important to note the
java version, app server version and namespace used. This will use Jetty 10.0.x
as the servlet container, which is the last major version based on servlet spec
less than `4.0` and JDK 11. Web app packing using Ant. The reason using Ant is
because it is simple and easily work in offline environment.

## Preparation
This demo tested in Linux. Before trying the example, run the `download.sh`

```bash
## Assumee you clone at ~/lightweb
cd ~/lightweb
./download.sh
```

## Run the Jetty Server
```bash
export JETTY_HOME=~/lightweb/jetty-home-10.0.17
mkdir ~/lightweb/jetty-base
cd ~/lightweb/jetty-base
# Scaffolding the app server folder structure
java -jar $JETTY_HOME/start.jar --add-module=server,http,jsp,deploy

# Change the port number
vim ~/lightweb/jetty-base/start.d/http.ini
# Change the port 
# jetty.http.port=28080
java -jar $JETTY_HOME/start.jar
```

Regarding TLS Config, can refer to this

https://eclipse.dev/jetty/documentation/jetty-10/operations-guide/index.html#og-protocols-ssl


## Build App with Ant

Project folder structure
```
mainapp
  |- classes    # Compiled java class
  |- docs       # JSP pages or other public accessible resources
  |- lib        # jar dependency that required to run in webapp, but not provided by contianer
  |- libservlet # jars that provided by container and does not include in the war
```
A simple web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="3.0">
    <display-name>test-service</display-name>

    <welcome-file-list>
        <welcome-file>index.jsp</welcome-file>
     </welcome-file-list>
    <servlet>
        <servlet-name>Hello</servlet-name>
        <servlet-class>HelloServlet</servlet-class>
    </servlet>

    <servlet-mapping>
        <url-pattern>/hello</url-pattern>
        <servlet-name>Hello</servlet-name>
    </servlet-mapping>
</web-app>
```

build.xml, based on example from O'Reilly.

```xml
<project name="myapplication" default="compile" basedir=".">

    <property name="war-file" value="~/lightweb/jettybase/webapps/demo.war" />
    <property name="war-file2" value="${ant.project.name}.war" />
    <property name="src-dir" value="src" />
    <property name="build-dir" value="classes" />
    <property name="docs-dir" value="docs" />
    <property name="webxml-file" value="web.xml" />
    <property name="lib-dir" value="lib" />

    <target name="compile" depends="">
        <mkdir dir="${build-dir}" />
        <javac srcdir="${src-dir}" destdir="${build-dir}" />
    </target>

    <target name="war" depends="compile">
        <war warfile="${war-file}" webxml="${webxml-file}">
            <classes dir="${build-dir}" />
            <fileset dir="${docs-dir}" />
            <lib dir="${lib-dir}" />
        </war>
    </target>

    <target name="clean">
        <delete dir="${build-dir}" />
        <delete file="${war-file}" />
    </target>

</project>
```

Build command
```bash
~/lightweb/apache-ant-1.10.14/bin/ant war
# The output will be generated at jettybase/webapp
# If jetty is running, it will automatically detect and reload the app
```

## Quick performance test

```bash
ab -n 10000 -c 100 http://localhost:28080/demo/hello
```
