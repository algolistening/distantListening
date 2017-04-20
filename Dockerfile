FROM continuumio/anaconda3

RUN apt-get update && apt-get install -qqy \
        pkg-config \
        build-essential \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libavresample-dev \
        fftw3-dev \
        libfreetype6-dev \
        wget \
        git \
        curl \
        vim \
		gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-ugly \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# TensorFlow
ENV TENSORFLOW_VERSION 1.0.0
RUN pip install tensorflow==$TENSORFLOW_VERSION 

# This tends to break builds at unknown times so don't update
# RUN conda update conda; conda update --all

# ffmpeg and LibRosa
RUN conda install -c conda-forge ffmpeg librosa

COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly:
# https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# tensorboard
EXPOSE 6006

# jupyter
EXPOSE 8888
EXPOSE 8889

# X11
ENV DISPLAY :0

WORKDIR "/notebooks"

CMD ["sh", "/run_jupyter.sh"]
