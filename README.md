# Type4PySA
an augmented Type4Py with static analysis

## Docker Implementation

### build docker
```python
docker build -t t4pysa .
```

### run docker with gpu & memory
```python
docker run -it --gpus all --shm-size=32gb t4pysa 
```


### docker preparation 
#### activate virtual environment
```python
source py38/bin/activate
```

#### install annoy
```python
pip install https://type4py.com/pretrained_models/annoy-wheels/annoy-1.17.0-cp38-cp38-linux_x86_64.whl
```

#### install type4py development mode
```python
pip install -e type4py/
```

#### unzip the datatset
```python
tar -xzvf ManyTypes4PyV8.tar.gz
```

### Type4Py training pipeline
please refer to [Type4Py Github](https://github.com/LangFeng0912/type4py)