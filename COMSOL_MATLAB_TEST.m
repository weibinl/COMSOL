clear all
clc
import com.comsol.model.*
import com.comsol.model.util.*

%array generation 
a=1;
model = ModelUtil.create('Model');
model.component.create('comp1',true);
geom1 = model.component('comp1').geom.create('geom1',2);

%generate the simulation area 
s=geom1.feature.create('s','Rectangle');
s.set('size',[100 100]);

%genereate the main array
array=geom1.selection().create("array","CumulativeSelection");
for a=1:4;
    for b=1:4
geom1.feature.create("i1"+a+b,'Circle');
geom1.feature("i1"+a+b).set('r',2);
geom1.feature("i1"+a+b).set('pos',[a*10 b*10]);
geom1.feature("i1"+a+b).set("contributeto","array");

    end;
end;

%generate the boundary
geom1.feature.create("s1",'Square');
geom1.feature("s1").set('size',3);
geom1.feature("s1").set('pos',[80 90]);
geom1.feature("s1").set("contributeto","array");

%compose all the component
model.component("comp1").geom("geom1").create("dif1", "Difference");
model.component("comp1").geom("geom1").feature("dif1").selection("input").set("s");
model.component("comp1").geom("geom1").feature("dif1").selection("input2").named("array");

geom1.run;
mphgeom(model,'geom1','vertexmode','on');

%finish the geometry 