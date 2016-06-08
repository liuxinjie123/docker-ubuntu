FROM ubuntu:14.04

MAINTAINER hary <94093146@qq.com>

ENV DEBIAN_FRONTEND noninteractive

# 使用阿里的source
ADD ["sources.list", "/etc/apt/sources.list" ]
RUN apt-get update

# 安装基础工具软件
RUN apt-get install -y vim.tiny wget sudo net-tools ca-certificates  curl git

# 安装中文语言包
RUN /usr/share/locales/install-language-pack zh_CN \
 && locale-gen zh_CN.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales \
 && apt-get install -y --no-install-recommends  language-pack-zh-hans

# 配置中文为默认语言
ENV LANGUAGE "zh_CN:en_US:en"
ENV LANG     "zh_CN.UTF-8"
ENV LC_ALL   "zh_CN.UTF-8"

# 安装文泉字体
RUN apt-get install -y ttf-wqy-microhei \
 && ln /etc/fonts/conf.d/65-wqy-microhei.conf /etc/fonts/conf.d/69-language-selector-zh-cn.conf

# 设置时区
ENV TZ "PRC"
RUN echo "Asia/Shanghai" | tee /etc/timezone \
 && dpkg-reconfigure -f noninteractive tzdata

# 安装java环境
RUN apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa  \
  && apt-get update  \
  && apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$GRADLE_HOME/bin:$PATH

# 安装mysql
RUN apt-get install -yq mysql-server-5.6 pwgen \
  && rm -fr /var/lib/mysql/*

# 安装redis
RUN apt-get install -y redis-server \
 && sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
 && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
 && sed '/^logfile/d' -i /etc/redis/redis.conf

# 安装nginx
RUN apt-get install -y nginx

# 安装node环境
ADD https://nodejs.org/dist/v6.2.0/node-v6.2.0-linux-x64.tar.gz  /opt/
WORKDIR /opt
RUN ln -s node-v6.2.0-linux-x64 nodejs
ENV PATH /opt/nodejs/bin:$PATH
RUN apt-get install -y python node-gyp
RUN npm install -g forever pm2 supervisor 
ENV NODE_PATH=/opt/node-v6.2.0-linux-x64/lib/node_modules


####################################
# 安装nodejs二进制模块
####################################
RUN apt-get install -y imagemagick ghostscript poppler-utils
RUN npm install -g ccap 

####################################
# 其他需要安装的软件------
####################################

# 删除cache
RUN rm -fr /var/lib/apt/lists/*

# 设置default
ADD locale.conf /etc/default/locale
RUN echo 'LANG="zh_CN.UTF-8"'  >> /etc/environment \
 && echo 'LANGUAGE="zh_CN:zh"' >> /etc/environment

CMD echo "hello world"

