
clc; close all; clear all;
load Seq0102_ground_truth % ground truth label of sequence0102 in MAD dataset
Methodset = 'Beyond_Joints'; %'MAR' is the proposed method in the paper, 'Beyond_Joints' is the method proposed in the reference 
%'Beyond_Joints: Learning Representations From Primitive Geometries for Skeleton-Based Action Recognition and Detection'
switch Methodset
            case 'MAR'
                load('MAR_mad_s0102.mat')
                predict_frame_label=Pre_frame_label;
            case 'Beyond_Joints'
                load('Beyond_Joints_mad_results010102.mat')
                predict_frame_label=Pre_frame_label_mad02;
end
              
[apre,bpre]=find(predict_frame_label==0);
predict_frame_label(:,bpre)=36;
labelfordetection=frame_label(1,1:size(predict_frame_label,2));
labelfordetection=labelfordetection';
[a,b]=find(labelfordetection==1000);
labelfordetection(a,:)=36;
[a1,b1]=find(labelfordetection==1001);
labelfordetection(a1,:)=36;

Label=unique(labelfordetection);
t=1;
for i=1:size(Label,1)
    
    [aind,bind]=find(labelfordetection==Label(i));
    if i>1 & i<size(Label,1)
        gtlabE(t,1)=36;   
        gtlabE(t,2)=aind(1)-previousind(end)-1;
        gtlabE(t,3)=1;
        gtlabE(t,4)=1;
        t=t+1;
        gtlabE(t,1)=Label(i); 
        gtlabE(t,2)=length(aind);
        gtlabE(t,3)=1;
        gtlabE(t,4)=1;
        t=t+1;
    elseif i==size(Label,1)
         gtlabE(t,1)=36; 
         gtlabE(t,2)=size(labelfordetection,1)-previousind(end);
         gtlabE(t,3)=1;
         gtlabE(t,4)=1;   
    else
        gtlabE(t,1)=36;   
        gtlabE(t,2)=aind(i)-1;
        gtlabE(t,3)=1;
        gtlabE(t,4)=1;
        t=t+1;    
        gtlabE(t,1)=Label(i); 
        gtlabE(t,2)=length(aind);
        gtlabE(t,3)=1;
        gtlabE(t,4)=1;
        t=t+1;   
    end
    previousind=aind;
end
tslab=predict_frame_label(1,1:end); % test frame-based labels produced by SVM+DP (baseline)
thr=0.5; % overlap threshold between a true event and a detect event
Result= funEvalDetection(gtlabE, tslab, thr);