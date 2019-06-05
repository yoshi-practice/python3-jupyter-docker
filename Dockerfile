FROM python:3.7

RUN apt-get update && apt-get install -y \
    libblas-dev \
	liblapack-dev\
    libatlas-base-dev \
    mecab \
    mecab-naist-jdic \
    libmecab-dev \
	gfortran \
    libav-tools \
    python3-setuptools

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install TensorFlow(CPU)
ENV TENSORFLOW_VERSION 1.5.0
RUN pip --no-cache-dir install \
    http://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp36-cp36m-linux_x86_64.whl

# Install Python library
RUN pip --no-cache-dir install \
        keras \
        sklearn \
        jupyter \
        ipykernel \
		scipy \
        simpy \
        matplotlib \
        numpy \
        pandas \
        plotly \
        sympy \
        mecab-python3 \
        librosa \
        Pillow \
        h5py \
        google-api-python-client \
        && \
    python -m ipykernel.kernelspec

ENV CONFIG /root/.jupyter/jupyter_notebook_config.py
ENV CONFIG_IPYTHON /root/.ipython/profile_default/ipython_config.py 

RUN jupyter notebook --generate-config --allow-root && \
    ipython profile create

RUN echo "c.NotebookApp.ip = '*'" >>${CONFIG} && \
    echo "c.NotebookApp.open_browser = False" >>${CONFIG} && \
    echo "c.NotebookApp.iopub_data_rate_limit=10000000000" >>${CONFIG} && \
    echo "c.MultiKernelManager.default_kernel_name = 'python3'" >>${CONFIG} 

RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >>${CONFIG_IPYTHON} 

COPY notebooks /notebooks

EXPOSE 8888 6006 

VOLUME /notebooks

WORKDIR "/notebooks"
CMD ["jupyter","notebook", "--allow-root"]
