clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*
%array generation 
a=1;
model = ModelUtil.create('Model');
comp1=model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',3);
model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']); %set the unit to um


%% genereate the main array

% setting the array parameters 
PostDiameter=21;
LateralGap=17;
DownstreamGap=17;
TiltRatio=42; %lateral displacement vs lateral movement per bump, or # of rows required to displace one post in column
ColumnNumber=3; %one side, we built the symmetric model about the center bypass channel to reduce the required calculation time, also this is the number of channel, the post number should be ColumnNumber-1
RowNumber=TiltRatio;
BypassChannelWidth=LateralGap;
LateralDisplacementPerRow=(DownstreamGap+PostDiameter)/TiltRatio;
% calculate the position of the main post 
% set the middle of by bypass channel to be (0,0), flow from top to bottom, and the model is built from bottom to top 

XPosFirstPost=BypassChannelWidth/2+PostDiameter/2;  %define the first post of the array
YPosFirstPost=PostDiameter/2;

wp2 = geom1.feature.create('wp2', 'WorkPlane');  %generate the workplane in which the post will be extruded from 
wp2.set('planetype', 'quick');
wp2.set('quickplane', 'xy');
Array=wp2.geom.selection().create("Array","CumulativeSelection");
for RN=1:1:RowNumber
    for CN=1:1:ColumnNumber
wp2.geom.feature.create("Post"+RN+CN,'Square');
wp2.geom.feature("Post"+RN+CN).set('size',PostDiameter/2*sqrt(2));
wp2.geom.feature("Post"+RN+CN).set('base','center');
wp2.geom.feature("Post"+RN+CN).set('pos',[XPosFirstPost+(PostDiameter+LateralGap)*(CN-1)+LateralDisplacementPerRow*(RN-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RN-1)]); %remember, the position is the center point
wp2.geom.feature("Post"+RN+CN).set('rot',45); %rotate around the bottom-left vertex
wp2.geom.feature("Post"+RN+CN).set("contributeto","Array"); 
    end;
end;
%generate the boundary & other geometry
wp2.geom.feature.create("s1",'Square');
wp2.geom.feature("s1").set('size',3);
wp2.geom.feature("s1").set('pos',[10 10]);
wp2.geom.feature("s1").set("contributeto","Array");
geom1.run
ext2 = geom1.feature.create('ext2', 'Extrude');
ext2.set('distance', '10');  %extrude the post and the boundary

% end of main array & boundary generation


%% generate the simulation area (the outter most area) 
WidthofRegion=(ColumnNumber+1)*(LateralGap+PostDiameter)+BypassChannelWidth/2+PostDiameter/2;
HeighofRegion=RowNumber*(DownstreamGap+PostDiameter);
wp1 = geom1.feature.create('wp1', 'WorkPlane');
wp1.set('planetype', 'quick');
wp1.set('quickplane', 'xy');
s=wp1.geom.feature.create('s','Rectangle');
s.set('size',[WidthofRegion HeighofRegion]);
geom1.run;
ext1 = geom1.feature.create('ext1', 'Extrude');
ext1.set('distance', '10');%%extrude the simulation area

%cut the simulation by the array 
FlowChannel = geom1.feature.create('FlowChannel', 'Difference');
FlowChannel.selection('input').set({'ext1'});
FlowChannel.selection('input2').set({'ext2'});
geom1.run;
mphgeom(model);

% model.save('G:/array')