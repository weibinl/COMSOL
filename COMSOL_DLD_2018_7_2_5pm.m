clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*
%% start of geometry generation 
%array generation 
a=1;
model = ModelUtil.create('Model');
comp1=model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',3);
model.component('comp1').geom('geom1').lengthUnit([native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']); %set the unit to um
wp1 = geom1.feature.create('wp1', 'WorkPlane');
wp1.set('planetype', 'quick');
wp1.set('quickplane', 'xy');
%generate the simulation area 
s=wp1.geom.feature.create('s','Rectangle');
s.set('size',[100 100]);
geom1.run;
ext1 = geom1.feature.create('ext1', 'Extrude');
ext1.set('distance', '10');%%extrude the simulation area
%genereate the main array
wp2 = geom1.feature.create('wp2', 'WorkPlane');
wp2.set('planetype', 'quick');
wp2.set('quickplane', 'xy');
array=wp2.geom.selection().create("array","CumulativeSelection");
for a=1:2
    for b=1:2
wp2.geom.feature.create("i1"+a+b,'Circle');
wp2.geom.feature("i1"+a+b).set('r',2);
wp2.geom.feature("i1"+a+b).set('pos',[a*10 b*10]);
wp2.geom.feature("i1"+a+b).set("contributeto","array");
    end;
end;
%generate the boundary & other geometry
wp2.geom.feature.create("s1",'Square');
wp2.geom.feature("s1").set('size',3);
wp2.geom.feature("s1").set('pos',[10 10]);
wp2.geom.feature("s1").set("contributeto","array");
geom1.run
ext2 = geom1.feature.create('ext2', 'Extrude');
ext2.set('distance', '10');  %extrude the post and the boundary
%cut the simulation by the array 
FlowChannel = geom1.feature.create('FlowChannel', 'Difference');
FlowChannel.selection('input').set({'ext1'});
FlowChannel.selection('input2').set({'ext2'});
geom1.run;
mphgeom(model);
% end of 3D geometry generation 

%% start of mesh generation
mesh1 = comp1.mesh.create('mesh1');
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').autoMeshSize(3);
mesh1.run;
mphmesh(model)
% end of mesh generation 


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
model.component('comp1').geom('geom1').feature('Inflow').set('xmax', 100);
model.component('comp1').geom('geom1').feature('Inflow').set('ymin', 0);
model.component('comp1').geom('geom1').feature('Inflow').set('ymax', 0.05);
model.component('comp1').geom('geom1').feature('Inflow').set('zmin', 0);
model.component('comp1').geom('geom1').feature('Inflow').set('zmax', 50);
model.component('comp1').geom('geom1').feature('Inflow').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('Inflow').set('entitydim', 2);
model.component('comp1').geom('geom1').run('Inflow');
 
model.component('comp1').geom('geom1').create('Outflow', 'BoxSelection');
model.component('comp1').geom('geom1').feature('Outflow').set('xmin', 0);
model.component('comp1').geom('geom1').feature('Outflow').set('xmax', 200);
model.component('comp1').geom('geom1').feature('Outflow').set('ymin', 98);
model.component('comp1').geom('geom1').feature('Outflow').set('ymax', 101);
model.component('comp1').geom('geom1').feature('Outflow').set('zmin', 0);
model.component('comp1').geom('geom1').feature('Outflow').set('zmax', 51);
model.component('comp1').geom('geom1').feature('Outflow').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('Outflow').set('entitydim', 2);
model.component('comp1').geom('geom1').run('Outflow');

model.component('comp1').geom('geom1').create('PointPressureConstrain', 'BoxSelection');
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('xmin', -1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('xmax', 1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('ymin', -1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('ymax', 1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('zmin', -1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('zmax', 1);
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('condition', 'inside');
model.component('comp1').geom('geom1').feature('PointPressureConstrain').set('entitydim', 0);
model.component('comp1').geom('geom1').run('PointPressureConstrain');

model.component('comp1').physics('spf').create('pfc1', 'PeriodicFlowCondition', 2); 
model.component('comp1').geom('geom1').create('Periodic_boundary', 'UnionSelection');
model.component('comp1').geom('geom1').feature('Periodic_boundary').set('entitydim', 2); 
model.component('comp1').geom('geom1').feature('Periodic_boundary').set('input', {'Inflow' 'Outflow'});
model.component('comp1').geom('geom1').run;
model.component('comp1').physics('spf').feature('pfc1').selection.named('geom1_Periodic_boundary'); % Watch out! The name of the selection is geom1_ plus the original selection name 
model.component('comp1').physics('spf').feature('pfc1').set('pdiff', 0.05); % Pressure difference between inflow and outlow, unit: Pa
model.component('comp1').physics('spf').create('prpc1', 'PressurePointConstraint', 0);
model.component('comp1').physics('spf').feature('prpc1').selection.named('geom1_PointPressureConstrain');% Watch out! The name of the selection is geom1_ plus the original selection name 
model.component('comp1').physics('spf').feature('prpc1').set('p0', 0);  % Pressure at the constrain point

%end of physics setup 

%% start of study setup

% end of study setup 

%% start of simulation 

% end of simulation 

%% start of post processing 

%end of post processing 

%% start of file saving
% save to mph file in the following destination with file name 'test.mph'
% 



