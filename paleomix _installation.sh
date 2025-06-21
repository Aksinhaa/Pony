


## To install PALEOMIX using conda:
curl -fL https://github.com/MikkelSchubert/paleomix/releases/download/v1.3.7/paleomix_environment.yaml > paleomix_environment.yaml
conda env create -n paleomix -f paleomix_environment.yaml

#Activate the env: 
conda activate paleomix

PALEOMIX requires that the Picard JAR file , so we can symlink the versions in your conda environment into the correct place:

(paleomix) mkdir -p ~/install/jar_root/
(paleomix) ln -s ~/*conda*/envs/paleomix/share/picard-*/picard.jar ~/install/jar_root/

# OR 

## To install PALEOMIX using pip in a conda env:
conda create -n paleomix_env python=3.8
conda activate paleomix_env

## Install compiled dependencies via Conda:
conda install -c conda-forge zlib bzip2 xz libffi python-devtools

##  Install PALEOMIX v1.3.7 via pip:
pip install paleomix==1.3.7

## Confirm it's installed:
paleomix

## NOTE: If you use pip to install PALEOMIX , you will need to install its dependencies like AdapterRemoval, BWA etc. separately in the same conda-env. 

# For example, to install AdapterRemoval in the same env:
conda install -c bioconda adapterremoval
# This will make AdapterRemoval available in your environment, and PALEOMIX will detect it.
# Just like this, install all the dependencies listed above in the "Requirements", using the following commands:

conda install -c bioconda samtools=1.3.1
# After installation, verify the version by running:
samtools --version

conda install -c bioconda bwa=0.7.17
# To verify the installation, you can run:
bwa

conda install -c conda-forge openjdk=17
# After installation, verify the Java version:
java -version
