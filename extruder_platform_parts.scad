include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module extruder_platform()
{
	platform_vert_off = rail_height+groove_height+rail_offset;
	l = extruder_length;
	w = rail_width;
	h = rail_height;

	color("LightSteelBlue")
	prerender(convexity=10)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2)
					cube(size=[w, l, rail_thick], center=true);

				// Walls.
				zring(n=2) {
					xflip_copy() {
						up(h/2) {
							fwd(l/2-l/6-5) {
								right((rail_spacing+joiner_width)/2) {
									thinning_triangle(h=h, l=l/3, thick=joiner_width, strut=5, bracing=false);
								}
							}
						}
					}
				}
			}

			// Extruder mount holes.
			circle_of(r=25, n=2) {
				cylinder(r=4.5/2, h=20, center=true);
			}

			// Extruder hole.
			rrect(r=10, size=[40, 60, 20], center=true);

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=l+0.05, h=h+0.001, w=joiner_width, clearance=5, a=joiner_angle);
			}

			// Shrinkage stress relief
			up(rail_thick/2) {
				yspread(13, n=12) {
					cube(size=[w+1, 1, rail_thick-2], center=true);
				}
				xspread(13, n=8) {
					yspread(l-10) {
						cube(size=[1, 60, rail_thick-2], center=true);
					}
				}
			}

			// Wiring acess holes.
			xspread(w-35-joiner_width*2) {
				yspread(80) {
					cylinder(h=20, r=w/8, center=true);
				}
			}

		}

		// Fan shroud mounts
		grid_of(count=2, spacing=w+10-0.05) {
			translate([0, 0, 10/2]) {
				difference() {
					union() {
						translate([0, 0, -fan_mount_width/4]) cube(size=[fan_mount_width, fan_mount_length, fan_mount_width/2], center=true);
						xrot(90) cylinder(h=fan_mount_length, r=fan_mount_width/2, center=true);
					}
					xrot(90) cylinder(h=fan_mount_length+1, r=fan_mount_screw*1.1/2, center=true, $fn=12);
					grid_of(count=[1,2], spacing=fan_mount_length-2*4) {
						hull() {
							grid_of(za=[0,5]) {
								xrot(90) zrot(90) {
									metric_nut(size=set_screw_size, hole=false, center=true);
								}
							}
						}
					}
				}
			}
		}
		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=l, h=h, w=joiner_width, l=5, a=joiner_angle);
		}
	}
}



module extruder_platform_parts() { // make me
	zrot(90) extruder_platform();
}



extruder_platform_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

