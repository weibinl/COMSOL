clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*
%{
NUMBER_OF_HOLES = 1000;
ind = 0;
hx=0;
hy=0;
hz=0;
hr = 0.0;
CHEESE_HEIGHT = 20;
CHEESE_RADIUS = 40;
RIND_THICKNESS = 0.2;
HOLE_MIN_RADIUS = 0.1;
HOLE_MAX_RADIUS = 1;
model = ModelUtil.create('model');
model.component.create('comp1',true);
model.component('comp1').geom.create('geom1',3).selection().create('csel1', 'CumulativeSelection');
while ind < NUMBER_OF_HOLES
    
 hx =(2.0*rand-1)*CHEESE_RADIUS;
 hy = (2.0*rand-1)*CHEESE_RADIUS;
 hz = rand*CHEESE_HEIGHT;
 hr = rand*(HOLE_MAX_RADIUS-HOLE_MIN_RADIUS)+HOLE_MIN_RADIUS;
 if (sqrt(hx*hx+hy*hy)+hr)> CHEESE_RADIUS-RIND_THICKNESS 
  continue
 end
 if ((hz-hr) < RIND_THICKNESS) || ((hz+hr) > CHEESE_HEIGHT-RIND_THICKNESS)
     continue; 
 end
 model.component('comp1').geom('geom1').create('sph'+ind, 'Sphere');
 model.component('comp1').geom('geom1').feature('sph'+ind).set('r', hr);
 model.component('comp1').geom('geom1').feature('sph'+ind).set('pos', double(hx, hy, hz));
 model.component('comp1').geom('geom1').feature('sph'+ind).set('contributeto', 'csel1');
 ind=ind+1;
end
model.component('comp1').geom('geom1').create('cyl1', 'Cylinder');
model.component('comp1').geom('geom1').feature('cyl1').set('r', CHEESE_RADIUS);
model.component('comp1').geom('geom1').feature('cyl1').set('h', CHEESE_HEIGHT);
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set('cyl1');
model.component('comp1').geom('geom1').feature('dif1').selection('input2').named('csel1');
model.component('comp1').geom('geom1').run();
%}
a=1
b=int2str(a);
model = ModelUtil.create('Model');
model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',2);
for a=1:3;
    for b=1:4
geom1.feature.create("i1"+a+b,'Point');
geom1.feature("i1"+a+b).set('p',[a b]);
    end;
end;
geom1.run;
mphgeom(model,'geom1','vertexmode','on');