clear all;
close all;
clc;
import com.comsol.model.*
import com.comsol.model.util.*

%array generation 

% setting the array parameters 
PostDiameter=21;
LateralGap=17;
DownstreamGap=17;
TiltRatio=42; %lateral displacement vs lateral movement per bump, or # of rows required to displace one post in column
ColumnNumber=5; %one side, we built the symmetric model about the center bypass channel to reduce the required calculation time, also this is the number of channel, the post number should be ColumnNumber-1, count from the top
RowNumber=TiltRatio;
MinimumBypassChannelWidth=25;
LateralDisplacementPerRow=(DownstreamGap+PostDiameter)/TiltRatio;
pressure=500;
gain1=0.5;  %for gap adjustment 
gain2=0.05;  %for gap adjustment
DepthofChannel=10;
LoopNumber=1;

%initial guess of width
ByPassWidth=zeros(RowNumber,1);
%{
for i=1:1:RowNumber %determine the bypass channel width
    ByPassWidth(i,1)=(-0.0011*i^2+0.2088*i+18.403)/2;  %remember, only half 
end
%}
ByPassWidth=[10.6645221533565;12.8031734767178;13.5803036201877;14.2062111870981;14.7728812616999;15.2420749643883;15.7740878692233;16.3309546451832;16.7758595957440;17.2521503275215;17.7608357680089;18.2129105390487;18.7508551593992;19.1574972574569;19.6322344947803;20.1271391957333;20.5319445225589;20.9932625788932;21.5323969922881;21.9287846367590;22.3036948362273;22.7849704571794;23.2078654102119;23.6333749099267;24.1322521808160;24.6330985979721;25.1310663759066;25.5456620037633;26.0329562915751;26.4642210274954;27.0239346655304;27.4977514477989;27.9279576606219;28.4460084196386;28.9774644304736;29.4418152474182;29.8856432512400;30.3978412461337;31.0883815978032;31.9170921883415;34.2101881444406;38.3462036075565];
WallChannelWidth=zeros(RowNumber,1);
%{
for i=1:1:RowNumber %determine the near wall channel width
    WallChannelWidth(i,1)=-0.0061*i^2+0.6*i;  
end
%}
WallChannelWidth=[1.55099800024041;2.21604811521003;2.64769868350091;3.17358896531085;3.40224544300060;3.74623553037906;4.07358161968670;4.37400384993856;4.73789963499786;5.05287213372808;5.36336324803342;5.68848762683223;6.04703050445144;6.32022082878713;6.66828750552752;6.94794914123578;7.29200815193276;7.67658340007579;8.00196968680499;8.10873584088780;9.90990000000000;8.75535522391205;9.45686593562922;9.74823590401503;10.1446207791524;10.4933817718896;10.8704294918654;11.2622813566696;11.5893962892596;11.9597442856006;12.3303650855780;12.7412829084529;13.1077417212002;13.4840172685287;13.8465678324172;14.2763129307872;14.6433276210343;15.0591217694579;15.4154786761703;15.9084863555982;16.1173209946555;15.9746952908221];

figure(1);
hold on;
figure(2);
hold on;
figure(3);
hold on;
pause(2);
figure(5);
hold on;
figure(6)
hold on;
figure(7)
hold on;
figure(8)
hold on;
figure(9)
hold on;
figure(10);
hold on;
figure(11);
hold on;

for z=1:1:LoopNumber



figure(1);
plot(ByPassWidth,'-b');
plot(WallChannelWidth,'-r');
pause(2)

% calculate the position of the main post 
% set the middle of by bypass channel to be (0,0), flow from top to bottom, and the model is built from bottom to top 
a=1;
model = ModelUtil.create('Model');
comp1=model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',3);
model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']); %set the unit to um
XPosFirstPost=MinimumBypassChannelWidth/2+PostDiameter/2;  %define the first post of the array
YPosFirstPost=PostDiameter/2;
%% genereate the main array

wp2 = geom1.feature.create('wp2', 'WorkPlane');  %generate the workplane in which the post will be extruded from 
wp2.set('planetype', 'quick');
wp2.set('quickplane', 'xy');
wp2.geom.selection().create("Array","CumulativeSelection");
 for RN=2:1:RowNumber
      for CN=1:1:ColumnNumber
          wp2.geom.feature.create("Post_low"+((RN-1)*ColumnNumber+CN),'Square');
          wp2.geom.feature("Post_low"+((RN-1)*ColumnNumber+CN)).set('size',PostDiameter/2*sqrt(2));
          wp2.geom.feature("Post_low"+((RN-1)*ColumnNumber+CN)).set('base','center');
          wp2.geom.feature("Post_low"+((RN-1)*ColumnNumber+CN)).set('pos',[XPosFirstPost+(PostDiameter+LateralGap)*(CN-1)+LateralDisplacementPerRow*(RN-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RN-2)]); %remember, the position is the center point
          wp2.geom.feature("Post_low"+((RN-1)*ColumnNumber+CN)).set('rot',45); %rotate around the bottom-left vertex
          wp2.geom.feature("Post_low"+((RN-1)*ColumnNumber+CN)).set("contributeto","Array"); 
      end;
  end;
 
  for CN=1:1:ColumnNumber
      RN=RowNumber+1;
      wp2.geom.feature.create("Post_high"+((RN-1)*ColumnNumber+CN),'Square');
      wp2.geom.feature("Post_high"+((RN-1)*ColumnNumber+CN)).set('size',PostDiameter/2*sqrt(2));
      wp2.geom.feature("Post_high"+((RN-1)*ColumnNumber+CN)).set('base','center');
      wp2.geom.feature("Post_high"+((RN-1)*ColumnNumber+CN)).set('pos',[XPosFirstPost+(PostDiameter+LateralGap)*(CN-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RN-2)]); %remember, the position is the center point
      wp2.geom.feature("Post_high"+((RN-1)*ColumnNumber+CN)).set('rot',45); %rotate around the bottom-left vertex
      wp2.geom.feature("Post_high"+((RN-1)*ColumnNumber+CN)).set("contributeto","Array"); 
  end

%generate the boundary & other geometry

% Bypass channel post generation start
 BypassWidthByOrder=zeros(TiltRatio,1);
 for i=2:1:RowNumber %generate the bypass channel wide post (post section)
     wp2.geom.feature.create("ByPassPost"+i,'Square');
     wp2.geom.feature("ByPassPost"+i).set('size',PostDiameter/2*sqrt(2));
     wp2.geom.feature("ByPassPost"+i).set('base','center');
     wp2.geom.feature("ByPassPost"+i).set('pos',[ByPassWidth(i)+PostDiameter/2 YPosFirstPost+(PostDiameter+DownstreamGap)*(i-2)]); %remember, the position is the center point
     BypassWidthByOrder(i-1)=ByPassWidth(i);
     wp2.geom.feature("ByPassPost"+i).set('rot',45); %rotate around the bottom-left vertex
     wp2.geom.feature("ByPassPost"+i).set("contributeto","Array"); 
 end 
 
 for i=2:1:RowNumber %generate the bypass channel wide post (rectangle section)
      wp2.geom.feature.create("ByPassPost_Rec"+i,'Rectangle');
      wp2.geom.feature("ByPassPost_Rec"+i).set('size',[XPosFirstPost+LateralDisplacementPerRow*(i-1)-ByPassWidth(i)-PostDiameter/2 PostDiameter]);
      wp2.geom.feature("ByPassPost_Rec"+i).set('pos',[ByPassWidth(i)+PostDiameter/2 YPosFirstPost+(PostDiameter+DownstreamGap)*(i-2)-PostDiameter/2]);
      wp2.geom.feature("ByPassPost_Rec"+i).set("contributeto","Array");
 end 
 
     wp2.geom.feature.create("ByPassPost"+1,'Square');
     wp2.geom.feature("ByPassPost"+1).set('size',PostDiameter/2*sqrt(2));
     wp2.geom.feature("ByPassPost"+1).set('base','center');
     wp2.geom.feature("ByPassPost"+1).set('pos',[ByPassWidth(1)+PostDiameter/2 YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)]); %remember, the position is the center point
     BypassWidthByOrder(RowNumber)=ByPassWidth(1);
     wp2.geom.feature("ByPassPost"+1).set('rot',45); %rotate around the bottom-left vertex
     wp2.geom.feature("ByPassPost"+1).set("contributeto","Array"); 
 
     wp2.geom.feature.create("ByPassPost_Rec"+1,'Rectangle');
     wp2.geom.feature("ByPassPost_Rec"+1).set('size',[XPosFirstPost-ByPassWidth(1)-PostDiameter/2 PostDiameter]);
     wp2.geom.feature("ByPassPost_Rec"+1).set('pos',[ByPassWidth(1)+PostDiameter/2 YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)-PostDiameter/2]);
     wp2.geom.feature("ByPassPost_Rec"+1).set("contributeto","Array");
     
     figure(5)
     plot(flip(BypassWidthByOrder'))
%end of Bypass channel post generation 

pause(1);

%start of wall generation 
%generation of the post at the wall 
WallPostPosition=zeros(TiltRatio,1);
WallChannelWidthByOrder=zeros(TiltRatio,1);
for i=1:1:RowNumber/2-1  %low section
     wp2.geom.feature.create("Wall_post"+i,'Square');
     wp2.geom.feature("Wall_post"+i).set('size',PostDiameter/2*sqrt(2));
     wp2.geom.feature("Wall_post"+i).set('base','center');
     wp2.geom.feature("Wall_post"+i).set('pos',[WallChannelWidth(RowNumber/2-i)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1)+LateralDisplacementPerRow*(i) YPosFirstPost+(PostDiameter+DownstreamGap)*(i-1)]); %remember, the position is the center point
     WallPostPosition(i)=WallChannelWidth(RowNumber/2-i)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1)+LateralDisplacementPerRow*(i);
     WallChannelWidthByOrder(i)=WallChannelWidth(RowNumber/2-i);
     wp2.geom.feature("Wall_post"+i).set('rot',45); %rotate around the bottom-left vertex
     wp2.geom.feature("Wall_post"+i).set("contributeto","Array"); 
     
     wp2.geom.feature.create("Wall"+i,'Rectangle');
     wp2.geom.feature("Wall"+i).set('size',[500 PostDiameter*1.5+DownstreamGap*2]);
     wp2.geom.feature("Wall"+i).set('pos',[WallChannelWidth(RowNumber/2-i)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1)+LateralDisplacementPerRow*(i) YPosFirstPost+(PostDiameter+DownstreamGap)*(i-1)-PostDiameter/2-DownstreamGap]); 
     wp2.geom.feature("Wall"+i).set("contributeto","Array"); 
end
 
for i=1:1:RowNumber/2   %upper section
    wp2.geom.feature.create("Wall_post"+(i-1)+RowNumber/2,'Square');
    wp2.geom.feature("Wall_post"+(i-1)+RowNumber/2).set('size',PostDiameter/2*sqrt(2));
    wp2.geom.feature("Wall_post"+(i-1)+RowNumber/2).set('base','center');
    wp2.geom.feature("Wall_post"+(i-1)+RowNumber/2).set('pos',[WallChannelWidth(RowNumber-i+1)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-2)+LateralDisplacementPerRow*(i+RowNumber/2-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber/2-2+i)]); %remember, the position is the center point
    WallPostPosition(i+RowNumber/2-1)=WallChannelWidth(RowNumber-i+1)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-2)+LateralDisplacementPerRow*(i+RowNumber/2-1);
    WallChannelWidthByOrder(i+RowNumber/2-1)=WallChannelWidth(RowNumber-i+1);
    wp2.geom.feature("Wall_post"+(i-1)+RowNumber/2).set('rot',45); %rotate around the bottom-left vertex
    wp2.geom.feature("Wall_post"+(i-1)+RowNumber/2).set("contributeto","Array"); 
    
     wp2.geom.feature.create("Wall"+(i-1)+RowNumber/2,'Rectangle');
     wp2.geom.feature("Wall"+(i-1)+RowNumber/2).set('pos',[WallChannelWidth(RowNumber-i+1)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-2)+LateralDisplacementPerRow*(i+RowNumber/2-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber/2-2+i)-PostDiameter/2]); 
     wp2.geom.feature("Wall"+(i-1)+RowNumber/2).set('size',[500 PostDiameter*1.5+DownstreamGap]);
     wp2.geom.feature("Wall"+(i-1)+RowNumber/2).set("contributeto","Array"); 
     
    
end
 
     wp2.geom.feature.create("Wall_post"+RowNumber,'Square');
     wp2.geom.feature("Wall_post"+RowNumber).set('size',PostDiameter/2*sqrt(2));
     wp2.geom.feature("Wall_post"+RowNumber).set('base','center');
     wp2.geom.feature("Wall_post"+RowNumber).set('pos',[WallChannelWidth(RowNumber/2)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)]); %remember, the position is the center point
     WallPostPosition(TiltRatio)=WallChannelWidth(RowNumber/2)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1);
     WallChannelWidthByOrder(TiltRatio)=WallChannelWidth(RowNumber/2);
     wp2.geom.feature("Wall_post"+RowNumber).set('rot',45); %rotate around the bottom-left vertex
     wp2.geom.feature("Wall_post"+RowNumber).set("contributeto","Array"); 
    
     wp2.geom.feature.create("Wall"+RowNumber,'Rectangle');
     wp2.geom.feature("Wall"+RowNumber).set('pos',[WallChannelWidth(RowNumber/2)+PostDiameter+XPosFirstPost+(PostDiameter+LateralGap)*(ColumnNumber-1) YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)-PostDiameter/2]); 
     wp2.geom.feature("Wall"+RowNumber).set('size',[500 PostDiameter*1.5+DownstreamGap]);
     wp2.geom.feature("Wall"+RowNumber).set("contributeto","Array"); 
     
     figure(5)
     plot(fliplr(WallChannelWidthByOrder'));
% end of the post generetation at the wall

geom1.run
ext2 = geom1.feature.create('ext2', 'Extrude');
ext2.set('distance', num2str(DepthofChannel));  %extrude the post and the boundary, depth of the channel

% end of main array & boundary generation


%% generate the simulation area (the outter most area) 
WidthofRegion=(ColumnNumber+1)*(LateralGap+PostDiameter)+MinimumBypassChannelWidth/2+PostDiameter/2;
HeighofRegion=RowNumber*(DownstreamGap+PostDiameter);
wp1 = geom1.feature.create('wp1', 'WorkPlane');
wp1.set('planetype', 'quick');
wp1.set('quickplane', 'xy');
s=wp1.geom.feature.create('s','Rectangle');
s.set('size',[WidthofRegion HeighofRegion]);
s.set('pos',[0 -5]);
geom1.run;
ext1 = geom1.feature.create('ext1', 'Extrude');
ext1.set('distance',  num2str(DepthofChannel));%%extrude the simulation area

%cut the simulation by the array 
FlowChannel = geom1.feature.create('FlowChannel', 'Difference');
FlowChannel.selection('input').set({'ext1'});
FlowChannel.selection('input2').set({'ext2'});
geom1.run;

pause(1);

%end of simulation area generation


%% material setup (water, liquid, pre-built in the COMSOL 5.3 Version 
model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').label('Water, liquid');
model.component('comp1').material('mat1').set('family', 'water');
model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.0');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', '5.5e-6[S/m]');
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(T[1/K])[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', 'k(T[1/K])[W/(m*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('funcname', 'eta');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'273.15' '413.15' '1.3799566804-0.021224019151*T^1+1.3604562827E-4*T^2-4.6454090319E-7*T^3+8.9042735735E-10*T^4-9.0790692686E-13*T^5+3.8457331488E-16*T^6'; '413.15' '553.75' '0.00401235783-2.10746715E-5*T^1+3.85772275E-8*T^2-2.39730284E-11*T^3'});
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('funcname', 'Cp');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'273.15' '553.75' '12010.1471-80.4072879*T^1+0.309866854*T^2-5.38186884E-4*T^3+3.62536437E-7*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('funcname', 'rho');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('pieces', {'273.15' '553.75' '838.466135+1.40050603*T^1-0.0030112376*T^2+3.71822313E-7*T^3'});
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('funcname', 'k');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('extrap', 'constant');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'273.15' '553.75' '-0.869083936+0.00894880345*T^1-1.58366345E-5*T^2+7.97543259E-9*T^3'});
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Interpolation');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('sourcetype', 'user');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('source', 'table');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('funcname', 'cs');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('table', {'273' '1403';'278' '1427'; '283' '1447';'293' '1481';'303' '1507';'313' '1526';'323' '1541';'333' '1552';'343' '1555';'353' '1555';'363' '1550';'373' '1543'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('interp', 'piecewisecubic');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('extrap', 'const');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').set('family', 'water');
% end of material setup

%% Start of Physics Setup

model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');
model.component('comp1').geom('geom1').create('Inflow', 'BoxSelection');
model.component('comp1').geom('geom1').feature('Inflow').set('xmin', 0);
model.component('comp1').geom('geom1').feature('Inflow').set('xmax', WidthofRegion);
model.component('comp1').geom('geom1').feature('Inflow').set('ymin', -5-0.05);
model.component('comp1').geom('geom1').feature('Inflow').set('ymax', -5+0.05);
model.component('comp1').geom('geom1').feature('Inflow').set('zmin', 0);
model.component('comp1').geom('geom1').feature('Inflow').set('zmax', 50);
model.component('comp1').geom('geom1').feature('Inflow').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('Inflow').set('entitydim', 2);
model.component('comp1').geom('geom1').run('Inflow');
 
model.component('comp1').geom('geom1').create('Outflow', 'BoxSelection');
model.component('comp1').geom('geom1').feature('Outflow').set('xmin', 0);
model.component('comp1').geom('geom1').feature('Outflow').set('xmax', WidthofRegion);
model.component('comp1').geom('geom1').feature('Outflow').set('ymin', HeighofRegion-5-0.05);
model.component('comp1').geom('geom1').feature('Outflow').set('ymax', HeighofRegion-5+0.05);
model.component('comp1').geom('geom1').feature('Outflow').set('zmin', 0);
model.component('comp1').geom('geom1').feature('Outflow').set('zmax', 50);
model.component('comp1').geom('geom1').feature('Outflow').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('Outflow').set('entitydim', 2); %plane selection,2
model.component('comp1').geom('geom1').run('Outflow');

model.component('comp1').geom('geom1').create('PointPressureConstrain', 'BoxSelection');
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('xmin', -1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('xmax', 1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('ymin', -5-1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('ymax', -5+1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('zmin', -1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('zmax', 50);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('entitydim', 0);   %point selection, 0
model.component('comp1').geom('geom1').run('PointPressureConstrain');

model.component('comp1').geom('geom1').create('Symmetry', 'BoxSelection');
model.component('comp1').geom('geom1').feature('Symmetry').set('xmin', -1);
model.component('comp1').geom('geom1').feature('Symmetry').set('xmax', 1);
model.component('comp1').geom('geom1').feature('Symmetry').set('ymin', -5-1);
model.component('comp1').geom('geom1').feature('Symmetry').set('ymax', -5+HeighofRegion);
model.component('comp1').geom('geom1').feature('Symmetry').set('zmin', -1);
model.component('comp1').geom('geom1').feature('Symmetry').set('zmax', 50);
model.component('comp1').geom('geom1').feature('Symmetry').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('Symmetry').set('entitydim', 2);   %plane selection,2
model.component('comp1').geom('geom1').run('Symmetry');

model.component('comp1').physics('spf').create('sym1', 'Symmetry', 2);
model.component('comp1').physics('spf').feature('sym1').selection.named('geom1_Symmetry');
model.component('comp1').physics('spf').create('pfc1', 'PeriodicFlowCondition', 2); 
model.component('comp1').geom('geom1').create('Periodic_boundary', 'UnionSelection');
model.component('comp1').geom('geom1').feature('Periodic_boundary').set('entitydim', 2); 
model.component('comp1').geom('geom1').feature('Periodic_boundary').set('input', {'Outflow' 'Inflow'});
model.component('comp1').geom('geom1').run;
model.component('comp1').physics('spf').feature('pfc1').selection.named('geom1_Periodic_boundary'); % Watch out! The name of the selection is geom1_ plus the original selection name 
model.component('comp1').physics('spf').feature('pfc1').set('pdiff', pressure); % Pressure difference between inflow and outlow, unit: Pa
model.component('comp1').physics('spf').create('prpc1', 'PressurePointConstraint', 0);
model.component('comp1').physics('spf').feature('prpc1').selection.named('geom1_PointPressureConstrain');% Watch out! The name of the selection is geom1_ plus the original selection name 
model.component('comp1').physics('spf').feature('prpc1').set('p0', 0);  % Pressure at the constrain point
figure(4)
mphgeom(model)
%end of physics setup 

%% start of mesh generation
me='meshing start'
mesh1 = comp1.mesh.create('mesh1');
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').autoMeshSize(5);
mesh1.run;
mee='meshing ends'
% end of mesh generation 

%% start of study setup
std1=model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('spf', true);
model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');
a='start simulation'
pause(10);

std1.run;

b='simulation ends'
% start the simulation
% end of study setup 

%% start of post-processing 

BypassResult=zeros(TiltRatio,1);
for i=1:1:TiltRatio
    model.result.dataset.create("ps"+i, 'ParSurface');
    model.result.dataset("ps"+i).set('parmax1', ByPassWidth(mod(i,TiltRatio)+1));%X width of the gap
    model.result.dataset("ps"+i).set('parmax2', DepthofChannel);   %Z, the depth of the channel
    model.result.dataset("ps"+i).set('exprx', 's1');    %X width of the gap
    model.result.dataset("ps"+i).set('expry', num2str(YPosFirstPost+(PostDiameter+DownstreamGap)*(i-1)));   %Y position
    model.result.dataset("ps"+i).set('exprz', 's2');    %Z, the depth of the channel
    model.result.numerical.create("int"+i, 'IntSurface');  % evaluate the flux along y direction (v component)
    model.result.numerical("int"+i).set('data', "ps"+i);
    model.result.numerical("int"+i).setIndex('expr', 'v', 0);
    model.result.numerical("int"+i).set('method', 'integration');
    model.result.numerical("int"+i).set('dataseries', 'integral');
    model.result.table.create("table"+i, 'Table');
    model.result.table("table"+i).comments('Surface Integration 1 (v)');
    model.result.numerical("int"+i).set('table', "table"+i);
    model.result.numerical("int"+i).setResult;
    BypassResult(i)=model.result.table("table"+i).getReal();
end

WallResult=zeros(TiltRatio,1);
for i=1:1:TiltRatio
    model.result.dataset.create("ps22"+i, 'ParSurface');
    model.result.dataset("ps22"+i).set('parmax1', WallChannelWidthByOrder(i));%X width of the gap
    model.result.dataset("ps22"+i).set('parmax2', DepthofChannel);   %Z, the depth of the channel
    model.result.dataset("ps22"+i).set('exprx', num2str(WallPostPosition(i)-PostDiameter/2-WallChannelWidthByOrder(i))+"+s1");    %X width of the gap
    model.result.dataset("ps22"+i).set('expry', num2str(YPosFirstPost+(PostDiameter+DownstreamGap)*(i-1)));   %Y position
    model.result.dataset("ps22"+i).set('exprz', 's2');    %Z, the depth of the channel
    model.result.numerical.create("int22"+i, 'IntSurface');  % evaluate the flux along y direction (v component)
    model.result.numerical("int22"+i).set('data', "ps22"+i);
    model.result.numerical("int22"+i).setIndex('expr', 'v', 0);
    model.result.numerical("int22"+i).set('method', 'integration');
    model.result.numerical("int22"+i).set('dataseries', 'integral');
    model.result.table.create("table22"+i, 'Table');
    model.result.table("table22"+i).comments('Surface Integration 1 (v)');
    model.result.numerical("int22"+i).set('table', "table22"+i);
    model.result.numerical("int22"+i).setResult;
    WallResult(i)=model.result.table("table22"+i).getReal();
end
GapNextToBypass=0;
% nearest gap to the bypass channel 
    model.result.dataset.create("PS3", 'ParSurface');
    model.result.dataset("PS3").set('parmax1', LateralGap);%X width of the gap
    model.result.dataset("PS3").set('parmax2', DepthofChannel);   %Z, the depth of the channel
    model.result.dataset("PS3").set('exprx', num2str(XPosFirstPost+PostDiameter/2)+"+s1");    %X width of the gap
    model.result.dataset("PS3").set('expry', num2str(YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)));   %Y position
    model.result.dataset("PS3").set('exprz', 's2');    %Z, the depth of the channel
    model.result.numerical.create("Int3", 'IntSurface');  % evaluate the flux along y direction (v component)
    model.result.numerical("Int3").set('data', "PS3");
    model.result.numerical("Int3").setIndex('expr', 'v', 0);
    model.result.numerical("Int3").set('method', 'integration');
    model.result.numerical("Int3").set('dataseries', 'integral');
    model.result.table.create("Table3", 'Table');
    model.result.table("Table3").comments('Surface Integration 1 (v)');
    model.result.numerical("Int3").set('table', "Table3");
    model.result.numerical("Int3").setResult;
    GapNextToBypass=model.result.table("Table3").getReal();
    
GapNextToWall=0;    
% nearest gap to the wall channel 
    model.result.dataset.create("PS4", 'ParSurface');
    model.result.dataset("PS4").set('parmax1', LateralGap);%X width of the gap
    model.result.dataset("PS4").set('parmax2', DepthofChannel);   %Z, the depth of the channel
    model.result.dataset("PS4").set('exprx', num2str(XPosFirstPost+PostDiameter/2+(PostDiameter+LateralGap)*(ColumnNumber-2))+"+s1");    %X width of the gap
    model.result.dataset("PS4").set('expry', num2str(YPosFirstPost+(PostDiameter+DownstreamGap)*(RowNumber-1)));   %Y position
    model.result.dataset("PS4").set('exprz', 's2');    %Z, the depth of the channel
    model.result.numerical.create("Int4", 'IntSurface');  % evaluate the flux along y direction (v component)
    model.result.numerical("Int4").set('data', "PS4");
    model.result.numerical("Int4").setIndex('expr', 'v', 0);
    model.result.numerical("Int4").set('method', 'integration');
    model.result.numerical("Int4").set('dataseries', 'integral');
    model.result.table.create("Table4", 'Table');
    model.result.table("Table4").comments('Surface Integration 1 (v)');
    model.result.numerical("Int4").set('table', "Table4");
    model.result.numerical("Int4").setResult;
    GapNextToWall=model.result.table("Table4").getReal();

%% Calculate the Difference of bypass channel 
BypassTargetFlux=(fliplr((BypassResult(TiltRatio,1)+fliplr([(linspace(1/TiltRatio*GapNextToBypass,GapNextToBypass*(1-1/TiltRatio),TiltRatio-1)) 0]))))';
BypassDifference=(BypassTargetFlux-BypassResult)./BypassResult;  %remember, the index is 1 in the bottom and getting bigger to the top
figure(6)
plot(fliplr((BypassTargetFlux)'),'-b')
figure(7)
plot(fliplr((BypassResult)'),'-b')
figure(8)
plot(fliplr((BypassTargetFlux-BypassResult)'),'-b')
WallTargetFlux=fliplr(([linspace(0.5*GapNextToWall,GapNextToWall,TiltRatio/2+1) linspace(1/TiltRatio*GapNextToWall, (TiltRatio/2-1)/TiltRatio*GapNextToWall, TiltRatio/2-1)]))';
WallTargetDifference=(WallTargetFlux-WallResult)./WallResult;  %remember, the index is 1 in the bottom and getting bigger to the top
figure(9)
plot(fliplr((WallTargetFlux)'),'-r')
figure(10)
plot(fliplr((WallResult)'),'-r')
figure(11)
plot(fliplr((WallTargetFlux-WallResult)'),'-b')
pause(2);
z
pause(1);
figure(2)
BD=norm(BypassDifference)
plot(z,BD,'o','MarkerSize',6,'MarkerEdgeColor','b');
pause(1);
figure(3)
WD=norm(WallTargetDifference)
plot(z,WD,'^','MarkerSize',6,'MarkerEdgeColor','r');
pause(1);

%adjust the gain of gap adjustment
for i=1:1:TiltRatio
    if abs(BypassDifference(i))>=1
        BypassDifference(i)=sign(BypassDifference(i))*0.2;
    end
    if abs(WallTargetDifference(i))>=1
        WallTargetDifference(i)=sign(WallTargetDifference(i))*0.2;
    end
end;

% end of the calculation 
%% start to adjust the gap

if z<LoopNumber  
ByPassWidthModPar=(diag(ones(TiltRatio,1)*gain1)+diag(ones(TiltRatio-1,1)*gain2,1)+diag(ones(TiltRatio-1,1)*gain2,-1)+diag(ones(1,1)*gain2,TiltRatio-1)+diag(ones(1,1)*gain2,-TiltRatio+1))*BypassDifference;

WallChannelWidthModPar=(diag(ones(TiltRatio,1)*gain1)+diag(ones(TiltRatio-1,1)*gain2,1)+diag(ones(TiltRatio-1,1)*gain2,-1)+diag(ones(1,1)*gain2,TiltRatio-1)+diag(ones(1,1)*gain2,-TiltRatio+1))*WallTargetDifference;

for i=1:1:TiltRatio/2-1 %lower section
    WallChannelWidth(RowNumber/2-i)=(WallChannelWidthModPar(i)+1)*WallChannelWidth(RowNumber/2-i);  
end

for i=1:1:RowNumber/2 %upper section
    WallChannelWidth(RowNumber-i+1)=(WallChannelWidthModPar(i+RowNumber/2-1)+1)*WallChannelWidth(RowNumber-i+1);
end

for i=1:1:RowNumber
   ByPassWidth(mod(i,TiltRatio)+1)=(ByPassWidthModPar(i)+1)*ByPassWidth(mod(i,TiltRatio)+1);
end
ModelUtil.clear
end 



for i=2:1:RowNumber
while XPosFirstPost+LateralDisplacementPerRow*(i-1)-ByPassWidth(i)-PostDiameter/2<=0
     MinimumBypassChannelWidth=MinimumBypassChannelWidth+1;
     XPosFirstPost=MinimumBypassChannelWidth/2+PostDiameter/2;   
end
end
end
