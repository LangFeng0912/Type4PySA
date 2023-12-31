# FROM --platform=linux/amd64 ubuntu

FROM nvidia/cuda:11.0.3-cudnn8-runtime-ubuntu20.04

# WORKDIR /maindir
# COPY train_model.sh /maindir/
# RUN chmod +x /maindir/train_model.sh
# ENTRYPOINT ["/maindir/train_model.sh"]

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# RUN apt-get purge libappstream3
RUN apt-get update

# python 3.8 installed by one of the following packages
# install packages needed
RUN apt-get install -y vim
RUN apt-get install -y wget
RUN apt-get install unzip
RUN apt-get install -y git
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt install -y expect

RUN apt-get install -y python3-distutils

# Watchman dependencies
RUN apt install -y libgoogle-glog0v5 libboost-context1.71.0 libdouble-conversion3 libevent-2.1-7 libsnappy1v5

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

RUN pip --version

RUN apt-get install -y libssl-dev

# download watchman
RUN wget https://github.com/facebook/watchman/releases/download/v2022.12.12.00/watchman_ubuntu20.04_v2022.12.12.00.deb
RUN dpkg -i watchman_ubuntu20.04_v2022.12.12.00.deb
RUN apt-get -f -y install
RUN watchman version

# RUN apt install -y python3.8-venv
# RUN python3 -m venv py38
# RUN /bin/bash -c "source py38/bin/activate"
RUN git clone https://github.com/facebook/pyre-check.git

# The current model files are pickled with the below ver. of sklearn
RUN pip install scikit-learn==0.24.1

# Install Annoy from a pre-built binary wheel to avoid weird SIGILL error on some systems
RUN pip install https://type4py.com/pretrained_models/annoy-wheels/annoy-1.17.0-cp38-cp38-linux_x86_64.whl

# RUN pip install protobuf==3.20.0

# For production env., install ONNXRuntime with GPU support
# RUN pip install onnx==1.10 onnxruntime==1.10 onnxruntime-gpu==1.10

RUN pip install --upgrade pip
RUN pip install setuptools-rust

# install libsa4py
# RUN git clone -b dev-lang https://github.com/saltudelft/libsa4py.git
RUN git clone https://github.com/LangFeng0912/libsa4py.git
RUN pip install -r libsa4py/requirements.txt
RUN pip install libsa4py/

# install type4py
RUN git clone https://github.com/LangFeng0912/type4py.git
RUN pip install type4py/

RUN python3 -c "import nltk; nltk.download('stopwords')"
RUN python3 -c "import nltk; nltk.download('wordnet')"
RUN python3 -c "import nltk; nltk.download('omw-1.4')"
RUN python3 -c "import nltk; nltk.download('averaged_perceptron_tagger')"

RUN git clone https://github.com/LangFeng0912/build_MTV0.8.git
RUN pip install -r build_MTV0.8/requirements.txt
RUN pip install build_MTV0.8/

# download dataset
RUN wget https://zenodo.org/record/8255564/files/ManyTypes4PyV8.tar.gz?download=1
RUN tar -xzvf ManyTypes4PyV8.tar.gz\?download\=1


 WORKDIR /maindir
 COPY train_model.sh /maindir
 RUN chmod +x /maindir/train_model.sh
 ENTRYPOINT ["/maindir/train_model.sh"]
