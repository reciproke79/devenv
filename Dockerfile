# Install Centos with pathogen and YouCompleteMe

FROM       centos:latest
MAINTAINER Mario Eidher <mario.eidher@gmail.com>

ARG user=root
ARG homedir=/root

# Install required yum packages
RUN yum update -y && yum install -y vim \
  automake \
  cmake \
  gcc \
  gcc-c++ \
  git \
  kernel-devel \
  make \
  python-devel \
  python3-devel \
  ruby \
  xterm

# Setup user
#RUN useradd -d $HOMEDIR $user

# Install pathogen
USER $user
WORKDIR $homedir

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

COPY files/vimrc $homedir/.vimrc

# Install syntastic
RUN cd ~/.vim/bundle && \
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git

# Install vim syntax files
RUN git clone git://github.com/vim-ruby/vim-ruby.git ~/.vim/bundle/vim-ruby

# Install YouCompleteMe

WORKDIR $homedir/.vim/bundle
RUN git clone https://github.com/Valloric/YouCompleteMe.git

WORKDIR YouCompleteMe
RUN git submodule update --init --recursive
RUN ./install.py
