clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*


model = ModelUtil.create('Model');
comp1 = model.component.create('comp1',true);
geom1 = comp1.geom.create('geom1', 3);
wp1 = geom1.feature.create('wp1', 'WorkPlane');
wp1.set('planetype', 'quick');
wp1.set('quickplane', 'xy');
r1 = wp1.geom.feature.create('r1', 'Rectangle');
r1.set('size',[1 2]);
geom1.run

ext1 = geom1.feature.create('ext1', 'Extrude');
ext1.set('distance', '0.1');

geom1.run;
mphgeom(model);
%finish the geometry 







