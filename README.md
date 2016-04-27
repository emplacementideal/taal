What is Taal?
=============

Taal is a Docker image that provides several command-line data science tools.

This is useful when one does not or can not install these tools on their computer. This is also a way to ensure
a team works with the same versions of the tools and that newcomers will have their work environment ready in minutes.

Available Tools
===============

Taal provides the following tools:

Data Retrieval
--------------

* [cURL](http://curl.haxx.se/)
* [HTTPie](https://github.com/jkbrzt/httpie)
* wget

Data Manipulation
-----------------

* [csvkit](https://github.com/onyxfish/csvkit) (including connectors for MySQL and PostgreSQL)
* [csvfix](http://neilb.bitbucket.org/csvfix/)
* [GDAL](http://www.gdal.org/)
* [jq](https://stedolan.github.io/jq/)

Archive Management
------------------

* bzip2
* gzip
* tar
* unzip

Encoding Management
-------------------

* iconv
* [uchardet](https://github.com/BYVoid/uchardet)

Taal being based on [Alpine Linux](https://hub.docker.com/_/alpine/), it also provides general purpose Unix commands that can be used for data science such as `head` or `iconv`.

Getting Started
===============

Taal being a Docker image, a Docker environment is needed to use it. Please see
[Docker documentation](https://docs.docker.com/) for instructions.

In order to run a container the Taal Docker image must be pulled from Docker Hub:

    $ docker pull pentimentolabs/taal
    
A container can then be run:

    $ docker run -it pentimentolabs/taal
    
Special Folders
===============

It is often useful to share with Taal things stored on the host computer such as data and scripts. There are several special folders for that purpose:

* `/root/data`: Data.
* `/root/supplies`: Anything that could be useful to your scripts such as database schemas and templates.
* `/root/toolbox`: Scripts and binaries. They will be automatically added to the `$PATH`.
* `/root/workbench`: Recipes and intermediary files.
    
Local folders can be easily mounted to these mount points thanks to Docker volumes:

    $ docker run -it -v `pwd`/data:/root/data -v `pwd`/supplies:/root/supplies -v `pwd`/scripts:/root/toolbox -v `pwd`/workbench:/root/workbench pentimentolabs/taal

This command being quite verbose you might want to abstract it in a script or a Makefile.

License
=======

Copyright 2016 Pentimento

*Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at*

*[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)*

*Unless required by applicable law or agreed to in writing, software   distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.*
