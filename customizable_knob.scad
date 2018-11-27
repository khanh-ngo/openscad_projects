// resolution of the knob. higher value (100) will render very slow but create a smoother surface. low value (10) will create 'Low poly' effect.
$fn = 30;
// tolerance for the bolt and hex nut
tolerance = 0.2;

// output setting. 0 will output whole knob, 1 to output only half.
output_part = 0;

// total height of the knob
knob_height = 35;

// height of the top round knob
knob_handle_height = 20;
// diameter of the top round knob
knob_handle_dia = 40;

// diameter of the base
knob_base_dia = 50;

// style of base and top connector. -1 for inward, 1 for outward and 0 for straight
connector_style = 1;

// screw hole diameter in mm. make it a bit larger (+0.6) than the screw you want to use if you don't want to cut threads
screw_dia = 5.8;
// set to TRUE if you want to insert a hex nut, set to FALSE if you don't.
have_hex_nut_insert = true;
// hex nut's width across faces. needed if you want to insert hex nut. According to ISO4032, M4 = 7, M5 = 8 and M6 = 10
hex_nut_fwidth = 7.9;
// hex nut's height. needed if you want to insert hex nut. Higher value will give you a bigger window to insert your hex nut when printing.
hex_nut_height = 14;
// hex nut's position. adjust according to your bolt's length
hex_nut_post = 13.5;

module connector() {
    step = 2;
    for (i=[0:step:knob_height - knob_handle_height/2])
        hull() {
          translate([0, 0, i])
            scale(f(i)*[1,1])
              cylinder(r=knob_handle_dia/4, h = .01);
          translate([0, 0, i+step])
            scale(f(i+step)*[1,1])
              cylinder(r=knob_handle_dia/4, h = .01);
        }
    function f(i) = 1 + connector_style*pow(i/knob_height,2);
}

// top round knob
module top_round_knob() {
        translate([0, 0, knob_height - knob_handle_height/2])
        resize(newsize=[knob_handle_dia, knob_handle_dia, knob_handle_height])
        sphere(r=knob_handle_dia);
}

module base() {
            difference() {
                translate([0, 0, -2])
                    resize(newsize=[knob_base_dia, knob_base_dia, knob_handle_height])
                    sphere(r=knob_base_dia);
                translate([0, 0, -knob_handle_height/2])
                    cube([knob_handle_dia * 2, knob_handle_dia * 2, knob_handle_height], center=true);
            }
}

// create hexagon, with width being the distance across flat faces.
module fhex(width, height) {
    hull() {
        cube([width/1.7,width,height],center = true);
        rotate([0,0,120])cube([width/1.7,width,height],center = true);
        rotate([0,0,240])cube([width/1.7,width,height],center = true);
    }
}

// create hexagon, with width being the distance across corners.
module ghex(width, height) {
    cylinder(d = width, h = height, $fn = 6);
}

// create screw hole and hex nut cavity
module screw_hole() {
    cylinder(d = screw_dia + tolerance, h = knob_height - knob_handle_height/2);
    if (have_hex_nut_insert) {
        translate([0, 0 , hex_nut_post])
            fhex(hex_nut_fwidth + tolerance, hex_nut_height);
    }
}

// assemble all the parts together
difference() {
    union() {
        color("green")
            top_round_knob();
        color("blue")
            base();
        color("gray")
            connector();
    }
    translate([0, 0, -3.4])
        base();
    screw_hole();
    if (output_part == 1) {
        cutting_cube_size = knob_height * 10;
        translate([cutting_cube_size / 2 , 0, 0])
            cube(cutting_cube_size, center=true);
    }
}