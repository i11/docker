docker
======

Docker related files

CentOS:6.5
----------

Make sure you are running it as **root** and have **febootstrap** package installed.

```
cd centos65
./build_centos.sh
```

Import the built image
```
docker import - centos:6.5 < centos65.tar.xz
```
or

```
docker build .
```
Remove image file after the import
```
rm -f centos65.tar.xz
```
