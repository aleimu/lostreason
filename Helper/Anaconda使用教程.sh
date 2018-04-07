Anaconda使用教程


# 创建一个名为python34的环境，指定Python版本是3.4（不用管是3.4.x，conda会为我们自动寻找3.4.x中的最新版本）
conda create --name python34 python=3.4
 
# 安装好后，使用activate激活某个环境
activate python34 # for Windows
source activate python34 # for Linux & Mac
# 激活后，会发现terminal输入的地方多了python34的字样，实际上，此时系统做的事情就是把默认2.7环境从PATH中去除，再把3.4对应的命令加入PATH
 
# 此时，再次输入
python --version
# 可以得到`Python 3.4.5 :: Anaconda 4.1.1 (64-bit)`，即系统已经切换到了3.4的环境
 
# 如果想返回默认的python 2.7环境，运行
deactivate python34 # for Windows
source deactivate python34 # for Linux & Mac
 
# 删除一个已有的环境
conda remove --name python34 --all


# 安装scipy
conda install scipy
# conda会从从远程搜索scipy的相关信息和依赖项目，对于python 3.4，conda会同时安装numpy和mkl（运算加速的库）
 
# 查看已经安装的packages
conda list
# 最新版的conda是从site-packages文件夹中搜索已经安装的包，不依赖于pip，因此可以显示出通过各种方式安装的包

# 查看当前环境下已安装的包
conda list
 
# 查看某个指定环境的已安装包
conda list -n python34
 
# 查找package信息
conda search numpy
 
# 安装package
conda install -n python34 numpy
# 如果不用-n指定环境名称，则被安装在当前活跃环境
# 也可以通过-c指定通过某个channel安装
 
# 更新package
conda update -n python34 numpy
 
# 删除package
conda remove -n python34 numpy

# 更新conda，保持conda最新
conda update conda
 
# 更新anaconda
conda update anaconda
 
# 更新python
conda update python
# 假设当前环境是python 3.4, conda会将python升级为3.4.x系列的当前最新版本

# 在当前环境下安装anaconda包集合
conda install anaconda
 
# 结合创建环境的命令，以上操作可以合并为
conda create -n python34 python=3.4 anaconda
# 也可以不用全部安装，根据需求安装自己需要的package即可




常用命令：

1、查看这个环境下的包列表
conda list

2、查看Anaconda和Python版本号
win健+R（或者点开始菜单-运行-输入cmd-按回车）打开命令提示符 
命令：conda --version 和 python --version查看版本号

查看你现在所在的版本分支
命令：conda info --e

3、更新Anaconda版本
conda update conda
conda update --all
conda update scikit-learn -y

4、添加Anaconda的TUNA镜像-配置下载源
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

5、设置搜索时显示通道地址
conda config --set show_channel_urls yes

6、在Windows cmd命令行中升级pip
python -m pip install --upgrade pip

7、解决from keras.models import Sequential的命令：（顺便安装了theano 0.9.0版本）
pip install keras2pmml

8、安装tensorflow
conda install --channel https://conda.anaconda.org/conda-forge tensorflow 或者 pip install tensorflow-gpu （GPU版本 Python3.5）
pip install --upgrade --ignore-installed https://storage.googleapis.com/tensorflow/windows/cpu/tensorflow-0.12.0rc0-cp35-cp35m-win_amd64.whl （CPU版本 ython3.5）
pip install --upgrade https://storage.googleapis.com/tensorflow/windows/cpu/tensorflow-0.12.1-cp35-cp35m-win_amd64.whl （CPU版本 Python3.5）

9、安装theano
conda install --channel https://conda.anaconda.org/ideas theano （方式一）
pip install theano	（方式二）
conda install theano pygpu	（Anaconda安装方式）

10、安装sqlite3 数据库
conda install --channel https://conda.anaconda.org/maxwell-k sqlite3

11、创建一个名为python35的环境，指定Python版本是3.5（不用管是3.5.x，conda会为我们自动寻找3.5.x中的最新版本）
命令：conda create --name py35 python=3.5 
激活环境： activate py35
移除环境： conda remove -n py35 --all
切换回root分支： Windows: deactivate

12、安装未知包搜索步骤

例：查找seaborn的包

anaconda search -t conda seaborn
anaconda show rahuketu86/seaborn
conda install --channel https://conda.anaconda.org/joshadel seaborn

13、安装小波工具箱库
conda install --channel https://conda.anaconda.org/SciTools pywavelets

Python2.7 兼容Python3.0调用函数
from _future_ import print_function

14 安装离线安装包
win10下面已经编译好的xgboost，可直接通过命令行转到xgboost\python-package文件夹，然后输入python setup.py install安装，然后在python环境中输入Import xgboost验证。

15、安装missingno
conda install --channel https://conda.anaconda.org/conda-forge missingno 
16、安装imblearn
conda install -c glemaitre imbalanced-learn



