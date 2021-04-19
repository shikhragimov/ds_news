###########################################################################################
### NVIDIA PART ###########################################################################
FROM tensorflow/tensorflow:latest-gpu-py3
MAINTAINER Marat Shikhragimov 

###########################################################################################
### BASE PART #############################################################################
RUN apt-get update && apt-get install -y apt-utils vim wget tmux curl gnupg git

RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

###########################################################################################
### JUPYTER ###############################################################################
# install and run jupyterhub
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
RUN pip3 install jupyterhub jupyter notebook jupyterlab virtualenv 

# jupyterlab extensions
RUN jupyter labextension install @jupyterlab/toc jupyterlab-drawio
RUN pip3 install jupyterlab_latex
RUN jupyter serverextension enable --sys-prefix jupyterlab_latex
RUN jupyter lab build

###########################################################################################
### OTHER #################################################################################
# install requirements
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

COPY . /app
WORKDIR /app

CMD ["bash", "-c", "jupyter lab --notebook-dir=/app --ip 0.0.0.0 --port 8888 --no-browser --allow-root"]
