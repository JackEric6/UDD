# PKU SFM Semantic Dataset(PSSD)

## 0.Dataset
### 0.1 Dataset Overview
北大4000*3000的低空航拍图像,共计288张(m1)，目前共有三个语义类。

**Class Definitions**

|Class|Gt Label|
|------|------|
|Tree  |  0   |
|Building |  1   |
|Ground  |  2   |

now the 3 classes Dataset is on air. See Download Link below.

*数据集示例：*
![src image](img/DJI_0285.JPG)
![visualization of gt](img/DJI_0285_visual_gt.png)

### 0.2 Download Link
[m1-288.rar](https://pan.baidu.com/s/1sbDrPlgH5SRNjJgHc4AqTA)
[m1-train200-val40-test48.rar](https://pan.baidu.com/s/15DvvM0AxWiNIHcyTRrhtcA)


## 1.Labeling Policy (instruction included)
### 1.0  Tree
- 1、 enter photo shop，press alt+F9 to open Action menu，load action script tree.atn
![selection](img/action.png)
- 2、 open the src url, and press CTRL+F2，a raw mask of tree would be generated
![selection](img/selection.png)

- 3、 adjust the selected area by hand(lasso is recommended, just press shift/alt and drag the mouse)
- 4、 then press CTRL+F3 to generate bitmap, save it by "_t.png" suffix，"DJI_0285_t.png",e.g.

*Annotation example*
![tree](img/DJI_0285_t.png)

**[Chinese version of annotation instruction](tree.pdf)**

### 1.1 Building
- 1、 新建空白图层，通过多边形套索，选取每个建筑，将其填充为黑色
- 2、 所有建筑标注完成后，点击图像->模式->灰度，再点击图像->模式->位图，选择"50%阈值"，生成位图，保存为原文件名+"_b.png"，例如"DJI_0285_b.png"

*标注结果示例：*
![建筑](img/DJI_0285_b.png)

## 2. 命名规则

**/src**  ```原图```

**/gt**  ```ground truth```

**/gt_class** ```groundtruth分类别结果```

**/ori**  ```标注类别结果(经过标注的"_t.png"，"_b.png"都放置在此目录下)```

**/visualization** ```可视化结果```
```
文件名可任意命名，只需要和main.m中的env路径一致即可
```


## 3. 标注处理脚本

- ### [main.m](script/main.m)
处理标注结果，可自定义语义标签规则。

- ### [gtVisual.m(function，通过main调用)](script/gtVisual.m)
此函数的参数：
```
visual_mode = 0; %是否运行此脚本
visual_resizerate=0.25; %对于原图可视化时间过长，可以resize较小尺寸看效果
visual_writemode = 0; %是否要保存visualization的结果
```
- ### [gtSplit.m(function，通过main调用)](script/gtSplit.m)
此函数的参数：
```
split_mode = 1; %是否运行此脚本
split_visualmode = 0;  %是否可视化
```

- ### [visualization.m](script/visualization.m)
执行完main生成visualizati_gt的数据后可运行此脚本看标注效果
此函数的参数：
```
view_mode = 1; % 0 automatic, 1 manual
```

## 4. ***致谢***
感谢对数据集构建做出贡献的朋友们（排名不分先后，且不一定全）：邓枭、顾友鹏、郭健元、侯忱、金朝、宋博宁、王尧、文佑尔、姚洋、易康睿、周昊天。
