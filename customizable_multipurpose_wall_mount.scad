// resolution of round corners, holes
$fn = 60;

// width of the bracket. Normally it should be set to a value smaller than half the length of object you want to hang
width = 30;
// height of the bracket. Normally it should be set to a value smaller than half the height of the object you want to hang
height = 30;
// the depth of our bracket, also equal thickness of the object you want to hang
depth = 20;

// thick ness of bracket's wall. A multiple of your nozzle width (line width) is best.
wall_thickness = 1.6;

// holding length: length of the part that hold your object
hold_length = 6;

// bolt diameter
bolt_dia = 3;
// bolt type
bolt_type = "chamfered"; // "countersunk" or "chamfered"

// hidden
// calculated values
outter_width = width;
outter_height = height;
outter_depth = depth + wall_thickness*2;
inner_depth = depth;

// main body
difference() {
    union() {
        difference() {
            cube([outter_width, outter_depth, outter_height]);
            // cut out holder
            holder_trans_dist = hold_length + wall_thickness;
            color("green")
                translate([holder_trans_dist, 0, holder_trans_dist])
                cube([outter_width, outter_depth, outter_height]);
        }
        rotate([0,0,90])
            translate([wall_thickness*2,-width,0])
            prism(inner_depth, width, height);
    }
    // cut out the inner portion to create a shell
    color("red")
        translate([wall_thickness, wall_thickness, wall_thickness])
        cube([width, inner_depth, height]);
    // cut out bolt hole(s)
    color("blue")
        translate([4*1.618 + wall_thickness, outter_depth - wall_thickness*(0.75/2)-0.1, 4*1.618 + wall_thickness])
        rotate([90, 0, 0])
        bolt(bolt_type, bolt_dia);
}

// create cavity for the bolt
module bolt(bolt_type, bolt_dia) {
    // Constants
    chamfer=4;
    gr=1.618;
    if (bolt_type == "chamfered") {
        translate([0, 0, wall_thickness*0.25])
            cylinder(d=bolt_dia*chamfer, h=wall_thickness*0.75, center=true);
        cylinder(d=bolt_dia, h=wall_thickness, center=true);
    } else if (bolt_type == "countersunk") {
        cylinder(d1=bolt_dia, d2=bolt_dia*chamfer, h=wall_thickness, center=true);
    }
}

// this module create a right triangular prism
module prism(l, w, h) {
    polyhedron(
        points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
        faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
    );
}