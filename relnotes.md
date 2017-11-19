### Build script
- Python modules update: pip freeze is seriously broken. Always use pip install -U. setuptools wasn't updated at all due to pip freeze shortcomings. Also Scons 3.0.1 wasn't picked up despite being live on Pypi.
- Python modules: wheel is no longer needed.
### Build script documentation
- Workaround a pywin32 installer bug.
- Updating setuptools preloaded with Python allows for successful installation of Scons via Pypi without having to install wheel.