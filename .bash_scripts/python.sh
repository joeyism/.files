#!/bin/bash
alias pipr="pip install --user -r requirements.txt"
alias pip3r="pip3 install --user -r requirements.txt"
alias pipu="pip install --user"
alias pip3u="pip3 install --user"
alias ho="honcho -e .env run "
alias rm_pycache='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'
python_publish(){
    m2r README.md
    python setup.py sdist bdist_wheel
    twine check dist/*
    twine upload dist/*
}
venv(){
  if [ ! -d "./venv" ]; then
    virtualenv venv $@
  fi
  source venv/bin/activate $@
}
venv3(){
  if [ ! -d "./venv" ]; then
    virtualenv venv -p python3 $@
  fi
  source venv/bin/activate $@
}
