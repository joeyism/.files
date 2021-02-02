#!/bin/bash
alias pipr="pip install --user -r requirements.txt"
alias pip3r="pip3 install --user -r requirements.txt"
alias pipu="pip install --user"
alias pip3u="pip3 install --user"
alias ho="honcho -e .env run "
alias rm_pycache='find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf'
python_publish(){
    m2r README.md
    python3 setup.py sdist bdist_wheel
    twine check dist/*
    twine upload dist/*
    VERSION=$(cat $(find **/__init__.py) | egrep '^__version__\s*=\s*"(.*)"' | cut -d '"' -f2)
    git tag $VERSION
    git push --tag origin master
}
venv(){
  venv3 $@
}
venv3(){
  if [ ! -d "./venv" ]; then
    virtualenv venv -p python3 $@
  fi
  source venv/bin/activate $@
}
venv38(){
  if [ ! -d "./venv" ]; then
    virtualenv venv -p python3.8 $@
  fi
  source venv/bin/activate $@
}
venv-jupyter(){
  python -m ipykernel install --user --name=venv
}
_venv_select(){
    if [ -d "./venv" ]; then
        find venv -type f -follow -print | grep "^activate\|activate$"
    fi
}
venvselect(){
    if [ $# -eq 0 ]; then
        select activate in $(find venv -type f -follow -print | grep "^activate\|activate$" | sort);
        do  
            source $activate
            break
        done
    else
        source $@
    fi
    activate=${activate/venv\//}
    activate=${activate/\/bin\/activate/}
    echo "PACKAGE_PATH=$activate"
    PACKAGE_PATH=$activate
}
complete -W "$(_venv_select)" venvselect
py-replace(){
    if [ $# -eq 0 ]; then
        echo py-replace SEARCH REPLACE
    else
        find . -name '*.py' -exec sed -i -e "s/$1/$2/g" {} \;
    fi
}
