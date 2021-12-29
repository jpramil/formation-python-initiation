#!/bin/sh

SECTION=$1
CHAPTER=$2

WORK_DIR=/home/jovyan/work
CLONE_DIR=${WORK_DIR}/repo-git
COURSE_DIR=${CLONE_DIR}/course
FORMATION_DIR=${WORK_DIR}/formation

# Clone course repository
REPO_URL=https://github.com/InseeFrLab/formation-python-initiation.git
git clone --depth 1 $REPO_URL $CLONE_DIR

# Convert .md to .ipynb
pip install python-frontmatter jupytext
python $CLONE_DIR/utils/md-to-ipynb.py $COURSE_DIR/${SECTION}/${CHAPTER}/tutorial.md

# Put relevant notebook in the training dir
mkdir $FORMATION_DIR
cp ${COURSE_DIR}/${SECTION}/${CHAPTER}/tutorial.ipynb ${FORMATION_DIR}/

# Give write permissions
chown -R jovyan:users $FORMATION_DIR/

# If there is a solutions file, put in the training dir
SOLUTIONS_FILE=${COURSE_DIR}/${SECTION}/${CHAPTER}/solutions.py
[ -f $SOLUTIONS_FILE ] && cp $SOLUTIONS_FILE ${FORMATION_DIR}/

# Install additional packages if needed
REQUIREMENTS_FILE=${COURSE_DIR}/${SECTION}/${CHAPTER}/requirements.txt
[ -f $REQUIREMENTS_FILE ] && pip install -r $REQUIREMENTS_FILE

# Remove course Git repository
rm -r $CLONE_DIR

# Open the relevant notebook when starting Jupyter Lab
echo "c.LabApp.default_url = '/lab/tree/formation/tutorial.ipynb'" >> /home/jovyan/.jupyter/jupyter_server_config.py
