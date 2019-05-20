#!/usr/bin/env bash
set -e

pip install --upgrade setuptools
pip install scikit_learn numpy matplotlib
pip install -U cuckoo

# install pdfrate - parser
cd /pdf_malware_parser
python setup.py install

# install pdf predictor - classifier
cd /mimicus
python setup.py develop
#python reproduction/FTC.py

# create mongo db & user


## running the classifier
#1. Create detection agent
/utils/detection_agent_server.py ./utils/36vms_sigs.pickle &
#
##2. Link classifier
/utils/generate_ext_genome.py pdfrate /data/correct_pdf/ 500
# 3.
python batch.py pdfrate /data/correct_pdf 50
