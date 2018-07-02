
clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*
%array generation 
a=1;
model = ModelUtil.create('Model');
model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',3);
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
for a=1:8
    for b=1:8
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
dif1 = geom1.feature.create('dif1', 'Difference');
dif1.selection('input').set({'ext1'});
dif1.selection('input2').set({'ext2'});
geom1.run;
mphgeom(model);
%finish the 3D geometry generation 
% save to mph file in the following destination with file name 'test.mph'

model.save('G:\test')


