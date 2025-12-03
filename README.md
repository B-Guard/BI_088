### Installation

Since we depend on the `starvers` package and it is not in PyPI, we have added it as a git submodule. To install all dependencies you need to run the following commands:

```bash
git submodule update --init --recursive
conda create --name dwh --file BI_Projects/DA_088/environment-dwh.yaml
conda activate dwh
cd starvers && pip install . && cd ..
```

Now everything should be set up correctly