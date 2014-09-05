yum -y install zlib-devel openssl-devel cpio expat-devel gettext-devel gcc

present_directory=$(pwd)
cd /tmp
wget https://jacderida-software.s3.amazonaws.com/ExtUtils-MakeMaker-6.98.tar.gz
tar xfv ExtUtils-MakeMaker-6.98.tar.gz
cd ExtUtils-MakeMaker-6.98
perl Makefile.PL
make && make install
cd /tmp
rm ExtUtils-MakeMaker-6.98.tar.gz
rm -rf ExtUtils-MakeMaker-6.98

wget http://git-core.googlecode.com/files/git-1.7.12.tar.gz
tar xfv git-1.7.12.tar.gz
cd git-1.7.12
./configure
make && make install
cd /tmp
rm git-1.7.12.tar.gz
rm -rf git-1.7.12
cd $present_directory
