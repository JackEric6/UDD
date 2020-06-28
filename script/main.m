
%% Label definition
%----------------------------------------%
% 0: vegetation ֲ�� imgT ��׺��_t.png ��ɫ:107,142,35
% 1: building �������Ľ��� imgB ��׺��_b.png ��ɫ:102,102,156
% 2: road ��· imgR ��׺��_r.png ��ɫ:128,64,128
% 3: vehicle ���� imgV ��׺��_v.png ��ɫ:0,0,142
% 4: root ���� imgRoof ��׺��_roof.png ��ɫ:70,70,70
% 5: other ���� ��ɫ:0,0,0
%----------------------------------------%
% δ��������չ��������
% ���ֳ� motor / bicycle
% ���� pedestrian
% �˶��� pitch
% ���߸� pole
%----------------------------------------%
%% Envs setup
path='G:\Dataset\rawUDDnew\';
srcpath=[path 'src\'];
oripath=[path 'ori\'];
gtpath=[path 'gt\'];
visualpath=[path 'visualization\'];
classpath=[path 'gt_class\'];

visual_mode = 1; %�Ƿ�����visual�ű�
visual_resizerate=0.25; %����ԭͼ���ӻ�ʱ�����������resize��С�ߴ翴Ч��
split_mode = 0; %�Ƿ�����split�ű���1���У�0������
split_visualmode = 0;  %�Ƿ���ӻ�split�����1���п��ӻ���0�����п��ӻ� 
src_prefix = '.JPG';

%% Main function
listing = dir([srcpath '*' src_prefix]);
imgSum = length(listing);
for imgNum = 1:imgSum
    imgORI_uri = [srcpath listing(imgNum).name];
    fileName = strrep(listing(imgNum).name,src_prefix,'');
    imgB_uri = [oripath fileName '/' fileName '_b.png'];
    imgRoof_uri = [oripath fileName '/' fileName '_roof.png'];
    imgT_uri = [oripath fileName '/' fileName '_t.png'];
    imgV_uri = [oripath fileName '/' fileName '_v.png'];
    imgR_uri = [oripath fileName '/' fileName '_r.png'];

    imgGT_uri = [gtpath strrep(listing(imgNum).name,src_prefix,'.png')];
   
    imgVIS_uri = [visualpath strrep(listing(imgNum).name,src_prefix,'_visual_mask.png')];
    imgVIS_uri2 = [visualpath strrep(listing(imgNum).name,src_prefix,'_visual_color.png')]; 
    imgCLASS_uri = [classpath strrep(listing(imgNum).name,src_prefix,'')];
    
    %read original pic
    imgORI = imread(imgORI_uri);
    if length(size(imgORI))==3
        imgORI = rgb2gray(imgORI);
    end
    [m,n] = size(imgORI);
    
    % set ground truth
    imgGT = uint8(zeros(m,n));

    if exist(imgB_uri,'file')
        imgB = imread(imgB_uri);
        if length(size(imgB))==3
            imgB = rgb2gray(imgB);
        end
        imgB = imresize(imgB,[m n]);
        imgB = bwmorph(imgB,'close');
        imgGT = imgGT + uint8(~imgB .* 1); % building
    end
    if exist(imgR_uri,'file')
        imgW = imread(imgR_uri);
        if length(size(imgW))==3
            imgW = rgb2gray(imgW);
        end
        imgW = imresize(imgW,[m n]);
        imgW = bwmorph(imgW,'close');
        imgGT = imgGT + uint8(~imgW .* 2); % road
    end
    if exist(imgT_uri,'file')
        imgT = imread(imgT_uri);
        if length(size(imgT))==3
            imgT = rgb2gray(imgT);
        end
        imgT = imresize(imgT,[m n]);
        imgT = bwmorph(imgT,'close');
        imgGT = imgGT + uint8(~imgT .* 4); % tree
    end
    if exist(imgV_uri,'file')
        imgV = imread(imgV_uri);
        if length(size(imgV))==3
            imgV = rgb2gray(imgV);
        end
        imgV = imresize(imgV,[m n]);
        imgV = bwmorph(imgV,'close');
        imgGT = imgGT + uint8(~imgV .* 8); % vehicle
    end
    if exist(imgRoof_uri,'file')
        imgRoof = imread(imgRoof_uri);
        if length(size(imgRoof))==3
            imgRoof = rgb2gray(imgRoof);
        end
        imgRoof = imresize(imgRoof,[m n]);
        imgRoof = bwmorph(imgRoof,'close');
        imgGT = imgGT + uint8(~imgRoof .* 16); % roof
    end
    
    %----------------------------------------%
    %{
    %convert rgb to logical
    if length(size(imgB))==3
        imgB = rgb2gray(imgB);
        [m n] = size(imgB);
        if max(imgB(:))>1
            for i = 1:m
                for j = 1:n
                    if imgB(i,j) > 128
                        imgB(i,j) = 1;
                    elseif imgB(i,j) > 1
                        imgB(i,j) = 0;
                    end
                end
            end
            imgB = logical(imgB);
            %imwrite(imgB,imgB_uri);
        end
    end    
    [m n] = size(imgB);
    
    %----------------------------------------%
    %convert rgb to logical
    if length(size(imgT))==3
        imgT = rgb2gray(imgT);
        if max(imgT(:))>1
            for i = 1:m
                for j = 1:n
                    if imgT(i,j) > 128
                        imgT(i,j) = 1;
                    else
                        imgT(i,j) = 0;
                    end
                end
            end
            imgT = logical(imgT);
            imwrite(imgT,imgT_uri);
        end
    end
    %}
    %----------------------------------------%
    
    
    %class_number == 5
    imgGTout = uint8(zeros(m,n)); % 0 as vegetation
    for i = 1:m
       for j = 1:n
           if imgGT(i,j) > 15
               imgGTout(i,j) = 5; %roof
           elseif imgGT(i,j) > 7
               imgGTout(i,j) = 4; %vehicle
           elseif imgGT(i,j) > 3
               imgGTout(i,j) = 3; %vegetation
           elseif imgGT(i,j) > 1
               imgGTout(i,j) = 2; %road
           elseif imgGT(i,j) > 0
               imgGTout(i,j) = 1; %building(except for roof)
           else
               imgGTout(i,j) = 0; %other
           end
       end
    end

    % final output:
    imwrite(imgGTout,imgGT_uri);
    %----------------------------------------%
    if visual_mode
        gtVisual(imgGT_uri,imgORI_uri,imgVIS_uri, 0, visual_resizerate);
        gtVisual(imgGT_uri,imgORI_uri,imgVIS_uri2, 1, visual_resizerate);
    end
    if split_mode
        gtSplit(imgGT_uri,imgCLASS_uri,split_visualmode);
    end
end