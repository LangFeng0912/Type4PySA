# Type4PySA
an augmented Type4Py with static analysis

## Docker Implementation

### build docker
```python
docker build -t t4pysa .
```

### run docker with gpu & memory
```python
docker run -it --gpus all --shm-size=32gb -v pretrainedresults:/results t4pysa -l 128 -j 8 
```


### Type4Py training pipeline
please refer to [Type4Py Github](https://github.com/LangFeng0912/type4py)