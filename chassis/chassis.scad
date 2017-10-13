/*
 * chassis.scad - Thermostat chassis drawings for laser cutting
 * 
 * Copyright 2017 Marcel Clausen
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

// 2D rendering module separation
module_spacing = 3;

// Material
thickness = 3;

// Chassis outer dimensions
boxw = 40;
boxh = 54;
boxl = 70;

// Threaded rod (or machine screws) used for assembly
join_rod_r = 3 / 2;

// Target minimum size for finger joints
min_joint_width = 7;

// Offset of valve mount hole relative to box vertical center
hole_y_offset = 7;

// Lever dimensions
lever_length = 24;
lever_ratio = 3;
lever_width = 6;
lever_axis_rod_r = 3/2;

// Measurements of Danfoss RA radiator valve
RA_valve_radius = 22.8 / 2;
RA_valve_radius_outer = 20 / 2;
RA_valve_radius_dents_bottom = 21 / 2;
RA_valve_dents_width = 4.25;
RA_valve_dents_shape_r = 2.96;
RA_valve_dents_length = RA_valve_radius - RA_valve_radius_dents_bottom;
RA_valve_dents_center_pos = RA_valve_radius + RA_valve_dents_shape_r -
	RA_valve_dents_length;
RA_valve_back_to_tip = 32.6;

// Measurements of geared micro motor
motorw = 12;
motorh = 10;
motorl = 24.3;
motor_front_hole_r = 4/2;
motor_rear_hole_r = 5/2;
motor_wire_holes_r = 3/2;
motor_wire_holes_x_center_offset = 3.5;
motor_shaft_r = 2.9;


/*
 * Add finger joints to a side (or holes for inserting fingers into).
 * The shapes produced should be subtracted.
 */
module joints(side_length, vertical, gender, thickness=thickness,
			  min_joint_width=min_joint_width) {
	// Male joints will cut off the cornes, so the available length
	// for fingers is (in case of adjacent male joints)
	run_length = side_length - thickness * 2;

	// Distance from end (corner - thickness) to first finger, relative to
	// finger width
	end_space_scale = 0.8;

	calc_length = run_length - end_space_scale * 2 * min_joint_width;
	num = floor((calc_length / min_joint_width + 1) / 2);
	finger_width = run_length / (2 * num - 1 + 2 * end_space_scale);
	x_offset = -(num - 1) * finger_width;

	rotate(vertical ? 90 : 0) {
		difference() {
			if (gender == "male")
				square([side_length, thickness], true);
			for (n = [0 : num - 1]) {
				translate([x_offset + n * finger_width * 2, 0]) {
					square([finger_width, thickness], true);
				}
			}
		}
	}
}

/*
 * Square with finger joints.
 */
module jointed_square(width, height, vert_gender, horiz_gender) {
	difference() {
		square([width, height], true);

		translate([0, (height - thickness) / 2])
			joints(width, false, horiz_gender);
		translate([0, -(height - thickness) / 2])
			joints(width, false, horiz_gender);
		translate([(width - thickness) / 2, 0])
			joints(height, true, vert_gender);
		translate([-(width - thickness) / 2, 0])
			joints(height, true, vert_gender);
	}
}

// Shape of RA type valve, center at [0,0]
module ra_valve_hole() {
	difference() {
		circle(r=RA_valve_radius, $fn=120);

		// Dents
		for (n = [0 : 11]) {
			translate([cos(n / 12 * 360) * RA_valve_dents_center_pos,
						  sin(n / 12 * 360) * RA_valve_dents_center_pos]
					   ) {
				circle(r=RA_valve_dents_shape_r, $fn=40);
			}
		}
	}
}

// Holes for joining the layers with a threaded rod
module join_holes() {
	num_holes = 4;
	center_dist = RA_valve_radius + 3 + join_rod_r;
	angle = 360 / num_holes / 2;

	for (n = [0 : num_holes - 1]) {
			translate([cos(n / num_holes * 360 + angle) * center_dist,
						  sin(n / num_holes * 360 + angle) * center_dist]
					   ) {
				circle(r=join_rod_r, $fn=40);
			}
	}
}

// Common shape of rear assembly layers
module rear_common(cut_vertical) {
	difference() {
		translate([0, -hole_y_offset]) {
			difference() {
				jointed_square(boxw, boxh, "male", "male");
				// Cut notches at vertical or horiz edges
				if (cut_vertical) {
					translate([-(boxw - thickness) / 2, 0])
						square([thickness, boxh], true);
					translate([(boxw - thickness) / 2, 0])
						square([thickness, boxh], true);
				} else {
					translate([0, (boxh - thickness) / 2])
						square([boxw, thickness], true);
					translate([0, -(boxh - thickness) / 2])
						square([boxw, thickness], true);
				}
			}
		}
		join_holes();
	}
}

module rear_asm_1_3() {
	difference() {
		rear_common(false);
		ra_valve_hole();
	}
}

module rear_asm_2() {
	difference() {
		rear_common(true);
		ra_valve_hole();
	}
}

module rear_asm_4() {
	difference() {
		rear_common(true);
		// Center hole
		circle(r=RA_valve_radius_outer);
		// Screw holes
		square([boxw, thickness], true);
	}
}

module rear_asm_5() {
	difference() {
		rear_common(false);
		// Center hole
		circle(r=RA_valve_radius_outer);
	}
}

module sides() {
	difference() {
		jointed_square(boxl, boxh, "female", "female");
		// Notches for rear assembly layers
		translate([-boxl / 2 + 2.5 * thickness, 0])
			joints(boxh, true, "female");
		translate([-boxl / 2 + 4.5 * thickness, 0])
			joints(boxh, true, "female");
		// Holes for lever axis rod
		translate([-boxl / 2 + RA_valve_back_to_tip,
					  hole_y_offset - lever_length / (lever_ratio + 1)])
			circle(r=lever_axis_rod_r, $fn=40);
	}
}

module top_bottom() {
	difference() {
		union() {
			jointed_square(boxl, boxw, "female", "male");
			// Undo left notches
			translate([-boxl / 2 + 0.5 * thickness, 0])
				square([thickness, boxw - 2 * thickness], true);
		}
		// Notches for rear assembly layers
		translate([-boxl / 2 + 1.5 * thickness, 0])
			joints(boxw, true, "female");
		translate([-boxl / 2 + 3.5 * thickness, 0])
			joints(boxw, true, "female");
	}
}

module front() {
	jointed_square(boxw, boxh, "male", "male");
}

module lever_sides() {
	difference() {
		union() {
			square([lever_width, lever_length], true);
			// Add rounded ends (extending length)
			translate([0, lever_length / 2])
				circle(d=lever_width, $fn=40);
			translate([0, -lever_length / 2])
				circle(d=lever_width, $fn=40);
		}
		// Hole for axis rod
		translate([0, lever_length * (lever_ratio / (lever_ratio + 1) - 1/2)])
			circle(r=lever_axis_rod_r, $fn=40);
		// Holes for join rods
		translate([0, lever_length / 2 - join_rod_r / 4])
			circle(r=join_rod_r, $fn=40);
		translate([0, - lever_length / 2 + lever_width / 2 + 3 * join_rod_r])
			circle(r=join_rod_r, $fn=40);
	}
}

module lever_middle() {
	difference() {
		lever_sides();
		translate([0, -lever_length / 2])
			square([lever_width, lever_width], true);
	}
}

// Helper for aligning modules
module row(x, y, width, module_spacing=module_spacing) {
	for (i = [0 : $children - 1]) {
		translate([x + (width + module_spacing) * i, y])
			children(i);
	}
}

// Render the modules
row(boxw / 2, boxh / 2 + hole_y_offset, boxw) {
	rear_asm_1_3();
	rear_asm_2();
	rear_asm_1_3();
	rear_asm_4();
	rear_asm_5();
}

row(boxl / 2, 1.5 * boxh + module_spacing, boxl) {
	sides();
	sides();
	top_bottom();
	top_bottom();
}

row(lever_width / 2, 2 * boxh + 2 * module_spacing + (lever_length + lever_width) / 2, lever_width) {
	lever_sides();
	lever_sides();
	lever_middle();
}

row(boxw / 2, 2 * boxh + 3 * module_spacing + (lever_length + lever_width) + boxh / 2, boxw) { 
	front();
}
