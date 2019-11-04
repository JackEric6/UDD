%% Visualize ground truth
% mask_or_color
% 0: ���ӻ�����ͼ
% 1: ���ӻ�ԭͼ�ɰ�
%% Label definition
%----------------------------------------%
% 0: vegetation ֲ�� imgT ��׺��_t.png
% 1: building ���� imgB ��׺��_b.png
% 2: road ��· imgR ��׺��_r.png
% 3: vehicle ���� imgV ��׺��_v.png
% 13: other ����
%----------------------------------------%
%%
function out = gtVisual(gt_uri, src_uri, output_uri,mask_or_color, resize_rate)
    display(['%processing ' gt_uri]);
    %%parameters
    %expansion_times = 0;

    %----------------------------------------%
    gtI = imread(gt_uri);
    visualI = imread(src_uri);
    if length(size(gtI))==3
        gtI = rgb2gray(gtI);
    end
    
    %----------------------------------------%
    gtI = imresize(gtI,resize_rate);
    visualI = imresize(visualI,resize_rate);
    
    %if max(gtImg(:))==1
    %    gtImg = uint8(gtImg).*255;
    %end
    %if expansion_times>0
    %    gtImg = expand(gtImg,128,expansion_times);
    %end
    %----------------------------------------%
    [m n]=size(gtI);
    if mask_or_color == 0 % generate color
        for i = 1:m
            for j = 1:n;
                if gtI(i,j) == 0 %tree  green
                    visualI(i,j,1) = 0;
                    visualI(i,j,2) = 255;
                    visualI(i,j,3) = 0;
                elseif gtI(i,j) == 1 %building  red
                    visualI(i,j,1) = 255;
                    visualI(i,j,2) = 0;
                    visualI(i,j,3) = 0;
                elseif gtI(i,j) == 2 %road  blue
                    visualI(i,j,1) = 0;
                    visualI(i,j,2) = 0;
                    visualI(i,j,3) = 255;
                 elseif gtI(i,j) == 3 %vehicle  yellow
                    visualI(i,j,1) = 255;
                    visualI(i,j,2) = 255;
                    visualI(i,j,3) = 0;
                 else
                    visualI(i,j,1) = 128;
                    visualI(i,j,2) = 128;
                    visualI(i,j,3) = 128;
                end
            end
        end
    else % generate mask
        for i = 1:m
            for j = 1:n;
                if gtI(i,j) == 0 %tree  green
                    %visualI(i,j,1) = 0;
                    visualI(i,j,2) = visualI(i,j,2) + 64;
                    %visualI(i,j,3) = 0;
                elseif gtI(i,j) == 1 %building  red
                    visualI(i,j,1) = visualI(i,j,1) + 64;
                    %visualI(i,j,2) = 0;
                    %visualI(i,j,3) = 0;
                elseif gtI(i,j) == 2 %road  blue
                    %visualI(i,j,1) = 0;
                    %visualI(i,j,2) = 0;
                    visualI(i,j,3) = visualI(i,j,3) + 64;
                 elseif gtI(i,j) == 3 %car  yellow
                    visualI(i,j,1) = visualI(i,j,1) + 48;
                    visualI(i,j,2) = visualI(i,j,2) + 48;
                    %visualI(i,j,3) = 0;
                else %other grey
                    visualI(i,j,1) = visualI(i,j,1) + 32;
                    visualI(i,j,2) = visualI(i,j,2) + 32;
                    visualI(i,j,3) = visualI(i,j,3) + 32;
                end
            end
        end
    end
    imwrite(visualI,output_uri);
end