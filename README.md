What is Taal?
=============

Taal is a Docker image that provides several command-line data science tools.

This is useful when one does not or can not install these tools on their computer. This is also a way to ensure
a team works with the same versions of the tools and that newcomers will have their work environment ready in minutes.

Taal provides the following tools:

* [csvkit](https://github.com/onyxfish/csvkit)
* [csvfix](http://neilb.bitbucket.org/csvfix/)
* [GDAL](http://www.gdal.org/)
* [gnuplot](http://www.gnuplot.info/)
* [HTTPie](https://github.com/jkbrzt/httpie)
* [jq](https://stedolan.github.io/jq/)
* [uchardet](https://github.com/BYVoid/uchardet)

Taal being based on Debian, it also provides general purpose Unix commands that can be used for data science
such as `head` or `iconv`.

Getting Started
===============

Taal being a Docker image, a Docker environment is needed to use it. Please see
[Docker documentation](https://docs.docker.com/) for instructions.

In order to run a container the Taal Docker image must be pulled from Docker Hub:

    $ docker pull emplacementideal/taal
    
A container can then be run:

    $ docker run -it emplacementideal/taal
    
A local folder can be mounted to share data and scripts with the container:

    $ docker run -it -v `pwd`/data:/data emplacementideal/taal
