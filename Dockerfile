
#A Dockerfile with Apache webserver
FROM httpd

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y curl && \
    apt-get install -y tree && \
    apt-get install -y unzip

# COPY is used to copy local files into the container.
# ADD is used to copy files local & remote into the container ... equivalent to wget in Linux.

WORKDIR /usr/local/apache2/htdocs
ADD  https://linux-devops-course.s3.amazonaws.com/WEB+SIDE+HTML/covid19.zip .
RUN unzip covid19.zip && \
    cp -R covid19/* . && \
    rm -rf covid19.zip && \
    rm -rf covid19
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]

#docker build -t cyd .
#docker images | grep cyd
#docker run -itd --name httpd_cyd --rm -p 360:80 cyd

# docker ps -a | grep s4gil
# cyd:latest needs to change... we need to rename to suit our dockerhub account
# docker tag cyd:latest gache001/cyd_project:v1.0.0 (dockerhub username/reponame:tag)

# docker login
# docker push gache001/cyd_project:v1.0.0 (or image ID)