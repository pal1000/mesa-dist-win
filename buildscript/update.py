import pip
from subprocess import call
packages = [dist.project_name for dist in pip.get_installed_distributions()]
call("python -m pip install --upgrade " + ' '.join(packages), shell=True)
