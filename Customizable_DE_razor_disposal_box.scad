/* [Customizable text] */
// warning text, 1st line
text_warning1 = "Razor";
// warning text, 2nd line
text_warning2 = "inside!";
// text's size
text_size = 6;

/* [Dimension of the box] */
// Width in mm
width = 48.4;
// Height in mm
height = 27.4;
// Depth in mm
depth = 27.4;
// Thickness of the wall. An even multiple (2x, 4x, 6x) of your nozzle width is best.
thickness = 1.6;
// slit's height
slit_height = 3;

// hidden
text_font = "Futura";

module emboss_text(h_offset, text_str) {
    translate([0, -depth/2, h_offset])
        rotate([90, 0, 0]) {
        linear_extrude(height=thickness/2) {
          offset(r=0.3, $fn=20)  // text w/ rounded corners
          text(text=text_str, font=text_font, size=text_size, halign="center", valign="center");
        }
    }
}

difference() {
    // base block
    cube([width,depth,height], center=true);
    
    // hollowing out the inside of base block
    union() {
        cube([width - thickness*2, depth - thickness*2, height - thickness*2], center=true);  // inside
        translate(v=[0, -thickness/2, height/2 - slit_height/2 - thickness]) rotate([90,0,0]) cube([width - thickness*2, slit_height, depth], center=true);  // opening
    }
}

// add warning text (1st line)
offset_h1 = height/2 - slit_height/2 - thickness*4 - text_size / 2;
color("red")
    emboss_text(offset_h1, text_warning1);
// add warning text (2nd line)
offset_h2 = height/2 - slit_height/2 - thickness*6 - text_size / 2 - text_size;
color("red")
    emboss_text(offset_h2, text_warning2);